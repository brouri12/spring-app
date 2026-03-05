# Design Document - Advanced Forum Features

## Overview

This design document specifies the technical architecture for three major feature enhancements to the existing Spring Boot forum service: multimedia integration, email notification system, and AI-powered chatbot assistant. These features will be implemented as modular components that integrate seamlessly with the existing forum infrastructure while maintaining separation of concerns and scalability.

### System Context

The existing system consists of:
- **Backend**: Spring Boot microservice (forum-service) on port 8082 with MySQL database
- **Frontend**: Angular public application (port 65198) and back-office administration (port 4201)
- **Existing Entities**: MessageForum, ReponseMessage, LikeMessage, Signalement, NotificationForum, BadgeUtilisateur, Forum

### Design Goals

1. **Modularity**: Each feature (multimedia, email, chatbot) should be independently deployable and maintainable
2. **Scalability**: Support asynchronous processing for resource-intensive operations (transcription, email sending, AI inference)
3. **Integration**: Seamlessly integrate with existing forum entities and workflows
4. **Performance**: Minimize impact on existing forum operations through efficient storage and caching strategies
5. **Security**: Implement file validation, malware scanning, and user privacy protection
6. **Maintainability**: Follow Spring Boot best practices with clear separation between controllers, services, and repositories


## Architecture

### High-Level Architecture

The system will adopt a layered architecture with three new major components:

```
┌─────────────────────────────────────────────────────────────┐
│                    Angular Frontends                         │
│  ┌──────────────────────┐    ┌──────────────────────────┐  │
│  │  Public Frontend     │    │    Back Office           │  │
│  │  (Port 65198)        │    │    (Port 4201)           │  │
│  └──────────────────────┘    └──────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│              Forum Service (Port 8082)                       │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              REST Controllers                         │  │
│  │  ForumRestAPI │ MultimediaController │               │  │
│  │  EmailController │ ChatbotController                 │  │
│  └──────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              Service Layer                            │  │
│  │  MessageForumService │ MultimediaService             │  │
│  │  EmailService │ ChatbotService                       │  │
│  └──────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              Repository Layer                         │  │
│  │  MessageForumRepository │ MediaFileRepository        │  │
│  │  EmailPreferenceRepository │ ChatbotLogRepository    │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    External Services                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │  MySQL   │  │  File    │  │  SMTP    │  │  OpenAI  │   │
│  │  Database│  │  Storage │  │  Server  │  │  API     │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### Component Responsibilities

#### 1. Multimedia Manager Component
- **Purpose**: Handle file uploads, storage, validation, and retrieval for images, videos, audio, and documents
- **Key Services**: MultimediaService, FileStorageService, TranscriptionService, ThumbnailService
- **Storage Strategy**: Local file system with database metadata tracking
- **File Path Pattern**: `/uploads/{media-type}/{year}/{month}/{uuid}.{extension}`

#### 2. Email Notification Component
- **Purpose**: Send transactional and digest emails based on forum events and user preferences
- **Key Services**: EmailService, EmailTemplateService, EmailSchedulerService
- **Email Provider**: JavaMailSender with SMTP configuration
- **Scheduling**: Spring @Scheduled for digest and summary emails
- **Queue Strategy**: Asynchronous processing with @Async for non-blocking email delivery

#### 3. AI Chatbot Component
- **Purpose**: Provide intelligent forum assistance using OpenAI GPT-4 API
- **Key Services**: ChatbotService, KnowledgeBaseService, ConversationService
- **AI Provider**: OpenAI API (GPT-4 model)
- **Context Management**: Session-based conversation history (10 message limit)
- **Training Data**: Indexed MessageForum content with daily updates

### Technology Stack

| Component | Technology | Justification |
|-----------|-----------|---------------|
| File Storage | Local File System | Simple, cost-effective for initial deployment; can migrate to S3/MinIO later |
| Image Processing | Thumbnailator library | Lightweight Java library for thumbnail generation |
| Transcription | OpenAI Whisper API | High-quality multilingual transcription (French/English) |
| Email Sending | Spring Boot Mail + JavaMailSender | Native Spring integration, reliable SMTP support |
| Email Templates | Thymeleaf | Consistent with Spring Boot ecosystem, HTML template support |
| Email Scheduling | Spring @Scheduled | Built-in scheduling, no external dependencies |
| AI Chatbot | OpenAI GPT-4 API | State-of-the-art language model, French language support |
| Async Processing | Spring @Async | Native Spring async support for non-blocking operations |
| File Validation | Apache Tika | Content-type detection and validation |
| Malware Scanning | ClamAV (optional) | Industry-standard open-source antivirus |

### Integration Points

1. **MessageForum Integration**: New MediaFile entity with @OneToMany relationship to MessageForum
2. **NotificationForum Integration**: Email notifications create corresponding NotificationForum entries
3. **Existing Services**: MultimediaService integrates with MessageForumService, SignalementService, and AnalyseService
4. **User Context**: Chatbot accesses BadgeUtilisateur, MessageForum, and ReponseMessage for personalization


## Components and Interfaces

### 1. Multimedia Management

#### REST Endpoints

```
POST   /api/forum/multimedia/upload/image
POST   /api/forum/multimedia/upload/audio
POST   /api/forum/multimedia/upload/document
POST   /api/forum/multimedia/embed/video
GET    /api/forum/multimedia/file/{fileId}
GET    /api/forum/multimedia/thumbnail/{fileId}
DELETE /api/forum/multimedia/file/{fileId}
GET    /api/forum/multimedia/gallery/{forumId}
GET    /api/forum/multimedia/transcription/{fileId}
```

#### MultimediaController

```java
@RestController
@RequestMapping("/api/forum/multimedia")
public class MultimediaController {
    
    @PostMapping("/upload/image")
    public ResponseEntity<MediaFileDTO> uploadImage(
        @RequestParam("file") MultipartFile file,
        @RequestParam("messageId") Long messageId
    );
    
