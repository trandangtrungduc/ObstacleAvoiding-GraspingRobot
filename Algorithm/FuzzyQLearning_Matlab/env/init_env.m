function [start, goal, staticObs, movingObs, hMObs, hStart] = init_env()
%Initialize the environment for the simulation
%------------------------Bug you may encounter----------------------------%
%- Click (x) button on the dialog box can make the answer is empty
%- Click Enter when execute ginput can make error
%-------------------------------------------------------------------------%
% Get the dimension of the env
% prompt = ["Enter env's width(mm):", "Enter env's length(mm):"];
% dlgtitle = 'Environment Settings';
% dims = [1, 35];
% definput = {'3000', '4000'};
% size = inputdlg(prompt, dlgtitle, dims, definput, 'on');
% width = str2double(size{1});
% length = str2double(size{2});
width = 3000; length = 4000;
notDone = true;

% Choose the option to init the environment
question = 'Which option you want to init the environment?';
dlgtitle = 'Environment Settings';
option1 = 'Load a file';
option2 = 'Create a new one';
option = questdlg(question, dlgtitle, option1, option2, option2);

if strcmp(option, option1)
    loadfile = inputdlg('Load file:', dlgtitle, [1 35], {'data0.mat'}, 'on');
    loadfile = loadfile{1};
    load(loadfile, 'start', 'goal', 'staticObs', 'movingObs');
end  

