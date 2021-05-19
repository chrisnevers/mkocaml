open IoUtils
open GitUtils

let opam project =
  Format.sprintf
"
opam-version: \"2.0\"
version: \"1.0\"
authors: \"%s <%s>\"
maintainer: \"%s <%s>\"
homepage: \"https://github.com/%s/%s\"
bug-reports: \"https://github.com/%s/%s/issues\"
dev-repo: \"git://github.com/%s/%s.git\"
synopsis: \"\"
build: [
  [\"dune\" \"subst\"] {dev}
  [\"dune\" \"build\" \"-p\" name \"-j\" jobs]
]

depends: [
  \"ocaml\"
  \"dune\" {>= \"%s\"}
]
"
(* Authors *)
username email
(* Maintainers *)
username email
(* Homepage *)
account project
(* Bug reports *)
account project
(* Dev repo *)
account project
(* Build depends on user's dune version *)
dune_version

let setup_opam project =
  let filename = project ^ ".opam" in
  if Sys.file_exists filename |> not then
    opam project |> write_file filename; cmd_ "dune build @install"
