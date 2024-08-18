#include<iostream>
using namespace std;

struct nodo_pila{
  int elem;
  nodo_pila * sig;
};
typedef nodo_pila *pila;
//using pila =  nodo_pila *;

pila pila_vacia(){
  pila p;
  return NULL;
}

void apilar(pila & p, int e){
  pila aux;
  aux = new(struct nodo_pila);
  aux->elem = e;
  aux->sig = p;
  p = aux;
}

void desapilar(pila & p){
  pila aux;
  aux = p;
  p = aux->sig;
  delete(aux);
}


bool is_pila_vacia(pila & p){
     return p == NULL;
}

void mostrar(int e){
  cout << "("<< e <<")";
}

void mostrar(pila & p){
  if(!(is_pila_vacia(p))){
      mostrar(p->elem);
      mostrar(p->sig);
  }
  
}

int main(){
  pila p;
  p = pila_vacia();
  mostrar(p);
  apilar(p,2);
  apilar(p,5);
  desapilar(p);
  apilar(p,3);
  apilar(p,2);
  apilar(p,6);
  mostrar(p);
  cout<<endl;
  return 0;
}


