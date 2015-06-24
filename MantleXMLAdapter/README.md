# Mantle XML Adapter

This repository started as a fork of the excellent [Mantle](https://github.com/github/Mantle) framework and added a MTLXMLAdapter  and some XML specific NSValueTransformer utility functions. This allows you to use XML data to create Mantle model instances in addition to the builtin JSON support.

The new additions can be found in these files:
 * [MTLXMLAdapter.h](https://github.com/mbaranowski/MantleXMLAdapter/blob/master/Mantle/MTLXMLAdapter.h)
 * [MTLXMLAdapter.m](https://github.com/mbaranowski/MantleXMLAdapter/blob/master/Mantle/MTLXMLAdapter.m)
 * [NSValueTransformer+MTLXMLTransformerAdditions.h](https://github.com/mbaranowski/MantleXMLAdapter/blob/master/Mantle/NSValueTransformer%2BMTLXMLTransformerAdditions.h)
 * [NSValueTransformer+MTLXMLTransformerAdditions.m](https://github.com/mbaranowski/MantleXMLAdapter/blob/master/Mantle/NSValueTransformer%2BMTLXMLTransformerAdditions.m)

This is best used a [Cocoapod](http://cocoapods.org) that pulls in just the files above, and has Mantle and KISSXML as a dependency.

There is very basic support for serializing Mantle model instances into XML, provided that the user manually constructs the DDXMLElement node tree by implementing serializeToXMLElement. Some examples of current usage can be found in these test files:

 * [MTLTestModelXML.h](https://github.com/mbaranowski/MantleXMLAdapter/blob/master/MantleTests/MTLTestModelXML.h)
 * [MTLTestModelXML.m](https://github.com/mbaranowski/MantleXMLAdapter/blob/master/MantleTests/MTLTestModelXML.m)
 * [MTLXMLAdapterSpec.m](https://github.com/mbaranowski/MantleXMLAdapter/blob/master/MantleTests/MTLXMLAdapterSpec.m)
 
## License

Mantle XML Adapter is released under the MIT license, like Mantle itself, See
[LICENSE.md](https://github.com/github/Mantle/blob/master/LICENSE.md).
