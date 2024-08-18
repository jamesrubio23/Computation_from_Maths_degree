#include<iostream>
using namespace std;

struct nodo_cola{
  int elem;
  nodo_cola * sig;
};

struct cola{
  nodo_cola * primero=NULL;
  nodo_cola * ultimo=NULL;
};


cola cola_vacia(){
  cola c;
  /*nodo_cola * aux = new nodo_cola ;
  c.primero=aux;
  c.ultimo=aux;*/
  return c;
}


void pedir_vez(cola & c, int e){
  nodo_cola * aux = new nodo_cola;
  aux->elem = e;
  aux->sig = NULL;
  if(c.ultimo == NULL){
    c.primero = aux;
  } 
  else{
     c.ultimo->sig = aux;
  }
  c.ultimo = aux;
}

void avanzar(cola & c){
  if(c.primero==NULL){
    throw runtime_error("Es vacia la cola");
  }
  else{
    nodo_cola * aux = new nodo_cola;
    aux = c.primero;
    c.primero = aux->sig;  
  }  
}

void mostrar(int e){
  cout<<e<<" ";
}

void mostrar(cola & c){ //Si pongo que muestre aux->elem primero muestra un 0.
  nodo_cola * aux = new nodo_cola;
  aux = c.primero;
  while(aux != NULL){
    mostrar(aux->elem);
    aux = aux->sig;
  }
  cout<<endl;
}


cola copiar(cola & c){
  cola d = cola_vacia();
  nodo_cola * t = new nodo_cola;
  nodo_cola * r;
  nodo_cola * s;
  if(c.primero==NULL){
    throw runtime_error("Es vacia la cola");
    d = cola_vacia();
  }
  else{
    r = c.primero;
    t->elem =r->elem;
    s = t;
    d.primero = t;
    while((r->sig)!=NULL){
      r = r->sig;
      nodo_cola * t = new nodo_cola;
      t->elem = r->elem;
      s->sig = t;
      s = t;  
         
    }
    s->sig = NULL;
    d.ultimo = s;
  }
  return d;
  
  
}

int main(){
  cola c;
  c = cola_vacia();
  mostrar(c);
  cout<<"Meto 1,2,3"<<endl;
  pedir_vez(c,1);
  pedir_vez(c,2);
  pedir_vez(c,3);
  mostrar(c);
  cout<<"Eliminamos el primero que entro que es el 1"<<endl;
  avanzar(c);
  mostrar(c);
  cout<<"Añadimos el 1 otra vez"<<endl;
  pedir_vez(c,1);
  mostrar(c);
  cout<<"Copiamos la cola en otra con diferente posicion de memoria"<<endl;
  cola d;
  d = copiar(c);
  mostrar(d);
}








