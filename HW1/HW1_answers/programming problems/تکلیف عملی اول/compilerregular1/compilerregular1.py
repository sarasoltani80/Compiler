import re

reshte = input()
Regex = re.compile(r'0*10*10*10*10*')
mo1 = Regex.fullmatch(reshte)== None
final = mo1


if (final == False):
    print("this string accepted")
else:
    print("this string doesnt accepted")


