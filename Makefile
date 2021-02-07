list:
	docker run -t -v $(pwd):/work -v ~/.aws:/work/.aws surfersamu/test-kitchen kitchen list

create:
	docker run -it -v $(shell pwd):/work -v ~/.aws:/root/.aws surfersamu/test-kitchen kitchen create

converge:
	docker run -it -v $(shell pwd):/work -v ~/.aws:/root/.aws surfersamu/test-kitchen kitchen converge

destroy:
	docker run -it -v $(shell pwd):/work -v ~/.aws:/root/.aws surfersamu/test-kitchen kitchen destroy

login:
	docker run -it -v $(shell pwd):/work -v ~/.aws:/root/.aws surfersamu/test-kitchen kitchen login

exec:
	docker run -it -v $(shell pwd):/work -v ~/.aws:/work/.aws surfersamu/test-kitchen bash
