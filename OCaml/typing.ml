open Syntax
exception Error of string
let err s = raise (Error s)

(* Type Environment *)
type tyenv = ty Environment.t

(*型代入を表す型subst*)
type subst = (tyvar * ty) list

let fst (x, y) = x
let snd (x, y) = y

(* eqs_of_subst : subst -> (ty * ty) list 
型代入を型の等式集合に変換*)
let rec eqs_of_subst = function
    [] -> []
  | x :: rest -> ((TyVar (fst x)) , (snd x)) :: (eqs_of_subst rest)
    


(* *)
let ty_prim op ty1 ty2 = match op with
    Plus -> ([(ty1, TyInt); (ty2, TyInt)], TyInt)
  | Mult -> ([(ty1, TyInt); (ty2, TyInt)], TyInt)
  | Lt   -> ([(ty1, TyInt); (ty2, TyInt)], TyBool)
 (* | Cons -> err "Not Implemented!"*)

let hd (x :: rest) = x


(*x:tyと一致するy:substの要素を返す*)
let rec search x = function
  | y :: rest -> 
    if x = (fst y) 
    then (snd y) 
    else (search x rest) 

(*x:tyと一致するy:substの要素が存在するならtrueを返す*)
let rec check x = function
    [] -> false
  | y :: rest ->
    if x = (fst y)
    then true
    else (check x rest)


(*xと一致する要素yより後ろの要素を返す*)
let rec tail x = function
    [] -> []
  | y :: rest -> if x = (fst y) then rest else (tail x rest)

let null = function
    [] -> true
  | _ -> false

(*subst_type: subst -> ty -> ty
型に型代入を適用*)
let rec subst_type subst ty =
  match (subst, ty) with
      ([], ty) -> ty
    | (_, TyFun (ty1, ty2)) -> TyFun (subst_type subst ty1, subst_type subst ty2)
    | (_, TyInt) -> TyInt
    | (_, TyBool) -> TyBool
    | (_, TyVar tyvar) -> 
      if (check tyvar subst)
      then (subst_type (tail tyvar subst) (search tyvar subst))
      else TyVar tyvar

(*subst_eqs: subst -> (ty * ty) list -> (ty * ty) list  
型の等式集合に型代入を適用*)
let rec subst_eqs s eqs =
  match eqs with
      [] -> []
    | x :: rest -> ((subst_type s (fst x)), (subst_type s (snd x))) :: (subst_eqs s rest)

(*xと等しい要素を削除*)
let rec remove x = function
    [] -> []
  | y::rest -> if x = y then rest else y :: (remove x rest)

(*xと等しい要素があればそれをyで置き換える*)
let rec apply x y= function
    [] -> []
  | z :: rest ->
    if z=x 
    then y :: (apply x y rest)
    else z :: (apply x y rest)

(*入れ子になったリストを展開する 例:[(1,2); (3,4)] -> [1; 2; 3; 4] *)
let rec unfold = function
    [] -> []
  | x :: rest -> (fst x) :: (snd x) :: (unfold rest)

(*リストを2つずつペアにする 例:[1; 2; 3; 4] -> [(1,2); (3,4)] *)
let rec fold = function
    [] -> []
  | x :: y :: rest -> (x, y) :: (fold rest)

(*ty中に現れる型変数の集合を返す関数ftv*)
let rec ftv = function
    TyVar tyvar -> [tyvar]
  | TyFun (ty1, ty2) -> (ftv ty1) @ (ftv ty2)
  | _ -> []

(*リスト中にxが存在すればtrue,存在しなければfalseを返す関数exist*)
let rec exist x = function
    [] -> false
  | y :: rest -> if x = y then true else (exist x rest) 

(*単一化アルゴリズムunify : (ty * ty) list -> subst*)
let rec unify = function
    [] -> []
  | x :: rest -> 
    if (fst x) = (snd x) 
    then unify (remove x rest)
    else match ((fst x), (snd x)) with
	((TyVar tyvar), ty) ->
	  if (exist tyvar (ftv ty)) 
	  then err "error"
	  else
	    (tyvar, ty) :: 
	      (unify (fold (apply (TyVar tyvar) ty 
			      (unfold (remove x rest)))))
      | (ty, (TyVar tyvar)) ->
	if (exist tyvar (ftv ty))
	then err "error" 
	else 
	  (tyvar, ty) :: 
	    (unify (fold (apply (TyVar tyvar) ty
			    (unfold (remove x rest)))))
      | (TyFun(ty11, ty12), TyFun(ty21, ty22)) ->
	unify ((ty11, ty21) :: (ty12, ty22) :: 
		  (remove (ty11, ty21) (remove (ty12, ty22) (remove x rest))))
      | (_, _) -> err "error"

