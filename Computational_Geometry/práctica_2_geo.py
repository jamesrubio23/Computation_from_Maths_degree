import random
import string
import numpy as np
import matplotlib.pyplot as plt
from shapely.geometry import LineString, Point
import itertools

# ################################ PARTE 1 #####################################

#Generamos 1000 segmentos aleatorios, pero siempre serán los mismos

#Usaremos primero el concepto de coordenadas
X = []
Y = []

#Fijamos el modo aleatorio con una versión prefijada
random.seed(a=0, version=2)

#Generamos subconjuntos cuadrados del plano R2 para determinar los rangos de X e Y
xrango1 = random.sample(range(100, 1000), 200)
xrango2 = list(np.add(xrango1, random.sample(range(10, 230), 200)))
yrango1 = random.sample(range(100, 950), 200)
yrango2 = list(np.add(yrango1, random.sample(range(10, 275), 200)))
        
for j in range(len(xrango1)):
    for i in range(5):
        random.seed(a=i, version=2)
        xrandomlist = random.sample(range(xrango1[j], xrango2[j]), 4)
        yrandomlist = random.sample(range(yrango1[j], yrango2[j]), 4)
        X.append(xrandomlist[0:2])
        Y.append(yrandomlist[2:4])

Segmentos=[]
for i in range(len(X)):
    Point1=Point(X[i][0],Y[i][0])
    Point2=Point(X[i][1],Y[i][1])
    Segment=LineString([Point1, Point2])
    Segmentos.append(Segment)
    
def componentes_conexas(Segments):
    dicc=dict()
    for i in range(len(Segments)):
        dicc[i]=[]
        for j in range(len(Segments)):
            if (j!=i) and (Segments[i].intersects(Segments[j])):
                dicc[i].append(j)
    n=0
    l=[]
    comp=0
    while len(l)<len(dicc):
        if not(n in l):
            l= recursive(n,l,dicc)
            comp+=1
        n+=1
    return comp

def recursive(numero,lista,diccionario):
    lista.append(numero)
    for i in diccionario[numero]:
        if not(i in lista):
            lista=recursive(i,lista,diccionario)
    return lista


for i in range(len(X)):
    plt.plot(X[i],Y[i],'b')
plt.show()

print(componentes_conexas(Segmentos))
# ############################# PARTE 2 #############################

#Tomamos el listado de letras del alfabeto para construir un generador de conjuntos
alphabet = list(string.ascii_lowercase)
generator = alphabet
for i in range(len(alphabet)):
    for j in range(len(alphabet)):
        generator = np.append(generator, generator[i]+alphabet[j])
        
#Fijamos la configuración de un determinado conjunto aleatorio (¡siempre será el mismo!)
random.seed(a=0, version=1)

#Fijamos un número de conjuntos, y asignamos un cardinal diferentes a cada uno de ellos
nsets = 100
cardinals = random.sample(range(0, int(len(generator)/4)), nsets)

#Generamos los conjuntos "aleatorios" (prefijados), sin repeticiones
Sets = []
for i in range(nsets):
    random.seed(a=i, version=2)
    index_random = random.sample(range(0, len(generator)), cardinals[i])
    newset = list(np.array(generator)[index_random])
    Sets.append(newset)

def interseccion():
    intersección = []
    for i in range(len(Sets)-1):
        inter = set(Sets[i]).intersection(Sets[i+1])
        intersección = set(inter).intersection(intersección)
    print("El número de componentes de la intersección es: {0}".format(len(intersección)))

def union():
    union = []
    for i in range(len(Sets)-1):
        uni = set(Sets[i]).union(Sets[i+1])
        union = set(uni).union(union)
    print("El número de componentes de la unión es: {0}".format(len(union)))


def comprobar(subset, empty):
    for element in empty:
        if element in subset:
            return False
    return True


def A_size(sets):
    sets = [set(elem) for elem in sets]
    return len(set.union(*sets))

def B_size(sets):
    sum = 0
    empty = []
    sets = [set(elem) for elem in sets]
    for i in range(1, len(sets) + 1):
        for subset in itertools.combinations(sets, i):
            if comprobar(list(subset),empty):
                a = (-1)**(i+1) * len(set.intersection(*subset))
                if a == 0 and len(list(subset))==2:
                    empty.append(list(subset))
                sum += a
        print(i)
    return sum

union()
interseccion()
