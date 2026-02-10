// ============================================================================
// SID SUPERSTATION - Storage / Disk I/O
// ============================================================================
// Save and load patches, patterns, and songs to/from 1541 disk
// ============================================================================

// ============================================================================
// File Headers
// ============================================================================
// Each file type has a 4-byte header: "SID" + type byte

.const HEADER_PATCH         = 'P'   // Single patch file
.const HEADER_BANK          = 'B'   // Patch bank file
.const HEADER_PATTERN       = 'S'   // Pattern (sequence) file
.const HEADER_SONG          = 'G'   // Song file

// ============================================================================
// Storage State Variables
// ============================================================================
.label storage_filename     = $0600     // Filename buffer (16 bytes)
.label storage_status       = $0610     // Status/error code
.label storage_buffer       = $0620     // Temporary I/O buffer (256 bytes)

.const LOGICAL_FILE         = 1         // Logical file number
.const DEVICE_NUM           = 8         // Device 8 = 1541 disk drive
.const SECONDARY_ADDR       = 1         // Secondary address

// ============================================================================
// Initialize Storage System
// ============================================================================
storage_init:
    // Clear filename buffer
    ldx #$00
    lda #$00
clear_filename:
    sta storage_filename,x
    inx
    cpx #$10
    bne clear_filename
    
    // Set default status
    lda #$00
    sta storage_status
    
    rts

// ============================================================================
// Save Patch to Disk
// ============================================================================
// Saves a single patch to disk
// Inputs: A = patch number (0-127)
//         X = low byte of filename
//         Y = high byte of filename
// Outputs: storage_status = 0 on success, error code on failure
// Modifies: A, X, Y
// ============================================================================
storage_save_patch:
    // Save patch number
    sta ZP_TEMP
    
    // Copy filename to buffer
    stx ZP_PTR1
    sty ZP_PTR1+1
    jsr storage_copy_filename
    
    // Calculate patch address
    lda ZP_TEMP
    jsr storage_calc_patch_address
    // Now ZP_PTR2 points to patch data
    
    // Prepare file header
    ldx #$00
    lda #'S'
    sta storage_buffer,x
    inx
    lda #'I'
    sta storage_buffer,x
    inx
    lda #'D'
    sta storage_buffer,x
    inx
    lda #HEADER_PATCH
    sta storage_buffer,x
    inx
    
    // Copy patch data to buffer
    ldy #$00
copy_patch_to_buffer:
    lda (ZP_PTR2),y
    sta storage_buffer,x
    inx
    iny
    cpy #PATCH_SIZE
    bne copy_patch_to_buffer
    
    // Now storage_buffer contains 4-byte header + 64-byte patch = 68 bytes
    
    // Set filename
    lda #$10                // Filename length (max 16)
    ldx #<storage_filename
    ldy #>storage_filename
    jsr KERNAL_SETNAM
    
    // Set file parameters
    lda #LOGICAL_FILE
    ldx #DEVICE_NUM
    ldy #SECONDARY_ADDR
    jsr KERNAL_SETLFS
    
    // Open file for writing
    jsr KERNAL_OPEN
    bcs save_error
    
    // Set output channel
    ldx #LOGICAL_FILE
    jsr KERNAL_CHKOUT
    
    // Write data
    ldx #$00
save_write_loop:
    lda storage_buffer,x
    jsr KERNAL_CHROUT
    inx
    cpx #(4 + PATCH_SIZE)   // Header + patch size
    bne save_write_loop
    
    // Clear channel and close file
    jsr KERNAL_CLRCHN
    lda #LOGICAL_FILE
    jsr KERNAL_CLOSE
    
    // Success
    lda #$00
    sta storage_status
    rts

save_error:
    // Error occurred
    lda #$FF
    sta storage_status
    rts

