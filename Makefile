run: build
	docker run -it --rm plicease/atn

build:
	docker build . -t plicease/atn

push: build
	docker push plicease/atn
