NextBus-Mantle
==============

***NOTE:*** *NextBus has discontinued support for the MBTA transit agency. Thus all methods called by 'Make Request' table rows just return errors. The project remains useful only in demonstrating code to parse the XML responses this service used to return for the MBTA, using files captured when the service was still active. (updated Nov. 5, 2020)*

*Also, the T-Alerts service this project has been replaced with an entirely different service that this project does not implement. Again, this project is only useful for demonstrating how to parse the responses this service used to provide.*

This repository demonstrates how to use MantleXMLAdapter, an addition to the popular Objective-C model framework Mantle, to parse XML responses from NextBus, Inc., an RESTful web service that *used to track* the MBTA bus system, as well as the MBTA's *now discontinued* service alerts ('T-Alerts') RSS feed.

It also implements a block-based system to make requests to this web service, with caching, using the popular AFNetworking framework. 

The demo app offers two options:

* Request methods to get XML data from NextBus, with optional caching, and use it to populate custom Objective-C data classes. 

* Parse methods to read similar XML files from the app's bundle, to provide a simpler means to track the implementation of XML parsing and data object population using Mantle and MantleXMLAdapter. 

Mantle itself is designed to translate JSON into objects (and the reverse). MantleXMLAdapter extends this to translate data in the next most popular format, XML.

This code uses CocoaPods to manage all third-party frameworks except MantleXMLAdapter in the Pods project, which is included in the app project.

It also uses code from several other repositories of mine on GitHub, to provide debug-build logging that falls silent in release builds, and to provide some simple file utilities to manage the XML files stored in the app bundle. This requires those repositories be cloned into the same directory as this repo. 

To simplify this, my [unix-scripts](https://github.com/SteveCaine/unix-scripts) repository includes a 'cloneall' script to download all my public repositories to the current folder; the script contains detailed instructions on its use. 

**To use this code**, launch the app and tap any row in either the two sections of the table presented. Each will execute a single operation (either requesting new data or parsing cached/bundle data) and display a Success/Failed messagse in the table cell. Detailed information about the response is written to the Xcode debugger's console. *See note above that this service has been discontinued.*

Rows in the first section -- "**Make Request**" create a 'request' object that is responsible for making the request and holding the response data. This pattern allows the request object to look for XML files saved from previous requests, and use those in place of a new request if the file is younger than a 'stale age' specified by each request class.

Rows in the second section -- "**Parse File**" -- reads the named bundle XML file and populates the appropriate object with its data.

This code is distributed under the terms of the MIT license. See file "LICENSE" in this repository for details.

Copyright (c) 2015-16 Steve Caine.<br>
@SteveCaine on github.com