    @PostMapping("/upload/audio")
    public ResponseEntity<MediaFileDTO> uploadAudio(
        @RequestParam("file") MultipartFile file,
        @RequestParam("messageId") Long messageId
    );
    
    @PostMapping("/upload/document")
    public ResponseEntity<MediaFileDTO> uploadDocument(
        @RequestParam("file") MultipartFile file,
        @RequestParam("messageId") Long messageId
    );
    
    @PostMapping("/embed/video")
    public ResponseEntity<MediaFileDTO> embedVideo(
        @RequestBody VideoEmbedRequest request
    );
    
    @GetMapping("/file/{fileId}")
    public ResponseEntity<Resource> downloadFile(@PathVariable Long fileId);
    
    @GetMapping("/thumbnail/{fileId}")
    public ResponseEntity<Resource> getThumbnail(@PathVariable Long fileId);
    
    @DeleteMapping("/file/{fileId}")
    public ResponseEntity<Void> deleteFile(@PathVariable Long fileId);
    
    @GetMapping("/gallery/{forumId}")
    public ResponseEntity<List<MediaFileDTO>> getGallery(@PathVariable Long forumId);
    
    @GetMapping("/transcription/{fileId}")
    public ResponseEntity<TranscriptionDTO> getTranscription(@PathVariable Long fileId);
}
```

#### MultimediaService Interface

```java
@Service
public class MultimediaService {
    
    MediaFileDTO uploadImage(MultipartFile file, Long messageId);
    MediaFileDTO uploadAudio(MultipartFile file, Long messageId);
    MediaFileDTO uploadDocument(MultipartFile file, Long messageId);
    MediaFileDTO embedVideo(String videoUrl, String platform, Long messageId);
    Resource getFile(Long fileId);
    Resource getThumbnail(Long fileId);
    void deleteFile(Long fileId);
    List<MediaFileDTO> getGalleryByForum(Long forumId);
    TranscriptionDTO getTranscription(Long fileId);
    void generateThumbnail(Long fileId);
    void requestTranscription(Long fileId);
}
```

#### FileStorageService Interface

```java
@Service
public class FileStorageService {
    
    String storeFile(MultipartFile file, String mediaType);
    Resource loadFile(String filePath);
    void deleteFile(String filePath);
    boolean validateFileType(MultipartFile file, List<String> allowedTypes);
    boolean validateFileSize(MultipartFile file, long maxSizeBytes);
    String generateUniqueFileName(String originalFilename);
}
```

#### TranscriptionService Interface

```java
@Service
public class TranscriptionService {
    
    @Async
    CompletableFuture<String> transcribeAudio(String filePath, String language);
    
    @Async
    CompletableFuture<String> transcribeVideo(String videoUrl, String language);
}
```

### 2. Email Notification System

#### REST Endpoints

```
POST   /api/forum/email/preferences
GET    /api/forum/email/preferences/{userId}
PUT    /api/forum/email/preferences/{userId}
POST   /api/forum/email/test/{userId}
GET    /api/forum/email/history/{userId}
```

#### EmailController

```java
@RestController
@RequestMapping("/api/forum/email")
public class EmailController {
    
    @PostMapping("/preferences")
    public ResponseEntity<EmailPreferenceDTO> createPreferences(
        @RequestBody EmailPreferenceDTO preferences
    );
    
    @GetMapping("/preferences/{userId}")
    public ResponseEntity<EmailPreferenceDTO> getPreferences(@PathVariable Long userId);
    
    @PutMapping("/preferences/{userId}")
    public ResponseEntity<EmailPreferenceDTO> updatePreferences(
        @PathVariable Long userId,
        @RequestBody EmailPreferenceDTO preferences
    );
    
    @PostMapping("/test/{userId}")
    public ResponseEntity<Void> sendTestEmail(@PathVariable Long userId);
    
    @GetMapping("/history/{userId}")
    public ResponseEntity<List<EmailLogDTO>> getEmailHistory(@PathVariable Long userId);
}
```

#### EmailService Interface

```java
@Service
public class EmailService {
    
    @Async
    void sendWelcomeEmail(Long userId, String email, String username);
    
    @Async
    void sendReplyNotification(Long userId, String email, ReponseMessage reply);
    
    @Async
    void sendMentionAlert(Long userId, String email, MessageForum message);
    
    void sendWeeklyDigest();
    void sendDailySummary();
    void sendUnreadReminders();
    
    boolean shouldSendEmail(Long userId, String emailType);
    void logEmailDelivery(Long userId, String emailType, boolean success);
}
```

#### EmailTemplateService Interface

```java
@Service
public class EmailTemplateService {
    
    String generateWelcomeEmail(String username);
    String generateReplyNotification(String username, String replyAuthor, String replyPreview);
    String generateMentionAlert(String username, String mentionAuthor, String messagePreview);
    String generateWeeklyDigest(List<MessageForum> topMessages, int newMessageCount);
    String generateDailySummary(List<MessageForum> unreadMessages);
    String generateUnreadReminder(String discussionTitle, int newReplyCount);
}
```

#### EmailSchedulerService

```java
@Service
public class EmailSchedulerService {
    
    @Scheduled(cron = "0 0 9 * * SUN")
    void sendWeeklyDigests();
    
    @Scheduled(cron = "0 0 18 * * *")
    void sendDailySummaries();
    
    @Scheduled(cron = "0 0 10 * * *")
    void sendUnreadReminders();
}
```

### 3. AI Chatbot Assistant

#### REST Endpoints

```
POST   /api/forum/chatbot/message
GET    /api/forum/chatbot/conversation/{userId}
DELETE /api/forum/chatbot/conversation/{userId}
POST   /api/forum/chatbot/feedback
GET    /api/forum/chatbot/stats
POST   /api/forum/chatbot/train
GET    /api/forum/chatbot/logs
```

#### ChatbotController

```java
@RestController
@RequestMapping("/api/forum/chatbot")
public class ChatbotController {
    
    @PostMapping("/message")
    public ResponseEntity<ChatbotResponseDTO> sendMessage(
        @RequestBody ChatbotMessageRequest request
    );
    