while notDone
    % Set the original axis
    axis equal;
    xlim([0, length]);
    ylim([0, width]);
    title("Mobile robot simulation");
    hold on;
    hStart = [];
    if strcmp(option,option1)
        % Draw the intial and the goal location
        for i=1:size(start,1)
            posStart = start(i,:);
            plot(posStart(1), posStart(2), '+', 'Color', 'black');
        end
        plot(goal(1), goal(2), 'bp');
        text(goal(1)+100, goal(2)+100, 'Goal');
        % plot([start(1), goal(1)], [start(2), goal(2)], ':', 'Color', 'cyan');
        
        % Draw the static obstacle
        for i=1:size(staticObs, 1)
            posObs = staticObs(i,1:2);
            radObs = staticObs(i,3);
            viscircles(posObs, radObs, 'LineWidth', 1, 'Color', 'black');
        end
        
        % Draw the moving obstacle
        hMObs = [];
        for i=1:size(movingObs, 1)
            if movingObs(i, 8) == 0
                startObs = movingObs(i,1:2);
                lenObs = movingObs(i,6);
                dirObs = movingObs(i,5);
                radObs = movingObs(i,4);
                endObs = startObs + lenObs*[cos(dirObs),sin(dirObs)];
                h1 = plot(startObs(1), startObs(2), '+', 'Color', 'magenta');
                h2 = plot(endObs(1), endObs(2), '+', 'Color', 'magenta');
                h3 = plot([startObs(1), endObs(1)], [startObs(2), endObs(2)], '--k');
                hObs = viscircles(startObs, radObs, 'LineWidth', 1, 'Color', 'blue');
                hStart = [hStart h1 h2 h3];
                hMObs = [hMObs hObs];
            else
                startObs = movingObs(i,1:2);
                radObs = movingObs(i,4);
                radCir = movingObs(i,3);
                centerCir = movingObs(i,5:6);
                h1 = plot(centerCir(1), centerCir(2), '+', 'Color', 'magenta');
                h2 = viscircles(centerCir, radCir, 'LineWidth', 1,'LineStyle', '--', 'Color', 'magenta');
                hObs = viscircles(startObs, radObs, 'LineWidth', 1, 'Color', 'blue');
                hStart = [hStart h1 h2];
                hMObs = [hMObs hObs];
            end
        end
        notDone = false;
    end
    
    if strcmp(option,option2)
        % Set the possible start location 
        xlabel('Select the start location', 'Color', 'k');
        countStart = 0;
        start = zeros(10, 2);
        button = 1;
        while (button == 1)
            [xCor, yCor, button] = ginput(1);
            countStart = countStart + 1;
            posStart = [floor(xCor), floor(yCor)];
            start(countStart,:) = posStart;
            plot(posStart(1), posStart(2), '+', 'Color', 'yellow');
        end
        start = start(1:countStart, :);
        % Set the goal location
        xlabel('Select the goal location', 'Color', 'k');
        button = 0;
        while (button ~= 1)
            [xCor, yCor, button] = ginput(1);
        end
        goal = [floor(xCor), floor(yCor)];
        plot(goal(1), goal(2), 'bp');
        text(goal(1)+100, goal(2)+100, 'Goal');

        % plot([start(1), goal(1)], [start(2), goal(2)], ':', 'Color', 'cyan');

        % Set the obstacles location
        radObs_range = [80, 100];
        vObs_range = [300, 500];
        movingObs = zeros(20, 8);
        hMObs = [];
        staticObs = zeros(20, 3);
        countSObs = 0;
        countMObs = 0;

        % Set the static obstacles location
        xlabel('Select the static obstacles location, use right-click for placing last obstacle');
        while (button == 1)
            [xCor, yCor, button] = ginput(1);
            countSObs = countSObs + 1;
            posObs = [floor(xCor), floor(yCor)];
            radObs = randi(radObs_range);
            staticObs(countSObs,:) = [posObs, radObs];
            viscircles(posObs, radObs, 'LineWidth', 1, 'Color', 'black');
        end
        staticObs = staticObs(1:countSObs, :);
        
        % Set the moving obstacles location
        question = 'Add moving obstacles?';
        dlgtitle = 'Environment Settings';
        option1 = 'Only linear';
        option2 = 'linear + circular';
        option3 = 'No';
        option = questdlg(question, dlgtitle, option1, option2, option3, option1);
        
        if ~strcmp(option, option3)
            % Set the linear moving obstacles location
            xlabel('Select the linear moving obstacles location, use right-click for placing last obstacle');
            button = 1;
            while (button == 1)
                [xCor, yCor] = ginput(1);
                startObs = [floor(xCor), floor(yCor)];
                h1 = plot(startObs(1), startObs(2), '+', 'Color', 'magenta');
                
                [xCor, yCor, button] = ginput(1);
                endObs = [floor(xCor), floor(yCor)];
                h2 = plot(endObs(1), endObs(2), '+', 'Color', 'magenta');
                h3 = plot([startObs(1), endObs(1)], [startObs(2), endObs(2)], '--', 'Color', 'magenta');
                
                countMObs = countMObs + 1;
                posObs = startObs;
                disObs = 0;
                radObs = randi(radObs_range);
                vObs = randi(vObs_range);
                typeObs = 0;
                [dirObs, lenObs] = calc_vector(startObs, endObs);
                movingObs(countMObs, :) = [posObs, disObs, radObs, dirObs, lenObs, vObs, typeObs];
                hObs = viscircles(posObs, radObs, 'LineWidth', 1, 'Color', 'blue');
                hStart = [hStart h1 h2 h3];
                hMObs = [hMObs, hObs];
            end
            
            if strcmp(option, option2)
                % Set the circular moving obstacles location
                xlabel('Select the circular moving obstacles location, use right-click for placing last obstacle');
                button = 1;
                while (button == 1)
                    [xCor, yCor] = ginput(1);
                    centerCir = [floor(xCor), floor(yCor)];
                    h1 = plot(centerCir(1), centerCir(2), '+', 'Color', 'magenta');

                    [xCor, yCor, button] = ginput(1);
                    startObs = [floor(xCor), floor(yCor)];
                    [~, radCir] = calc_vector(startObs, centerCir); 
                    h2 = viscircles(centerCir, radCir, 'LineWidth', 1,'LineStyle', '--', 'Color', 'magenta');
                    question = 'Which direction?';
                    dlgtitle = 'Direction of Obstacle';
                    option1 = 'CW';
                    option2 = 'CCW';
                    option = questdlg(question, dlgtitle, option1, option2, option1);
                    if strcmp(option, option1)
                        typeObs = 1;
                    else
                        typeObs = -1;
                    end
                    countMObs = countMObs + 1;
                    posObs = startObs;
                    radObs = randi(radObs_range);
                    vObs = randi(vObs_range);
                    movingObs(countMObs, :) = [posObs, radCir, radObs, centerCir, vObs, typeObs];
                    hObs = viscircles(posObs, radObs, 'LineWidth', 1, 'Color', 'blue');
                    hStart = [hStart h1 h2];
                    hMObs = [hMObs, hObs];
                end
            end
        else
            hMObs = [];
            movingObs = [];
        end
        movingObs = movingObs(1:countMObs, :);
        xlabel('');
        hold off

        % Save environment config to a MAT-file
        question = 'Do you want to save the env configurations?';
        dlgtitle = 'Environment Settings';
        answer = questdlg(question, dlgtitle, 'Yes', 'No and redo', 'No and quit', 'No and quit');
        switch answer
            case 'Yes'
                savefile = inputdlg('Save as:', dlgtitle, [1 35], {'data0.mat'}, 'on');
                save(savefile{1}, 'start', 'goal', 'staticObs', 'movingObs');
                notDone = false;
            case 'No and redo'
                notDone = true;
                close all; clear movingObs hMObs staticObs start goal;
            case 'No and quit'
                notDone = false;
        end
    end
end