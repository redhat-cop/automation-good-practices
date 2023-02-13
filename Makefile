# be sure to have the following RPMs installed on Fedora Linux
#
# okular
# asciidoctor-pdf
# rubygem-rugged
# hunspell
# hunspell-en-GB
# rubygem-ffi ?
# rubygem-json ?

ADOCPDF = asciidoctor-pdf --attribute=gitdate=$(shell git log -1 --date=short --pretty=format:%cd) --attribute=githash=$(shell git rev-parse --verify HEAD) --failure-level=warn
ADOCHTML = asciidoctor -a toc=left --attribute=gitdate=$(shell git log -1 --date=short --pretty=format:%cd) --attribute=githash=$(shell git rev-parse --verify HEAD) --failure-level=warn
ACROREAD = okular
VCS = git
INFILE = README.adoc
INFILE2 = CONTRIBUTE.adoc
OUTFILE = Good_Practices_for_Ansible
OUTFILE2 = Contributing-to-GPA
PRINT = lpr
SPELL = hunspell
SPELLOPTS = -d en_GB

all: $(OUTFILE)

$(OUTFILE): $(INFILE) *.adoc */*.adoc _images/* Makefile .git/index
	$(ADOCPDF) --out-file $(OUTFILE).pdf $(INFILE)
	$(ADOCPDF) --out-file $(OUTFILE2).pdf $(INFILE2)

view: viewpdf

print: $(OUTFILE)
	$(PRINT) $(OUTFILE).pdf

viewpdf: $(OUTFILE)
	$(ACROREAD) $(OUTFILE).pdf

clean:
	rm -f $(OUTFILE).pdf
	rm -f $(OUTFILE2).pdf
	rm -rf .AppleDouble

spell:
	$(SPELL) $(SPELLOPTS) *.adoc */*.adoc

commit: clean
	$(VCS) commit .

push: clean
	$(VCS) push

pull:
	$(VCS) pull

release:
	mkdir -p docs
	$(ADOCHTML) -D docs --out-file index.html $(INFILE)
	$(ADOCHTML) -D docs --out-file CONTRIBUTE.html $(INFILE2)
	mkdir -p docs/images
	cp -v images/*.svg docs/images

preview:
	mkdir -p docs
	$(ADOCPDF) --out-file docs/preview/$(OUTFILE).pdf $(INFILE)
	$(ADOCPDF) --out-file docs/preview/$(OUTFILE2).pdf $(INFILE2)
	$(ADOCHTML) --out-file docs/preview/$(OUTFILE).html $(INFILE)
	$(ADOCHTML) --out-file docs/preview/$(OUTFILE2).html $(INFILE2)
	mkdir -p docs/preview/images
	cp -v images/*.svg docs/preview/images
