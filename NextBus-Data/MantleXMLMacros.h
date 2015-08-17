//
//  MantleXMLMacros.h
//  NextBus-Mantle
//
//  Created by Steve Caine on 06/21/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#ifndef NextBus_Mantle_MantleXMLMacros_h
#define NextBus_Mantle_MantleXMLMacros_h

// key = property name, value = content of xml element => @"s" : @"s/text()"
#define PROPERTY_FROM_XML_CONTENT(s)	@#s : @#s"/text()"

// key = property name, value = xml attribute name => @"s" : @"@s"
#define PROPERTY_FROM_XML_ATTRIBUTE(s)	@#s : @"@"#s

// key = property name, value = xml child name => @"s" : @"s"
#define PROPERTY_FROM_XML_CHILD(s)		@#s : @#s

#endif
