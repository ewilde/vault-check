GOFMT_FILES?=$$(find . -name '*.go' |grep -v vendor)

default: lint build test testacc

test: goimportscheck

build: goimportscheck
	@find ./cmd/* -maxdepth 1 -type d -exec go install "{}" \;

release:
	go get github.com/goreleaser/goreleaser; \
	goreleaser; \

clean:
	rm -rf pkg/

goimports:
	goimports -w $(GOFMT_FILES)

goimportscheck:
	@sh -c "'$(CURDIR)/scripts/goimportscheck.sh'"

vet:
	@echo "go vet ."
	@go vet $$(go list ./... | grep -v vendor/) ; if [ $$? -eq 1 ]; then \
		echo ""; \
		echo "Vet found suspicious constructs. Please check the reported constructs"; \
		echo "and fix them if necessary before submitting the code for review."; \
		exit 1; \
	fi

lint:
	@echo "go lint ."
	@golint $$(go list ./... | grep -v vendor/) ; if [ $$? -eq 1 ]; then \
		echo ""; \
		echo "Lint found errors in the source code. Please check the reported errors"; \
		echo "and fix them if necessary before submitting the code for review."; \
		exit 1; \
	fi

.PHONY: build test testacc vet goimports goimportscheck errcheck vendor-status test-compile lint
