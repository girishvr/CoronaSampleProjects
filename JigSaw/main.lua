--JIGSAW BY GIRISHVR

-- require "sprite"
display.setStatusBar( display.HiddenStatusBar )

local util = require("util")
-- start physics
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )
physics.setDrawMode( "normal" ) -- normal, hybrid, debug
local gameUI = require("gameUI")

local childImage = {}
local stickyBall = {}
local stickFlag = false
local firstStickyBall 
local secondStickyBall 
local jointCount = 0 


function main()
	print("Here we go "..system.getInfo("maxTextureSize"))

	--USE THIS FOR SWIPE GESTURE ON STRICKER	
	local function imageDragged( event ) 
		return 
		gameUI.dragBody( event )
	--	gameUI.dragBody( event, { maxForce=400, frequency=5, dampingRatio=0.2 } ) -- slow, elastic dragging
	--	gameUI.dragBody( event, { maxForce=20000, frequency=1000, dampingRatio=1.0, center=true } ) -- very tight dragging, snaps to object center
	end

	function imageRotate(event)
		-- body
		print("imageRotate"..event.target.name)
		event.target.rotation = event.target.rotation +45
	end

	
	for i=1,4 do
	
		childImage[i] = display.newImage("image"..i..".png")
		childImage[i].name = i
		childImage[i].x = 100*i
		childImage[i].y = 200*i
		physics.addBody(childImage[i], "kinetic",{ friction=30, bounce=0, density=1000})
		childImage[i].angularDamping = 1000
		childImage[i].linearDamping = 1000
		-- listen for touch drag on the image
		childImage[i]:addEventListener( "touch", imageDragged )
		childImage[i]:addEventListener( "tap", imageRotate )

	end
	function stickEmUp()
	
		if (stickFlag) then
			print("stickEmUp()--"..firstStickyBall..secondStickyBall)
			stickFlag = false
			-- stickyBall[firstStickyBall].isSensor = false
			-- stickyBall[secondStickyBall].isSensor = false
			stickyBall[firstStickyBall].alpha = 0
			stickyBall[secondStickyBall].alpha = 0
			-- stickyBall[firstStickyBall]:removeEventListener("collision", stickyBall[firstStickyBall])
			-- stickyBall[secondStickyBall]:removeEventListener("collision", stickyBall[secondStickyBall])
			-- stickyBall[secondStickyBall].x = stickyBall[firstStickyBall].x
			-- stickyBall[secondStickyBall].y = stickyBall[firstStickyBall].y
			-- stickyBall[firstStickyBall].joint = physics.newJoint( "pivot", stickyBall[firstStickyBall], stickyBall[secondStickyBall],stickyBall[firstStickyBall].x,stickyBall[firstStickyBall].y )

			childImage[math.ceil (firstStickyBall/2) ].joint = physics.newJoint( "weld", childImage[math.ceil (firstStickyBall/2) ], childImage[math.ceil (secondStickyBall/2) ],childImage[math.ceil (secondStickyBall/2) ].x,childImage[math.ceil (secondStickyBall/2) ].y )
			jointCount = jointCount+1


 			 stickyBall[firstStickyBall].id = nil
			 stickyBall[secondStickyBall].id = nil
			 stickyBall[firstStickyBall]:removeSelf()
			 stickyBall[secondStickyBall]:removeSelf()

			 if jointCount == 3 then
			 	print("HURRAY! JIGSAW COMPLETE!!!")
			 	Runtime:removeEventListener("enterFrame", stickEmUp )
		 		parentImage = display.newImage("sample.png")
		 		parentImage.x = (childImage[1].x + childImage[2].x)/2
		 		parentImage.y = (childImage[1].y + childImage[4].y)/2
			 	for i=1,4 do
			 		childImage[i]:removeSelf()
			 	end

			 	for i=1,8 do
			 		
			 		if stickyBall[i].id ~= nil then
			 			print("-------------------"..stickyBall[i].id)
				 		stickyBall[i]:removeSelf()
				 	end
				end
			 end

		end

	end


	local function stickTogether(self,event)
		-- body
		event.other:setLinearVelocity(0,0)
	    -- event.other.active = false
	    -- event.other.alpha = 0
	    -- self.isSensor = false
	   
		if ( event.phase == "began" ) then
 			if self.match == event.other.match and (stickyBall[self.id].joint == nil and stickyBall[event.other.id].joint == nil) then -- and (self.pivot == nil and event.other ~= nil) then
				print(self.name.." stickTogether "..event.other.name, self.x)
				-- timer.performWithDelay(3000, stickEmUp(), 1 )
				stickFlag = true
				firstStickyBall = event.other.id
				secondStickyBall = self.id

				 -- childImage[math.ceil (firstStickyBall/2)]:removeEventListener( "tap", imageRotate )---
			  --    childImage[math.ceil (secondStickyBall/2)]:removeEventListener( "tap", imageRotate )--- Remove rotate on Touch

			end
        end

		
	end



	
	local sensorXpos = {childImage[1].x + childImage[1].width/2, 	childImage[1].x,		childImage[2].x - childImage[2].width/2,	childImage[2].x ,	childImage[3].x ,	childImage[3].x - childImage[3].width/2, 	childImage[4].x + childImage[4].width/2,	childImage[4].x  }
	local sensorYpos = {childImage[1].y,	childImage[1].y+childImage[1].height/2,		childImage[2].y,	childImage[2].y+childImage[2].height/2,			childImage[3].y-childImage[3].height/2,		childImage[3].y,	childImage[4].y,	childImage[4].y-childImage[4].height/2,}
	local matchPoint = {1,2,1,4,4,6,6,2}

	for i=1,8 do

		local  n =  math.ceil (i/2) 
		
		print(n)

		stickyBall[i] = display.newCircle(sensorXpos[i], sensorYpos[i], 2)
		physics.addBody(stickyBall[i], "kinetic",{ friction=10, bounce=0, density=10})
		stickyBall[i].isSensor = true
		stickyBall[i].name = "stickyBall"
		stickyBall[i].id = i
		stickyBall[i].match = matchPoint[i]
		myJoint = physics.newJoint( "weld", childImage[n], stickyBall[i], childImage[n].x,childImage[n].y )

		stickyBall[i].collision = stickTogether
	    stickyBall[i]:addEventListener("collision", stickyBall[i])

	end

		Runtime:addEventListener("enterFrame", stickEmUp )

