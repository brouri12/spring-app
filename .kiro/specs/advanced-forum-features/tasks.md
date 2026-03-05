# Implementation Plan: Advanced Forum Features

## Overview

This implementation plan covers three major feature enhancements to the existing Spring Boot forum service:
1. **Multimedia Integration**: Image, video, audio, and document support with transcription and galleries
2. **Email Notification System**: Welcome emails, reply notifications, digests, mentions, summaries, and preference management
3. **AI Chatbot Assistant**: GPT-4 powered forum assistance with knowledge base training and interaction monitoring

The implementation follows a logical order: database schema → backend entities → services → controllers → frontend components → integration → testing. Each task builds incrementally on previous work to ensure continuous validation.

## Technology Stack

- Backend: Spring Boot (Java), MySQL, Spring Mail, Spring @Async, Spring @Scheduled
- Frontend: Angular (TypeScript), RxJS
- External APIs: OpenAI GPT-4, OpenAI Whisper
- Libraries: Thumbnailator, Apache Tika, JUnit QuickCheck

## Tasks


- [ ] 1. Set up database schema and configuration
  - [ ] 1.1 Create database migration scripts for new tables
    - Create SQL migration file with CREATE TABLE statements for media_file, email_preference, email_log, chatbot_conversation, chatbot_log, chatbot_knowledge_base
    - Add indexes for foreign keys and frequently queried columns
    - _Requirements: 1.1, 3.1, 4.1, 7.1, 8.1, 14.1, 15.1, 16.1_
  
  - [ ] 1.2 Configure application properties for new features
    - Add file storage configuration (upload directory, max file sizes)
    - Add SMTP configuration for email service (host, port, username, password)
    - Add OpenAI API configuration (API key, model names for GPT-4 and Whisper)
    - Add async executor configuration for background tasks
    - _Requirements: 1.2, 3.4, 4.2, 7.1, 14.2, 6.1_
  
  - [ ] 1.3 Add Maven dependencies
    - Add Thumbnailator for image processing
    - Add Apache Tika for file type detection
    - Add Spring Boot Mail starter
    - Add Thymeleaf for email templates
    - Add OpenAI Java client library
    - Add JUnit QuickCheck for property-based testing
    - _Requirements: 1.3, 4.6, 7.4, 6.1, 14.2_

- [x] 2. Implement multimedia entities and repositories
  - [x] 2.1 Create MediaFile entity
    - Implement entity with all fields (id, messageId, mediaType, filePath, thumbnailPath, originalFilename, fileSize, mimeType, videoPlatform, videoIdentifier, transcription, transcriptionLanguage, uploadDate, uploaderId, malwareScanned, scanResult)
    - Add JPA annotations and relationships to MessageForum
    - Add @PrePersist lifecycle callback
    - _Requirements: 1.1, 2.1, 3.1, 4.1, 6.3_
  
  - [x] 2.2 Create MediaFileRepository interface
    - Extend JpaRepository with MediaFile entity
    - Add custom query methods: findByMessageId, findByMediaType, findByUploaderId
    - _Requirements: 1.1, 5.1_
  
  - [x] 2.3 Update MessageForum entity with media relationship
    - Add @OneToMany relationship to MediaFile with cascade and orphan removal
    - _Requirements: 17.1, 17.4_
  
  - [ ]* 2.4 Write property test for MediaFile entity
    - **Property 7: Document Metadata Persistence**
    - **Validates: Requirements 4.3**


- [x] 3. Implement email entities and repositories
  - [x] 3.1 Create EmailPreference entity
    - Implement entity with all fields (id, userId, welcomeEmails, replyNotifications, weeklyDigests, mentionAlerts, dailySummaries, unreadReminders, unsubscribeAll, createdDate, updatedDate)
    - Add @PrePersist and @PreUpdate lifecycle callbacks with default values
    - _Requirements: 13.1, 13.2, 13.3_
  
  - [x] 3.2 Create EmailLog entity
    - Implement entity with all fields (id, userId, emailAddress, emailType, subject, sentDate, success, errorMessage, retryCount)
    - Add @PrePersist lifecycle callback
    - _Requirements: 7.6, 16.1_
  
  - [x] 3.3 Create EmailPreferenceRepository interface
    - Extend JpaRepository with EmailPreference entity
    - Add custom query method: findByUserId
    - _Requirements: 13.3_
  
  - [x] 3.4 Create EmailLogRepository interface
    - Extend JpaRepository with EmailLog entity
    - Add custom query methods: findByUserId, findByEmailType, findBySentDateBetween
    - _Requirements: 7.6_
  
  - [ ]* 3.5 Write property test for email preferences
    - **Property 36: Preference Persistence**
    - **Validates: Requirements 13.3**

