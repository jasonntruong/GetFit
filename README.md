# GetFit

BeReal for the gym. It's time to GetFit >:)

## Solution
- At the beginning of the week, the user enters their gym schedule
- Based on the schedule, when they "should" be working out, they get a notification to take a picture within 2 minutes
- They get to retake the pic until the app sees a dumbbell in the image
- If it does, you pass - great job. If it doesn't after 2 min you get charged $2 for skipping the gym
- That fee is tracked and should be donated to charity

## Scenarios
- ### [Take an image (Notification)](https://github.com/jasonntruong/GetFit/blob/main/screenshots/image/imageNotification.PNG)
- ### [Take an image (Screen)](https://github.com/jasonntruong/GetFit/blob/main/screenshots/image/imageScreen.PNG)

- ### [Dumbbell found in image](https://github.com/jasonntruong/GetFit/blob/main/screenshots/home/dumbbellFound.PNG)
- ### [No dumbbell found in image](https://github.com/jasonntruong/GetFit/blob/main/screenshots/home/noDumbbellAlert.PNG)
- ### [No dumbbell after 2 min](https://github.com/jasonntruong/GetFit/blob/main/screenshots/home/noDumbbell.PNG)

- ### [Donation](https://github.com/jasonntruong/GetFit/blob/main/screenshots/donation/donation.PNG)

- ### [Schedule](https://github.com/jasonntruong/GetFit/blob/main/screenshots/schedule/schedule.PNG)
- ### [Schedule error](https://github.com/jasonntruong/GetFit/blob/main/screenshots/schedule/scheduleError.PNG)
- ### [Schedule not entered for the week (Notification)](https://github.com/jasonntruong/GetFit/blob/main/screenshots/schedule/scheduleNotification.PNG)
- ### [Scheduled not entered for the week (Alert)](https://github.com/jasonntruong/GetFit/blob/main/screenshots/schedule/scheduleAlert.PNG)

## Why it was built
I need to go to the gym man

## Technologies
- App developed using Flutter, Dart, Python, and Xcode
- Dumbbell detection model was trained using Tensorflow Lite
- Features include: Computer Vision, Object Detection, Notifications

### Developed for iOS. Cannot gurantee it works on Android
