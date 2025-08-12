# Objais Frontend



This repository contains the frontend code for the Objais mobile application built with Flutter.



---



## **Safety Notice**

Safe to share – Contains no backend logic or sensitive API keys.



The .env file only includes the BASE_URL for API requests. All sensitive data (pricing logic, keys, business rules) lives in a separate backend repository.



## **Requirements**

Install Flutter (latest stable version recommended).

Install Dart (comes bundled with Flutter).

A code editor such as VS Code.



## **Setup Instructions**

### Clone the repository



git clone <repository_url>

cd <repository_folder>



### Install dependencies

flutter pub get



### Add your .env file in the project root:

BASE_URL=https://example.com/api



### Run the application

flutter run



## **Project Structure**

- lib/ – Main Flutter source code (screens, widgets, controllers).

- assets/ – Images, icons, and static resources.

- android/, ios/ – Platform-specific build files.

- .gitignore – Prevents sensitive/unnecessary files from being committed.



## **Additional Notes**

This repository is for UI/UX and client-side development only.

Backend integration happens via API calls using the BASE_URL.
