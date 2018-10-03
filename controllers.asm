latchController:
    lda #$01
    sta controller1
    lda #$00
    sta controller1

    lda buttons
    sta oldButtons

    ldx #$08
@loop
    lda controller1
    lsr
    rol buttons
    dex
    bne @loop
latchControllerDone:
    rts

readA:
    lda buttons
    and #%10000000
    beq readAdone
    
    lda oldButtons
    and #%10000000
    bne varJump

    lda jumping
    bne readAdone
activateJump:
    lda #jumpState
    sta jumping
;   sta spriteJumpState
    lda #-03
    sta jumpForce
    lda #$04
    sta jumpVelocity
    lda #$0E
    sta jumpCounter
    rts
varJump:
    lda jumpCounter
    beq readAdone
    dec jumpCounter
    inc jumpVelocity
    rts
readAdone:
    lda #$00
    sta jumpCounter
    rts

jumpRoutine:
    lda jumping
    beq jumpRoutineDone
jump:
    lda #$01
    sta upIsPressed

    lda spriteV
    clc
    adc jumpForce
    sta spriteV

    dec jumpVelocity
    bne jumpRoutineDone

rise:
    lda jumpForce
    bpl fall
    inc jumpForce
    lda #$04
    sta jumpVelocity
    jsr checkCollision
    rts
fall:
    cmp #$05
    beq jumpRoutineDone
    lda #fallState
    sta jumping
    inc jumpForce
    lda #$04
    sta jumpVelocity
    jsr checkCollision
jumpRoutineDone:
    rts

gravity:
    lda #$01
    sta downIsPressed

    lda jumping
    bne gravityDone            ; If not jumping then continue Else, skip

    lda spriteV
    clc
    adc jumpVelocity
    sta spriteV          ; Add velocity to spriteV

    lda jumpVelocity
    cmp #maxVelocity     ; Compare to maxVelocity
    beq gravityDone            ; If maxVelocity then we're done

    clc
    adc #fallGrav
    sta jumpVelocity         ; Else, add gravity to velocity

gravityDone:
    jsr checkCollision
    lda #$00
    sta downIsPressed
    rts

readB:
    lda buttons
    and #%01000000
    beq readBdone
    
    lda oldButtons
    and #%01000000
    bne readBdone
    
    lda #%01011111
    sta $4000
    lda #$00
    sta $4001
    lda #$8F
    stx $4002
    lda #%11111011
    sta $4003
    dex
    bne readBdone

;    inc scroll
;    bne readBdone

;    inc scroll+1
;    lda softPPU_Control
;    eor #$01
;    sta softPPU_Control
;    and #$01
;    sta nametable
readBdone:
    rts

readSelect:
    lda buttons
    and #%00100000
    beq readSelectDone


readSelectDone:
    rts

pause:
    lda buttons
    and #%00010000
    beq readStartDone

    lda oldButtons
    and #%00010000
    bne readStartDone

    lda gameState
    and #PAUSED
    bne unpause
    dec gameState
    rts
unpause:
    inc gameState
readStartDone:
    rts

readLeft:
    lda buttons
    and #%00000010
    beq readLeftDone

    lda spriteH
    cmp #$09
    bcs @continue
    lda #$00
    sta leftIsPressed
    rts
@continue

    lda #$01
    sta leftIsPressed
    sta animationEnable
    ldx #$04
    stx animConstNumber
    inx
    stx animConstNumber+1
    inx
    stx animConstNumber+2
    inx
    stx animConstNumber+3

    lda spriteH
    clc
    adc #-02
    sta spriteH

    jsr checkCollision

readLeftDone:
    lda #$00
    sta leftIsPressed
    rts

readRight:
    lda buttons
    and #%00000001
    beq readRightDone

    lda spriteH
    cmp #$D8
    bcs readRightDone

    lda #$01
    sta rightIsPressed
    sta animationEnable
    ldx #$00
    stx animConstNumber
    inx
    stx animConstNumber+1
    inx
    stx animConstNumber+2
    inx
    stx animConstNumber+3

    lda spriteH
    clc
    adc #$02
    sta spriteH
    
    jsr checkCollision

    lda scroll+1
    cmp #$0B
    beq readRightDone
    lda spriteH
    cmp #scrollHit1
    bcc readRightDone
    sec
    sbc #$02
    sta spriteH
    lda scroll
    clc
    adc #$02
    sta scroll
    bne readRightDone

    inc scroll+1
    lda softPPU_Control
    eor #$01
    sta softPPU_Control
    and #$01
    sta nametable

readRightDone:
    lda #$00
    sta rightIsPressed
    rts


