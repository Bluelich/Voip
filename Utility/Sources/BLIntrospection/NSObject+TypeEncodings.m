//
//  NSObject+TypeEncodings.m
//  Pods
//
//  Created by zhouqiang on 16/10/2017.
//

#import "NSObject+TypeEncodings.h"

NSComparisonResult cString_compare(const char *s1, const char *s2){
    int result = strcmp(s1, s2);
    if (result == 0) {
        return NSOrderedSame;
    }else if (result < 0) {
        return NSOrderedAscending;
    }else{
        return NSOrderedDescending;
    }
}
/*
 ************************************
 Property Type String
 
 R : The property is read-only (readonly).
 C : The property is a copy of the value last assigned (copy).
 & : The property is a reference to the value last assigned (retain).
 N : The property is non-atomic (nonatomic).
 G<name> : The property defines a custom getter selector name. The name follows the G (for example, GcustomGetter,).
 S<name> : The property defines a custom setter selector name. The name follows the S (for example, ScustomSetter:,).
 D : The property is dynamic (@dynamic).
 W : The property is a weak reference (__weak).
 P : The property is eligible for garbage collection.
 t<encoding> : Specifies the type using old-style encoding.
 */

EncodingType objc_getMethodEncoding(const char *cString){
    char *type = (char *)cString;
    if (!type) {
        return EncodingTypeUnknown;
    }
    size_t len = strlen(type);
    if (len == 0) {
        return EncodingTypeUnknown;
    }
    switch (*type) {
        case 'n':
            return EncodingTypeQualifierIn;
        case 'N':
            return EncodingTypeQualifierInout;
        case 'o':
            return EncodingTypeQualifierOut;
        case 'O':
            return EncodingTypeQualifierBycopy;
        case 'r':
            return EncodingTypeQualifierConst;
        case 'R':
            return EncodingTypeQualifierByref;
        case 'V':
            return EncodingTypeQualifierOneway;
        default:
            return EncodingTypeQualifierMask;
    }
}

EncodingType EncodingGetType(const char *encodingType) {
    char *type = (char *)encodingType;
    if (!type) return EncodingTypeUnknown;
    size_t len = strlen(type);
    if (len == 0) return EncodingTypeUnknown;
    
    //https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
    EncodingType qualifier = 0;
    bool prefix = true;
    while (prefix) {
        switch (*type) {
            case 'r': {
                qualifier |= EncodingTypeQualifierConst;
                type++;
            } break;
            case 'n': {
                qualifier |= EncodingTypeQualifierIn;
                type++;
            } break;
            case 'N': {
                qualifier |= EncodingTypeQualifierInout;
                type++;
            } break;
            case 'o': {
                qualifier |= EncodingTypeQualifierOut;
                type++;
            } break;
            case 'O': {
                qualifier |= EncodingTypeQualifierBycopy;
                type++;
            } break;
            case 'R': {
                qualifier |= EncodingTypeQualifierByref;
                type++;
            } break;
            case 'V': {
                qualifier |= EncodingTypeQualifierOneway;
                type++;
            } break;
            default: {
                prefix = false;
            } break;
        }
    }
    
    len = strlen(type);
    if (len == 0) return EncodingTypeUnknown | qualifier;
    switch (*type) {
        case 'v': return EncodingTypeVoid       | qualifier;
        case 'B': return EncodingTypeBool       | qualifier;
        case 'c': return EncodingTypeInt8       | qualifier;
        case 'C': return EncodingTypeUInt8      | qualifier;
        case 's': return EncodingTypeInt16      | qualifier;
        case 'S': return EncodingTypeUInt16     | qualifier;
        case 'i': return EncodingTypeInt32      | qualifier;
        case 'I': return EncodingTypeUInt32     | qualifier;
        case 'l': return EncodingTypeInt32      | qualifier;
        case 'L': return EncodingTypeUInt32     | qualifier;
        case 'q': return EncodingTypeInt64      | qualifier;
        case 'Q': return EncodingTypeUInt64     | qualifier;
        case 'f': return EncodingTypeFloat      | qualifier;
        case 'd': return EncodingTypeDouble     | qualifier;
        case 'D': return EncodingTypeLongDouble | qualifier;
        case '#': return EncodingTypeClass      | qualifier;
        case ':': return EncodingTypeSEL        | qualifier;
        case '*': return EncodingTypeCString    | qualifier;
        case '^': return EncodingTypePointer    | qualifier;
        case '[': return EncodingTypeCArray     | qualifier;
        case '(': return EncodingTypeUnion      | qualifier;
        case '{': return EncodingTypeStruct     | qualifier;
        case '@': {
            if (len == 2 && *(type + 1) == '?')
                return EncodingTypeBlock        | qualifier;
            else
                return EncodingTypeObject       | qualifier;
        }
        default: return EncodingTypeUnknown     | qualifier;
    }
}
NSString *NSStringFromEncodingType(EncodingType type){
    switch (type) {
        case EncodingTypeMask:
            return @"mask of type value";
        case EncodingTypeUnknown:
            return @"unknown";
        case EncodingTypeVoid:
            return @"void";
        case EncodingTypeBool:
            return @"bool";
        case EncodingTypeInt8:
            return @"char or BOOL";
        case EncodingTypeUInt8:
            return @"unsigned char";
        case EncodingTypeInt16:
            return @"short";
        case EncodingTypeUInt16:
            return @"unsigned short";
        case EncodingTypeInt32:
            return @"int";
        case EncodingTypeUInt32:
            return @"unsigned int";
        case EncodingTypeInt64:
            return @"long long";
        case EncodingTypeUInt64:
            return @"unsigned long long";
        case EncodingTypeFloat:
            return @"float";
        case EncodingTypeDouble:
            return @"double";
        case EncodingTypeLongDouble:
            return @"long double";
        case EncodingTypeObject:
            return @"id";
        case EncodingTypeClass:
            return @"Class";
        case EncodingTypeSEL:
            return @"SEL";
        case EncodingTypeBlock:
            return @"block";
        case EncodingTypePointer:
            return @"void*";
        case EncodingTypeStruct:
            return @"struct";
        case EncodingTypeUnion:
            return @"union";
        case EncodingTypeCString:
            return @"char*";
        case EncodingTypeCArray:
            return @"c type array(e.g. char[10])";
        case EncodingTypeQualifierMask:
            return @"mask of qualifier";
        case EncodingTypeQualifierConst:
            return @"const";
        case EncodingTypeQualifierIn:
            return @"in";
        case EncodingTypeQualifierInout:
            return @"inout";
        case EncodingTypeQualifierOut:
            return @"out";
        case EncodingTypeQualifierBycopy:
            return @"bycopy";
        case EncodingTypeQualifierByref:
            return @"byref";
        case EncodingTypeQualifierOneway:
            return @"oneway";
        case EncodingTypePropertyMask:
            return @"mask of property";
        case EncodingTypePropertyReadonly:
            return @"readonly";
        case EncodingTypePropertyCopy:
            return @"copy";
        case EncodingTypePropertyRetain:
            return @"retain";
        case EncodingTypePropertyNonatomic:
            return @"nonatomic";
        case EncodingTypePropertyWeak:
            return @"weak";
        case EncodingTypePropertyCustomGetter:
            return @"getter=";
        case EncodingTypePropertyCustomSetter:
            return @"setter=";
        case EncodingTypePropertyDynamic:
            return @"@dynamic";
    }
}
@implementation NSObject (TypeEncodings)
@end
