# 🐪 Mkocaml

A simple helper I use to generate OCaml projects.

This tool generates:
  * Git repository
  * Git ignore
  * Executable/Library
  * Makefile with no nonsense commands
  * Copy of the executable to `/usr/local/bin`

I constantly find myself struggling to remember `dune` commands for
various tasks. This project is intended to solve that.


# Example
Creating a new executable

    > mkocaml -e new
    > make
    > new
    Hello, World!
