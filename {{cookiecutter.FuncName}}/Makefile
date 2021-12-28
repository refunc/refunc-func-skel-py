FUNC_NAME={{cookiecutter.FuncName}}
HANDLER=main.lambda_handler
RUNTIME=python3.7
TIMEOUT=120
AWSLOCAL=./hack/awslocal

.cache:
	mkdir -p .cache

dist: .cache clean
	mkdir -p dist && cp -r src/* dist/ && cp requirements.txt dist/
	docker run --rm -u $(shell id -u):$(shell id -g) -v $(shell pwd)/dist:/var/task/dist -v $(shell pwd)/.cache:/cache lambci/lambda:build-python3.7 \
	pip install -r dist/requirements.txt --cache-dir /cache --target dist

dist.zip: dist
	cd dist && zip -r9 ../dist.zip *

build: dist.zip

create: build
	# create func
	@$(AWSLOCAL) lambda create-function --function-name $(FUNC_NAME) --handler $(HANDLER) --zip-file fileb://dist.zip --runtime $(RUNTIME) --timeout $(TIMEOUT)

get:
	# get func
	@$(AWSLOCAL) lambda get-function --function-name $(FUNC_NAME)

update-code: build
	# update func code
	@$(AWSLOCAL) lambda update-function-code --function-name $(FUNC_NAME) --zip-file fileb://dist.zip

update-config:
	# update func config
	@$(AWSLOCAL) lambda update-function-configuration --function-name $(FUNC_NAME) --handler $(HANDLER) --runtime $(RUNTIME) --timeout $(TIMEOUT)

delete:
	# delete func
	@$(AWSLOCAL) lambda delete-function --function-name $(FUNC_NAME)

test:
	# test invoke func
	@$(AWSLOCAL) lambda invoke --cli-binary-format raw-in-base64-out --function-name $(FUNC_NAME) --payload $(shell python hack/payload.py) /dev/stdout

clean:
	rm -rf dist dist.zip