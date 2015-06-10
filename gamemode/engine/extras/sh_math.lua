-- v1.1.0
-- * Changed the way wrap works to make it simplier
-- * Renamed math.logBase to math.logx
-- * math.sum, math.mean, math.standardDeviation now accept tables
-- * math.dot now supports 3D vectors
-- + math.wrapInt(value, low, high)
-- + math.even(value)
-- + math.error(value, target)
-- + math.cross(x1, y1, z1, x2, y2, z2)
-- + math.csc(x), math.acsc(x), math.csch(x)
-- + math.sec(x), math.asec(x), math.sech(x)
-- + math.cot(x), math.acot(x), math.coth(x)
-- + math.cumulativeSum(...)
-- + math.prime(value)
-- + math.factor(value)
-- + math.primeFactor(value)
-- + math.median(...)
-- + math.poly(x, ...)
-- + math.perfect(value)
-- + math.rootx(x, root)
-- + math.primeDecomp(value)
-- + math.gcd(a, b)
-- + math.quadRoots(a, b, c)
-- + math.polyDerive(...)

-- Constants
math.e = 2.71828182845904523536028747135266249775724709369995
math.tau = math.pi * 2.0
math.halfPI = math.pi * 0.5
math.goldenRatio = 1.618033988749894848204586834365638117720309179

-- Localized globals
local funcRandom = math.random
local funcRandomSeed = math.randomseed
local funcFloor = math.floor
local funcCeil = math.ceil
local funcCosine = math.cos
local funcArcCosine = math.acos
local funcCosineH = math.cosh
local funcSine = math.sin
local funcArcSine = math.asin
local funcSineH = math.sinh
local funcTangent = math.tan
local funcArcTangent = math.atan
local funcTangentH = math.tanh
local funcATan2 = math.atan2
local funcSqrt = math.sqrt
local funcLog = math.log
local funcMod = math.mod
local funcAbs = math.abs
local funcPow = math.pow
local funcOsTime = os.time
local mathPI = math.pi
local mathHalfPI = math.halfPI
local mathTau = math.tau
local mathE = math.e

-- Initializes the random seed so that it can start to produce
-- quality random numbers.
function math.initiateRandom()
	funcRandomSeed(funcOsTime())
	funcRandom()
	funcRandom()	
end
math.initiateRandom()

-- Finds the factorial of a number
-- WARNING: This shit can cause stack overflow like a bitch
-- so keep value as a fairly low integer
function math.factorial(value)
	if value == 1 then return value end
	return value * math.factorial(value - 1)
end

-- Gives you the log, with the specified base, of x
function math.logx(base, value)
	return funcLog(value) / funcLog(base)
end

-- Returns the nth root of x
function math.rootx(x, root)
	return x ^ (1 / root)
end

-- Returns -1 if value is negative and 1 if positive, 0 if it is zero
function math.sign(value)
	if value > 0 then return 1 end
	if value < 0 then return -1 end
	return 0
end

-- Returns true if the value is even
function math.even(value)
	return funcMod(value, 2) == 0
end

-- Rounds the value to the nearest whole number
function math.round(value)
	return funcFloor(value + 0.5)
end

-- Rounds the val to the nearest digit
function math.roundTo(value, digit)
	return funcFloor((value / digit) + 0.5) * digit
end

-- Clamps value between low and high
function math.clamp(value, low, high)
	if value <= low then return low end
	if high and value >= high then return high end
	return value
end

-- Wraps the value around the low and high parameters
function math.wrap(value, low, high)
	local dif = high - low
	local offSet = value - low
	return low + (dif * ((offSet / dif) - funcFloor(offSet / dif)))
end
function math.wrapInt(value, low, high)
	local dif = high - low + 1
	local offSet = value - low
	return low + (dif * ((offSet / dif) - funcFloor(offSet / dif)))
end

-- Returns the value of an expressed polynomial using Horner's rule
-- Coefficients are ordered from lowes to highest power
-- ex. (-19 + 7x - 4x^2 + 6x^3, x = 2) => math.poly(2, -19, 7, 4, 6)
function math.poly(x, ...)
    local val = 0
    for i = #arg, 1, -1 do
        val = val * x + arg[i]
    end
    return val
end

-- Returns a table of the coeficients of the dirivative
function math.polyDerive(...)
	local newPolynomail = {}
	-- First coeficient is removed because it the constant
    for i = 2, #arg do
		newPolynomail[i - 1] = arg[i] * (i - 1)
    end
	return newPolynomail
end

