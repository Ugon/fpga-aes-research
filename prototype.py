from bitarray import bitarray
from sys import argv

# 2, 2 => 2
def xor2(inp1, inp2):
	return [inp1[0] ^ inp2[0], inp1[1] ^ inp2[1]]

# 4, 4 => 4
def xor4(inp1, inp2):
	return [inp1[0] ^ inp2[0], inp1[1] ^ inp2[1], inp1[2] ^ inp2[2], inp1[3] ^ inp2[3]]

# 2 => 2
def mul_phi(inp):
	a = inp[1]
	b = inp[0]
	c = a ^ b
	return [a, c]

# 4 => 4
def mul_lam(inp):
	a = inp[3]
	b = inp[2]
	c = inp[1]
	d = inp[0]
	e = a ^ c
	f = b ^ d
	g = e ^ f
	return [b, a, g, f]

# 4 => 4
def x_sq(inp):
	a = inp[3]
	b = inp[2]
	c = inp[1]
	d = inp[0]
	e = a ^ b
	f = b ^ c
	g = c ^ d
	h = a ^ g
	return [h, f, e, a]

# 2, 2 => 2
def mul2(inp1, inp2):
	a = inp1[1]	
	b = inp1[0]	
	c = inp2[1]	
	d = inp2[0] 
	e = a ^ b
	f = c ^ d
	g = a and c
	h = e and f
	i = b and d
	j = h ^ i
	k = g ^ i
	return [k, j]

# 4, 4 => 4
def mul4(inp1, inp2):
	a = inp1[2:4]
	b = inp1[0:2]
	c = inp2[2:4]
	d = inp2[0:2]
	e = xor2(a, b)
	f = xor2(c, d)
	g = mul2(a, c)
	h = mul2(e, f)
	i = mul2(b, d)
	g_phi = mul_phi(g)
	j = xor2(h, i)
	k = xor2(g_phi, i)
	return k + j

# 4 => 4
def inv4(inp):
	x0 = inp[0]
	x1 = inp[1]
	x2 = inp[2]
	x3 = inp[3]

	x01 = x0 and x1
	x02 = x0 and x2
	x03 = x0 and x3
	x12 = x1 and x2
	x13 = x1 and x3
	# x23 = x2 and x3
	
	x123 = x12 and x3
	x023 = x02 and x3
	x013 = x01 and x3
	x012 = x01 and x2

	a = x123 ^ x2
	b = a ^ x03
	c = x023 ^ x12
	d = x013 ^ x1


	x3i = b ^ x3
	x2i = b ^ c
	x1i = x3 ^ x02 ^ a ^ d
	x0i = b ^ c ^ d ^ x13 ^ x012 ^ x0

	return [x0i, x1i, x2i, x3i]




# 8 => 8
def mul_inv8(inp):
	print("inp: " + to_str(inp))
	a = inp[4:8]
	b = inp[0:4]
	print("a: " + to_str(a))
	print("b: " + to_str(b))
	c = x_sq(a)
	d = xor4(a, b)
	e = mul_lam(c)
	f = mul4(d, b)
	g = xor4(e, f)
	h = inv4(g)
	i = mul4(a, h)
	j = mul4(h, d)
	return j + i

def delta_mul(inp):
	a = inp[0]
	b = inp[1]
	c = inp[2]
	d = inp[3]
	e = inp[4]
	f = inp[5]
	g = inp[6]
	h = inp[7]

	r0 = a ^ b ^                 g 
	r1 =     b ^         e ^     g 
	r2 =     b ^ c ^ d ^ e ^         h
	r3 =     b ^ c ^             g ^ h
	r4 =     b ^ c ^ d ^     f ^     h
	r5 =         c ^ d ^     f ^     h
	r6 =     b ^ c ^ d ^ e ^     g ^ h
	r7 =                     f ^     h

	return [r0, r1, r2, r3, r4, r5, r6, r7]


def delta_inv_mul(inp):
	print(to_str(inp))
	a = inp[0]
	b = inp[1]
	c = inp[2]
	d = inp[3]
	e = inp[4]
	f = inp[5]
	g = inp[6]
	h = inp[7]

	r0 = a     ^ c     ^ e ^ f ^ g    
	r1 =                 e ^ f   
	r2 =     b ^ c ^ d ^ e         ^ h
	r3 =     b ^ c ^ d ^ e ^ f  
	r4 =     b ^ c     ^ e ^ f ^ g    
	r5 =     b             ^ f ^ g
	r6 =         c             ^ g   
	r7 =     b             ^ f ^ g ^ h

	r = [r0, r1, r2, r3, r4, r5, r6, r7]
	print(to_str(r))
	return [r0, r1, r2, r3, r4, r5, r6, r7]

def affine(inp):
	a = inp[0]
	b = inp[1]
	c = inp[2]
	d = inp[3]
	e = inp[4]
	f = inp[5]
	g = inp[6]
	h = inp[7]

	r0 = a             ^ e ^ f ^ g ^ h  ^ True
	r1 = a ^ b             ^ f ^ g ^ h  ^ True
	r2 = a ^ b ^ c             ^ g ^ h  
	r3 = a ^ b ^ c ^ d             ^ h  
	r4 = a ^ b ^ c ^ d ^ e              
	r5 =     b ^ c ^ d ^ e ^ f          ^ True       
	r6 =         c ^ d ^ e ^ f ^ g      ^ True   
	r7 =             d ^ e ^ f ^ g ^ h  

	r = [r0, r1, r2, r3, r4, r5, r6, r7]
	print("aff:" + to_str(r))
	return r



def inv_del_affine_x(inp):
	a = inp[0]
	b = inp[1]
	c = inp[2]
	d = inp[3]
	e = inp[4]
	f = inp[5]
	g = inp[6]
	h = inp[7]

	r0 = a ^ b ^ c             ^ g ^ h ^ True 
	r1 = a                         ^ h ^ True
	r2 = a     ^ c ^ d ^ e ^ f ^ g    
	r3 = a ^ b ^ c       
	r4 = a ^ b         ^ e         ^ h
	r5 =         c                 ^ h ^ True
	r6 =                 e ^ f ^ g ^ h ^ True
	r7 =         c ^ d             ^ h

	return [r0, r1, r2, r3, r4, r5, r6, r7]


def sub_byte(inp):
	# return affine(delta_inv_mul(mul_inv8(delta_mul(inp))))
	return inv_del_affine_x(mul_inv8(delta_mul(inp)))
	# return inv_del_affine_x(mul_inv8(delta_mul(inp)))

input_byte_hex = argv[1]

def from_str(arr):
	return list(map(lambda x: x == '1', arr))[::-1]

def to_str(arr):
	return ''.join(list(map(lambda x: '1' if x else '0', arr)))[::-1]

input_byte_bin = bin(int(input_byte_hex, 16))[2:].zfill(8)
input_byte_bool_rev = from_str(input_byte_bin)

output_byte_bool_rev = sub_byte(input_byte_bool_rev)
output_byte_bin = to_str(output_byte_bool_rev)
output_byte_hex = hex(int(output_byte_bin, 2))[2:]

print(output_byte_hex)











