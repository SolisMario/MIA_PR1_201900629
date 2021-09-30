import json
import psycopg2
from psycopg2.extras import RealDictCursor

# ///////////////////////////////////////CREAR Y ELIMINAR TABLA TEMPORAL///////////////////////////////////////


def create_temporal():
    result = ""
    try:
        # Connect to an existing database
        connection = psycopg2.connect(user="postgres",
                                      password="postgres",
                                      database="blockbuster")

        # Create a cursor to perform database operations
        cursor = connection.cursor()

        # Executing query to create temporal table
        script = open("scripts/[MIA]ScriptTT_201900629.sql", "r").read()
        cursor.execute(script)
        cursor.execute("commit")
        result = "Se cargaron los datos a la tabla temporal con exito"

    except (Exception, psycopg2.DatabaseError) as error:
        result = "Error while executing query to PostgreSQL" + str(error)

    finally:
        if (connection):
            cursor.close()
            connection.close()
            print("PostgreSQL connection is closed")
        return result


def drop_temporal():
    result = ""
    try:
        connection = psycopg2.connect(user="postgres",
                                      password="postgres",
                                      database="blockbuster")

        cursor = connection.cursor()

        cursor.execute("TRUNCATE TABLE temporal;")
        cursor.execute("commit")
        result = "Se eliminaron los datos de la tabla temporal con exito"

    except (Exception, psycopg2.DatabaseError) as error:
        result = "Error while executing query to PostgreSQL" + str(error)

    finally:
        if (connection):
            cursor.close()
            connection.close()
            print("PostgreSQL connection is closed")
        return result

# ///////////////////////////////////////CREAR Y ELIMINAR MODELO///////////////////////////////////////


def create_modelo():
    result = ""
    try:
        connection = psycopg2.connect(user="postgres",
                                      password="postgres",
                                      database="blockbuster")

        cursor = connection.cursor()

        script = open("scripts/[MIA]ScriptMR_201900629.sql", "r").read()
        cursor.execute(script)
        script = open("scripts/[MIA]CargaDeDatos_201900629.sql", "r").read()
        cursor.execute(script)
        cursor.execute("commit")
        result = "Se crearon las tablas y se cargaron los datos del modelo con exito"

    except (Exception, psycopg2.DatabaseError) as error:
        result = "Error while executing query to PostgreSQL" + str(error)

    finally:
        if (connection):
            cursor.close()
            connection.close()
            print("PostgreSQL connection is closed")
        return result


def drop_modelo():
    result = ""
    try:
        connection = psycopg2.connect(user="postgres",
                                      password="postgres",
                                      database="blockbuster")

        cursor = connection.cursor()
        script = open("scripts/[MIA]ScriptEliminarModelo.sql", "r").read()
        cursor.execute(script)
        cursor.execute("commit")
        result = "Se eliminaron las tablas del model con exito"

    except (Exception, psycopg2.DatabaseError) as error:
        result = "Error while executing query to PostgreSQL" + str(error)

    finally:
        if (connection):
            cursor.close()
            connection.close()
            print("PostgreSQL connection is closed")
        return result

#////////////////////////////////////////////CONTEOS////////////////////////////////////
def counts():
    counts = []
    try:
        connection = psycopg2.connect(user="postgres",
                                      password="postgres",
                                      database="blockbuster")

        cursor = connection.cursor(cursor_factory=RealDictCursor)

        script = open("scripts/[MIA]Conteos_201900629.sql", "r").read()
        queries = script.split('\n')
        for query in queries:
            cursor.execute(query)
            result = cursor.fetchone()
            counts.append(json.dumps(result))

    except (Exception, psycopg2.DatabaseError) as error:
        counts = "Error while executing query to PostgreSQL" + str(error)

    finally:
        if (connection):
            cursor.close()
            connection.close()
            print("PostgreSQL connection is closed")
        return counts
