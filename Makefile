
ADOCPDF = asciidoctor-pdf --attribute=gitdate=$(shell git log -1 --date=short --pretty=format:%cd) --attribute=githash=$(shell git rev-parse --verify HEAD)
INFILE = README.adoc
INFILE2 = CONTRIBUTE.adoc
OUTFILE = Good_Practices_for_Ansible.pdf
OUTFILE2 = Contributing-to-GPA.pdf

all:
	$(ADOCPDF) --out-file docs/$(OUTFILE) $(INFILE)
	$(ADOCPDF) --out-file docs/$(OUTFILE2) $(INFILE2)

preview: 
	$(ADOCPDF) --out-file docs/preview/$(OUTFILE) $(INFILE)
        $(ADOCPDF) --out-file docs/preview/$(OUTFILE2) $(INFILE2)

clean:
	rm -f $(OUTFILE)
	rm -f $(OUTFILE2)
