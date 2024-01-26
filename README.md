# Wolfi Manpage Repository

This project generates a repository of all of the manpage documentation in Wolfi.

 - Running `make` will run, in sequence each of the targets (any of which could be run independently):
    - `make mirror` - will create a mirror of all current Wolfi apk packages (x86_64 only); takes ~5 hours and 36GB of disk
    - `make extract` - requires a local mirror (see: `make mirror`), will examine and extract `/usr/share/man` from every package; takes ~22 minutes and 260MB of disk
    - `make permission` - will fix permissions (755 directories, 644 files), and update file ownership corrupted by docker
    - `make prune` - will prune non-manpages from `/usr/share/man`; there seems to be a lot of htm, html, jpeg, gif, pdf, and other files installed in `/usr/share/man`
    - `make compress` - will `gzip -9` compress each and every file in our extracted `/usr/share/man` directory
    - `make symlink` - once we `gzip` a bunch of files, we now break a bunch of symlinks, so this target updates those accordingly (and then removes any remaining dead links)
    - `make tarball` - ultimately, we generate a compressed tarball of all of our extracted manpages
    - `make docker` - will create a docker image that includes our generated tarball, plus a simple `lighttpd` configuration for serving a directory for browsing those manpages
 - Running `make test` will start a local docker container, with our wolfi-manpage-repo served on https://localhost:8080
 - You can try this out, using the included `man` script, by setting the `REPO` environment variable, and then trying to read manpages such as:
    - `REPO="http://localhost:8080" ./man grep
    - `REPO="http://localhost:8080" ./man pgrep
    - `REPO="http://localhost:8080" ./man awk
    - `REPO="http://localhost:8080" ./man gawk
    - `REPO="http://localhost:8080" ./man open

Some to-do's and optimizations:
 - The package mirroring could / should be optimized
 - The whole thing could be event based and tied back into the actual melange build processes
 - We could get rid of -doc packages entirely, maybe?
 - The web directory browsing could come straight out of GCS or the gzip file itself
 - We should have a man page for this man command itself
 - We should stand up a real backend service at man.cgr.dev or similar domain
 - We should move the real binary at /usr/bin/man (from man-db package) to /usr/lib/man/man and ship our wrapper script in itsl place
 - We could improve the lightweight caching that we have here
 - ...probably a hundred other things
