all: docker

tarball:
	docker pull cgr.dev/chainguard/wolfi-base:latest
	docker run --rm -it -v ${PWD}:/root/ cgr.dev/chainguard/wolfi-base:latest /root/create-archive
	mv -f manpages/manpages.tar.gz .
	mv -f manpages/manpages.index.gz .

docker: tarball
	docker build . -t wolfi-manpage-repo

test: docker
	docker run --rm -p 8080:8080 wolfi-manpage-repo

clean:
	rm -rf manpages/ *gz .ash_history

