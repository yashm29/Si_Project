
#include <stdbool.h>




typedef struct
{
    char NomEntite[20];
    char CodeEntite[20];
    char TypeEntite[20];
    char TailleEntite[20];
	char Constante[4];
} TypeTS;

//initiation de la table de symbole
TypeTS ts[100]; 

// un compteur global pour la table de symbole
int CpTabSym=0;

//une fonctione recherche: pour chercher est ce que l'entite existe ou non deja dans la table de symbole.

int recherche(char entite[])
{
    int i=0;
    while(i<CpTabSym)
    {
        if (strcmp(entite,ts[i].NomEntite)==0) return i;
        i++;
    }
    return -1; // non trouve
}

//une fontion qui va inserer les entites de programme dans la table de symbole
void inserer(char entite[], char code[])
{
    if ( recherche(entite)==-1)
    {
        strcpy(ts[CpTabSym].NomEntite,entite); 
        strcpy(ts[CpTabSym].CodeEntite,code);
        strcpy(ts[CpTabSym].Constante,"non");
        
        //printf("lentite est %s, sont type est %s %d\n",ts[CpTabSym].NomEntite,ts[CpTabSym].TypeEntite,CpTabSym);
        CpTabSym=CpTabSym+1;
    }
}

//une fonction pour afficher la table de symbole
void afficher()
{
    printf("\n/***************Table des symboles ******************/\n");
    printf("___________________________________________________________________\n");
    printf(" NomEntite |  CodeEntite  |  TypeEntite | Constante | TailleEntite \n");
    printf("___________________________________________________________________\n");
    int i=0;
    while(i<CpTabSym)
    {
        printf("%10s |%12s  |%10s   |%10s|%13s|\n",ts[i].NomEntite,ts[i].CodeEntite,ts[i].TypeEntite,ts[i].Constante,ts[i].TailleEntite);
        i=i+1;
		
    }
}
// fonction qui change le type et taille d'une etite une fois elle va etre reconu dans la syntaxe 
void insererTypeTaille(char entite[],char type[], int taille)
{
    int posEntite=recherche(entite);
    if (posEntite!=-1)
    { 
        strcpy(ts[posEntite].TypeEntite,type);
        sprintf(ts[posEntite].TailleEntite, "%d", taille);
        // ts[posEntite].TailleEntite=taille;
    }
}


void insererConst(char entite[],char constante[]){
    int posEntite=recherche(entite);

    if (posEntite!=-1){ 
        if(strcmp(constante,"const")==0){
            strcpy(ts[posEntite].Constante,"oui");
        }
    }
}


int ifConst(char entite[]){
    int posEntite = recherche(entite);

    if (strcmp(ts[posEntite].Constante,"oui")==0) return 1;// erreur
    else return 0;// pas d'erreur
}


int doubleDeclaration (char entite[])
{
    int posEntite=recherche(entite);

    //printf ("\nposi %d\n",posEntite);
    if (strcmp(ts[posEntite].TypeEntite,"")==0) return 1;  //  pas de type associe a l'entite dans le table de symbole et donc elle est pas encore declaree
    else return 0; // le type de existe donc c'est une double declaration

}


int ifDeclare(char entite[]) {
    int posEntite = recherche(entite);

    if (strcmp(ts[posEntite].TypeEntite, "") == 0) {
        // idf non trouve dans la tables des symboles
        return 0; // non declare
    } else {
        return 1; // declare
    }
}



int depassementTaille(char entite[],int taille){
    int posEntite=recherche(entite);
    
    int tailleEntite=atoi(ts[posEntite].TailleEntite);
    if(taille>tailleEntite) return 0;
    else return 1; // pas de depassement
}




