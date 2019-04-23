FUNC_NAME={{cookiecutter.FuncName}}

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
	@./hack/awslocal lambda create-function --function-name $(FUNC_NAME) --handler main.lambda_handler --zip-file fileb://dist.zip --runtime python3.7
	@rm dist.zip

delete:
	# delete func
	@./hack/awslocal lambda delete-function --function-name $(FUNC_NAME)

test:
	# test invoke func
	@./hack/awslocal lambda invoke --function-name $(FUNC_NAME) --payload $(shell python hack/payload.py) /tmp/output.json && cat /tmp/output.json && rm /tmp/output.json

clean:
	rm -rf dist dist.zip