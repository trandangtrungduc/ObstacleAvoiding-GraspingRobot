import math
def calc_vector(startPoint, endPoint):
    #Calculate the length and angle of the vector from start to end respect to x-axis
    x_dis = endPoint(1) - startPoint(1)
    y_dis = endPoint(2) - startPoint(2)
    length = math.sqrt(x_dis^2 + y_dis^2)
    theta = math.atan2(y_dis, x_dis)
    return theta, length

def limit_angle(theta):
    if theta > math.pi:
        theta = theta - 2*math.pi
    elif theta < -math.pi:
        theta = theta + 2*math.pi
    return theta