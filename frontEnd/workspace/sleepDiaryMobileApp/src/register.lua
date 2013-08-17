local storyboard = require ( "storyboard" )
local main, saveData, loadData
local dataTable, dataTableNew
local answer = {};
local answers = {};
local scrollView
local y
-- Load external libraries
local str = require("str")
local Wrapper = require("wrapper")
local widget = require( "widget" )

local clock = os.clock
function sleep(n)  -- seconds
  local t0 = clock()
  while clock() - t0 <= n do end
end

-- Set location for saved data
local filePath = system.pathForFile( "data24.txt", system.DocumentsDirectory )


--Create a storyboard scene for this module
local scene = storyboard.newScene()

local buttonHandlerBack = function( event )
	storyboard.gotoScene("register","fromLeft");
end


function saveData()
	
	--local levelseq = table.concat( levelArray, "-" )

	file = io.open( filePath, "w" )
	
	for k,v in pairs( dataTable ) do
		file:write( k .. "=" .. v .. "," )
	end
	
	io.close( file )
end

local function scrollListener( event )
		local phase = event.phase
		local direction = event.direction
		
		if "began" == phase then
			--print( "Began" )
		elseif "moved" == phase then
			--print( "Moved" )
		elseif "ended" == phase then
			--print( "Ended" )
		end
		
		-- If the scrollView has reached it's scroll limit
		if event.limitReached then
			if "up" == direction then
				print( "Reached Top Limit" )
			elseif "down" == direction then
				print( "Reached Bottom Limit" )
			elseif "left" == direction then
				print( "Reached Left Limit" )
			elseif "right" == direction then
				print( "Reached Right Limit" )
			end
		end
end

local function networkListener( event )
 --       if ( event.isError ) then
                print( "Network error!")
 --       else
 --               print ( "RESPONSE: " .. event.response )
                dataTable = {}
				dataTable["userName"] = answers[1]
				dataTable["emailId"] =  answers[2]
				saveData()
				local userName = display.newText("User registered", 40, y + 40, native.systemFont, 18)
				print("networkListener>>>>>" .. dataTable["userName"] .. dataTable["emailId"] )
				scrollView:insert(userName,true);
				sleep(5)
				storyboard.gotoScene("homePage","fromLeft");
 --       end
end

local buttonHandlerSubmit = function( event )
	local headers = {}
	answers[1] = "user2"
	answers[2] = "user2@mail.com"
	headers["userName"] = answers[1]
	headers["data"] = answers[2]
	headers["TypeOfData"] = "registration"
	local body = answers[2]
    
    --Write to remote service
	local params = {}
	params.headers = headers
	params.body = body
	print("buttonHandlerSubmit>>>>>" .. answers[1] .. answers[2])
				
	network.request( "http://127.0.0.1/Dispatcher", "POST", networkListener, params)
		 local screenText = Wrapper:newParagraph({
			--text = "Wrapper Class Sample-Text\n\nCorona's framework dramatically increase productivity. \n\nTasks like animating objects in OpenGL or creating user-interface widgets take only one line of code, and changes are instantly viewable in the Corona Simulator. \n\nYou can rapidly test without lengthy build times.",
			text = "User is being registered......",
			
			width = 240,
			--height = 300, 			-- fontSize will be calculated automatically if set 
			--font = "helvetica", 	-- make sure the selected font is installed on your system
			fontSize = 18,			
			lineSpace = 2,
			alignment  = "left",
			
			-- Parameters for auto font-sizing
			fontSizeMin = 8,
			fontSizeMax = 12,
			incrementSize = 2
		})
		
		screenText.x = 40;
		screenText.y = y+80;
		scrollView:insert( screenText )
		 y = y+screenText.height
		 
		 y = y+80
		 
	
end


