#include<iostream>
using namespace std;

//EJ 4.8

struct nodo_dc{
  int elem;
  nodo_dc * ant;
  nodo_dc * sig;
};

struct doble_cola{
  nodo_dc * primero=NULL;
  nodo_dc * ultimo=NULL;
};

doble_cola dcola_vacia(){
  doble_cola c;
  return c;
}

void poner_detras(doble_cola & c, int e){  //NO funciona
  nodo_dc * p = new nodo_dc;
  p->elem = e;
  p->sig=NULL;
  if(c.ultimo ==NULL){
    p->ant = NULL;
    c.primero = p;
  }
  else{
    p->ant = c.ultimo;
    c.ultimo->sig = p;
  }
  c.ultimo = p;
}

void poner_delante(doble_cola & c, int e){
  nodo_dc * p = new nodo_dc;
  p->elem = e;
  p->ant =NULL;
  if(c.primero==NULL){
    p->sig =NULL;
    c.ultimo = p;
  }
  else{
    p->sig = c.primero;
    c.primero->ant = p; 
  }
  c.primero = p;
}

void mostrar(int e){
  cout<<e<<" ";
}

void mostrar(doble_cola & c){ //Si pongo que muestre aux->elem primero muestra un 0.
  nodo_dc * aux = new nodo_dc;
  aux = c.primero;
  while(!(aux == NULL)){    
    mostrar(aux->elem);
    aux = aux->sig;    
  }
  //mostrar(aux->elem);
  cout<<endl;
}


int main(){
  doble_cola c;
  c = dcola_vacia();
  mostrar(c);
  cout<<"Meto el 1 delante"<<endl;
  poner_delante(c,1);
  mostrar(c);
  cout<<"Meto el 2 delante"<<endl;
  poner_delante(c,2);
  mostrar(c);
  cout<<"Meto el 3 detras"<<endl;
  poner_detras(c,3);
  mostrar(c);

}
