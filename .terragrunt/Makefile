TARGET = $(CURDIR)/libexec/tg
SOURCE = main.go

.PHONY: all
all: build

.PHONY: build
build: $(TARGET)

.PHONY: clean
clean:
	rm -f $(TARGET)
	rmdir $$(dirname $(TARGET)) 2>/dev/null || true

$(TARGET): $(SOURCE)
	GOBIN=$$(dirname $@) go install
