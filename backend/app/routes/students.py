
from flask import Blueprint, request, jsonify

from mysql.connector import IntegrityError

from app.db import get_db_connection


# Create student Blueprint
students_bp = Blueprint("students", __name__)


# GET API - Retrieve all students
@students_bp.route("/api/students", methods=["GET"])
def get_students():

    connection = None
    cursor = None

    try:

        connection = get_db_connection()

        cursor = connection.cursor(dictionary=True)

        cursor.execute(
            "SELECT id, name, email, course, created_at "
            "FROM students ORDER BY id DESC"
        )

        students = cursor.fetchall()

        return jsonify({
            "success": True,
            "count": len(students),
            "data": students
        }), 200

    except Exception:

        return jsonify({
            "success": False,
            "message": "Unable to retrieve students"
        }), 500

    finally:

        if cursor:
            cursor.close()

        if connection and connection.is_connected():
            connection.close()


# GET API - Retrieve one student
@students_bp.route("/api/students/<int:student_id>", methods=["GET"])
def get_student(student_id):

    connection = None
    cursor = None

    try:

        connection = get_db_connection()

        cursor = connection.cursor(dictionary=True)

        cursor.execute(
            "SELECT id, name, email, course, created_at "
            "FROM students WHERE id = %s",
            (student_id,)
        )

        student = cursor.fetchone()

        if not student:

            return jsonify({
                "success": False,
                "message": "Student not found"
            }), 404

        return jsonify({
            "success": True,
            "data": student
        }), 200

    except Exception:

        return jsonify({
            "success": False,
            "message": "Unable to retrieve student"
        }), 500

    finally:

        if cursor:
            cursor.close()

        if connection and connection.is_connected():
            connection.close()


# POST API - Add new student
@students_bp.route("/api/students", methods=["POST"])
def add_student():

    data = request.get_json(silent=True)

    if not isinstance(data, dict):

        return jsonify({
            "success": False,
            "message": "A valid JSON request body is required"
        }), 400

    name = data.get("name", "").strip()

    email = data.get("email", "").strip()

    course = data.get("course", "").strip()

    # Validate required fields
    if not name or not email or not course:

        return jsonify({
            "success": False,
            "message": "Name, email and course are required"
        }), 400

    connection = None
    cursor = None

    try:

        connection = get_db_connection()

        cursor = connection.cursor()

        query = """
            INSERT INTO students (name, email, course)
            VALUES (%s, %s, %s)
        """

        cursor.execute(query, (name, email, course))

        connection.commit()

        student_id = cursor.lastrowid

        return jsonify({
            "success": True,
            "message": "Student added successfully",
            "data": {
                "id": student_id,
                "name": name,
                "email": email,
                "course": course
            }
        }), 201

    except IntegrityError:

        if connection:
            connection.rollback()

        return jsonify({
            "success": False,
            "message": "This email is already registered"
        }), 409

    except Exception:

        if connection:
            connection.rollback()

        return jsonify({
            "success": False,
            "message": "Unable to add student"
        }), 500

    finally:

        if cursor:
            cursor.close()

        if connection and connection.is_connected():
            connection.close()


# PUT API - Update student
@students_bp.route("/api/students/<int:student_id>", methods=["PUT"])
def update_student(student_id):

    data = request.get_json(silent=True)

    if not isinstance(data, dict):

        return jsonify({
            "success": False,
            "message": "A valid JSON request body is required"
        }), 400

    name = data.get("name", "").strip()

    email = data.get("email", "").strip()

    course = data.get("course", "").strip()

    if not name or not email or not course:

        return jsonify({
            "success": False,
            "message": "All fields are required"
        }), 400

    connection = None
    cursor = None

    try:

        connection = get_db_connection()

        cursor = connection.cursor()

        cursor.execute(
            """
            UPDATE students
            SET name = %s, email = %s, course = %s
            WHERE id = %s
            """,
            (name, email, course, student_id)
        )

        if cursor.rowcount == 0:

            cursor.execute(
                "SELECT id FROM students WHERE id = %s",
                (student_id,)
            )

            if not cursor.fetchone():

                return jsonify({
                    "success": False,
                    "message": "Student not found"
                }), 404

        connection.commit()

        return jsonify({
            "success": True,
            "message": "Student updated successfully"
        }), 200

    except IntegrityError:

        if connection:
            connection.rollback()

        return jsonify({
            "success": False,
            "message": "This email is already registered"
        }), 409

    except Exception:

        if connection:
            connection.rollback()

        return jsonify({
            "success": False,
            "message": "Unable to update student"
        }), 500

    finally:

        if cursor:
            cursor.close()

        if connection and connection.is_connected():
            connection.close()


# DELETE API - Delete student
@students_bp.route("/api/students/<int:student_id>", methods=["DELETE"])
def delete_student(student_id):

    connection = None
    cursor = None

    try:

        connection = get_db_connection()

        cursor = connection.cursor()

        cursor.execute(
            "DELETE FROM students WHERE id = %s",
            (student_id,)
        )

        if cursor.rowcount == 0:

            return jsonify({
                "success": False,
                "message": "Student not found"
            }), 404

        connection.commit()

        return jsonify({
            "success": True,
            "message": "Student deleted successfully"
        }), 200

    except Exception:

        if connection:
            connection.rollback()

        return jsonify({
            "success": False,
            "message": "Unable to delete student"
        }), 500

    finally:

        if cursor:
            cursor.close()

        if connection and connection.is_connected():
            connection.close()
