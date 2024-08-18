
const string FLECHA = "↓";

template <typename T>
struct Nodo_sec{
       T dato;
       Nodo_sec<T> * sig = NULL;
};

template <typename T>
struct Secuencia{
  Nodo_sec<T> * primero;
  Nodo_sec<T> * anterior; //puntero al anterior al actual
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
    throw runtime_error(" final de la  secuencia");
  }
};

template <typename T>
T actual(const Secuencia<T>& s){
  if(s.anterior->sig != NULL){
    return s.anterior->sig->dato;
  }
  else{
    throw runtime_error(" final de la  secuencia");
  }
};

template<typename T>
void avanzar(Secuencia<T>& s){
  if(s.anterior->sig != NULL){
    s.anterior = s.anterior->sig;
  }
  else{
    throw runtime_error("final de la  secuencia");
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


template<typename T>
void mostrar(Secuencia<T> s){
    Nodo_sec<T> * aux = s.primero;
    while(aux->sig != NULL){
      if(aux == s.anterior){
        cout << FLECHA;
      }
      mostrar(aux->sig->dato);
      cout <<  " ";
      aux = aux->sig;
    }
    cout << endl;
}

template<typename T>
ostream & operator <<(ostream & o, Secuencia<T> s){
  Nodo_sec<T> * aux = s.primero;
  while(aux->sig != NULL){
    if(aux == s.anterior){
      o << FLECHA;
    }
    o << aux->sig->dato;
    o <<  " ";
    aux = aux->sig;
  }
  o << endl;
  return o;
}

template <typename T>
bool es_vacia(Secuencia<T> s){
    return s.primero->sig == NULL;
}
