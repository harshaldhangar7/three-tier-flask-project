
# import os
# from dotenv import load_dotenv

# # Load .env for local development.
# # Kubernetes environment variables take precedence.
# load_dotenv()

# class Config:

#     # MySQL database configuration
#     DB_HOST = os.getenv("DB_HOST")
#     DB_PORT = int(os.getenv("DB_PORT", "3306"))
#     DB_USER = os.getenv("DB_USER")
#     DB_PASSWORD = os.getenv("DB_PASSWORD")
#     DB_NAME = os.getenv("DB_NAME")

#     # Flask configuration
#     SECRET_KEY = os.getenv("SECRET_KEY")
#     DEBUG = os.getenv("FLASK_DEBUG", "false").lower() == "true"


import os
import json
import boto3

from dotenv import load_dotenv

# Load .env for local development.
load_dotenv()


def get_database_config():

    # Local development:
    # Use credentials from the .env file.
    if os.getenv("DB_PASSWORD"):

        return {
            "host": os.getenv("DB_HOST"),
            "port": int(os.getenv("DB_PORT", "3306")),
            "user": os.getenv("DB_USER"),
            "password": os.getenv("DB_PASSWORD"),
            "database": os.getenv("DB_NAME")
        }

    # Production:
    # Retrieve credentials from AWS Secrets Manager.
    secret_arn = os.getenv("DB_SECRET_ARN")
    region = os.getenv("AWS_REGION", "ap-south-1")

    if not secret_arn:
        raise ValueError("DB_SECRET_ARN is not configured")

    client = boto3.client(
        "secretsmanager",
        region_name=region
    )

    response = client.get_secret_value(
        SecretId=secret_arn
    )

    secret = json.loads(response["SecretString"])

    return {
        "host": secret["host"],
        "port": int(secret.get("port", 3306)),
        "user": secret["username"],
        "password": secret["password"],
        "database": secret.get("dbname") or os.getenv("DB_NAME")
    }


class Config:

    # Flask configuration.
    SECRET_KEY = os.getenv("SECRET_KEY")

    DEBUG = (
        os.getenv("FLASK_DEBUG", "false").lower() == "true"
    )

