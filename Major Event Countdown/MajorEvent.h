//
//  Document.h
//  VirtualEventCentre
//
//  Created by Muhammed Nurkerim on 11/09/2012.
//
//

#import <Foundation/Foundation.h>

@interface MajorEvent : NSObject {
    
}

@property long eventId;
@property (nonatomic, retain) NSString* eventName;
@property (nonatomic, retain) NSString* eventDescription;
@property (nonatomic, retain) NSString* category;
@property (nonatomic, retain) NSString* eventDate;
@property (nonatomic, retain) NSString* notes;

- (MajorEvent *) initWithEventId:(int) Id eventName:(NSString*) name eventDescription:(NSString*) description eventCategory:(NSString*) category eventUTCDate:(NSString*) date eventNotes:(NSString *) notes;

- (MajorEvent *) initWithEventId:(int)Id eventName:(NSString *)name eventDescription:(NSString *)description eventCategory:(NSString *)category eventLocalDate:(NSString *)date eventNotes:(NSString *)notes;

- (NSDate*) convertStringToDate;

+ (NSString *) convertToLocalTimeZone:(NSString*) UTCDateAndTime;

@end
