# GetFit

BeReal for the gym. It's time to GetFit >:)

## Solution
- At the beginning of the week, the user enters their gym schedule
- Based on the schedule, when they "should" be working out, they get a notification to take a picture within 2 minutes
- They get to retake the pic until the app sees a dumbbell in the image
- If it does, you pass - great job. If it doesn't after 2 min you get charged $2 for skipping the gym
- That fee is tracked and should be donated to charity

## Scenarios
- ### Take an image (Notification)
- ### Take an image (Screen)

- ### Dumbbell found in image
- ### No dumbbell found in image
- ### No dumbbell after 2 min

- ### Donation

- ### Schedule
- ### Schedule error
- ### Schedule not entered for the week (Notification)
- ### Scheduled not entered for the week (Alert)

## Why it was built
I need to go to the gym man

## Technologies
- App developed using Flutter, Dart, Python, and Xcode
- Dumbbell detection model was trained using Tensorflow Lite
- Features include: Computer Vision, Object Detection, Notifications

### Developed for iOS. Cannot gurantee it works on Android
