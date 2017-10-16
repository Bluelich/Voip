//
//  NSObject+TypeEncodings.h
//  Pods
//
//  Created by zhouqiang on 16/10/2017.
//

#import <Foundation/Foundation.h>
/*
 1.C 的字符串被认为是一个实体，而不是指针。所以char *的编码不使用指针的编码 ^ 作为前置,而是用自己的编码 *
 2.BOOL 实质是 signed char (即使设置了 -funsigned-char 参数）,而不是int,因为 char 比 int 小,所以编码是 c
 3.直接传入 NSObject 将产生 #。但是传入 [NSObject class] 产生一个名为 NSObject 只有一个类字段的结构体。很明显，那就是 isa 字段，所有的 NSObject 实例都用它来表示自己的类型。
 @encode(typeof(NSObject)))        ->　{NSObject=#}
 @encode(typeof([NSObject class])) ->
 */
typedef NS_ENUM(NSUInteger, objc_encoding) {
    objc_encoding_char,             ///< c : A char
    objc_encoding_int,              ///< i : An int
    objc_encoding_short,            ///< s : A short
    objc_encoding_long,             ///< l : A long,treated as a 32-bit quantity on 64-bit programs.
    objc_encoding_longlong,         ///< q : A long long
    objc_encoding_unsignedchar,     ///< C : An unsigned char
    objc_encoding_unsignedint,      ///< I : An unsigned int
    objc_encoding_unsignedshort,    ///< S : An unsigned short
    objc_encoding_unsignedlong,     ///< L : An unsigned long
    objc_encoding_unsignedlonglong, ///< Q : An unsigned long long
    objc_encoding_float,            ///< f : A float
    objc_encoding_double,           ///< d : A double
    objc_encoding_bool,             ///< B : A C++ bool or a C99 _Bool
    objc_encoding_void,             ///< v : A void
    objc_encoding_cString,          ///< * : A character string (char *)
    objc_encoding_object,           ///< @ : An object (whether statically typed or typed id)
    objc_encoding_class,            ///< # : A class object (Class)
    objc_encoding_sel,              ///< :  : A method selector (SEL)
    objc_encoding_array,            ///< [array type] : An array (e.g. {NSObject=#} -> [NSObject])
    objc_encoding_struct,           ///< {name=type...} : A structure
    objc_encoding_union,            ///< (name=type...) : A union
    objc_encoding_bnum,             ///< bnum : A bit field of num bits
    objc_encoding_pointer_to_type,  ///< ^type : A pointer to type (e.g. ^f -> float *)
    objc_encoding_unknow,           ///< ?  An unknown type (among other things, this code is used for function pointers)
};

typedef NS_OPTIONS(NSUInteger, EncodingType) {
    EncodingTypeMask       = 0xFF, ///< mask of type value
    EncodingTypeUnknown    = 0, ///< unknown
    EncodingTypeVoid       = 1, ///< void
    EncodingTypeBool       = 2, ///< bool
    EncodingTypeInt8       = 3, ///< char / BOOL
    EncodingTypeUInt8      = 4, ///< unsigned char
    EncodingTypeInt16      = 5, ///< short
    EncodingTypeUInt16     = 6, ///< unsigned short
    EncodingTypeInt32      = 7, ///< int
    EncodingTypeUInt32     = 8, ///< unsigned int
    EncodingTypeInt64      = 9, ///< long long
    EncodingTypeUInt64     = 10, ///< unsigned long long
    EncodingTypeFloat      = 11, ///< float
    EncodingTypeDouble     = 12, ///< double
    EncodingTypeLongDouble = 13, ///< long double
    EncodingTypeObject     = 14, ///< id
    EncodingTypeClass      = 15, ///< Class
    EncodingTypeSEL        = 16, ///< SEL
    EncodingTypeBlock      = 17, ///< block
    EncodingTypePointer    = 18, ///< void*
    EncodingTypeStruct     = 19, ///< struct
    EncodingTypeUnion      = 20, ///< union
    EncodingTypeCString    = 21, ///< char*
    EncodingTypeCArray     = 22, ///< char[10] (for example)
    
    EncodingTypeQualifierMask   = 0xFF00,   ///< mask of qualifier
    EncodingTypeQualifierConst  = 1 << 8,  ///< const
    EncodingTypeQualifierIn     = 1 << 9,  ///< in
    EncodingTypeQualifierInout  = 1 << 10, ///< inout
    EncodingTypeQualifierOut    = 1 << 11, ///< out
    EncodingTypeQualifierBycopy = 1 << 12, ///< bycopy
    EncodingTypeQualifierByref  = 1 << 13, ///< byref
    EncodingTypeQualifierOneway = 1 << 14, ///< oneway
    
    EncodingTypePropertyMask         = 0xFF0000, ///< mask of property
    EncodingTypePropertyReadonly     = 1 << 16, ///< readonly
    EncodingTypePropertyCopy         = 1 << 17, ///< copy
    EncodingTypePropertyRetain       = 1 << 18, ///< retain
    EncodingTypePropertyNonatomic    = 1 << 19, ///< nonatomic
    EncodingTypePropertyWeak         = 1 << 20, ///< weak
    EncodingTypePropertyCustomGetter = 1 << 21, ///< getter=
    EncodingTypePropertyCustomSetter = 1 << 22, ///< setter=
    EncodingTypePropertyDynamic      = 1 << 23, ///< @dynamic
};

EncodingType EncodingGetType(const char *encodingType);

@interface NSObject (TypeEncodings)

@end
