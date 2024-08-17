import numpy as np
from scipy import io
from numpy import random
import matplotlib.pyplot as plt
from helper.calc_vector_limit_angle import calc_vector
import calc_ref
import get_env_state
import get_action_state
import get_action
import math
# % Q-learning parameters
espisodes = 100
targetSuccess = 3
dt = 0.04
N_State  = 8
N_Action = 3
disSafe = 500
vmax = 750

# % Denote each state as a number
WS = 0;     #%winning state
SS = 1;     #%safe state
FS = 3;     #%failure state

# % Intialize plot variables
t           = np.zeros(5000, 1)
posPlot     = np.zeros(5000, 2)
dirPlot     = np.zeros(5000, 1)
vPlot       = np.zeros(5000, 1)
wPlot       = np.zeros(5000, 1)
closestPlot = np.zeros(5000, 1)

# % Initialize plotting configuration
f = figure('Name', 'Motion simulation');
f.Position = [236,378,1375,425];
ax1 = subplot(1, 2, 1);
ax2 = subplot(1, 2, 2);
pos_table = get(ax2, 'Position');
delete(ax2);
col = {'Go ahead', 'Turn left', 'Turn Right'};
row = {'G1', 'G2', 'G3', 'G4', 'G5', 'G6', 'G7', 'G8'};
Qtable = uitable(f,'Columnname', col, 'ColumnWidth', {120, 120, 120}, 'Rowname', row, 'Data', zeros(length(row), length(col)));
set(Qtable, 'units', 'normalized');
set(Qtable, 'position', pos_table);
f.CurrentAxes = ax1;

