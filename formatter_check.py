with open("sitornot.txt", "r") as p:
    slines = p.readlines()
    posfile = open("sitornot_positions.txt", "r")
    plines = posfile.readlines()
    newfile = open("dmp_sitornot.txt", "w")
    print("hi")
    for sline, pline in zip(slines, plines):
        swords = sline.split(' ')
        pwords = pline.split(' ')
        for i in range(18):
            newfile.write(pwords[i]+' '+swords[i*3+1]+' '+swords[i*3+2]+' ')
        newfile.write('\n')
    print("we are done here")
    newfile.close()
    posfile.close()