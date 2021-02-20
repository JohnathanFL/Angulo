#!/bin/env python3
import swisseph as swe

lat = 55.4016187
lon = 10.3862211
date = swe.julday(1999, 4, 7)
cusps, asmc = swe.houses(date, lat, lon)

print("""
[Signs]
signRot: 333

[HouseAngles]
""")
for cusp in cusps:
    print(cusp)

print("""
[Planets]
# All planets that shall exist in the chart
sun
moon
mercury
venus
mars
jupiter
saturn
uranus
neptune
pluto
lilith
ascendant

[Positions]
# The position of each planet inside a sign.
# Represented as "sign, angleFromStartOfSign"
sun       : "aries, 17.51"
moon      : "capricorn, 2.52"
mercury   : "pisces, 22.1667"
venus     : "taurus, 24.35"
mars      : "scorpio, 9.60"
jupiter   : "aries, 12.70"
saturn    : "taurus, 4.22"
uranus    : "aquarius, 16.02"
neptune   : "aquarius, 4.1667"
pluto     : "sagittarius, 10.333"
lilith    : "scorpio, 32.38"
ascendant : "leo, 20.6667"

[Retrogrades]
# A list of all planets in retrograde
moon
uranus
""")