- [x] 4. Implement chatbot entities and repositories
  - [x] 4.1 Create ChatbotConversation entity
    - Implement entity with all fields (id, userId, role, content, timestamp, sessionId)
    - Add @PrePersist lifecycle callback
    - _Requirements: 14.1, 15.6_
  
  - [x] 4.2 Create ChatbotLog entity
    - Implement entity with all fields (id, userId, userMessage, botResponse, timestamp, responseTimeMs, helpful, flaggedForReview)
    - Add @PrePersist lifecycle callback
    - _Requirements: 16.1, 16.5_
  
  - [x] 4.3 Create ChatbotKnowledgeBase entity
    - Implement entity with all fields (id, messageId, content, isFaq, indexedDate, lastUpdated)
    - Add @PrePersist and @PreUpdate lifecycle callbacks
    - _Requirements: 15.1, 15.3_
  
  - [x] 4.4 Create chatbot repositories
    - Create ChatbotConversationRepository with findByUserIdOrderByTimestampDesc
    - Create ChatbotLogRepository with findByUserId, findByTimestampBetween, findByFlaggedForReview
    - Create ChatbotKnowledgeBaseRepository with findByMessageId, findByIsFaq
    - _Requirements: 14.1, 15.1, 16.1_
  
  - [ ]* 4.5 Write property test for conversation context
    - **Property 46: Conversation Context Limit**
    - **Validates: Requirements 15.6**


- [x] 5. Implement file storage service
  - [x] 5.1 Create FileStorageService
    - Implement storeFile method with unique filename generation using UUID
    - Implement loadFile method to retrieve files as Resource
    - Implement deleteFile method with file existence check
    - Implement validateFileType using Apache Tika for MIME type detection
    - Implement validateFileSize with configurable limits
    - Implement generateUniqueFileName with pattern: {year}/{month}/{uuid}.{extension}
    - _Requirements: 1.1, 1.2, 1.7, 3.3, 3.4, 4.1, 4.2_
  
  - [ ]* 5.2 Write property tests for file storage
    - **Property 2: File Size Validation**
    - **Property 4: Unique File Storage**
    - **Validates: Requirements 1.2, 1.7, 3.4, 4.2**
  
  - [ ]* 5.3 Write unit tests for file storage edge cases
    - Test file storage with special characters in filename
    - Test file deletion when file doesn't exist
    - Test concurrent file uploads with same filename

- [x] 6. Implement transcription service
  - [x] 6.1 Create TranscriptionService with OpenAI Whisper integration
    - Implement @Async transcribeAudio method calling OpenAI Whisper API
    - Implement @Async transcribeVideo method for video URL transcription
    - Add language detection support (French/English)
    - Add error handling with retry logic
    - Return CompletableFuture for async processing
    - _Requirements: 6.1, 6.2, 6.5_
  
  - [ ]* 6.2 Write property test for transcription
    - **Property 12: Transcription Generation**
    - **Property 14: Asynchronous Transcription**
    - **Validates: Requirements 6.1, 6.5**
  
  - [ ]* 6.3 Write unit tests for transcription error handling
    - Test transcription with invalid audio file
    - Test transcription API timeout
    - Test transcription with unsupported language

- [x] 7. Implement multimedia service
  - [x] 7.1 Create MultimediaService for image uploads
    - Implement uploadImage method with format validation (JPEG, PNG, GIF, WebP)
    - Integrate with FileStorageService for file storage
    - Create MediaFile entity and save to repository
    - Generate thumbnail using Thumbnailator (200x200 max dimensions)
    - Add malware scanning placeholder (optional ClamAV integration)
    - Return MediaFileDTO with file URL
    - _Requirements: 1.1, 1.2, 1.3, 1.7, 4.6_
  
  - [x] 7.2 Implement video embedding functionality
    - Implement embedVideo method with YouTube/Vimeo URL parsing
    - Extract video platform and identifier using regex
    - Validate URL domain (youtube.com, youtu.be, vimeo.com)
    - Create MediaFile entity with video metadata
    - Return MediaFileDTO with embed information
    - _Requirements: 2.1, 2.2, 2.4, 2.5_
  
  - [x] 7.3 Implement audio upload functionality
    - Implement uploadAudio method with format validation (MP3, WAV, OGG)
    - Integrate with FileStorageService
    - Trigger async transcription via TranscriptionService
    - Create MediaFile entity with transcription status
    - _Requirements: 3.1, 3.3, 3.4, 6.1_
  
  - [x] 7.4 Implement document upload functionality
    - Implement uploadDocument method with format validation (PDF, ZIP, RAR, DOC, DOCX, XLS, XLSX)
    - Integrate with FileStorageService
    - Store original filename and file size
    - Add malware scanning
    - _Requirements: 4.1, 4.2, 4.3, 4.6_
  
  - [x] 7.5 Implement file retrieval and deletion
    - Implement getFile method returning Resource with proper Content-Type headers
    - Implement getThumbnail method for image thumbnails
    - Implement deleteFile method with cascade to storage
    - _Requirements: 4.5, 5.6_
  
  - [x] 7.6 Implement gallery functionality
    - Implement getGalleryByForum method retrieving all images for a forum
    - Return list of MediaFileDTO with metadata
    - _Requirements: 5.1, 5.4_
  
  - [ ]* 7.7 Write property tests for multimedia service
    - **Property 1: File Format Validation**
    - **Property 3: Thumbnail Generation**
    - **Property 5: Video URL Parsing**
    - **Property 6: Video URL Validation**
    - **Property 8: Document Content-Type Headers**
    - **Property 10: Gallery Image Retrieval**
    - **Validates: Requirements 1.1, 1.3, 1.6, 2.1, 2.2, 2.4, 2.5, 3.3, 4.1, 4.5, 5.1**
  
  - [ ]* 7.8 Write unit tests for multimedia edge cases
    - Test image upload at exact 10MB limit
    - Test video URL with query parameters
    - Test audio transcription failure handling
    - Test document with malicious content


