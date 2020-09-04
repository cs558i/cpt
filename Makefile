# See LICENSE for copyright information
include config.mk

SRC = bin/cpt-readlink.c bin/cpt-stat.c
OBJ = ${SRC:.c=.o}
BIN = ${SRC:.c=}

all: ${BIN}

.c:
	${CC} ${CFLAGS} ${LDFLAGS} -o $@ $< ${LIBS}

clean:
	rm -f ${BIN} ${OBJ}

install-bin: ${BIN}
	for bin in ${BIN}; do \
		install -Dm755 $${bin} ${DESTDIR}${BINDIR}/$${bin##*/}; done

install-src:
	for bin in src/*; do \
		install -Dm755 $${bin} ${DESTDIR}${BINDIR}/$${bin##*/}; done

install-contrib:
	for bin in contrib/*; do \
		install -Dm755 $${bin} ${DESTDIR}${BINDIR}/$${bin##*/}; done

install-contrib-static:
	mkdir -p ${DESTDIR}${BINDIR}
	for bin in contrib/*; do \
		sed '/\. cpt-lib/r src/cpt-lib' $${bin} | \
		sed '/\. cpt-lib/d' > ${DESTDIR}${BINDIR}/$${bin##*/}; \
		chmod 755 ${DESTDIR}${BINDIR}/$${bin##*/}; done

install-src-static:
	mkdir -p ${DESTDIR}${BINDIR}
	for bin in src/*; do \
		sed '/\. cpt-lib/r src/cpt-lib' $${bin} | \
		sed '/\. cpt-lib/d' > ${DESTDIR}${BINDIR}/$${bin##*/}; \
		chmod 755 ${DESTDIR}${BINDIR}/$${bin##*/}; done

install-doc:
	for man in man/*.1; do install -Dm644 $${man} ${DESTDIR}${MAN1}/$${man##*/}; done

install:        install-bin install-src        install-contrib        install-doc
install-static: install-bin install-src-static install-contrib-static install-doc

uninstall:
	for bin in ${BIN} src/* contrib/*; do \
		rm -f ${DESTDIR}${BINDIR}/$${bin##*/}; done
	for man in man/*; do rm -f ${DESTDIR}${MAN1}/$${man##*/}; done


.PHONY: all install-bin install-src install-contrib install-doc install-src-static install-contrib-static install uninstall test clean
