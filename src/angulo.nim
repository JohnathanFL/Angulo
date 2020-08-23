import strformat
import tables
import json
import math


import swiss

const # Error exit codes
  ERR_CANT_JULDAY = 1
  ERR_CANT_CUSPS = 2
  ERR_CANT_PLANET = 3


var xx: array[6, cdouble] # Common for swe_calc calls
var err: cint
template checkError(msg: string, exitCode: int) =
  if err == -1:
    echo "SWE Error ", err, ": ", serr[0].addr.cstring # serr defined globally in swiss.nim
    quit msg, exitCode

template alias(what, asWhat: untyped)  =
  template asWhat(): untyped {.dirty.} = what


# The planets we need output for
const AllPlanets = [
  (bodySun, "sun"),
  (bodyMoon, "moon"),
  (bodyMercury, "mercury"),
  (bodyVenus, "venus"),
  (bodyMars, "mars"),
  (bodyJupiter, "jupiter"),
  (bodySaturn, "saturn"),
  (bodyUranus, "uranus"),
  (bodyNeptune, "neptune"),
  (bodyPluto, "pluto"),
  #(bodyOscuApog, "lilith"),
]
# Note that we also place the ascendant in the planets json array, but it's actually handled
# outside swe_calc code for planets

when isMainModule:
  swe_set_ephe_path(nil) # Use moshier approx.
  
  var # Input params for place of birth
    year:int32 = 1999
    month:int32 = 04
    day:int32 = 7
    hour:int32 = 20
    min:int32 = 41
    sec:cdouble = 0
    timezone:cdouble = +2 # DK timezone
    geolat:cdouble = 55.372868
    geolong:cdouble = 10.287323

  doAssert geolat in -66.5..66.5, "Lattitude must be outside arctic circles"

  # Convert local time to UTC
  swe_utc_time_zone(
    year, month, day,
    hour, min, sec,
    timezone,
    # Output params
    year.addr, month.addr, day.addr,
    hour.addr, min.addr, sec.addr
  )

  var dret: array[2, cdouble]
  err = swe_utc_to_jd(
    year, month, day,
    hour, min, sec,
    SE_GREG_CAL,
    dret[0].addr, # Out
  )
  checkError "Failed to convert your date to a julian day", ERR_CANT_JULDAY


  let
    etJulDay = dret[0] # For planet calcs (ephemeris time)
    ut1JulDay = dret[1] # For house calcs


  # cusps[0] is always 0... because astrologers are filthy 1-indexers
  var cusps: array[13, cdouble]
  var ascmc: array[10, cdouble]
  # swe_houses gets ice cream
  err = swe_houses_ex(
    ut1JulDay,
    iflag=SEFLG_MOSEPH,
    geolat, geolong,
    Placidus,
    cusps[0].addr,
    ascmc[0].addr,
  )
  checkError fmt"Failed to get house cusps", ERR_CANT_CUSPS
  proc houseAngle(i: int): float = # Used later in planet calcs
    return cusps[1..12][i mod 12]

  err = swe_calc(
    etJulDay,
    bodyMeanApog,
    iflag=SEFLG_MOSEPH,
    xx[0].addr,
  )

  let
    asc = ascmc[0]
    mc = ascmc[1]
    armc = ascmc[2]
    eps = xx[0] # ecliptic obliquity, accounting for nutation
    # We'll ignore the rest of ascmc for now


  var planets: Table[string, float]
  # swe_calc gets each planet, one at a time
  for (body, planetName) in AllPlanets:
    err = swe_calc(
      etJulDay,
      body,
      iflag=SEFLG_MOSEPH,
      xx[0].addr,
    )
    checkError fmt"Failed to swe_calc {planetName}", ERR_CANT_PLANET
    let angle = swe_house_pos(
      armc, geolong,
      eps,
      Placidus,
      xx[0].addr, # lat/long in the first 2 of xx from swe_calc
    )
    # angle is currently in the format `house.pct_way_through_house`
    # Now convert it to an absolute angle in the system ccw from <1,0>
    var
      house = angle.floor
      a = houseAngle(house.int) # The house it's in
      b = houseAngle(house.int + 1) # The house it's a percentage of the way to
      pct = angle - house
    if b < a: b += 360
    #echo "Planet ", planetName, " was ", pct*100, "% of the way between ", a, " and ", b
    var res = a + (b - a) * pct
    if res > 360: res -= 360
    planets[planetName] = res


    
  echo pretty %*{
    "signRot": asc,
    "mc": mc,
    "armc": armc,
    "houseAngles": cusps[1..12],
    "planets": planets
  }

