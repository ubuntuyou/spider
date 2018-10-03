updateFrames:
    lda #<spriteAnim          ; Load animation pointers
    sta animationPtr
    lda #>spriteAnim
    sta animationPtr+1

frameCheck:
    lda jumping
    bne playingFrameJump
    lda frameCounter          ; Load frameCounter
    beq playingFrame1         ; Determine which frame to setup
    cmp #$03
    beq playingFrame2
    cmp #$07
    beq playingFrame3
    cmp #$0B
    beq playingFrame2
    rts                       ; If no change needed then skip setup

playingFrame1:
    lda animConstNumber       ; Same as above but for left movement
    sta animationNumber
    jmp updateFramesDone

playingFrame2:                ; Same as playingFrame1
    lda buttons
    and #%00000011
    bne @skip
    lda #$01
    sta animationEnable
@skip
    lda animConstNumber+1
    sta animationNumber
    jmp updateFramesDone

playingFrame3:                ; Same as playingFrame1
    lda animConstNumber+2
    sta animationNumber
    jmp updateFramesDone

playingFrameJump:             ; Same as playingFrame1
    lda #$01
    sta animationEnable
    lda animConstNumber+3
    sta animationNumber

updateFramesDone:             ; End
    lda animationEnable       ; Check if animation enabled
    beq animateSpritesDone    ; If not then do nothing

animateSprites:
    ldx animationNumber       ; Load X with animationNumber
    ldy animationConstants,x  ; Use as offset to load correct animationConstant
    
    ldx #$00                  ; Initialize X
@loop
    inx                       ; Increment X
    lda (animationPtr),y      ; Load sprite number
    sta spriteRAM,x           ; Store in sprite slot
    iny
    inx                       ; Increment X and Y
    lda (animationPtr),y      ; Load sprite attribute
    sta spriteRAM,x           ; Store in attribute slot
    iny                       ; Increment Y
    inx
    inx                       ; Increment X twice
    cpx #$20                  ; Compare to #$20
    bne @loop                 ; If not #$20 then repeat until true
animateSpritesDone:
    lda #$00
    sta animationEnable
    rts


displayScroll:
    lda scroll                ; Load scroll
    and #$0F                  ; Discard higer bits
    tax                       ; Transfer to X
    lda count,x               ; Load count value using X as offset
    sta spriteOnes+1          ; Store in spriteOnes+1
    
    lda scroll                ; Load scroll
    lsr
    lsr
    lsr
    lsr                       ; Divide by 16
    tax                       ; Transfer to X
    lda count,x               ; Load count value using X as offset
    sta spriteTens+1          ; Store in spriteTens+1
    
    ldx scroll+1              ; Load X with scroll+1
    dex                       ; Decrement once to get correct offset
    lda count,x               ; Load count value using X as offset
    sta spriteHundreds+1      ; Store in spriteHundreds+1
displayScrollDone:
    rts


; For enemies we need to know enemyNumber first, then check if alive.
; If alive then check enemy direction and load A with the correct animationNumber for that direction.
; Then pick animationConstant with animationNumber as offset and store in spriteRAM for that enemy.
; Increment (or decrement) enemy counter and repeat.
