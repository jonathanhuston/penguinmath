# times tables

import operator
import random

ops = {'+': operator.add, '-': operator.sub, '*': operator.mul, '/': operator.truediv}


def get_qa(num_range):
    op_sym, op = random.choice(list(ops.items()))
    while True:
        x = random.randint(0, num_range + 1)
        y = random.randint(0, num_range + 1)
        if (op_sym == "/") and (y == 0):
            continue
        a = op(x, y)
        if (a <= num_range) and (a == round(a)):
            break
    
    q = "{} {} {} = ?".format(x, op_sym, y)

    return q, str(round(a))


def generate_qas(total, num_range):
    questions = []
    answers = []
    for i in range(total):
        q, a = get_qa(num_range)
        questions.append(q)
        answers.append(a)
    return questions, answers
