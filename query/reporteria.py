import psycopg2
from psycopg2.extras import RealDictCursor
import json


def consultan(n):
    result = None
    try:
        # Connect to an existing database
        connection = psycopg2.connect(user="postgres",
                                      password="postgres",
                                      database="blockbuster")

        # Create a cursor to perform database operations
        cursor = connection.cursor(cursor_factory=RealDictCursor)

        # Executing query to create temporal table
        script = open("scripts/[MIA]Reporteria_201900629.sql", "r").read()
        queries = script.split('--\n')
        cursor.execute(queries[n])
        result = json.dumps(cursor.fetchall())

    except (Exception, psycopg2.DatabaseError) as error:
        #print("Error while executing query to PostgreSQL", error)
        result = "Error while executing query to PostgreSQL" + str(error)

    finally:
        if (connection):
            cursor.close()
            connection.close()
            print("PostgreSQL connection is closed")
        return result