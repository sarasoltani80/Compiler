
import re

reshte = input()
Regex = re.compile(r'(0|101|11(01)*(1|00)1|(100|11(01)*(1|00)0)(1|0(01)*(1|00)0)*0(01)*(1|00)1)*')
mo1 = Regex.fullmatch(reshte)== None
final = mo1


if (final == False):
    print("this string accepted")
else:
    print("this string doesnt accepted")

