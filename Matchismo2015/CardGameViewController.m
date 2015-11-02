//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Tatiana Kornilova on 11/2/13.
//  Copyright (c) 2013 Tatiana Kornilova. All rights reserved.
//

#import "CardGameViewController.h"
#import "HistoryViewController.h"
#import "GameResult.h"

@interface CardGameViewController ()

@property (strong, nonatomic) Deck *deck;
@property (nonatomic,strong) CardMatchingGame *game;

@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;

@property (strong,nonatomic) NSMutableArray *flipsHistory;

@property (strong, nonatomic) GameResult *gameResult;

@end

@implementation CardGameViewController

- (GameResult *)gameResult
{
    if (!_gameResult) _gameResult = [[GameResult alloc] init];
    _gameResult.gameName = [self gameName];
    
    return _gameResult;
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]];
    _game.numberOfMatches =[self numberOfMatches];
    _game.gameName = [self gameName];
    return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        
        [self updateCardButton:cardButton usingCard:(Card *)card];
        cardButton.enabled = !card.isMatched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
    [self updateFlipResult];
    
}

- (Deck *)deck
{
    if (!_deck) _deck = [self createDeck];
    return _deck;
}
 - (Deck *)createDeck   //abstract
{
    return nil;
}
- (NSUInteger)numberOfMatches //abstract
{
    return 0;
}

- (NSString *)gameName //abstract
{
    return nil;
}

-(void)updateCardButton:(UIButton *)cardButton usingCard:(Card *)card //abstract
{
    // Abstract метод для того, чтобы добавить image, представлящий обратную сторону карты
    // и решить, является ли выбранная карта higlighted
}

- (NSAttributedString *)textForSingleCard:(Card *)card //abstract
{
    // Abstract метод для возврата текста для текста метки результата self.resultsLabel.text
    // если вы управляете одной картой
    return nil;
}

- (NSAttributedString *)attributedCardsDescription:(NSArray *)cards  //abstract
{
    return nil;
}

- (NSMutableArray *)flipsHistory
{
    if (!_flipsHistory)_flipsHistory = [[NSMutableArray alloc] init];
    return _flipsHistory;
}

- (IBAction)Deal {
    self.game = nil;
    self.flipCount =0;
    self.flipsHistory =nil;
    self.gameResult = nil;
    [self updateUI];
}


- (IBAction)touchCardButton:(UIButton *)sender
{
    NSUInteger cardIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:cardIndex];
    self.flipCount++;
    self.gameResult.score = self.game.score;
    [self updateUI];
}


-(void)updateFlipResult
{
    NSString *text=@" ";
    NSMutableAttributedString *textResult=[[NSMutableAttributedString alloc] init];
    if ([self.game.matchedCards  count]>0)
    {
        if ([self.game.matchedCards count] == [self numberOfMatches])
        {
           [textResult appendAttributedString:
                         [self attributedCardsDescription:self.game.matchedCards]];
            if (self.game.lastFlipPoints<0) {
                text = [text stringByAppendingString:
                        [NSString stringWithFormat:
                                 @"✘ %ld penalty",(long)self.game.lastFlipPoints]];
            } else {
                text = [text stringByAppendingString:
                        [NSString stringWithFormat:
                                  @"✔ +%ld bonus",(long)self.game.lastFlipPoints]];
            }
            
        } else textResult = [[NSMutableAttributedString alloc] initWithAttributedString:
                             [self textForSingleCard:[self.game.matchedCards lastObject]]];
        
        [textResult appendAttributedString:[[NSAttributedString alloc] initWithString:text]];
        self.resultsLabel.attributedText = textResult;
        [self.flipsHistory addObject:textResult];
    } else
        self.resultsLabel.attributedText= [[NSAttributedString alloc] initWithString:@"Play game!"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show history"]) {
        if ([segue.destinationViewController isKindOfClass:[HistoryViewController class]]) {
            HistoryViewController *hsvc = (HistoryViewController *)segue.destinationViewController;
            hsvc.flipsHistory = self.flipsHistory;
        }
    }
    
}
@end
