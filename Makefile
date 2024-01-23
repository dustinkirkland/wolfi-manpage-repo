# Full archive build from scratch takes ~6 hours
all: docker

tarball:
	docker pull cgr.dev/chainguard/wolfi-base:latest
	docker run --rm -it -v ${PWD}:/root/ cgr.dev/chainguard/wolfi-base:latest /root/create-archive
	mv -f manpages/manpages.tar.gz . || true
	mv -f manpages/manpages.index.gz . || true

docker: tarball
	docker build . -t wolfi-manpage-repo

test: docker
	docker run --rm -p 8080:8080 wolfi-manpage-repo

clean:
	rm -rf archive/ manpages/ *gz .ash_history

all_clean: clean
	rm -rf packages/

