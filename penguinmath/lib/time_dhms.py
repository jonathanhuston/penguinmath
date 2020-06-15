# time_dhms (days, hours, minutes, seconds)

import random

units = ["d", "h", "m", "s"]
multiples = [None, 24, 60, 60]
num_ranges = [10, 240, 1440, 3600]


def up_qa(i):
    quantity = random.randint(1, num_ranges[i])
    multiple = multiples[i]
    source_unit = units[i]
    target_unit = units[i-1]
    q = "How many {} and {} are {} {}?".format(target_unit, source_unit, str(quantity), source_unit)
    a = "{} {} {} {}".format(str(quantity // multiple), target_unit, str(quantity % multiple), source_unit)

    return q, a


def down_qa(i):
    quantity = random.randint(1, num_ranges[i])
    multiple = multiples[i+1]
    source_unit = units[i]
    target_unit = units[i+1]
    q = "How many {} are {} {}?".format(target_unit, str(quantity), source_unit)
    a = str(quantity * multiple)

    return q, a


def get_qa(_):
    i = random.randint(0, 3)

    if i == 0:
        q, a = down_qa(i)
    elif i == 3:
        q, a = up_qa(i)
    else:
        q, a = down_qa(i) if random.randint(0, 1) else up_qa(i)

    return q, a
