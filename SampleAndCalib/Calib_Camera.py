"""  Created by Tran Dang Trung Duc - 06/13/2021
     Description: Calibrate Camera Kinect XBox 360
                  Size of checkerboard (row,column) = (10,7) 
                  Size of cell (2.3x2.3) (mm x mm)
"""
# Libraries
import cv2 # OpenCV for computer vision
import numpy as np # Library for linear algebra
import glob

""" Step 1: Find chessboard corners - objectPoint and imagePoints
    Step 2: Calibration               """
def Find_corners_and_Calib(chessboardSize, frameSize, path):
    chessboardSize = (9,6) # Size of chessboard
    frameSize = (640,480) # Resolution of Camera
    
    # Termination criteria
    criteria = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER, 30, 0.001)
    
    # Prepare object points, like (0,0,0), (1,0,0), (2,0,0) ....,(6,5,0)
    objp = np.zeros((chessboardSize[0]*chessboardSize[1],3), np.float32)
    objp[:,:2] = np.mgrid[0:chessboardSize[0],0:chessboardSize[1]].T.reshape(-1,2)
    
    # Arrays to store object points and image points from all the images
    objPoints = [] # 3d points in real world space
    imgPoints = [] # 2d points in image plane
    
    images = glob.glob(path)
    
    for image in images:
        print(image)
        img = cv2.imread(image)
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        # Find the chess board corners
        ret, corners = cv2.findChessboardCorners(gray, chessboardSize, None)
        
        # If found, add object points, image points (after refining them)
        if ret == True:
            objPoints.append(objp)
            corners2 = cv2.cornerSubPix(gray, corners, (11,11), (-1,-1), criteria)
            imgPoints.append(corners)
            
            # Draw and display the corners
            cv2.drawChessboardCorners(img, chessboardSize, corners2, ret)
            cv2.imshow('img', img)
            cv2.waitKey(500) # Delay 0.5s
    
    cv2.destroyAllWindows()
    
    # print("Object Points: ", objPoints)
    # print("Image Points: ", imgPoints)
    
    """ Calibration """
    ret, cameraMatrix, dist, rvecs, tvecs = cv2.calibrateCamera(objPoints, imgPoints, frameSize, None, None)

    # print("Camera Calibrated: ", ret)
    # print("\nCamera Matrix:\n", cameraMatrix)
    # print("\nDistortion Parameters:\n ", rvecs)
    # print("\nRotation Vectors:\n", tvecs)
    return ret, cameraMatrix, dist, rvecs, tvecs, objPoints, imgPoints  

""" This is an optional step that can be skipped
    Step 3: Optimal Camera by crop image """   
def OptimalCamera(cameraMatrix, dist, alpha, path_sample):      
    """ Undistortion """
    img = cv2.imread(path_sample)
    h, w = img.shape[:2]
    newCameraMatrix, roi = cv2.getOptimalNewCameraMatrix(cameraMatrix, dist, (w,h), alpha, (w,h))
    return newCameraMatrix, roi, h, w

""" Select 1 of 2 steps 4a or 4b (for 2 same results)
    Step 4a: Undistort """   
def Undistort(img, cameraMatrix, dist, newCameraMatrix, roi, path):
    # Undistort 
    dst = cv2.undistort(img, cameraMatrix, dist, None, newCameraMatrix)
    # Crop the image
    x, y, w, h = roi
    dst = dst[y:y+h, x:x+w]
    cv2.imwrite(path, dst)

""" Step 4b: Undistort with Remapping """   
def Undistort_Remapping(img, cameraMatrix, dist, newCameraMatrix, roi, h, w, path):
    # Undistort with Remapping
    mapx, mapy = cv2.initUndistortRectifyMap(cameraMatrix, dist, None, newCameraMatrix, (w,h), 5)
    dst = cv2.remap(img, mapx, mapy, cv2.INTER_LINEAR)
    # Crop the image
    x, y, w, h = roi
    dst = dst[y:y+h, x:x+w]
    cv2.imwrite(path, dst)

""" Reprojection error """
def Reprojection_Error(objPoints,imgPoints, cameraMatrix, dist, rvecs, tvecs):
    mean_error = 0
    for i in range(len(objPoints)):
        imgPoints2, _ = cv2.projectPoints(objPoints[i], rvecs[i], tvecs[i], cameraMatrix, dist)
        error = cv2.norm(imgPoints[i], imgPoints2, cv2.NORM_L2)/len(imgPoints2)
        mean_error += error
        
    print("\ntotal_error: {}".format(mean_error/len(objPoints)))
    print("\n\n\n")

""" Drive program """
if __name__ == '__main__':    
    # Initialize parameters of Camera and Chessboard, import directory
    chessboardSize = (9,6)    
    frameSize = (640,480) 
    path = 'G:/1510815/Sample_Calibration/'
    ret, cameraMatrix, dist, rvecs, tvecs, objPoints, imgPoints = Find_corners_and_Calib(chessboardSize,frameSize, path + 'Sample/*.png')
    images = glob.glob(path + 'Sample/*.png')
    
    # Calib and distort with Optimization  
    alpha = 1
    i = 0
    for image in images:        
        newCameraMatrix, roi, h, w = OptimalCamera(cameraMatrix, dist, alpha, image)
        Undistort(cv2.imread(image), cameraMatrix, dist, newCameraMatrix, roi, path + 'Calib_Undist_Result_Op/Calib_Undist_Result_Op_' + str(i) +'.png')
        Undistort_Remapping(cv2.imread(image), cameraMatrix, dist, newCameraMatrix, roi, h, w, path + 'Calib_Remap_Result_Op/Calib_Remap_Result_Op_' + str(i) +'.png')
        i += 1
    Reprojection_Error(objPoints, imgPoints, cameraMatrix, dist, rvecs, tvecs)
   
    # Calib and distort without Optimization
    alpha = 0
    i = 0
    for image in images:
        newCameraMatrix, roi, h, w = OptimalCamera(cameraMatrix, dist, alpha, image)
        Undistort(cv2.imread(image), cameraMatrix, dist, None, roi, path + 'Calib_Undist_Result/Cali_Undist_Result_' + str(i) +'.png')
        Undistort_Remapping(cv2.imread(image), cameraMatrix, dist, None, roi, h, w, path + 'Calib_Remap_Result/Cali_Remap_Result_' + str(i) +'.png')
        i += 1
    Reprojection_Error(objPoints, imgPoints, cameraMatrix, dist, rvecs, tvecs)
    