    @GetMapping("/conversation/{userId}")
    public ResponseEntity<List<ChatbotMessageDTO>> getConversation(
        @PathVariable Long userId
    );
    
    @DeleteMapping("/conversation/{userId}")
    public ResponseEntity<Void> clearConversation(@PathVariable Long userId);
    
    @PostMapping("/feedback")
    public ResponseEntity<Void> submitFeedback(
        @RequestBody ChatbotFeedbackRequest request
    );
    
    @GetMapping("/stats")
    public ResponseEntity<ChatbotStatsDTO> getStatistics();
    
    @PostMapping("/train")
    public ResponseEntity<Void> triggerTraining();
    
    @GetMapping("/logs")
    public ResponseEntity<List<ChatbotLogDTO>> getLogs(
        @RequestParam(required = false) LocalDateTime startDate,
        @RequestParam(required = false) LocalDateTime endDate
    );
}
```

#### ChatbotService Interface

```java
@Service
public class ChatbotService {
    
    ChatbotResponseDTO processMessage(Long userId, String message);
    List<ChatbotMessageDTO> getConversationHistory(Long userId);
    void clearConversation(Long userId);
    void logInteraction(Long userId, String userMessage, String botResponse, boolean helpful);
    ChatbotStatsDTO getStatistics();
    String generateContextualResponse(Long userId, String message, List<String> conversationHistory);
}
```

#### KnowledgeBaseService Interface

```java
@Service
public class KnowledgeBaseService {
    
    @Scheduled(cron = "0 0 2 * * *")
    void updateKnowledgeBase();
    
    List<MessageForum> getFAQMessages();
    String buildContextFromForumContent(String query);
    void indexMessage(MessageForum message);
    void removeFromIndex(Long messageId);
}
```

#### ConversationService Interface

```java
@Service
public class ConversationService {
    
    void addMessage(Long userId, String role, String content);
    List<ChatbotMessageDTO> getRecentMessages(Long userId, int limit);
    void clearUserConversation(Long userId);
    String getUserContext(Long userId);
}
```


## Data Models

### New Entities

#### MediaFile Entity

```java
@Entity
@Table(name = "media_file")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MediaFile {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotNull
    @Column(name = "message_id")
    private Long messageId;
    
    @NotBlank
    @Column(name = "media_type")
    private String mediaType; // IMAGE, VIDEO, AUDIO, DOCUMENT
    
    @NotBlank
    @Column(name = "file_path")
    private String filePath;
    
    @Column(name = "thumbnail_path")
    private String thumbnailPath;
    
    @NotBlank
    @Column(name = "original_filename")
    private String originalFilename;
    
    @NotNull
    @Column(name = "file_size")
    private Long fileSize;
    
    @Column(name = "mime_type")
    private String mimeType;
    
    @Column(name = "video_platform")
    private String videoPlatform; // YOUTUBE, VIMEO
    
    @Column(name = "video_identifier")
    private String videoIdentifier;
    
    @Column(name = "transcription", length = 10000)
    private String transcription;
    
    @Column(name = "transcription_language")
    private String transcriptionLanguage;
    
    @NotNull
    @Column(name = "upload_date")
    private LocalDateTime uploadDate;
    
    @NotNull
    @Column(name = "uploader_id")
    private Long uploaderId;
    
    @Column(name = "malware_scanned")
    private Boolean malwareScanned;
    
    @Column(name = "scan_result")
    private String scanResult;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "message_id", insertable = false, updatable = false)
    private MessageForum messageForum;
    
    @PrePersist
    protected void onCreate() {
        uploadDate = LocalDateTime.now();
        if (malwareScanned == null) {
            malwareScanned = false;
        }
    }
}
```

#### EmailPreference Entity

```java
@Entity
@Table(name = "email_preference")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class EmailPreference {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotNull
    @Column(name = "user_id", unique = true)
    private Long userId;
    
    @NotNull
    @Column(name = "welcome_emails")
    private Boolean welcomeEmails;
    
    @NotNull
    @Column(name = "reply_notifications")
    private Boolean replyNotifications;
    
    @NotNull
    @Column(name = "weekly_digests")
    private Boolean weeklyDigests;
    
    @NotNull
    @Column(name = "mention_alerts")
    private Boolean mentionAlerts;
    
    @NotNull
    @Column(name = "daily_summaries")
    private Boolean dailySummaries;
    
    @NotNull
    @Column(name = "unread_reminders")
    private Boolean unreadReminders;
    
    @NotNull
    @Column(name = "unsubscribe_all")
    private Boolean unsubscribeAll;
    
    @Column(name = "created_date")
    private LocalDateTime createdDate;
    
    @Column(name = "updated_date")
    private LocalDateTime updatedDate;
    
    @PrePersist
    protected void onCreate() {
        createdDate = LocalDateTime.now();
        if (welcomeEmails == null) welcomeEmails = true;
        if (replyNotifications == null) replyNotifications = true;
        if (weeklyDigests == null) weeklyDigests = true;
        if (mentionAlerts == null) mentionAlerts = true;
        if (dailySummaries == null) dailySummaries = false;
        if (unreadReminders == null) unreadReminders = true;
        if (unsubscribeAll == null) unsubscribeAll = false;
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedDate = LocalDateTime.now();
    }
}
```

#### EmailLog Entity

```java
@Entity
@Table(name = "email_log")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class EmailLog {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotNull
    @Column(name = "user_id")
    private Long userId;
    
    @NotBlank
    @Column(name = "email_address")
    private String emailAddress;
    
    @NotBlank
    @Column(name = "email_type")
    private String emailType; // WELCOME, REPLY, MENTION, DIGEST, SUMMARY, REMINDER
    
    @Column(name = "subject")
    private String subject;
    
    @NotNull
    @Column(name = "sent_date")
    private LocalDateTime sentDate;
    
    @NotNull
    @Column(name = "success")
    private Boolean success;
    
    @Column(name = "error_message", length = 1000)
    private String errorMessage;
    
    @Column(name = "retry_count")
    private Integer retryCount;
    
    @PrePersist
    protected void onCreate() {
        sentDate = LocalDateTime.now();
        if (retryCount == null) {
            retryCount = 0;
        }
    }
}
```

#### ChatbotConversation Entity

```java
@Entity
@Table(name = "chatbot_conversation")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ChatbotConversation {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotNull
    @Column(name = "user_id")
    private Long userId;
    
    @NotBlank
    @Column(name = "role")
    private String role; // USER, ASSISTANT
    
    @NotBlank
    @Column(name = "content", length = 2000)
    private String content;
    
    @NotNull
    @Column(name = "timestamp")
    private LocalDateTime timestamp;
    
    @Column(name = "session_id")
    private String sessionId;
    
    @PrePersist
    protected void onCreate() {
        timestamp = LocalDateTime.now();
    }
}
```

#### ChatbotLog Entity

```java
@Entity
@Table(name = "chatbot_log")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ChatbotLog {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotNull
    @Column(name = "user_id")
    private Long userId;
    
    @NotBlank
    @Column(name = "user_message", length = 2000)
    private String userMessage;
    
    @NotBlank
    @Column(name = "bot_response", length = 2000)
    private String botResponse;
    
    @NotNull
    @Column(name = "timestamp")
    private LocalDateTime timestamp;
    
    @Column(name = "response_time_ms")
    private Long responseTimeMs;
    
    @Column(name = "helpful")
    private Boolean helpful;
    
    @Column(name = "flagged_for_review")
    private Boolean flaggedForReview;
    
    @PrePersist
    protected void onCreate() {
        timestamp = LocalDateTime.now();
        if (flaggedForReview == null) {
            flaggedForReview = false;
        }
    }
}
```

#### ChatbotKnowledgeBase Entity

```java
@Entity
@Table(name = "chatbot_knowledge_base")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ChatbotKnowledgeBase {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotNull
    @Column(name = "message_id")
    private Long messageId;
    
    @NotBlank
    @Column(name = "content", length = 5000)
    private String content;
    
    @Column(name = "is_faq")
    private Boolean isFaq;
    
    @NotNull
    @Column(name = "indexed_date")
    private LocalDateTime indexedDate;
    
    @Column(name = "last_updated")
    private LocalDateTime lastUpdated;
    
    @PrePersist
    protected void onCreate() {
        indexedDate = LocalDateTime.now();
        if (isFaq == null) {
            isFaq = false;
        }
    }
    
    @PreUpdate
    protected void onUpdate() {
        lastUpdated = LocalDateTime.now();
    }
}
```

### Modified Entities

#### MessageForum (Extended)

Add relationship to MediaFile:

```java
@OneToMany(mappedBy = "messageForum", cascade = CascadeType.ALL, orphanRemoval = true)
private List<MediaFile> mediaFiles = new ArrayList<>();
```

### Database Schema

```sql
-- MediaFile table
CREATE TABLE media_file (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    message_id BIGINT NOT NULL,
    media_type VARCHAR(20) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    thumbnail_path VARCHAR(500),
    original_filename VARCHAR(255) NOT NULL,
    file_size BIGINT NOT NULL,
    mime_type VARCHAR(100),
    video_platform VARCHAR(20),
    video_identifier VARCHAR(100),
    transcription TEXT,
    transcription_language VARCHAR(10),
    upload_date DATETIME NOT NULL,
    uploader_id BIGINT NOT NULL,
    malware_scanned BOOLEAN DEFAULT FALSE,
    scan_result VARCHAR(50),
    FOREIGN KEY (message_id) REFERENCES message_forum(id) ON DELETE CASCADE,
    INDEX idx_message_id (message_id),
    INDEX idx_media_type (media_type),
    INDEX idx_uploader_id (uploader_id)
);

