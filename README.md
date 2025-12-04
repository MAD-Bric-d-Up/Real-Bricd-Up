# Bric'd Up

Track BRIC (gym) progress with fellow Cal Poly Pomona students by taking photos in line with your gym goals!  
Share up-to-date events and statuses on BRIC related things!  
Keep up your streak by hitting your weekly amount of photos.  
See how your friends are progressing at the BRIC.  

## Starting App

To download libraries and necessary files:  
$ flutter pub get  


If there's errors still with camera, try:  
$ flutter pub add camera  


Install firebase cli:  
$ npm install -g firebase-tools  


Login to firebase on terminal in flutter project:  
$ firebase login  


Activate flutterfire cli:  
$ dart pub global activate flutterfire_cli  


Configure flutterfire:  
$ flutterfire configure --project=bric-d-up  
OR IF THAT DOESN'T WORK:  
$ flutterfire.bat configure --project=bric-d-up  


To run locally on chrome:  
$ flutter run -d chrome  

## Loading Feed

I had to download Google Cloud SDK on the web and then after setting it up I ran in command prompt/powershell terminal

Created a file named cors.json with following code

[
  {
    "origin": ["http://localhost:*", "*"],
    "method": ["GET", "HEAD"],
    "maxAgeSeconds": 3600
  }
]

$ gcloud auth login

$ gcloud auth list

$ gsutil cors set <path-to-cors.json-file> gs://bric-d-up.firestore.app


