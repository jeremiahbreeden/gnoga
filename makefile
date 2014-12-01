PREFIX=$(dir $(shell which gnatls))..
TARGET=$(shell gcc -dumpmachine)

BUILDER=gprbuild
CLEANER=gprclean

# If you do not have gprtools switch to gnatmake and gnatclean
# this is the case on MSYS with MinGW, using Cygwin's own gcc/ada
# or on some linux distros
#
#BUILDER=gnatmake
#CLEANER=gnatclean
#
# If using MinGW on Cygwin32 or 64 you can use the following:
#
# For 32bit
#BUILDER=i686-w64-ming32-gnatmake
#CLEANER=i686-w64-ming32-gnatclean
#
# For 64bit
#BUILDER=x86_64-mingw32-gnatmake
#CLEANER=x86_64-mingw32-gnatclean

ifeq ($(strip $(findstring darwin, $(TARGET))),darwin)
	PRJ_TARGET=OSX
endif

all: gnoga gnoga_tools tutorials snake

gnoga:
	cd src && $(BUILDER) -p -Pgnoga.gpr

gnoga_tools:
	cd tools && $(BUILDER) -p -Ptools.gpr

release:
	cd src && $(BUILDER) -p -Pgnoga.gpr -XPRJ_BUILD=Release

install: release gnoga_tools
	cd src && gprinstall -f --prefix=$(PREFIX) -p gnoga.gpr -XPRJ_BUILD=Release
	cd tools && gprinstall -f --prefix=$(PREFIX) -p --mode=usage --install-name=tools tools.gpr

uninstall:
	- cd src && gprinstall -f --prefix=$(PREFIX) --uninstall gnoga.gpr
	- cd tools && gprinstall -f --prefix=$(PREFIX) --uninstall tools.gpr

ace_editor:
	- cd js && git clone https://github.com/ajaxorg/ace-builds.git

demo: snake adaedit adablog

adablog:
	cd demo/adablog && $(BUILDER) -Padablog.gpr

snake:
	cd demo/snake && $(BUILDER) -Psnake.gpr

adaedit: ace_editor
	cd demo/adaedit && $(BUILDER) -Pace_editor.gpr

tests:
	cd test && $(BUILDER) -Ptest.gpr

tutorials:
	cd tutorial/tutorial-01 && $(BUILDER) -Ptutorial_01.gpr
	cd tutorial/tutorial-02 && $(BUILDER) -Ptutorial_02.gpr
	cd tutorial/tutorial-03 && $(BUILDER) -Ptutorial_03.gpr
	cd tutorial/tutorial-04 && $(BUILDER) -Ptutorial_04.gpr
	cd tutorial/tutorial-05 && $(BUILDER) -Ptutorial_05.gpr
	cd tutorial/tutorial-06 && $(BUILDER) -Ptutorial_06.gpr
	cd tutorial/tutorial-07 && $(BUILDER) -Ptutorial_07.gpr
	cd tutorial/tutorial-08 && $(BUILDER) -Ptutorial_08.gpr
	cd tutorial/tutorial-09 && $(BUILDER) -Ptutorial_09.gpr
	- cd tutorial/tutorial-10 && $(BUILDER) -Ptutorial_10.gpr
	- cd tutorial/tutorial-11 && $(BUILDER) -Ptutorial_11.gpr

clean:
	cd src && $(CLEANER) -r -Pgnoga.gpr
	cd tools && $(CLEANER) -Ptools.gpr
	cd test && $(CLEANER) -Ptest.gpr
	cd demo/adablog && $(CLEANER) -Padablog.gpr
	cd demo/snake && $(CLEANER) -Psnake.gpr
	cd demo/adaedit && $(CLEANER) -Padaedit.gpr
	cd tutorial/tutorial-01 && $(CLEANER) -Ptutorial_01.gpr
	cd tutorial/tutorial-02 && $(CLEANER) -Ptutorial_02.gpr
	cd tutorial/tutorial-03 && $(CLEANER) -Ptutorial_03.gpr
	cd tutorial/tutorial-04 && $(CLEANER) -Ptutorial_04.gpr
	cd tutorial/tutorial-05 && $(CLEANER) -Ptutorial_05.gpr
	cd tutorial/tutorial-06 && $(CLEANER) -Ptutorial_06.gpr
	cd tutorial/tutorial-07 && $(CLEANER) -Ptutorial_07.gpr
	cd tutorial/tutorial-08 && $(CLEANER) -Ptutorial_08.gpr
	cd tutorial/tutorial-09 && $(CLEANER) -Ptutorial_09.gpr
	cd tutorial/tutorial-10 && $(CLEANER) -Ptutorial_10.gpr
	cd tutorial/tutorial-11 && $(CLEANER) -Ptutorial_11.gpr
	- cd bin && rm *.db
	- cd bin && rm temp.txt
	- cd js && rm -rf ace-builds
