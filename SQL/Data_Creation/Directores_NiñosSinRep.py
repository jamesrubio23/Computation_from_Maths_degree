
import mysql.connector
import pandas as pd

mydb = mysql.connector.connect(
        host='localhost',
        database='Bruto',
        user='******',
        password='******')
mycursor = mydb.cursor()

# Selección de directores de los departamentos

def crear_directores(num,list):
    try:
        sql_select_query = """SELECT NSS FROM Elfos WHERE contrato_completo = 1 AND codigo_departamento = %s ORDER BY RAND() LIMIT 1"""
        # set variable in query
        mycursor.execute(sql_select_query, (num,))
        # fetch result
        record = mycursor.fetchone()
        for i in record:
            list.append(i)

        mycursor.reset()
    except mysql.connector.Error as error:
        print("Failed to get record from MySQL table: {}".format(error))

numdepartamentos=[1,2,3,4,5,6,7,8,9]
directores=[]
for i in numdepartamentos:
    crear_directores(i,directores)

print("\Directores:")
for i in directores:
    print(i)
direc = pd.DataFrame(list(zip(directores,numdepartamentos)), columns=['NSS_director','codigo'])
print(direc)
direc.to_csv(
    r'C:\Users\bruno\OneDrive - Universidad Complutense de Madrid (UCM)\Primer Cuatrimestre\BasesDatos\export_dataframe_directores.csv',
    index=False, header=False)

# Mostramos los elfos que se encargan de más de un niño
mycursor.execute("SELECT NSS_elfo, COUNT(NSS_elfo) FROM Niños GROUP BY NSS_elfo HAVING COUNT(NSS_elfo) > 1")

reps = mycursor.fetchall()

print("\nRepeticiones:")
for row in reps:
    print(row)

aborrar=[]

print("\nNiños que tenemos que eliminar de la tabla Niños:")


def appendto_by_nss(nss,rep,list):
    try:
        sql_select_query = """select * from niños where nss_elfo = %s ORDER BY RAND()"""
        # set variable in query
        mycursor.execute(sql_select_query, (nss,))
        # fetch result
        record = mycursor.fetchmany(rep-1)
        for i in record:
            list.append(i)
        #list.append(record)

        mycursor.reset()
    except mysql.connector.Error as error:
        print("Failed to get record from MySQL table: {}".format(error))


for row in reps:
    appendto_by_nss(row[0],row[1],aborrar)

for row in aborrar:
    print(row)

# Borramos a los niños que hemos decidido borrar por no cumplir las restricciones#

print("\nMostramos la lista final de los niños:")

def delete_children(list):
    try:
        for row in list:
            sql_delete_query = """DELETE FROM niños WHERE Nombre = %s AND Apellido = %s AND Coordenadas = %s """
            mycursor.execute(sql_delete_query, (row[0],row[1],row[2],))
        mycursor.execute("SELECT * FROM niños")
        final = mycursor.fetchall()
        for row in final:
            print(row)
        df = pd.DataFrame(final, columns=['Nombre', 'Apellido', 'Coordenadas', 'Fecha_nacimiento', 'NSS_elfo'])

        df.to_csv(r'C:\Users\bruno\OneDrive - Universidad Complutense de Madrid (UCM)\Primer Cuatrimestre\BasesDatos\export_dataframe_ninos.csv', index=False, header=True)
        mycursor.reset()
    except mysql.connector.Error as error:
        print("Failed to get record from MySQL table: {}".format(error))

delete_children(aborrar)

