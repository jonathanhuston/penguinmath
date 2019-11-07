# addition

import random


def get_qa(num_range):
    op_sym = "+"
    while True:
        x = random.randint(0, num_range + 1)
        y = random.randint(0, num_range + 1)
        a = x + y
        if (a <= num_range) and (a == round(a)):
            break
    
    q = "{} + {} = ?".format(x, y)

    return q, str(round(a))


def generate_qas(total, num_range):
    questions = []
    answers = []
    for i in range(total):
        q, a = get_qa(num_range)
        questions.append(q)
        answers.append(a)
    return questions, answers
