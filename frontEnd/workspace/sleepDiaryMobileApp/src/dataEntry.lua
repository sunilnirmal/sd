

local storyboard = require ( "storyboard" )

--Create a storyboard scene for this module
local scene = storyboard.newScene()

--Create the scene
function scene:createScene( event )
	local group = self.view
	storyboard.returnTo = "homePage";
	-- Set up the background
	local background = display.newImage( "assets/wallpaper.jpg" )
	group:insert( background, true)
	background.isFullResolution = true

		
		
	local buttonHandlerMorning = function( event )
		storyboard.gotoScene("morningRoutine","slideDown")
	end
	
	local buttonHandlerEvening = function( event )
		storyboard.gotoScene("screen3","slideUp");
	end
	
	local buttonHandlerBack = function( event )
		storyboard.gotoScene("homePage","fromLeft");
	end
	
	local widget = require( "widget" )
	widget.setTheme( "widget_theme_ios" )
	
	local eveningButton = widget.newButton {
		id = "Evening",
		defaultFile = "assets/night.jpg",
		overFile = "assets/nightPress.jpg",
		label = "Evening Routine",
		left = 75,
    	top = 200,
    	width = 200,
    	height = 200,
		emboss = true,
		onPress = buttonHandlerEvening,
	}	
	group:insert(eveningButton,true)
	
	
	
	local morningButton = widget.newButton {
		id = "morning",
		defaultFile = "assets/Morning.jpg",
		overFile = "assets/MorningPress.jpg",
		label = "Morning Routine",
		font = "MarkerFelt-Thin",
		emboss = true,
		onPress = buttonHandlerMorning,
		left = 50,
    	top = 50,
    	width = 200,
    	height = 200,
	}
	
	group:insert(morningButton,true)
	
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
	
	group:insert(backButton,true)
	
end

--Add the createScene listener
scene:addEventListener( "createScene", scene )




return scene

