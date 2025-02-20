#!/bin/bash

set -e

cd $GENERATOR_OUTPUT_DIR/apis/Google.Cloud.DevTools.ContainerAnalysis.V1

# Add the Grafeas.V1 surface to the metadata so that
# the REST transport will work. This API is *very* unusual
# in terms of having something "mixin-like" which isn't
# one of the standard mixins.
sed -i -E '/yield return ContaineranalysisReflection\.Descriptor;/a\
            yield return global::Grafeas.V1.GrafeasReflection.Descriptor;' \
    Google.Cloud.DevTools.ContainerAnalysis.V1/PackageApiMetadata.g.cs
