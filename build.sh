#!/bin/bash

set -ex

make

cp index.html  /output/
cp index.html  /publish/

