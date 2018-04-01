#!/bin/bash
set -evx

mkdir ~/.Xchangecore

# safety check
if [ ! -f ~/.Xchangecore/.Xchange.conf ]; then
  cp share/Xchange.conf.example ~/.Xchangecore/Xchange.conf
fi
