import measures
import times

quizzes = [
    {
        "name": "measures",
        "title": "Measures (length, volume, weight)"
    },
    {
        "name": "times1000",
        "title": "Times tables (up to 1000)"
    },
    {
        "name": "times100",
        "title": "Times tables (up to 100)"
    }
]


def get_quiz(quiz=quizzes[0]):
    dispatch = {
        "measures": measures.make_quiz(quiz),
        "times1000": times.make_quiz(quiz, 1000),
        "times100": times.make_quiz(quiz, 100)
    }
    return dispatch[quiz["name"]]