-- EmailPreference table
CREATE TABLE email_preference (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL UNIQUE,
    welcome_emails BOOLEAN DEFAULT TRUE,
    reply_notifications BOOLEAN DEFAULT TRUE,
    weekly_digests BOOLEAN DEFAULT TRUE,
    mention_alerts BOOLEAN DEFAULT TRUE,
    daily_summaries BOOLEAN DEFAULT FALSE,
    unread_reminders BOOLEAN DEFAULT TRUE,
    unsubscribe_all BOOLEAN DEFAULT FALSE,
    created_date DATETIME NOT NULL,
    updated_date DATETIME,
    INDEX idx_user_id (user_id)
);

-- EmailLog table
CREATE TABLE email_log (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    email_address VARCHAR(255) NOT NULL,
    email_type VARCHAR(20) NOT NULL,
    subject VARCHAR(255),
    sent_date DATETIME NOT NULL,
    success BOOLEAN NOT NULL,
    error_message TEXT,
    retry_count INT DEFAULT 0,
    INDEX idx_user_id (user_id),
    INDEX idx_email_type (email_type),
    INDEX idx_sent_date (sent_date)
);

-- ChatbotConversation table
CREATE TABLE chatbot_conversation (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    role VARCHAR(20) NOT NULL,
    content TEXT NOT NULL,
    timestamp DATETIME NOT NULL,
    session_id VARCHAR(100),
    INDEX idx_user_id (user_id),
    INDEX idx_session_id (session_id),
    INDEX idx_timestamp (timestamp)
);

-- ChatbotLog table
CREATE TABLE chatbot_log (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    user_message TEXT NOT NULL,
    bot_response TEXT NOT NULL,
    timestamp DATETIME NOT NULL,
    response_time_ms BIGINT,
    helpful BOOLEAN,
    flagged_for_review BOOLEAN DEFAULT FALSE,
    INDEX idx_user_id (user_id),
    INDEX idx_timestamp (timestamp),
    INDEX idx_flagged (flagged_for_review)
);