end

 main()



local removable = false
local someGroup = display.newGroup()
local drawLine

function removeLine(event )
	print( "removeLine" ) 
	someGroup:removeSelf()
	Runtime:removeEventListener("touch", removeLine)

 --    Runtime:addEventListener("touch", drawLine )
	-- someGroup = display.newGroup()
end


local x1 = 0
local y1 = 0
local star

function drawLine(event )
	-- body

	if x1 == 0 and y1 == 0 then
		x1 = event.x
		y1 = event.y
		star = display.newLine( event.x,event.y,event.x,event.y )
			print( "touch occurred at ("..event.x..","..event.y..")" ) 

	else
		
		star = display.newLine( x1,y1,event.x,event.y )
 	 		print( "touch occurred  ("..event.x..","..event.y..")"..event.phase ) 

 	 	x1 = event.x
		y1 = event.y

	end
	 

  		


 	star:setColor( 255, 102, 102, 255 )
  	star.width = 8
  	physics.addBody( star, { isSensor = true } ) 
	star.isHidden = NO 


	someGroup:insert(star)


	if event.phase == "ended" then
	
		Runtime:removeEventListener("touch", drawLine )

		function setRm(  )
			-- body
			removable = true
			Runtime:addEventListener("touch", removeLine )

			 for i=1,someGroup.numChildren do
			  local child = someGroup[i]
			  child.width = 20
			  child.height = 100
			  local description = (child.isVisible and "visible") or "not visible"
			  print( "child["..i.."] is " .. description )

						-- touch listener
						function child:touch( event )
						    -- 'self' parameter exists via the ':' in function definition
						    print( "child touched")
						    someGroup:removeSelf()
							Runtime:removeEventListener("touch", removeLine)

						end

						-- begin detecting touches
						child:addEventListener( "touch", child )
			  end 

		end
		timer.performWithDelay( 1000,setRm, 1 )

   
	end




end
Runtime:addEventListener("touch", drawLine )




















function setBoundaries()
	-- body
	local boundaryWalls = {}
	local wallThickness =5
	local wallCods = {{wallThickness,wallThickness,wallThickness,display.contentHeight},
	{wallThickness,display.contentHeight-wallThickness,display.contentWidth,wallThickness},
	{display.contentWidth-wallThickness,wallThickness,wallThickness, display.contentHeight},
	{wallThickness,wallThickness,display.contentWidth,wallThickness}}

	for i=1,4 do
		-- print(wallCods[i][1],wallCods[i][2],wallCods[i][3],wallCods[i][4])
		boundaryWalls[i]  = display.newRect(wallCods[i][1],wallCods[i][2],wallCods[i][3],wallCods[i][4] )
		physics.addBody(boundaryWalls[i], "static",{ friction=3, bounce=0, density=10})
	end
	 
