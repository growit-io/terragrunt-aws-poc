package main

import (
    "fmt"
    "io/ioutil"
    "log"

    "gopkg.in/yaml.v2"
)

type terragruntLayerConfig struct {
    Layer string `yaml:"layer"`
}

func loadTerragruntLayerConfigFile(filename string) (*terragruntLayerConfig, error) {
    var c terragruntLayerConfig

    yamlData, err := ioutil.ReadFile(filename)
    if err != nil {
        return nil, fmt.Errorf("ioutil.ReadFile error: %v", err)
    }

    err = yaml.Unmarshal(yamlData, &c)
    if err != nil {
        return nil, fmt.Errorf("yaml.Unmarshal error: %v", err)
    }

    return &c, nil
}

func main() {
    layerConfig, err := loadTerragruntLayerConfigFile("terragrunt.yml")
    if err != nil {
        log.Fatalf("%v", err)
    }

    fmt.Println(layerConfig.Layer)
}
