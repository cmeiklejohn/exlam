.PHONY: deps deploy package upload

deploy: delete-function package upload
	mix exlam.deploy -cli

package: deps
	mix exlam.package

upload:
	mix exlam.uf

init:
	mix exlam.init

deps:
	mix deps.get

# TODO: Make me a mix target.
delete-function:
	aws lambda delete-function --function-name exlam --profile exlam-deployer1; \
	exit 0