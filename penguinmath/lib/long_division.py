# long division

import random


def get_qa(num_range):
    while True:
        x = random.randint(1000, num_range + 1)
        y = random.randint(2, 9)
        a = x / y
        if (a <= num_range) and (a == round(a)):
            break

    q = "{} {} {} = ?".format(x, '/', y)

    return q, str(round(a))
