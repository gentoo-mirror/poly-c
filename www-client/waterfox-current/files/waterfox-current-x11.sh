#!/bin/sh

#
# Run Mozilla Waterfox Current on X11
#
export MOZ_DISABLE_WAYLAND=1
exec @PREFIX@/bin/waterfox-current "$@"
