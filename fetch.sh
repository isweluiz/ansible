#!/bin/bash

ansible multi -s -m fetch -a "src=/etc/hosts dest=/tmp"