- [-] 8. Implement email template service
  - [-] 8.1 Create Thymeleaf email templates
    - Create welcome-email.html template with navigation instructions and forum links
    - Create reply-notification.html template with reply author, preview, and message link
    - Create mention-alert.html template with mentioning user, preview, and message link
    - Create weekly-digest.html template with top messages and activity counts
    - Create daily-summary.html template with unread messages grouped by category
    - Create unread-reminder.html template with discussion title and reply count
    - Add preference management link to all templates
    - _Requirements: 7.2, 7.3, 8.2, 8.3, 10.3, 10.4, 11.2, 11.3, 12.2, 12.3, 18.5_
  
  - [ ] 8.2 Create EmailTemplateService
    - Implement generateWelcomeEmail method using Thymeleaf
    - Implement generateReplyNotification method
    - Implement generateMentionAlert method
    - Implement generateWeeklyDigest method
    - Implement generateDailySummary method with category grouping
    - Implement generateUnreadReminder method
    - All methods return HTML strings
    - _Requirements: 7.2, 8.2, 10.3, 11.3, 12.2_
  
  - [ ]* 8.3 Write property test for email templates
    - **Property 16: HTML Email Format**
    - **Property 41: Preference Link in Emails**
    - **Validates: Requirements 7.4, 18.5**
  
  - [ ]* 8.4 Write unit tests for email template content
    - Test welcome email contains navigation instructions
    - Test reply notification contains author name and preview
    - Test mention alert contains direct link
    - Test weekly digest contains top 10 messages

- [ ] 9. Implement email service
  - [ ] 9.1 Create EmailService for transactional emails
    - Implement @Async sendWelcomeEmail method with JavaMailSender
    - Implement @Async sendReplyNotification with batching logic (5-minute window)
    - Implement @Async sendMentionAlert with 1-minute delivery target
    - Integrate with EmailTemplateService for HTML content
    - Implement shouldSendEmail method checking EmailPreference
    - Implement logEmailDelivery method creating EmailLog entries
    - Add retry logic with exponential backoff (3 attempts)
    - _Requirements: 7.1, 7.5, 7.6, 8.1, 8.5, 10.1, 10.2_
  
  - [ ] 9.2 Implement digest and summary email methods
    - Implement sendWeeklyDigest method querying top messages from past week
    - Implement sendDailySummary method querying unread messages
    - Implement sendUnreadReminders method with 48-hour threshold and rate limiting
    - Add re-engagement message logic for inactive users
    - Filter based on user preferences
    - _Requirements: 9.1, 9.2, 9.6, 11.1, 11.2, 12.1, 12.4_
  
  - [ ]* 9.3 Write property tests for email service
    - **Property 15: Welcome Email Delivery**
    - **Property 17: Email Retry Logic**
    - **Property 18: Email Delivery Logging**
    - **Property 19: Reply Notification Delivery**
    - **Property 21: Email Preference Enforcement**
    - **Property 22: Reply Batching**
    - **Property 23: Self-Action Filtering**
    - **Property 37: Unsubscribe All**
    - **Validates: Requirements 7.1, 7.5, 7.6, 8.1, 8.4, 8.5, 8.6, 9.5, 10.6, 10.7, 11.5, 12.5, 13.6**
  
  - [ ]* 9.4 Write unit tests for email edge cases
    - Test email sending with invalid SMTP configuration
    - Test reply batching with multiple replies in 5-minute window
    - Test mention alert when user has no email address
    - Test daily summary with no unread content


- [ ] 10. Implement email scheduler service
  - [ ] 10.1 Create EmailSchedulerService with scheduled tasks
    - Implement @Scheduled sendWeeklyDigests method (cron: 0 0 9 * * SUN)
    - Implement @Scheduled sendDailySummaries method (cron: 0 0 18 * * *)
    - Implement @Scheduled sendUnreadReminders method (cron: 0 0 10 * * *)
    - Integrate with EmailService for actual sending
    - Add logging for scheduled task execution
    - _Requirements: 9.1, 11.1, 12.1_
  
  - [ ]* 10.2 Write unit tests for scheduler
    - Test weekly digest scheduling logic
    - Test daily summary scheduling logic
    - Test unread reminder scheduling with rate limiting

- [ ] 11. Implement mention detection service
  - [ ] 11.1 Create MentionDetectionService
    - Implement detectMentions method parsing @username syntax with regex
    - Implement validateUsername method checking user existence
    - Return list of valid mentioned user IDs
    - _Requirements: 10.1, 10.5_
  
  - [ ]* 11.2 Write property test for mention detection
    - **Property 26: Mention Detection**
    - **Property 28: Mention Validation**
    - **Validates: Requirements 10.1, 10.5**
  
  - [ ]* 11.3 Write unit tests for mention edge cases
    - Test mention with special characters
    - Test multiple mentions in single message
    - Test mention of non-existent user

- [ ] 12. Checkpoint - Ensure backend services compile and basic tests pass
  - Ensure all tests pass, ask the user if questions arise.


