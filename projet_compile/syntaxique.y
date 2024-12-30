%{
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

int nb_ligne = 1;
int nb_colonne = 1; 
char suavType[20];
char suavConst[10];

int cptIdf=0;
    int i=0;

 

%}

%union{
    int entier;
    char* str;
}

%token mc_program <str>mc_int <str>mc_real <str>mc_chaine mc_const mc_for mc_begin mc_end mc_in mc_out signe_format <entier>cst  <str>idf str err

%%

S: mc_program idf '{' Corps '}' 
    { 
        printf("Programme syntaxiquement juste\n"); 
        YYACCEPT; 
    }
;
Corps : Inst_Dec Corps
       |
;
Inst_Dec: declaration
         |listInst 
;
declaration: type ListIdf ';' declaration 
           | type ListIdf ';'
           | type const_dec declaration 
           | type const_dec
;


const_dec: const idfs_dec '=' cst ';' 
;

const: mc_const {strcpy(suavConst,$1);} 
;

type: mc_int {strcpy(suavType,$1);} 
    | mc_real {strcpy(suavType,$1);} 
    | mc_chaine {strcpy(suavType,$1);} 
;



ListIdf: ListIdf ',' idfs_dec | idfs_dec
;
idfs_dec: idf '[' cst ']' {
    if (doubleDeclaration($1) == 1) {
        // Insert the array type and size correctly
        insererTypeTaille($1, suavType, $3); // Insert array with its size
        insererConst($1, suavConst); // Insert const if needed
    } else {
        printf("ERREUR SEMANTIQUE: double declaration de %s, a la ligne %d\n", $1, nb_ligne);
    }
}
    | idf {
        if (doubleDeclaration($1) == 1) {
            insererTypeTaille($1, suavType, 1); // Insert a single variable (not an array)
            insererConst($1, suavConst); // Insert const if needed
        } else {
            printf("ERREUR SEMANTIQUE: double declaration de %s, a la ligne %d\n", $1, nb_ligne);
        }
    }
;


listInst: listInst uneInst
        | uneInst
;

uneInst: instAff
       | instfor
       | insIn
       | insOut
;

idfs:idf'['cst']' {
    if(ifDeclare($1)==0) 
        printf("ERREUR SEMANTIQUE: %s non declare, a la ligne %d\n", $1, nb_ligne);
    else if(ifConst($1)==1) 
        printf("ERREUR SEMANTIQUE: %s est une constante a la ligne %d\n",$1,nb_ligne);
    else if(depassementTaille($1,$3)==0)
        printf("ERREUR SEMANTIQUE: Depassement de taille pour le tableau %s , a la ligne %d\n",$1,nb_ligne);
}
    | idf {
        if(ifDeclare($1)==0) 
            printf("ERREUR SEMANTIQUE: %s non declare, a la ligne %d\n", $1, nb_ligne);
        else if(ifConst($1)==1) 
            printf("ERREUR SEMANTIQUE: %s est une constante a la ligne %d\n",$1,nb_ligne);
}
;

instAff: idfs '=' exp ';'
        | idfs'=' str ';'
;

exp: exp '+' term | exp '-' term | term
;

term: term '*' facteur | division | facteur
;

facteur: idfs 
        | cst 
        | '('exp')'
;

division: exp '/' idfs
        | exp '/' cst 
		{if ($3==0) printf("erreur semantique: division sur zero, a la ligne %d\n",nb_ligne);}
;
;
insIn: mc_in '(' '"' signe_format '"' ',' idf ')' ';'
;

insOut: mc_out '(' idf '"' signe_format '"' ',' ')' ';'
;

instfor: mc_for '(' headerfor ')' mc_begin listInst mc_end ';'
;

headerfor: initfor condfor incfor
;

initfor: idf '=' exp ';'
{if(ifDeclare($1)==0) 
        printf("ERREUR SEMANTIQUE: %s non declare, a la ligne %d\n", $1, nb_ligne);}
;

condfor: idf opr exp ';'
{
    if(ifDeclare($1)==0) 
        printf("ERREUR SEMANTIQUE: %s non declare, a la ligne %d\n", $1, nb_ligne);
}
;

incfor:idf '+' '+'
 {if(ifDeclare($1)==0) 
        printf("ERREUR SEMANTIQUE: %s non declare, a la ligne %d\n", $1, nb_ligne);
}
;

opr: '<' | '>' | '<' '=' | '>' '=' | '!' '=' | '=' '='
;

%%
main () 
{
yyparse();
afficher();

}
yywrap()
{}

int yyerror(char * msg)

{
printf("erreur syntaxique dans la ligne %d\n", nb_ligne);
}