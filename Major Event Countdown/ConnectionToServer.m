//
//  ConnectionToServer.m
//  VirtualEventCentre
//
//  Created by Muhammed Nurkerim on 28/09/2012.
//
//

#import "ConnectionToServer.h"

@implementation ConnectionToServer

+ (NSMutableArray *) makeGETRequestWithURL:(NSURL *)urlRequest
{
    NSMutableURLRequest *request;
    NSData *data;
    
    NSMutableArray * json;
    
    request = [NSMutableURLRequest requestWithURL:urlRequest];
    data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if (data != nil && data.length > 2) {
        json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    }
    return json; 
}

+ (NSHTTPURLResponse *) makePOSTReqeustWithURL:(NSURL *)urlRequest jsonData:(NSMutableDictionary *)jsonToSend
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonToSend options:NSJSONWritingPrettyPrinted error:&error];
    
    NSHTTPURLResponse* urlResponse = nil;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlRequest];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPBody:jsonData];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    return urlResponse;
}

+ (NSHTTPURLResponse *) makePOSTReqeustWithURL:(NSURL *)urlRequest
{
    NSError *error = nil;
    
    NSHTTPURLResponse* urlResponse = nil;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlRequest];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    return urlResponse;
}

+ (NSHTTPURLResponse *) makePUTReqeustWithURL:(NSURL *)urlRequest jsonData:(NSMutableDictionary *)jsonToSend
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonToSend options:NSJSONWritingPrettyPrinted error:&error];
    
    NSHTTPURLResponse* urlResponse = nil;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlRequest];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPBody:jsonData];
    [request setHTTPMethod:@"PUT"];
    [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    return urlResponse;
}

@end
