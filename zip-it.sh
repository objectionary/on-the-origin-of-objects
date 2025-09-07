#!/usr/bin/env bash
# SPDX-FileCopyrightText: Copyright (c) 2024-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

set -e -o pipefail

REPO=objectionary/on-the-origin-of-objects

TLROOT=$(kpsewhich -var-value TEXMFDIST)

rm -rf package
mkdir package
cd package
cp ../paper.tex .
mkdir bibliography
cp ../bibliography/main.bib bibliography/main.bib
for p in ffcode to-be-determined href-ul eolang iexec; do
    cp "${TLROOT}/tex/latex/${p}/${p}.sty" .
done

version=$(curl --silent -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/${REPO}/releases/latest" | jq -r '.tag_name')
echo "Version is: ${version}"
gsed -i "s|0\.0\.0|${version}|g" paper.tex
gsed -i "s|REPOSITORY|${REPO}|g" paper.tex
eo_version=$(curl --silent -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/objectionary/eo/releases/latest" | jq -r '.tag_name')
echo "EO version is: ${eo_version}"
gsed -i "s|9\.9\.9|${eo_version}|g" paper.tex
pdflatex -interaction=errorstopmode -halt-on-error -shell-escape paper.tex
bibtex paper
pdflatex -interaction=errorstopmode -halt-on-error paper.tex > /dev/null
pdflatex -interaction=errorstopmode -halt-on-error paper.tex > /dev/null
rm -rf ./*.aux ./*.bcf ./*.blg ./*.fdb_latexmk ./*.fls ./*.log ./*.run.xml ./*.out ./*.exc ./*.pdf
rm -rf ./bibliography
rm -rf ./iexec.ret
zip -x paper.pdf -r "paper-${version}.zip" ./*
mv "paper-${version}.zip" ..
cd ..
