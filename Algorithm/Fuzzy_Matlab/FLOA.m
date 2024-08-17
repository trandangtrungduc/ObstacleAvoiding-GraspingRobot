function fisin = FLOA()
fisin = mamfis;

% Add input
rangeIn1 = [0 500];
rangeIn2 = [-180 180];
rangeIn3 = [-180 180];
fisin = addInput(fisin, rangeIn1, 'Name', 'disObs');
fisin = addInput(fisin, rangeIn2, 'Name', 'errObs');
fisin = addInput(fisin, rangeIn3, 'Name', 'errGoal');

% Add output
rangeOut1 = [200 800];
rangeOut2 = [-pi pi];
fisin = addOutput(fisin, rangeOut1, 'Name', 'v');
fisin = addOutput(fisin, rangeOut2, 'Name', 'w');

% Add membership function to the first input
fisin = addMF(fisin, 'disObs', 'trimf', [100 200 300], 'Name', 'VN');
fisin = addMF(fisin, 'disObs', 'trimf', [200 500 800], 'Name', 'N');

% Add membership function to the second input
fisin = addMF(fisin, 'errObs', 'trimf', [-200 -180 -90], 'Name', 'N'); 
fisin = addMF(fisin, 'errObs', 'trimf', [-90 -45 0], 'Name', 'NZ');
fisin = addMF(fisin, 'errObs', 'trimf', [-45 0 45], 'Name', 'Z');
fisin = addMF(fisin, 'errObs', 'trimf', [0 45 90], 'Name', 'PZ');
fisin = addMF(fisin, 'errObs', 'trimf', [90 180 200], 'Name', 'P');

% Add membership function to the second input
fisin = addMF(fisin, 'errGoal', 'trimf', [-200 -180 -90], 'Name', 'N'); 
fisin = addMF(fisin, 'errGoal', 'trimf', [-90 -45 0], 'Name', 'NZ');
fisin = addMF(fisin, 'errGoal', 'trimf', [-45 0 45], 'Name', 'Z');
fisin = addMF(fisin, 'errGoal', 'trimf', [0 45 90], 'Name', 'PZ');
fisin = addMF(fisin, 'errGoal', 'trimf', [90 180 200], 'Name', 'P');

% Add membership function to the first output
fisin = addMF(fisin, 'v', 'trimf', [-50 0 50], 'Name', 'Zero');
fisin = addMF(fisin, 'v', 'trimf', [50 100 200], 'Name', 'Slow');
fisin = addMF(fisin, 'v', 'trimf', [100 200 300], 'Name', 'Medium');
fisin = addMF(fisin, 'v', 'trimf', [200 400 500], 'Name', 'Fast');
fisin = addMF(fisin, 'v', 'trapmf', [400 600 800 1000], 'Name', 'Very Fast');

% Add membership function to the second ouput
fisin = addMF(fisin, 'w', 'trimf', [-3*pi/2 -pi -pi/2], 'Name', 'Right');
fisin = addMF(fisin, 'w', 'trimf', [-pi -pi/2 0], 'Name', 'SRight');
fisin = addMF(fisin, 'w', 'trimf', [-pi/4 0 pi/4], 'Name', 'Straight');
fisin = addMF(fisin, 'w', 'trimf', [0 pi/2 pi], 'Name', 'SLeft');
fisin = addMF(fisin, 'w', 'trimf', [pi/2 pi 3*pi/2], 'Name', 'Left');

% Add rules
ruleList1        = [1 1 1 2 1 1 1;      %1
                    1 1 2 3 2 1 1;      %2
                    1 1 3 4 3 1 1;      %3
                    1 1 4 3 4 1 1;      %4
                    1 1 5 2 5 1 1;      %5
                    1 2 1 2 1 1 1;      %6
                    1 2 2 2 2 1 1;      %7
                    1 2 3 3 4 1 1;      %8
                    1 2 4 2 5 1 1;      %9
                    1 2 5 2 5 1 1;      %10
                    1 3 1 2 1 1 1;      %11
                    1 3 2 2 1 1 1;      %12
                    1 3 3 2 1 1 1;      %13
                    1 3 4 2 5 1 1;      %14
                    1 3 5 2 5 1 1;      %15
                    1 4 1 2 1 1 1;      %16
                    1 4 2 2 1 1 1;      %17
                    1 4 3 3 2 1 1;      %18
                    1 4 4 2 5 1 1;      %19
                    1 4 5 2 5 1 1;      %20
                    1 5 1 2 1 1 1;      %21
                    1 5 2 3 2 1 1;      %22
                    1 5 3 4 3 1 1;      %23
                    1 5 4 3 4 1 1;      %24
                    1 5 5 2 5 1 1;];    %25
                
ruleList2        = [2 1 1 2 2 1 1;      %26
                    2 1 2 3 2 1 1;      %27        
                    2 1 3 4 3 1 1;      %28
                    2 1 4 3 4 1 1;      %29
                    2 1 5 2 4 1 1;      %30
                    2 2 1 2 2 1 1;      %31
                    2 2 2 2 3 1 1;      %32
                    2 2 3 3 3 1 1;      %33
                    2 2 4 3 3 1 1;      %34
                    2 2 5 3 4 1 1;      %35
                    2 3 1 3 2 1 1;      %36
                    2 3 2 2 2 1 1;      %37
                    2 3 3 3 2 1 1;      %38
                    2 3 4 2 4 1 1;      %39
                    2 3 5 3 4 1 1;      %40
                    2 4 1 3 2 1 1;      %41
                    2 4 2 3 3 1 1;      %42
                    2 4 3 3 3 1 1;      %43
                    2 4 4 3 2 1 1;      %44
                    2 4 5 2 4 1 1;      %45
                    2 5 1 2 2 1 1;      %46
                    2 5 2 3 2 1 1;      %47
                    2 5 3 4 3 1 1;      %48
                    2 5 4 3 4 1 1;      %49
                    2 5 5 2 4 1 1;];    %50
                
fisin = addRule(fisin, [ruleList1; ruleList2]);                
