# Full archive build from scratch takes ~6 hours
all: mirror extract prune permission compress symlink docker

wolfi-base:
	docker pull cgr.dev/chainguard/wolfi-base:latest

mirror: wolfi-base
	docker run --rm -it -v ${PWD}:/root/ cgr.dev/chainguard/wolfi-base:latest /root/wolfi-manpage-repo mirror

extract: wolfi-base
	docker run --rm -it -v ${PWD}:/root/ cgr.dev/chainguard/wolfi-base:latest /root/wolfi-manpage-repo extract

prune: wolfi-base
	docker run --rm -it -v ${PWD}:/root/ cgr.dev/chainguard/wolfi-base:latest /root/wolfi-manpage-repo prune
	mv -f manpages/deleted.index.gz .
	ls -halF deleted.index.gz
	zcat deleted.index.gz | wc -l

permission: wolfi-base
	docker run --rm -it -v ${PWD}:/root/ cgr.dev/chainguard/wolfi-base:latest /root/wolfi-manpage-repo permission

compress: wolfi-base
	docker run --rm -it -v ${PWD}:/root/ cgr.dev/chainguard/wolfi-base:latest /root/wolfi-manpage-repo compress

symlink: wolfi-base
	docker run --rm -it -v ${PWD}:/root/ cgr.dev/chainguard/wolfi-base:latest /root/wolfi-manpage-repo symlink

index: wolfi-base
	docker run --rm -it -v ${PWD}:/root/ cgr.dev/chainguard/wolfi-base:latest /root/wolfi-manpage-repo index
	mv -f manpages/manpages.index.gz .
	ls -halF manpages.index.gz
	zcat manpages.index.gz | wc -l

tarball: wolfi-base
	docker run --rm -it -v ${PWD}:/root/ cgr.dev/chainguard/wolfi-base:latest /root/wolfi-manpage-repo tarball
	mv -f manpages/manpages.tar.gz .
	ls -halF manpages.tar.gz
	tar -tf manpages.tar.gz | wc -l

docker: index tarball
	# Make a docker image with the manpage archives
	docker build . -t wolfi-manpage-repo

test:
	# Run a test docker container with the wolfi manpage repo
	docker run --rm -p 8080:8080 wolfi-manpage-repo

clean:
	# Delete the generated archives
	rm -rf archive/ manpages/ *gz .ash_history

purge: clean
	# Deletes the entire package mirror, which could take hours to reproduce
	rm -rf packages/

