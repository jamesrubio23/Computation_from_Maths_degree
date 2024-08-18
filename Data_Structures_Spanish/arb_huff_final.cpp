#include <iostream>
#include <string>
#include <queue>
#include <unordered_map>
#include "TablaFrecuencias.cpp"
#include <list>
#include <map>
using namespace std;



struct Node {
    char data;//Cualquier caracter
    int freq;//Frecuencia del caracter
    Node* left;//Hijo izquierdo del nodo
    Node* right;//Hijo derecho del nodo
    
    
    Node(char character,
                    int frequency)
    {
        data = character;
        freq = frequency;
        left = right = NULL;
    }
};

map<char, string> codes;
map<char, int> freq;

void printStoreCodes(struct Node* root,string str){//Se encarga de sacar la tabla de codigos y guardarlos
   if(!root){
       return;
   }
   //Si data de Node* no es $, es decir no es un nodo interno, enseñaremos y almacenaremos el string str en nuestra tabla de codigos
   if(root->data!='$'){
       cout<<root->data<<": "<<str<<endl;
       codes[root->data]=str;
   }

   printStoreCodes(root->left,str+"0");
   printStoreCodes(root->right,str+"1");
}



void calculoFreq(string text){//Se encarga de guardar la tabla de frecuancias
   for(char ch:text){
      freq[ch]++;
   }
}



struct comp{

    bool operator()(Node* a,Node* b)
    {
        return (a->freq > b->freq);
    }
};


priority_queue<Node*, vector<Node*>, comp> pq;

void buildHuffmanTree()
{

        struct Node *left, *right, *top;
	//Creamos el nodo para cada caracter y se lo añadimos a la cola de prioridad
	for(auto pair: freq){
	   pq.push(new Node(pair.first,pair.second));
	}

	while (pq.size() != 1)//Hasta que no haya mas de un nodo en la cola de prioridad
	{
		//Insertamos los 2 nodos con la frecuencia mas baja de la cola de prioridad y lo eliminamos de la cola de prioridad.
		Node *left = pq.top();
		pq.pop();
		Node *right = pq.top();
		pq.pop();
		//Creamos un nodo interno por encima de estos 2 nodos sumando las frecuencias de dichos nodos.Añadimos el nuevo nodo a la cola de prioridad.
                Node* suma = new Node('$',left->freq + right->freq);
                suma->left = left;
                suma->right = right;
		
		pq.push(suma);
	}
	printStoreCodes(pq.top(),"");
	
	}

string decode_file(struct Node* root, string s){//Se encarga de decodificar la cadena de 0's y 1's
    string ans = ""; 
    struct Node* actual = root; 
    for (int i=0;i<s.size();i++) 
    { 
        if (s[i] == '0') 
           actual = actual->left; 
        else
           actual = actual->right; 
  
        if (actual->left==NULL and actual->right==NULL) 
        { 
            ans += actual->data; 
            actual = root; 
        } 
    } 
    return ans+'\0'; 
}




int main(){
  string file_name;
  cout << "Nombre del archivo"<<endl;
  cin >> file_name;
  ifstream f;
  f.open(file_name);
  Tabla_frec t = tabla_vacia();
  int cont=0;
  string str="";
  cout<<"Tabla de frecuencias:"<<endl;
  if(leer(file_name,t,cont,str)){
       cout<<in_orden(t)<<endl;
       cout<<"Tamaño del archivo: "<<cont<<endl;
  }
  
  calculoFreq(str);
  string encode_string="";
  cout<<endl;
  cout<<"Tabla de codigos:"<<endl;
  buildHuffmanTree();
  vector<bool> result;
  result.reserve(encode_string.size());
  for(char i : str){
    encode_string+=codes[i]; 
  }
  for(char a:encode_string){
     result.push_back(a=='1');
  }
  cout<<endl;
  cout<<"Mensaje codificado:"<<endl;
  cout<<encode_string<<endl;
  cout<<endl;
  string salida = decode_file(pq.top(),encode_string);
  cout<<"Mensaje descodificado:"<<endl;
  cout<<salida<<endl;
  return 0;
}