-- ChatbotKnowledgeBase table
CREATE TABLE chatbot_knowledge_base (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    message_id BIGINT NOT NULL,
    content TEXT NOT NULL,
    is_faq BOOLEAN DEFAULT FALSE,
    indexed_date DATETIME NOT NULL,
    last_updated DATETIME,
    FOREIGN KEY (message_id) REFERENCES message_forum(id) ON DELETE CASCADE,
    INDEX idx_message_id (message_id),
    INDEX idx_is_faq (is_faq)
);
```

### DTOs

#### MediaFileDTO

```java
@Data
@NoArgsConstructor
@AllArgsConstructor
public class MediaFileDTO {
    private Long id;
    private Long messageId;
    private String mediaType;
    private String fileUrl;
    private String thumbnailUrl;
    private String originalFilename;
    private Long fileSize;
    private String mimeType;
    private String videoPlatform;
    private String videoIdentifier;
    private String transcription;
    private LocalDateTime uploadDate;
    private Long uploaderId;
}
```

#### EmailPreferenceDTO

```java
@Data
@NoArgsConstructor
@AllArgsConstructor
public class EmailPreferenceDTO {
    private Long userId;
    private Boolean welcomeEmails;
    private Boolean replyNotifications;
    private Boolean weeklyDigests;
    private Boolean mentionAlerts;
    private Boolean dailySummaries;
    private Boolean unreadReminders;
    private Boolean unsubscribeAll;
}
```

#### ChatbotResponseDTO

```java
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ChatbotResponseDTO {
    private String response;
    private List<String> suggestedLinks;
    private Long responseTimeMs;
    private Boolean requiresHumanSupport;
}
```

#### ChatbotMessageDTO

```java
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ChatbotMessageDTO {
    private String role;
    private String content;
    private LocalDateTime timestamp;
}
```

#### ChatbotStatsDTO

```java
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ChatbotStatsDTO {
    private Long totalInteractions;
    private Long totalUsers;
    private Double averageResponseTime;
    private Double satisfactionRate;
    private List<String> topQuestions;
}
```


## Correctness Properties

A property is a characteristic or behavior that should hold true across all valid executions of a system—essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.

### Property Reflection

After analyzing all acceptance criteria, I identified several areas of redundancy:

1. **File Size Validation**: Requirements 1.2, 3.4, and 4.2 all test file size validation for different media types. These can be consolidated into a single property about file size validation.

2. **File Format Validation**: Requirements 1.1, 1.6, 3.3, and 4.1 all test file format validation. These can be consolidated into a single property about format validation with error handling.

3. **Email Preference Respect**: Requirements 8.4, 9.5, 10.6, 11.5, and 12.5 all test that email preferences are respected. These can be consolidated into a single property about preference enforcement.

4. **Email Content Properties**: Requirements 8.2, 8.3, 10.3, 10.4, 12.2, 12.3 all test that emails contain specific content. These can be consolidated into fewer properties about email content completeness.

5. **Self-Action Filtering**: Requirements 8.6 and 10.7 both test that users don't get notified of their own actions. These can be consolidated.

6. **Metadata Storage and Retrieval**: Requirements 4.3 and 6.3 test that metadata is stored and retrievable. These follow the same pattern.

7. **Chatbot Context Access**: Requirements 19.1, 19.2, 19.3, and 19.5 all test chatbot context access. These can be consolidated into fewer properties.

### Multimedia Properties

#### Property 1: File Format Validation

*For any* file upload request with a specified media type (IMAGE, AUDIO, DOCUMENT), if the file format is in the allowed list for that media type, the system should accept the upload; otherwise, it should reject the upload with a French error message.

**Validates: Requirements 1.1, 1.6, 3.3, 4.1**

#### Property 2: File Size Validation

*For any* file upload request with a specified media type, if the file size is within the maximum limit for that media type (10MB for images, 25MB for audio, 50MB for documents), the system should accept the upload; otherwise, it should reject the upload.

**Validates: Requirements 1.2, 3.4, 4.2**

#### Property 3: Thumbnail Generation

*For any* uploaded image file, the system should generate a thumbnail with dimensions not exceeding 200x200 pixels.

**Validates: Requirements 1.3**

#### Property 4: Unique File Storage

*For any* two uploaded files, even if they have the same original filename, the stored file paths should be different.

**Validates: Requirements 1.7**

#### Property 5: Video URL Parsing

*For any* valid YouTube or Vimeo URL, the system should correctly extract the video identifier and store it with the platform name.

**Validates: Requirements 2.1, 2.2**

#### Property 6: Video URL Validation

*For any* URL provided for video embedding, if it's not from YouTube or Vimeo domains, the system should reject it with a French error message.

**Validates: Requirements 2.4, 2.5**

#### Property 7: Document Metadata Persistence

*For any* uploaded document, the system should store and allow retrieval of the original filename and file size.

**Validates: Requirements 4.3**

#### Property 8: Document Content-Type Headers

*For any* document download request, the HTTP response should include the correct Content-Type header matching the document's MIME type.

**Validates: Requirements 4.5**

#### Property 9: Malware Scanning

*For any* uploaded file, the system should perform malware scanning before storage.

**Validates: Requirements 4.6**

#### Property 10: Gallery Image Retrieval

*For any* forum, requesting the gallery view should return all images from MessageForum entries in that forum.

**Validates: Requirements 5.1**

#### Property 11: Image Deletion Cascade

*For any* image deletion by an administrator, both the file storage and the associated MessageForum should be updated to reflect the deletion.

**Validates: Requirements 5.6**

#### Property 12: Transcription Generation

*For any* uploaded audio or video file, the system should generate a text transcription.

**Validates: Requirements 6.1**

#### Property 13: Transcription Persistence

*For any* transcribed media file, the transcription text should be stored and retrievable with the MediaFile record.

**Validates: Requirements 6.3**

#### Property 14: Asynchronous Transcription

*For any* message creation with audio/video content, the message should be created and persisted before the transcription process completes.

**Validates: Requirements 6.5**

### Email Notification Properties

#### Property 15: Welcome Email Delivery

*For any* newly registered user, the system should send a welcome email to their registered email address.

**Validates: Requirements 7.1**

#### Property 16: HTML Email Format

*For any* email sent by the system, the email should be in HTML format with proper structure.

**Validates: Requirements 7.4**

#### Property 17: Email Retry Logic

*For any* failed email delivery, the system should retry up to 3 times before marking it as permanently failed.

**Validates: Requirements 7.5**

#### Property 18: Email Delivery Logging

*For any* email delivery attempt, the system should create a log entry with user ID, email type, timestamp, and success/failure status.

**Validates: Requirements 7.6**

#### Property 19: Reply Notification Delivery

*For any* ReponseMessage created on a MessageForum, if the original poster has reply notifications enabled, the system should send a notification email to the original poster.

**Validates: Requirements 8.1**

#### Property 20: Reply Notification Content

*For any* reply notification email, the email should include the reply author's name, reply preview, and a direct link to the MessageForum.

**Validates: Requirements 8.2, 8.3**

#### Property 21: Email Preference Enforcement

*For any* email notification type, if a user has disabled that notification type in their preferences or has unsubscribe_all enabled, the system should not send that email to the user.

**Validates: Requirements 8.4, 9.5, 10.6, 11.5, 12.5**

#### Property 22: Reply Batching

*For any* user who receives multiple replies to their MessageForum within a 5-minute window, the system should send a single batched notification email instead of multiple individual emails.

**Validates: Requirements 8.5**

#### Property 23: Self-Action Filtering

*For any* user action (reply, mention), the system should not send notification emails to the user about their own actions.

**Validates: Requirements 8.6, 10.7**

#### Property 24: Weekly Digest Content

*For any* weekly digest email, the email should include the top 10 most active MessageForum entries from the past week and the count of new messages and replies.

**Validates: Requirements 9.2, 9.3**

#### Property 25: Re-engagement Message

*For any* user who has not visited the forum in the past week, their weekly digest should include a re-engagement message.

**Validates: Requirements 9.6**

#### Property 26: Mention Detection

*For any* MessageForum or ReponseMessage containing @username syntax, the system should identify the mentioned user if the username exists.

**Validates: Requirements 10.1**

#### Property 27: Mention Alert Content

*For any* mention alert email, the email should include the mentioning user's name, message preview, and a direct link to the MessageForum.

**Validates: Requirements 10.3, 10.4**

#### Property 28: Mention Validation

*For any* @username mention, if the username does not exist, the system should not send a mention alert.

**Validates: Requirements 10.5**

#### Property 29: Daily Summary Filtering

*For any* daily summary email, the email should include only unread MessageForum and ReponseMessage entries.

**Validates: Requirements 11.2**

#### Property 30: Daily Summary Grouping

*For any* daily summary email, the content should be grouped by forum category.

**Validates: Requirements 11.3**

#### Property 31: Daily Summary Subject

*For any* daily summary email, the subject line should include the total count of unread items.

**Validates: Requirements 11.4**

#### Property 32: Empty Summary Suppression

*For any* user with no unread content, the system should not send a daily summary email to that user.

**Validates: Requirements 11.6**

#### Property 33: Reminder Content

*For any* unread reminder email, the email should include the discussion title, number of new replies, and a direct link to the MessageForum.

**Validates: Requirements 12.2, 12.3**

#### Property 34: Reminder Rate Limiting

*For any* MessageForum, the system should send a maximum of one reminder email per user per week for that MessageForum.

**Validates: Requirements 12.4**

#### Property 35: Closed Discussion Filtering

*For any* MessageForum marked as resolved or closed, the system should not send unread reminder emails for that MessageForum.

**Validates: Requirements 12.6**

#### Property 36: Preference Persistence

*For any* email preference change by a user, the system should persist the preferences to the database and retrieve them correctly on subsequent queries.

**Validates: Requirements 13.3**

#### Property 37: Unsubscribe All

*For any* user who enables the "unsubscribe from all" option, the system should not send any email notifications of any type to that user.

**Validates: Requirements 13.6**

### Email-Notification Integration Properties

#### Property 38: Dual Notification Creation

*For any* email notification sent by the Email_Service, the system should also create a corresponding NotificationForum entry in the database.

**Validates: Requirements 18.1**

#### Property 39: Notification Synchronization

*For any* NotificationForum marked as read in the application, the system should mark the corresponding email notification as acknowledged.

**Validates: Requirements 18.2**

#### Property 40: In-App Notification Independence

*For any* user with email notifications disabled, the system should still create in-app NotificationForum entries for relevant events.

**Validates: Requirements 18.4**

#### Property 41: Preference Link in Emails

*For any* email sent by the system, the email should include a link to manage notification preferences.

**Validates: Requirements 18.5**

### Chatbot Properties

#### Property 42: French Language Responses

*For any* chatbot response, the response text should be in French.

**Validates: Requirements 14.3**

#### Property 43: Knowledge Base Indexing

*For any* MessageForum entry, the system should index its content in the chatbot knowledge base.

**Validates: Requirements 15.1**

#### Property 44: FAQ Prioritization

*For any* MessageForum marked as FAQ by an administrator, the chatbot should prioritize that content when generating responses to related queries.

**Validates: Requirements 15.3**

#### Property 45: Flagged Content Exclusion

*For any* MessageForum with an active Signalement, the system should exclude that content from the chatbot training data.

**Validates: Requirements 15.5**

#### Property 46: Conversation Context Limit

*For any* user session, the chatbot should maintain conversation context for up to 10 message exchanges.

**Validates: Requirements 15.6**

#### Property 47: Interaction Logging

*For any* chatbot interaction, the system should create a log entry with user ID, user message, bot response, timestamp, and response time.

**Validates: Requirements 16.1**

#### Property 48: Unhelpful Response Flagging

*For any* chatbot response reported as unhelpful by a user, the system should flag that interaction for administrator review.

**Validates: Requirements 16.5**

#### Property 49: Conversation Log Export

*For any* request to export chatbot logs, the system should generate a CSV file containing all conversation logs with proper formatting.

**Validates: Requirements 16.6**

### Integration Properties

#### Property 50: Media Message Likeability

*For any* MessageForum containing MediaFile attachments, the system should allow users to like the message using the existing LikeMessage functionality.

**Validates: Requirements 17.1**

#### Property 51: Signalement Media Information

*For any* Signalement created for a MessageForum with MediaFile attachments, the Signalement should include information about the attached media files.

**Validates: Requirements 17.2**

#### Property 52: Message Deletion Cascade

*For any* MessageForum deletion by an administrator, the system should also delete all associated MediaFile items from both the database and file storage.

**Validates: Requirements 17.4**

#### Property 53: Analytics Media Statistics

*For any* forum analytics report generated by AnalyseService, the report should include MediaFile statistics.

**Validates: Requirements 17.5**

#### Property 54: User Context Access

*For any* chatbot interaction, the chatbot should access the user's recent MessageForum and ReponseMessage history, BadgeUtilisateur achievements, and participation patterns to provide personalized responses.

**Validates: Requirements 19.1, 19.2, 19.3**

#### Property 55: User Statistics Accuracy

*For any* user query about their own activity statistics, the chatbot should provide accurate data retrieved from the Forum_Service.

**Validates: Requirements 19.5**

#### Property 56: File Size Limit Configuration

*For any* media type, administrators should be able to set and enforce file size limits through the Back_Office interface.

**Validates: Requirements 20.4**


## Error Handling

### Error Categories

The system will handle errors across four main categories:

1. **Validation Errors**: Invalid input data, file format/size violations, malformed URLs
2. **Resource Errors**: File storage failures, database connection issues, external API failures
3. **Business Logic Errors**: Permission violations, preference conflicts, rate limit violations
4. **External Service Errors**: Email delivery failures, transcription API errors, chatbot API errors

### Error Response Format

All API endpoints will return consistent error responses:

```json
{
  "timestamp": "2024-01-15T10:30:00",
  "status": 400,
  "error": "Bad Request",
  "message": "Le fichier dépasse la taille maximale autorisée de 10MB",
  "path": "/api/forum/multimedia/upload/image",
  "details": {
    "field": "file",
    "rejectedValue": "15728640",
    "maxSize": "10485760"
  }
}
```

### Error Handling Strategies

#### 1. Multimedia Errors

**File Validation Errors**:
- Return 400 Bad Request with French error message
- Log validation failure with file details
- Do not persist invalid files

**Storage Errors**:
- Return 500 Internal Server Error
- Retry storage operation once
- Log error with stack trace
- Clean up partial uploads

**Malware Detection Errors**:
- Return 400 Bad Request with security warning
- Log security event with user ID and file hash
- Quarantine suspicious files
- Notify administrators of repeated violations

**Transcription Errors**:
- Log error but allow media upload to proceed
- Set transcription status to "FAILED"
- Retry transcription after 1 hour
- Notify user if transcription remains unavailable after 3 attempts

#### 2. Email Errors

**SMTP Connection Errors**:
- Retry with exponential backoff (1s, 2s, 4s)
- Log each retry attempt
- Mark email as failed after 3 attempts
- Queue for manual review if critical (welcome emails, mentions)

**Template Rendering Errors**:
- Log error with template name and data
- Fall back to plain text email
- Notify administrators of template issues

**Preference Errors**:
- Default to opt-in for all notifications if preferences not found
- Create default preferences on first email attempt
- Log preference creation

**Batch Processing Errors**:
- Process emails individually if batch fails
- Log batch failure details
- Continue with remaining emails

#### 3. Chatbot Errors

**API Connection Errors**:
- Return fallback response: "Je rencontre des difficultés techniques. Veuillez réessayer dans quelques instants ou contacter un administrateur."
- Log API error with request details
- Retry once after 2 seconds
- Track API availability metrics

**Context Retrieval Errors**:
- Proceed without user context
- Log context retrieval failure
- Provide generic responses

**Knowledge Base Errors**:
- Use cached knowledge base if update fails
- Log indexing errors
- Retry indexing during next scheduled update

**Rate Limiting**:
- Return 429 Too Many Requests
- Include Retry-After header
- Log rate limit violations
- Implement per-user rate limits (10 messages per minute)

#### 4. Integration Errors

**MessageForum Not Found**:
- Return 404 Not Found
- Log attempted access with user ID
- Suggest similar or recent messages

**User Not Found**:
- Return 404 Not Found for direct user queries
- Silently skip for batch operations (mentions, notifications)
- Log user ID for investigation

**Cascade Deletion Errors**:
- Roll back entire transaction
- Log deletion failure with entity IDs
- Retry deletion once
- Notify administrator if retry fails

### Global Exception Handler

```java
@ControllerAdvice
public class GlobalExceptionHandler {
    
