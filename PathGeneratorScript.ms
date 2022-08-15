--Path Generator Rollout Tool
--William Hovsepyan

struct Turtle(
	--Inital position
	pos = [0,0,0],

	--Direction of path
	heading = [0,1,0],
	
	--Direction of lamp
	lHeading = [1,0,0],
	
	--Turn offsets for movement
	leftPivot = normalize([-9.75,48.75,0]),
	rightPivot = normalize([9.75,48.75,0]),
	
	--Distance from center of curved piece to edge
	--Using pythagorean theorem to find distance between center and edge
	--Height = 48.75
	--Width = 9.75
	offsetDistance = 49.7154,

	--Axis of rotation
	rotationQuat = quat 0 [0,0,1],  --Change the number to a different angle for different starting points
	
	--Length of pieces 
	amount = 97.5,
	
	--Width of pieces
	wide = 35,
	
	--Height of pieces
	tall = 1,
	
	--Angle of turn for curved piece
	turnAngle = 45,
	
	--Adjustment angle for curved piece
	adj = 22.5,
	
	fn forward = (
		
		--Generate object
		a = 128/2
		
		--Draw turtle
		--c2 = box pos: pos height: 5 width: 5 length: 5 wirecolor: red
		--rotate c2 rotationQuat
		
		c=box pos:pos length: 128 height: tall width: wide lengthsegs: 10 wirecolor: blue
		rotate c rotationQuat
		move c (a*heading)
	
		--Updating position
		pos=pos + (127.35*heading)
	),
	
	fn left = (		
		
		--Draw turtle
		--c2 = box pos: pos height: 5 width: 5 length: 5 wirecolor: red
		--rotate c2 rotationQuat
		
		--Create piece
		c=box pos: (pos) length: 100 height: tall width: wide lengthsegs: 10 wirecolor: blue
		
		--Curve piece
		addmodifier c (bend())
		c.bend.bendangle = -45
		c.bend.bendAxis = 1
		
		--Create 22.5 degree adjustment for aligning the object
		defaultQuat = quat adj [0,0,1]
		rotate c defaultQuat
			
		--Rotate object 22.5 degrees to follow path
		rotate c rotationQuat
		
		--Position the piece
		move c (offsetDistance*leftPivot)

		--Turtle adjustment
		q = quat turnAngle [0,0,1]		
		rotationQuat = q*rotationQuat
		invq = inverse q
			
		heading2 = heading
		q2 = quat 22.5 [0,0,1]
		invq2 = inverse q2
		heading2 = heading2*invq2
		heading2 = normalize(heading2)
			
		heading=heading*invq
		heading = normalize(heading)
			
		leftPivot = leftPivot*invq			
		leftPivot = normalize(leftPivot)			
			
		rightPivot = rightPivot*invq			
		rightPivot = normalize(rightPivot)
		
		--Updating position
		pos=pos + (amount*heading2)
	),
	
		fn right = (
		
		--Draw turtle
		--c2 = box pos: pos height: 5 width: 5 length: 5 wirecolor: red
		--rotate c2 rotationQuat
		
		--Create piece
		c=box pos: (pos) length: 100 height: tall width: wide lengthsegs: 10 wirecolor: blue
		
		--Curve piece
		addmodifier c (bend())
		c.bend.bendangle = 45
		c.bend.bendAxis = 1
		
		--Create 22.5 degree adjustment for aligning the object
		defaultQuat = quat -adj [0,0,1]
		rotate c defaultQuat
			
		--Rotate object 22.5 degrees to follow path
		rotate c rotationQuat
		
		--Position the piece
		move c (offsetDistance*rightPivot)

		--Turtle adjustment
		q = quat -turnAngle [0,0,1]		
		rotationQuat = q*rotationQuat
		invq = inverse q
			
		heading2 = heading
		q2 = quat -22.5 [0,0,1]
		invq2 = inverse q2
		heading2 = heading2*invq2
		heading2 = normalize(heading2)
			
		heading=heading*invq
		heading = normalize(heading)
			
		leftPivot = leftPivot*invq			
		leftPivot = normalize(leftPivot)			
			
		rightPivot = rightPivot*invq			
		rightPivot = normalize(rightPivot)
		
		--Updating position
		pos=pos + (amount*heading2)
	),
	
	--Generates lamp post next to path piece
	fn decor = (
	
		--Turtle adjustment
		lHeading = heading
		qH = quat -130 [0,0,1]
		invqH = inverse qH
		lHeading = lHeading*invqH
		lHeading = normalize(lHeading)
		
		--Updating position
		lampPos = pos + (35 * lHeading)
		
		--Creates lamp post pieces at position
		lightRadius = 3
		lightHeight = 23
		handleReach = 10
		post = box pos: lampPos height: 25 width: 2 length: 2 wirecolor: black
		lightbulb = Sphere pos: (lampPos + [0, handleReach, lightHeight]) radius: lightRadius wirecolor: yellow
		lightbulb2 = Sphere pos: (lampPos + [0, -handleReach, lightHeight]) radius: lightRadius wirecolor: yellow
		lightbulb3 = Sphere pos: (lampPos + [handleReach, 0, lightHeight]) radius: lightRadius wirecolor: yellow
		lightbulb4 = Sphere pos: (lampPos + [-handleReach, 0, lightHeight]) radius: lightRadius wirecolor: yellow
		handle = box pos: (lampPos + [0, 0,25]) height: 2 width: 2 length: 20 wirecolor: black
		handle2 = box pos: (lampPos + [0, 0,25]) height: 2 width: 20 length: 2 wirecolor: black
	)
)

