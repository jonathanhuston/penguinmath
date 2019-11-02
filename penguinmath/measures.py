# measures (length, volume, weight)

import random

multiples = [["mm", "cm", "dm", "m", "km"], ["ml", "cl", "dl", "l"], ["mg", "g", "kg"]]
values = [[0.001, 0.01, 0.1, 1, 1000], [0.001, 0.01, 0.1, 1], [0.001, 1, 1000]]

def get_qa():
    i = random.randint(0, 2)
    measure_category = multiples[i]
    value_category = values[i]

    l = len(measure_category)
    ti = random.randint(0, l-2)
    s1i = random.randint(ti, l-1)
    s2i = random.randint(ti, l-1)
    if s1i < s2i:
        temp = s1i
        s1i = s2i
        s2i = temp

    tm = measure_category[ti]
    tv = value_category[ti]
    s1m = measure_category[s1i]
    s1v = value_category[s1i]
    s2m = measure_category[s2i]
    s2v = value_category[s2i]

    f1 = random.randint(0, 1000)
    f2 = random.randint(0, 1000)
    
    q = "How many {} are {} {} and {} {}?".format(tm, str(f1), s1m, str(f2), s2m)
    a = str(round((f1 * s1v + f2 * s2v) / tv))

    return q, a


def generate_qas(num):
    questions = []
    answers = []
    for i in range(num):
        q, a = get_qa()
        questions.append(q)
        answers.append(a)
    return questions, answers


def make_quiz(quiz):
    quiz["total"] = 10
    quiz["goal"] = 8
    quiz["questions"], quiz["answers"] = generate_qas(10)
    return quiz
