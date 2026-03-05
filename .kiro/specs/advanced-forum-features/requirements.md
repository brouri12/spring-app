# Requirements Document - Advanced Forum Features

## Introduction

This document specifies requirements for three advanced business features to be added to an existing Spring Boot forum service with Angular frontend. The features include multimedia integration capabilities, an email notification system, and an AI-powered chatbot assistant. These features will enhance user engagement and provide modern forum functionality while integrating seamlessly with existing forum components (messages, likes, replies, signalements, badges, and notifications).

## Glossary

- **Forum_Service**: The Spring Boot microservice running on port 8082 that handles forum business logic
- **Public_Frontend**: The Angular application on port 65198 for end users
- **Back_Office**: The Angular administration application on port 4201
- **MessageForum**: Existing entity representing a forum message/post
- **Multimedia_Manager**: Component responsible for handling file uploads, storage, and retrieval
- **Email_Service**: Component responsible for sending email notifications to users
- **Chatbot_Service**: AI-powered component that assists users with forum navigation and questions
- **Media_File**: Any uploaded file including images, videos, audio, or documents
- **Transcription**: Text conversion of audio/video content
- **Digest_Email**: Periodic summary email containing forum activity
- **Mention**: Reference to a user using @ symbol followed by username
- **User**: A registered forum participant
- **Administrator**: A user with administrative privileges in the Back_Office

## Requirements

### Requirement 1: Upload and Display Images

**User Story:** As a User, I want to upload images to my forum posts, so that I can share visual content with other participants.

#### Acceptance Criteria

1. WHEN a User creates or edits a MessageForum, THE Forum_Service SHALL accept image uploads in JPEG, PNG, GIF, and WebP formats
2. WHEN an image is uploaded, THE Multimedia_Manager SHALL validate that the file size does not exceed 10MB
3. WHEN an image is uploaded, THE Multimedia_Manager SHALL generate a thumbnail preview with maximum dimensions of 200x200 pixels
4. WHEN a User views a MessageForum containing images, THE Public_Frontend SHALL display the thumbnail preview
5. WHEN a User clicks on an image thumbnail, THE Public_Frontend SHALL display the full-size image
6. IF an uploaded file is not a valid image format, THEN THE Forum_Service SHALL return an error message in French
7. THE Multimedia_Manager SHALL store uploaded images with unique identifiers to prevent filename conflicts

### Requirement 2: Integrate Video Content

**User Story:** As a User, I want to embed YouTube and Vimeo videos in my posts, so that I can share video content without uploading large files.

#### Acceptance Criteria

1. WHEN a User provides a YouTube URL, THE Forum_Service SHALL extract the video identifier and store it with the MessageForum
2. WHEN a User provides a Vimeo URL, THE Forum_Service SHALL extract the video identifier and store it with the MessageForum
3. WHEN a User views a MessageForum containing a video link, THE Public_Frontend SHALL display an embedded video player
4. THE Forum_Service SHALL validate that provided URLs are from YouTube or Vimeo domains
5. IF a provided URL is not from YouTube or Vimeo, THEN THE Forum_Service SHALL return an error message in French
6. WHEN a video is embedded, THE Public_Frontend SHALL display the video title and thumbnail before playback

### Requirement 3: Record and Upload Audio

**User Story:** As a User, I want to record audio messages directly in the forum, so that I can share voice content without external recording tools.

#### Acceptance Criteria

1. WHEN a User creates or edits a MessageForum, THE Public_Frontend SHALL provide an audio recording interface
2. WHEN a User starts recording, THE Public_Frontend SHALL request microphone permissions from the browser
3. WHEN a User completes recording, THE Multimedia_Manager SHALL accept audio files in MP3, WAV, and OGG formats
4. THE Multimedia_Manager SHALL validate that audio file size does not exceed 25MB
5. WHEN a User views a MessageForum containing audio, THE Public_Frontend SHALL display an audio player with play, pause, and volume controls
6. THE Public_Frontend SHALL display the audio duration in minutes and seconds
7. IF microphone access is denied, THEN THE Public_Frontend SHALL display an error message in French explaining the requirement

### Requirement 4: Share Document Files

**User Story:** As a User, I want to attach document files to my posts, so that I can share resources like PDFs and archives with other participants.

#### Acceptance Criteria

