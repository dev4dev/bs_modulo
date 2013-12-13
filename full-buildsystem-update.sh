#!/usr/bin/env bash

rake xcode:switch[v5]
./update.sh
rake xcode:switch[v4]
