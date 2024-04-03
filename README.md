# logpaste-fly.io

[![CircleCI](https://circleci.com/gh/tiny-pilot/logpaste-fly.io.svg?style=svg)](https://circleci.com/gh/tiny-pilot/logpaste-fly.io)
[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](LICENSE)

## Overview

This repo controls deployments to TinyPilot's LogPaste instance on Fly.io.

## Purpose

TinyPilot uses LogPaste to accept debug logs from TinyPilot users.

## Updating LogPaste versions

To update to a new version of LogPaste, create a PR that updates the version of the `build.image` property within the `fly.toml` file.

When the PR is merged, CircleCI will automatically deploy the new version of LogPaste. TinyPilot's logs will persist due to the persistent volume (specified in the `mounts` property of `fly.toml`) and will continue being replicated to cloud storage buckets via Litestream.