- [ ] 13. Implement chatbot knowledge base service
  - [ ] 13.1 Create KnowledgeBaseService
    - Implement @Scheduled updateKnowledgeBase method (cron: 0 0 2 * * *)
    - Implement indexMessage method creating ChatbotKnowledgeBase entries
    - Implement removeFromIndex method for deleted messages
    - Implement getFAQMessages method querying messages marked as FAQ
    - Implement buildContextFromForumContent method for query-relevant content retrieval
    - Exclude Signalement-flagged content from indexing
    - _Requirements: 15.1, 15.2, 15.3, 15.5_
  
  - [ ]* 13.2 Write property tests for knowledge base
    - **Property 43: Knowledge Base Indexing**
    - **Property 44: FAQ Prioritization**
    - **Property 45: Flagged Content Exclusion**
    - **Validates: Requirements 15.1, 15.3, 15.5**
  
  - [ ]* 13.3 Write unit tests for knowledge base
    - Test daily knowledge base update
    - Test FAQ message prioritization
    - Test exclusion of flagged content

- [ ] 14. Implement conversation service
  - [ ] 14.1 Create ConversationService
    - Implement addMessage method creating ChatbotConversation entries
    - Implement getRecentMessages method with 10-message limit
    - Implement clearUserConversation method deleting user's conversation history
    - Implement getUserContext method retrieving user's forum activity
    - _Requirements: 14.1, 15.6, 19.1_
  
  - [ ]* 14.2 Write property test for conversation service
    - **Property 46: Conversation Context Limit**
    - **Validates: Requirements 15.6**
  
  - [ ]* 14.3 Write unit tests for conversation service
    - Test conversation history retrieval
    - Test conversation clearing
    - Test user context building

- [ ] 15. Implement chatbot service
  - [ ] 15.1 Create ChatbotService with OpenAI GPT-4 integration
    - Implement processMessage method calling OpenAI API
    - Implement generateContextualResponse with conversation history and knowledge base context
    - Add user context from ConversationService (recent messages, badges, participation)
    - Implement response time tracking
    - Add fallback response for API failures
    - Ensure all responses are in French
    - Add rate limiting (10 messages per minute per user)
    - _Requirements: 14.2, 14.3, 14.4, 14.5, 14.6, 19.1, 19.2, 19.3_
  
  - [ ] 15.2 Implement conversation management methods
    - Implement getConversationHistory method
    - Implement clearConversation method
    - Integrate with ConversationService
    - _Requirements: 14.1_
  
  - [ ] 15.3 Implement logging and feedback methods
    - Implement logInteraction method creating ChatbotLog entries
    - Implement submitFeedback method updating helpful flag
    - Implement flagging logic for unhelpful responses
    - _Requirements: 16.1, 16.5_
  
  - [ ] 15.4 Implement statistics methods
    - Implement getStatistics method calculating total interactions, users, avg response time, satisfaction rate
    - Implement getTopQuestions method from ChatbotLog
    - _Requirements: 16.2, 16.3, 16.4_
  
  - [ ]* 15.5 Write property tests for chatbot service
    - **Property 42: French Language Responses**
    - **Property 47: Interaction Logging**
    - **Property 48: Unhelpful Response Flagging**
    - **Property 54: User Context Access**
    - **Property 55: User Statistics Accuracy**
    - **Validates: Requirements 14.3, 16.1, 16.5, 19.1, 19.2, 19.3, 19.5**
  
  - [ ]* 15.6 Write unit tests for chatbot edge cases
    - Test chatbot with empty message
    - Test chatbot with very long message (>2000 chars)
    - Test chatbot API timeout
    - Test rate limiting enforcement


- [ ] 16. Create DTOs and mappers
  - [ ] 16.1 Create multimedia DTOs
    - Create MediaFileDTO with all fields
    - Create VideoEmbedRequest DTO
    - Create TranscriptionDTO
    - Create MediaFileMapper for entity-to-DTO conversion
    - _Requirements: 1.1, 2.1, 6.3_
  
  - [ ] 16.2 Create email DTOs
    - Create EmailPreferenceDTO
    - Create EmailLogDTO
    - Create EmailPreferenceMapper
    - _Requirements: 13.1, 13.2_
  
  - [ ] 16.3 Create chatbot DTOs
    - Create ChatbotMessageRequest DTO
    - Create ChatbotResponseDTO with suggestedLinks and responseTimeMs
    - Create ChatbotMessageDTO
    - Create ChatbotFeedbackRequest DTO
    - Create ChatbotStatsDTO with topQuestions
    - Create ChatbotLogDTO
    - _Requirements: 14.1, 14.2, 16.2, 16.3, 16.4_

- [ ] 17. Implement multimedia controller
  - [ ] 17.1 Create MultimediaController REST endpoints
    - Implement POST /api/forum/multimedia/upload/image endpoint
    - Implement POST /api/forum/multimedia/upload/audio endpoint
    - Implement POST /api/forum/multimedia/upload/document endpoint
    - Implement POST /api/forum/multimedia/embed/video endpoint
    - Add @RequestParam validation and error handling
    - Return appropriate HTTP status codes (200, 400, 500)
    - _Requirements: 1.1, 2.1, 3.1, 4.1_
  
  - [ ] 17.2 Implement file retrieval endpoints
    - Implement GET /api/forum/multimedia/file/{fileId} endpoint
    - Implement GET /api/forum/multimedia/thumbnail/{fileId} endpoint
    - Set proper Content-Type and Content-Disposition headers
    - _Requirements: 4.5_
  
  - [ ] 17.3 Implement gallery and management endpoints
    - Implement GET /api/forum/multimedia/gallery/{forumId} endpoint
    - Implement DELETE /api/forum/multimedia/file/{fileId} endpoint
    - Implement GET /api/forum/multimedia/transcription/{fileId} endpoint
    - _Requirements: 5.1, 5.6, 6.4_
  
  - [ ]* 17.4 Write integration tests for multimedia controller
    - Test image upload with valid file
    - Test image upload with invalid format
    - Test video embedding with YouTube URL
    - Test gallery retrieval for forum


