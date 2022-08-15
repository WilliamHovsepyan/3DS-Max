--Picket Fence Generator Rollout Tool
--William Hovsepyan

--Function for generating fence
function generatePicketFence xStart yStart fenceDirection numOfSegments fenceColour = (
	
	--Clears View
	delete objects
	
	--Saves initial starting points
	startPosition = xStart
	xPosition = xStart
	yPosition = yStart
	
	--Draws beginning post for fence & sets pivot point for direction rotation
	post1 = box pos: [xStart, yStart, 0] height: 50 length: 6 width: 10 wirecolor: fenceColour
	post1.pivot = [xPosition, yPosition, 0]
	rotate post1 fenceDirection [0,0,1]
	
	--Draws each fence segment
	for i = 1 to numOfSegments do (
	
	--Draws each fence bar in between posts & sets pivot point for direction rotation
		for i = 1 to 9 do (
			xStart = xStart + 15
				fence = box pos: [xStart, yStart-1, 0] height: 40 length: 2 width: 8 wirecolor: fenceColour
				fence.pivot = [xPosition, yPosition, 0]
				rotate fence fenceDirection [0, 0, 1]
	)
	
	--Adds space for ending post
	xStart = xStart + 15

	--Draws ending post for fence & sets pivot point for direction rotation
	post2 = box pos: [xStart, yStart, 0] height: 50 length: 6 width: 10 wirecolor: fenceColour
	post2.pivot = [xPosition, yPosition, 0]
	rotate post2 fenceDirection [0,0,1]
)
	
	--Determine the position for horizontal beams
	endPosition = (xStart + startPosition)/2
	
	--Determine length of horizontal fence beams
	beamLength = xStart - startPosition
	
	--Create top horizontal beam & sets pivot point for direction rotation
	beam1 = box pos: [endPosition, yStart+1, 25] height: 6 length: 2 width: beamLength wirecolor: fenceColour
	beam1.pivot = [xPosition, yPosition, 0]
	rotate beam1 fenceDirection [0,0,1]
	
	--Create bottom horizontal beam & sets pivot point for direction rotation
	beam2 = box pos: [endPosition, yStart+1, 10] height: 6 length: 2 width: beamLength wirecolor: fenceColour
	beam2.pivot = [xPosition, yPosition, 0]
	rotate beam2 fenceDirection [0,0,1]
)

--Function converted into a rollout tool

--Destroys any active dialog box so only one exists at a time
try(DestroyDialog FenceGenerator) catch()
--Defines the user interface of the dialog box
rollout FenceGenerator "Picket Fence Generator" (
	group "Parameters" (
		--Defines parameters for fence
		spinner xStart "Starting X Coordinate: " type:#integer range: [-10000, 10000, 0]
		spinner yStart "Starting Y Coordinate: " type:#integer range: [-10000, 10000, 0]		
		spinner fenceDirection "Direction: " type:#integer range: [0, 360, 0]
		spinner numOfSegments "Number of Fence Segments: " type:#integer range: [0, 10000, 10]
		colorPicker fenceColourPicker "Fence Colour: " color: [170,59,255]
		button createFence "Generate Picket Fence"
	)
	--Generate picket fence based on parameters
	on createFence pressed do(
		generatePicketFence xStart.value yStart.value fenceDirection.value numOfSegments.value fenceColourPicker.color
	)
)

--Defines user interface dimensions
createDialog FenceGenerator 300 200