#
# GNU Makefile
#

install:
	@echo Install...
	./setup.sh install
	@echo Finish!!

deploy:
	@echo Deploy...
	./setup.sh deploy
	@echo Finish!!
