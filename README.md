# BiteBalance
Calorie Counting and Nutritional Analysis Mobile Application using Artificial Intelligence developed as bachelors's thesis @TUC-N

## Implementation details
A cross-platform mobile application in Flutter with Firebase & JavaScript back-end, connected to a local database.

### Image recognition model- Python
I used a pretrained convolutional neural network model, MobileNetV2 which is directly available from python, and further trained it for food recognition with the food 101 dataset from Kaggle. Each image is similar to a user taken one, it may not be exactly in the middle and has disturbance elements such as kitchenware, hands, table, etc. The foods in the dataset are complex foods like pizza, and other full meals.  The model is converted to a tflite format compatible with Flutter development kit, that is lightweight for a mobile application.
Implementing image recognition model in Flutter was done using the tflite flutter helper and tflife flutter packages.

### Back-end development
The back-end part consists of the server that connects and retrieves data from the local database, and also handles API connections. It is implemented in JavaScript with node.js and express. The back-end also has a part that handles user authentication, that is implemented in Firebase & Flutter. The user authentication was chosen to be implemented separately from the rest of the back-end for security reasons. Flutter & Firebase already provide a secure authentication system that works well for deployed applications, providing token-based authentication, secure data storage and session management logics, that can be easily implemented. Firebase follows industry standards for secure authentication, including encryption, token validation and secure data storage.
 
###  Front-End development
The front-end is implemented using Flutter SDK. The application can be run on emulators or on a physical device connected to the computer. The application was tested in both cases but during the development process a physical device was mainly used. The first step is to configure the coding environment. For developing this project, Visual Studio Code was used as IDE.

![image](https://github.com/user-attachments/assets/e883e2fc-6a9d-4aa4-a00c-5dfe66d73e2a)
![image](https://github.com/user-attachments/assets/a21b5e6f-2834-4782-8ee7-5d46b4d2a66c)
![image](https://github.com/user-attachments/assets/3626d4b9-19c9-45a6-a979-a375fe8c21f0)

More details about the implementation can be found in the detailed project documentation available above.
 
## Getting started
To run the application, firstly you need to run the server. Navigate in the extracted
folder to BiteBalance/BackEnd, open a command line to this location and type:
      node server.js
If everything is ok, the command line should display:
    Listening to port: 3000
After running the server, the next step is runnig the flutter project. Choose a physical
device, iOS or Android, connect it to the laptop with a wired connection. Make sure
the device and the laptop are both connected to the same wifi network. This step is
important to ensure proper data flow between devices. Open a command line to the
following location: BiteBalance/FrontEnd/bite balance and type:
      flutter run
After some time, the application should start and should be ready to use.
