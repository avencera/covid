import sys
import numpy
import math

x = numpy.array(list(map(int, sys.argv[1].split(","))))
y = numpy.array(list(map(int, sys.argv[2].split(","))))

f = numpy.polyfit(x, numpy.log(y), 1, w=numpy.sqrt(y))

print(list(f))
