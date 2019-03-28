# rate my course * Purdue CS edition *

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
1. [Schema](#Schema)

## Overview
### Description
We are making a service to allow students to rate classes, similar to RateMyProfessor. We are going to limit classes to Purdue CS courses to simplify it for a demo.

- **Category:** Education
- **Mobile:** real-time, audio
- **Story:** The value of this idea is high to students looking to take certain classes. Potentially, other students would be able to use the app and would respond positively.
- **Market:** The market is all Purdue CS students, which is relatively small but we could potentially cater to that audience. This is more of a niche service.
- **Habit:** The frequency of the app's use depends on the user. consume & create
- **Scope:** The service isn't particularly complex. We only include Purdue CS courses, which we can create a back-end for by Demo Day.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

 * [x] User can login
 * [x] User can search for classes
 * [] User can create ratings/posts
 * [] User can see ratings/posts

**Optional Nice-to-have Stories**

 * [x] User can Logout 
 * [] User can manage account

### 2. Screen Archetypes

 * Login Screen
     * User can login
 * Search Screen
     * User can search for classes
 * Detail/Stream Screen
     * User can see ratings/posts
 * Creation Screen
     * User can create ratings/posts

### 3. Navigation

**Tab Navigation** (Tab to Screen)

N/A

**Flow Navigation** (Screen to Screen)

 * Login Screen
   * Search Screen
 * Search Screen
   * Detail/Stream Screen
   * Login Screen
 * Detail/Stream Screen
   * Creation Screen 
 * Creation Screen
   * Detail/Stream Screen
 
## Wireframes
### Digital Wireframes & Mockups & interactive prototypes
[figma prototype](https://www.figma.com/file/EjJjVgg0Xs4ZXMg753z4ZR6L/Rate-my-course?node-id=0%3A1)

## Schema
### Models
#### post

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the user post (default field) |
   | userImage | File | user profile image |
   | username | String | name of user |
   | comments      | String   | comments that made by users |
   | commentsCount | Number   | number of comments that has been posted in each courses |
   | likesCount | Number | number of likes for the post |
   | createdAt | DateTime | date when post is created (default field) |
   | updatedAt | DateTime | date when post is last updated (default field) |
   
#### postSummary
   
   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | courseName | String | name of course|
   | overallQuality | Number | overall score of each courses rated by users |
   | difficultyLevel | Number | difficulty level of each courses rated by users |
   | usefulnessPercentage | Number | percentage of people that foud the course useful|
   | funPercentage | Number | percentage of people that found the course fun|

### Networking

#### List of network requests by screen

##### Stream Screen
- (Read/GET) Query all CS courses and number of feedbacks for each course


##### Detail Screen
- (Read/GET) Query logged in user object
- (Read/GET) Query all posts where user is author
    - (Create/POST) Create a new like on a post
    - (Create/POST) Create a new comment on a post

##### survey/comment Screen
- (Create/POST) Create a new post object
