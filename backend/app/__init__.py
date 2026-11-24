
from flask import Flask

from app.config import Config

from app.routes.students import students_bp

from app.routes.health import health_bp


# Application factory
def create_app():

    # Create Flask application
    app = Flask(__name__)

    # Load configuration
    app.config.from_object(Config)

    # Register student API routes
    app.register_blueprint(students_bp)

    # Register health API routes
    app.register_blueprint(health_bp)

    return app