frame = 0;
writerObj = VideoWriter('example.avi');
writeObj.quality = 100
writerObj.FrameRate = 20
open(writerObj)
# %% Main function
[start, goal, staticObs, movingObs, hMObs, hStart] = init_env();
question = 'Are you ready to start?'
dlgtitle = 'Begin'
option1 = 'Yes'
option2 = 'No'
option = questdlg(question, dlgtitle, option1, option2, option1);
count = 0
trainSuccess = 0;
if strcmp(option, option1):
    delete(hStart);
    [robot, robotParams, hRobot, hStart] = init_robot(start, goal);
    initialMovingObs = movingObs;
    question = 'Initialize Q-table';
    dlgtitle = 'Q-learning';
    option1 = 'Load a file';
    option2 = 'Create a new one';
    option = questdlg(question, dlgtitle, option1, option2, option1);
    if strcmp(option, option1)
        loadfile = inputdlg('Load file:', dlgtitle, [1 35], {'Q1.mat'}, 'on');
        loadfile = loadfile{1};
        load(loadfile, 'Q');
    else
        Q = zeros(N_State, N_Action);
    end
    Qtable.Data = Q;
    # %add a random obstacle at the end
    addedRandom = False
    for i=0:espisodes:
        title(strcat(["Training phase: Espisode "], [string(i)]));
        fprintf('Espisode %d:', i);
        senseObs = sense_obs(staticObs, movingObs, robot);
        nearestObs = senseObs[0,:];
        currentEnvState = get_env_state(robot, nearestObs);
        currentActionState = get_action_state(robot, robotParams, nearestObs, goal, disSafe);
        h = [];
        # count = count+1;
        posPlot[count, :] = robot[0:1];
        dirPlot[count, :] = robot[2];
        vPlot[count] = robot[3];
        wPlot[count] = robot[4];
        closestPlot[count] = disSafe;
        eGoal = sense_goal(robot, goal); 
        update = 1;
        while (currentActionState[0] == WS) and (currentActionState[0] == FS):
            xlabel(strcat(["t = "], [string(t(count))]));
            action = get_action(currentEnvState, Q);
            prev_posRobot = robot[0,1];
            [_, disGoal] = calc_vector(robot[0,1], goal);
            if nearestObs[2] > 600 or disGoal < 400 or robot[0] > 3800 or robot[0] < 200 or robot[1] < 200 or robot[1] > 2800:
                vRef = 2*eGoal[0];
                wRef = 5*eGoal[2];
                update = 0;
            else:            
                [vRef, wRef] = calc_ref(action, robot, goal, nearestObs, vmax);
                update = 1;
            [movingObs, hMObs] = update_mObs(movingObs, hMObs, dt);
            [robot, hRobot] = update_robot(robot, hRobot, robotParams, [vRef, wRef], dt);
            senseObs = sense_obs(staticObs, movingObs, robot);
            nearestObs = senseObs[0,:];
            # count = count+1;
            t(count+1) = t(count) + dt;
            posRobot = robot[0:1];
            hold on
            h1 = plot([prev_posRobot(1), posRobot(1)], [prev_posRobot(2), posRobot(2)], ":r");
            h = [h ,h1];
            hold off
            posPlot[count, :] = robot[0:1];
            dirPlot[count, :] = robot[2];
            vPlot[count] = robot[3];
            wPlot[count] = robot[4];
            closestPlot[count] = nearestObs[2]-nearestObs[4]-robotParams[0];
            nextEnvState = get_env_state(robot, nearestObs);
            nextActionState = get_action_state(robot, robotParams, nearestObs, goal, disSafe);
            if update % nextActionState(1) == FS:
                Q = updateQ(Q, action, currentEnvState, currentActionState, nextEnvState,...
                            nextActionState);
            currentActionState = nextActionState;
            currentEnvState = nextEnvState;
            eGoal = sense_goal(robot, goal);
            [_, disGoal] = calc_vector(robot[0:1], goal);
            if (disGoal < 800) and not addedRandom:
                [randomObs, hRandom] = addRandomObs(robot, goal);
                staticObs = [staticObs, randomObs];
                addedRandom = True;
            drawnow
            frame = frame+1;
            M(frame) = getframe(f);
            writeVideo(writerObj,M(frame));
        Qtable.Data = Q;
        if addedRandom:
            addedRandom = False;
            staticObs = staticObs[0:1,:];
            delete(hRandom);
        end
        count = 0;
        delete(h);
        if currentActionState(1) == WS:
            fprintf(' Success\n');
            trainSuccess = trainSuccess + 1;
            if trainSuccess == targetSuccess:
                break
        else:
            fprintf(' Collided\n');
        end        
        [robot, hRobot, hStart] = reset_robot(start, hRobot, robotParams, goal, hStart);
        [movingObs, hMObs] = reset_mObs(initialMovingObs, hMObs);
    end
    testSuccess = 0;
    testFailed = 0;
    for i in range() i=0:size(start,1)
        title(strcat(["Testing phase: Test case "], [string(i)]));
        [robot, hRobot, hStart] = reset_robot(start[i,:], hRobot, robotParams, goal, hStart);
        [movingObs, hMObs] = reset_mObs(initialMovingObs, hMObs);
        senseObs = sense_obs(staticObs, movingObs, robot);
        nearestObs = senseObs[1,:];
        currentEnvState = get_env_state(robot, nearestObs);
        currentActionState = get_action_state(robot, robotParams, nearestObs, goal, disSafe);
        h = [];
        count = 1;
        eGoal = sense_goal(robot, goal); 
        while (currentActionState[0] == WS) and (currentActionState[0] == FS):
            xlabel(strcat(["t = "], [string(t(count))]));
            action = get_action(currentEnvState, Q);
            prev_posRobot = robot[0:1];
            [_, disGoal] = calc_vector(robot[0:1], goal);
            if nearestObs(3) > 600 or disGoal < 400 or robot(1) > 3800 or robot(1) < 200 or robot(2) < 200 or robot(2) > 2800:
                vRef = 2*eGoal[0]
                wRef = 5*eGoal[2]
            else:            
                [vRef, wRef] = calc_ref(action, robot, goal, nearestObs, vmax);
            [movingObs, hMObs] = update_mObs(movingObs, hMObs, dt);
            [robot, hRobot] = update_robot(robot, hRobot, robotParams, [vRef, wRef], dt);
            senseObs = sense_obs(staticObs, movingObs, robot);
            nearestObs = senseObs[0,:];
            count = count+1;
            t(count) = t(count-1) + dt;
            posRobot = robot[0:1];
            # hold on
            h1 = plot([prev_posRobot(1), posRobot(1)], [prev_posRobot(2), posRobot(2)], ":r");
            h = [h, h1];
            # hold off
            nextEnvState = get_env_state(robot, nearestObs);
            nextActionState = get_action_state(robot, robotParams, nearestObs, goal, disSafe);
            currentActionState = nextActionState;
            currentEnvState = nextEnvState;
            eGoal = sense_goal(robot, goal);
            if (disGoal < 800) and (not addedRandom):
                [randomObs, hRandom] = addRandomObs(robot, goal)
                staticObs = [staticObs, randomObs]
                addedRandom = True
            drawnow
            frame = frame+1;
            M(frame) = getframe(f);
            writeVideo(writerObj,M(frame));
        if currentActionState(1) == WS:
            fprintf(' Success\n')
            testSuccess = testSuccess + 1
        else:
            fprintf(' Collided\n')
            testFailed = testFailed + 1
        if addedRandom:
            addedRandom = False
            staticObs = staticObs[0:-1,:]
            delete(hRandom)
        count = 0;
        delete(h);  
    end
    delete(hRobot);
    delete(hStart);
    title(strcat(["Testing results: "], [string(testSuccess)], ["/"], [string(testSuccess+testFailed)], " succeed"));
    fprintf('Test results: %d/%d succeed\n', testSuccess, testSuccess+testFailed);
    %plot_results(count);
