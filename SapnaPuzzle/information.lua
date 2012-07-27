module(..., package.seeall)
--import the scrolling classes
local scrollView = require("scrollView")
local util = require("util")
local ui = require("ui")

local fontsType = "Noteworthy-Bold" --"MarkerFelt-Wide"--"Noteworthy-Bold" --"Chalkboard-Bold"--


-- Setup a scrollable content group
local topBoundary = display.screenOriginY
local bottomBoundary = display.screenOriginY

local infoGroup




function loadInformation()
	-- fontsType = fontType
	print("loadInformation - fontType "..fontsType)
	infoGroup = display.newGroup()

	local scrollView = scrollView.new{ top=topBoundary, bottom=bottomBoundary }
	-- infoGroup:insert(scrollView)


	textArea = ui.newLabel{
			bounds = { display.contentWidth/2.7, display.contentHeight/100, display.contentWidth/4, display.contentHeight/9 },
			text = " ",
			font = fontsType,
			textColor = { 5, 5, 5, 255 },
			size = display.contentWidth/15,
			align = "center"
			}
			
			textArea:setText("About SapnaSolutions ")

		infoGroup:insert(textArea)
		scrollView:insert(textArea)


	local SapnaSolutions = "SapnaSolutions"


	
	
	

	local infoText = "SapnaSolutions is a new type of web \ndevelopment company:\n\nWe follow a two tier strategy of delivering \nhighly engaging and creative client \nprojects on one hand, and developing \ninnovative, 'Intrapreneurial' Web, \nMobile and Social applications in-house \non the other hand.\n\n People are our greatest asset, and we \nstrive to create an intense, startup-like \nenvironment which is sustainable, fun \nand creative, empowering our teams to \nrealise their dreams. \n\n'Sapna' is the traditional Hindi word for \n'Dream', and realising dreams is what \nSapnaSolutions is all about! \nAt "..SapnaSolutions..", we Dare to Dream! "
	local myText = util.wrappedText(infoText, 39, 14, fontsType, {0,0,0})--wrappedText(str, limit, size, font, color, indent, indent1)
	
	myText.x = display.contentWidth/15
	myText.y = textArea.height +display.contentWidth/15
	scrollView:insert(myText)

	local closedCard = {}
	local openCard = {}
	local cardWidth = display.contentWidth/5
		function openWebPage()
		print("openWebPage-- body")
		system.openURL("http://sapnasolutions.com/portfolios-page/web")--( "http://developer.anscamobile.com" )
		-- native.showWebPopup( 10, 10, 300, 300,"http://www.google.com" )
		-- native.showWebPopup( 10, 10, 300, 300, "http://www.anscamobile.com")

	end
	for	i=0,31 do
		closedCard[i] = display.newImage( "images/GVRFaceClosed.png" )--( "images/GVRClosedCard.png" ) --( "images/GVRFaceB.png" )
		openCard[i] = display.newImage("images/GVRFace"..i..".png")
		
		closedCard[i]:scale(cardWidth/closedCard[i].width, cardWidth*1.5/closedCard[i].height)
		openCard[i]:scale((cardWidth-display.contentWidth/35)/closedCard[i].width, (cardWidth-display.contentWidth/35)/closedCard[i].height) --(closedCard[i].xScale*display.contentWidth/900, closedCard[i].yScale*display.contentWidth/900)

		infoGroup:insert(closedCard[i])
		scrollView:insert(closedCard[i])

		infoGroup:insert(openCard[i])
		scrollView:insert(openCard[i])

		
	end
	
