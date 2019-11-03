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


def generate_qas(get_qa, total, num_range):
    questions = []
    answers = []
    for i in range(total):
        q, a = get_qa(num_range)
        questions.append(q)
        answers.append(a)
    return questions, answers


def make_quiz(quiz, get_qa, total, goal, num_range):
    quiz["total"] = total
    quiz["goal"] = goal
    quiz["questions"], quiz["answers"] = generate_qas(get_qa, total, num_range)
    return quiz


def get_quiz(quiz=quizzes[0]):
    dispatch = {
        "measures": {"get_qa": measures.get_qa, "total": 10, "goal": 8, "range": 1000},
        "times1000": {"get_qa": times.get_qa, "total": 25, "goal": 23, "range": 1000},
        "times100": {"get_qa": times.get_qa, "total": 25, "goal": 23, "range": 100}
    }
    params = dispatch[quiz["name"]]
    return make_quiz(quiz, params["get_qa"], params["total"], params["goal"], params["range"])