    @ExceptionHandler(FileValidationException.class)
    public ResponseEntity<ErrorResponse> handleFileValidation(FileValidationException ex) {
        // Return 400 with French error message
    }
    
    @ExceptionHandler(StorageException.class)
    public ResponseEntity<ErrorResponse> handleStorage(StorageException ex) {
        // Return 500 with generic error message
    }
    
    @ExceptionHandler(EmailDeliveryException.class)
    public ResponseEntity<ErrorResponse> handleEmailDelivery(EmailDeliveryException ex) {
        // Log and return 202 Accepted (async processing)
    }
    
    @ExceptionHandler(ChatbotException.class)
    public ResponseEntity<ErrorResponse> handleChatbot(ChatbotException ex) {
        // Return fallback response
    }
    
    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleNotFound(ResourceNotFoundException ex) {
        // Return 404 with French error message
    }
    
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGeneral(Exception ex) {
        // Log unexpected error and return 500
    }
}
```

### Logging Strategy

All errors will be logged with:
- Timestamp
- User ID (if available)
- Request path and method
- Error type and message
- Stack trace (for 500 errors)
- Contextual data (file names, email addresses, etc.)

Log levels:
- **ERROR**: System failures, external API errors, data corruption
- **WARN**: Validation failures, retry attempts, rate limiting
- **INFO**: Successful operations, scheduled task execution
- **DEBUG**: Detailed processing information, SQL queries

## Testing Strategy

### Dual Testing Approach

The testing strategy employs both unit tests and property-based tests to ensure comprehensive coverage:

- **Unit Tests**: Verify specific examples, edge cases, error conditions, and integration points
- **Property Tests**: Verify universal properties across all inputs through randomization

This dual approach ensures that unit tests catch concrete bugs while property tests verify general correctness across a wide range of inputs.

### Unit Testing

Unit tests will focus on:

1. **Specific Examples**: Concrete test cases that demonstrate correct behavior
   - Upload a valid JPEG image and verify it's stored correctly
   - Send a welcome email and verify content includes navigation instructions
   - Ask chatbot a specific question and verify response is in French

2. **Edge Cases**: Boundary conditions and special scenarios
   - Upload a file exactly at the size limit (10MB for images)
   - Send reply notification when user has no email address
   - Chatbot query with empty string or very long text

3. **Error Conditions**: Failure scenarios and error handling
   - Upload an invalid file format and verify French error message
   - Simulate SMTP failure and verify retry logic
   - Chatbot API timeout and verify fallback response

4. **Integration Points**: Component interactions
   - Delete MessageForum and verify MediaFiles are also deleted
   - Send email notification and verify NotificationForum is created
   - Chatbot accesses user context from multiple services

### Property-Based Testing

Property-based tests will use **JUnit QuickCheck** library for Java to generate random test data and verify properties hold across all inputs.

#### Configuration

- **Iterations**: Minimum 100 iterations per property test
- **Tagging**: Each test tagged with feature name and property number
- **Generators**: Custom generators for domain objects (MediaFile, EmailPreference, ChatbotMessage)

#### Example Property Test Structure

```java
@RunWith(JUnitQuickcheck.class)
public class MultimediaPropertyTest {
    
