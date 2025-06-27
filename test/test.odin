package test

import "../embree"
import "core:fmt"

main :: proc()
{
    fmt.println("Testing basic Embree device creation...")

    device := embree.rtcNewDevice(nil)

    if device == nil
    {
        fmt.println("✖️ Failed to create Embree device")
        fmt.println("This likely means missing DLLs:")
        fmt.println(" - embree.dll")
        fmt.println(" - tbb12.dll")
        fmt.println(" - tbbmalloc.dll (possibly)")
        return
    }

    fmt.println("✅ Device created successfully!")

    version := embree.rtcGetDeviceProperty(device, embree.RTCDeviceProperty.VERSION)
    fmt.printf("Embree version: %d\n", version)

    embree.rtcReleaseDevice(device)
    fmt.println("✅ Test completed successfully!")
}