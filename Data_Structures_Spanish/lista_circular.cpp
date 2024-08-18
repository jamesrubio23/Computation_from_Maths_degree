#include<iostream>
using namespace std;

struct nodo{
  int dato;
  nodo* sig;
  nodo* ant;
};

struct lista{
  int longitud=0;
  nodo* izquierdo=NULL;
  nodo* derecho=NULL;
};

lista vacia();
void anadir_iz(lista &, int);
void elim_iz(lista &);
void anadir_dr(lista &, int);
void elim_dr(lista &);
void concatenar(lista &, lista &, lista &);
bool esta(lista &, int);
int posicion(lista &, int, int);
void eliminar(lista &, int);
void coger(lista &, int n);
void tirar(lista & l, int n);

lista unitaria(int);
bool is_vacia(lista & l);
void mostrar(lista &,int);
void mostrar(int);

int main(){
  lista l1;
  mostrar(l1,1);
  cout<<"Hemos mostrado la lista vacía. Añadimos 1 y 2"<<endl;
  anadir_iz(l1,1);
  anadir_iz(l1,2);
  mostrar(l1,1);
  cout<<"Añado el 3 y 4 a otra lista"<<endl;  
  lista l2;
  anadir_iz(l2,3);
  anadir_iz(l2,4);
  mostrar(l2,2);
  cout<<"Unimos lista 1 y lista 2"<<endl;
  lista l3;
  concatenar(l1,l2,l3);
  mostrar(l3,3);
  
  cout<<"Veamos si esta el 4 en la lista 2"<<endl;
  bool b;
  b = esta(l2,4);
  cout<<b<<endl;
  cout<<"Veamos si esta el 10 en la lista 2"<<endl;
  bool b1;
  b1 = esta(l2,10);
  cout<<b1<<endl; 
  
  int pos = 0;
  pos = posicion(l2,3,pos);
  cout<<"El 3 esta en la posicion "<<pos<<endl;
  int pos1 = 0;
  pos1 = posicion(l2,5,pos1);
  cout<<"El 5 esta en la posicion "<<pos1<<endl;
  
  cout<<"AÃ±adimos otro 1 a l1 y eliminamos los 1 que haya en l1"<<endl;
  anadir_iz(l1,1);
  mostrar(l1,1);
  cout<<"Eliminamos los 1"<<endl;
  eliminar(l1,1);
  mostrar(l1,1);
  

  
}


lista vacia(){
  lista nuevo;
  /*nodo * p = new nodo; 
  nuevo.izquierdo = p;
  nuevo.derecho = nuevo.izquierdo;*/
  return nuevo;
}

void anadir_iz(lista & l, int e){
  nodo* p = new nodo;
  p->dato = e;
  p->ant = NULL;
  if(l.izquierdo==NULL){
    p->sig =NULL;
    l.derecho = p;
  }
  else{
    p->sig = l.izquierdo;
    l.izquierdo->ant = p;
  }
  l.longitud+=1;
  l.izquierdo = p;
}

void elim_iz(lista & l){
  
  if(l.izquierdo == NULL){
    cout<<"ERROR"<<endl;
  }
  else{
    nodo * p = new nodo;
    p = l.izquierdo;
    l.izquierdo = p->sig;
    if(l.izquierdo == NULL){
      l.derecho =NULL;
    }
    else{
      l.izquierdo->ant = NULL;
    }
    l.longitud -=1;
    delete p;
  }
  
}

void anadir_dr(lista & l, int e){
  nodo * p = new nodo;
  p->dato = e;
  p->sig = NULL;
  if(l.derecho ==NULL){
    p->ant = NULL;
    l.izquierdo = p;
  }
  else{
    p->ant = l.derecho;
    l.derecho->sig = p;
  }
  l.derecho = p;
  l.longitud+=1;  
}

