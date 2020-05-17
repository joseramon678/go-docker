PROJECT = "letsgo"

all: build run

build:
	docker build -t ${PROJECT} .

run:
	docker run -p 80:8080 -it ${PROJECT} 

publish:
	 docker push jrmanes/$(PROJECT):$(GIT_TAG)