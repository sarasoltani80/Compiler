import re

reshte = input()
Regex = re.compile(r'0*(λ|1|110*|110*10*|110*10*10*|110*10*10*10*|100*|100*10*(' '|10*|10*10*|10*10*10*|10*10*10*10*))')
mo1 = Regex.fullmatch(reshte)== None
final = mo1



if (final == False):
    print("this string accepted")
else:
    print("this string doesnt accepted")