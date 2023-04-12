# Creacion de las peticiones
import mysql.connector
import pandas as pd
import pyodbc
import random

mydb = mysql.connector.connect(
        host='localhost',
        database='Neto',
        user='*******',
        password='******')
mycursor = mydb.cursor()

# Creamos una tabla en Python con los niños tras el filtro

mycursor.execute("SELECT * FROM Niños")
Ninos = mycursor.fetchall()


peticiones=[]

def buscar_juguetes(edad,objetos,num):
    try:
        mycursor.reset()
        sql_buscar = """SELECT Nombre FROM juguetes WHERE %s <= edad_max AND %s >= edad_min ORDER BY RAND()"""
        mycursor.execute(sql_buscar, (edad,edad,))
        new=mycursor.fetchmany(num)
        for i in new:
            objetos.append(i)
        mycursor.reset()
    except mysql.connector.Error as error:
        print("Failed to get record from MySQL table: {}".format(error))


# Suponemos que la entrega de los juguetes se realizará el 25/12/2022
def crear_peticiones (children,list):
    try:
       sql_edad_query = """SELECT round(DATEDIFF('2022-12-25', Fecha_nacimiento)/365,0) as edad
                 FROM niños WHERE Nombre=%s AND Apellido=%s AND Coordenadas=%s"""
       for i in children:
            num = random.randint(0, 4)
            mycursor.execute(sql_edad_query, (i[0],i[1],i[2],))
            edad = mycursor.fetchone()
            objetos = []
            buscar_juguetes(edad[0],objetos,num)
            for j in objetos:
                record = i[0],i[1],i[2],j[0]
                list.append(record)
                mycursor.reset()
            mycursor.reset()
    except mysql.connector.Error as error:
        print("Failed to get record from MySQL table: {}".format(error))

crear_peticiones(Ninos,peticiones)

df = pd.DataFrame(peticiones, columns=['Nombre', 'Apellido', 'Coordenadas', 'Nombre_juguete'])

df.to_csv(
    r'C:\Users\bruno\OneDrive - Universidad Complutense de Madrid (UCM)\Primer Cuatrimestre\BasesDatos\export_dataframe_peticiones.csv',
    index=False, header=True)

#for i in peticiones:
#    print(i)

# Creamos los familiares
# Guardamos las coordenadas en las que hay más de un niño

mycursor.execute("SELECT Coordenadas, COUNT(Coordenadas) FROM Niños GROUP BY Coordenadas HAVING COUNT(Coordenadas) > 1")

reps = mycursor.fetchall()

#for row in reps:
#    print(row)


print("\nEstas son las parejas de familiares:")
parejas=[]
sql_parejas_query = """SELECT Nombre, Apellido, Coordenadas
        FROM niños WHERE Coordenadas=%s"""
for i in reps:
    mycursor.execute(sql_parejas_query, (i[0],))
    familiares = mycursor.fetchall()
    for j in familiares:
        for k in familiares:
            if (j < k):
                record = j[0], j[1], j[2], k[0], k[1], k[2]
                parejas.append(record)
for row in parejas:
    print(row)

fams = pd.DataFrame(parejas, columns=['Nombre_niño1', 'Apellido_niño1', 'Coordenadas_niño1', 'Nombre_niño2', 'Apellido_niño2', 'Coordenadas_niño2'])

fams.to_csv(
    r'C:\Users\bruno\OneDrive - Universidad Complutense de Madrid (UCM)\Primer Cuatrimestre\BasesDatos\export_dataframe_fams.csv',
    index=False, header=True)