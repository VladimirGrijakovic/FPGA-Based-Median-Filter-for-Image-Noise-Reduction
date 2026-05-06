import numpy as np
import scipy.signal as signal
import matplotlib.pyplot as plt

#prikaz original slike - pre obrade
swImage = plt.imread('lenaCorrupted.bmp')

plt.imshow(swImage, cmap='gray', vmin=0, vmax=255)
plt.show()

#softverski obradjena slika
swImageDenoised = signal.medfilt2d(swImage, 3)
plt.imshow(swImageDenoised, cmap='gray', vmin=0, vmax=255)
plt.show()

#hardverski obradjena slika
IMAGE_SIZE = 256

#data = open(r"C:\Users\grija\VHDL vezbanje\VLSI_Projekat\VLSI_Projekat.srcs\sources_1\new\rezultat.txt", "r")
#staviti putanju do txt fajla sa rezultatom hardverske obrade
data = open(r"putanja do rezultata", "r")

pikseli = []

for line in data:
    pikseli.append(int(line))


slika = np.zeros([IMAGE_SIZE, IMAGE_SIZE])
slika = np.reshape(np.array(pikseli), [IMAGE_SIZE, IMAGE_SIZE])


plt.imshow(slika, cmap='gray', vmin=0, vmax=255)
plt.show()

data.close()

#razlika u softverskoj i hardverskoj obradi

greska = []

swImageDenoised = np.reshape(np.array(swImageDenoised), [IMAGE_SIZE*IMAGE_SIZE, 1])
for i in range(0, 256*256):
    if swImageDenoised[i][0] != pikseli[i]:
        greska.append(i)

print("Pikseli koji se razlikuju izmedju softverske i hardverske obrade:")
print(greska)

