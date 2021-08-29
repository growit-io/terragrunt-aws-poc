decrypt-access-key:
ifeq ($(strip $(key)),)
	@echo 'Usage: $@ key=<name>' >&2
	@exit 2
else
	@encrypted_access_keys="$$(terragrunt output -json | jq -r .encrypted_access_keys.value)"; \
	access_key="$$(jq -r ".[\"$(key)\"]" <<<"$$encrypted_access_keys")"; \
	encrypted_secret="$$(jq -r '.["encrypted_secret"]' <<<"$$access_key")"; \
	secret="$$(base64 -d <<<"$$encrypted_secret" | gpg -d)"; \
	printf 'id: %s\nsecret: ' "$$(jq -r '.["id"]' <<<"$$access_key")"; \
	cat <<<"$$secret"
endif
