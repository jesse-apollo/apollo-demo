# Authors Service

This services knows about Science Fiction authors.

# Setup

 1. Add an Apollo `.env` file.
 2. Run `go build`

# Deploy to AppEngine

`make deploy`

# Run a Schema Check

 1. Edit the Makefile to specify your correct graph and variant.
 2. Run `make check`

# Push a Schema Change

 1. Edit the Makefile to specify your correct graph and variant.
 2. Run `make push`

# Regen Project after Schema Change

 1. Run `make regen`