function coords = radialSurf(center, phase, radius_fun)
    coords = hypersph2cart(phase, radius_fun(phase)) + center;
end