// ============================================================================
// Load Patch from Disk
// ============================================================================
// Loads a single patch from disk
// Inputs: A = patch number (destination, 0-127)
//         X = low byte of filename
//         Y = high byte of filename
// Outputs: storage_status = 0 on success, error code on failure
// Modifies: A, X, Y
// ============================================================================
storage_load_patch:
    // Save patch number
    sta ZP_TEMP
    
    // Copy filename to buffer
    stx ZP_PTR1
    sty ZP_PTR1+1
    jsr storage_copy_filename
    
    // Calculate patch address
    lda ZP_TEMP
    jsr storage_calc_patch_address
    // Now ZP_PTR2 points to patch data destination
    
    // Set filename
    lda #$10                // Filename length
    ldx #<storage_filename
    ldy #>storage_filename
    jsr KERNAL_SETNAM
    
    // Set file parameters
    lda #LOGICAL_FILE
    ldx #DEVICE_NUM
    ldy #$00                // 0 = load
    jsr KERNAL_SETLFS
    
    // Open file for reading
    jsr KERNAL_OPEN
    bcs load_error
    
    // Set input channel
    ldx #LOGICAL_FILE
    jsr KERNAL_CHKIN
    
    // Read header (4 bytes)
    jsr KERNAL_CHRIN        // 'S'
    jsr KERNAL_CHRIN        // 'I'
    jsr KERNAL_CHRIN        // 'D'
    jsr KERNAL_CHRIN        // Type
    cmp #HEADER_PATCH
    bne load_invalid_file
    
    // Read patch data
    ldy #$00
load_read_loop:
    jsr KERNAL_CHRIN
    sta (ZP_PTR2),y
    iny
    cpy #PATCH_SIZE
    bne load_read_loop
    
    // Clear channel and close file
    jsr KERNAL_CLRCHN
    lda #LOGICAL_FILE
    jsr KERNAL_CLOSE
    
    // Success
    lda #$00
    sta storage_status
    rts

load_error:
    lda #$FF
    sta storage_status
    rts

load_invalid_file:
    jsr KERNAL_CLRCHN
    lda #LOGICAL_FILE
    jsr KERNAL_CLOSE
    lda #$FE
    sta storage_status
    rts

// ============================================================================
// Save Pattern to Disk
// ============================================================================
// Saves a single pattern to disk
// Inputs: A = pattern number (0-31)
//         X = low byte of filename
//         Y = high byte of filename
// Outputs: storage_status = 0 on success
// Modifies: A, X, Y
// ============================================================================
storage_save_pattern:
    // Save pattern number
    sta ZP_TEMP
    
    // Copy filename
    stx ZP_PTR1
    sty ZP_PTR1+1
    jsr storage_copy_filename
    
    // Calculate pattern address
    lda ZP_TEMP
    jsr storage_calc_pattern_address
    // Now ZP_PTR2 points to pattern data
    
    // Set filename
    lda #$10
    ldx #<storage_filename
    ldy #>storage_filename
    jsr KERNAL_SETNAM
    
    // Set file parameters
    lda #LOGICAL_FILE
    ldx #DEVICE_NUM
    ldy #SECONDARY_ADDR
    jsr KERNAL_SETLFS
    
    // Open file
    jsr KERNAL_OPEN
    bcs save_pattern_error
    
    // Set output channel
    ldx #LOGICAL_FILE
    jsr KERNAL_CHKOUT
    
    // Write header
    lda #'S'
    jsr KERNAL_CHROUT
    lda #'I'
    jsr KERNAL_CHROUT
    lda #'D'
    jsr KERNAL_CHROUT
    lda #HEADER_PATTERN
    jsr KERNAL_CHROUT
    
    // Write pattern data (256 bytes)
    ldy #$00
save_pattern_loop:
    lda (ZP_PTR2),y
    jsr KERNAL_CHROUT
    iny
    bne save_pattern_loop
    
    // Close
    jsr KERNAL_CLRCHN
    lda #LOGICAL_FILE
    jsr KERNAL_CLOSE
    
    lda #$00
    sta storage_status
    rts

save_pattern_error:
    lda #$FF
    sta storage_status
    rts

// ============================================================================
// Load Pattern from Disk
// ============================================================================
storage_load_pattern:
    // Save pattern number
    sta ZP_TEMP
    
    // Copy filename
    stx ZP_PTR1
    sty ZP_PTR1+1
    jsr storage_copy_filename
    
    // Calculate pattern address
    lda ZP_TEMP
    jsr storage_calc_pattern_address
    
    // Set filename
    lda #$10
    ldx #<storage_filename
    ldy #>storage_filename
    jsr KERNAL_SETNAM
    
    // Set file parameters
    lda #LOGICAL_FILE
    ldx #DEVICE_NUM
    ldy #$00
    jsr KERNAL_SETLFS
    
    // Open file
    jsr KERNAL_OPEN
    bcs load_pattern_error
    
    // Set input channel
    ldx #LOGICAL_FILE
    jsr KERNAL_CHKIN
    
    // Read and verify header
    jsr KERNAL_CHRIN
    jsr KERNAL_CHRIN
    jsr KERNAL_CHRIN
    jsr KERNAL_CHRIN
    cmp #HEADER_PATTERN
    bne load_pattern_invalid
    
    // Read pattern data
    ldy #$00
