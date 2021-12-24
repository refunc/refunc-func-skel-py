FUNC_NAME={{cookiecutter.FuncName}}
REGION={{cookiecutter.Region}}
HANDLER=main.lambda_handler
RUNTIME=python3.7
TIMEOUT=120

.cache:
	mkdir .cache

dist: .cache clean
	mkdir dist && cp -r src/* dist/ && cp requirements.txt dist/
	docker run --rm -v $(shell pwd):/var/task lambci/lambda:build-python3.7 pip install -r requirements.txt --cache-dir .cache --target dist

dist.zip: dist
	cd dist && zip -r9 ../dist.zip *

build: dist.zip

create: build
	# create func
	@awslocal lambda create-function --region $(REGION) --function-name $(FUNC_NAME) --handler $(HANDLER) --zip-file fileb://dist.zip --runtime $(RUNTIME) --timeout $(TIMEOUT)

get: create
	# get func
	@awslocal lambda get-function --region $(REGION) --function-name $(FUNC_NAME) --region $(REGION)

update-code: build
	# update func code
	@awslocal lambda update-function-code --region $(REGION) --function-name $(FUNC_NAME) --zip-file fileb://dist.zip

update-config:
	# update func config
	@awslocal lambda update-function-configuration --region $(REGION) --function-name $(FUNC_NAME) --handler $(HANDLER) --runtime $(RUNTIME) --timeout $(TIMEOUT)

delete:
	# delete func
	@awslocal lambda delete-function --region $(REGION) --function-name $(FUNC_NAME)

test:
	# test invoke func
	@awslocal lambda invoke --region $(REGION) --cli-binary-format raw-in-base64-out --function-name $(FUNC_NAME) --payload $(shell python hack/payload.py) /dev/stdout

clean:
	rm -rf dist dist.zip