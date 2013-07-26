//
//  JSEngine.m
//  MailCheck
//
//  Created by Jesly Varghese on 7/25/13.
//  Copyright (c) 2013 Jesly Varghese. All rights reserved.
//
#define JSON_INDENTATION_LEVEL 2
#import "GloblinJS.h"

@implementation GloblinJS

  //TODO: Memory management and Raise exception instead of logging 
/* Create a context for the JS Library */
+ (JSContextRef)JSContextForLibrary:(NSString*)libraryName
{
  JSContextRef libraryContext = JSGlobalContextCreate(NULL);
  if (libraryName) {
    NSError *fileError = nil;
    NSString *filePath = [[NSBundle mainBundle]pathForResource:libraryName ofType:@"js"];
    NSString *libContentString  = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&fileError];
    JSStringRef libJSString = JSStringCreateWithCFString((__bridge CFStringRef)(libContentString));
    JSValueRef exception = NULL;
    JSEvaluateScript(libraryContext, libJSString, NULL, NULL, 0, &exception);
    if (exception) {
      JSStringRef exceptionString = JSValueToStringCopy(libraryContext, exception, NULL);
      NSLog(@"Exception: %@",(__bridge_transfer NSString*)(JSStringCopyCFString(kCFAllocatorDefault, exceptionString)));
      JSStringRelease(exceptionString);
    }
    JSStringRelease(libJSString);
  }
  return libraryContext;
}
/* Execute a JS Snippet and return the result object */
+ (JSValueRef)valueForScript:(NSString*)jScript compileWithLibraryContext:(JSContextRef)libraryContext;
{
  JSStringRef scriptString = JSStringCreateWithCFString((__bridge CFStringRef)(jScript));
  JSValueRef exception = NULL;
  JSValueRef executionValue = JSEvaluateScript(libraryContext, scriptString, NULL, NULL, 0, &exception);
  if (exception) {
    JSStringRef exceptionString = JSValueToStringCopy(libraryContext, exception, NULL);
    NSLog(@"Exception: %@",(__bridge_transfer NSString*)(JSStringCopyCFString(kCFAllocatorDefault, exceptionString)));
  }
  return executionValue;
}
/* Obtain Value Out of JSProperty */
+ (JSValueRef)valueForProperty:(NSString*)propertyName inJSObject:(JSObjectRef)jsObjectRef forContext:(JSContextRef)context
{
  JSValueRef errorObj = NULL;
  JSStringRef propertyNameJSString = JSStringCreateWithCFString((__bridge CFStringRef)(propertyName));
  JSValueRef value = JSObjectGetProperty(context, jsObjectRef, propertyNameJSString, &errorObj);
  if (errorObj) {
    JSStringRef exceptionString = JSValueToStringCopy(context, errorObj, NULL);
    NSLog(@"Exception: %@",(__bridge_transfer NSString*)(JSStringCopyCFString(kCFAllocatorDefault, exceptionString)));
    JSStringRelease(exceptionString);
  }
  return value;
}

/* Translate JS Value to JSON String */
+ (NSString*)JSONStringForValue:(JSValueRef)jsValue inContext:(JSContextRef)context
{
  JSValueRef exception = NULL;
  JSStringRef jsonString = JSValueCreateJSONString(context, jsValue, JSON_INDENTATION_LEVEL, &exception);
  if (exception) {
    JSStringRef exceptionString = JSValueToStringCopy(context, exception, NULL);
    NSLog(@"Exception: %@",(__bridge_transfer NSString*)(JSStringCopyCFString(kCFAllocatorDefault, exceptionString)));
    JSStringRelease(exceptionString);
  }
  return (__bridge_transfer NSString*)(JSStringCopyCFString(kCFAllocatorDefault, jsonString));
}

@end
