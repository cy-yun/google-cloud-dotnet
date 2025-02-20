#!/bin/bash

set -e

cd $GENERATOR_OUTPUT_DIR/apis/Google.Cloud.Logging.V2

# Fix the gRPC generated code (for the grpc::Method instances) so it refers to the right server-side RPC
sed -i -E 's/"UpdateBucketLongRunning"/"UpdateBucketAsync"/g' Google.Cloud.Logging.V2/LoggingConfigGrpc.g.cs
sed -i -E 's/"CreateBucketLongRunning"/"CreateBucketAsync"/g' Google.Cloud.Logging.V2/LoggingConfigGrpc.g.cs
