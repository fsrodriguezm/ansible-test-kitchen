list:
	docker run -it -v $(pwd):/work -v ~/.aws:/work/.aws test-kitchen kitchen list

create:
	docker run -it -v $(shell pwd):/work -v ~/.aws:/root/.aws test-kitchen kitchen create

converge:
	docker run -it -v $(shell pwd):/work -v ~/.aws:/root/.aws test-kitchen kitchen converge

destroy:
	docker run -it -v $(shell pwd):/work -v ~/.aws:/root/.aws test-kitchen kitchen destroy

login:
	docker run -it -v $(shell pwd):/work -v ~/.aws:/root/.aws test-kitchen kitchen login

exec:
	docker run -it -v $(shell pwd):/work -v ~/.aws:/work/.aws test-kitchen bash