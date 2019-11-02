#!flask/bin/python
from flask import Flask, jsonify, make_response
from flask_cors import CORS
import generate

app = Flask(__name__)
CORS(app)

@app.route('/penguinmath/api/quiz', methods=['GET'])
def get_quiz():
    return jsonify(generate.quiz)


@app.errorhandler(404)
def not_found(error):
    return make_response(jsonify({'error': 'Not found'}), 404)


if __name__ == '__main__':
    app.run(debug=True)
