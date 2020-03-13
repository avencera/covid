import sys
import numpy
import math

x = numpy.array(list(map(int, sys.argv[1].split(","))))
y = numpy.array(list(map(int, sys.argv[2].split(","))))

f = numpy.polyfit(x, numpy.log(y), 1)

print(list(f))