--Create the scene
function scene:createScene( event )
	local group = self.view
	local background = display.newImage( "assets/wallpaper.jpg" )
	group:insert( background, true)
	
	local file = io.open( filePath, "r" )
	
	if file then

		-- Read file contents into a string
		local dataStr = file:read( "*a" )
		
		-- Break string into separate variables and construct new table from resulting data
		local datavars = str.split(dataStr, ",")
		
		dataTableNew = {}
		
		for i = 1, #datavars do
			-- split each name/value pair
			local onevalue = str.split(datavars[i], "=")
			dataTableNew[onevalue[1]] = onevalue[2]
		end
	
		io.close( file ) -- important!
		
		local screenText = display.newText( "Welcome,".."\n"..dataTableNew["userName"], 0, 0, native.systemFontBold, 18 )
		screenText:setTextColor( 0 )
		screenText.x = display.contentCenterX
		screenText.y = display.contentCenterY
		group:insert( screenText )
	
		print(dataTableNew["userName"])
		sleep(5)
		storyboard.gotoScene("homePage","fromLeft");
		
	else
		
		scrollView = widget.newScrollView
		{
			left = 0,
			top = 0,
			width = display.contentWidth,
			height = display.contentHeight,
			bottomPadding = 50,
			id = "onBottom",
			hideBackground = true,
			horizontalScrollDisabled = true,
			verticalScrollDisabled = false,
			listener = scrollListener,
		}
		group:insert(scrollView)
		
		y = 50
	
	local type = {};

		 --print (questionnaire.child[i].child[1].value)
		 
-- Was Used for testing only
		 --answerString = answerString .. questionnaire.child[i].child[1].value .. "\n";
		 local screenText = Wrapper:newParagraph({
			--text = "Wrapper Class Sample-Text\n\nCorona's framework dramatically increase productivity. \n\nTasks like animating objects in OpenGL or creating user-interface widgets take only one line of code, and changes are instantly viewable in the Corona Simulator. \n\nYou can rapidly test without lengthy build times.",
			text = "Enter UserName",
			
			width = 240,
			--height = 300, 			-- fontSize will be calculated automatically if set 
			--font = "helvetica", 	-- make sure the selected font is installed on your system
			fontSize = 18,			
			lineSpace = 2,
			alignment  = "left",
			
			-- Parameters for auto font-sizing
			fontSizeMin = 8,
			fontSizeMax = 12,
			incrementSize = 2
		})
		
		screenText.x = 40;
		screenText.y = y;
		scrollView:insert( screenText )
		 y = y+screenText.height
		 
		 y = y+10
		 
		 answer[1] = native.newTextBox( 40, y + 20, 240, 30 )
		 
		 answer[1].hasBackground = false
		 answer[1].size = 16
		 answer[1].isEditable = true
		 answer[1].fontSize = 14
		 scrollView:insert(answer[1])
		 y = y+30
		 
		 local screenText = Wrapper:newParagraph({
			--text = "Wrapper Class Sample-Text\n\nCorona's framework dramatically increase productivity. \n\nTasks like animating objects in OpenGL or creating user-interface widgets take only one line of code, and changes are instantly viewable in the Corona Simulator. \n\nYou can rapidly test without lengthy build times.",
			text = "Enter e-mail",
			
			width = 240,
			--height = 300, 			-- fontSize will be calculated automatically if set 
			--font = "helvetica", 	-- make sure the selected font is installed on your system
			fontSize = 18,			
			lineSpace = 2,
			alignment  = "left",
			
			-- Parameters for auto font-sizing
			fontSizeMin = 8,
			fontSizeMax = 12,
			incrementSize = 2
		})
		
		screenText.x = 40;
		screenText.y = y;
		scrollView:insert( screenText )
		 y = y+screenText.height
		 
		 y = y+10
		 
		 answer[2] = native.newTextBox( 40, y + 20, 240, 30 )
		 
		 answer[2].hasBackground = false
		 answer[2].size = 16
		 answer[2].isEditable = true
		 answer[2].fontSize = 14
		 scrollView:insert(answer[2])
		 y = y+30

		local backButton  = widget.newButton {
		id = "back",
		defaultFile = "assets/back.png",
		label = "",
		font = "MarkerFelt-Thin",
		emboss = true,
		onPress = buttonHandlerBack,
		left = 250,
    	top = 10,
    	width = 40,
    	height = 40,
	}
	
	scrollView:insert(backButton)
	
	local submitButton  = widget.newButton {
		id = "submit",
		defaultFile = "assets/register.png",
		label = "Submit",
		font = "MarkerFelt-Thin",
		emboss = true,
		onPress = buttonHandlerSubmit,
		align = "centre",
		left = 100,
    	top = y+80,
    	width = 100,
    	height = 100,
	}
	 
	y = y+80
	scrollView:insert(submitButton,true)
	


	end

end

--Add the createScene listener
scene:addEventListener( "createScene", scene )

return scene