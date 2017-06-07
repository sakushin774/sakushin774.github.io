open Syntax
open Eval
open Typing

let rec read_eval_print env tyenv=
  print_string "# ";
  flush stdout;
  let decl = try Parser.toplevel Lexer.main (Lexing.from_channel stdin)
             with parse_error -> Printf.printf "Error: Syntax error\n";
                                 print_string "# ";
                                 flush stdout;
                                 Parser.toplevel Lexer.main (Lexing.from_channel stdin) in
  let (newtyenv, ty) =  ty_decl tyenv decl in
  let (id, newenv, v) = 
    try eval_decl env decl
    with Unbound x -> Printf.printf "Error: Unbound value %s" x;
      print_newline();
      read_eval_print env tyenv in
  Printf.printf "val %s : " id;
  pp_ty ty;
  print_string " = ";
  pp_val v;
  print_newline();
  read_eval_print newenv newtyenv

(*Ex3.1:大域環境の追加*)
let initial_env = 
  Environment.extend "i" (IntV 1)
   (Environment.extend "ii" (IntV 2)
     (Environment.extend "iii" (IntV 3)
       (Environment.extend "iv" (IntV 4)
         (Environment.extend "v" (IntV 5) 
           (Environment.extend "x" (IntV 10)
	      Environment.empty)))))

let initial_tyenv = 
  Environment.extend "i" TyInt
   (Environment.extend "ii" TyInt
     (Environment.extend "iii" TyInt
       (Environment.extend "iv" TyInt
         (Environment.extend "v" TyInt 
           (Environment.extend "x" TyInt Environment.empty)))))

let _ = read_eval_print initial_env initial_tyenv


