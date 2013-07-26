//
//  JSEngine.h
//  MailCheck
//
//  Created by Jesly Varghese on 7/25/13.
//  Copyright (c) 2013 Jesly Varghese. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
/* JS Engine will deal with loading of any generic JSLibrary file
 and executing any JS script with that library */

@interface GloblinJS : NSObject
+ (JSContextRef)JSContextForLibrary:(NSString*)libraryName;
+ (JSValueRef)valueForScript:(NSString*)jScript compileWithLibraryContext:(JSContextRef)libraryContext;
+ (NSString*)JSONStringForValue:(JSValueRef)jsValue forLibraryContext:(JSContextRef)context;

  // TODO:: Possible use case of using JSObject directly and translating them to CF/NS objects? What will be the advantages?
+ (JSValueRef)valueForProperty:(NSString*)propertyName inJSObject:(JSObjectRef)jsObjectRef forLibraryContext:(JSContextRef)context;
+ (JSObjectRef)objectForValue:(JSValueRef)jsValue forLibraryContext:(JSContextRef)libraryContext;
@end
