DOCKERIMAGE := docker.dragonfly.co.nz/hadleyverse/stack

# Use docker if available
HASDOCKER ?= $(shell which docker-engine || which docker)
HADLEY := $(if $(HASDOCKER), docker run --net host -it --rm -u $$(id -u):$$(id -g) -v $$PWD:/work -w /work $(DOCKERIMAGE) ,) 

all: index.html

# Simple html output
index.html: index.Rmd \
			besiege.csv \
			verdun.csv \
			csgo.csv \
			terraria.csv \
			ksp.csv

	${HADLEY} Rscript -e "rmarkdown::render('$<')"

besiege.csv: besiege_raw.file
	./read-file Besiege.x8+ < $< > $@

verdun.csv: verdun_raw.file
	./read-file Verdun.x8+ < $< > $@

csgo.csv: CSGO_raw.file
	./read-file csgo_linux+ < $< > $@

terraria.csv: terraria_raw.file
	./read-file Terraria.b+ < $< > $@

ksp.csv: ksp_raw.file
	./read-file KSP.x86 < $< > $@



## read-file reads _raw.file to produce a csv
read-file: read-file.hs
	stack ghc read-file.hs