end


setBoundaries()


-- -----------------------------------------------
-- ---------------LIGHTENING EFFECT---------------
-- -----------------------------------------------
 
-- _W = display.contentWidth
-- _H = display.contentHeight
 
-- gameStates = { menu = 0, pause = 1, gameOver = 2, levelSelection = 3, lightning = 4, inGame = 5};
-- currentState = gameStates["menu"];
 
-- function onTouch(event)
--         if (event.phase == "began") then
--                 print("creating lightning...")
--                 util.newLightning(_W/2,_H/2,event.x,event.y)
--                 _G.currentState = gameStates["lightning"]
--         end
-- end
 
-- Runtime:addEventListener("touch", onTouch)

-- ---------------------------------------------------------------------------
-- ---------------------------------------------------------------------------
-- ---------------------------------------------------------------------------



-------------------------------------
-- A sprite sheet with a cat---
-------------------------------------
-- local baseline =200

-- local sheet1 = sprite.newSpriteSheet( "test.png", 100, 103 )

-- local spriteSet1 = sprite.newSpriteSet(sheet1, 1, 5)
-- sprite.add( spriteSet1, "cat", 1, 5, 3000, 0 ) -- play 8 frames every 1000 ms

-- local instance1 = sprite.newSprite( spriteSet1 )
-- instance1.x = display.contentWidth / 4 + 40
-- instance1.y = baseline - 75
-- -- instance1.xScale = .5
-- -- instance1.yScale = .5

-- instance1:prepare("cat")
-- instance1:play()

function stickyImage()

		function addImage(childImage )

			-- add a image when there is a tap on the background
			-- if (event.numTaps == 1) then
			-- 	-- create a image to bounce around
			-- 	-- local radius = math.random( 10, 60 )
			-- 	-- local image = display.newCircle( event.x, event.y, radius )
			-- 	local image = display.newRect(200,200,100,100 )
			-- 	image.name = "image"
			-- 	-- image.radius = radius
			-- 	-- image:setFillColor( math.random(150, 255), math.random(150, 255), math.random(150, 255) )
			-- 	physics.addBody( image, "dynamic", { friction=1, bounce=.7, density=1, radius=radius } )
				local image = childImage
				-- touches on the image will drag it round the screen
				function image:touch( event )
					if (event.phase == "began") then
						-- set drag focus to the image to be dragged
						display.getCurrentStage():setFocus( image )
						image.joint = physics.newJoint( "touch", image, event.x, event.y )
					elseif (event.phase == "moved") then
						-- drag the image
						image.joint:setTarget( event.x, event.y )
					else
						-- stop dragging the image
						display.getCurrentStage():setFocus( nil )
						image.joint:removeSelf()
					end
					
					-- tell system we've handled the touch
					return true
				end
				
				-- listen for touch drag on the image
				image:addEventListener( "touch", image )
				
				-- used to attach the weld joint, because that can't be done in the collision event handler
				function image:timer( event )
					-- only attach the joint to images and weld is not already attached (use a table to add multiple joints)
					if (image.weld == nil and image.other ~= nil) then
						-- add joint
						image.weld = physics.newJoint( "weld", image, image.other, image.x, image.y )
						-- we don't need to keep track of the other object to be jointed
						image.other = nil
					end
				end
				
				-- when collisions happen start the timer to add the joint because it can't be done here
				function image:collision( event )
					-- only attach the joint to images, not walls!
					if (event.other.name == "image") then
						-- keep track of the other object to join to
						image.other = event.other
						-- start the timer on a very short expiry
						timer.performWithDelay( 0, image, 1 )
					end
				end
				
				-- listen for collisions with the image
				image:addEventListener( "collision", image )
			-- end
			
			-- tell system we've handled the tap
			return true
		end


		for i=1,4 do
				print(i)
				childImage[i] = display.newImage("image"..i..".png")
				childImage[i].name = "image"
				childImage[i].x = 100*i
				childImage[i].y = 200*i
				physics.addBody(childImage[i], "kinetic",{ friction=3, bounce=0, density=10})
				childImage[i].angularDamping = 10
				childImage[i].linearDamping = 10

			addImage(childImage[i])

		end

end

local function onShake (event)
if event.isShake then
print "Device was shaken"
end
end
Runtime:addEventListener("accelerometer", onShake)