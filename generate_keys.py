g = "11111111111111111111111111111111"
h = "1111111111111111"

print('Generating Skeys...')
n = 32
file = open('skeys.txt', 'w')
for i in range(299):
    b = bin(i)[2:]
    l = len(b)
    b = str(0) * (n - l) + b
    print (b)
    b = b+'\n'
    file.write(b)
file.write(g)
file.close()

print('Generating Din...')
file = open('din.txt', 'w')
n = 16
for i in range(299):
    b = bin(i)[2:]
    l = len(b)
    b = str(0) * (n - l) + b
    print (b)
    b = b+'\n'
    file.write(b)
file.write(h)
file.close()

print("Done, check files!")
