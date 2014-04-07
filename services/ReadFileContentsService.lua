local json = require( "json" )

function loadTable(filename, filePath)  
    local path = system.pathForFile( filename, filePath)    
    local contents = "" 
    local myTable = {}  
    local file = io.open( path, "r" )   
    if file then    
         -- read all contents of file into a string 
         local contents = file:read( "*a" ) 
         myTable = json.decode(contents);   
         io.close( file )   
         return myTable     
    else
        print( "file not found" )
        return nil
    end

      
end

function saveTable(filename, filePath, contents)
    local path = system.pathForFile( filename, filePath)
    local file = io.open(path, "w")
    if file then
        local _contents = json.encode(contents)
        file:write( _contents )
        io.close( file )
        return true
    else
        return false
    end
end