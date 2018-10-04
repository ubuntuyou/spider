;;;;;;;;;;;;;;;;;;;;;;;
;;;   iNES HEADER   ;;;
;;;;;;;;;;;;;;;;;;;;;;;

    .db  "NES", $1a     ;identification of the iNES header
    .db  PRG_COUNT      ;number of 16KB PRG-ROM pages
    .db  $02            ;number of 8KB CHR-ROM pages
    .db  $00|MIRRORING  ;mapper 0 and mirroring
    .dsb $09, $00       ;clear the remaining bytes

    .fillvalue $FF      ; Sets all unused space in rom to value $FF

;;;;;;;;;;;;;;;;;;;;;
;;;   VARIABLES   ;;;
;;;;;;;;;;;;;;;;;;;;;

    .enum $0000 ; Zero Page variables

atbPtr          .dsb 2
animationPtr    .dsb 2    
bkgPtr          .dsb 2    
colPtr          .dsb 2    
animationNumber .dsb 1    
animConstNumber .dsb 4    
animationEnable .dsb 1    
frameCounter    .dsb 2    
gameState       .dsb 1    


nametable       .dsb 1    
len             .dsb 1    
needDraw        .dsb 1    
needUpdate      .dsb 1    
columnCount     .dsb 1    
bkgLo           .dsb 1    
bkgHi           .dsb 1    

addrLo          .dsb 1    
addrHi          .dsb 1    
colLo           .dsb 1    
colHi           .dsb 1    
temp            .dsb 2

buttons         .dsb 1    
oldButtons      .dsb 1    

scroll          .dsb 2    
oldScroll       .dsb 1    

spriteXpos      .dsb 2    
spriteYpos      .dsb 2    
spriteX         .dsb 1    
spriteY         .dsb 1    
spriteH         .dsb 1    
spriteV         .dsb 1    

sleeping        .dsb 1    

upIsPressed     .dsb 1    
downIsPressed   .dsb 1    
leftIsPressed   .dsb 1    
rightIsPressed  .dsb 1    

jumping         .dsb 1    
velocity        .dsb 1    

jumpForce       .dsb 1    
jumpVelocity    .dsb 1    
jumpVelocityMod .dsb 1    
jumpCounter     .dsb 1    
bkgColPtr       .dsb 1    
levelEnemyPtr   .dsb 2    
enemyType       .dsb 1

    .ende

    .enum $0400 ; Variables at $0400. Can start on any RAM page
softPPU_Control .dsb 1
softPPU_Mask    .dsb 1
    .ende
;;;;;;;;;;;;;;;;;;;;;
;;;   CONSTANTS   ;;;
;;;;;;;;;;;;;;;;;;;;;

PRG_COUNT       = 2       ;1 = 16KB, 2 = 32KB
MIRRORING       = %0001   ;%0000 = horizontal, %0001 = vertical, %1000 = four-screen

jumpState       .equ $01
fallState       .equ $FF
fallGrav        .equ $01
maxVelocity     .equ $05
scrollHit2      .equ $50
scrollHit1      .equ $97

TITLE           .equ $00
PAUSED          .equ $01
PLAYING         .equ $02

spriteRAM       .equ $0200
spriteOnes      .equ $0230
spriteTens      .equ $0234
spriteHundreds  .equ $0238
columnBuffer    .equ $0100
columnBuffer1   .equ $0100
columnBuffer2   .equ $011E

controller1     .equ $4016

PPU_Control     .equ $2000
PPU_Mask        .equ $2001
PPU_Status      .equ $2002
PPU_Scroll      .equ $2005
PPU_Address     .equ $2006
PPU_Data        .equ $2007

    .org $8000
.include metabackgrounds.asm
.include attributes.asm

    .pad $C000
;;;;;;;;;;;;;;;;;
;;;   RESET   ;;;
;;;;;;;;;;;;;;;;;

RESET:
    sei
    cld
    ldx #$40
    stx $4017
    ldx #$FF
    txs
    inx
    stx PPU_Control
    stx PPU_Mask
    stx $4010

vblank1:
    bit PPU_Status
    bpl vblank1

clrmem:
    lda #$00
    sta $0000,x
    sta $0100,x
    sta $0300,x
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $0700,x
    lda #$FE
    sta $0200,x
    inx
    bne clrmem

vblank2:
    bit PPU_Status
    bpl vblank2

    lda PPU_Status
    lda #$3F
    sta PPU_Address
    lda #$00
    sta PPU_Address

    ldx #$00
loadPalettesLoop:
    lda palette, x
    sta PPU_Data
    inx
    cpx #$20
    bne loadPalettesLoop
