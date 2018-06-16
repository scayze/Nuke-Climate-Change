extends MeshInstance
tool

var noise = preload("res://Scripts/softnoise.gd")
export(ImageTexture) var texture = ImageTexture.new()

func _ready():
	pass
#	randomize()
#	var noise
#	#noise = noise.SoftNoise.new(rand_range(0,100))
#	noise = Noise.new()
#	var size = 128
#	var freq = 1.0/32.0
#	var octs = 5
#	var data = []
#
#	var image = Image.new()
#	image.create(size,size,false,Image.FORMAT_RGB8)
#	image.lock()
#	for x in range(size):
#		for y in range(size):
#			#var c = noise.perlin_noise2d(float(x/512.0),float(y/512.0))
#			var c = noise.fBm(x*freq, y*freq, round(size*freq), octs)
#			#print(c)
#			image.set_pixel(x,y,Color(c,0,0))
#	image.unlock()
#	texture = ImageTexture.new()
#	texture.create_from_image(image,0)
#	ResourceSaver.save("res://noise.png",texture)
	
	#mesh.material.albedo_texture = texture

func _process(delta):
	mesh.material.set_shader_param("water_level",get_parent().get_node("Sea").mesh.radius)

class Noise:
	
	var dirs = []
	var perm = []
	
	func _init():
		#Init Perm
		for i in range(256):
			perm.append(i)
		perm = shuffleList(perm)
		perm += perm
		
		#Init Dirs
		
		for a in range(256):
			dirs.append(Vector2(cos(a * 2.0 * PI / 256),sin(a * 2.0 * PI / 256)))
	
	func shuffleList(list):
		var shuffledList = [] 
		var indexList = range(list.size())
		for i in range(list.size()):
			var x = randi()%indexList.size()
			shuffledList.append(list[indexList[x]])
			indexList.remove(x)
		return shuffledList
	
	func fBm(x, y, per, octs):
		var val = 0
		for o in range(octs):
			val += pow(0.5,o) * noise(x*pow(2,o), y*pow(2,o), per*pow(2,o))
		return val
	
	func surflet(x,y,per,gridX, gridY):
		var distX = abs(x-gridX)
		var distY = abs(y-gridY)
		var polyX = 1 - 6*pow(distX,5) + 15*pow(distX,4) - 10*pow(distX,3)
		var polyY = 1 - 6*pow(distY,5) + 15*pow(distY,4) - 10*pow(distY,3)
		var hashed = perm[perm[fmod(gridX,per)] + fmod(gridY,per)]
		var grad = (x-gridX)*dirs[hashed].x + (y-gridY)*dirs[hashed].y
		return polyX * polyY * grad
	
	func noise(x, y, per):
		var intX = round(x)
		var intY = round(y)
		return (surflet(x,y,per,intX+0, intY+0) + surflet(x,y,per,intX+1, intY+0) + surflet(x,y,per,intX+0, intY+1) + surflet(x,y,per,intX+1, intY+1))