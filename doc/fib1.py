
def F(x):
    print(f'F({x})',end = ",")
    if x != 0:
        print(f'call F({x-1})',end = "->")
        F(x-1)  #NOTE return here
        return print(f'return F({x})',end = "->")
    else: # F(0)
        return print(f'\n\n...x==0 return F(0)',end = "->")

x = 2
F(x)
