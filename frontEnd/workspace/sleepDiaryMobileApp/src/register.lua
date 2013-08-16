local storyboard = require ( "storyboard" )
local main, saveData, loadData
local dataTable, dataTableNew

-- Load external libraries
local str = require("str")

-- Set location for saved data
local filePath = system.pathForFile( "data1.txt", system.DocumentsDirectory )


--Create a storyboard scene for this module
local scene = storyboard.newScene()

function saveData()
	
	--local levelseq = table.concat( levelArray, "-" )

	file = io.open( filePath, "w" )
	
	for k,v in pairs( dataTable ) do
		file:write( k .. "=" .. v .. "," )
	end
	
	io.close( file )
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
		
		local welcome = display.newText("Welcome, ".. dataTableNew["userName"], 0,0, native.systemFont, 18)
		welcome.x = display.contentCenterX
		welcome.y = display.contentCenterY
		group:insert(welcome,true);
		print(dataTableNew["userName"])
		--local userName = display.newText(dataTableNew["userName"], 100, 300, native.systemFont, 18)
		--group:insert(userName,true);
		
	else
		dataTable = {}
		dataTable.userName = "user1"
		dataTable.emailId =  "random@user"
		saveData()
		local userName = display.newText("User registered", 0, 0, native.systemFont, 18)
		userName.x = display.contentCenterX
		userName.y = display.contentCenterY
		group:insert(userName,true);
	end

end

--Add the createScene listener
scene:addEventListener( "createScene", scene )

return scene
