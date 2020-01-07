from lib import weights, addition, measures, simple, time_dhms, times

quizzes = [
    {
        "name": "weights",
        "title": "Weights (kg, g, mg)"
    }, 
    {
        "name": "time_dhms",
        "title": "Time (days, hours, minutes, seconds)"
    }, 
    {
        "name": "measures",
        "title": "Measures (length, volume, weight)"
    },
    {
        "name": "times1000000",
        "title": "Times tables (up to 1000000)"
    },
    {
        "name": "times1000",
        "title": "Times tables (up to 1000)"
    },
    {
        "name": "times100",
        "title": "Times tables (up to 100)"
    },
    {
        "name": "capitals",
        "title": "Capital cities"
    },
    {
        "name": "roman",
        "title": "Roman history"
    },
    {
        "name": "addition100000",
        "title": "Addition (up to 100000)"
    }
]

def generate_qas(get_qa, total, num_range):
    questions = []
    answers = []
    for i in range(total):
        q, a = get_qa(num_range)
        questions.append(q)
        answers.append(a)
    return questions, answers


def make_quiz(quiz, generate_qas, get_qa, total, goal, extra):
    quiz["total"] = total
    quiz["goal"] = goal
    quiz["questions"], quiz["answers"] = generate_qas(get_qa, total, extra)
    return quiz


def get_quiz(quiz=quizzes[0]):
    dispatch = {
        "weights": {"generate_qas": generate_qas, "get_qa": weights.get_qa, "total": 10, "goal": 9, "extra": 1000},
        "time_dhms": {"generate_qas": generate_qas, "get_qa": time_dhms.get_qa, "total": 20, "goal": 19, "extra": None},
        "measures": {"generate_qas": generate_qas, "get_qa": measures.get_qa, "total": 10, "goal": 9, "extra": 1000},
        "times1000000": {"generate_qas": generate_qas, "get_qa": times.get_qa, "total": 10, "goal": 9, "extra": 1000000},
        "times1000": {"generate_qas": generate_qas, "get_qa": times.get_qa, "total": 25, "goal": 23, "extra": 1000},
        "times100": {"generate_qas": generate_qas, "get_qa": times.get_qa, "total": 25, "goal": 23, "extra": 100},
        "capitals": {"generate_qas": simple.generate_qas, "get_qa": None, "total": 40, "goal": 38, "extra": "capitals"},
        "roman": {"generate_qas": simple.generate_qas, "get_qa": None, "total": 14, "goal": 13, "extra": "roman"},
        "addition100000": {"generate_qas": generate_qas, "get_qa": addition.get_qa, "total": 10, "goal": 9, "extra": 100000}
    }
    params = dispatch[quiz["name"]]
    return make_quiz(quiz, params["generate_qas"], params["get_qa"], params["total"], params["goal"], params["extra"])
