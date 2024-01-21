all: docker

tarball: clean
	docker pull cgr.dev/chainguard/wolfi-base:latest
	docker run --rm -it -v ${PWD}:/root/ cgr.dev/chainguard/wolfi-base:latest /root/create-archive
	mv -f manpages/*gz .

docker: tarball
	docker build . -t manpage-repo

clean:
	rm -rf manpages/ *gz .ash_history

