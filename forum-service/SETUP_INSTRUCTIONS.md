# Advanced Forum Features - Setup Instructions

## Task 1: Database Schema and Configuration - COMPLETED ✓

This document describes the setup completed for the Advanced Forum Features implementation.

## What Was Done

### 1. Database Migration Script Created ✓

**Location:** `src/main/resources/db/migration/V1__create_advanced_forum_tables.sql`

Created SQL migration script with 6 new tables:

#### Multimedia Integration Tables:
- **media_file**: Stores metadata for uploaded images, videos, audio, and documents
  - Supports image uploads (JPEG, PNG, GIF, WebP)
  - Video embedding (YouTube, Vimeo)
  - Audio files with transcription support
  - Document attachments (PDF, ZIP, RAR, DOC, DOCX, XLS, XLSX)
  - Includes indexes for performance optimization

#### Email Notification Tables:
- **email_preference**: User email notification preferences
  - Welcome emails, reply notifications, weekly digests
  - Mention alerts, daily summaries, unread reminders
  - Unsubscribe all option
  
- **email_log**: Logs all email delivery attempts
  - Tracks success/failure status
  - Retry count and error messages
  - Indexed for efficient querying

#### AI Chatbot Tables:
- **chatbot_conversation**: Conversation history for context management
  - Stores user and assistant messages
  - Session-based tracking
  
- **chatbot_log**: Interaction logging for monitoring
  - Response time tracking
  - Helpful/unhelpful feedback
  - Flagging for administrator review
  
- **chatbot_knowledge_base**: Indexed forum content for training
  - FAQ prioritization
  - Content indexing with timestamps

### 2. Application Properties Configured ✓

**Location:** `src/main/resources/application.properties`

Added comprehensive configuration for:

#### File Storage Configuration:
```properties
forum.storage.upload-directory=uploads
forum.storage.max-image-size=10485760      # 10MB
forum.storage.max-audio-size=26214400      # 25MB
forum.storage.max-document-size=52428800   # 50MB
forum.storage.allowed-image-formats=jpg,jpeg,png,gif,webp
forum.storage.allowed-audio-formats=mp3,wav,ogg
forum.storage.allowed-document-formats=pdf,zip,rar,doc,docx,xls,xlsx
```

#### Email Service Configuration (SMTP):
```properties
spring.mail.host=smtp.gmail.com
spring.mail.port=587
spring.mail.username=your-email@gmail.com          # ⚠️ REPLACE WITH ACTUAL EMAIL
spring.mail.password=your-app-password             # ⚠️ REPLACE WITH APP PASSWORD
```

#### OpenAI API Configuration:
```properties
forum.openai.api-key=sk-your-openai-api-key-here  # ⚠️ REPLACE WITH ACTUAL API KEY
forum.openai.gpt-model=gpt-4
forum.openai.whisper-model=whisper-1
```

#### Async Executor Configuration:
```properties
spring.task.execution.pool.core-size=5
spring.task.execution.pool.max-size=10
spring.task.scheduling.pool.size=5
```

### 3. Maven Dependencies Added ✓

**Location:** `pom.xml`

Added the following dependencies:

- **Thumbnailator (0.4.20)**: Image processing and thumbnail generation
- **Apache Tika (2.9.1)**: File type detection and content analysis
- **Spring Boot Mail**: Email sending functionality
- **Thymeleaf**: Email template engine
- **OpenAI Java Client (0.18.2)**: GPT-4 and Whisper API integration
- **JUnit QuickCheck (1.0)**: Property-based testing framework

## Next Steps - REQUIRED ACTIONS

### 1. Configure SMTP Credentials ⚠️

You must replace the placeholder SMTP credentials in `application.properties`:

**For Gmail:**
1. Go to Google Account settings
2. Enable 2-factor authentication
3. Generate an App Password: https://myaccount.google.com/apppasswords
4. Replace `your-email@gmail.com` and `your-app-password` in the config

