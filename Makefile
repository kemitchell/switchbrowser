SHELL = /bin/sh
CC = gcc
FRAMEWORKS = -framework Foundation -framework ApplicationServices

all: switchbrowser

switchbrowser: switchbrowser.m
	${CC} ${FRAMEWORKS} -o $@ $^*

install: switchbrowser
	cp switchbrowser /usr/local/bin
	cp switchbrowser.1 /usr/local/share/man/man1

preview:
	groff -Tascii -man switchbrowser.1 | less

clean:
	rm switchbrowser
