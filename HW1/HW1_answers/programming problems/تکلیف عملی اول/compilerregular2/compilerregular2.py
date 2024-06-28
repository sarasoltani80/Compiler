
import re

reshte = input()
Regex = re.compile(r'0*(1(1|0)(1|0)(1|0)(1|0)(1|0)(1|0)(1|0)*|11(1|0)(1|0)(1|0)(1|0)(0|1)*|1011(1|0)(1|0))')
mo1 = Regex.fullmatch(reshte)== None
final = mo1



if (final == False):
    print("this string accepted")
else:
    print("this string doesnt accepted")