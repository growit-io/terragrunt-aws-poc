#!/usr/bin/env python3

import fnmatch
import glob
import os
import re
import sys
import yaml

from contextlib import contextmanager
from pathlib import Path
from subprocess import check_call, check_output

if 'TERRAGRUNT' in os.environ:
    TERRAGRUNT = os.environ['TERRAGRUNT']
else:
    TERRAGRUNT = 'terragrunt'

TERRAGRUNT_LAYER_FILENAME = 'terragrunt.yml'
TERRAGRUNT_CONFIG_FILENAME = 'terragrunt.hcl'


@contextmanager
def cwd(path):
    owd = os.getcwd()
    try:
        os.chdir(path)
        yield
    finally:
        os.chdir(owd)


def load_layers():
    global TERRAGRUNT_CONFIG_FILENAME

    config_pattern = f'**/{TERRAGRUNT_CONFIG_FILENAME}'
    config_files = glob.glob(config_pattern, recursive=True)

    root_layer = load_layer(os.getcwd())

    for config_file in config_files:
        parent_layer = root_layer
        layer_path = Path()

        for part in Path(config_file).parts[0:-1]:
            layer_path = layer_path.joinpath(part)

            if part in parent_layer['children']:
                layer = parent_layer['children'][part]
            else:
                layer = load_layer(layer_path, parent_layer)
                parent_layer['children'][part] = layer

            parent_layer = layer

    return root_layer


def load_layer(layer_path, parent=None):
    node = {
        'path': str(layer_path),
        'config': load_layer_config(layer_path),
        'inputs': {},
        'children': {}
    }

    if parent and 'inputs' in parent:
        node['inputs'] = {**parent['inputs']}

    if parent and 'layer' in parent['config']:
        node['inputs'][parent['config']['layer']] = Path(layer_path).parts[-1]

    return node


def load_layer_config(layer_path):
    global TERRAGRUNT_LAYER_FILENAME

    layer_file = Path(layer_path).joinpath(TERRAGRUNT_LAYER_FILENAME)

    if not os.path.isfile(layer_file):
        return {}

    with open(layer_file, 'r') as stream:
        return yaml.safe_load(stream)


def get_config_paths(layer, selectors):
    if layer_is_selected(layer, selectors):
        return [layer['path']]

    config_paths = []

    for child in layer['children'].values():
        config_paths += get_config_paths(child, selectors)

    return config_paths


def layer_is_selected(layer, selectors):
    for key, value in selectors.items():
        if key not in layer['inputs']:
            return False

        match = False

        for v in value.replace(',', ' ').split():
            if fnmatch.fnmatch(layer['inputs'][key], v):
                match = True
                break

        if not match:
            return False

    return True


def load_layer_selectors(root_layer):
    valid_selectors = valid_layer_selectors(root_layer)
    selectors = {}

    for key in os.environ.keys():
        if key in valid_selectors:
            selectors[key] = os.environ[key]

    return selectors


def valid_layer_selectors(root_layer):
    valid_selectors = set(root_layer['inputs'].keys())

    for layer in root_layer['children'].values():
        valid_selectors |= valid_layer_selectors(layer)

    return valid_selectors


def terragrunt_run_all(*args):
    terragrunt('run-all', *args)


def terragrunt(*args):
    global TERRAGRUNT

    check_call([TERRAGRUNT] + list(args))


def main(*args):
    # TODO: find the parent terragrunt.hcl and enter into its directory
    root_layer = load_layers()
    selectors = load_layer_selectors(root_layer)

    for config_path in get_config_paths(root_layer, selectors):
        print(config_path)
        # with cwd(config_path):
        #     if os.path.isfile('#{config_path}/terragrunt.hcl'):
        #         terragrunt(*args)
        #     else:
        #         terragrunt_run_all(*args)

    return 0


exit(main(*sys.argv[1:]))
