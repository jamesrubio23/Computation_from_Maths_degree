#include<iostream>
#include<algorithm>
#include<queue>
#include<list>

using namespace std;

# include "secuencias.cpp"

struct entrada{
       char letra;
       int frec=0;
};

bool operator <=(entrada e1, entrada e2){
     return e1.letra <= e2.letra;
}

bool operator ==(entrada e1, entrada e2){
     return e1.letra == e2.letra;
}

ostream &  operator <<(ostream & o, entrada e){
  o << e.letra << ":" << e.frec;
  return o;
}


#include "abb.cpp"


//template <>      //modifica insertar de los Abb de entradas, de forma que si está añada la frecuencia
/*template <typename entrada>*/
void insertar(Abb<entrada> & a, entrada e);



typedef  Abb<entrada> Tabla_frec;



void insertar(Abb<entrada> & a,char c){
     entrada e;
     e.letra = c;
     if(es_abb_vacio(a)){
        e.frec++;
        a = new Nodo_arbol<entrada>; 
        a->dato = e;

     }
     else if(a->dato.letra==c){
          a->dato.frec++;
     }
     else if(!(a->dato.letra<= c)){
          insertar(a->hijo_izdo,c);
     }
     else{
          insertar(a->hijo_dcho,c);
     }
}



Tabla_frec tabla_vacia(){
       return NULL;
}




#include <fstream>
bool leer(string file_name, Tabla_frec & t,int & cont,string & str){
     ifstream archivo;
     string mensaje;
     archivo.open(file_name);
     while(getline(archivo, mensaje)){
        for(int i = 0;i<mensaje.length();++i){ 
          insertar(t,mensaje[i]);
          cont++;
          str=str+mensaje[i];
        }        
     }
     archivo.close();
     return true; // Poner luego cuando no se puede leer el archivo
}


/*int main(){
     string mensaje;
     cout << "nombre del archivo"<<endl;
     cin >> mensaje;
     Tabla_frec a=tabla_vacia();
     if (leer(mensaje, a)){
       cout<<in_orden(a)<<endl;
     }
     return 0;
}*/

















