all: docker

tarball: clean
	docker pull cgr.dev/chainguard/wolfi-base:latest
	docker run --rm -it -v ${PWD}:/root/ cgr.dev/chainguard/wolfi-base:latest /root/create-archive

docker: tarball
	docker build . -t manpage-repo

clean:
	rm -f manpages/ *gz

