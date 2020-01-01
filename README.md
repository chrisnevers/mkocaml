# 🐪 Mkocaml

A simple helper I use to generate OCaml projects. I constantly find myself struggling to remember `dune` commands for
various tasks and how to setup opam files. This project is intended to solve that and make setup quicker.



This tool generates:
  * Git repository
  * OCaml `.gitignore`
  * Executable or Library with `inline-tests`
  * Opam package
  * Copy of the executable to `/usr/local/bin`
  * Makefile with no nonsense commands
  
# Install
      
      opam install mkocaml


# Examples
Creating a new executable

    > mkocaml -e new
    > make
    > new
    Hello, World!
Creating a new library

    > mkocaml -l new
    > make
   
## Makefile
    
 |Makefile command|Description|
 |---|---|
 |`make` or `make build` | Builds the project with dune, copies exe to `/usr/local/bin` |
 |`make install` | Installs the dune projects|
 |`make test` | Runs unit tests|
 |`make clean` | Cleans the project with dune|
 |`make doc` | Generates the documentation for the project|
 | `make publish` | Publishes the opam package| 

## Opam File

`mkocaml` uses `git config user.name` and `git config user.email` to fill in details. This info is used to generate a default version control url. For example, a git user name of `Chris Nevers` generates `https://github.com/chrisnevers`.

The `opam` package will be versioned at `1.0` by default. For subsequent releases, update the version in `<project>.opam` and `Makefile` (under the `publish` section).

Before publishing, ensure you fill in the `synopsis` section of the `<project>.opam`.

# Contributions
Contributions to `mkocaml` are greatly appreciated! ❤️

Please try to keep its implementation unassuming and configurable. 🙂
