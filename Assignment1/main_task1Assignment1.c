#include <stdio.h>

 extern void assFunc(int x, int y);

 char c_check_validity(int x, int y){
    if(x>=y){
    return 1; 
    }   
    return 0 ;
 }

 int main(int argc, char* argv[],char *envp[]){
   int x,y;
    fprintf(stdout,"%s", "Enter Two 32-bit Int Numbers :\n");
    scanf("%d",&x);
    scanf("%d",&y);
    fflush(stdout);
    assFunc(x,y);
    return 0;
 }

