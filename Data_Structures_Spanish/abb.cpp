template <typename T>
struct Nodo_arbol;

template <typename T>
using Abb =  Nodo_arbol<T> *;

template <typename T>
struct Nodo_arbol{
       T dato;
       Abb<T> hijo_izdo = NULL, hijo_dcho = NULL;
};

template <typename T>
Abb<T> abb_vacio(){
       return NULL;
}

template <typename T>
bool es_abb_vacio(Abb<T> a){
     return a == NULL;
}





/*template <typename T>
void insertar(Abb<T> & a,T e){
     if(es_abb_vacio(a)){
        a = new Nodo_arbol<T>; 
        a->dato = e;
     }
     else if(!(a->dato<= e)){
          insertar(a->hijo_izdo,e);
     }
     else{
          insertar(a->hijo_dcho,e);
     }
}*/

template <typename T>
void in_orden_aux(const Abb<T> & a,Secuencia<T> & s){
     if(!es_abb_vacio(a)){

          in_orden_aux( a->hijo_izdo, s);
          insertar(s,a->dato);
          in_orden_aux( a->hijo_dcho, s);
     }

}


template <typename T>
Secuencia<T> in_orden(const Abb<T> & a){
     Secuencia<T> result = crear<T>();
     in_orden_aux(a,result);
     return result;
}

template <typename T>
Secuencia<T> ordenar_abb(Secuencia<T> s){
      Abb<T> a=NULL;
      reiniciar(s);
      while(!fin(s)){
          insertar(a,actual(s));
          avanzar(s);
      }
      Secuencia<T> result = in_orden(a);
      //cout << a << endl;
      liberar(a);
      return  result;
}


template <typename T>
void liberar(Abb<T> & a){
       if(a!=NULL){
           liberar(a->hijo_izdo);
           liberar(a->hijo_dcho);
           delete a;
       }
}

template <typename T>
ostream & operator << (ostream & o, Abb<T> a){
       if(es_abb_vacio(a)){
         o << "*" ;
       }
       else{
          o << "(" << a->dato << "," << a->hijo_izdo << "," << a->hijo_dcho << ")";
       }
       return o;
}
