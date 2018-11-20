# VARIABLE DEFINITIONS  #######################################################
###############################################################################
# folders #####################################################################
DIR:= .#
CODE:= $(DIR)/code

DATA:= $(DIR)/data

FIG:= $(DIR)/figures


DT/P:= $(DATA)/processed
DT/R:= $(DATA)/raw
DT/I:= $(DATA)/interim

DOC:= $(DIR)/docs
JRN:= $(DOC)/journals
RPRT:= $(DOC)/reports
PREZ:= $(DOC)/presentations
GIF:= $(PREZ)/figures

# FILES #######################################################################
# gif files for presentation
gifz:= $(GIF)/Slovenia.gif # $(wildcard $(GIF)/*.gif)

# all interim data filee
DT/I/.rds :=  $(DT/I)/*.rds

# all processed files
DT/P/.rds := $(DT/P)/*.rds



# COMMANDS ####################################################################
# recipe to make .dot file  of this makefile
define make2dot
	@echo creating the .dot file from the dependencies in this makefile ----------
	python $(DIR)/code/makefile2dot.py < $< > $@
	sed -i 's/rankdir="BT"/rankdir="TB"/' $(DT/P)/make.dot	
	@echo done -------------------------------------------------------------------
endef 

# recipe to make .png file  from the dot file
define dot2png
	@echo Creating the .png from the .dot ----------------------------------------
  Rscript -e "source('$<')"
	@echo done -------------------------------------------------------------------
endef

# recipe to knit pdf from first prerequisite
define rmd2pdf
	@echo creating the $(@F) file by knitting it in R. ---------------------------
  Rscript -e "suppressWarnings(suppressMessages(require(rmarkdown)));\
	render('$<', output_dir = '$(@D)', output_format = 'pdf_document',\
	quiet = TRUE )"
	-rm $(wildcard $(@D)/tex2pdf*) -fr
endef 

# recipe to knit html from first prerequisite
define rmd2html
	@echo creating the $(@F) file by knitting it in R.---------------------------
  Rscript -e "suppressWarnings(suppressMessages(require(rmarkdown))); \
	render('$<', output_dir = '$(@D)', output_format = 'html_document',\
	quiet = TRUE )"
endef 

# recipe to knit xaringan presentation from first prerequisite
define rmd2xaringan
	@echo creating the $(@F) file by knitting it in R.---------------------------
  Rscript -e "suppressWarnings(suppressMessages(require(rmarkdown))); \
	render('$<', output_dir = '$(@D)', output_format = 'xaringan::moon_reader',\
	quiet = TRUE )"
endef 


# recipe run latex with bibtex
define tex2dvi
	latex -interaction=nonstopmode --output-directory=$(@D) --aux-directory=$(@D) $< 
  bibtex $(basename $@)
	latex -interaction=nonstopmode --output-directory=$(@D) --aux-directory=$(@D) $<
  latex -interaction=nonstopmode --output-directory=$(@D) --aux-directory=$(@D) $<
endef 

# recipe run dvips for a0poster i.e. move the header file
define dvi2ps
	cp docs/presentations/a0header.ps a0header.ps
	dvips  -Pdownload35 -q -o $@ $<
  rm a0header.ps
endef

# recipe for creating pdf from ps file
define ps2pdf
	ps2pdf $< $@
endef

# recipe for sourcing the prerequisite R file
define sourceR
	Rscript -e "source('$<')"
endef

# DEPENDENCIES   ##############################################################
###############################################################################

all: journal dot reports data prezi

.PHONY: all


# make chart from .dot #########################################################
dot: $(FIG)/make.png 

# make chart from .dot
$(FIG)/make.png: $(CODE)/dot2png.R $(DT/P)/make.dot
	@$(dot2png)

# make file .dot from the .makefile
$(DT/P)/make.dot: $(DIR)/Makefile
	@$(make2dot)


# reports from Rmds ###########################################################
reports: $(RPRT)/*.pdf 

# journal (with graph) render to  pdf
$(RPRT)/*.pdf :  $(RPRT)/*.Rmd
	$(rmd2pdf)



# journals from Rmds ###########################################################
journal: $(JRN)/journal.html $(JRN)/journal.pdf  

# journal (with graph) render to  pdf
$(JRN)/journal.pdf:  $(JRN)/journal.Rmd $(FIG)/make.png 
	$(rmd2pdf)

# journal (with graph) render to  html
$(JRN)/journal.html:  $(JRN)/journal.Rmd 
	$(rmd2html)

prezi: $(PREZ)/2018-propsective_ageing_talk.html

# journal (with graph) render to  html
$(PREZ)/2018-propsective_ageing_talk.html:  $(PREZ)/2018-propsective_ageing_talk.Rmd $(gifz)
	$(rmd2xaringan)

# make gifs ##################################################
$(gifz):  $(CODE)/03-plotting.R
	Rscript -e "source('$<')"

# required data and fucntions for input to 03-plotting.R
$(CODE)/03-plotting.R: $(DT/P)/pop.rds $(DT/P)/prop.over.rds $(DT/P)/threshold.1y.rds $(CODE)/FunPlots.R

	
# clean up abd process data   ##################################################
$(DT/P)/pop.rds:  $(CODE)/02-transform_data.R
	Rscript -e "source('$<')"

# dependencies
$(DT/P)/prop.over.rds $(DT/P)/threshold.1y.rds:  $(CODE)/02-transform_data.R
	
# required data for input to 02-transform-data
$(CODE)/02-transform_data.R: $(DT/I)/pop.rds $(DT/I)/prosp.age.rds
	touch $@
	
# import and subset data #######################################################
$(DT/I)/pop.rds: $(CODE)/01-import.R
	Rscript -e "source('$<')"

# dependencies
$(DT/I)/prosp.age.rds: $(CODE)/01-import.R

# required data for input to 01-import
$(CODE)/01-import.R: $(DT/R)/2017_prospective-ages.csv $(DT/R)/WPP2017_PBSAS.csv 
	touch $@

# download figshare data 
$(DT/R)/2017_prospective-ages.csv:  $(CODE)/00-download.R 
	Rscript -e "source('$<')"
    
$(DT/R)/WPP2017_PBSAS.csv:  $(CODE)/00-download.R 
	touch $@