textArea:addEventListener("tap", openWebPage)


	--CODE FOR CO-ORDINATES OF N x N POINTS

	local int k = 0
	for i=0,3 do
		for j=0,7 do
			closedCard[k].x = i*display.contentWidth/4 + display.contentWidth/(2*4) -- + margin/2
			closedCard[k].y = j*display.contentWidth/3 + ((display.contentHeight-display.contentWidth)/2+(display.contentWidth/(2*4))) + textArea.height + myText.height
			k=k+1
		end
	end

	for	i=0,31 do
		openCard[i].x = closedCard[i].x
		openCard[i].y = closedCard[i].y - display.contentWidth/25
	end

	local empList = {"Girish","Innovator\n iOS & Corona ",		"Anthony","Co-founder ",	"Shyam","The LION\n tamer ",		"Lalit","iOS Fanboy ",		"Natasha","Cheerful\n Sunshine ",		"Corinna","Social\n Butterfly ",		"Dario","Salespocalypse ",		"Shubhangi","Innovator ",		"Prashant","QA",	"Prabhath","Seriously\n into Quality ",		"Altaf","iOS FanMan ",		"Parag","iOS Fanboy ",		"Nitin","Quality Geek ",		"David","ESUPPLY",		"Shwet","iOS Fanboy ",		"Niklas","Insert\n Funny Reference",		"Abhishek","Project\n Manager ",		"Chandra","The Architect ",		"Vishal","Innovator ",		 "Surat","Rails Geek" ,		"Matteo","Project\n Manager ",	"Roshani","Recruiter ",		"Kalpesh","Innovator ",		"Ivan","Operations ",		"Peter","Sales ",		"Sandeep","Rails Geek ",		"Tali","HR Chika",		"Anna","Marketing &\n Sales Manager ",		"Ranjith","Rails\n MuscleMan ",		"Karishma","Recruiter ",		"Marco","Love for Sales",	"Eliza","ROR" }

	for i=0,31 do
		print(empList[i*2+2])

		empName = ui.newLabel{
				bounds = { closedCard[i].x - display.contentWidth/12, closedCard[i].y +  display.contentWidth/33
				, display.contentWidth/4, display.contentHeight/9 },
				text = " ",
				font = fontsType,
				textColor = { 5, 5, 5, 255 },
				size = display.contentWidth/30,
				align = "left"
				}
			empName:setText(empList[i*2+1])
			infoGroup:insert(empName)
			scrollView:insert(empName)

		empTitle = ui.newLabel{
				bounds = { closedCard[i].x - display.contentWidth/12, closedCard[i].y +  display.contentWidth/12, display.contentWidth/4, display.contentHeight/9 },
				text = " ",
				font = "AmericanTypewriter",
				textColor = { 5, 5, 5, 255 },
				size = display.contentWidth/40,
				align = "left"
				}
			empTitle:setText(empList[i*2+2])
			infoGroup:insert(empTitle)
			scrollView:insert(empTitle)

	end


	scrollView:addScrollBar()-- scroll bar to the right side of the screen

		-- Important! Add a background to the scroll view for a proper hit area
		local scrollBackground = display.newRect(0, 0, display.contentWidth, scrollView.height+ display.contentWidth/10 )
		scrollBackground:setFillColor( 211, 244, 193, 255)
		scrollView:insert(1, scrollBackground)
		infoGroup:insert(scrollBackground)
		scrollBackground:toBack()


	local buttonInfoBack

	function goBack( )
			print("buttonInfoBack")
			
				infoGroup:removeSelf()
				scrollView:cleanUp()
				-- scrollView:removeScrollBar()
				-- scrollView:toBack()
				scrollView:removeSelf()--Crashes here

				setFirstView()
		end	
		
	function quitScreen(event)
		print("quitScreen--------->"..event.phase)
		buttonInfoBack.alpha = 0
		timer.performWithDelay(500,goBack,1)
		if event.phase == "release" then
			if event.id == "buttonInfoBack" then
				timer.performWithDelay(2000,goBack,1)
			end
		end
	end



	buttonInfoBack = ui.newButton{
		default = "images/Back-Unpressed.png",
		over = "images/Back-Pressed.png",
		text = "",
		onEvent = quitScreen,
		id = "buttonInfoBack",
		font = fontsType,
		textColor = { 51, 51, 51, 255 },
		size =display.contentWidth*0.03,
		emboss = true
		}
	
	buttonInfoBack:scale(display.contentWidth/(8*buttonInfoBack.width),display.contentWidth/(8*buttonInfoBack.width))
	buttonInfoBack.x = display.contentWidth/9
	buttonInfoBack.y = display.contentHeight/12--scrollBackground.height--	
	infoGroup:insert(buttonInfoBack)
	scrollView:insert(buttonInfoBack)	
	
	local buttonInfoBackUp = display.newImage("images/Back-Pressed.png")
	buttonInfoBackUp:scale(display.contentWidth/(8*buttonInfoBackUp.width),display.contentWidth/(8*buttonInfoBackUp.width))
	buttonInfoBackUp.x = buttonInfoBack.x
	buttonInfoBackUp.y = buttonInfoBack.y
	infoGroup:insert(buttonInfoBackUp)
	scrollView:insert(buttonInfoBackUp)	


	buttonInfoBack = ui.newButton{
		default = "images/Back-Unpressed.png",
		over = "images/Back-Pressed.png",
		text = "",
		onEvent = quitScreen,
		id = "buttonInfoBack",
		font = fontsType,
		textColor = { 51, 51, 51, 255 },
		size =display.contentWidth*0.03,
		emboss = true
		}
	
	buttonInfoBack:scale(display.contentWidth/(4.5*buttonInfoBack.width),display.contentWidth/(4.5*buttonInfoBack.width))
	buttonInfoBack.x = display.contentWidth/9
	buttonInfoBack.y = scrollBackground.height--display.contentHeight/1.1	
	infoGroup:insert(buttonInfoBack)
	scrollView:insert(buttonInfoBack)	
	
	local buttonInfoBackUp = display.newImage("images/Back-Pressed.png")
	buttonInfoBackUp:scale(display.contentWidth/(4.5*buttonInfoBackUp.width),display.contentWidth/(4.5*buttonInfoBackUp.width))
	buttonInfoBackUp.x = buttonInfoBack.x
	buttonInfoBackUp.y = buttonInfoBack.y
	infoGroup:insert(buttonInfoBackUp)
	scrollView:insert(buttonInfoBackUp)	
	

	function slideBackAnimation( )
		-- body
		 scrollView:slideDown{time = 1000, slideAlpha = 0.5 , distance = display.contentHeight}
	end

	scrollView.y = scrollView.y + display.contentHeight
	scrollView:slideUp{time = 1000, delay = 1000, slideAlpha = 1 , distance = 2* display.contentHeight, onComplete = slideBackAnimation}

	return "hi" 


end




-- 
-- ALTAF BHAI'S SUGGESTION
-- to set corner radius of the image

-- local testImage = display.newImageRect("images/GVRFace0.png",100,100)
-- infoGroup:insert(testImage)
-- scrollView:insert(testImage)

