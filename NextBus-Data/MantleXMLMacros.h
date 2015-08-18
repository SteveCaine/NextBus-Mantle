//
//  MantleXMLMacros.h
//  NextBus-Mantle
//
//	shorthand macros for Mantle's +XMLKeyPathsByPropertyKey
//	mapping an object's properties to data in the incoming XML stream
//	where the property name matches the XML elem/attribute name
//
//  Created by Steve Caine on 06/21/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#ifndef NextBus_Mantle_MantleXMLMacros_h
#define NextBus_Mantle_MantleXMLMacros_h

// key = property name, value = content of xml element => @"s" : @"s/text()"
#define PROPERTY_FROM_XML_CONTENT(s)			@#s : @#s"/text()"

// key = property name, value = xml attribute name => @"s" : @"@s"
#define PROPERTY_FROM_XML_ATTRIBUTE(s)			@#s : @"@"#s

// key = property name, value = xml child name => @"s" : @"s"
#define PROPERTY_FROM_XML_CHILD(s)				@#s : @#s

// key = property name, value = xml child attribute => @"s" : @"c/@s/text()"
#define PROPERTY_FROM_XML_CHILD_ATTRIBUTE(s,c)	@#s : @#c"/@"#s

#endif
