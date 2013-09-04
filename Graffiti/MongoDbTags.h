//
//  MongoDbTags.h
//  Graffiti
//
//  Created by Ade on 8/30/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#ifndef Graffiti_MongoDbTags_h
#define Graffiti_MongoDbTags_h

typedef enum {
    GROUP_TABLE = 0,
    TAGS_TABLE = 1,
    LOGIN_CREDENTIALS_TABLE = 2,
    PROFILE_TABLE = 3,
    TAGGER_TABLE = 4
} MongoTable;

typedef enum {
    TAG_LONGITUDE_COLUMN = 5,
    TAG_LATITUDE_COLUMN = 44,
    TAG_CONTENT_COLUMN = 6,
    TAG_CONTENT_TYPE_COLUMN = 7,
    TAG_TAGGER_COLUMN = 8,
    TAG_GROUP_COLUMN = 9,
    TAG_TIME_DROPPED_COLUMN = 10,
    TAG_RESTRICTED_BY_COLUMN = 11,
    TAG_EXPIRATION_DATE_COLUMN = 12,
    TAG_NOTES_COLUMN = 13,
    TAG_NAME_COLUMN = 33,
    TAG_ID_COLUMN = 34,
    TAG_DATA_URL_COLUMN = 35,
    TAG_CONVERSATION_COLUMN = 36,
    TAG_COMMENTS_COLUMN = 41
} TagDatabaseColumn;

typedef enum {
    PROFILE_NAME_COLUMN = 37,
    PROFILE_PASSWORD_COLUMN = 38,
    PROFILE_EMAIL_COLUMN = 39,
    PROFILE_UUID_COLUMN = 40,
    PROFILE_PICTURE_COLUMN = 14,
    PROFILE_GROUPS_COLUMN = 15,
    PROFILE_HOBBIES_COLUMN = 16,
    PROFILE_INTEREST_COLUMN = 17,
    PROFILE_BIO_COLUMN = 18,
    PROFILE_WEBSITE_COLUMN = 19,
    PROFILE_PHONE_NUMBER_COLUMN = 20,
    PROFILE_NUM_OF_FOLLOWERS_COLUMN = 21,
    PROFILE_NUM_FOLLOWING_COLUMN = 22,
    PROFILE_POST_SCOPE_COLUMN = 23,
    PROFILE_HOME_LOCATION_COLUMN = 24
} ProfileDatabaseColumn;

typedef enum {
    LOGIN_NAME_COLUMN = 25,
    LOGIN_PASSWORD_COLUMN = 26,
    LOGIN_EMAIL_COLUMN = 27
} LoginCredentialsColumn;

typedef enum {
    GROUP_NAME_COLUMN = 28,
    GROUP_DESCRIPTION_COLUMN = 29,
    GROUP_PRIMARY_LOCATION_COLUMN = 30
} GroupTableColumn;

typedef enum {
    GETTER_GET_ALL_VALUES = 31,
    GETTER_NO_KEY = 32
} Getters;

typedef enum {
    CONTENT_TYPE_IMAGE = 42,
    CONTENT_TYPE_AUDIO = 43
} TagContentType;

#endif
