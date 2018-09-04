#!/bin/sh
set -e


mvn clean -U package -P $env_config -Dmaven.test.skip=true -Denv_config=$env_config

