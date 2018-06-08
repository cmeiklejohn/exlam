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

clean: 
	rm -rf deps

# TODO: Make me a mix target.
delete-function:
	aws lambda delete-function --region us-east-1 --function-name exlam --profile exlam-deployer1; \
	exit 0

invoke:
	aws lambda invoke --invocation-type Event --function-name exlam --region us-east-1 --log-type=Tail --payload '{ "cmd": "hget" }' --profile=exlam-deployer1 outputfile.txt
	exit 0
