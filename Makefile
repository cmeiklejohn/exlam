.PHONY: deps deploy package upload

deps:
	mix deps.get

deploy: package upload
	mix exlam.deploy -cli

package: deps
	mix exlam.package

upload:
	mix exlam.uf
