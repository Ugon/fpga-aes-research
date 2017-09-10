from pyAES import shiftRows, expandKey, subBytes, addRoundKey, mixColumns, createRoundKey

def flip(state):
	flip = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
	flip[0] = state[0]
	flip[1] = state[4]
	flip[2] = state[8]
	flip[3] = state[12]
	flip[4] = state[1]
	flip[5] = state[5]
	flip[6] = state[9]
	flip[7] = state[13]
	flip[8] = state[2]
	flip[9] = state[6]
	flip[10] = state[10]
	flip[11] = state[14]
	flip[12] = state[3]
	flip[13] = state[7]
	flip[14] = state[11]
	flip[15] = state[15]
	return flip

key = [
	int('00', 16),
	int('01', 16),
	int('02', 16),
	int('03', 16),
	int('04', 16),
	int('05', 16),
	int('06', 16),
	int('07', 16),
	int('08', 16),
	int('09', 16),
	int('0a', 16),
	int('0b', 16),
	int('0c', 16),
	int('0d', 16),
	int('0e', 16),
	int('0f', 16),
	int('10', 16),
	int('11', 16),
	int('12', 16),
	int('13', 16),
	int('14', 16),
	int('15', 16),
	int('16', 16),
	int('17', 16),
	int('18', 16),
	int('19', 16),
	int('1a', 16),
	int('1b', 16),
	int('1c', 16),
	int('1d', 16),
	int('1e', 16),
	int('1f', 16)
	]

state = flip([
	int('00', 16),
	int('11', 16),
	int('22', 16),
	int('33', 16),
	int('44', 16),
	int('55', 16),
	int('66', 16),
	int('77', 16),
	int('88', 16),
	int('99', 16),
	int('aa', 16),
	int('bb', 16),
	int('cc', 16),
	int('dd', 16),
	int('ee', 16),
	int('ff', 16)
	])



def asString(state):
	return ''.join(map(lambda x: '{0:02x}'.format(x), flip(state)))


key_expanded = expandKey(key)

print asString(state)

key_schedule = createRoundKey(key_expanded, 0)
addRoundKey(state, flip(key_schedule))
print asString(flip(key_schedule)) + '\n'
print asString(state)

subBytes(state)
print asString(state)

shiftRows(state)
print asString(state)

mixColumns(state)
print asString(state)

key_schedule = createRoundKey(key_expanded, 1)
addRoundKey(state, flip(key_schedule))
print asString(flip(key_schedule)) + '\n'
print asString(state)

subBytes(state)
print asString(state)

shiftRows(state)
print asString(state)

mixColumns(state)
print asString(state)

key_schedule = createRoundKey(key_expanded, 2)
addRoundKey(state, flip(key_schedule))
print asString(flip(key_schedule)) + '\n'
print asString(state)

subBytes(state)
print asString(state)

shiftRows(state)
print asString(state)

mixColumns(state)
print asString(state)

key_schedule = createRoundKey(key_expanded, 3)
addRoundKey(state, flip(key_schedule))
print asString(flip(key_schedule)) + '\n'
print asString(state)

subBytes(state)
print asString(state)

shiftRows(state)
print asString(state)

mixColumns(state)
print asString(state)

key_schedule = createRoundKey(key_expanded, 4)
addRoundKey(state, flip(key_schedule))
print asString(flip(key_schedule)) + '\n'
print asString(state)

subBytes(state)
print asString(state)

shiftRows(state)
print asString(state)

mixColumns(state)
print asString(state)

key_schedule = createRoundKey(key_expanded, 5)
addRoundKey(state, flip(key_schedule))
print asString(flip(key_schedule)) + '\n'
print asString(state)

subBytes(state)
print asString(state)

shiftRows(state)
print asString(state)

mixColumns(state)
print asString(state)

key_schedule = createRoundKey(key_expanded, 6)
addRoundKey(state, flip(key_schedule))
print asString(flip(key_schedule)) + '\n'
print asString(state)

subBytes(state)
print asString(state)

shiftRows(state)
print asString(state)

mixColumns(state)
print asString(state)

key_schedule = createRoundKey(key_expanded, 7)
addRoundKey(state, flip(key_schedule))
print asString(flip(key_schedule)) + '\n'
print asString(state)

subBytes(state)
print asString(state)

shiftRows(state)
print asString(state)

mixColumns(state)
print asString(state)

key_schedule = createRoundKey(key_expanded, 8)
addRoundKey(state, flip(key_schedule))
print asString(flip(key_schedule)) + '\n'
print asString(state)

subBytes(state)
print asString(state)

shiftRows(state)
print asString(state)

mixColumns(state)
print asString(state)

key_schedule = createRoundKey(key_expanded, 9)
addRoundKey(state, flip(key_schedule))
print asString(flip(key_schedule)) + '\n'
print asString(state)

subBytes(state)
print asString(state)

shiftRows(state)
print asString(state)

mixColumns(state)
print asString(state)

key_schedule = createRoundKey(key_expanded, 10)
addRoundKey(state, flip(key_schedule))
print asString(flip(key_schedule)) + '\n'
print asString(state)

subBytes(state)
print asString(state)

shiftRows(state)
print asString(state)

mixColumns(state)
print asString(state)