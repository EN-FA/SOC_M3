filenamer = "image.hex"
filenamew = "image.mif"

i=0

s = '%x %s'%(i, 'Tab')

with open(filenamew,"w") as mon:
    mon.write("DEPTH=24576;\n")
    mon.write("WIDTH=32;\n")
    mon.write("ADDRESS_RADIX=HEX;\n")
    mon.write("DATA_RADIX=HEX;\n")
    mon.write("CONTENT\n")
    mon.write("BEGIN\n")

ms = open(filenamer);
for line in ms.readlines():
    with open(filenamew,"a") as mon:
        s = '%x:%s;\n'%(i, line.rstrip())
        mon.write(s)
        i = i + 1
        
with open(filenamew,"a") as mon:
    mon.write("END;\n")