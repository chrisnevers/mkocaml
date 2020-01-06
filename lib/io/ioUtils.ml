let exec cmd = cmd |> Unix.open_process_in |> input_line

let cmd_ cmd = let _ = Sys.command cmd in ()

let write_file name str =
  let chan = open_out name in
  output_string chan str;
  close_out chan
