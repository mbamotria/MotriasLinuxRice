---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout      = "us",
        kb_variant     = "",
        kb_model       = "",
        kb_options     = "",
        kb_rules       = "",

        follow_mouse   = 1,
        force_no_accel = true,

        sensitivity    = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad       = {
            natural_scroll = false,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
-- hl.device({
--     name        = "beken-2.4g-wireless-device-consumer-control-1",
--     sensitivity = -1,
-- })
