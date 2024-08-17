""" Simulation of the mobile robot to avoid the obstacles"""
import numpy as np
from scipy import io
from numpy import random
import matplotlib.pyplot as plt
from env.init_robot import init_robot
from env.update_robot import update_robot
from env.update_mObs import update_mObs
from env.sense_goal import sense_goal
from env.sense_obs import sense_obs
from algorithm.sense_danger import sense_danger
from algorithm.calc_ref import calc_ref

def plot_result(count, t, posPlot, dirPlot, vPlot, wPlot, closestPlot):
    """ Plot the info about the robot """
    """ Create a position graph """
    plt.plot(t[0:count], posPlot[0:count,:], linewidth=2)
    plt.title('Robot Position')
    plt.ylabel('Position(mm)')
    plt.xlabel('Time(s)')
    plt.legend(['x','y'])
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
    plt.ylabel(r'$\omega(rad/s)$')
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
            if m == 6:
                posObs = data["staticObs"][m,0:2]
                radObs_init = data["staticObs"][m,2]
                cirObs = plt.Circle((posObs[0],posObs[1]+50), 74, fill = False, linewidth=1, color='red')                    
                ax.add_patch(cirObs)   
            else:
                posObs = data["staticObs"][m,0:2]
                radObs_init = data["staticObs"][m,2]
                cirObs = plt.Circle((posObs[0],posObs[1]), radObs_init, fill = False, linewidth=1, color='red')                    
                ax.add_patch(cirObs)           
           
        """ Initialize robot """
        ax.plot(posStart[0], posStart[1], marker='*', color='green')
        ax.text(posStart[0], posStart[1], 'Start')
        ax.plot([posStart[0], goal[0]], [posStart[1], goal[1]], linestyle='--', color='cyan')           
        cir0 = plt.Circle((posStart[0],posStart[1]), 94, fill = False, linewidth=1, color='green')
        ax.add_patch(cir0)  
        
        """ Update robot and obstacle """
        cir1 = plt.Circle((posObs_data[i][0],posObs_data[i][1]), 94, fill = False, linewidth=1, color='blue')
        cir2 = plt.Circle((posObs_data[i][2],posObs_data[i][3]), 83, fill = False, linewidth=1, color='blue')
        cir3 = plt.Circle((posRobot_data[i][0], posRobot_data[i][1]), 95, color='y',fill=False)
        ax.set_aspect('equal', adjustable='datalim')
        ax.add_patch(cir1)
        ax.add_patch(cir2)
        ax.add_patch(cir3)
        ax.plot([posRobot_data[i][0], posRobot_data[i][0]+94*np.cos(dirRobot_data[i])],[posRobot_data[i][1], posRobot_data[i][1]+95*np.sin(dirRobot_data[i])],linewidth=1, color='green')                
        """ Trace of robot """
        for j in range(0,i):
            plt.plot([trace_plot[j][0], trace_plot[j][1]], [trace_plot[j][2], trace_plot[j][3]], color="orange") 
        plt.show()
        i += 1

""" Drive program """
if __name__ == "__main__":
    data = io.loadmat('E:/Project/Autonomous_Robot/BTL/ORM_Python/data/data1.mat')
    """ Initialize the variables """
    count = 0
    dt = 0.03
    disDanger = 600
    radSafe = 30
    step = 8000
    data_init = 8000
    
    """ Initialize plot variables  """
    t = np.zeros((step,1))
    posPlot = np.zeros((step,2))
    dirPlot = np.zeros((step,1))
    vPlot = np.zeros((step,1))
    wPlot = np.zeros((step,1))
    closestPlot = np.zeros((step,1))
     
    """ Get data from update robot and update obstacles"""
    posRobot_data = np.zeros((data_init,2),dtype=np.float64)
    dirRobot_data = np.zeros(data_init,dtype=np.float64)
    posObs_data = np.zeros((data_init,4),dtype=np.float64)
    trace_plot = np.zeros((data_init,4),dtype=np.float64)
 
    """ Initialize environment (moving and static obstacles) and robot parameter  """
    start, goal, staticObs, movingObs = data["start"], data["goal"], data["staticObs"], data["movingObs"]                                  # start, goal, staticObs, movingObs, hMObs, hStart
    [robot, robotParams, posStart] = init_robot(start, goal) # robot, robotParams, hRobot
    
    goal = goal[0]
    posPlot[count, :] = robot[0:2]
    dirPlot[count, :] = robot[2]  
    vPlot[count] = robot[3]
    wPlot[count] = robot[4]
    closestPlot[count] = disDanger
    eGoal = sense_goal(robot, goal)
    
    countStart = start.shape[0]
    posStart = start[random.randint(countStart),:]
    
    while (abs(eGoal[0]) > 10 or abs(eGoal[1]) > 10):
        """ Motion of the robot and moving obstacles """
        count += 1
        t[count] = t[count-1] + dt
        prev_posRobot = robot[0:2]
        
        [movingObs, posObs_total] = update_mObs(movingObs, dt)
        senseObs = sense_obs(staticObs, movingObs, robot, radSafe)
        dangerObs = sense_danger(senseObs, robotParams, disDanger)
        nearestObs = senseObs[0,:]
        disClosestObs = nearestObs[0]- nearestObs[2] - robotParams[0] + radSafe
        [refParams, rangeRobot, dirRef] = calc_ref(robot, dangerObs, goal)
        [robot, posRobot, radRobot, dirRobot] = update_robot(robot, robotParams, refParams, dt)
        posRobot_data[count-1,:] = posRobot
        posObs_data[count-1,0:2] = posObs_total[0]
        posObs_data[count-1,2:4] = posObs_total[1]
        dirRobot_data[count-1] = dirRobot
        """ Update trace of the robot """ 
        posRobot = robot[0:2]
        trace_plot[count-1,:] = [prev_posRobot[0], posRobot[0], prev_posRobot[1], posRobot[1]]
        """ Update plot variables """
        posPlot[count, :] = robot[0:2]
        dirPlot[count, :] = robot[2]
        vPlot[count] = robot[3]
        wPlot[count] = robot[4]
        closestPlot[count] = disClosestObs 
        
        """ Check if the robot collided with an obstacle """
        if disClosestObs < 10:
            print('Robot collided with an obstacle')
            break
        eGoal = sense_goal(robot, goal)
        
    """ Plot the final results """
    update_plot(posRobot_data, radRobot, dirRobot_data, posObs_data, posStart, trace_plot, data)
    #plot_result(count, t, posPlot, dirPlot, vPlot, wPlot, closestPlot)