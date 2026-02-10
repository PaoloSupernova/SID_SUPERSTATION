#!/bin/bash
# SID SUPERSTATION Build Script
# Simple build script for systems without Make

set -e

echo "=================================="
echo "SID SUPERSTATION Build Script"
echo "=================================="
echo ""

# Configuration
KICKASS_JAR="KickAss.jar"
SOURCE_FILE="src/main.asm"
OUTPUT_DIR="build"
OUTPUT_FILE="sid_superstation.prg"

# Check for Java
echo "Checking for Java..."
if ! command -v java &> /dev/null; then
    echo "ERROR: Java not found. Please install Java Runtime Environment."
    echo "  Ubuntu/Debian: sudo apt install default-jre"
    echo "  macOS: brew install java"
    echo "  Windows: Download from java.com"
    exit 1
fi

JAVA_VERSION=$(java -version 2>&1 | head -n 1)
echo "Found: $JAVA_VERSION"
echo ""

# Check for KickAssembler
echo "Checking for KickAssembler..."
if [ ! -f "$KICKASS_JAR" ]; then
    echo "ERROR: $KICKASS_JAR not found in current directory."
    echo "Please download KickAssembler from:"
    echo "  http://theweb.dk/KickAssembler/"
    echo ""
    echo "Place KickAss.jar in the project root directory or update"
    echo "the KICKASS_JAR variable in this script to point to its location."
    exit 1
fi
echo "Found: $KICKASS_JAR"
echo ""

# Create output directory
echo "Creating build directory..."
mkdir -p "$OUTPUT_DIR"
echo ""

# Build
echo "Assembling $SOURCE_FILE..."
echo "Command: java -jar $KICKASS_JAR -showmem -o $OUTPUT_DIR/$OUTPUT_FILE $SOURCE_FILE"
echo ""

if java -jar "$KICKASS_JAR" -showmem -o "$OUTPUT_DIR/$OUTPUT_FILE" "$SOURCE_FILE"; then
    echo ""
    echo "=================================="
    echo "BUILD SUCCESSFUL!"
    echo "=================================="
    echo "Output: $OUTPUT_DIR/$OUTPUT_FILE"
    echo ""
    
    # Show file size
    if [ -f "$OUTPUT_DIR/$OUTPUT_FILE" ]; then
        SIZE=$(stat -f%z "$OUTPUT_DIR/$OUTPUT_FILE" 2>/dev/null || stat -c%s "$OUTPUT_DIR/$OUTPUT_FILE" 2>/dev/null)
        echo "File size: $SIZE bytes"
        echo ""
    fi
    
    # Check for VICE
    if command -v x64 &> /dev/null; then
        echo "VICE emulator detected."
        read -p "Run in emulator now? (y/n) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Starting VICE..."
            x64 "$OUTPUT_DIR/$OUTPUT_FILE"
        fi
    else
        echo "To run in VICE emulator:"
        echo "  x64 $OUTPUT_DIR/$OUTPUT_FILE"
        echo ""
        echo "Or transfer to real C64 hardware using SD2IEC, 1541 Ultimate, etc."
    fi
    
    exit 0
else
    echo ""
    echo "=================================="
    echo "BUILD FAILED!"
    echo "=================================="
    echo "Check error messages above for details."
    exit 1
fi
