#!/bin/bash

# Edited from -e to -ex to get detailed output of the run
set -ex

source toolversions.sh
declare -r CORE_PROTOS_ROOT=$PROTOBUF_TOOLS_ROOT/tools

# This script generates all APIs from the googleapis/googleapis github repository,
# using the code generator from googleapis/gapic-generator-csharp.
# It will fetch both repositories if necessary.

if [[ "$GOOGLEAPIS_DIR" != "" ]]
then
  declare -r GOOGLEAPIS="$GOOGLEAPIS_DIR"
else
  declare -r GOOGLEAPIS="$PWD/googleapis"
fi

if [[ "$GENERATOR_OUTPUT" != "" ]]
then
  declare -r GENERATOR_OUTPUT_DIR="$GENERATOR_OUTPUT"
else
  declare -r GENERATOR_OUTPUT_DIR="$PWD"
fi

if [[ "$GENERATOR_INPUT" != "" ]]
then
  declare -r GENERATOR_INPUT_DIR="$GENERATOR_INPUT"
else
  declare -r GENERATOR_INPUT_DIR="$PWD/generator-input"
fi

fetch_github_repos() {
  # We assume that if the directory has been explicitly specified, we don't need
  # to fetch it.
  if [[ "$GOOGLEAPIS_DIR" != "" ]]
  then
    return 0
  fi

  if [ -d "$GOOGLEAPIS" ]
  then
    git -C $GOOGLEAPIS pull -q
  else
    git clone https://github.com/googleapis/googleapis $GOOGLEAPIS
  fi
}

# Entry point

echo "Preparing tools"

install_protoc
install_microgenerator
install_grpc
fetch_github_repos

# Allow other processes to know where to find repos, binaries etc.
export GOOGLEAPIS
export GRPC_PLUGIN
export PROTOBUF_TOOLS_ROOT
export GAPIC_PLUGIN
export PROTOC
export GENERATOR_OUTPUT_DIR
export GENERATOR_INPUT_DIR

dotnet run --project tools/Google.Cloud.Tools.ReleaseManager -- generate-apis $*
