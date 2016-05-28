//
//  PicoTBXMLReader.m
//  Pico
//
//  Created by bulldog on 13-3-11.
//  Copyright (c) 2013 LeanSoft Technology. All rights reserved.
//

#import "PicoXMLReader.h"
#import "GDataXMLNode.h"
#import "PicoBindingSchema.h"
#import "PicoPropertySchema.h"
#import "PicoClassSchema.h"
#import "PicoConstants.h"
#import "PicoConverter.h"
#import "PicoXMLElement.h"

@implementation PicoXMLReader

@synthesize config = _config;

- (instancetype) init {
    PicoConfig *config = [[PicoConfig alloc] init] ;
    return [self initWithConfig:config];
}

- (instancetype)initWithConfig:(PicoConfig *)config {
    self = [super init];
    if (self) {
        self.config = config;
    }
    
    return self;
}

-(id)fromData:(NSData *)data withClass:(Class)clazz {
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data error:&error];
    
    if (!doc) {
        @throw [NSException exceptionWithName:@"ReaderException" reason:[NSString stringWithFormat:@"fail to parse xml data , Error : %@", error] userInfo:[error userInfo]];
    }
    
    GDataXMLElement *rootElement = [doc rootElement];
    PicoBindingSchema *bs = [PicoBindingSchema fromClass:clazz];
    PicoClassSchema *cs = bs.classSchema;
    NSString *xmlName = cs.xmlName;
    if ([xmlName length] == 0) {
        xmlName = bs.className;
    }
    NSString *rootName = [rootElement localName];
    if (![xmlName isEqualToString: rootName]) {
		@throw [NSException exceptionWithName:@"ReaderException" reason:[NSString stringWithFormat:@"root name mismatch , xml name : %@, root name : %@", xmlName, rootName] userInfo:nil];
	}
    
    id obj = [clazz new];
    
    [self read: obj element: rootElement];
    
    return obj;
}

-(void)read:(id)value element:(GDataXMLElement *)element {
    
    [self readAttribute:value element:element];

    
    BOOL hasText = [self readText:value element:element];
    if (hasText) {
        return; // no further read if xml text presents
    }
    
    [self readElement:value element:element];
    
    
    [self readAnyElement:value element:element];

}

-(void)readAttribute:(id)value element:(GDataXMLElement *)element {
    PicoBindingSchema *bs = [PicoBindingSchema fromObject:value];
    
    // read xml attributes
    NSDictionary *attrMap = bs.xml2AttributeSchemaMapping;
    if(attrMap.count > 0) {
        for(NSString *xmlName in attrMap) {
            PicoPropertySchema *ps = attrMap[xmlName];
            GDataXMLNode *attrNode = [element attributeForName:xmlName];
            if (attrNode) {
                NSString *attrValue = [attrNode stringValue];
                if ([attrValue length] > 0) {
                    id objValue = [PicoConverter read:attrValue withType:ps.propertyType config:self.config];
                    if (objValue) {
                        [value setValue:objValue forKey: ps.propertyName];
                    }
                }
            }
        }
    }
}

-(BOOL)readText:(id)value element:(GDataXMLElement *) element {
    PicoBindingSchema *bs = [PicoBindingSchema fromObject:value];
    
    // read xml value if any
    PicoPropertySchema *valuePs = bs.valueSchema;
    if (valuePs) {
        NSString *text = [element stringValue];
        if (text.length > 0) {
            id objValue = [PicoConverter read: text withType: valuePs.propertyType config:self.config];
            if (objValue) {
                [value setValue: objValue forKey: valuePs.propertyName];
            }
        }
        
        return YES;
    }
    return NO;
}

-(void)readElement:(id)value element:(GDataXMLElement *)element {
    PicoBindingSchema *bs = [PicoBindingSchema fromObject:value];
    
    // read xml element
    NSDictionary *elementMap = bs.xml2ElementSchemaMapping;
    NSArray *children = [element children];
    if (children.count > 0) {
        for(GDataXMLNode *node in children) {
            if ([node kind] == GDataXMLElementKind) {
                GDataXMLElement *childElement = (GDataXMLElement *) node;
                NSString *localName = childElement.localName;
                
                PicoPropertySchema *ps = elementMap[localName];
                
                if (ps) { // found element match
                    
                    if ([ps.propertyKind isEqualToString:PICO_KIND_ELEMENT]) {
                        // primitive
                        if ([PicoConverter isPrimitive:ps.propertyType]) {
                            NSString *xmlValue = [childElement stringValue];
                            if (xmlValue.length > 0) {
                                id objValue = [PicoConverter read: xmlValue withType: ps.propertyType config:self.config];
                                if (objValue) {
                                    [value setValue: objValue forKey: ps.propertyName];
                                }
                            }
                        } else if ([ps.propertyType isEqualToString:PICO_TYPE_OBJECT]) { // object
                            id obj = [ps.clazz new];
                            [value setValue:obj forKey: ps.propertyName];
                            [self read: obj element: childElement];
                        }
                    } else if ([ps.propertyKind isEqualToString: PICO_KIND_ELEMENT_ARRAY]) {
                        NSMutableArray *array = [value valueForKey:ps.propertyName];
                        if (!array) {
                            array = [[NSMutableArray alloc] init];
                            [value setValue:array forKey: ps.propertyName];
                        }
                        // primitive
                        if ([PicoConverter isPrimitive: ps.propertyType]) {
                            NSString *xmlValue = [childElement stringValue];
                            if (xmlValue.length > 0) {
                                id objValue = [PicoConverter read:xmlValue withType:ps.propertyType config:self.config];
                                [array addObject: objValue];
                            }
                        } else if ([ps.propertyType isEqualToString:PICO_TYPE_OBJECT]) { // object
                            id obj = [ps.clazz new];
                            [array addObject:obj];
                            [self read: obj element: childElement];
                        }
                    }
                }
            }
        }
    }
}


