# The document base name which will be opened in preview by 'make open'
# Do not add the folder path as that is prepended with the value of TARGET_DIR.
DEFAULT_DOC = hello-world.pdf

# Directory location of image files
IMAGE_DIR = ./images
# Directory location of the markdown source files
SRC_DIR = ./src
# Working directory for xelatex auxilary and output files
WORK_DIR = ./.work
# Target directory for the pdf files produced
TARGET_DIR = ./target

# Syntax highlighting style for fenced code blocks
# To discover the set of values, use pandoc --list-highlight-styles
# Currently one of: pygments (the default), tango, espresso, zenburn, kate, monochrome, breezedark, haddock.
HIGHLIGHT_STYLE = kate

# List the set of target pdf files. These will be built using 'make all' and also with 'make pdf'.
# File names should be space-separated.
PDF_FILES = $(TARGET_DIR)/$(DEFAULT_DOC)

# search path
VPATH = ./:$(WORK_DIR):$(SRC_DIR)
vpath %.md $(SRC_DIR)
vpath %.tex $(WORK_DIR)
vpath %.pdf $(TARGET_DIR)

# find the images
FIGURES = $(shell find $(IMAGE_DIR) -type f \( -name '*.jpg' -printf '%h/%f ' \) , \( -name '*.png' -printf '%h/%f ' \) , \( -name '*.svg' -printf '%h/%f ' \))

# Custom metadata file for Pandoc. Set values for Pandoc metadata and variables in there. Metadata blocks in the markdown source can also be used.
# See https://pandoc.org/MANUAL.html#extension-yaml_metadata_block
PANDOC_METADATA = ./my-metadata.yaml

# Custom template file for Pandoc latex-format writer
# See https://pandoc.org/MANUAL.html#templates
# Use the pandoc command line option, --template=$(PANDOC_TEMPLATE)
#PANDOC_TEMPLATE = ./default.latex
#PANDOC_TEMPLATE = ./template.latex
#PANDOC_TEMPLATE = ./my-template.latex

# Default goal
default : $(TARGET_DIR)/$(DEFAULT_DOC)

.PHONY : default all pdf showvars open clean cleanlatexmk cleantex touch

open : $(TARGET_DIR)/$(DEFAULT_DOC)
	xdg-open $< &

all : pdf

pdf : $(PDF_FILES)

# Useful for debugging
showvars :
	@echo 'Default document:' $(DEFAULT_DOC)
	@echo 'PDF files:' $(PDF_FILES)
	@echo 'Figures:' $(FIGURES)
	@echo 'Source folder:' $(SRC_DIR)
	@echo 'Working folder:' $(WORK_DIR)
	@echo 'Target folder:' $(TARGET_DIR)
	@echo 'VPATH:' $(VPATH)
	@echo 'Pandoc metadata:' $(PANDOC_METADATA)
	@echo 'Syntax highlight style:' $(HIGHLIGHT_STYLE)

$(TARGET_DIR)/%.pdf : $(WORK_DIR)/%.pdf | $(TARGET_DIR)
	mv -v $< $@

$(WORK_DIR)/%.pdf : $(WORK_DIR)/%.tex
	latexmk -outdir=$(WORK_DIR) -pdfxe -pdfxelatex='xelatex -shell-escape %O %S' $<

$(WORK_DIR)/%.tex : %.md $(FIGURES) | $(WORK_DIR)
	pandoc --from=markdown+emoji --to=latex --metadata-file=$(PANDOC_METADATA) --highlight-style=$(HIGHLIGHT_STYLE) --standalone --output=$@ $<

$(TARGET_DIR)/%.html : %.md $(FIGURES) | $(TARGET_DIR)
	pandoc --from=markdown+emoji --to=html --metadata-file=$(PANDOC_METADATA) --highlight-style=$(HIGHLIGHT_STYLE) --standalone --output=$@ $<

$(WORK_DIR) :
	mkdir -v $@

$(TARGET_DIR) :
	mkdir -v $@

clean :
	@-rm -rfv $(TARGET_DIR)
	@-rm -rfv $(WORK_DIR)

cleanlatexmk :
	-latexmk -outdir=$(WORK_DIR) -C

cleantex :
	@-rm -v $(WORK_DIR)/*.tex

touch :
	-touch $(patsubst %.pdf,%.md,$(SRC_DIR)/$(DEFAULT_DOC))

