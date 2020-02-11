dot = "#"
clos = 60
header = " a mini os "
leftsider = "db    "
selects = [
    "",
    "reset pc",
    "start system",
    "clock",
    "set clock",
    "",
]

head = header
left = dot * ((clos-len(head))//2)
right = dot * (clos-len(head)-len(left))
head = left + head + right
for i in range(clos):
    print(i%10, end="")
print("")
# print header
print(f"{leftsider}\"{head}\"")
# print body
index = 1
for line in selects:
    print(leftsider, end="")
    if line == "":
        print(f"\"{dot}{' '*(clos-2)}{dot}\"")
        continue
    line =  str(index) + ') ' + line
    index = index + 1
    print(f"\"{dot}{' '*((clos-2)//2-10)}{line}{' '*((clos-2)//2+10-len(line))}{dot}\"")

print(f"{leftsider}\"{dot*clos}\"")
