%{
open Syntax
%}

%token LPAREN RPAREN SEMISEMI
%token PLUS MULT LT AND OR
%token IF THEN ELSE TRUE FALSE
%token LET IN EQ
%token RARROW FUN
%token REC

%token <int> INTV
%token <Syntax.id> ID

%start toplevel
%type <Syntax.program> toplevel
%%

toplevel :
    Expr SEMISEMI { Exp $1 }
  | DeclExpr SEMISEMI { $1 }

  
Expr :
    IfExpr { $1 }
  | LetExpr { $1 }
  | ORExpr { $1 }
  | FunExpr { $1 }

ORExpr :
    ANDExpr OR ANDExpr {LogOp (Or, $1, $3) }
  | ANDExpr { $1 }

ANDExpr :
    LTExpr AND LTExpr {LogOp (And, $1, $3) }
  | LTExpr { $1 }

LTExpr : 
    PExpr LT PExpr { BinOp (Lt, $1, $3) }
  | PExpr { $1 }

PExpr :
    PExpr PLUS MExpr { BinOp (Plus, $1, $3) }
  | MExpr { $1 }

MExpr : 
    MExpr MULT AppExpr { BinOp (Mult, $1, $3) }
  | AppExpr { $1 }

AppExpr :
    AppExpr AExpr { AppExp ($1, $2) }
  | AExpr { $1 }

AExpr :
    INTV { ILit $1 }
  | TRUE { BLit true }
  | FALSE { BLit false }
  | ID { Var $1 }
  | LPAREN Expr RPAREN { $2 }

IfExpr :
   IF Expr THEN Expr ELSE Expr { IfExp ($2, $4, $6) }

LetExpr :
   LET ID EQ Expr IN Expr { LetExp ($2, $4, $6) }
 | LET REC ID EQ FUN ID RARROW Expr IN Expr { LetRecExp ($3, $6, $8, $10)}

FunExpr :
   FUN ID RARROW Expr { FunExp ($2, $4) }

DeclExpr :
   LET ID EQ Expr { Decl ($2, $4) }
 | LET REC ID EQ FUN ID RARROW Expr { RecDecl ($3, $6, $8)}
 | LET ID EQ Expr LET NewDExpr {NewDecl ($2, $4, $6)}

NewDExpr :
   ID EQ Expr { Decl ($1, $3) }
 | ID EQ Expr LET NewDExpr {NewDecl ($1, $3, $5)}
