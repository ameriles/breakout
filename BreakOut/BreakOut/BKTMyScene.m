//
//  BKTMyScene.m
//  BreakOut
//
//  Created by Agustin on 07/08/14.
//  Copyright (c) 2014 Agustin. All rights reserved.
//

#import "BKTMyScene.h"

static NSString* ballCategoryName = @"ball";
static NSString* paddleCategoryName = @"paddle";
static NSString* blockCategoryName = @"block";
static NSString* blockNodeCategoryName = @"blockNode";

@implementation BKTMyScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"bg"];
        background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        
        [self addChild:background];
        
        self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
        
        SKPhysicsBody *borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody = borderBody;
        self.physicsBody.friction = 0.0f;
        
        SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
        ball.name = ballCategoryName;
        ball.position = CGPointMake(self.frame.size.width/3, self.frame.size.height/3);
        [self addChild:ball];
        
        ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.frame.size.width/2];
        ball.physicsBody.friction = 0.0f;
        ball.physicsBody.restitution = 1.0f;
        ball.physicsBody.linearDamping = 0.0f;
        ball.physicsBody.allowsRotation = NO;
        [ball.physicsBody applyImpulse:CGVectorMake(10.0f, -10.0f)];
        
        SKSpriteNode *paddle = [SKSpriteNode spriteNodeWithImageNamed:@"paddle"];
        paddle.name = paddleCategoryName;
        paddle.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height * 0.15f);
        [self addChild:paddle];
        
        paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:paddle.frame.size];
        paddle.physicsBody.restitution = 0.1f;
        paddle.physicsBody.friction = 0.4f;
        paddle.physicsBody.dynamic = NO;
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    
    SKPhysicsBody *body = [self.physicsWorld bodyAtPoint:touchLocation];
    if (body && [body.node.name isEqualToString: paddleCategoryName]) {
        NSLog(@"Began touch on paddle");
        self.isFingerOnPaddle = YES;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.isFingerOnPaddle) {
        UITouch* touch = [touches anyObject];
        CGPoint touchLocation = [touch locationInNode:self];
        CGPoint previousLocation = [touch previousLocationInNode:self];
        
        SKSpriteNode* paddle = (SKSpriteNode*)[self childNodeWithName: paddleCategoryName];
        
        int paddleX = paddle.position.x + (touchLocation.x - previousLocation.x);
        
        paddleX = MAX(paddleX, paddle.size.width/2);
        paddleX = MIN(paddleX, self.size.width - paddle.size.width/2);
        
        paddle.position = CGPointMake(paddleX, paddle.position.y);
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.isFingerOnPaddle = NO;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
