#!/bin/bash

time curl http://some.nonexistent.hostname.example --connect-timeout 3 --max-time 5