load_pattern_loop:
    jsr KERNAL_CHRIN
    sta (ZP_PTR2),y
    iny
    bne load_pattern_loop
    
    // Close
    jsr KERNAL_CLRCHN
    lda #LOGICAL_FILE
    jsr KERNAL_CLOSE
    
    lda #$00
    sta storage_status
    rts

load_pattern_error:
    lda #$FF
    sta storage_status
    rts

load_pattern_invalid:
    jsr KERNAL_CLRCHN
    lda #LOGICAL_FILE
    jsr KERNAL_CLOSE
    lda #$FE
    sta storage_status
    rts

// ============================================================================
// Helper: Copy Filename
// ============================================================================
// Copies a null-terminated filename to storage_filename buffer
// Inputs: ZP_PTR1 = pointer to source filename
// Modifies: A, X, Y
// ============================================================================
storage_copy_filename:
    ldy #$00
copy_fn_loop:
    lda (ZP_PTR1),y
    sta storage_filename,y
    beq copy_fn_done
    iny
    cpy #$10
    bne copy_fn_loop
copy_fn_done:
    rts

// ============================================================================
// Helper: Calculate Patch Address
// ============================================================================
// Calculates memory address for a patch
// Inputs: A = patch number (0-127)
// Outputs: ZP_PTR2 = address of patch data
// Modifies: A
// ============================================================================
storage_calc_patch_address:
    // Multiply by 64 (PATCH_SIZE)
    sta ZP_TEMP
    lda #$00
    sta ZP_PTR2+1
    lda ZP_TEMP
    asl
    rol ZP_PTR2+1
    asl
    rol ZP_PTR2+1
    asl
    rol ZP_PTR2+1
    asl
    rol ZP_PTR2+1
    asl
    rol ZP_PTR2+1
    asl
    rol ZP_PTR2+1
    sta ZP_PTR2
    
    // Add PATCH_DATA base
    lda ZP_PTR2
    clc
    adc #<PATCH_DATA
    sta ZP_PTR2
    lda ZP_PTR2+1
    adc #>PATCH_DATA
    sta ZP_PTR2+1
    
    rts

// ============================================================================
// Helper: Calculate Pattern Address
// ============================================================================
// Calculates memory address for a pattern
// Inputs: A = pattern number (0-31)
// Outputs: ZP_PTR2 = address of pattern data
// Modifies: A
// ============================================================================
storage_calc_pattern_address:
    // Multiply by 256 (PATTERN_SIZE)
    sta ZP_PTR2+1
    lda #$00
    sta ZP_PTR2
    
    // Add PATTERN_DATA base
    lda ZP_PTR2
    clc
    adc #<PATTERN_DATA
    sta ZP_PTR2
    lda ZP_PTR2+1
    adc #>PATTERN_DATA
    sta ZP_PTR2+1
    
    rts

// ============================================================================
// Check Disk Status
// ============================================================================
// Reads the disk drive error channel
// Outputs: A = status code (0 = OK)
// Modifies: A, X, Y
// ============================================================================
storage_check_status:
    // Open command channel
    lda #$0F                // Command channel
    ldx #DEVICE_NUM
    ldy #$0F
    jsr KERNAL_SETLFS
    
    lda #$00                // No filename
    jsr KERNAL_SETNAM
    
    jsr KERNAL_OPEN
    bcs status_error
    
    ldx #$0F
    jsr KERNAL_CHKIN
    
    // Read status (first 2 chars are status code)
    jsr KERNAL_CHRIN
    sta ZP_TEMP
    jsr KERNAL_CHRIN
    
    jsr KERNAL_CLRCHN
    lda #$0F
    jsr KERNAL_CLOSE
    
    lda ZP_TEMP
    rts

status_error:
    lda #$FF
    rts