**For other SMTP providers:**
- Update `spring.mail.host` and `spring.mail.port` accordingly
- Provide appropriate credentials

### 2. Configure OpenAI API Key ⚠️

1. Get your API key from: https://platform.openai.com/api-keys
2. Replace `sk-your-openai-api-key-here` in `application.properties`
3. Ensure you have credits in your OpenAI account

### 3. Run Database Migration

The migration script will be executed automatically when you start the application if you're using Flyway. 

**If NOT using Flyway:**
- Execute the SQL script manually: `src/main/resources/db/migration/V1__create_advanced_forum_tables.sql`
- Or configure Flyway by adding this dependency to `pom.xml`:
  ```xml
  <dependency>
      <groupId>org.flywaydb</groupId>
      <artifactId>flyway-core</artifactId>
  </dependency>
  <dependency>
      <groupId>org.flywaydb</groupId>
      <artifactId>flyway-mysql</artifactId>
  </dependency>
  ```

### 4. Create Upload Directory

Create the uploads directory in your application root:
```bash
mkdir uploads
mkdir uploads/images
mkdir uploads/audio
mkdir uploads/documents
mkdir uploads/thumbnails
```

Or the application will create it automatically on first file upload.

### 5. Build the Project

Run Maven to download all new dependencies:
```bash
mvn clean install
```

Or if using an IDE (IntelliJ IDEA, Eclipse):
- Right-click on `pom.xml` → Maven → Reload Project
- Or use the Maven tool window to reload

## Verification Checklist

Before proceeding to the next task, verify:

- [ ] Database migration script exists in `src/main/resources/db/migration/`
- [ ] Application properties contain all new configuration sections
- [ ] SMTP credentials are configured (not placeholders)
- [ ] OpenAI API key is configured (not placeholder)
- [ ] All Maven dependencies are added to `pom.xml`
- [ ] Project builds successfully without errors
- [ ] Database tables are created (check MySQL)

## Configuration Reference

### File Size Limits (in bytes):
- Images: 10,485,760 bytes (10 MB)
- Audio: 26,214,400 bytes (25 MB)
- Documents: 52,428,800 bytes (50 MB)

### Supported File Formats:
- **Images**: JPG, JPEG, PNG, GIF, WebP
- **Audio**: MP3, WAV, OGG
- **Documents**: PDF, ZIP, RAR, DOC, DOCX, XLS, XLSX
- **Video**: YouTube and Vimeo URLs (embedded, not uploaded)

### Email Types:
- WELCOME: New user registration
- REPLY: Reply to user's post
- MENTION: User mentioned with @username
- DIGEST: Weekly activity summary
- SUMMARY: Daily unread summary
- REMINDER: Unread discussion reminder

### Chatbot Configuration:
- Rate limit: 10 messages per minute per user
- Conversation context: 10 messages
- Response timeout: 3 seconds
- Model: GPT-4
- Language: French

## Troubleshooting

### Maven Build Fails
- Ensure you have internet connection to download dependencies
- Check Maven version: `mvn --version` (requires Maven 3.6+)
- Clear Maven cache: `mvn dependency:purge-local-repository`

### Database Connection Issues
- Verify MySQL is running on localhost:3306
- Check database credentials in `application.properties`
- Ensure `forum_db` database exists or `createDatabaseIfNotExist=true` is set

### Email Sending Fails
- Verify SMTP credentials are correct
- Check firewall/antivirus isn't blocking port 587
- For Gmail, ensure "Less secure app access" is enabled or use App Password

### OpenAI API Errors
- Verify API key is valid and has credits
- Check network connectivity to OpenAI servers
- Review rate limits on your OpenAI account

## Support

For issues or questions:
1. Check the design document: `.kiro/specs/advanced-forum-features/design.md`
2. Review requirements: `.kiro/specs/advanced-forum-features/requirements.md`
3. Consult the implementation plan: `.kiro/specs/advanced-forum-features/tasks.md`

---

**Status**: Task 1 Complete - Ready for Task 2 (Implement multimedia entities and repositories)