- [ ] 18. Implement email controller
  - [ ] 18.1 Create EmailController REST endpoints
    - Implement POST /api/forum/email/preferences endpoint
    - Implement GET /api/forum/email/preferences/{userId} endpoint
    - Implement PUT /api/forum/email/preferences/{userId} endpoint
    - Add validation for preference fields
    - _Requirements: 13.1, 13.2, 13.3_
  
  - [ ] 18.2 Implement email testing and history endpoints
    - Implement POST /api/forum/email/test/{userId} endpoint for test emails
    - Implement GET /api/forum/email/history/{userId} endpoint
    - _Requirements: 7.6_
  
  - [ ]* 18.3 Write integration tests for email controller
    - Test preference creation and retrieval
    - Test preference update
    - Test email history retrieval

- [ ] 19. Implement chatbot controller
  - [ ] 19.1 Create ChatbotController REST endpoints
    - Implement POST /api/forum/chatbot/message endpoint with rate limiting
    - Implement GET /api/forum/chatbot/conversation/{userId} endpoint
    - Implement DELETE /api/forum/chatbot/conversation/{userId} endpoint
    - Implement POST /api/forum/chatbot/feedback endpoint
    - Add request validation and error handling
    - _Requirements: 14.1, 14.2, 16.5_
  
  - [ ] 19.2 Implement chatbot admin endpoints
    - Implement GET /api/forum/chatbot/stats endpoint
    - Implement POST /api/forum/chatbot/train endpoint (admin only)
    - Implement GET /api/forum/chatbot/logs endpoint with date filtering
    - Add authorization checks for admin endpoints
    - _Requirements: 15.2, 16.1, 16.2, 16.3, 16.4_
  
  - [ ]* 19.3 Write integration tests for chatbot controller
    - Test message sending and response
    - Test conversation retrieval
    - Test feedback submission
    - Test statistics endpoint

- [ ] 20. Implement global exception handler
  - [ ] 20.1 Create GlobalExceptionHandler
    - Implement @ExceptionHandler for FileValidationException (400)
    - Implement @ExceptionHandler for StorageException (500)
    - Implement @ExceptionHandler for EmailDeliveryException (202)
    - Implement @ExceptionHandler for ChatbotException (fallback response)
    - Implement @ExceptionHandler for ResourceNotFoundException (404)
    - Implement @ExceptionHandler for generic Exception (500)
    - Return ErrorResponse DTO with French error messages
    - _Requirements: 1.6, 2.5, 4.7, 14.6_
  
  - [ ]* 20.2 Write unit tests for exception handler
    - Test file validation error response
    - Test storage error response
    - Test chatbot fallback response

- [ ] 21. Checkpoint - Ensure all backend endpoints work correctly
  - Ensure all tests pass, ask the user if questions arise.


- [ ] 22. Implement integration with existing forum features
  - [ ] 22.1 Update MessageForumService for multimedia integration
    - Modify createMessage method to handle MediaFile attachments
    - Modify deleteMessage method to cascade delete MediaFiles
    - Trigger mention detection on message creation
    - Trigger email notifications for replies
    - _Requirements: 17.1, 17.4, 8.1, 10.1_
  
  - [ ] 22.2 Update SignalementService for multimedia reporting
    - Modify Signalement creation to include MediaFile information
    - Update Signalement display to show media previews
    - _Requirements: 17.2, 17.3_
  
  - [ ] 22.3 Update AnalyseService for multimedia statistics
    - Add MediaFile statistics to analytics reports
    - Include media upload counts, storage usage, popular media types
    - _Requirements: 17.5_
  
  - [ ] 22.4 Update NotificationService for email integration
    - Create NotificationForum entries when emails are sent
    - Implement notification acknowledgment sync with email logs
    - _Requirements: 18.1, 18.2_
  
  - [ ] 22.5 Integrate email notifications with forum events
    - Trigger welcome email on user registration
    - Trigger reply notification on ReponseMessage creation
    - Trigger mention alert on @username detection
    - _Requirements: 7.1, 8.1, 10.2_
  
  - [ ]* 22.6 Write property tests for integration
    - **Property 11: Image Deletion Cascade**
    - **Property 38: Dual Notification Creation**
    - **Property 39: Notification Synchronization**
    - **Property 40: In-App Notification Independence**
    - **Property 50: Media Message Likeability**
    - **Property 51: Signalement Media Information**
    - **Property 52: Message Deletion Cascade**
    - **Property 53: Analytics Media Statistics**
    - **Validates: Requirements 5.6, 17.1, 17.2, 17.4, 17.5, 18.1, 18.2, 18.4**
  
  - [ ]* 22.7 Write integration tests for cross-service functionality
    - Test message creation with media attachments
    - Test message deletion cascading to media files
    - Test signalement with media information
    - Test email notification creating NotificationForum entry


