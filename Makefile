# be sure to have the following RPMs installed on Fedora Linux
#
# okular
# asciidoctor-pdf
# rubygem-rugged
# hunspell
# hunspell-en-GB
# rubygem-ffi ?
# rubygem-json ?

ADOCPDF = asciidoctor-pdf --attribute=gitdate=$(shell git log -1 --date=short --pretty=format:%cd) --attribute=githash=$(shell git rev-parse --verify HEAD)
ADOCHTML = asciidoctor --attribute=gitdate=$(shell git log -1 --date=short --pretty=format:%cd) --attribute=githash=$(shell git rev-parse --verify HEAD)
ACROREAD = okular
VCS = git
INFILE = README.adoc
INFILE2 = CONTRIBUTE.adoc
OUTFILE = Good_Practices_for_Ansible.pdf
OUTFILE2 = Contributing-to-GPA.pdf
PRINT = lpr
SPELL = hunspell
SPELLOPTS = -d en_GB


all: $(OUTFILE) html_$(OUTFILE)

pdf: $(OUTFILE)

$(OUTFILE):
	$(ADOCPDF) --out-file $(OUTFILE) $(INFILE)
	$(ADOCPDF) --out-file $(OUTFILE2) $(INFILE2)

html: html_$(OUTFILE)

html_$(OUTFILE):
	$(ADOCHTML) --out-file docs/index.html $(INFILE)
	$(ADOCHTML) --out-file docs/CONTRIBUTE.html $(INFILE2)

preview_html: preview_html_$(OUTFILE)

preview_html_$(OUTFILE):
	$(ADOCHTML) --out-file docs/preview/index.html $(INFILE)
	$(ADOCHTML) --out-file docs/preview/CONTRIBUTE.html $(INFILE2)

preview_pdf: preview_$(OUTFILE)

preview_$(OUTFILE):
	$(ADOCPDF) --out-file docs/preview/$(OUTFILE) $(INFILE)
	$(ADOCPDF) --out-file docs/preview/$(OUTFILE2) $(INFILE2)

view: viewpdf

print: $(OUTFILE)
	$(PRINT) $(OUTFILE)

viewpdf: $(OUTFILE)
	$(ACROREAD) $(OUTFILE)

clean:
	rm -f $(OUTFILE)
	rm -f $(OUTFILE2)
	rm -rf .AppleDouble

spell:
	$(SPELL) $(SPELLOPTS) *.adoc */*.adoc

commit: clean
	$(VCS) commit .

push: clean
	$(VCS) push

pull:
	$(VCS) pull
