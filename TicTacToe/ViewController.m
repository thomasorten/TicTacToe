//
//  ViewController.m
//  TicTacToe
//
//  Created by Orten, Thomas on 15.05.14.
//  Copyright (c) 2014 Orten, Thomas. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *myLabelOne;
@property (weak, nonatomic) IBOutlet UILabel *myLabelTwo;
@property (weak, nonatomic) IBOutlet UILabel *myLabelThree;
@property (weak, nonatomic) IBOutlet UILabel *myLabelFour;
@property (weak, nonatomic) IBOutlet UILabel *myLabelFive;
@property (weak, nonatomic) IBOutlet UILabel *myLabelSix;
@property (weak, nonatomic) IBOutlet UILabel *myLabelSeven;
@property (weak, nonatomic) IBOutlet UILabel *myLabelEight;
@property (weak, nonatomic) IBOutlet UILabel *myLabelNine;
@property (weak, nonatomic) IBOutlet UILabel *whichPlayerLabel;
@property (weak, nonatomic) NSString *lastPlayer;
@property (weak, nonatomic) NSString *theWinner;
@property (strong, nonatomic) NSArray *board;
@property (strong, nonatomic) NSMutableArray *boardArray;
- (NSString *)whoWon:(NSNumber *)row :(NSNumber *)col :(NSString *)piece;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.theWinner = @"X";
    [self startGame];
}

- (void)startGame
{
    self.lastPlayer = nil;
    self.whichPlayerLabel.text = self.theWinner;
    self.boardArray = [[NSMutableArray alloc] init];
    self.board = [[NSArray alloc] initWithObjects:
                  @[self.myLabelOne, self.myLabelTwo, self.myLabelThree],
                  @[self.myLabelFour, self.myLabelFive, self.myLabelSix],
                  @[self.myLabelSeven, self.myLabelEight, self.myLabelNine], nil];
    for (int x = 0; x < self.board.count; x++) {
        for (int y = 0; y < self.board.count; y++) {
            UILabel *label = self.board[x][y];
            label.text = @"";
        }
    }
}

- (NSString *)whoWon:(NSNumber *)row :(NSNumber *)col :(NSString *)piece
{
    int xPos = [row intValue];
    int yPos = [col intValue];

    NSString *winner = nil;

    // check current row
    bool w = YES;
    for (int x = 0; x < 3; x++) {
        UILabel *aLabel = self.board[xPos][x];
        NSString *aLabelValue = aLabel.text;
        NSLog(@"%@", aLabelValue);
        w = w && aLabelValue != nil && ([aLabelValue isEqualToString:piece]);
    }
    if (w) { winner = piece; }

    // check current column
    w = YES;
    for (int x = 0; x < 3; x++) {
        UILabel *aLabel = self.board[x][yPos];
        NSString *aLabelValue = aLabel.text;
        w = w && aLabelValue != nil && ([aLabelValue isEqualToString:piece]);
    }
    if (w) { winner = piece; }

    // check 0,0 diagonal
    w = YES;
    for (int x = 0; x < 3; x++) {
        UILabel *aLabel = self.board[x][x];
        NSString *aLabelValue = aLabel.text;
        w = w && aLabelValue != nil && ([aLabelValue isEqualToString:piece]);
    }
    if (w) { winner = piece; }

    // check 0,2 diagonal
    w = YES;
    for (int x = 0; x < 3; x++) {
        UILabel *aLabel = self.board[x][2 - x];
        NSString *aLabelValue = aLabel.text;
        w = w && aLabelValue != nil && ([aLabelValue isEqualToString:piece]);
    }
    if (w) { winner = piece; }

    return winner;
}

- (NSDictionary *)findLabelUsingPoint:(CGPoint)point
{
    NSDictionary *foundLabel;
    for (int x = 0; x < self.board.count; x++) {
        for (int y = 0; y < self.board.count; y++) {
            UILabel *label = self.board[x][y];
            if (CGRectContainsPoint(label.frame, point)) {
                NSNumber *xPos = [NSNumber numberWithInt:x];
                NSNumber *yPos = [NSNumber numberWithInt:y];
                foundLabel = [NSDictionary dictionaryWithObjectsAndKeys:
                   label, @"label",
                   xPos, @"x",
                   yPos, @"y", nil];
                break;
            }
        }
    }
    return foundLabel;
}

-(IBAction)onLabelTapped:(UITapGestureRecognizer *)tapGesture
{
    CGPoint point;
    point = [tapGesture locationInView:nil];
    NSDictionary *labelDict = [self findLabelUsingPoint:point];
    UILabel *label = [labelDict objectForKey: @"label"];
    NSNumber *x = [labelDict objectForKey: @"x"];
    NSNumber *y = [labelDict objectForKey: @"y"];

    NSString *playerX = @"X";
    NSString *playerO = @"O";

    if (label != nil && [label.text isEqualToString:@""]) {

        if ([self.boardArray.lastObject isEqualToString:playerX]) {
            label.textColor = [UIColor redColor];
            self.lastPlayer = playerX;
            [self.boardArray addObject:playerO];
        } else {
            label.textColor = [UIColor blueColor];
            self.lastPlayer = playerO;
            [self.boardArray addObject:playerX];
        }

        self.whichPlayerLabel.text = self.lastPlayer;
        label.text = self.boardArray.lastObject;

        if ([self.boardArray count] >= 9) {
            self.whichPlayerLabel.text = @"";
        }

        if ([self whoWon:x :y :label.text]) {
            self.theWinner = label.text;
            UIAlertView *alert = [[UIAlertView alloc] init];
            alert.title = @"We have a winner";
            alert.message = label.text;
            [alert addButtonWithTitle:@"Start again"];
            alert.delegate = self;
            [alert show];
        }

    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self startGame];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
