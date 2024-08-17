function fisin = FLOA1()
fisin = mamfis;

% Add input
rangeIn1 = [0 500];
rangeIn2 = [-90 90];
fisin = addInput(fisin, rangeIn1, 'Name', 'disObs');
fisin = addInput(fisin, rangeIn2, 'Name', 'errObs');

% Add output
rangeOut1 = [0 600];
rangeOut2 = [-pi/2 pi/2];
fisin = addOutput(fisin, rangeOut1, 'Name', 'v');
fisin = addOutput(fisin, rangeOut2, 'Name', 'w');

% Add membership function to the first input
fisin = addMF(fisin, 'disObs', 'trimf', [-100 0 100], 'Name', 'Z');
fisin = addMF(fisin, 'disObs', 'trimf', [0 150 300], 'Name', 'VN');
fisin = addMF(fisin, 'disObs', 'trimf', [200 500 600], 'Name', 'N');

% Add membership function to the second input
fisin = addMF(fisin, 'errObs', 'trimf', [-100 -90 -45], 'Name', 'N'); 
fisin = addMF(fisin, 'errObs', 'trimf', [-90 -45 0], 'Name', 'NZ');
fisin = addMF(fisin, 'errObs', 'trimf', [-45 0 0], 'Name', 'Z');
fisin = addMF(fisin, 'errObs', 'trimf', [0 45 90], 'Name', 'PZ');
fisin = addMF(fisin, 'errObs', 'trimf', [45 90 100], 'Name', 'P');

% Add membership function to the first output
fisin = addMF(fisin, 'v', 'trimf', [-50 0 150], 'Name', 'Zero');
fisin = addMF(fisin, 'v', 'trimf', [100 200 300], 'Name', 'Slow');
fisin = addMF(fisin, 'v', 'trimf', [200 400 500], 'Name', 'Medium');
fisin = addMF(fisin, 'v', 'trimf', [300 600 700], 'Name', 'Fast');

% Add membership function to the second ouput
fisin = addMF(fisin, 'w', 'trimf', [-pi -pi/2 -pi/4], 'Name', 'Right');
fisin = addMF(fisin, 'w', 'trimf', [-pi/2 -pi/4 0], 'Name', 'SRight');
fisin = addMF(fisin, 'w', 'trimf', [-pi/4 0 pi/4], 'Name', 'Straight');
fisin = addMF(fisin, 'w', 'trimf', [0 pi/4 pi/2], 'Name', 'SLeft');
fisin = addMF(fisin, 'w', 'trimf', [pi/4 pi/2 pi], 'Name', 'Left');

% Add rules
ruleList         = [1 1 4 4 1 1;
                    2 1 4 4 1 1;
                    3 1 4 3 1 1;
                    1 2 3 5 1 1;
                    2 2 3 4 1 1;
                    3 2 4 4 1 1;
                    1 3 1 5 1 1;
                    2 3 2 5 1 1;
                    3 3 3 5 1 1;
                    1 4 3 1 1 1;
                    2 4 3 2 1 1;
                    3 4 4 2 1 1;
                    1 5 4 2 1 1;
                    2 5 4 2 1 1;
                    3 5 4 3 1 1;];

fisin = addRule(fisin, ruleList); 