let move_exe_to_bin project = function
  | `Exec -> Format.sprintf
    "\t@cp -f _build/default/bin/%s.exe /usr/local/bin/%s\n" project project
  | _ -> ""

let update_makefile_for_exe project =
  Format.sprintf "sed -i \"\" 's#@dune build @all#@dune build @all\\\n\t@cp -f _build/default/bin/main.exe /usr/local/bin/%s\\\n#' Makefile"
  project |> IoUtils.cmd_

let makefile project project_type account =
  let mv_cmd = move_exe_to_bin project project_type in
  Format.sprintf
"all: build

build:
\t@dune build @all
%s
install:
\t@dune install

test: build
\t@dune runtest

doc: build
\t@opam install odoc
\t@dune build @doc

clean:
\t@dune clean

# Create a release on Github, then run git pull
publish:
\t@git tag 1.0
\t@git push origin 1.0
\t@git pull
\t@opam pin .
\t@opam publish https://github.com/%s/%s/archive/1.0.tar.gz
"
(* Move executables to /usr/local/bin *)
mv_cmd
(* Git account name *)
account
(* Git project name *)
project