1. WHEN a User creates or edits a MessageForum, THE Forum_Service SHALL accept file uploads in PDF, ZIP, RAR, DOC, DOCX, XLS, and XLSX formats
2. THE Multimedia_Manager SHALL validate that document file size does not exceed 50MB
3. WHEN a document is uploaded, THE Multimedia_Manager SHALL store the original filename and file size
4. WHEN a User views a MessageForum containing documents, THE Public_Frontend SHALL display a download link with filename and size
5. WHEN a User clicks a document download link, THE Forum_Service SHALL serve the file with appropriate content-type headers
6. THE Multimedia_Manager SHALL scan uploaded files for malware before storage
7. IF a file fails malware scanning, THEN THE Forum_Service SHALL reject the upload and return an error message in French

### Requirement 5: Manage Forum Image Galleries

**User Story:** As a User, I want to view all images shared in a forum as a gallery, so that I can browse visual content easily.

#### Acceptance Criteria

1. WHEN a User requests a forum gallery view, THE Forum_Service SHALL retrieve all images from MessageForum entries in that forum
2. THE Public_Frontend SHALL display images in a grid layout with thumbnails
3. WHEN a User clicks on a gallery thumbnail, THE Public_Frontend SHALL open a lightbox view with navigation controls
4. THE Public_Frontend SHALL display image metadata including uploader name and upload date
5. WHERE an Administrator views the gallery in the Back_Office, THE Back_Office SHALL provide options to delete inappropriate images
6. WHEN an Administrator deletes an image from the gallery, THE Forum_Service SHALL remove the image from storage and update the associated MessageForum

### Requirement 6: Transcribe Video and Audio Content

**User Story:** As a User, I want automatic transcriptions of video and audio content, so that I can read content instead of listening when needed.

#### Acceptance Criteria

1. WHEN audio or video content is uploaded, THE Multimedia_Manager SHALL generate a text transcription
2. THE Multimedia_Manager SHALL support transcription for French and English languages
3. WHEN transcription is complete, THE Forum_Service SHALL store the transcription text with the Media_File
4. WHEN a User views a MessageForum with transcribed media, THE Public_Frontend SHALL display a toggle to show or hide the transcription
5. THE Multimedia_Manager SHALL process transcriptions asynchronously to avoid blocking message creation
6. IF transcription fails, THEN THE Forum_Service SHALL log the error but still allow the media to be posted without transcription

### Requirement 7: Send Welcome Emails to New Users

**User Story:** As a new User, I want to receive a welcome email when I register, so that I understand how to get started with the forum.

#### Acceptance Criteria

1. WHEN a new User completes registration, THE Email_Service SHALL send a welcome email to the User's registered email address
2. THE Email_Service SHALL include forum navigation instructions in French in the welcome email
3. THE Email_Service SHALL include links to the Public_Frontend in the welcome email
4. THE Email_Service SHALL use HTML email templates with proper formatting
5. IF email delivery fails, THEN THE Email_Service SHALL retry up to 3 times with exponential backoff
6. THE Email_Service SHALL log all email delivery attempts with success or failure status

### Requirement 8: Notify Users of Replies

**User Story:** As a User, I want to receive email notifications when someone replies to my posts, so that I can stay engaged in discussions.

#### Acceptance Criteria

1. WHEN a ReponseMessage is created for a User's MessageForum, THE Email_Service SHALL send a notification email to the original poster
2. THE Email_Service SHALL include the reply author's name and reply preview in the notification
3. THE Email_Service SHALL include a direct link to the MessageForum in the notification
4. WHERE a User has disabled reply notifications in their preferences, THE Email_Service SHALL not send reply notifications to that User
5. THE Email_Service SHALL batch multiple replies within 5 minutes into a single notification email
6. THE Email_Service SHALL not send notifications for a User's own replies to their posts

### Requirement 9: Send Weekly Digest Emails

**User Story:** As a User, I want to receive weekly summary emails of forum activity, so that I can stay informed without checking the forum daily.

#### Acceptance Criteria