--Array of moves made to follow a path - Clicking the directions adds new pieces to array
thePath = #()

--Array of directions to make a figure 8
thePath = #("left","left","left","left","left", "left", "straight", "straight", "right", "right", "right", "right", "right", "right", "straight", "straight")

--Generates pieces based on array string value
fn generatePath pathArray = (
	delete objects	
	t = Turtle()

	for i = 1 to pathArray.count do (	
		if pathArray[i] == "left" then (
		t.left()
	)		
	else if pathArray[i] == "right" then (
		t.right()
	)			
	else if pathArray[i] == "straight" then (
		t.forward()
	)		
	)
)

--Generates pieces based on array string value and creates a lamp post next to objects
fn generatePathwithDecor pathArray = (
	delete objects	
	t = Turtle()

	for i = 1 to pathArray.count do (	
		if pathArray[i] == "left" then (
		t.left()
		t.decor()
	)		
	else if pathArray[i] == "right" then (
		t.right()	
		t.decor()
	)			
	else if pathArray[i] == "straight" then (
		t.forward()
		t.decor()
	)		
	)
)

--Calling generator function using path array
--generatePath thePath

--Function converted into a rollout tool

--Destroys any active dialog box so only one exists at a time
try(DestroyDialog pathGenerator) catch()

--Defines the user interface
rollout pathGenerator "Path Generator" (
	
	group "Reset:" (
		button resetData "Clear Path Data"	
	)
	
	listbox directions "Directions: " items: thePath selection: 1 height: 20
	
	group "Pick Direction(s):" (
	button addLeft "Left"
	button addRight "Right"
	button addStraight "Straight"
	)
	
	group "Decorations:" (
		checkbox decorations "Add Lamp Posts"	
	)
	
	group "Generate Path" (
		button createPath "Create"
	)	
	
	--Add left turn to path array
	on addLeft pressed do (
		append thePath "left"
		directions.items = thePath
	)
	
	--Add right turn to path array
	on addRight pressed do (
		append thePath "right"
		directions.items = thePath
	)	
	
	--Add straight piece to path array
	on addStraight pressed do (
		append thePath "straight"
		directions.items = thePath
	)
	
	--Resets path generator data
	on resetData pressed do (
		decorations.checked = false
		thePath = #()
		directions.items = thePath
	)
	
	--Generate path when button is pressed
	on createPath pressed do (
		
		--If checkbox is selected decorations are applied to scene
		if decorations.checked then (
		generatePathwithDecor thePath
		)
		--If not checked then only the path will be drawn
		else (
		generatePath thePath
		)
	)
)

--Defines user interface dimensions
createDialog pathGenerator 200 550