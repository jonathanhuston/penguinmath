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
