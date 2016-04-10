#!/bin/bash

swish-e -S prog -c vulgate.index.conf
swish-e -S prog -c incipits.index.conf
swish-e -S prog -c mss.index.conf
rm full.index
swish-e -M vulgate.index incipits.index mss.index full.index