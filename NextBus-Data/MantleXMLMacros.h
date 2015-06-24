//
//  MantleXMLMacros.h
//  NextBus-Mantle
//
//  Created by Steve Caine on 06/21/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#ifndef NextBus_Mantle_MantleXMLMacros_h
#define NextBus_Mantle_MantleXMLMacros_h

// key = property name, value = xml attribute name
#define PROPERTY_FROM_XML_ATTRIBUTE(s)	@#s : @"@"#s

// key = property name, value = xml child name
#define PROPERTY_FROM_XML_CHILD(s)		@#s : @#s

#endif