loadPalettesDone:

loadSprites:
    ldx #$20
@loop
    lda sprite,x
    sta spriteRAM,x
    dex
    bpl @loop
loadSpritesDone:

loadCountSprites:
    ldx #$0C
@loop
    lda countSpriteOnes,x
    sta spriteOnes,x
    dex
    bpl @loop
loadCountSpritesDone:


    inc nametable
bkg:
    jsr columnBuff
    jsr updateColumn
    dec needUpdate
    lda scroll
    clc
    adc #$10
    sta scroll
    sta oldScroll
    bne bkg
bkgDone:

atb:
    lda #$04
    sta scroll
    jsr updateAttribs
    dec nametable
    inc scroll+1
    jsr updateAttribs
    lda #$00
    sta scroll
atbDone:

initSprite:
    ldx #$00
    stx animConstNumber
    inx
    stx animConstNumber+1
    inx
    stx animConstNumber+2
    inx
    stx animConstNumber+3

    lda #$40
    sta spriteH
    lda #$7F
    sta spriteV
initSpriteDone:

    lda #%10010000
    sta softPPU_Control
    sta PPU_Control
    lda #%00011110
    sta softPPU_Mask
    sta PPU_Mask

    lda #PLAYING
    sta gameState
    
    lda #%00000001
    sta $4015
    lda #%01000000
    sta $4017
    
    lda #$0F
    sta len

    jmp MAIN

;;;;;;;;;;;;;;;;;;;;;;;
;;;   SUBROUTINES   ;;;
;;;;;;;;;;;;;;;;;;;;;;;

updateSpriteLoc:
    lda spriteV
    sta spriteRAM
    sta spriteRAM+4
    sta spriteRAM+8
    sta spriteRAM+12
    clc
    adc #$08
    sta spriteRAM+16
    sta spriteRAM+20
    sta spriteRAM+24
    sta spriteRAM+28

    lda spriteH
    sta spriteRAM+3
    sta spriteRAM+19
    clc
    adc #$08
    sta spriteRAM+7
    sta spriteRAM+23
    adc #$08
    sta spriteRAM+11
    sta spriteRAM+27
    adc #$08
    sta spriteRAM+15
    sta spriteRAM+31
updateSpriteLocDone:
    rts

.include controllers.asm
.include columns.asm
.include collision.asm
.include animation.asm
.include enemies.asm

;;;;;;;;;;;;;;;;
;;;   MAIN   ;;;
;;;;;;;;;;;;;;;;

MAINindsL:
    .dl MAINtitle-1
    .dl MAINpause-1
    .dl MAINplaying-1

MAINindsH:
    .dh MAINtitle-1
    .dh MAINpause-1
    .dh MAINplaying-1

MAINind:
    ldx gameState
    lda MAINindsH,x
    pha
    lda MAINindsL,x
    pha
    rts

MAINtitle:
    rts

MAINpause:
    jsr pause
    rts

MAINplaying:
controllers:
    jsr readRight
    jsr readLeft
    jsr pause
    jsr readB
    jsr readA
controllersDone:

    jsr jumpRoutine
    jsr gravity
    jsr updateSpriteLoc

    jsr columnBuff

    jsr updateFrames
    jsr displayScroll
MAINplayingDone:
    rts

MAIN:
    inc sleeping
loop:
    lda sleeping
    bne loop

    jsr MAINind

showCPUusageBar:
    ldx #%00011111  ; sprites + background + monochrome (i.e. WHITE)
    stx $2001
    ldy #23  ; add about 23 for each additional line (leave it on WHITE for one scan line)