function math.polyRoots(...)
	arg.n = nil
	if #arg == 2 then
		return {-arg[1] / arg[2]}
	end
	local oddPower = (#arg - 1) % 2 ~= 0
	local crossTheX = (arg[#arg] > 0 and arg[1] < 0) or (arg[#arg] < 0 and arg[1] > 0)
	local posibleRoots = oddPower or crossTheX
	if not posibleRoots then return {} end
	
	local derCoeif = math.polyDerive(unpack(arg))
	local critPoints = math.polyRoots(unpack(derCoeif))
	
	local guessPoints = {}
	if #critPoints > 0 then
		guessPoints[1] = critPoints[1] - 1
		for i = 1, #critPoints do
			if i ~= #critPoints then
				guessPoints[#guessPoints + 1] = (critPoints[i] + critPoints[i + 1]) * 0.5
			else
				guessPoints[#guessPoints + 1] = critPoints[i] + 1
			end
		end
	end
	if #guessPoints <= 0 then
		guessPoints[1] = 0
	end
	
	print("coef")
	print(unpack(arg))
	print("dercoef")
	print(unpack(derCoeif))
	table.prints(critPoints)
	table.prints(guessPoints)
	
	local roots = {}
	for i = 1, #guessPoints do
		local last, current = guessPoints[i], 0
		while true do
			local f1 = math.poly(last, unpack(arg))
			local f2 = math.poly(last, unpack(derCoeif))
			current = last - (f1 / f2)
			print("level " .. current)
			if math.roundTo(last, 0.0000001) == math.roundTo(current, 0.0000001) then
			--if last == current then
				roots[#roots + 1] = current
				break
			end
			last = current
		end
	end

	table.sort(roots, function(a, b) return a < b end)
	return roots
end

-- Finds the roots of a quadratic polynomial
function math.quadRoots(a, b, c)
	if b < 0 then return math.quadRoots(-a, -b, -c) end
	local inSqrt = b^2 - (4 * a * c)
	if inSqrt >= 0 then
		local val = b + funcSqrt(inSqrt) -- This never exhibits instability if b > 0
		return -val / (2 * a), -2 * c / val -- 2c / val is the same as the "unstable" second root
	end
end

-- Returns true if the value is prime
-- Must be a positive integer
local primeCacheSize = 40
local primeCache = {false, true, true, false, true, false, true, false, false, false,
					true, false, true, false, false, false, true, false, true, false,
					false, false, true, false, false, false, false, false, true, false,
					true, false, false, false, false, false, true, false, false, false}
function math.prime(value)
	if value <= 1 or (value ~= 2 and value % 2 == 0) then
		return false
	end
	if value <= primeCacheSize then return primeCache[value] end
	
	for i = 3, funcSqrt(value), 2 do
		if value % i == 0 then
			return false
		end
	end
	
    return true
end

-- Returns a tbale of the prime factor decomposition
-- ex. 12 = 2 × 2 × 3, so 12 returns {2, 2, 3}
local lFuncPrime = math.prime
function math.primeDecomp(value)
	local decomp = {}
	
	if lFuncPrime(value) then
		return {value}
	end
	
	local i = 2
	repeat
		while value % i == 0 do
			decomp[#decomp + 1] = i
			value = value / i
		end
		
		repeat
			i = i + 1
		until lFuncPrime(i)
	until value == 1
	
	return decomp
end

-- Returns true if the value is perfect
function math.perfect(value)
	local sum = 0
	for i = 1, value - 1 do
		if value % i == 0 then
			sum = sum + i
		end
	end
	return sum == value
end

-- Returns a list of factors of the value
-- Must be integer and positive!
function math.factor(value)
	if value < 0 then return end
	local factors = {1}
	for i = 2, value * 0.5 do
		if value % i == 0 then
			factors[#factors + 1] = i
		end
	end
	factors[#factors + 1] = value
	return factors
end

-- Returns a list of prime factors of the value
-- Must be integer and positive!
local lFuncPrime = math.prime
function math.primeFactor(value)
	if value < 0 then return end
	local factors, prime = {}, true
	for i = 2, value * 0.5 do
		if value % i == 0 then
			if lFuncPrime(i) then
				factors[#factors + 1] = i
			end
		end
	end
	return factors
end

-- Returns the greatest common divisor of two values
function math.gcd(a, b)
	if b ~= 0 then
		return math.gcd(b, a % b)
	end
	return funcAbs(a)
end

-- Returns a random float between low and high arguments
function math.randomf(low, high)
	return low + ((high - low) * funcRandom())
end


-- Returns a random key based on its value (weight)
-- example: math.weightedRandom({foo = 20, bar = 10, polkm = 1}))
-- Weights are NOT percents, they get "normalized"
function math.weightedRandom(tbl)
	local weightSum = 0
	for choice, weight in pairs(tbl) do
		weightSum = weightSum + weight
	end
	
	local threshold = math.random(0, weightSum)
	local last_choice
	for choice, weight in pairs(tbl) do
		threshold = threshold - weight
		if threshold <= 0 then return choice end
		last_choice = choice
	end
	return last_choice
end

-- Linearly interpotates a to b by delta
function math.lerp(a, b, delta)
	return a + (b - a) * delta
end
-- Linearly interpotates point one to two by delta
function math.lerp2(x1, y1, x2, y2, delta)
	local xLerp = x1 + (x2 - x1) * delta
	local yLerp = y1 + (y2 - y1) * delta
	return xLerp, yLerp
end
-- Linearly interpotates a table to b table by delta
function math.lerpTable(a, b, delta)
	local retTbl = {}
	for key, val in pairs(a) do
		retTbl[key] = math.lerp(val, b[key], delta)
	end
	return retTbl
end

-- Cosine interpolation of a to b by delta
function math.cosInterp(a, b, delta)
	local f = (1 - funcCosine(delta * mathPI)) * 0.5
	return (a * (1 - f)) + (b * f)
end
-- Cosine interpolation of point 1 to point 2 by delta
function math.cosInterp2(x1, y1, x2, y2, delta)
	local f = (1 - funcCosine(delta * mathPI)) * 0.5
	local inverseF = (1 - f)
	local cosInterpX = (x1 * inverseF) + (x2 * f)
	local cosInterpY = (y1 * inverseF) + (y2 * f)
	return cosInterpX, cosInterpY
end

-- Returns the length of the vector
function math.length(x, y)
	return funcSqrt((x * x) + (y * y))
end
function math.lengthSquared(x, y)
	return (x * x) + (y * y)
end

-- Returns the distance between two points
function math.dist(x1, y1, x2, y2)
	local deltaX, deltaY = x2 - x1, y2 - y1
	return funcSqrt((deltaX * deltaX) + (deltaY * deltaY))
end
function math.distSquared(x1, y1, x2, y2)
	local deltaX, deltaY = x2 - x1, y2 - y1
	return (deltaX * deltaX) + (deltaY * deltaY)
end

-- Returns angle between two points
function math.angle(x1, y1, x2, y2)
	return funcATan2(x2 - x1, y2 - y1)
end

-- Normalize the vector
function math.normalize(x, y)
	local length = funcSqrt(x * x + y * y)
	if length == 0 then
		return 0, 0
	end
	return x / length, y / length
end

-- Normalize that accepts any number of arguments
function math.nNormalize(...)
	local length, val = 0
	local normalTable = {}
	for i = 1, #arg do
		val = arg[i]
		length = length + (val * val)
	end
	length = funcSqrt(length)
	if length == 0 then
		for i = 1, #arg do
			normalTable[i] = 0
		end
	else
		for i = 1, #arg do
			normalTable[i] = arg[i] / length
		end
	end
	return unpack(normalTable)
end

-- Dot product of the two 2D or 3D vectors
function math.dot(x1, y1, z1, x2, y2, z2)
	if y2 and z2 then
		return (x1 * x2) + (y1 * y2) + (z1 * z2)
	else
		return (x1 * z1) + (y1 * x2)
	end
end

-- Cross product of two 3D vectors
function math.cross(x1, y1, z1, x2, y2, z2)
	return (y1 * z2) - (z1 * y2), (z1 * y2) - (x1 * z2), (x1 * y2) - (y1 * x2)
end

-- Normalizes the radian so that it is inbetween 0 and tau (2pi)
function math.normalizeRadians(radians)
	return radians - (funcFloor(radians / mathTau) * mathTau);
end
-- Normalizes the degree so that it is inbetween 0 and 360
function math.normalizeDegrees(degrees)
	return degrees - (funcFloor(degrees / 360) * 360);
end

-- Rotates the vector about the origin by angles (in radians)
function math.rotate(x, y, angle)
	local cosAngle = funcCosine(angle)
	local sinAngle = funcSine(angle)
	return (x * cosAngle) - (y * sinAngle), (x * sinAngle) + (y * cosAngle)
end





-- Matrix functions
-- Returns the identity matrix
function math.getIdenity2x2()
	return {1, 0, 0, 1}
end
-- Rotates a matrix by angle (in radians)
function math.rotateMatrix2x2(angle, mat)
	local cosAngle, sinAngle = funcCosine(angle), funcSine(angle)
	local a, b, c, d = mat[1], mat[2], mat[3], mat[4]
	mat[1] = (a * cosAngle) - (c * sinAngle)
	mat[2] = (b * cosAngle) - (d * sinAngle)
	mat[3] = (a * sinAngle) + (c * cosAngle)
	mat[4] = (b * sinAngle) + (d * cosAngle)
	return mat
end
function math.getRotationMatrix2x2(angle)
	local cosAngle, sinAngle = funcCosine(angle), funcSine(angle)
	return {cosAngle, sinAngle, sinAngle, cosAngle}
end
-- Multiplies two 2x2 matricies
function math.multMatrix2x2(mat1, mat2)
	return {mat1[1] * mat2[1], mat1[2] * mat2[2],
			mat1[3] * mat2[3], mat1[4] * mat2[4]}
end
-- Multiplies a vector by a 2x2 matrix
function math.multVector2x2(x, y, mat)
	return (x * mat[0]) + (y * mat[1]), (x * mat[2]) + (y * mat[3])
end

-- Multiplies a vector by a 3 x 2 matrix
function math.multVector3x2(x, y, mat)
	return (x * mat[0]) + (y * mat[1]) + mat[3], (x * mat[3]) + (y * mat[4]) + mat[5]
end