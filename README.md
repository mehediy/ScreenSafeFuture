# ScreenSafeFuture
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

ScreenSafeFuture: A Parent-empathetic and Pragmatic mHealth Application for Toddlers' Brain Development Addressing Screen-Addiction Challenges


## Table of Contents
- [Table of Contents](#table-of-contents)
- [Background](#background)
- [Functionality](#functionality) 
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Dependencies](#dependencies)
- [Design](#design)
- [Contributions](#contributions)
- [Troubleshooting](#troubleshooting)
- [License](#license)

## Background

In today’s fast-paced digital age, the surging incidents of infant and toddler screen addiction in the United States are becoming a pressing concern due to its detrimental and compound impact on cognitive development, mental health, and physical and socio-economic growth. Parents, precisely working parents, continually confront obstructions in regulating their offspring's movements. Subsequently, screen devices have appeared as a convenient alternative, serving as a helping hand for these struggling parents.
Unsupervised and extreme screen consumption among this significant population is associated with a range of adverse outcomes, shortcomings, and potential risks. In response to this era's critical child health and human development issues, a personalized mHealth solution can appear as a practical proposition to help parents strengthen the protection of their children from excessive device ingestion and strike a stable balance between technology ingestion and ideal parenting.

How can we adopt a more empathetic, holistic, and pragmatic approach that specifies personalized solutions to cater the requirements of parents in the present era? Acknowledging the effectiveness and convenience of smartphones as a healthcare tool, an innovative mHealth application is proposed that provides practical and parent-friendly solutions that seamlessly fit into parents' busy lifestyles.


## Functionality
An iOS prototype of the ScreenSafeFuture mHealth system that
* Envisions addressing screen addiction challenges
* permits parents in navigating their children’s screen device activities
* ensures that the contents consumed are educational and age-appropriate
* concentrates on the micro-digital ecosystem within a specific household
* supports younger generations' healthy development


## Features

- [x] **Personalized Activity Advocator**: Recommending tailored non-screen activity proposals for children
* [x] **Screen Time Tracking and Monitoring**: Consenting parents to remain conscious about their child’s digital media expenditure
* [x] **Educational Reservoir**: Delivering an extensive collection of resources to parents on prevailing screen time guidelines
* [ ] **Digital Reward System**: Providing rewards to parents for comprehending healthy media habits

## Requirements

| Requirement            | Details                                          |
|------------------------|--------------------------------------------------|
| Platform               | iOS 16.0+                                        |
| Swift Version          | Swift 5.3                                        |
| Xcode Version          | Xcode 14.0+                                      |
| Supported Architectures| arm64, x86_64 (Simulator)                        |
| Dependency Managers    | Swift Package Manager                            |
| Third-Party Services   | Firebase                                         |
| Contribution Guidelines| [Contribution Guide](#contributions)             |


### App Development Environment
* IDE and Code Editor: Xcode
* Core programming language: Swift
* UI Frameworks: UIKit & SwiftUI
* Dependency manager: Swift Package Manager
* Version control system: Git
* Backend Infrastructure: Firebase SDKs
* Hardware: Mac computer


## Installation

This section provides instructions on setting up the project on your local development environment.

### Step 1: Clone the Repository

Clone the project repository to your local machine by running the following command in the terminal:

```bash
git clone [https://github.com/yourusername/yourprojectname.git](https://github.com/mehediy/ScreenSafeFuture.git)
cd ScreenSafeFuture
```

### Step 2: Setting Up the Project in Xcode
1. **Open the Project**: After cloning the repository, open the .xcodeproj file in Xcode:
2. **Install Dependencies**: Xcode should automatically fetch the dependencies with Swift Package Manager. If it doesn't, you can manually fetch and update the packages by navigating to:
`Xcode > File > Swift Packages > Update to Latest Package Versions`

### Step 3:  Configuring Signing and Provisioning
Each target in the project (main app and extensions) requires specific signing and provisioning settings:
1. **Select the Team**: In Xcode's General tab for each target, select the appropriate team from the "Team" dropdown.
2. **Manage Signing**:
   - **Automatic**: For automatic signing, check "Automatically manage signing" and ensure the correct team is selected.
   - **Manual**: For manual signing, uncheck "Automatically manage signing" and select the specific provisioning profiles for each target, aligned with their bundle identifiers and capabilities.

### Step 4: Configure Firebase
The project uses Firebase as a third-party service. the project already includes Firebase configuation, but to configure Firebase your own:
* Download the GoogleService-Info.plist file from your Firebase project's settings page.
* Drag and drop the GoogleService-Info.plist file into the root of your Xcode project. Ensure you select "Copy items if needed" and add the file to all relevant targets.

### Step 5: Run the Project
Select your target device or simulator from the Xcode toolbar. Then, press the Run button (▶) to build and run the project.

## Dependencies

ScreenSafeFuture depends on the following libraries:

- [Firebase](https://github.com/firebase/firebase-ios-sdk)
- [PagerTabStripView](https://github.com/xmartlabs/PagerTabStripView)
- [McPicker-iOS](https://github.com/kmcgill88/McPicker-iOS)
- [Anchorage](https://github.com/Rightpoint/Anchorage)
- [DateHelper](https://github.com/melvitax/DateHelper)

## Design
Sign-Up and Authentication

<img width="325" alt="image" src="https://github.com/mehediy/ScreenSafeFuture/assets/16387621/bad5ea5c-9da4-478d-801c-8e322b10f63a">

Personalized Activity Advocator

<img width="710" alt="image" src="https://github.com/mehediy/ScreenSafeFuture/assets/16387621/c17c5546-54cf-42ec-ade9-ee0a4a8c9f44">

Screen Time Tracking and Monitoring

<img width="710" alt="image" src="https://github.com/mehediy/ScreenSafeFuture/assets/16387621/c03745d5-4e30-41b5-8a04-841999777fb1">

Educational Reservoir

<img width="710" alt="image" src="https://github.com/mehediy/ScreenSafeFuture/assets/16387621/c46e3b54-af46-4e57-a108-31ab6b395f5e">



## Contributions
Your contributions are appreciated! Here's how you can help:

1. **Fork** the repository.
2. **Create** a new branch: `git checkout -b feature/your-feature-name`.
3. **Commit** your changes: `git commit -am 'Add some feature'`.
4. **Push** to the branch: `git push origin feature/your-feature-name`.
5. **Open** a pull request.

Thank you for supporting ScreenSafeFuture!



## Troubleshooting
- Ensure all targets have the correct signing team and provisioning profiles, especially if using manual signing.
- For issues related to dependency fetching, verify your internet connection and the configuration of Swift Package Manager within Xcode.

Feel free to report any issues or ask for help by opening an issue on GitHub.



## License

ScreenSafeFuture is released under Apache License 2.0. [See LICENSE](https://github.com/mehediy/ScreenSafeFuture/blob/main/LICENSE) for details.
