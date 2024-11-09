@tool
class_name Rail extends CSGPolygon3D

@export var profile: Polygon

@export var road_width: float = 1.52:
	set(value):
		road_width = value
		recalculate()
@export var left_rail: bool:
	set(value):
		left_rail = value
		recalculate()
		
func recalculate() -> void:
	var offset: float = road_width * 0.5
	if left_rail:
		offset *= -1.0
	for i in range(polygon.size()):
		polygon[i] = profile.polygon[i]
		polygon[i].x += offset
		
		
