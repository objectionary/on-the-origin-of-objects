# SPDX-FileCopyrightText: Copyright (c) 2020-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

.SHELLFLAGS = -e -x -c
.ONESHELL:
SHELL=bash

zip: *.tex
	./zip-it.sh

clean:
	git clean -dfX
