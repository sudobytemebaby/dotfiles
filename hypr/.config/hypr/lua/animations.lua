-- Curves: gentle 'smooth' for windows/workspaces, snappy 'quick' for fades,
-- 'linear' for fast dismissals.
hl.curve("smooth", { type = "bezier", points = { { 0.25, 0.8 }, { 0.25, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.10, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })

hl.config({ animations = { enabled = true } })

hl.animation({ leaf = "windows", enabled = true, speed = 3.5, bezier = "smooth", style = "slide" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "smooth", style = "slide" })

hl.animation({ leaf = "fadeIn", enabled = true, speed = 3.5, bezier = "smooth" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.5, bezier = "linear" })
hl.animation({ leaf = "fade", enabled = true, speed = 2.5, bezier = "quick" })

hl.animation({ leaf = "layers", enabled = true, speed = 3.5, bezier = "smooth" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 3.5, bezier = "smooth", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1, bezier = "linear", style = "fade" })

hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 2, bezier = "quick" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1, bezier = "linear" })
