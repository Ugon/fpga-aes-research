# from pyAES import shiftRows, expandKey, subBytes, addRoundKey, mixColumns, createRoundKey
from pyAES import *
from random import randint

# FILE_FOLDER = '../mem/mix_columns'
# FILE_FOLDER = '../mem/rev_not'
# FILE_FOLDER = '../mem/sub_bytes'
# FILE_FOLDER = '../mem/enc'
FILE_FOLDER = '../mem/enc2'
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

postamble = '\nEND;'

def string_to_state(string):
	state = []
	for i in xrange(16):
		state.append(int(string[i * 2: (i + 1) * 2], 16))
	return flip(state)

def string_to_key(string):
	state = []
	for i in xrange(32):
		state.append(int(string[i * 2: (i + 1) * 2], 16))
	return state

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

def as_string(state):
	return ''.join(map(lambda x: '{0:02X}'.format(x), flip(state)))

def key_as_string(key):
	return ''.join(map(lambda x: '{0:02X}'.format(x), key))

for i in xrange(NUMBER):
	filename_in = FILE_FOLDER + '/' + FILE_PREFIX + str(i) + '_in' + FILE_SUFFIX
	filename_out = FILE_FOLDER + '/' + FILE_PREFIX + str(i) + '_out' + FILE_SUFFIX
	filename_key_hign = FILE_FOLDER + '/' + FILE_PREFIX + str(i) + '_key_high' + FILE_SUFFIX
	filename_key_low = FILE_FOLDER + '/' + FILE_PREFIX + str(i) + '_key_low' + FILE_SUFFIX
	with open(filename_in, 'w+') as f_in, open(filename_out, 'w+') as f_out, open(filename_key_hign, 'w+') as f_high, open(filename_key_low, 'w+') as f_low:
		f_high.write(preamble)
		f_low.write(preamble)
		f_in.write(preamble)
		f_out.write(preamble)

		for j in xrange(DEPTH):
			state = [randint(0, 255) for x in xrange(16)]
			key_high = [randint(0, 255) for x in xrange(16)]
			key_low = [randint(0, 255) for x in xrange(16)]
			
			# wtf
			# state = string_to_state("6353e08c0960e104cd70b751bacad0e7")
			# key_high = string_to_state("000102030405060708090a0b0c0d0e0f")
			# key_low = string_to_state("101112131415161718191a1b1c1d1e1f")
			
			# state = string_to_state("00112233445566778899aabbccddeeff")
			# key_high = string_to_key("000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f")[0:16]
			# key_low = string_to_key("000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f")[16:32]

			
			f_high.write('{0:02X}: '.format(j))
			f_high.write(key_as_string(key_high))
			f_high.write(';\n')

			f_low.write('{0:02X}: '.format(j))
			f_low.write(key_as_string(key_low))
			f_low.write(';\n')

			f_in.write('{0:02X}: '.format(j))
			f_in.write(as_string(state))
			f_in.write(';\n')

			# subBytes(state)
			# mixColumns(state)
			# rev_not(state)
			
			expandedKey = expandKey(key_high + key_low)
			round_key = flip(createRoundKey(expandedKey, 0))
			addRoundKey(state, round_key)

			round_key = flip(createRoundKey(expandedKey, 1))
			aesRound(state, round_key)

			round_key = flip(createRoundKey(expandedKey, 2))
			aesRound(state, round_key)

			round_key = flip(createRoundKey(expandedKey, 3))
			aesRound(state, round_key)

			round_key = flip(createRoundKey(expandedKey, 4))
			aesRound(state, round_key)

			round_key = flip(createRoundKey(expandedKey, 5))
			aesRound(state, round_key)

			round_key = flip(createRoundKey(expandedKey, 6))
			aesRound(state, round_key)

			round_key = flip(createRoundKey(expandedKey, 7))
			aesRound(state, round_key)

			round_key = flip(createRoundKey(expandedKey, 8))
			aesRound(state, round_key)

			round_key = flip(createRoundKey(expandedKey, 9))
			aesRound(state, round_key)

			round_key = flip(createRoundKey(expandedKey, 10))
			aesRound(state, round_key)

			round_key = flip(createRoundKey(expandedKey, 11))
			aesRound(state, round_key)

			round_key = flip(createRoundKey(expandedKey, 12))
			aesRound(state, round_key)

			round_key = flip(createRoundKey(expandedKey, 13))
			aesRound(state, round_key)

			round_key = flip(createRoundKey(expandedKey, 14))
			subBytes(state)
			shiftRows(state)
			addRoundKey(state, round_key)

			f_out.write('{0:02X}: '.format(j))
			f_out.write(as_string(state))
			f_out.write(';\n')

		f_high.write(postamble)
		f_low.write(postamble)
		f_in.write(postamble)
		f_out.write(postamble)