- [ ] 23. Create Angular services for multimedia (Public Frontend)
  - [ ] 23.1 Create MultimediaService in Angular
    - Implement uploadImage method calling POST /api/forum/multimedia/upload/image
    - Implement uploadAudio method calling POST /api/forum/multimedia/upload/audio
    - Implement uploadDocument method calling POST /api/forum/multimedia/upload/document
    - Implement embedVideo method calling POST /api/forum/multimedia/embed/video
    - Implement getFile method for file download
    - Implement getThumbnail method for thumbnail retrieval
    - Implement deleteFile method calling DELETE endpoint
    - Implement getGallery method calling GET /api/forum/multimedia/gallery/{forumId}
    - Implement getTranscription method
    - Use HttpClient with proper headers and error handling
    - _Requirements: 1.1, 2.1, 3.1, 4.1, 5.1, 6.4_
  
  - [ ] 23.2 Create FileValidationService in Angular
    - Implement validateImageFormat method (JPEG, PNG, GIF, WebP)
    - Implement validateAudioFormat method (MP3, WAV, OGG)
    - Implement validateDocumentFormat method (PDF, ZIP, RAR, DOC, DOCX, XLS, XLSX)
    - Implement validateFileSize method with configurable limits
    - Return validation errors in French
    - _Requirements: 1.1, 1.2, 3.3, 3.4, 4.1, 4.2_

- [ ] 24. Create Angular components for multimedia (Public Frontend)
  - [ ] 24.1 Create ImageUploadComponent
    - Implement file input with drag-and-drop support
    - Add client-side validation for format and size
    - Display upload progress bar
    - Show thumbnail preview after upload
    - Display error messages in French
    - _Requirements: 1.1, 1.2, 1.4, 1.6_
  
  - [ ] 24.2 Create VideoEmbedComponent
    - Implement URL input field with validation
    - Display embedded video player for YouTube/Vimeo
    - Show video title and thumbnail
    - Display error messages for invalid URLs
    - _Requirements: 2.1, 2.3, 2.5, 2.6_
  
  - [ ] 24.3 Create AudioRecorderComponent
    - Implement audio recording interface with start/stop buttons
    - Request microphone permissions
    - Display recording duration
    - Implement audio player with play, pause, volume controls
    - Show audio duration in minutes:seconds format
    - Display permission error in French
    - _Requirements: 3.1, 3.2, 3.5, 3.6, 3.7_
  
  - [ ] 24.4 Create DocumentUploadComponent
    - Implement file input for document uploads
    - Display filename and file size
    - Show upload progress
    - Provide download link after upload
    - Display malware scan status
    - _Requirements: 4.1, 4.4, 4.6, 4.7_
  
  - [ ] 24.5 Create GalleryComponent
    - Display images in grid layout with thumbnails
    - Implement lightbox view with navigation controls
    - Show image metadata (uploader, date)
    - Add pagination for large galleries
    - _Requirements: 5.1, 5.2, 5.3, 5.4_
  
  - [ ] 24.6 Create TranscriptionViewerComponent
    - Display toggle button to show/hide transcription
    - Show transcription text below media player
    - Handle missing transcriptions gracefully
    - _Requirements: 6.4_


- [ ] 25. Create Angular services for email (Public Frontend)
  - [ ] 25.1 Create EmailPreferenceService in Angular
    - Implement getPreferences method calling GET /api/forum/email/preferences/{userId}
    - Implement updatePreferences method calling PUT endpoint
    - Implement sendTestEmail method calling POST /api/forum/email/test/{userId}
    - Implement getEmailHistory method
    - Use HttpClient with error handling
    - _Requirements: 13.1, 13.2, 13.3_

- [ ] 26. Create Angular components for email preferences (Public Frontend)
  - [ ] 26.1 Create EmailPreferencesComponent
    - Display toggles for all email preference types (welcome, reply, digest, mention, summary, reminder)
    - Display preference descriptions in French
    - Implement "Unsubscribe from all" toggle
    - Add save button with loading state
    - Show success/error messages
    - _Requirements: 13.1, 13.2, 13.5, 13.6_
  
  - [ ] 26.2 Create EmailHistoryComponent
    - Display table of sent emails with type, date, status
    - Add filtering by email type
    - Show error messages for failed emails
    - _Requirements: 7.6_

- [ ] 27. Create Angular services for chatbot (Public Frontend)
  - [ ] 27.1 Create ChatbotService in Angular
    - Implement sendMessage method calling POST /api/forum/chatbot/message
    - Implement getConversation method calling GET endpoint
    - Implement clearConversation method calling DELETE endpoint
    - Implement submitFeedback method calling POST /api/forum/chatbot/feedback
    - Handle rate limiting errors (429)
    - Use HttpClient with error handling
    - _Requirements: 14.1, 14.2, 16.5_

