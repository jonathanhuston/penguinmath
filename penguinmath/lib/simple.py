import csv
import random


def generate_qas(_, total, quiz_name):
    # PythonAnywhere: quiz_file = open('penguinmath/quizdata/' + quiz_name + '.csv')
    quiz_file = open('quizdata/' + quiz_name + '.csv')
    quiz_reader = csv.reader(quiz_file)
    qas = list(quiz_reader)
    quiz_file.close()

    random.shuffle(qas)
    q = [qa[0] for qa in qas][0:total]
    a = [qa[1] for qa in qas][0:total]

    return q, a
    
