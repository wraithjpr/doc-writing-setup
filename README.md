---
title: How I Write My Documents
subtitle: From markdown to PDF, HTML, .odt or .docx using Vim and Pandoc
thanks: Inspired by Vladimir Keleshev's blog post about his book writing setup at [keleshev.com/my-book-writing-setup](https://keleshev.com/my-book-writing-setup/)
author: James Wraith
date: May 2020
...

_Tooling and workflow to create written materials using Vim and Pandoc in a Linux desktop environment._

I prefer using keyboard-centric tools from the command line rather than GUI-based word processing apps; WYSIWYM vs WYSIWYG[^1]. I want to write content once using a text editor and markdown, then automatically create the finished material targetted at the Cloud, the Web and old school word processing as necessary. I prefer to publish as a PDF rather than MS-Word documents and view as HTML in my browser too.\
This article covers tooling and workflow to achieve that efficiently. I use it from a Linux desktop.

[^1]: What You See Is What You _Mean_ vs What You See Is What You _Get_

---

## Approach

1. Use Neovim to edit `.md` files in Markdown format; convert them to `.pdf` files using Pandoc; and view them easily on my Linux desktop using the pdf viewer, in my case Evince on Fedora.\
   Pandoc can also convert to `.html` for viewing in a browser.
1. The workflow is be easily automated using Make by means of a simple makefile, named `Makefile`.
1. The Pandoc pdf engine is `xelatex`. I use the default Latex template configured with my own local metadata file.

## Install

1. Clone this repo to your local machine.

## Usage

1. Copy the contents to your local folder where you are working on your documents. I edit in markdown format and publish pdf files that are built with `make.`

1. Use `./src/hello-world` as an example for your own markdown file. I use Neovim as my text editor. The makefile assumes that your markdown source files are either in your folder or in the `./src` sub-folder. Put any images used in image links into the `./images` sub-folder.

1. I often use a title, author and date at the top of my documents. Sometimes I also add a sub-title, abstract, keywords, subject and thanks. This is easily achieved using a metadata block at the top of the markdown file. The `./src/hello-world.md` file has an example for you to follow.

1. I use a config file, `my-metadata.yaml`, to configure Pandoc's markdown reader. Here, I configure page size and geometry, and fonts. See the `TEMPLATES` section in `man pandoc` for the set of metadata variables available.\
   I am usually happy with the article document class, A4 portrait paper, and the DejaVu font family.

1. As it is, the makefile uses Pandoc's default template for it's Latex writer. That is installed, on my machine, at `/usr/share/pandoc-2.7.3/data/templates/default.latex` \
   * You may put this out to the local folder:\
     `$ pandoc --output=my-template.latex --print-default-template=latex`
   * Customise it and then adjust the makefile to use it for the build:\
     `PANDOC_TEMPLATE = ./my-template.latex` \
     ... \
     `pandoc --from=markdown+emoji --to=latex ... --template=$(PANDOC_TEMPLATE) ...`

     I usually find that the default template suites my needs and do not often need to use a customised template.

1. At the top of the makefile there are variables available to conveniently set:
   * The name of the default pdf file to build, `DEFAULT_DOC`;
   * The set of target pdf files built by `make all`, `PDF_FILES`;
   * The sub-folders used: `IMAGE_DIR`, `SRC_DIR`, `WORK_DIR`, `TARGET_DIR`;
   * The style used for syntax highlighting in fenced code blocks, `HIGHLIGHT_STYLE`.

   Adjust these as required. You are likely to want to change the default pdf file name from `hello-world.pdf` to your file name.

## Workflow

### Set up

1. Adjust the makefile, setting the values of the variables as required. I always set the name of my default pdf file, `DEFAULT_DOC`; rarely is it `hello-world.pdf`. I sometimes add other file names to `PDF_FILES`.\
   `$ nvim ./Makefile`

   For example, edit the file so that:\
   `DEFAULT_DOC = my-doc.pdf` \
   `PDF_FILES = $(TARGET_DIR)/my-other-doc.pdf $(TARGET_DIR)/$(DEFAULT_DOC)`

1. Adjust the metadata variables in the Pandoc config file, `my-metadata.yaml`, as required. This is useful for page layout and fonts.\
   `$ nvim ./my-metadata.yaml`

### Creating PDF documents

1. Edit markdown source files:\
   `$ nvim ./src/my-doc.md ./src/my-other-doc.md`

1. Copy any image files referred to in your markdown into the `./images` folder. For example:\
   `$ cp -v ~/Downloads/my-picture.jpg ./images/`

1. Generate the default pdf document only. This is put in `TARGET_DIR`, that is `./target` by default.\
   `$ make`

   Expect `./target/my-doc.pdf` to be available.

1. Generate all of the pdf documents.\
   `$ make all` \

   Expect two pdf files:\
   `./target/my-doc.pdf`; and\
   `./target/my-other-doc.pdf`

1. Generate a specific pdf document:\
   `$ make ./target/my-other-doc.pdf`

   Expect `./target/my-other-doc.pdf` to be available.

1. View a pdf document:\
   `$ xdg-open ./target/my-other-doc.pdf &`

1. For convenience, the default pdf document may be viewed via `make` and it will be re-built, as necessary, when the markdown source file is newer than the pdf file:\
   `$ make open`

### Housekeeping

1. Clean, i.e. remove, all target pdf documents, and Pandoc and Latex work files:\
   `$ make clean`

1. Clean just the Latex work files. This invokes `latexmk -C`.\
   `$ make cleanlatexmk`

## Tooling

**Neovim** for editing markdown format text files. [neovim.io](https://neovim.io/)

**Pandoc** for generating pdf and html documents from the markdown source files. [pandoc.org](https://pandoc.org/)

**Make** for automating the build workflow. [www.gnu.org/software/make](https://www.gnu.org/software/make/)

## References

The Linux Pandoc manual at `$ man pandoc`.

The Pandoc User's Guide at [pandoc.org/MANUAL.html](https://pandoc.org/MANUAL.html "Pandoc User's Guide") including a section covering [Pandoc's flavour of markdown](https://pandoc.org/MANUAL.html#pandocs-markdown "Pandoc's Markdown").

Wikibooks LaTeX Guide at [en.wikibooks.org/wiki/LaTeX](https://en.wikibooks.org/wiki/LaTeX "Guide to LaTeX on Wikibooks").

Overleaf has a good guide to LaTeX at [www.overleaf.com/learn](https://www.overleaf.com/learn "Overleaf knowledge base").

Gnu Make manual at [www.gnu.org/software/make/manual](https://www.gnu.org/software/make/manual/ "GNU Make Manual").

---

