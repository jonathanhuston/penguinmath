# weights (t, kg, g, mg)

import random

multiples = [["mg", "g", "kg", "t"]]
values = [[0.001, 1, 1000, 1000000]]


def get_qa(num_range):
    measure_category = multiples[0]
    value_category = values[0]

    l = len(measure_category)
    ti = random.randint(0, l-2)
    tm = measure_category[ti]
    tv = value_category[ti]

    while True:
        s1i = random.randint(ti, l-1)
        s1m = measure_category[s1i]
        s1v = value_category[s1i]
        if s1v / tv <= num_range:
            break

    while True:
        s2i = random.randint(ti, l-1)
        s2m = measure_category[s2i]
        s2v = value_category[s2i]
        if s2v / tv <= num_range:
            break

    f1 = random.randint(0, num_range)
    f2 = random.randint(0, num_range)
    
    q = "{} {} + {} {} = how many {}?".format(str(f1), s1m, str(f2), s2m, tm)
    a = str(round((f1 * s1v + f2 * s2v) / tv))

    return q, a
