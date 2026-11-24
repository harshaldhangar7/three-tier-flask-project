
from flask import Blueprint, jsonify

from app.db import get_db_connection


health_bp = Blueprint("health", __name__)


# Application health check
@health_bp.route("/api/health", methods=["GET"])
def health():

    return jsonify({
        "status": "healthy",
        "service": "student-backend"
    }), 200


# Database connectivity check
@health_bp.route("/api/health/db", methods=["GET"])
def database_health():

    connection = None
    cursor = None

    try:

        connection = get_db_connection()

        cursor = connection.cursor()

        cursor.execute("SELECT 1")

        cursor.fetchone()

        return jsonify({
            "status": "healthy",
            "database": "connected"
        }), 200

    except Exception:

        return jsonify({
            "status": "unhealthy",
            "database": "disconnected"
        }), 503

    finally:

        if cursor:
            cursor.close()

        if connection and connection.is_connected():
            connection.close()
