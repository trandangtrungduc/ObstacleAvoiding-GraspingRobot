import numpy as np

def limit_angle(theta):    
    """ Limit the value of angle in the range [-pi,pi]"""
    if theta > np.pi:
        theta = theta - 2*np.pi
    elif theta < -np.pi:
        theta = theta + 2*np.pi
    return theta

def calc_vector(startPoint, endPoint):
    """ Calculate the length and angle of the vector from start to end respect to x-axis """
    x_dis = endPoint[0] - startPoint[0]
    y_dis = endPoint[1] - startPoint[1]
    length = np.sqrt(np.power(x_dis,2) + np.power(y_dis,2))
    theta = np.arctan2(y_dis, x_dis)
    return np.array([theta, length])

def add_vector(vector1, vector2):
    pos1 = vector1[1]*np.array([np.cos(vector1[0]), np.sin(vector1[0])])
    pos2 = vector2[1]*np.array([np.cos(vector2[0]), np.sin(vector2[0])])
    return calc_vector(np.array([0,0]), pos1+pos2)