- [ ] 28. Create Angular components for chatbot (Public Frontend)
  - [ ] 28.1 Create ChatbotWidgetComponent
    - Display chatbot icon in bottom-right corner
    - Implement expandable chat window
    - Show conversation history with user/assistant messages
    - Add message input field with send button
    - Display typing indicator while waiting for response
    - Show suggested links in responses
    - Add feedback buttons (helpful/unhelpful) for each response
    - Display error messages for API failures
    - Implement rate limiting feedback
    - _Requirements: 14.1, 14.2, 14.3, 14.5, 14.6, 14.7, 16.5_
  
  - [ ] 28.2 Add chatbot widget to all forum pages
    - Import ChatbotWidgetComponent in app module
    - Add component selector to main layout template
    - Ensure widget appears on all routes
    - _Requirements: 14.1, 14.7_


- [ ] 29. Integrate multimedia components with message creation (Public Frontend)
  - [ ] 29.1 Update MessageCreationComponent
    - Add tabs for text, image, video, audio, document
    - Integrate ImageUploadComponent
    - Integrate VideoEmbedComponent
    - Integrate AudioRecorderComponent
    - Integrate DocumentUploadComponent
    - Allow multiple media attachments per message
    - Display attached media previews before submission
    - _Requirements: 1.1, 2.1, 3.1, 4.1_
  
  - [ ] 29.2 Update MessageDisplayComponent
    - Display image thumbnails with click-to-expand
    - Display embedded video players
    - Display audio players with controls
    - Display document download links
    - Show transcription toggle for audio/video
    - Integrate TranscriptionViewerComponent
    - _Requirements: 1.4, 1.5, 2.3, 3.5, 4.4, 6.4_
  
  - [ ] 29.3 Add gallery view to forum pages
    - Add "View Gallery" button to forum header
    - Integrate GalleryComponent
    - Filter gallery by forum ID
    - _Requirements: 5.1, 5.2_

- [ ] 30. Create Back Office components for multimedia management
  - [ ] 30.1 Create MediaManagementComponent (Back Office)
    - Display table of all MediaFile entries with previews
    - Add filtering by media type, uploader, date
    - Implement bulk selection with checkboxes
    - Add bulk delete button
    - Show storage usage statistics
    - Display upload history with user attribution
    - _Requirements: 20.1, 20.2, 20.3, 20.6_
  
  - [ ] 30.2 Create MediaConfigurationComponent (Back Office)
    - Display form for file size limits per media type
    - Add save button with validation
    - Show current configuration values
    - _Requirements: 20.4_
  
  - [ ] 30.3 Update SignalementReviewComponent (Back Office)
    - Display MediaFile previews in signalement details
    - Add option to delete media from signalement review
    - _Requirements: 17.2, 17.3, 5.5_


- [ ] 31. Create Back Office components for chatbot management
  - [ ] 31.1 Create ChatbotDashboardComponent (Back Office)
    - Display usage statistics (total interactions, users, avg response time, satisfaction rate)
    - Show chart of interactions over time
    - Display top 10 frequently asked questions
    - Add date range filter
    - _Requirements: 16.2, 16.3, 16.4_
  
  - [ ] 31.2 Create ChatbotLogsComponent (Back Office)
    - Display table of chatbot interactions with user, message, response, timestamp
    - Add filtering by date, user, flagged status
    - Implement export to CSV functionality
    - Show flagged interactions prominently
    - Add pagination
    - _Requirements: 16.1, 16.5, 16.6_
  
  - [ ] 31.3 Create ChatbotTrainingComponent (Back Office)
    - Display interface to review and approve training data
    - Show MessageForum entries indexed in knowledge base
    - Add toggle to mark messages as FAQ
    - Implement manual trigger for knowledge base update
    - Show last update timestamp
    - _Requirements: 15.2, 15.3, 15.4_

- [ ] 32. Create Back Office services for chatbot
  - [ ] 32.1 Create ChatbotAdminService in Angular (Back Office)
    - Implement getStatistics method calling GET /api/forum/chatbot/stats
    - Implement getLogs method with date filtering
    - Implement exportLogs method for CSV download
    - Implement triggerTraining method calling POST /api/forum/chatbot/train
    - Use HttpClient with admin authentication
    - _Requirements: 15.2, 16.1, 16.2, 16.6_

- [ ] 33. Checkpoint - Ensure all frontend components render correctly
  - Ensure all tests pass, ask the user if questions arise.


- [ ] 34. Implement remaining property-based tests
  - [ ]* 34.1 Write property tests for email content
    - **Property 20: Reply Notification Content**
    - **Property 24: Weekly Digest Content**
    - **Property 25: Re-engagement Message**
    - **Property 27: Mention Alert Content**
    - **Property 29: Daily Summary Filtering**
    - **Property 30: Daily Summary Grouping**
    - **Property 31: Daily Summary Subject**
    - **Property 32: Empty Summary Suppression**
    - **Property 33: Reminder Content**
    - **Property 34: Reminder Rate Limiting**
    - **Property 35: Closed Discussion Filtering**
    - **Validates: Requirements 8.2, 8.3, 9.2, 9.3, 9.6, 10.3, 10.4, 11.2, 11.3, 11.4, 11.6, 12.2, 12.3, 12.4, 12.6**
  
  - [ ]* 34.2 Write property tests for multimedia edge cases
    - **Property 9: Malware Scanning**
    - **Property 13: Transcription Persistence**
    - **Validates: Requirements 4.6, 6.3**
  
  - [ ]* 34.3 Write property test for chatbot export
    - **Property 49: Conversation Log Export**
    - **Validates: Requirements 16.6**
  
  - [ ]* 34.4 Write property test for file size configuration
    - **Property 56: File Size Limit Configuration**
    - **Validates: Requirements 20.4**

