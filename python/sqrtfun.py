# _*_ coding: utf-8 _*_

import math
def quadratic(a, b, c):
    if a!=0:
        if b**2-4*a*c>=0:
            if b**2 - 4*a*c==0:
                x=-b/2*a
                return x
            x1=(-b+math.sqrt(b**2-4*a*c))/2*a
            x2=(-b-math.sqrt(b**2-4*a*c))/2*a
            return x1,x2
        else:
            x1=(-b+math.sqrt(4*a*c-b**2))/2*a
            x2=(-b-math.sqrt(4*a*c-b**2))/2*a
            return x1,x2
    else:
        if b==0:
            return none
        else:
            x=-c/b
            return x
a = int(input("please input number a: "))
b = int(input("please iput number b: "))
c = int(input("please input number c: "))
print(quadratic(a,b,c))