void elim_dr(lista & l){
  
  if(l.derecho==NULL){
    cout<<"ERROR"<<endl;
  }
  else{
    nodo * p = new nodo;
    p = l.derecho;
    l.derecho = p->ant;
    if(l.derecho==NULL){
      l.izquierdo = NULL;
    }
    else{
      l.derecho->sig = NULL;
    }
    l.longitud-=1;
    delete p;
  }
}

void concatenar(lista & l1, lista & l2, lista & l3){ //POR QUE NO PUEDO CONCATENAR? COMO PUEDO COPIAR UNA LISTA EN DIFERENTE POSICION DE MEMORIA??
  nodo * z = new nodo;
  nodo * p = new nodo;
  //Como copio la lista l1??
  /*z = l1.izquierdo;
  l3.izquierdo = z;*/
  z = l1.izquierdo;
  while(z->sig !=NULL){
    anadir_dr(l3,z->dato);
    z = z->sig;
  }
  anadir_dr(l3,z->dato);
  
  p = l2.izquierdo;
  while(p->sig !=NULL){
    anadir_dr(l3,p->dato);
    p = p->sig;
  }
  anadir_dr(l3,p->dato);    
}


lista unitaria(int e){
  lista l;
  nodo * p = new nodo;
  p->dato = e;
  p->ant==NULL;
  p->sig ==NULL;
  l.izquierdo = p;
  l.derecho = p;
  l.longitud=1;
  return l;
}


bool esta(lista & l, int e){
  nodo * p = new nodo;
  bool b;
  p = l.izquierdo;
  b = false;
  while(!(b) and (p->sig !=NULL)){
    if(p->dato==e){
      b = true;
    }
    else{
      p = p->sig;
    }
  }
  b = (p->dato == e);
  return b;
}


int posicion(lista & l, int e, int pos){ //Podemos sacar la posicion ya que hacemos una inversion con pos
  if(esta(l, e)){
    nodo * p = new nodo;
    bool b;
    p = l.izquierdo;
    b = false;
    while(!(b) and (p->sig !=NULL)){
      if(p->dato==e){
        b = true;
        pos+=1;
      }
      else{
        p = p->sig;
        pos+=1;
      }
    }
    if(!b){
      b = (p->dato == e);
    
    }
    pos+=1;
    return pos;
  }
  else{
   return -1;
  } 
}

void eliminar(lista & l, int e){
  if(esta(l,e)){
    nodo* p = new nodo;
    p = l.izquierdo;
    while(p!=NULL){
      if(p->dato == e){
        if((p==l.izquierdo)and(p==l.derecho)){
          l.izquierdo == NULL;
          l.derecho == NULL;
        }
        else if((p == l.izquierdo) and (p!=l.derecho)){
          l.izquierdo = p->sig;
          p->sig->ant = NULL;
        }
        else if((p != l.izquierdo) and (p==l.derecho)){
          l.derecho = p->ant;
          p->ant->sig = NULL;
        }
        else if((p != l.izquierdo) and (p!=l.derecho)){
          p->ant->sig = p->sig;
          p->sig->ant = p->ant;
        }
        p = p->sig;
        l.longitud-=1;
      }
      else{
        p = p->sig;
      }
    }
  }
}

void coger(lista & l, int n){
  while(l.longitud>n){
    elim_dr(l);
  }
}

void tirar(lista & l, int n){
  while(n>0 or is_vacia(l)){
    elim_iz(l);
    n-=1;
  }
}



bool is_vacia(lista & l){
  return (l.izquierdo==NULL);
}

void mostrar(int e){
  cout<<e<<" ";
}

void mostrar(lista & l, int i){//Meto int i solo para nombrar a cada lista como lista i.
  nodo* p = new nodo;
  p = l.izquierdo;
  cout<<"Lista "<<i<<": ";
  while(p != NULL){
    mostrar(p->dato);
    p = p->sig;
  }
  //mostrar(p->dato);
  cout<<endl;
}
















