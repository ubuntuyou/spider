NToffset:
    .db $24, $20
    
ATBoffset:
    .db $27, $23

columnBuff:
    lda scroll          ; Load scroll
    tay
    eor oldScroll
    and #%00010000
    beq @next           ; If carry is set then not divisible by 8
    lda #$00
    sta needUpdate      ; So clear needUpdate flag
    rts                 ; End
@next
    tya
    lsr A
    lsr A
    lsr A
    lsr A
    tay
    sty temp+1

    lda needUpdate      ; Check if needUpdate flag is set
    bne columnBuffDone  ; If not then skip

    ldx scroll+1
    lda backgroundsLo,x
    sta bkgPtr
    lda backgroundsHi,x
    sta bkgPtr+1

columnBuffer = $011E

    ldx #$1E            ; Initialize X
leftMetaColumn:
    lda (bkgPtr),y
    tay
    lda topLeft,y
    sta columnBuffer,x
    dex
    lda bottomLeft,y
    sta columnBuffer,x
    lda temp+1
    clc
    adc #$10
    sta temp+1
    tay
    dex
    bne leftMetaColumn

    tya
    clc
    adc #$10
    sta temp+1
    tay

columnBuffer = $0100

    ldx #$1E
rightMetaColumn:
    lda (bkgPtr),y
    tay
    lda topRight,y
    sta columnBuffer,x
    dex
    lda bottomRight,y
    sta columnBuffer,x
    lda temp+1
    clc
    adc #$10
    sta temp+1
    tay
    dex
    bne rightMetaColumn

    ldx nametable
    lda NToffset,x
    sta addrHi

    lda scroll          ; Load Scroll
    lsr A
    lsr A
    lsr A               ; Divide by 8 for nametable column offset
    sta addrLo          ; Store in addrLo

    lda #$1E
    sta columnCount     ; Store 30 in columnCount

    lda #$01
    sta needUpdate      ; Set needAtbBuff and need update flags
    sta needDraw        ; Increment needDraw flag
columnBuffDone:
    rts

updateColumn:
    lda needDraw          ; Check if needDraw flag set
    beq updateColumnDone  ; If not then skip
    
    lda softPPU_Control
    eor #%00000100
    sta PPU_Control     ; Set bit 2 of PPU_Control to increment PPU address by 32

columnBuffer = $0100

    ldy #$02
    ldx #$3C            ; Initialise X for first row of buffer
@outerLoop

    lda PPU_Status
    lda addrHi
    sta PPU_Address
    lda addrLo
    sta PPU_Address

@loop
    lda columnBuffer,x  ; Load first byte of column buffer
    sta PPU_Data        ; Store in $2007
    dex
    cpx columnCount     ; Increment X and check if equal to columnCount
    bne @loop           ; If not equal then repeat until true

    lda #$00
    sta columnCount
    inc addrLo          ; Increment addrLo for next nametable column
    dey
    bne @outerLoop

    lda softPPU_Control
    sta PPU_Control     ; Clear bit 2 of PPU_Control to increment address by 1

    dec needDraw        ; Clear needDraw flag
updateColumnDone:
    rts
    
updateAttribs:
    lda scroll          ; Load scroll
    cmp #$04
    bne updateAttribsDone

    ldx nametable
    lda ATBoffset,x
    sta colHi

    lda PPU_Status
    lda colHi
    sta PPU_Address
    lda #$C0
    sta PPU_Address

    ldx scroll+1
    lda attribsLo,x
    sta atbPtr
    lda attribsHi,x
    sta atbPtr+1

    ldy #$00
@loop
    lda (atbPtr),y      ; Load attribute byte
    sta PPU_Data
    iny
    cpy #$40
    bne @loop           ; If not #$00 then repeat until true
updateAttribsDone:
    rts