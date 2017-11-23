.PHONY: deps deploy package upload

deploy: package upload
	mix exlam.deploy -cli

package: deps
	mix exlam.package

upload:
	mix exlam.uf

deps:
	mix deps.get
