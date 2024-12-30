%{
#include "syntaxique.tab.h"  
#include "Fonction.h"
extern  nb_ligne;
extern nb_colonne; 
extern YYSTYPE yylval;



%}

lettre [a-zA-Z]
chiffre [0-9]
idf {lettre}({lettre}|{chiffre}|_)*[^_]
cst  [+-]?([1-9][0-9]*|0)
str \"[^\"]*\"
commentaire ##(.|\n)*?##

%%

program return mc_program;
int {yylval.str=strdup(yytext); return mc_int;} 
real { yylval.str=strdup(yytext); return mc_real; }
chaine {yylval.str=strdup(yytext); return mc_chaine;}
const {yylval.str=strdup(yytext); return mc_const;}
for return mc_for;
begin {return mc_begin;}
end {return mc_end;}
In return mc_in;
Out return mc_out;
"%d" return signe_format;
"%f" return signe_format;
"%s" return signe_format;
[\-+*/;=,<>!()\[\]\{\}\"\.] {return yytext[0];}

{cst} {yylval.entier=atoi(yytext); return cst;}
{idf} { if (yyleng>12) printf("erreur lexicale a la ligne %d,colonne %d sur l'entite %s (IDF trop long)\n",nb_ligne, nb_colonne,yytext);
        else { 
		if (strstr(yytext, "__") == NULL) { 
            printf("Identifiant valide: %s\n", yytext);
        } else {
            printf("Erreur: Identifiant contient des doubles underscores\n");
        }
        yylval.str = strdup(yytext); 
        inserer(yytext, "idf"); 
        return idf;
	  }

{commentaire} 

[ \t]
\n  { 
     nb_ligne++;
	
	 }

. { 
    nb_colonne += yyleng; 
    printf("erreur lexical a la ligne %d sur l'entite %s\n", nb_ligne, yytext);
    return err;

}

%%
