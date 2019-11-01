#!flask/bin/python
from flask import Flask, abort, jsonify, make_response

app = Flask(__name__)

quizzes = [
    {
        "name": "measures",
        "title": "Measures (m, l, g)",
        "total": 3,
        "goal": 2,
        "questions" : [
            "How many meters is 5 km and 350 m?",
            "How many liters is 5 dl and 3 cl?"
            "How many grams is 10 kg and 1000 mg?"
        ],
        "answers" : [
            "5350",
            "0.53",
            "10001"
        ]
    },
    {
        "name": "times1000",
        "title": "Times tables (up to 1000)",
        "total": 5,
        "goal": 4,
        "questions" : [
            "What is 5 x 20?",
            "What is 1000 / 4?",
            "What is 987 - 298?",
            "What is 288 + 599?",
            "What is 333 x 3?"
        ],
        "answers" : [
            "100",
            "250",
            "689",
            "887",
            "999"
        ]
    }

]


@app.route('/penguinmath/api/quizzes', methods=['GET'])
def get_quizzes():
    return jsonify({'quizzes': quizzes})


@app.route('/penguinmath/api/quizzes/<string:quiz_name>', methods=['GET'])
def get_quiz(quiz_name):
    quiz = [quiz for quiz in quizzes if quiz['name'] == quiz_name]
    if len(quiz) == 0:
        abort(404)
    return jsonify({'quiz': quiz[0]})


@app.errorhandler(404)
def not_found(error):
    return make_response(jsonify({'error': 'Not found'}), 404)


if __name__ == '__main__':
    app.run(debug=True)
