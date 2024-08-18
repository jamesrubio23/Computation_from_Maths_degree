#include <iostream>

using namespace std;

const string FLECHA = "↓";

template <typename T>
struct Nodo_sec{
       T dato;
       Nodo_sec<T> * sig;
};

template <typename T>
struct Secuencia{
  Nodo_sec<T> * primero;
  Nodo_sec<T> * anterior; //puntero al anterior al actual
};

struct par_int{
  int primero ;
  int segundo ;
};

par_int new_par(int p,int s){
    par_int result;
    result.primero = p;
    result.segundo = s;
    return result;
};

bool operator <=(par_int e1,par_int e2){
  return e1.segundo<=e2.segundo;
};

void mostrar(par_int e){
    cout << "("<<e.primero<<","<<e.segundo<<")";
};


template <typename T>
Secuencia<T> crear(){
  Secuencia<T> s;
  s.primero = new Nodo_sec<T>;
  s.anterior = s.primero;
  return s;
};

template <typename T>
void insertar(Secuencia<T>& s,T e){
  Nodo_sec<T> * new_node = new Nodo_sec<T>;
  new_node->dato = e;
  new_node->sig = s.anterior->sig;
  s.anterior->sig = new_node;
  s.anterior = new_node;
};


template <typename T>
void eliminar(Secuencia<T>& s){
  if(s.anterior->sig != NULL){
    Nodo_sec<T> * aux = s.anterior->sig;
    s.anterior->sig = aux->sig;
    delete aux;
  }
  else{
    throw runtime_error(" Final de la  secuencia");
  }
};

template <typename T>
T actual(const Secuencia<T>& s){
  if(s.anterior->sig != NULL){
    return s.anterior->sig->dato;
  }
  else{
    throw runtime_error(" Final de la  secuencia");
  }
};

template<typename T>
Nodo_sec<T> * ultimo(Secuencia<T> s){
  Nodo_sec<T> * actual = s.primero;
  while(actual->sig != NULL){
    actual = actual->sig;
  }
  return actual;
}

template<typename T>
void pivotar(Nodo_sec<T>* n, Nodo_sec<T>* m){
  Nodo_sec<T> * aux_1 = n->sig;
  n->sig = aux_1->sig;
  Nodo_sec<T> * aux_2 = m->sig;
  m->sig=aux_1;
  aux_1->sig = aux_2;
}

template<typename T>
void avanzar(Secuencia<T>& s){
  if(s.anterior->sig != NULL){
    s.anterior = s.anterior->sig;
  }
  else{
    throw runtime_error(" Final de la  secuencia");
  }
}

template<typename T>
void reiniciar(Secuencia<T>& s){
  s.anterior = s.primero;
}

template<typename T>
bool fin(Secuencia<T> s){
  return s.anterior->sig == NULL;
}

template<typename T>
void liberar(Secuencia<T> s){
     reiniciar(s);
     while(!fin(s)){
         eliminar(s);
     }
     delete s.primero;
}


template<typename T>  // debe existir una procedimiento void mostrar(T dato) que mande
                      //la representación de dato a cout
void mostrar(Secuencia<T> s){
    Nodo_sec<T> * aux = s.primero;
    while(aux->sig != NULL){
      if(aux == s.anterior){
        cout << FLECHA;
      }
      mostrar(aux->sig->dato);
      cout <<  " " << endl;
      aux = aux->sig;
    }
    cout << endl;
}


//template <T> // T debe tener definido el operador <=
//void ordenar(Secuencia<T>& s) //ordena la secuencia s,00
template<typename T>
void quicksort(Secuencia<T> & s){
  Nodo_sec<T>* izq = s.primero;
  Nodo_sec<T>* der = ultimo(s);
  ordenar(izq,der);
}

template<typename T>
void ordenar(Nodo_sec<T>* left, Nodo_sec<T>* right){
  if(left != right){
    T pivot = right->dato;
    Nodo_sec<T>* actual = left;
    Nodo_sec<T>* ultimo = right;
    while(actual->sig != right){
      if(!(actual->sig->dato<=pivot)){
        pivotar(actual,right);
        if(ultimo==right){
          ultimo=right->sig;
        }
      }
      else{
        actual=actual->sig;
      }
    }
    ordenar(left,actual);
    ordenar(right,ultimo);
  }
}


int main(){
    Secuencia<par_int> s = crear<par_int>();
    for(int i = 0; i< 100; i++){
      int n = rand() % 50;
      insertar(s,new_par(i,n));
    }
    reiniciar(s);
	mostrar(s);
	s1 = quick_sort(s);
    quicksort(s);
	mostrar(s1);
    liberar(s);
    liberar(s1);
    return 0;
}