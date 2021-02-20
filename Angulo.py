#!/bin/env python3
import json
import datetime
from kerykeion import Calculator, output

def myconverter(o):
    if isinstance(o, datetime.datetime):
        return o.__str__()

anne = Calculator("Anne", 1999, 4, 7, 21, 0, "Odense, Denmark")

anne.get_all()

print(json.dumps(vars(anne), default = myconverter))
