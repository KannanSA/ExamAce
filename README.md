# ExamAce

SwiftUI iOS study app: cream paper background, a gold 25-minute timer for **Further Maths Paper 2**, and tabs for Plan, Timer, Tutors, Sleep, and You.

Open `ExamAce.xcodeproj` in Xcode 16 or later (iOS 17+). Select your Development Team under Signing & Capabilities, then run on a simulator or device.

The study timer, streaks, points, and revision list work locally. HealthKit and Sign in with Apple are stubbed with TODOs until those capabilities are enabled on an Apple Developer team.

---

# ExamAce Privacy Policy

**Effective Date:** August 31, 2025  
**Last Updated:** August 31, 2025

## Overview

ExamAce ("we," "our," or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application ExamAce (the "App"). By using our App, you agree to the collection and use of information in accordance with this policy.

## Information We Collect

### 1. Personal Information
When you use ExamAce, we may collect the following personal information:

- **Sign in with Apple Data**: When you choose to sign in with Apple, we receive:
  - Your name (if you choose to share it)
  - Your email address (if you choose to share it)
  - A unique Apple ID identifier
  
- **Tutor Profile Information**: If you register as a tutor, we collect:
  - Full name
  - Email address
  - Subject areas you teach
  - Hourly rates
  - Availability schedule
  - Ratings and reviews from students

### 2. Health and Fitness Data
With your explicit permission, ExamAce accesses your HealthKit data to:
- Read workout data to display daily exercise minutes
- Read sleep data to show last night's sleep duration
- **Note**: We only read this data; we never write or modify your health information

### 3. Calendar Data
With your permission, ExamAce accesses your calendar to:
- Add study sessions to your calendar
- Export your revision plan to your calendar app
- Sync study schedules with your existing calendar events

### 4. Study and Usage Data
We collect information about your app usage, including:
- Study session duration and frequency
- Subject preferences and study patterns
- Gamification progress (points, streaks, achievements)
- Planner and scheduling activities
- Tutor booking and rating activities

### 5. Device Information
We automatically collect certain device information:
- Device type and operating system version
- App version and crash reports
- Usage analytics and performance data

## How We Use Your Information

### Primary Purposes
We use your information to:
- **Provide Core App Services**: Enable study planning, timer functionality, and progress tracking
- **Health Integration**: Display your exercise and sleep summaries to help optimize study schedules
- **Calendar Integration**: Sync your study plans with your calendar
- **Tutor Marketplace**: Connect students with tutors and facilitate bookings
- **Personalization**: Customize your study experience and recommendations

### Secondary Purposes
- **App Improvement**: Analyze usage patterns to enhance features and user experience
- **Support**: Provide customer support and troubleshoot issues
- **Safety**: Ensure the security and integrity of our services

## Data Storage and Synchronization

### Local Storage
- Study data, preferences, and gamification progress are stored locally on your device
- Tutor bookings and personal study information remain on your device

### CloudKit Synchronization
- **Tutor profiles** are synchronized through Apple's CloudKit service to enable the tutor marketplace
- CloudKit data is encrypted and managed according to Apple's privacy standards
- Only tutor-related information (profiles, ratings, availability) is stored in CloudKit's public database

### Data Retention
- Personal data is retained as long as you have the app installed and maintain an account
- You can delete your data at any time by removing the app or clearing app data
- Tutor profile data may remain in CloudKit until explicitly removed by an administrator

## Data Sharing and Disclosure

### Information We Share
- **Tutor Profiles**: Tutor information is visible to students using the app
- **Ratings and Reviews**: Student ratings of tutors are shared publicly within the app
- **No Third-Party Sharing**: We do not sell, trade, or share your personal information with third parties

### When We May Disclose Information
We may disclose your information only in the following circumstances:
- **Legal Requirements**: When required by law, regulation, or court order
- **Safety**: To protect the rights, property, or safety of ExamAce, our users, or others
- **Business Transfer**: In connection with a merger, acquisition, or sale of assets (with user notification)

## Your Privacy Rights and Choices

### Access and Control
- **Health Data**: You can revoke HealthKit permissions at any time through iOS Settings
- **Calendar Access**: You can disable calendar access through iOS Settings
- **Sign in with Apple**: You can manage your Apple ID connection through Settings
- **Data Deletion**: You can request deletion of your tutor profile through the admin dashboard

### Admin Controls
- Administrators can approve or remove tutor profiles
- Admin access is protected by authentication codes
- Admin actions are logged for accountability

## Children's Privacy

ExamAce is designed for students of all ages, including those under 13. We comply with COPPA (Children's Online Privacy Protection Act) requirements:
- We do not knowingly collect personal information from children under 13 without parental consent
- Parents can review, delete, or refuse further collection of their child's information
- If you believe we have collected information from a child under 13, please contact us immediately

## Data Security

We implement appropriate security measures to protect your information:
- **Encryption**: Data transmission is encrypted using industry-standard protocols
- **Apple Security**: We leverage Apple's security infrastructure for Sign in with Apple and CloudKit
- **Local Storage**: Sensitive data is stored securely on your device using iOS security features
- **Access Controls**: Admin functions are protected by authentication mechanisms

## International Data Transfers

Your information may be transferred to and processed in countries other than your own. We ensure that such transfers comply with applicable privacy laws and that your data receives adequate protection.

## Changes to This Privacy Policy

We may update this Privacy Policy from time to time. We will notify you of any changes by:
- Posting the new Privacy Policy in the app
- Updating the "Last Updated" date at the top of this policy
- For significant changes, providing in-app notifications

Your continued use of the App after changes constitutes acceptance of the updated policy.

## Third-Party Services

ExamAce integrates with the following Apple services:
- **HealthKit**: For reading health and fitness data
- **EventKit**: For calendar integration
- **CloudKit**: For tutor data synchronization
- **Sign in with Apple**: For authentication

These services are governed by Apple's Privacy Policy, which you can review at https://www.apple.com/privacy/

## Contact Information

If you have questions, concerns, or requests regarding this Privacy Policy or your personal information, please contact us:

**Email**: privacy@examace.app  
**Address**: [Your Company Address]  
**Phone**: [Your Phone Number]

For data protection inquiries in the EU, you may also contact our Data Protection Officer at dpo@examace.app.

## Legal Basis for Processing (EU Users)

If you are in the European Union, our legal basis for processing your personal information includes:
- **Consent**: For health data access and optional features
- **Contract Performance**: To provide the core app services you've requested
- **Legitimate Interests**: To improve our services and ensure security

## Your EU Rights

If you are in the EU, you have the right to:
- Access your personal data
- Rectify inaccurate data
- Erase your data ("right to be forgotten")
- Restrict processing
- Data portability
- Object to processing
- Withdraw consent at any time

## California Privacy Rights

If you are a California resident, you have specific rights under the California Consumer Privacy Act (CCPA):
- Right to know what personal information is collected
- Right to know if personal information is sold or disclosed
- Right to say no to the sale of personal information
- Right to access your personal information
- Right to equal service and price

We do not sell personal information to third parties.

---

**Note**: This privacy policy is designed to be comprehensive and compliant with major privacy regulations. Please review it carefully and update contact information and company details as needed for your specific implementation.