@loop
    dey
    bne @loop
    dex    ; sprites + background + NO monochrome  (i.e. #%00011110)
    stx $2001

    jmp MAIN
MAINdone:


;;;;;;;;;;;;;;;
;;;   NMI   ;;;
;;;;;;;;;;;;;;;

NMIindsL:
    .dl NMItitle-1
    .dl NMIpause-1
    .dl NMIplaying-1

NMIindsH:
    .dh NMItitle-1
    .dh NMIpause-1
    .dh NMIplaying-1

NMIind:
    ldx gameState
    lda NMIindsH,x
    pha
    lda NMIindsL,x
    pha
    rts

NMItitle:
    rts

NMIpause:
    jsr latchController
    rts

NMIplaying:
    frame:
    inc frameCounter
    lda frameCounter
    and #$10
    beq frameDone
    and #$00
    sta frameCounter
frameDone:

    jsr latchController
    jsr updateColumn
    jsr updateAttribs
NMIplayingDone:
    rts

NMI:
    pha
    txa
    pha
    tya
    pha

    lda #$00
    sta $2003
    lda #$02
    sta $4014

    jsr NMIind

    lda PPU_Status
    lda #$00
    sta PPU_Address
    sta PPU_Address

    lda scroll
    sta oldScroll
    sta PPU_Scroll
    lda #$00
    sta PPU_Scroll

    lda softPPU_Control
    sta PPU_Control
    lda softPPU_Mask
    sta PPU_Mask
    dec sleeping

    pla
    tay
    pla
    tax
    pla
    rti
NMIdone:

    .pad $E000
palette:
    ;   BLK,WHT,LRd,DRd   BLK,DBL,LGr,DGr       BLK,WHT,LGr,DGr     BLK,DBL,RED,WHT
    .db $0F,$00,$07,$10,  $0F,$17,$19,$39,  $0F,$07,$1A,$29,  $0F,$0C,$16,$30   ;;background palette
    .db $31,$27,$17,$07,  $0F,$20,$10,$00,  $0F,$1C,$15,$14,  $0F,$02,$38,$3C   ;;sprite palette

sprite:
    .db $7F,$00,$00,$40
    .db $7F,$01,$00,$48
    .db $7F,$02,$00,$50
    .db $7F,$03,$00,$58

    .db $87,$10,$00,$40
    .db $87,$11,$00,$48
    .db $87,$12,$00,$50
    .db $87,$13,$00,$58

countSpriteOnes:
    .db $10,$20,$01,$18
countSpriteTens:
    .db $10,$20,$01,$10
countSpriteHundreds:
    .db $10,$20,$01,$08

spriteAnim:
    .db $00,$00, $01,$00, $02,$00, $03,$00, $10,$00, $11,$00, $12,$00, $13,$00 ; R0
    .db $00,$00, $04,$00, $02,$00, $05,$00, $10,$00, $0A,$00, $0B,$00, $0C,$00 ; R1,R3
    .db $00,$00, $04,$00, $06,$00, $05,$00, $0D,$00, $0E,$00, $0F,$00, $14,$00 ; R2

    .db $00,$00, $07,$00, $08,$00, $09,$00, $15,$00, $16,$00, $17,$00, $18,$00 ; Jumping R


    .db $03,$40, $02,$40, $01,$40, $00,$40, $13,$40, $12,$40, $11,$40, $10,$40 ; L0
    .db $05,$40, $02,$40, $04,$40, $00,$40, $0C,$40, $0B,$40, $0A,$40, $10,$40 ; L1,L3
    .db $05,$40, $06,$40, $04,$40, $00,$40, $14,$40, $0F,$40, $0E,$40, $0D,$40 ; L2

    .db $09,$40, $08,$40, $07,$40, $00,$40, $18,$40, $17,$40, $16,$40, $15,$40 ; Jumping L

animationConstants:
    .db $00,$10,$20,$30, $40,$50,$60,$70

count:
    .db $20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2A,$2B,$2C,$2D,$2E,$2F,$30

backgroundsLo:
    .dl background0, background1, background2, background3, background4
    .dl background5, background6, background7, background8, background9
    .dl backgroundA

backgroundsHi:
    .dh background0, background1, background2, background3, background4
    .dh background5, background6, background7, background8, background9
    .dh backgroundA

attribsLo:
    .dl attribs0, attribs1, attribs2, attribs3, attribs4
    .dl attribs5, attribs6, attribs7, attribs8, attribs9
    .dl attribsA

attribsHi:
    .dh attribs0, attribs1, attribs2, attribs3, attribs4
    .dh attribs5, attribs6, attribs7, attribs8, attribs9
    .dh attribsA
    
;;;;;;;;;;;;;;;;;;;;;
;;;   METATILES   ;;;
;;;;;;;;;;;;;;;;;;;;;

    ;;;  00   01   02   03   04
topLeft:
    .db $EE, $EF, $00, $01, $02

topRight:
    .db $EE, $EF, $01, $02, $03

bottomLeft:
    .db $EE, $EF, $EF, $EF, $EF

bottomRight:
    .db $EE, $EF, $EF, $EF, $EF

colAtb:
    .db $00, $01, $01, $01, $01

;;;;;;;;;;;;;;;;;;;
;;;   VECTORS   ;;;
;;;;;;;;;;;;;;;;;;;

    .pad $FFFA

    .dw NMI
    .dw RESET
    .dw 0


;;;;;;;;;;;;;;;;;;;
;;;   CHR-ROM   ;;;
;;;;;;;;;;;;;;;;;;;

    .incbin "META.chr"

