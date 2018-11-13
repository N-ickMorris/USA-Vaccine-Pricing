# ---- proposed model ----

# this model determines the minimum budget required to meet a desired antigen immunization coverage and bundle profit margin

# ---- define set(s) ----

set antigens;  # a set of antigens
set bundles;  # a set of bundles
set periods;  # a set of time periods
set firms;  # a set of firms

# ---- define parameter(s) ----

param dosage{i in antigens, t in periods} default 0;  # the number of doses of an antigen required in a period 
param prep{j in bundles, f in firms} default 0;  # the preperation cost of a bundle (this differs according to the type of packaging used by a firm)
param inject;  # the cost to inject a vaccine
param map{i in antigens, j in bundles} default 0;  # a binary parameter indicating if an antigen is/isn't in a bundle (this maps antigens to bundles)
param MC{j in bundles, f in firms} default 0;  # the marginal cost to produce a bundle (this differs according to the type of production system used by a firm)
param coverage{i in antigens, t in periods} default 0.9;  # the immunization coverage for each antigen
param demand{t in periods} default 4.3e6;  # the number of annual births
param margin{j in bundles, t in periods, f in firms} default 0.1;  # the minimum allowable profit margin for each bundle during a period for a firm
param limit{j in bundles, f in firms} default 0;  # the upper limit on the unit price for a bundle from a firm
param supply{j in bundles, f in firms} default 0;  # a binary parameter indicating if a firm does/doesn't supply a bundle

# ---- define variable(s) ----

var price{j in bundles, t in periods, f in firms} >= 0;  # the unit price of a bundle during a period for a firm
var quantity{j in bundles, t in periods, f in firms} integer >= 0;  # the number of bundles to purchase during a time period from a firm

# ---- define model formulation ----

minimize BUDGET: sum{j in bundles, t in periods, f in firms}((price[j,t,f] + prep[j,f] + inject) * quantity[j,t,f]);  # minimize total cost (ie. the required budget)
s.t. DEMAND{i in antigens, t in periods}: sum{j in bundles, f in firms}(supply[j,f] * map[i,j] * quantity[j,t,f]) >= coverage[i,t] * dosage[i,t] * demand[t];  # ensure the desired antigen coverage is met
s.t. PROFIT{j in bundles, t in periods, f in firms}: price[j,t,f] >= (1 + margin[j,t,f]) * MC[j,f];  # ensure the unit price yeilds the desired profit
s.t. LIMIT{j in bundles, t in periods, f in firms}: price[j,t,f] <= limit[j,f];  # ensure the unit price does not exceed the maximum allowable price
s.t. COLLUSION{j in bundles, f1 in firms, f2 in firms: supply[j,f1] + supply[j,f2] > 1}: sum{t in periods}(quantity[j,t,f1]) = sum{t in periods}(quantity[j,t,f2]);  # ensure that firms supplying the same bundle sell the same amount to share the market equally








