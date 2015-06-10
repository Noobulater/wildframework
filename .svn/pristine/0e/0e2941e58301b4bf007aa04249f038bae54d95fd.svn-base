classEvent = {}
classEvent.Events = {}
function classEvent.add( name, entry)
	classEvent.Events[name] = entry
end

function classEvent.get( name )
	return classEvent.Events[name]
end

function classEvent.remove( name )
	classEvent.Events[name] = nil
end

function classEvent.new( eventName )

	local public = {}

	if classEvent.get( eventName ) != nil then
		public = table.Copy( classEvent.get( eventName ) ) 
	else
		function public.initialize( ply )
			
		end
	end 
	return public

end