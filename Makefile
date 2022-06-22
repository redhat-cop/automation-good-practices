ADOCHTML = asciidoctor --attribute=gitdate=$(shell git log -1 --date=short --pretty=format:%cd) --attribute=githash=$(shell git rev-parse --verify HEAD)
ADOCPDF = asciidoctor-pdf --attribute=gitdate=$(shell git log -1 --date=short --pretty=format:%cd) --attribute=githash=$(shell git rev-parse --verify HEAD)
INFILE = README.adoc
INFILE2 = CONTRIBUTE.adoc
OUTFILE = Good_Practices_for_Ansible
OUTFILE2 = Contributing-to-GPA

all:
	$(ADOCPDF) --out-file docs/$(OUTFILE).pdf $(INFILE)
	$(ADOCPDF) --out-file docs/$(OUTFILE2).pdf $(INFILE2)
	$(ADOCHTML) --out-file docs/$(OUTFILE).html $(INFILE)
	$(ADOCHTML) --out-file docs/$(OUTFILE2).html $(INFILE2)

preview: 
	$(ADOCPDF) --out-file docs/preview/$(OUTFILE).pdf $(INFILE)
	$(ADOCPDF) --out-file docs/preview/$(OUTFILE2).pdf $(INFILE2)
	$(ADOCHTML) --out-file docs/preview/$(OUTFILE).html $(INFILE)
	$(ADOCHTML) --out-file docs/preview/$(OUTFILE2).html $(INFILE2)
