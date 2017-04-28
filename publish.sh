#!/bin/bash

version=`cat Version`

gcloud docker -- push gcr.io/levental-io/blog:$version
kubectl set image deployments/blog blog=gcr.io/levental-io/blog:$version