-(void)readAnyElement:(id)value element:(GDataXMLElement *)element {
    PicoBindingSchema *bs = [PicoBindingSchema fromObject:value];
    
    // read xml any element
    PicoPropertySchema *anyPs = bs.anyElementSchema;
    if (anyPs) {
        if (anyPs.clazz) { // target class specified
            [self readAnyElement:value element:element bindClass:anyPs.clazz];
        } else {
            NSMutableArray *anyChildElements = [[NSMutableArray alloc] init];
            NSArray *children = [element children];
            
            NSDictionary *elementMap = bs.xml2ElementSchemaMapping;
            
            for(GDataXMLNode *node in children) {
                if ([node kind] == GDataXMLElementKind) {
                    if (elementMap.count == 0 || !elementMap[[node localName]]) {
                        PicoXMLElement *picoElement = [self convertToPicoElement:(GDataXMLElement *)node];
                        [anyChildElements addObject:picoElement];
                    }
                }
            }
            [value setValue:anyChildElements forKey: anyPs.propertyName];
        }
    }
}

-(BOOL)readAnyElement:(id)value element:(GDataXMLElement *)element bindClass:(Class) clazz {
    BOOL result = NO;
    PicoBindingSchema *bs = [PicoBindingSchema fromClass:clazz];
    PicoClassSchema *cs = [bs classSchema];;
    NSString *xmlName = cs.xmlName;
    if ([xmlName length] == 0) {
        xmlName = bs.className;
    }
    NSMutableArray *childElements = [[NSMutableArray alloc] init];
    NSArray *children = [element children];
    for(GDataXMLNode *node in children) {
        if ([node kind] == GDataXMLElementKind && [xmlName isEqualToString:[node localName]]) {
            [childElements addObject:node];
        }
    }
    if (childElements.count > 0) {
        
        PicoBindingSchema *bs = [PicoBindingSchema fromObject:value];
        
        // read xml any element
        PicoPropertySchema *anyPs = bs.anyElementSchema;
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [value setValue:array forKey: anyPs.propertyName];
        for(GDataXMLElement *childElement in childElements) {
            id obj = [clazz new];
            [array addObject:obj];
            [self read: obj element: childElement];
        }
        result = YES;
    }
    
    return result;
}

-(PicoXMLElement *)convertToPicoElement:(GDataXMLElement *)element {
    PicoXMLElement *picoElement = [[PicoXMLElement alloc] init] ;
    picoElement.name = element.localName;
    picoElement.nsUri = element.URI;
    if ([element childCount] == 1) {
        GDataXMLNode *node = (element.children)[0];
        if (node.kind == GDataXMLTextKind) {
            picoElement.value = node.stringValue;
        }
    }
    if (element.attributes) {
        NSMutableDictionary *attrDic = [[NSMutableDictionary alloc] init];
        picoElement.attributes = attrDic;
        for(GDataXMLNode *attr in element.attributes) {
            attrDic[attr.localName] = attr.stringValue;
        }
    }
    if (element.children) {
        NSMutableArray *childrenArray = [[NSMutableArray alloc] init];
        picoElement.children = childrenArray;
        for(GDataXMLNode *node in element.children) {
            if ([node kind] == GDataXMLElementKind) {
                PicoXMLElement *childPicoElement = [self convertToPicoElement:(GDataXMLElement *)node];
                childPicoElement.parent = picoElement;
                [childrenArray addObject: childPicoElement];
            }
        }
    }
    return picoElement;
}


-(id)fromString:(NSString *)string withClass:(Class)clazz {
    NSData *data = [string dataUsingEncoding: CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding((CFStringRef)self.config.encoding)) allowLossyConversion:NO];
    
    return [self fromData:data withClass:clazz];
}



@end
