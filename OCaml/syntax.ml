open MySet
(* ML interpreter / type reconstruction *)
type id = string

type binOp = Plus | Mult | Lt

type logOp = And | Or

type exp =
    Var of id
  | ILit of int
  | BLit of bool
  | BinOp of binOp * exp * exp
  | LogOp of logOp * exp * exp
  | IfExp of exp * exp * exp
  | LetExp of id * exp * exp
  | FunExp of id * exp
  | AppExp of exp * exp
  | LetRecExp of id * id * exp * exp


type program = 
    Exp of exp
  | Decl of id * exp 
  | RecDecl of id * id * exp
  | NewDecl of id * exp * program

type tyvar = int

type ty = 
    TyInt
  | TyBool
  | TyVar of tyvar
  | TyFun of ty * ty (*引数の型と出力の型*)




let rec pp_ty = function
    TyInt -> print_string "int"
  | TyBool -> print_string "bool"
  | TyVar tyvar -> Printf.printf "%d" tyvar
  | TyFun (ty1, ty2) -> print_string "("; (pp_ty ty1); print_string " -> "; (pp_ty ty2); print_string ")"



let fresh_tyvar = 
  let counter = ref 0 in
  let body () =
    let v = !counter in
    counter := v + 1; v
  in body


let rec freevar_ty ty =
  match ty with
      TyFun(ty1, ty2) -> insert ty1 (freevar_ty ty2)
    | TyVar tyvar -> singleton ty
    | TyInt -> singleton ty
    | TyBool -> singleton ty;;

