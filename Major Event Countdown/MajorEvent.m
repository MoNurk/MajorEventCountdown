//
//  Document.m
//  VirtualEventCentre
//
//  Created by Muhammed Nurkerim on 11/09/2012.
//
//

#import "MajorEvent.h"

@implementation MajorEvent

@synthesize eventDate = _eventDate, eventDescription = _eventDescription, eventId = _eventId, category = _category, eventName = _eventName, notes = _notes;

- (MajorEvent *) initWithEventId:(int)Id eventName:(NSString *)name eventDescription:(NSString *)description eventCategory:(NSString *)category eventUTCDate:(NSString *)date eventNotes:(NSString *)notes
{
    _eventId = Id;
    _eventName = name;
    _eventDescription = description;
    _category = category;
    _eventDate = [MajorEvent convertToLocalTimeZone:date];
    _notes = notes;
    
    return self;
}

- (MajorEvent *) initWithEventId:(int)Id eventName:(NSString *)name eventDescription:(NSString *)description eventCategory:(NSString *)category eventLocalDate:(NSString *)date eventNotes:(NSString *)notes
{
    _eventId = Id;
    _eventName = name;
    _eventDescription = description;
    _category = category;
    _eventDate = date;
    _notes = notes;
    
    return self;
}

- (NSDate*) convertStringToDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/yyyy HH:mm";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSDate* eventDate = [dateFormatter dateFromString:[self eventDate]];
    
    return eventDate;
}

+ (NSString *) convertToLocalTimeZone:(NSString*) UTCDateAndTime
{
    NSDateFormatter *UTCdateFormatter = [[NSDateFormatter alloc] init];
    UTCdateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSTimeZone *utc = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [UTCdateFormatter setTimeZone:utc];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/yyyy HH:mm";
    NSTimeZone *local = [NSTimeZone systemTimeZone];
    [dateFormatter setTimeZone:local];
    
    NSDate * UTCDate = [UTCdateFormatter dateFromString:UTCDateAndTime];
    
    NSString *localTimeZoneTime = [dateFormatter stringFromDate:UTCDate];
    
    return localTimeZoneTime;
}

@end