    // Feature: advanced-forum-features, Property 2: File Size Validation
    @Property(trials = 100)
    public void fileSizeValidation(
        @InRange(minLong = 0, maxLong = 100_000_000) long fileSize,
        @From(MediaTypeGenerator.class) String mediaType
    ) {
        long maxSize = getMaxSizeForMediaType(mediaType);
        boolean shouldAccept = fileSize <= maxSize;
        boolean actuallyAccepted = multimediaService.validateFileSize(fileSize, mediaType);
        assertEquals(shouldAccept, actuallyAccepted);
    }
    
    // Feature: advanced-forum-features, Property 4: Unique File Storage
    @Property(trials = 100)
    public void uniqueFileStorage(
        @From(FilenameGenerator.class) String filename1,
        @From(FilenameGenerator.class) String filename2
    ) {
        String storedPath1 = fileStorageService.generateUniqueFileName(filename1);
        String storedPath2 = fileStorageService.generateUniqueFileName(filename2);
        assertNotEquals(storedPath1, storedPath2);
    }
}
```

#### Property Test Coverage

Each of the 56 correctness properties will have a corresponding property-based test:

**Multimedia Properties (1-14)**:
- File validation properties with random file sizes and formats
- URL parsing properties with random YouTube/Vimeo URLs
- Thumbnail generation with random image dimensions
- Transcription properties with random audio files

**Email Properties (15-37)**:
- Email delivery properties with random user preferences
- Content validation properties with random message data
- Batching properties with random timing scenarios
- Preference enforcement with random preference combinations

**Chatbot Properties (42-49)**:
- Language detection with random French text
- Context management with random conversation lengths
- Knowledge base properties with random forum content

**Integration Properties (50-56)**:
- Cascade deletion with random entity graphs
- Cross-service properties with random user contexts

### Test Organization

```
src/test/java/tn/esprit/forum/
├── unit/
│   ├── controller/
│   │   ├── MultimediaControllerTest.java
│   │   ├── EmailControllerTest.java
│   │   └── ChatbotControllerTest.java
│   ├── service/
│   │   ├── MultimediaServiceTest.java
│   │   ├── EmailServiceTest.java
│   │   └── ChatbotServiceTest.java
│   └── integration/
│       ├── MultimediaIntegrationTest.java
│       ├── EmailIntegrationTest.java
│       └── ChatbotIntegrationTest.java
└── property/
    ├── MultimediaPropertyTest.java
    ├── EmailPropertyTest.java
    ├── ChatbotPropertyTest.java
    └── IntegrationPropertyTest.java
