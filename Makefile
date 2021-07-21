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
ACROREAD = okular
VCS = git
INFILE = README.adoc
INFILE2 = CONTRIBUTE.adoc
OUTFILE = Good_Practices_for_Ansible.pdf
OUTFILE2 = Contributing-to-GPA.pdf
PRINT = lpr
SPELL = hunspell
SPELLOPTS = -d en_GB


all: $(OUTFILE)

$(OUTFILE): $(INFILE) *.adoc */*.adoc _images/* Makefile .git/index
	$(ADOCPDF) --out-file $(OUTFILE) $(INFILE)
	$(ADOCPDF) --out-file $(OUTFILE2) $(INFILE2)

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
