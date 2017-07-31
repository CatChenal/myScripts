#!/bin/bash

mfe++ _CL-1A0466_001 1 1 > _CL-1A0466_001.mfe
awk '{print; if ($1=="SUM") {exit}}' _CL-1A0466_001.mfe > CL-1A0466_001.mfe.csv
mfe++ _CL-1B0466_001 1 1 > _CL-1B0466_001.mfe
awk '{print; if ($1=="SUM") {exit}}' _CL-1B0466_001.mfe > CL-1B0466_001.mfe.csv

mfe++ _CL-1A0467_001 1 1 > _CL-1A0467_001.mfe
awk '{print; if ($1=="SUM") {exit}}' _CL-1A0467_001.mfe > CL-1A0467_001.mfe.csv
mfe++ _CL-1B0467_001 1 1 > _CL-1B0467_001.mfe
awk '{print; if ($1=="SUM") {exit}}' _CL-1B0467_001.mfe > CL-1B0467_001.mfe.csv

mfe++ _CL-1A0468_001 1 1 > _CL-1A0468_001.mfe
awk '{print; if ($1=="SUM") {exit}}' _CL-1A0468_001.mfe > CL-1A0468_001.mfe.csv
mfe++ _CL-1B0468_001 1 1 > _CL-1B0468_001.mfe
awk '{print; if ($1=="SUM") {exit}}' _CL-1B0468_001.mfe > CL-1B0468_001.mfe.csv

