params = containers.Map;

m = containers.Map;

m('position') = 1;
m('default') = 4;
m('tests') = [2, 3, 4, 5];

params('m') = m;

n_1 = containers.Map;

n_1('position') = 2;
n_1('default') = 1;
n_1('tests') = [1/2, 1, 2];

params('n_1') = n_1;

n_2 = containers.Map;

n_2('position') = 3;
n_2('default') = 1;
n_2('tests') = [1/2, 1, 2];

params('n_2') = n_2;

n_3 = containers.Map;

n_3('position') = 4;
n_3('default') = 1;
n_3('tests') = [1/2, 1, 2];

params('n_3') = n_3;

keys(params)
values(params)
