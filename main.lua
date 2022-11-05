function getHex(num, length)
	length = length or -1
	num = string.format("%X", num)
	fin = ""

	if (length == -1) then
		return num
	elseif (#num > length) then
		print("LENGTH IS LESS THAN NUMBER")
		return nil
	elseif (#num == length) then
		return num
	end
	
	for i=1,(length - #num) do
		fin = fin.."0"
	end
	fin = fin..num

	return fin
end

function writeLittleEndian(f, hex)
	if (#hex %2 ~= 0) then
		hex = "0"..hex
	end

	npairs = #hex / 2
	
	for i=npairs,1,-1 do
		print("a"..hex:sub(2*i -1, 2*i))
		f:write(string.char(tonumber(hex:sub(2*i -1,2*i), 16)))
	end
end

function writeBigEndian(f, hex)
	if (#hex %2 ~= 0) then
		hex = "0"..hex
	end

	npairs = #hex/2

	for i=1,npairs do
		f:write(string.char(tonumber(hex:sub(2*i-1,2*i), 16)))
	end
end

io.write("SaveFile Name : ")
fname = io.read()
print("")

save = io.open(fname, "r")
res = io.open("buffer", "w+")

res:write(save:read("*all"))

save:close()

-- Money Offset :- 0xA16A

res:seek("set", tonumber("0xA16A"))
print("How much money do you want?")
io.write("(0->4,294,967,295):")
num = tonumber(io.read())
fin = ""

if ( num < 0 ) or ( num > 4294967295 ) then
	print("INVALID CHOICE")
	print(num)
	os.exit()
end

a = getHex(num, 8)
writeLittleEndian(res, a)

save = io.open(fname, "w")
res:seek("set", 0)
save:write(res:read("*all"))
save:close()
res:close()
os.remove("buffer")
