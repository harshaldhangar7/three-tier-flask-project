
import os
from dotenv import load_dotenv

# Load .env for local development.
# Kubernetes environment variables take precedence.
load_dotenv()

class Config:

    # MySQL database configuration
    DB_HOST = os.getenv("DB_HOST")
    DB_PORT = int(os.getenv("DB_PORT", "3306"))
    DB_USER = os.getenv("DB_USER")
    DB_PASSWORD = os.getenv("DB_PASSWORD")
    DB_NAME = os.getenv("DB_NAME")

    # Flask configuration
    SECRET_KEY = os.getenv("SECRET_KEY")
    DEBUG = os.getenv("FLASK_DEBUG", "false").lower() == "true"
