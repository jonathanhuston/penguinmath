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
