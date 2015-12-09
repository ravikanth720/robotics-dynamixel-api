import sys

with open(sys.argv[1], "r") as intial:
    slines = intial.readlines()
    posfile = open(sys.argv[2], "r")
    plines = posfile.readlines()
    newfile = open("dmp_final.txt", "w")
    print("hi")
    for sline, pline in zip(slines, plines):
        swords = sline.strip().split(' ')
        pwords = pline.strip().split(' ')
        for i in range(18):
            newfile.write(pwords[i]+' '+swords[i*3+1]+' '+swords[i*3+2]+' ')
        newfile.write('\n')
    print("we are done here")
    newfile.close()
    posfile.close()