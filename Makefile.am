lib_LTLIBRARIES = libspcloudclient.la
libspcloudclient_la_SOURCES=src/*
obj_DIRS=obj
LIBS=
EXTRA_DIST = spcloud_config_client.gpr src/*
all-local:
	gprbuild -d -Pspcloud_config_client.gpr -XLIBRARY_TYPE=relocatable -XAWS_BUILD=relocatable -gnatX

check-local: all-local

format:
	find . -type f -name '*.ad*'  -print0 |xargs -0 gnatpp --max-line-length=120 --split-line-before-op -l2

clean-local:
	rm -rf ${obj_DIRS}/*
	rm -rf lib/*
	rm -rf tests/obj/*
	rm -rf *.o
	rm -rf *.ali
	rm -rf *.so
	rm -rf configure~
	rm -rf autom4te.cache/*
	rm -rf autom4te.cache
