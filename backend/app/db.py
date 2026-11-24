
import mysql.connector

from app.config import Config


# Create a new MySQL connection
def get_db_connection():

    connection = mysql.connector.connect(

        host=Config.DB_HOST,

        port=Config.DB_PORT,

        user=Config.DB_USER,

        password=Config.DB_PASSWORD,

        database=Config.DB_NAME,

        connection_timeout=5

    )

    return connection