- [ ] 35. Add comprehensive error handling and validation
  - [ ] 35.1 Add frontend validation for all forms
    - Validate file formats and sizes before upload
    - Validate email preference inputs
    - Validate chatbot message length
    - Display French error messages
    - _Requirements: 1.6, 2.5, 3.7, 4.7_
  
  - [ ] 35.2 Add loading states and progress indicators
    - Show upload progress for files
    - Show loading spinner for chatbot responses
    - Show loading state for email preference saves
    - _Requirements: 1.1, 14.2_
  
  - [ ] 35.3 Add user feedback for async operations
    - Show success toast for file uploads
    - Show success toast for preference updates
    - Show error toast for failed operations
    - _Requirements: 1.1, 13.3_


- [ ] 36. Configure and test email delivery
  - [ ] 36.1 Configure SMTP settings in application.properties
    - Add spring.mail.host, port, username, password
    - Configure spring.mail.properties for TLS/SSL
    - Add email sender address and display name
    - _Requirements: 7.1_
  
  - [ ] 36.2 Test email delivery with real SMTP server
    - Send test welcome email
    - Send test reply notification
    - Send test mention alert
    - Verify HTML formatting in email clients (Gmail, Outlook)
    - Verify links work correctly
    - _Requirements: 7.1, 7.4, 8.1, 10.2_
  
  - [ ] 36.3 Test scheduled email tasks
    - Manually trigger weekly digest and verify content
    - Manually trigger daily summary and verify content
    - Manually trigger unread reminders and verify rate limiting
    - _Requirements: 9.1, 11.1, 12.1, 12.4_

- [ ] 37. Configure and test OpenAI API integration
  - [ ] 37.1 Configure OpenAI API settings in application.properties
    - Add openai.api.key
    - Add openai.model.gpt4 (model name)
    - Add openai.model.whisper (model name)
    - Add timeout and retry configuration
    - _Requirements: 14.2, 6.1_
  
  - [ ] 37.2 Test chatbot with real OpenAI API
    - Send test messages and verify French responses
    - Test conversation context maintenance
    - Test knowledge base integration
    - Test user context access
    - Verify response time < 3 seconds
    - _Requirements: 14.2, 14.3, 15.6, 19.1_
  
  - [ ] 37.3 Test transcription with real Whisper API
    - Upload test audio file and verify transcription
    - Test French and English language detection
    - Verify async processing
    - Test error handling for invalid files
    - _Requirements: 6.1, 6.2, 6.5, 6.6_


- [ ] 38. Perform end-to-end integration testing
  - [ ] 38.1 Test complete multimedia workflow
    - Create message with image attachment in Public Frontend
    - Verify image appears in message display
    - View image in gallery
    - Create signalement for message with media
    - Delete message and verify media files removed from storage
    - _Requirements: 1.1, 1.4, 5.1, 17.2, 17.4_
  
  - [ ] 38.2 Test complete email notification workflow
    - Register new user and verify welcome email received
    - Create reply and verify reply notification sent
    - Mention user with @username and verify mention alert sent
    - Update email preferences and verify notifications respect preferences
    - Verify NotificationForum entries created for emails
    - _Requirements: 7.1, 8.1, 10.1, 13.3, 18.1_
  
  - [ ] 38.3 Test complete chatbot workflow
    - Open chatbot widget and send message
    - Verify French response received
    - Continue conversation and verify context maintained
    - Submit feedback and verify interaction logged
    - View chatbot logs in Back Office
    - Mark message as FAQ and verify chatbot prioritizes it
    - _Requirements: 14.1, 14.3, 15.6, 16.1, 16.5, 15.3_
  
  - [ ] 38.4 Test cross-feature integration
    - Upload audio file and verify transcription generated
    - Like message with media attachments
    - View analytics with media statistics
    - Test chatbot accessing user's forum activity
    - _Requirements: 6.1, 17.1, 17.5, 19.1_

- [ ] 39. Perform security and performance testing
  - [ ] 39.1 Test file upload security
    - Attempt to upload malicious file and verify rejection
    - Attempt to upload oversized file and verify rejection
    - Attempt to upload invalid format and verify rejection
    - Test path traversal attack prevention
    - _Requirements: 1.2, 1.6, 4.6_
  
  - [ ] 39.2 Test email security and privacy
    - Verify email addresses not exposed in logs
    - Test unsubscribe functionality
    - Verify preference enforcement
    - Test rate limiting for email sending
    - _Requirements: 13.6, 8.4_
  
  - [ ] 39.3 Test chatbot security and rate limiting
    - Test rate limiting (10 messages per minute)
    - Verify user privacy in responses
    - Test injection attack prevention
    - Verify flagged content excluded from training
    - _Requirements: 15.5, 19.4_
  
  - [ ] 39.4 Perform load testing
    - Simulate 100 concurrent file uploads
    - Send 1000 test emails and measure delivery rate
    - Send 100 concurrent chatbot messages and measure response times
    - Verify system stability under load
    - _Requirements: 1.1, 7.1, 14.2_