end
close(writerObj)
# % Remove the path to avoid conflict with other function
rmpath(genpath(pwd))

# '''%% Helper function'''

def addRandomObs(robot, goal):
    radObs = 80
    distance = 300
    dirGoal = calc_vector(robot[0:1], goal);
    posObs = goal + distance*np.array([np.cos(dirGoal-math.pi) ,np.sin(dirGoal-math.pi)]);
    # hold on
    hRandom = viscircles(posObs, radObs, 'LineWidth', 1, 'Color', 'black');
    # hold off
    randomObs = np.array([posObs, radObs])

def plot_result(count, t, posPlot, dirPlot, vPlot, wPlot, closestPlot):
    """ Plot the info about the robot """
    """ Create a position graph """
    plt.plot(t[0:count], posPlot[0:count,:], linewidth=2)
    plt.title('Robot Position')
    plt.ylabel('Position(mm)')
    plt.xlabel('Time(s)')
    plt.legend(['Left Motor','Right Motor'])
    plt.grid()
    plt.show()
    """ Create a direction graph """
    plt.plot(t[0:count], dirPlot[0:count], linewidth=2)
    plt.title('Robot Direction')
    plt.ylabel('Direction(rad)')
    plt.xlabel('Time(s)')
    plt.grid()
    plt.show()
    """ Create a position graph """
    plt.plot(t[0:count], vPlot[0:count], linewidth=2)
    plt.title('Robot Velocity')
    plt.ylabel('v(mm/$s^{2}$)')
    plt.xlabel('Time(s)')
    plt.grid()
    plt.show()
    """ Create a direction graph """
    plt.plot(t[0:count], wPlot[0:count], linewidth=2)
    plt.title('Robot Angular Velocity')
    plt.ylabel('$\omega$(rad/s)')
    plt.xlabel('Time(s)')
    plt.grid()
    plt.show()
    """ Create closest distance graph """
    plt.plot(t[0:count], closestPlot[0:count], linewidth=2)
    plt.title('Obstacle Closest Distance')
    plt.ylabel('Distance (mm)')
    plt.xlabel('Time(s)')
    plt.grid()
    plt.show()

def update_plot(posRobot_data, radRobot, dirRobot_data, posObs_data, posStart, trace_plot, data):
    width = 3000 
    length = 4000         
    for i in range(0,len(posRobot_data)):       
        fig, ax = plt.subplots() 
        plt.xlim([0, length])
        plt.ylim([0, width])
        plt.title("Autonomous Robot Simulation")
        plt.xlabel("Robot Position: x = {} mm  y = {} mm".format(round(posRobot_data[i][0],2),round(posRobot_data[i][1],2)))
        """ Initalize map """
        ax.plot(data["goal"][0][0], data["goal"][0][1], marker='*', color='blue')
        ax.text(data["goal"][0][0]+100, data["goal"][0][1]+100, 'Goal')
        
        """ Draw 12 static obstacles """
        for m in range(0,data["staticObs"].shape[0]):  
            posObs = data["staticObs"][m,0:2]
            radObs_init = data["staticObs"][m,2]
            cirObs = plt.Circle((posObs[0],posObs[1]), radObs_init, fill = False, linewidth=1, color='red')                    
            ax.add_patch(cirObs)           
           
        """ Initialize robot """
        ax.plot(posStart[0], posStart[1], marker='*', color='green')
        ax.text(posStart[0], posStart[1], 'Start')
        ax.plot([posStart[0], goal[0]], [posStart[1], goal[1]], linestyle='--', color='cyan')           
        cir0 = plt.Circle((posStart[0],posStart[1]), radRobot, fill = False, linewidth=1, color='green')
        ax.add_patch(cir0)  
        
        """ Update robot and obstacle """
        cir1 = plt.Circle((posObs_data[i][0],posObs_data[i][1]), 94, fill = False, linewidth=1, color='blue')
        cir2 = plt.Circle((posObs_data[i][2],posObs_data[i][3]), 83, fill = False, linewidth=1, color='blue')
        cir3 = plt.Circle((posRobot_data[i][0], posRobot_data[i][1]), radRobot, color='y',fill=False)
        ax.set_aspect('equal', adjustable='datalim')
        ax.add_patch(cir1)
        ax.add_patch(cir2)
        ax.add_patch(cir3)
        ax.plot([posRobot_data[i][0], posRobot_data[i][0]+radRobot*np.cos(dirRobot_data[i])],[posRobot_data[i][1], posRobot_data[i][1]+radRobot*np.sin(dirRobot_data[i])],linewidth=1, color='green')                
        """ Trace of robot """
        for j in range(0,i):
            plt.plot([trace_plot[j][0], trace_plot[j][1]], [trace_plot[j][2], trace_plot[j][3]], color="orange") 
        plt.show()
        i += 1
