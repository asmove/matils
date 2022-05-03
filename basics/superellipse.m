function coords = radialSurf(center, phase, orientation, radius_fun)
    coords = hypersph2cart(phase + orientation, radius_fun(phase + orientation)) - center;
end