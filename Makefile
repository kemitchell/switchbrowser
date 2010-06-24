SHELL = /bin/sh
CC = gcc
FRAMEWORKS = -framework Foundation -framework ApplicationServices

all: switchbrowser

switchbrowser: switchbrowser.m
	${CC} ${FRAMEWORKS} -o $@ $^*

install: switchbrowser
	cp switchbrowser /usr/local/bin
	cp switchbrowser.1 /usr/local/share/man/man1

clean:
	rm switchbrowser
