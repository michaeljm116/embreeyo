package embree

import "core:c"

RTCGeometry :: distinct rawptr

RTCGeometryType :: enum c.int
{
  TRIANGLE = 0, // triangle mesh
  QUAD     = 1, // quad (triangle pair) mesh
  GRID     = 2, // grid mesh

  SUBDIVISION = 8, // Catmull-Clark subdivision surface

  CONE_LINEAR_CURVE   = 15, // Cone linear curves - discontinuous at edge boundaries
  ROUND_LINEAR_CURVE  = 16, // Round (rounded cone like) linear curves
  FLAT_LINEAR_CURVE   = 17, // flat (ribbon-like) linear curves

  ROUND_BEZIER_CURVE  = 24, // round (tube-like) Bezier curves
  FLAT_BEZIER_CURVE   = 25, // flat (ribbon-like) Bezier curves
  NORMAL_ORIENTED_BEZIER_CURVE  = 26, // flat normal-oriented Bezier curves

  ROUND_BSPLINE_CURVE = 32, // round (tube-like) B-spline curves
  FLAT_BSPLINE_CURVE  = 33, // flat (ribbon-like) B-spline curves
  NORMAL_ORIENTED_BSPLINE_CURVE  = 34, // flat normal-oriented B-spline curves

  ROUND_HERMITE_CURVE = 40, // round (tube-like) Hermite curves
  FLAT_HERMITE_CURVE  = 41, // flat (ribbon-like) Hermite curves
  NORMAL_ORIENTED_HERMITE_CURVE  = 42, // flat normal-oriented Hermite curves

  SPHERE_POINT = 50,
  DISC_POINT = 51,
  ORIENTED_DISC_POINT = 52,

  ROUND_CATMULL_ROM_CURVE = 58, // round (tube-like) Catmull-Rom curves
  FLAT_CATMULL_ROM_CURVE  = 59, // flat (ribbon-like) Catmull-Rom curves
  NORMAL_ORIENTED_CATMULL_ROM_CURVE  = 60, // flat normal-oriented Catmull-Rom curves

  USER     = 120, // user-defined geometry
  INSTANCE = 121,  // scene instance
  INSTANCE_ARRAY = 122,  // scene instance array
};

RTCSubdivisionMode :: enum c.int
{
  NO_BOUNDARY     = 0,
  SMOOTH_BOUNDARY = 1,
  PIN_CORNERS     = 2,
  PIN_BOUNDARY    = 3,
  PIN_ALL         = 4,
};

/* Curve segment flags */
RTCCurveFlags :: enum c.int
{
  NEIGHBOR_LEFT  = (1 << 0), // left segments exists
  NEIGHBOR_RIGHT = (1 << 1)  // right segment exists
};



foreign import embree "embree4.lib"
foreign embree{
    @(link_name="rtcNewGeometry")
    rtcNewGeometry :: proc(device : RTCDevice, type : RTCGeometryType) -> RTCGeometry ---

}