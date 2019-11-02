#!flask/bin/python
from flask import Flask, abort, jsonify, make_response
from flask_cors import CORS
import generate

app = Flask(__name__)
CORS(app)


@app.route('/penguinmath/api/quizzes', methods=['GET'])
def get_quizzes():
    return jsonify({"quizzes:": generate.quizzes})


@app.route('/penguinmath/api/quizzes/<string:quizname>', methods=['GET'])
def get_quiz(quizname):
    quiz = [quiz for quiz in generate.quizzes if quiz["name"] == quizname]
    if len(quiz) == 0:
        abort(404)
    return jsonify(generate.get_quiz(quiz[0]))


@app.route('/penguinmath/api/quiz', methods=['GET'])
def get_firstquiz():
    return jsonify(generate.get_quiz())


@app.errorhandler(404)
def not_found(error):
    return make_response(jsonify({"error": "Not found"}), 404)


if __name__ == '__main__':
    app.run(debug=True)
