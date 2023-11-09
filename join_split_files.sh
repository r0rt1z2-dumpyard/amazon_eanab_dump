#!/bin/bash

cat system/sqfs/container.sqfs.* 2>/dev/null >> system/sqfs/container.sqfs
rm -f system/sqfs/container.sqfs.* 2>/dev/null
