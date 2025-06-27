package main

import "embree"
import "core:fmt"
import "core:c"

main :: proc() {
    fmt.println("HI")
	device := initializeDevice()
	scene := initializeScene(device)

	// Cast a ray expected to hit the triangle
	castRay(scene, 0.33, 0.33, -1.0, 0.0, 0.0, 1.0)
	// Cast a ray expected to miss
	castRay(scene, 1.0, 1.0, -1.0, 0.0, 0.0, 1.0)

	// Release resources
	embree.rtcReleaseScene(scene)
	embree.rtcReleaseDevice(device)
}

error_function :: proc "c" (user_ptr: rawptr, code: embree.RTCError, str: cstring) {

}

// Device initialization function
initializeDevice :: proc() -> embree.RTCDevice {
	// Create a new device with default config (nil)
	device := embree.rtcNewDevice(nil)
	if device == nil {
		fmt.println("Error: cannot create device")
		return nil
	}

	// Set error callback (assume embree.errorFunction exists)
	embree.rtcSetDeviceErrorFunction(device, error_function, nil)
	return device
}

// Scene initialization function: creates a scene with one triangle mesh
initializeScene :: proc(device: embree.RTCDevice)-> embree.RTCScene {
	scene := embree.rtcNewScene(device)

	// Create a triangle mesh geometry
	geom := embree.rtcNewGeometry(device, embree.RTCGeometryType.TRIANGLE)

	// Create vertex buffer: 3 vertices of type FLOAT3 (3 floats per vertex)
	verts_ptr := embree.rtcSetNewGeometryBuffer(geom, embree.RTCBufferType.VERTEX, 0, embree.RTCFormat.FLOAT3, 3 * size_of(f32), 3)
	// Create index buffer: 1 triangle of type UINT3 (3 unsigned ints)
	inds_ptr := embree.rtcSetNewGeometryBuffer(geom, embree.RTCBufferType.INDEX, 0, embree.RTCFormat.UINT3, 3 * size_of(u32), 1)

	// Fill vertex and index buffers if allocation succeeded
	if verts_ptr != nil && inds_ptr != nil {
	    verts : [9]f32 = { 0, 0, 0, 1, 0, 0, 0, 1, 0}
		inds : [3]u32 = {0,1,2}

	}

	// Commit the geometry and attach to the scene
	embree.rtcCommitGeometry(geom)
	embree.rtcAttachGeometry(scene, geom)
	embree.rtcReleaseGeometry(geom)
	embree.rtcCommitScene(scene)
	return scene
}
// Function to cast a single ray and print the result
castRay :: proc(scene: embree.RTCScene, ox, oy, oz, dx, dy, dz: f32) {
    idk := i32(-1)

	rayhit: embree.RTCRayHit
	// Setup ray origin and direction
	rayhit.ray.org_x = ox
	rayhit.ray.org_y = oy
	rayhit.ray.org_z = oz
	rayhit.ray.dir_x = dx
	rayhit.ray.dir_y = dy
	rayhit.ray.dir_z = dz
	rayhit.ray.tnear = 0.0
	rayhit.ray.tfar = 1e9
	rayhit.ray.mask = u32(idk)
	rayhit.ray.flags = 0
	// Invalidate hit initially
	rayhit.hit.geomID = embree.RTC_INVALID_GEOMETRY_ID
	rayhit.hit.instID[0] = embree.RTC_INVALID_GEOMETRY_ID

	// Cast the ray into the scene (single ray intersection)
	embree.rtcIntersect1(scene, &rayhit)

	fmt.printf("%f, %f, %f: ", ox, oy, oz)
	if rayhit.hit.geomID != embree.RTC_INVALID_GEOMETRY_ID {
		fmt.printf("Found intersection on geometry %d, primitive %d at tfar=%f\n",
			rayhit.hit.geomID, rayhit.hit.primID, rayhit.ray.tfar)
	} else {
		fmt.println("Did not find any intersection.")
	}
}





