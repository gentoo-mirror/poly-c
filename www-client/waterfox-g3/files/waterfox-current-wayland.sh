#!/bin/sh

#
# Run Waterfox Current under Wayland
#
export MOZ_ENABLE_WAYLAND=1
exec @PREFIX@/bin/waterfox-current "$@"
