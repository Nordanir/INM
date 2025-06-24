from multiprocessing.forkserver import connect_to_new_process
import psycopg2

connection = psycopg2.connect(
    host="192.168.56.1",
    dbname="postgres",
    user="postgres",
    password="admin",
    port="5432",
)

current = connection.cursor()

current.execute(
    """CREATE TABLE IF NOT EXISTS person (
                id INT,
                name VARCHAR(255)
                );
                
                """
)

connection.commit()
current.close()
connection.close()
