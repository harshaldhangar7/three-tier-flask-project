
from app import create_app

# Initialize Flask application
app = create_app()


# Local development server
if __name__ == "__main__":

    app.run(
        host="0.0.0.0",
        port=5000,
        debug=app.config["DEBUG"]
    )
