//
//  TagEnumValue.m
//  Graffiti
//
//  Created by Ade on 9/1/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "TagEnumValue.h"
#import "MongoDbTags.h"
#import "TagTypes.h"

@implementation TagEnumValue

+ (NSString *) getStringValueForTagType : (NSInteger) val
{
    switch (val) {
        case TYPE_IMAGE:
            return @"image";
            break;
        case TYPE_AUDIO:
            return @"audio";
            break;
        case TYPE_VIDEO:
            return @"video";
            break;
        default:
            return @"NO_SUCH_TYPE";
            break;
    }
}

+ (NSString *) getStringValue : (NSInteger) val
{
    switch (val) {
        case GROUP_TABLE:
            return @"graffiti.groups";
            break;
        case TAGS_TABLE:
            return @"graffiti.tags";
            break;
        case LOGIN_CREDENTIALS_TABLE:
            return @"graffiti.logincreds";
            break;
        case PROFILE_TABLE:
            return @"graffiti.profile";
            break;
        case TAGGER_TABLE:
            return @"graffiti.taggers";
            break;
        case TAG_LONGITUDE_COLUMN:
            return @"longitude";
            break;
        case TAG_LATITUDE_COLUMN:
            return @"latitude";
            break;
        case TAG_CONTENT_COLUMN:
            return @"content";
            break;
        case TAG_CONTENT_TYPE_COLUMN:
            return @"contenttype";
            break;
        case TAG_TAGGER_COLUMN:
            return @"tagger";
            break;
        case TAG_GROUP_COLUMN:
            return @"groups";
            break;
        case TAG_TIME_DROPPED_COLUMN:
            return @"timedropped";
            break;
        case TAG_RESTRICTED_BY_COLUMN:
            return @"restrictions";
            break;
        case TAG_EXPIRATION_DATE_COLUMN:
            return @"expdate";
            break;
        case TAG_NOTES_COLUMN:
            return @"notes";
            break;
        case PROFILE_PICTURE_COLUMN:
            return @"profilepic";
            break;
        case PROFILE_GROUPS_COLUMN:
            return @"groups";
            break;
        case PROFILE_HOBBIES_COLUMN:
            return @"hobbies";
            break;
        case PROFILE_INTEREST_COLUMN:
            return @"interest";
            break;
        case PROFILE_BIO_COLUMN:
            return @"bio";
            break;
        case PROFILE_WEBSITE_COLUMN:
            return @"website";
            break;
        case PROFILE_PHONE_NUMBER_COLUMN:
            return @"phone";
            break;
        case PROFILE_NUM_OF_FOLLOWERS_COLUMN:
            return @"numfollowers";
            break;
        case PROFILE_NUM_FOLLOWING_COLUMN:
            return @"numfollowing";
            break;
        case PROFILE_POST_SCOPE_COLUMN:
            return @"postscope";
            break;
        case PROFILE_HOME_LOCATION_COLUMN:
            return @"homeloc";
            break;
        case LOGIN_NAME_COLUMN:
            return @"username";
            break;
        case LOGIN_PASSWORD_COLUMN:
            return @"password";
            break;
        case LOGIN_EMAIL_COLUMN:
            return @"email";
            break;
        case GROUP_NAME_COLUMN:
            return @"name";
            break;
        case GROUP_DESCRIPTION_COLUMN:
            return @"description";
            break;
        case GROUP_PRIMARY_LOCATION_COLUMN:
            return @"primaryloc";
            break;
        case GETTER_GET_ALL_VALUES:
            return @"getallvalues";
            break;
        case GETTER_NO_KEY:
            return @"NO_KEY";
            break;
        case TAG_NAME_COLUMN:
            return @"name";
            break;
        case TAG_ID_COLUMN:
            return @"uid";
            break;
        case TAG_DATA_URL_COLUMN:
            return @"url";
            break;
        case TAG_CONVERSATION_COLUMN:
            return @"conversation";
            break;
        case PROFILE_NAME_COLUMN:
            return @"name";
            break;
        case PROFILE_PASSWORD_COLUMN:
            return @"password";
            break;
        case PROFILE_EMAIL_COLUMN:
            return @"email";
            break;
        case PROFILE_UUID_COLUMN:
            return @"uuid";
            break;
        case TAG_COMMENTS_COLUMN:
            return @"comments";
            break;
        case CONTENT_TYPE_AUDIO:
            return @"audio";
            break;
        case CONTENT_TYPE_IMAGE:
            return @"image";
            break;
        case CONTENT_TYPE_VIDEO:
            return @"video";
        default:
            return @"NO_SUCH_COLUMN";
            break;
    }
}

@end