1. THE Email_Service SHALL send digest emails every Sunday at 09:00 server time
2. THE Email_Service SHALL include the top 10 most active MessageForum entries from the past week in the digest
3. THE Email_Service SHALL include the number of new messages and replies in the digest
4. THE Email_Service SHALL include links to featured discussions in the digest
5. WHERE a User has disabled digest emails in their preferences, THE Email_Service SHALL not send digests to that User
6. IF a User has not visited the forum in the past week, THE Email_Service SHALL include a re-engagement message in the digest

### Requirement 10: Alert Users of Mentions

**User Story:** As a User, I want to receive immediate email alerts when someone mentions me with @username, so that I can respond to direct references quickly.

#### Acceptance Criteria

1. WHEN a MessageForum or ReponseMessage contains @username syntax, THE Forum_Service SHALL identify the mentioned User
2. WHEN a User is mentioned, THE Email_Service SHALL send an alert email within 1 minute
3. THE Email_Service SHALL include the mentioning User's name and message preview in the alert
4. THE Email_Service SHALL include a direct link to the MessageForum containing the mention
5. THE Forum_Service SHALL validate that mentioned usernames exist before sending alerts
6. WHERE a User has disabled mention alerts in their preferences, THE Email_Service SHALL not send mention alerts to that User
7. THE Email_Service SHALL not send mention alerts for a User's own mentions of themselves

### Requirement 11: Send Daily Summary Emails

**User Story:** As a User, I want to receive daily summary emails of unread activity, so that I can catch up on discussions at my preferred time.

#### Acceptance Criteria

1. THE Email_Service SHALL send daily summary emails every day at 18:00 server time
2. THE Email_Service SHALL include only unread MessageForum entries and ReponseMessage entries in the summary
3. THE Email_Service SHALL group content by forum category in the summary
4. THE Email_Service SHALL include the total count of unread items in the email subject line
5. WHERE a User has disabled daily summaries in their preferences, THE Email_Service SHALL not send daily summaries to that User
6. IF a User has no unread content, THEN THE Email_Service SHALL not send a daily summary to that User

### Requirement 12: Remind Users of Unread Discussions

**User Story:** As a User, I want to receive reminders about discussions I participated in but haven't checked recently, so that I don't miss important follow-ups.

#### Acceptance Criteria

1. WHEN a MessageForum that a User participated in has new activity and remains unread for 48 hours, THE Email_Service SHALL send a reminder email
2. THE Email_Service SHALL include the discussion title and number of new replies in the reminder
3. THE Email_Service SHALL include a direct link to the MessageForum in the reminder
4. THE Email_Service SHALL send a maximum of one reminder per MessageForum per week
5. WHERE a User has disabled reminder emails in their preferences, THE Email_Service SHALL not send reminders to that User
6. THE Email_Service SHALL not send reminders for MessageForum entries marked as resolved or closed

### Requirement 13: Provide Email Preference Management

**User Story:** As a User, I want to control which email notifications I receive, so that I can customize my communication preferences.

#### Acceptance Criteria

1. THE Public_Frontend SHALL provide an email preferences page in the User profile section
2. THE Public_Frontend SHALL display toggles for welcome emails, reply notifications, weekly digests, mention alerts, daily summaries, and unread reminders
3. WHEN a User changes email preferences, THE Forum_Service SHALL persist the preferences to the database
4. THE Email_Service SHALL respect User preferences before sending any email notification
5. THE Public_Frontend SHALL display preference descriptions in French
6. THE Public_Frontend SHALL provide a "Unsubscribe from all" option that disables all email notifications

### Requirement 14: Provide AI-Powered Forum Assistance

**User Story:** As a User, I want to interact with an AI chatbot for help, so that I can get immediate answers to common questions without waiting for human support.

#### Acceptance Criteria

1. THE Public_Frontend SHALL display a chatbot interface accessible from all forum pages
2. WHEN a User sends a message to the chatbot, THE Chatbot_Service SHALL process the message and return a response within 3 seconds
3. THE Chatbot_Service SHALL provide responses in French
4. THE Chatbot_Service SHALL answer questions about forum navigation, features, and policies
5. THE Chatbot_Service SHALL provide links to relevant forum sections when appropriate
6. WHEN the Chatbot_Service cannot answer a question, THE Chatbot_Service SHALL suggest contacting an Administrator
7. THE Public_Frontend SHALL display the chatbot icon in the bottom-right corner of the screen

### Requirement 15: Train Chatbot on Forum Content

