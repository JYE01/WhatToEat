# WhatToEat
UTS IOS application programming assignment3

This Git Hub repo is a private repo
https://github.com/JYE01/WhatToEat

Author: Junhui Ye, Yu Lok Fu, Aranth Tjandra
-----------------------------

Brief Project Description
=========================
WhatToEat is a recipe application based on SwiftUI, where users recommend cooking options based on the available ingredients to help them decide what to cook. This application allows users to add ingredients, dynamically filter recipes, and view detailed descriptions and images of each dish. It aims to reduce food waste, simplify meal plans, and introduce global cuisine to users. All of this will be achieved through a simple mobile interface.

The main features include:
1. Ingredient based formula filtration

2. Sorting based on cuisine

3. Detailed recipe view with images and cooking instructions

4. User login and favorite dish collection

5. Integrate with Firestore for real-time data synchronization

*IMPORTANT!*
This program is based on SwiftUI and firebase database, and it is structured following the Model-View-ViewModel (MVVM) design pattern.
-------------------------------------------------------------------------------------------------------------------------------------------------

FIREBASE SETUP
==============

If you want to connect this SwiftUI project with your Firebase, follow these steps:

1. Create a Firebase Project
----------------------------
- Go to Firebase Console: https://console.firebase.google.com
- Click "Add Project" and follow the setup wizard
- Disable Google Analytics if not needed

2. Register the iOS App
------------------------
- In the Firebase console, go to Project Settings → General
- Click "Add App" → Select iOS
- Enter your iOS bundle ID (e.g., com.yourname.YourApp)
- Download the generated GoogleService-Info.plist

3. Add GoogleService-Info.plist to Xcode
----------------------------------------
- Drag and drop GoogleService-Info.plist into your Xcode project
- Ensure "Copy items if needed" is checked

4. Install Firebase SDK
------------------------
If you're using Swift Package Manager (recommended for Xcode 12+):
- Go to Xcode > File > Add Packages
- Enter the URL: https://github.com/firebase/firebase-ios-sdk
- Select the version range (e.g., Up to Next Major: 10.0.0)
- Add the following packages:
    - FirebaseFirestore
    - FirebaseStorage

*** Additional notes ***
For more detail of Firebase setup, you can access this links: https://firebase.google.com/docs/ios/setup

FIRESTORE COLLECTIONS & DATA STRUCTURE
=====================================

This project uses Firebase Firestore to store and manage two types of data: Users and Recipes.

------------------------------------------------------------
USERS COLLECTION
------------------------------------------------------------

Each document in the "Users" collection represents a registered user and contains the following fields:

- email      : String  →  User's email address (should be unique)
- name       : String  →  Full name of the user
- password   : String  →  Password in plain text (for demo only; hash it in production)
- favourites : Array   →  A list of favorite recipe document IDs

Note: In a real-world app, always hash and securely store passwords. This implementation uses plain text for simplicity.

------------------------------------------------------------
RECIPES COLLECTION
------------------------------------------------------------

Each document in the "Recipes" collection represents a single recipe and contains the following fields:

- name        : String            →  Name of the recipe (e.g., "Spaghetti Bolognese")
- cuisine     : String            →  The cuisine type (e.g., "Italian", "Chinese")
- ingredients : Array of Strings  →  A list of ingredients (e.g., ["beef", "onion", "garlic"])
- description : String            →  Cooking instructions or description
- image       : String            →  Image path or asset name

------------------------------------------------------------
RECIPE IMAGE STORAGE OPTIONS
------------------------------------------------------------

There are two supported methods for managing recipe images:

1. Firebase Storage (Recommended for Production)
   - Upload your images to Firebase Storage.
   - For each image, copy the download URL.
   - Store the download URL in the "image" field of the recipe document.
   - Example:
     image = "https://firebasestorage.googleapis.com/v0/b/your-app.appspot.com/o/images%2Fpasta.jpg?alt=media"

2. Local Asset Catalog (Offline Support)
   - Add image files to Xcode’s Assets.xcassets folder.
   - Use the image name (without file extension) as the "image" value.
   - Example:
     image = "pasta"

Note: The SwiftUI code should determine whether the value is a URL or an asset name and display it accordingly using AsyncImage or Image.

-------------------------------------------------------------------------------------------------------------------------------------------------

USAGE
=====

This app supports two types of users: Guest and Registered Users.

------------------------------------
GUEST USERS
------------------------------------
- Guests can tap the "Find Recipes" button on the Home screen to access the Ingredient View.
- In the Ingredient View, they can:
  - Add ingredients manually (e.g., "beef", "carrot").
  - Click the "Go" button to access Recipe View.
- In the Recipe View, a list of recipes that match any of the entered ingredients will showing. And they can:
  - Use the Cuisine Filter to narrow down results by specific cuisine types.
  - Tap on a recipe to view its details, including image, description, and ingredients.
- Guests can also click the Account icon in the Home View to navigate to the Login view and sign up for an account.

------------------------------------
REGISTERED USERS
------------------------------------
- Except to the functions of guests users, registered users can log in using their email address and password.
- Once logged in, they have access to additional features:
  - Favorite Recipes:
    - On any Recipe Detail view, users can tap the heart ("Love") icon to save the recipe to their favorites.
  - Account View:
    - View a list of all recipes they have marked as favorites.

------------------------------------
RUNNING THE APP
------------------------------------
1. Open the project in Xcode.
2. Select a simulator or a real iOS device.
3. Press Cmd + R or click the "Run" button to build and launch the app.

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Now,,,Happy Coding~
