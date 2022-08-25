AWK ?= awk

# Show this help
help:
	@$(AWK) '/^#/{c=substr($$0,3);next}c&&/^[[:alpha:]][[:alnum:]_-]+:/{g=substr($$1,1,index($$1,":"));if (!a[g]++) h[i++]=g":"c}1{c=0}END{j=0;while (j < i) print h[j++]}' $(MAKEFILE_LIST) | column -s: -t

.PHONY: help
