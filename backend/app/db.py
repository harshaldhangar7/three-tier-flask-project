
# import mysql.connector

# from app.config import Config


# # Create a new MySQL connection
# def get_db_connection():

#     connection = mysql.connector.connect(

#         host=Config.DB_HOST,

#         port=Config.DB_PORT,

#         user=Config.DB_USER,

#         password=Config.DB_PASSWORD,

#         database=Config.DB_NAME,

#         connection_timeout=5

#     )

#     return connection


import mysql.connector

from app.config import get_database_config


# Create a new MySQL connection
def get_db_connection():

    # Get database credentials.
    # Local: Read from .env
    # EKS: Read from AWS Secrets Manager
    db_config = get_database_config()

    # Establish MySQL connection
    connection = mysql.connector.connect(

        **db_config,

        connection_timeout=5

    )

    return connection
