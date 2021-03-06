SHAREDLIB = libfirmata.so
STATICLIB = libfirmata.a

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	SHAREDLIBPATH = /usr/lib
endif
ifeq ($(UNAME_S),Darwin)
	SHAREDLIBPATH = /usr/local/lib
endif

program_NAME := firmatac
program_C_SRCS := $(wildcard src/*.c)
program_C_OBJS := ${program_C_SRCS:.c=.o}
program_OBJS := $(program_C_OBJS)
program_INCLUDE_DIRS := includes
program_LIBRARY_DIRS :=
program_LIBRARIES :=

CPPFLAGS += $(foreach includedir,$(program_INCLUDE_DIRS),-I$(includedir))
LDFLAGS += $(foreach librarydir,$(program_LIBRARY_DIRS),-L$(librarydir))
LDFLAGS += $(foreach library,$(program_LIBRARIES),-l$(library))

.PHONY: all clean distclean

all: $(program_NAME) shared static

shared: $(programe_NAME)
	clang -shared -o $(SHAREDLIB) $(program_OBJS)

static: $(program_NAME)
	ar rc $(STATICLIB) $(program_OBJS)

install: all
	cp $(SHAREDLIB) $(SHAREDLIBPATH)

$(program_NAME): $(program_OBJS)
#	$(CC) $(program_OBJS) -o $(program_NAME)

clean:
	@- $(RM) $(SHAREDLIBPATH)/$(SHAREDLIB)
	@- $(RM) $(SHAREDLIB)
	@- $(RM) $(program_NAME)
	@- $(RM) $(program_OBJS)
	@- $(RM) $(STATICLIB)

re: clean all

distclean: clean
