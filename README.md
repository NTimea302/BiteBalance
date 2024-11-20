# BiteBalance
Calorie Counting and Nutritional Analysis Mobile Application using Artificial Intelligence developed as bachelors's thesis @TUC-N

## Implementation details
A cross-platform mobile application in Flutter with Firebase & JavaScript back-end, connected to a local database.

### Image recognition model- Python
I used a pretrained convolutional neural network model, MobileNetV2 which is directly available from python, and further trained it for food recognition with the food 101 dataset from Kaggle. Each image is similar to a user taken one, it may not be exactly in the middle and has disturbance elements such as kitchenware, hands, table, etc. The foods in the dataset are complex foods like pizza, and other full meals.

### Back-end development
The back-end part consists of the server that connects and retrieves data from the local database, and also handles API connections. It is implemented in JavaScript with node.js and express. The back-end also has a part that handles user authentication, that is implemented in Firebase & Flutter. The user authentication was chosen to be implemented separately from the rest of the back-end for security reasons. Flutter & Firebase already provide a secure authentication system that works well for deployed applications, providing token-based authentication, secure data storage and session management logics, that can be easily implemented. Firebase follows industry standards for secure authentication, including encryption, token validation and secure data storage.
 
###  Front-End development
The front-end is implemented using Flutter SDK. The application can be run on emulators or on a physical device connected to the computer. The application was tested in both cases but during the development process a physical device was mainly used. The first step is to configure the coding environment. For developing this project, Visual Studio Code was used as IDE.  For developing this project the following dependencies and versions were used:
 flutter:
 sdk: flutter
 http: ^1.2.1
 flutter_launcher_icons: any
 english_words: ^4.0.0
 flutter_svg: ^2.0.9
 shared_preferences: ^2.0.8
 provider: ^6.1.2
 image_picker: ^1.1.1
 path_provider: ^2.0.15
 firebase_core: ^3.1.0
 firebase_auth: ^5.1.0
 google_sign_in: ^6.2.1
 cloud_firestore: ^5.0.1
 tflite: ^1.1.2
 tflite_flutter: ^0.9.5
 tflite_flutter_helper: ^0.2.0

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
