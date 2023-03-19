#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NFCConstants.h"
#import "NFCNDEFReader.h"
#import "NFCNDEFWriter.h"
#import "NFCReader.h"
#import "NFCReaderDelegate.h"
#import "NFCReaderWriter.h"
#import "NFCTagReader.h"

FOUNDATION_EXPORT double NFCReaderWriterVersionNumber;
FOUNDATION_EXPORT const unsigned char NFCReaderWriterVersionString[];

