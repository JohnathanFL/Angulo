# Manually written bindings for the swiss ephemeris library

# The actual library. I assume *Nix systems for now.
{.passL: "libswe.so" .}
# Because libswe depends on trig functions
{.passL: "libm.so" .}

# Global error message storage
var serr*: array[256, cchar]

const
  SE_JUL_CAL*: cint = 0
  SE_GREG_CAL*: cint = 1
  SEFLG_MOSEPH*: cint = 4
  Placidus*: cint = 'P'.cint

const # Body codes
  bodyEclNut*: cint = -1
  bodySun*: cint = 0
  bodyMoon*: cint = 1
  bodyMercury*: cint = 2
  bodyVenus*: cint = 3
  bodyMars*: cint = 4
  bodyJupiter*: cint = 5
  bodySaturn*: cint = 6
  bodyUranus*: cint = 7
  bodyNeptune*: cint = 8
  bodyPluto*: cint = 9
  bodyMeanNode*: cint = 10
  bodyTrueNode*: cint = 11
  bodyMeanApog*: cint = 12
  bodyOscuApog*: cint = 13
  bodyEarth*: cint = 14
  bodyChiron*: cint = 15
  bodyPholus*: cint = 16
  bodyCeres*: cint = 17
  bodyPallas*: cint = 18
  bodyJuno*: cint = 19
  bodyVesta*: cint = 20
  bodyIntpApog*: cint = 21
  bodyIntpPerg*: cint = 22
  bodyNplanets*: cint = 23
  bodyFictOffset*: cint = 40
  bodyNfictElem*: cint = 15
  bodyAstOffset*: cint = 10000
  bodyCupido*: cint = 40
  bodyHades*: cint = 41
  bodyZeus*: cint = 42
  bodyKronos*: cint = 43
  bodyApollon*: cint = 44
  bodyAdmetos*: cint = 45
  bodyVulkanus*: cint = 46
  bodyPoseidon*: cint = 47
  bodyIsis*: cint = 48
  bodyNibiru*: cint = 49
  bodyHarrington*: cint = 50
  bodyNeptuneLeverrier*: cint = 51
  bodyNeptuneAdams*: cint = 52
  bodyPlutoLowell*: cint = 53
  bodyPlutoPickering*: cint = 54

proc swe_set_ephe_path*(path: cstring) {.importc.}


proc swe_julday*(
  year, month, day: cint,
  hour: cdouble,
  gregflag: cint
): cdouble {.importc.}


proc swe_utc_to_jd*(
  year, month, day: int32, 
  hour, min: int32,
  sec: cdouble, 
  gregflag: int32,
  dret: ptr cdouble,
  serr: cstring = serr[0].addr,
): int32 {.importc.}

proc swe_utc_time_zone*(
  year, month, day: int32,
  hour, min: int32, sec: cdouble,
  timezone: cdouble,
  yearOut, monthOut, idayOut: ptr int32,
  hourOut, minOut: ptr int32,
  dsecOut: ptr cdouble
) {.importc.}

proc swe_calc*( 
  tjd: cdouble,
  ipl: cint,
  iflag: int32, 
  xx: ptr cdouble,
  serr: cstring = serr[0].addr,
): int32 {.importc.}


proc swe_houses*(
  tjd_ut, geolat, geolon: cdouble,
  hsys: cint, 
  hcusps, ascmc: ptr cdouble
): cint {.importc.}

proc swe_houses_ex*(
  tjd_ut        : cdouble,
  iflag         : int32,
  geolat, geolon: cdouble,
  hsys          : cint,
  cusps, ascmc  : ptr cdouble
): cint {.importc.}

proc swe_house_pos*(
  armc, geolon: cdouble,
  eps: cdouble,
  hsys: cint,
  xpin: ptr cdouble,
  serr: cstring = serr[0].addr,
): cdouble {.importc.}