let rec ty_tyarg ty tyarg =
  match (ty, tyarg) with
    (TyFun(ty1, ty2), TyFun(ty3, ty4)) -> (ty_tyarg ty1 ty3) && (ty_tyarg ty2 ty4)
  | (TyVar tyvar1, _) -> true
  | (_, TyVar tyvar2) -> true
  | (TyInt, TyInt) -> true
  | (TyBool, TyBool) -> true
  | (_, _) -> false
                      
let check_fun tyarg = function
    TyFun (ty, _) -> 
    if (ty_tyarg ty tyarg)
    then true
    else false
  | _ -> err ("arg error") 

         
(*check_tyfun_tyarg: subst->tyvar->ty->bool
substに(tyvar, Fun(tyarg,_))が含まれるならtrueを返す*)
let rec check_tyfun_tyarg subst tyvar tyarg =
  match subst with
      x :: rest -> 
	if tyvar = (fst x)
	then check_fun tyarg (snd x)
	else check_tyfun_tyarg rest tyvar tyarg
    | [] -> false



let tyvar_from_ty ty =
  match ty with
      TyVar tyvar -> tyvar
    | _ -> err "tyvar error"

let check_if_ty ty1 ty2 =
  if (ty1 = ty2) then true
  else false



let rec ty_exp tyenv = function
Var x ->
  (try ([], Environment.lookup x tyenv) with
      Environment.Not_bound -> err ("variable not bound: " ^ x))
  | ILit _ -> ([], TyInt)
  | BLit _ -> ([], TyBool)
  | BinOp (op, exp1, exp2) ->
    let (s1, ty1) = ty_exp tyenv exp1 in
    let (s2, ty2) = ty_exp tyenv exp2 in
    let (eqs3, ty) = ty_prim op ty1 ty2 in
    let eqs = (eqs_of_subst s1) @ (eqs_of_subst s2) @ eqs3 in
    let s3 = unify eqs in
    (s3, subst_type s3 ty)
  | IfExp (exp1, exp2, exp3) ->
    let (stest, tytest) = ty_exp tyenv exp1 in
    let (s1, ty1) = ty_exp tyenv exp2 in
    let (s2, ty2) = ty_exp tyenv exp3 in
    let eqs = (eqs_of_subst stest) @ (eqs_of_subst s1) @ (eqs_of_subst s2) @ [(ty1, ty2)] in
    let s = unify eqs in
    let st1 = (subst_type s ty1) in
    let st2 = (subst_type s ty2) in
    if st1 = st2 then
      (match tytest with
	  TyBool -> (s, subst_type s ty1)
	| TyVar tyvar ->
	  let new_eqs = eqs @ [(TyVar tyvar, TyBool)] in
	  let new_s = unify new_eqs in
	  (new_s, subst_type new_s ty1) 
	| _ -> err ("Test expression must be boolean: if"))
    else err ("If: type error")
  | LetExp (id, exp1, exp2) ->
    let (s1, ty1) = ty_exp tyenv exp1 in
    let (s2, ty2) = ty_exp (Environment.extend id ty1 tyenv) exp2 in
    let eqs = (eqs_of_subst s1) @ (eqs_of_subst s2) in
    let s = unify eqs in
    (s, subst_type s ty2)
  | FunExp (id, exp) ->
    let domty = TyVar (fresh_tyvar ()) in
    let (s, ranty) =
      ty_exp (Environment.extend id domty tyenv) exp in
    (s, TyFun (subst_type s domty, ranty))
  | AppExp (exp1, exp2) ->     
    let (sfun, tyfun) = ty_exp tyenv exp1 in
    let (sarg, tyarg) = ty_exp tyenv exp2 in
    let newty = TyVar (fresh_tyvar ()) in
    let eqs = (eqs_of_subst sfun) @ (eqs_of_subst sarg) 
      @ [(tyfun, TyFun (tyarg, newty))] in
    let s = unify eqs in
    let styfun = subst_type s tyfun in
    let styarg = subst_type s tyarg in
    pp_ty styfun;
    print_string "\n";
    pp_ty styarg;
    print_string "\n";
    if (check_fun styarg styfun)
    then (s, subst_type s newty)
    else err "apply type error";
  | _ -> err ("Not Implemented!debug2")

let ty_decl tyenv = function
    Exp e -> let (s, ty) = (ty_exp tyenv e) in (tyenv, subst_type s ty)
  | Decl (id, e) ->
     let (_, ty) = (ty_exp tyenv e) in
     ((Environment.extend id ty tyenv), ty)
  | _ -> err ("Not Implemented!debug1")
