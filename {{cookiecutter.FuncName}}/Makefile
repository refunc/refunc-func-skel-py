ENDPOINT_URL	=	{{cookiecutter.RefuncAWSEndpoint}}
FUNC_NAME	=	{{cookiecutter.FuncName}}

.cache:
	mkdir .cache

dist: .cache src
	rm -rf dist && mkdir dist && cp -r src/* dist/ && cp requirements.txt dist/
	docker run --rm -v $(shell pwd):/var/task lambci/lambda:build-python3.7 pip install -r requirements.txt --cache-dir .cache --target dist

dist.zip: dist
	cd dist && zip -r9 ../dist.zip *

build: dist.zip

publish: delete build
	# create func
	aws --region us-east-1 --no-verify-ssl --no-sign-request --endpoint-url=$(ENDPOINT_URL) \
lambda create-function --function-name $(FUNC_NAME) --handler main.lambda_handler --zip-file fileb://dist.zip --runtime python3.7 --role arn:aws:iam::refunc:role/refunc

delete:
	# delete func
	aws --region us-east-1 --no-verify-ssl --no-sign-request --endpoint-url=$(ENDPOINT_URL) \
lambda delete-function --function-name $(FUNC_NAME)

test:
	aws --region us-east-1 --no-verify-ssl --no-sign-request --endpoint-url=$(ENDPOINT_URL) \
lambda invoke --function-name $(FUNC_NAME) /tmp/output.json && cat /tmp/output.json && rm /tmp/output.json


clean:
	rm -rf dist dist.zip