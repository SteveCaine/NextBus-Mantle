//
//  Debug_KissXML.m
//	NextBus-Mantle
//
//  Created by Steve Caine on 07/13/15.
//
//	This code is distributed under the terms of the MIT license.
//
//	Copyright (c) 2015 Steve Caine.
//

//#import <Foundation/Foundation.h>

#import "Debug_KissXML.h"

#import "DDXMLNode.h"
#import "NSString+DDXML.h"

#import "Debug_iOS.h"

// ----------------------------------------------------------------------

static NSString * const kinds[] = {
	@"(inval)",
	@"doc",
	@"elem",
	@"attr",
	@"namespace",
	@"instruct",
	@"comment",
	@"text",
	@"dtd",
	@"entity-dec",
	@"attr-dec",
	@"elem-dec",
	@"note-dec",
};
NSUInteger num_kinds = sizeof(kinds)/sizeof(kinds[0]);

// ----------------------------------------------------------------------

void d_DDXMLNode(DDXMLNode* node) {
	if (node) {
		static int deep = 0;
		
		DDXMLNodeKind kind = node.kind;
		NSString *str_kind = (kind < num_kinds ? kinds[kind] : @"?");
//		MyLog(@"%2i: (%@) name = '%@', %lu kid(s), path = '%@'", deep, str_kind, node.name, node.childCount, node.XPath);
		MyLog(@"(%@) name = '%@', %lu kid(s), path = '%@'", str_kind, node.name, node.childCount, node.XPath);
		
//		MyLog(@"\tstringValue = '%@'", node.stringValue);
//		MyLog(@"\t  XMLString = '%@'", node.XMLString);
		
		return;
		
		for (DDXMLNode * child in node.children) {
			++deep;
			d_DDXMLNode(child);
			--deep;
		}
		
	}
}

// ----------------------------------------------------------------------