**User Story:** As an Administrator, I want the chatbot to learn from forum content, so that it can provide accurate and contextual assistance.

#### Acceptance Criteria

1. THE Chatbot_Service SHALL index MessageForum content for knowledge base creation
2. THE Chatbot_Service SHALL update its knowledge base daily with new forum content
3. WHERE an Administrator marks a MessageForum as a FAQ, THE Chatbot_Service SHALL prioritize that content in responses
4. THE Back_Office SHALL provide an interface for Administrators to review and approve chatbot training data
5. THE Chatbot_Service SHALL exclude Signalement-flagged content from training data
6. THE Chatbot_Service SHALL maintain conversation context for up to 10 message exchanges per User session

### Requirement 16: Monitor Chatbot Interactions

**User Story:** As an Administrator, I want to review chatbot conversations, so that I can identify areas for improvement and ensure quality assistance.

#### Acceptance Criteria

1. THE Chatbot_Service SHALL log all User interactions with timestamps and User identifiers
2. THE Back_Office SHALL provide a dashboard displaying chatbot usage statistics
3. THE Back_Office SHALL display the most frequently asked questions to the chatbot
4. THE Back_Office SHALL display User satisfaction ratings for chatbot responses
5. WHERE a User reports a chatbot response as unhelpful, THE Chatbot_Service SHALL flag that interaction for Administrator review
6. THE Back_Office SHALL allow Administrators to export chatbot conversation logs in CSV format

### Requirement 17: Integrate Multimedia with Existing Features

**User Story:** As a User, I want multimedia content to work with existing forum features like likes and signalements, so that I have a consistent experience.

#### Acceptance Criteria

1. WHEN a MessageForum contains Media_File attachments, THE Forum_Service SHALL allow Users to like the message using existing LikeMessage functionality
2. WHEN a User creates a Signalement for a MessageForum, THE Forum_Service SHALL include information about attached Media_File items in the report
3. THE Back_Office SHALL display Media_File previews when Administrators review Signalement reports
4. WHEN an Administrator deletes a MessageForum, THE Forum_Service SHALL also delete all associated Media_File items from storage
5. THE AnalyseService SHALL include Media_File statistics in forum analytics reports

### Requirement 18: Ensure Email Integration with Notifications

**User Story:** As a User, I want email notifications to complement in-app notifications, so that I stay informed through my preferred channel.

#### Acceptance Criteria

1. WHEN the Email_Service sends an email notification, THE NotificationService SHALL also create a corresponding NotificationForum entry
2. WHEN a User reads a NotificationForum in the application, THE Forum_Service SHALL mark the corresponding email notification as acknowledged
3. THE Public_Frontend SHALL display a unified notification center showing both in-app and email notification history
4. WHERE a User has email notifications disabled, THE NotificationService SHALL still create in-app NotificationForum entries
5. THE Email_Service SHALL include a link in all emails to manage notification preferences

### Requirement 19: Enable Chatbot to Access User Context

**User Story:** As a User, I want the chatbot to understand my forum activity, so that it can provide personalized assistance.

#### Acceptance Criteria

1. WHEN a User interacts with the Chatbot_Service, THE Chatbot_Service SHALL access the User's recent MessageForum and ReponseMessage history
2. THE Chatbot_Service SHALL reference the User's BadgeUtilisateur achievements when providing guidance
3. THE Chatbot_Service SHALL suggest relevant forum sections based on the User's participation patterns
4. THE Chatbot_Service SHALL respect User privacy and not share personal information with other Users
5. WHERE a User asks about their own activity, THE Chatbot_Service SHALL provide accurate statistics from the Forum_Service

### Requirement 20: Support Multimedia in Both Frontend Applications

**User Story:** As an Administrator, I want multimedia management features in the Back_Office, so that I can moderate content effectively.

#### Acceptance Criteria

1. THE Back_Office SHALL display all Media_File items with preview capabilities
2. THE Back_Office SHALL provide bulk deletion options for Media_File items
3. THE Back_Office SHALL display storage usage statistics for multimedia content
4. THE Back_Office SHALL allow Administrators to set file size limits per media type
5. WHERE the Public_Frontend displays multimedia content, THE Back_Office SHALL provide equivalent viewing capabilities for moderation purposes
6. THE Back_Office SHALL display upload history with User attribution for all Media_File items
