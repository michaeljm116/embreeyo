package embree

import "core:c"

// Opaque types
RTCTraversable :: distinct rawptr

// Scene flags
RTCSceneFlags :: enum c.int {
    NONE                         = 0,
    DYNAMIC                      = 1 << 0,
    COMPACT                      = 1 << 1,
    ROBUST                       = 1 << 2,
    FILTER_FUNCTION_IN_ARGUMENTS = 1 << 3,
    PREFETCH_USM_SHARED_ON_GPU   = 1 << 4,
}

// Progress monitor callback
RTCProgressMonitorFunction :: #type proc "c" (ptr: rawptr, n: f64) -> bool

// Intersect/Occluded arguments
RTCIntersectArguments :: struct {
    flags: RTCRayQueryFlags,
    feature_mask: RTCFeatureFlags,
    ctx: ^RTCRayQueryContext,
    filter: RTCFilterFunctionN,
    intersect: RTCIntersectFunctionN,
    minWidthDistanceFactor: f32, // Only used if RTC_MIN_WIDTH != 0
}

RTCOccludedArguments :: struct {
    flags: RTCRayQueryFlags,
    feature_mask: RTCFeatureFlags,
    ctx: ^RTCRayQueryContext,
    filter: RTCFilterFunctionN,
    occluded: RTCOccludedFunctionN,
    minWidthDistanceFactor: f32, // Only used if RTC_MIN_WIDTH != 0
}

// Collision callback and struct
RTCCollision :: struct {
    geomID0: u32,
    primID0: u32,
    geomID1: u32,
    primID1: u32,
}
RTCCollideFunc :: #type proc "c" (userPtr: rawptr, collisions: ^RTCCollision, num_collisions: u32)

// Foreign function declarations
foreign import embree "embree4.lib"
foreign embree {
    @(link_name="rtcNewScene")
    rtcNewScene :: proc(device: RTCDevice) -> RTCScene ---

    @(link_name="rtcGetSceneDevice")
    rtcGetSceneDevice :: proc(hscene: RTCScene) -> RTCDevice ---

    @(link_name="rtcRetainScene")
    rtcRetainScene :: proc(scene: RTCScene) ---

    @(link_name="rtcReleaseScene")
    rtcReleaseScene :: proc(scene: RTCScene) ---

    @(link_name="rtcGetSceneTraversable")
    rtcGetSceneTraversable :: proc(scene: RTCScene) -> RTCTraversable ---

    @(link_name="rtcAttachGeometry")
    rtcAttachGeometry :: proc(scene: RTCScene, geometry: RTCGeometry) -> u32 ---

    @(link_name="rtcAttachGeometryByID")
    rtcAttachGeometryByID :: proc(scene: RTCScene, geometry: RTCGeometry, geomID: u32) ---

    @(link_name="rtcDetachGeometry")
    rtcDetachGeometry :: proc(scene: RTCScene, geomID: u32) ---

    @(link_name="rtcGetGeometry")
    rtcGetGeometry :: proc(scene: RTCScene, geomID: u32) -> RTCGeometry ---

    @(link_name="rtcGetGeometryThreadSafe")
    rtcGetGeometryThreadSafe :: proc(scene: RTCScene, geomID: u32) -> RTCGeometry ---

    @(link_name="rtcCommitScene")
    rtcCommitScene :: proc(scene: RTCScene) ---

    @(link_name="rtcJoinCommitScene")
    rtcJoinCommitScene :: proc(scene: RTCScene) ---

    @(link_name="rtcSetSceneProgressMonitorFunction")
    rtcSetSceneProgressMonitorFunction :: proc(scene: RTCScene, progress: RTCProgressMonitorFunction, ptr: rawptr) ---

    @(link_name="rtcSetSceneBuildQuality")
    rtcSetSceneBuildQuality :: proc(scene: RTCScene, quality: RTCBuildQuality) ---

    @(link_name="rtcSetSceneFlags")
    rtcSetSceneFlags :: proc(scene: RTCScene, flags: RTCSceneFlags) ---

    @(link_name="rtcGetSceneFlags")
    rtcGetSceneFlags :: proc(scene: RTCScene) -> RTCSceneFlags ---

    @(link_name="rtcGetSceneBounds")
    rtcGetSceneBounds :: proc(scene: RTCScene, bounds_o: ^RTCBounds) ---

    @(link_name="rtcGetSceneLinearBounds")
    rtcGetSceneLinearBounds :: proc(scene: RTCScene, bounds_o: ^RTCLinearBounds) ---

    @(link_name="rtcCollide")
    rtcCollide :: proc(scene0: RTCScene, scene1: RTCScene, callback: RTCCollideFunc, userPtr: rawptr) ---
}
