from pyAES import shiftRows, expandKey, subBytes, addRoundKey, mixColumns, createRoundKey
from random import randint

# FILE_FOLDER = '../mem/rev_not'
FILE_FOLDER = '../mem/sub_bytes'
FILE_PREFIX = 'mem'
FILE_SUFFIX = '.mif'
DEPTH = 32;
NUMBER = 2;

preamble = (
	'DEPTH = ' + str(DEPTH) + ';\n'
	'WIDTH = 128;\n'
	'ADDRESS_RADIX = HEX;\n'
	'DATA_RADIX = HEX;\n'
	'CONTENT\n'
	'BEGIN\n\n')

postablme = '\nEND;'

def string_to_state(string):
	state = []
	for i in xrange(16):
		state.append(int(string[i * 2: (i + 1) * 2], 16))
	return flip(state)

def rev_not(state):
	# state = map(lambda x: int(map(lambda y: '1' if y == '0' else '0', '{:08b}'.format(x)[::-1]), 2), state)
	a = map(lambda x: int(''.join(map(lambda y: '1' if y == '0' else '0', '{:08b}'.format(x)[::-1])), 2), state)
	for i in xrange(16):
		state[i] = a[15 - i]
		

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

def asString(state):
	return ''.join(map(lambda x: '{0:02X}'.format(x), flip(state)))

for i in xrange(NUMBER):
	filename_in = FILE_FOLDER + '/' + FILE_PREFIX + str(i) + '_in' + FILE_SUFFIX
	filename_out = FILE_FOLDER + '/' + FILE_PREFIX + str(i) + '_out' + FILE_SUFFIX
	with open(filename_in, 'w+') as f_in, open(filename_out, 'w+') as f_out:
		f_in.write(preamble)
		f_out.write(preamble)

		for j in xrange(DEPTH):
			state = [randint(0, 255) for x in xrange(16)]
			# state = string_to_state("00102030405060708090a0b0c0d0e0f0")

			f_in.write('{0:02X}: '.format(j))
			f_in.write(asString(state))
			f_in.write(';\n')

			subBytes(state)
			# rev_not(state)

			f_out.write('{0:02X}: '.format(j))
			f_out.write(asString(state))
			f_out.write(';\n')

		f_in.write(postablme)
		f_out.write(postablme)
