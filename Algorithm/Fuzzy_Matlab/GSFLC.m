function fisin = GSFLC()
fisin = mamfis;

% Add input
rangeIn1 = [0 3000];
rangeIn2 = [-180 180];
fisin = addInput(fisin, rangeIn1, 'Name', 'disGoal');
fisin = addInput(fisin, rangeIn2, 'Name', 'errGoal');

% Add output
rangeOut1 = [0 800];
rangeOut2 = [-4*pi 4*pi];
fisin = addOutput(fisin, rangeOut1, 'Name', 'v');
fisin = addOutput(fisin, rangeOut2, 'Name', 'w');

% Add membership function to the first input
fisin = addMF(fisin, 'disGoal', 'trimf', [-50 0 50], 'Name', 'Z');
fisin = addMF(fisin, 'disGoal', 'trimf', [0 50 100], 'Name', 'NZ');
fisin = addMF(fisin, 'disGoal', 'trimf', [50 200 300], 'Name', 'M');
fisin = addMF(fisin, 'disGoal', 'trimf', [200  500 1000], 'Name', 'NF');
fisin = addMF(fisin, 'disGoal', 'trapmf', [800 1500 3000 5000], 'Name', 'F');

% Add membership function to the second input
fisin = addMF(fisin, 'errGoal', 'trimf', [-200 -180 -90], 'Name', 'N');
fisin = addMF(fisin, 'errGoal', 'trimf', [-90 -45 0], 'Name', 'NNZ');
fisin = addMF(fisin, 'errGoal', 'trimf', [-45 0 45], 'Name', 'Z');
fisin = addMF(fisin, 'errGoal', 'trimf', [0 45 90], 'Name', 'NPZ');
fisin = addMF(fisin, 'errGoal', 'trimf', [90 180 200], 'Name', 'P');

% Add membership function to the first output
fisin = addMF(fisin, 'v', 'trimf', [-50 0 50], 'Name', 'Zero');
fisin = addMF(fisin, 'v', 'trimf', [50 100 200], 'Name', 'Slow');
fisin = addMF(fisin, 'v', 'trimf', [100 200 300], 'Name', 'Medium');
fisin = addMF(fisin, 'v', 'trimf', [200 400 500], 'Name', 'Fast');
fisin = addMF(fisin, 'v', 'trapmf', [400 600 800 1000], 'Name', 'Very Fast');

% Add membership function to the second ouput
fisin = addMF(fisin, 'w', 'trimf', [-5*pi -4*pi -2*pi], 'Name', 'Right');
fisin = addMF(fisin, 'w', 'trimf', [-4*pi -2*pi 0], 'Name', 'SRight');
fisin = addMF(fisin, 'w', 'trimf', [-pi/4 0 pi/4], 'Name', 'Straight');
fisin = addMF(fisin, 'w', 'trimf', [0 2*pi 4*pi], 'Name', 'SLeft');
fisin = addMF(fisin, 'w', 'trimf', [2*pi 4*pi 5*pi], 'Name', 'Left');

% Add rules
ruleList         = [1 1 1 2 1 1;
                    1 2 1 2 1 1;
                    1 3 1 3 1 1;
                    1 4 1 4 1 1;
                    1 5 1 4 1 1;
                    2 1 1 1 1 1;
                    2 2 2 2 1 1;
                    2 3 2 3 1 1;
                    2 4 2 4 1 1;
                    2 5 1 5 1 1;
                    3 1 1 1 1 1;
                    3 2 3 2 1 1;
                    3 3 3 3 1 1;
                    3 4 3 4 1 1;
                    3 5 1 5 1 1;
                    4 1 1 1 1 1;
                    4 2 3 2 1 1;
                    4 3 4 3 1 1;
                    4 4 3 4 1 1;
                    4 5 1 5 1 1;
                    5 1 1 1 1 1;
                    5 2 3 2 1 1;
                    5 3 5 3 1 1;
                    5 4 3 4 1 1;
                    5 5 1 5 1 1;];
                
fisin = addRule(fisin, ruleList);                
