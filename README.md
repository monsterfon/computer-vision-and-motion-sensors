# Computer Vision and Motion Sensors

This project contains two main components:

## Computer Vision for Face Detection

I wrote a program that uses computer vision techniques to detect faces in images. The program analyzes the gradient of the image and color features to identify faces with high accuracy. The face detection approach relies on these image properties to differentiate faces from the background, providing a robust method for various lighting and image conditions.

## Motion Detection and Gyroscope Data Interpretation

Using MATLAB, I developed a system to detect and measure motion based on sensor data. The program interprets data from a gyroscope to track movement and calculate the amount of motion. This system can be used for various applications, such as:

- **Step Counting**: By analyzing the motion data, the program can estimate the number of steps a person has taken.
- **Pulse Measurement**: Using the video data along with motion sensors, the system can estimate a person's pulse rate, providing a unique way to measure heart rate using only a video feed.

### Technologies Used:
- **MATLAB** for motion detection and gyroscope data interpretation.
- **OpenCV** and image gradient techniques for face detection.

## How to Run

1. Clone the repository.
2. Run the MATLAB code for motion detection and gyroscope data analysis.
3. Use the face detection script to find faces based on image gradients and color.

---

Feel free to explore and modify the code for your own applications.
