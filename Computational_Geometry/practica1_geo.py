

import numpy as np

from sklearn.cluster import KMeans
from sklearn import metrics
from sklearn.datasets import make_blobs
from scipy.spatial import ConvexHull
from scipy.spatial import Voronoi, voronoi_plot_2d

import matplotlib.pyplot as plt
import math

# #############################################################################
# Aquí tenemos definido el sistema X de 1000 elementos de dos estados
# construido a partir de una muestra aleatoria entorno a unos centros:
initial_centers = [[-0.5, -2], [1, -1], [-1, 1], [-0.5, 0.5]]
X, labels_true = make_blobs(n_samples=1000, centers=initial_centers, cluster_std=0.4,
                            random_state=0)

#Otra posibilidad sería generar valores totalmente aleatorios de esta forma
#X = np.random.rand(100, 2)   # 30 random points in 2-D

#Si quisieramos estandarizar los valores del sistema, haríamos:
#from sklearn.preprocessing import StandardScaler
#X = StandardScaler().fit_transform(X)  
"""
plt.plot(X[:,0],X[:,1],'ro', markersize=1)
plt.show()
"""
# #################### PARTE 1 ################################################

hull = ConvexHull(X)
print(hull.simplices)
for simplex in hull.simplices:
    plt.plot(X[simplex,0],X[simplex,1],'g')
plt.plot(X[:,0],X[:,1],'ro', markersize=1)
plt.show() 

# ##################### PARTE 2 ###############################################
# Obtención del número de vecindades de Voronói óptimo según Silhouette
# Suponemos que es:    

mayor_coef_silhouette=-1
i=2
coefs=[]
while i<=15:
    n_clusters = i
    kmeans = KMeans(n_clusters=n_clusters, init='random', n_init=1, random_state=0, max_iter=1000) 
    kmeans.fit(X) #computes Kmeans clustering
    # Índice de los centros de vencindades o regiones de Voronoi para cada elemento (punto) 
    centers = kmeans.cluster_centers_ 
    y_kmeans = kmeans.predict(X) 
    labels = kmeans.labels_
    silhouette = metrics.silhouette_score(X, labels)
    if silhouette>mayor_coef_silhouette:
        mayor_coef_silhouette=silhouette
        best_n_clusters=n_clusters#nos dice los centroides mas optimos
    coefs.append(silhouette)
    i+=1
kmeans_best = KMeans(n_clusters=best_n_clusters, init='random', n_init=1, random_state=0, max_iter=1000) 
kmeans_best.fit(X) #computes Kmeans clustering
centers = kmeans_best.cluster_centers_ 
y_kmeans = kmeans_best.predict(X) 
labels = kmeans_best.labels_
mayor_coef_silhouette  
 
print(labels)
print(centers)
print("Silhouette Coefficient: %0.3f" % mayor_coef_silhouette)

#para ver los coeficientes respecto a k
k=2
i=0
while k<=15:
   plt.plot(coefs[i],k,'ro', markersize=1)   
   k+=1
   i+=1
plt.title("coef silhouette respecto al numero de clusters")
plt.show()


 


   
#apartado c) Diagrama de Voronói (para más de dos centros!)


#grafico con centroides, puntos divididos por vecinindades
vor = Voronoi(centers) 
voronoi_plot_2d(vor)

plt.scatter(X[:, 0], X[:, 1], c=y_kmeans, s=5, cmap='summer') 
plt.scatter(centers[:, 0], centers[:, 1], c='black', s=100, alpha=0.5)
plt.title("Diagrama de Voronoi")
#diagrama de voronoi

plt.show()
"""
print(f"{vor.regions}")
"""
# #############################################################################
# Predicción de elementos para pertenecer a una clase:
"""
def min_centro(value):
    #Vamos a suponer inicialmente que el centers[0] es el minimo
    distance=math.sqrt((value[0]-centers[0][0])**2+(value[1]-centers[0][1])**2)
    nearest_center=centers[0]
    for i in range(len(centers)):
        d=math.sqrt((value[0]-centers[i][0])**2+(value[1]-centers[i][1])**2)
        if d<distance:
            distance=d
            nearest_center=centers[i]
    return nearest_center
"""       
        
        
        


problem = np.array([[0, 0], [-0.5, -1]])
clases_pred = kmeans_best.predict(problem)

for i in range(len(problem)):
    print(f" {problem[i]} pertenece a la region con centro {centers[clases_pred[i]]} ")