```

### Test Data Management

**Unit Tests**:
- Use @BeforeEach to set up test data
- Use test fixtures for common scenarios
- Mock external services (OpenAI API, SMTP server)

**Property Tests**:
- Custom generators for domain objects
- Constraint-based generation (valid file sizes, formats)
- Shrinking support for minimal failing examples

### Continuous Integration

All tests will run on:
- Every commit to feature branches
- Pull request creation
- Merge to main branch

CI pipeline will:
1. Run unit tests (fast feedback)
2. Run property tests (comprehensive coverage)
3. Generate coverage report (target: 80% line coverage)
4. Fail build if any test fails

### Performance Testing

In addition to functional testing:

- **Load Testing**: Simulate 100 concurrent users uploading files
- **Email Volume Testing**: Send 1000 emails and verify delivery rate
- **Chatbot Response Time**: Verify 95th percentile response time < 3 seconds
- **Storage Capacity**: Test with 10GB of multimedia files

### Manual Testing Checklist

Before release, manually verify:

1. **Multimedia**:
   - Upload and view all supported file types in both frontends
   - Verify thumbnails display correctly
   - Test video embedding from YouTube and Vimeo
   - Verify transcription appears for audio files

2. **Email**:
   - Receive welcome email on registration
   - Receive reply notification
   - Receive mention alert
   - Verify email preferences work correctly
   - Check email formatting in multiple email clients

3. **Chatbot**:
   - Ask common questions and verify responses
   - Test conversation context (10 message limit)
   - Verify chatbot icon appears on all pages
   - Test administrator dashboard and logs

4. **Integration**:
   - Like a message with media attachments
   - Create signalement for message with media
   - Delete message and verify media files are removed
   - Verify analytics include media statistics

