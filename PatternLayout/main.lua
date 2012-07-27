local reverse = 0
local object
local closedCard = {}
local faceCard = {}
local count = 0
local int card1 = 0
local int card2 = 0
local int CardNumber = 0

local int margin = 40
local ContentWidth = display.contentWidth-margin
local ContentHeight = display.contentHeight
local int rows = 8 --SET THIS VALUE ACCORDING TO THE DIFFICULTY
local int columns = 8  --SET THIS VALUE ACCORDING TO THE DIFFICULTY
local int cardWidth = (ContentWidth - margin)/rows --SET THIS VALUE ACCORDING TO THE DEVICE








function sessionComplete(event)--TO READ IMAGES FROM THE DEVICE LIBRARY
	
	print("closedCard[CardNumber].width "..closedCard[CardNumber].width)
	print("closedCard[CardNumber].height "..closedCard[CardNumber].height)
	print("event.target.width "..event.target.width)
	print("event.target.height "..event.target.height)
	print("scale "..closedCard[CardNumber].width/event.target.width.."\n"..closedCard[CardNumber].height/event.target.height)


	event.target.x = closedCard[CardNumber].x 
	event.target.y = closedCard[CardNumber].y

	event.target:scale(closedCard[CardNumber].width/event.target.width,closedCard[CardNumber].height/event.target.height)
	closedCard[CardNumber] = event.target
	
	
	closedCard[CardNumber].alpha = 0.9
	

end
function loadImages(event)
	CardNumber = event.target.id
	print("loadImages")
	--READS THE DEVICE PHOTO LIBRARY AND LOADS THE SELECTED IMAGES
	media.show( media.SavedPhotosAlbum, sessionComplete )
end


function setUpCards()

	for	i=0,(rows* columns)-1 do
	closedCard[i] = display.newImage( "GVRFace.png" )
	closedCard[i].isVisible = false
	closedCard[i]:scale(cardWidth/closedCard[i].width, cardWidth/closedCard[i].height)
	closedCard[i].myName = i
	end

--CODE FOR CO-ORDINATES OF N x N POINTS

	local int k = 0
	for i=0,columns-1 do
		for j=0,rows -1 do
			
			closedCard[k].x = i*ContentWidth/rows + ContentWidth/(2*rows) + margin/2
			closedCard[k].y = j*ContentWidth/rows + ((ContentHeight-ContentWidth)/2+(ContentWidth/(2*rows)))
			closedCard[k].isVisible = true
			closedCard[k].id = k
			-- if (k%4 == 0) then
			-- 	closedCard[k].alpha = 0.1
			-- 	closedCard[k]:addEventListener("tap",loadImages)		
			-- end
			
			k=k+1
		end
	end


end


-- setUpCards()

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

local ui = require("ui")

-- Determine if running on Corona Simulator
--
local isSimulator = "simulator" == system.getInfo("environment")

-- Native Text Fields not supported on Simulator
--

local msg = display.newText( " HELLO ", 0, 120, "Verdana-Bold", 12 )
if isSimulator then
	msg.text = "Native Text Fields not supported on Simulator!"
	msg.x = display.contentWidth/2		-- center title
	msg:setTextColor( 255,255,0 )
end

local defaultField


function fieldHandler( event )

	if ( "began" == event.phase ) then
		-- This is the "keyboard has appeared" event
		-- In some cases you may want to adjust the interface when the keyboard appears.
	msg.text = defaultField.text
	elseif ( "ended" == event.phase ) then
		-- This event is called when the user stops editing a field: for example, when they touch a different field
	msg.text = defaultField.text
	elseif ( "submitted" == event.phase ) then
		-- This event occurs when the user presses the "return" key (if available) on the onscreen keyboard
	msg.text = ""	
		native.setKeyboardFocus( nil )-- Hide keyboard
	msg.text = defaultField.text
		
	end

end

-- Predefine local objects for use later

local fields = display.newGroup()
defaultField = native.newTextField( 10, 30, 180, 50, fieldHandler )
		defaultField.font = native.newFont( native.systemFontBold, 18 )
		fields:insert(defaultField)


