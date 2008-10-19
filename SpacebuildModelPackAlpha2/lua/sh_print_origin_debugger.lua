OldPrintFunc = print

function print(...)
	if arg[1] == "nil" then
		debug.Trace()
	end
	
	return Msg(unpack(arg), "\n")
end