all: build

build: 
	@dune build @all
	cp -f _build/default/mkocaml.exe /usr/local/bin/mkocaml

install:
	@dune install 

test: build
	@dune runtest

doc: build
	@opam install odoc
	@dune build @doc
  
clean:
	@dune clean

