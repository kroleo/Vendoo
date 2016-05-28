// Generated by xsd compiler for ios/objective-c
// DO NOT CHANGE!

#import <Foundation/Foundation.h>
#import "SOAP12Envelope.h"
#import "SOAP12Body.h"
#import "SOAP12Header.h"
#import "OrderedDictionary.h"

@implementation SOAP12Envelope

@synthesize header = _header;
@synthesize body = _body;

// class meta-data method
// note: this method is only for internal use, DO NOT CHANGE!
+(PicoClassSchema *)getClassMetaData {
    PicoClassSchema *cs = [[PicoClassSchema alloc] initWithXmlName:@"Envelope" nsUri:@"http://www.w3.org/2003/05/soap-envelope"];
    return cs;
}

// property meta-data method
// note: this method is only for internal use, DO NOT CHANGE!
+(NSMutableDictionary *)getPropertyMetaData {
    NSMutableDictionary *map = [OrderedDictionary dictionary];
    
    PicoPropertySchema *ps = nil;
    ps = [[PicoPropertySchema alloc] initWithKind:PICO_KIND_ELEMENT xmlName:@"Header" propertyName:@"header" type:PICO_TYPE_OBJECT clazz:[SOAP12Header class]];
    map[@"header"] = ps;
    ps = [[PicoPropertySchema alloc] initWithKind:PICO_KIND_ELEMENT xmlName:@"Body" propertyName:@"body" type:PICO_TYPE_OBJECT clazz:[SOAP12Body class]];
    map[@"body"] = ps;
    
    return map;
}




@end
