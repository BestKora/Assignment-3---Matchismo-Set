//
//  SetCard.h
//  Matchismo3
//
//  Created by Tatiana Kornilova on 11/12/13.
//  Copyright (c) 2013 Tatiana Kornilova. All rights reserved.
//

#import "Card.h"

// Каждая карта в Set имеет:

// number   - 1, 2, 3
// symbol   - ромб, волна, овал (diamond, squiggle, oval)
// shading  - закрашенная, штрихованная или без текстуры (solid, striped, open)
// color    - красный, зеленый, фиолетовый (red, green, purple)

@interface SetCard : Card

@property (nonatomic) NSUInteger number;
@property (nonatomic,strong) NSString *symbol;
@property (nonatomic,strong) NSString *shading;
@property (nonatomic,strong) NSString *color;

+(NSArray *)validSymbols;
+(NSArray *)validShadings;
+(NSArray *)validColors;
+(NSUInteger)maxNumber;
@end
