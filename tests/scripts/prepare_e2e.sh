#!/usr/bin/env bash

./cloudmapper.py collect --config tests/mock/config_e2e.json
./cloudmapper.py prepare --config tests/mock/config_e2e.json
