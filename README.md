# Wolfi Manpage Repository

This project generates a repository of all of the manpage documentation in Wolfi.

Run `make` to do both of the following:

Run `make tarball` to generate a zipped tarball, `manpages.tar.gz`, containing a directory structure of all of /usr/share/man from every package in Wolfi (this takes about ~10 minutes, and could be made even more efficient)

Run `make docker` to create a docker image that can serve all of those manpages as a web host
 
