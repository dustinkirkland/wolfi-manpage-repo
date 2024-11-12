UID = $(shell id -u)
GID = $(shell id -g)
DOCKER_CMD := docker run --rm -v ${PWD}:/root/ cgr.dev/chainguard/wolfi-base:latest /root/wolfi-manpage-repo -o ${UID}:${GID}

# Full archive build from scratch takes ~6 hours
all: mirror extract prune permission compress symlink tarball docker

wolfi-base:
	docker pull cgr.dev/chainguard/wolfi-base:latest

mirror: wolfi-base
	${DOCKER_CMD} mirror

packages: wolfi-base
	${DOCKER_CMD} packages

files: packages
	${DOCKER_CMD} files

extract: wolfi-base
	${DOCKER_CMD} extract

prune: wolfi-base
	${DOCKER_CMD} prune
	mv -f manpages/deleted.index.gz .
	ls -halF deleted.index.gz
	zcat deleted.index.gz | wc -l

permission: wolfi-base
	${DOCKER_CMD} permission

compress: wolfi-base
	${DOCKER_CMD} compress

symlink: wolfi-base
	${DOCKER_CMD} symlink

tarball: wolfi-base
	${DOCKER_CMD} tarball
	mv -f manpages/manpages.tar.gz .
	ls -halF manpages.tar.gz
	tar -tf manpages.tar.gz | wc -l
	mv -f manpages/manpages.index.gz .
	ls -halF manpages.index.gz
	zcat manpages.index.gz | wc -l

docker: tarball
	# Make a docker image with the manpage archives
	docker build . -t wolfi-manpage-repo

test:
	# Run a test docker container with the wolfi manpage repo
	docker run --rm -p 8080:8080 wolfi-manpage-repo

clean:
	# Delete the generated archives
	rm -rf manpages/ *gz .ash_history

purge: clean
	# Deletes the entire package mirror, which could take hours to reproduce
	rm -rf packages/

