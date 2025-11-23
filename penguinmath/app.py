import os

from flask import Flask, abort, jsonify, make_response, render_template
from flask_cors import CORS
from lib import generate

# Get the directory where this app.py file is located
basedir = os.path.abspath(os.path.dirname(__file__))

app = Flask(
    __name__,
    static_url_path="/static",
    static_folder=os.path.join(basedir, "static"),
    template_folder=os.path.join(basedir, "templates"),
)
CORS(app)


# Also serve static files at /penguinmath/static/
@app.route("/penguinmath/static/<path:filename>")
def penguinmath_static(filename):
    return app.send_static_file(filename)


# Also serve static files at /penguinmath/penguinmath/static/ (for subdomain with doubled prefix)
@app.route("/penguinmath/penguinmath/static/<path:filename>")
def penguinmath_static_double(filename):
    return app.send_static_file(filename)


@app.route("/")
@app.route("/penguinmath/")
def main():
    return render_template("index.html")


@app.route("/debug")
def debug():
    return jsonify(
        {
            "status": "ok",
            "basedir": basedir,
            "routes": [str(rule) for rule in app.url_map.iter_rules()],
        }
    )


# API routes with /penguinmath prefix
@app.route("/penguinmath/api/quizzes", methods=["GET"])
def get_quizzes_prefixed():
    headers = [{k: quiz[k] for k in ("name", "title")} for quiz in generate.quizzes]
    return jsonify({"quizzes": headers})


@app.route("/penguinmath/api/quizzes/<string:quizname>", methods=["GET"])
def get_quiz_prefixed(quizname):
    quiz = [quiz for quiz in generate.quizzes if quiz["name"] == quizname]
    if len(quiz) == 0:
        abort(404)
    return jsonify(generate.get_quiz(quiz[0]))


@app.route("/penguinmath/api/quiz", methods=["GET"])
def get_firstquiz_prefixed():
    return jsonify(generate.get_quiz())


# API routes with double /penguinmath/penguinmath prefix (for subdomain with Passenger BaseURI)
@app.route("/penguinmath/penguinmath/api/quizzes", methods=["GET"])
def get_quizzes_double():
    headers = [{k: quiz[k] for k in ("name", "title")} for quiz in generate.quizzes]
    return jsonify({"quizzes": headers})


@app.route("/penguinmath/penguinmath/api/quizzes/<string:quizname>", methods=["GET"])
def get_quiz_double(quizname):
    quiz = [quiz for quiz in generate.quizzes if quiz["name"] == quizname]
    if len(quiz) == 0:
        abort(404)
    return jsonify(generate.get_quiz(quiz[0]))


@app.route("/penguinmath/penguinmath/api/quiz", methods=["GET"])
def get_firstquiz_double():
    return jsonify(generate.get_quiz())


# API routes without /penguinmath prefix (for subdomain)
@app.route("/api/quizzes", methods=["GET"])
def get_quizzes():
    headers = [{k: quiz[k] for k in ("name", "title")} for quiz in generate.quizzes]
    return jsonify({"quizzes": headers})


@app.route("/api/quizzes/<string:quizname>", methods=["GET"])
def get_quiz(quizname):
    quiz = [quiz for quiz in generate.quizzes if quiz["name"] == quizname]
    if len(quiz) == 0:
        abort(404)
    return jsonify(generate.get_quiz(quiz[0]))


@app.route("/api/quiz", methods=["GET"])
def get_firstquiz():
    return jsonify(generate.get_quiz())


@app.errorhandler(404)
def not_found(error):
    return make_response(jsonify({"error": "Not found"}), 404)


if __name__ == "__main__":
    app.run(debug=True)
