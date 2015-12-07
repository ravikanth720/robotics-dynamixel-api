with open("sitornot.txt", "r") as p:
    lines = p.readlines()
    newp = open("sitornot_positions.txt", "w")
    for line in lines:
        words = line.split(' ')
        for i in range(18):
            print(i*3)
            print(words[i*3]+' ')
            newp.write(words[i*3]+' ')

        newp.write("\n")
    newp.close()