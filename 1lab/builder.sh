#!/bin/sh

# Проверка аргументов
if [ "$#" -ne 1 ] || [ ! -f "$1" ]; then
    echo "Usage: $0 <filename>" >&2
    echo "Error: Provide exactly one existing file" >&2
    exit 1
fi

FILE="$1"
BASE_DIR=$(pwd)
TEMP_WORKSPACE="/tmp/build_$(date +%s)_$$"

# Создание временной рабочей области
mkdir "$TEMP_WORKSPACE" 2>/dev/null || {
    echo "Error: Failed to create temp workspace" >&2
    exit 2
}

finish() {
    cd "$BASE_DIR" || exit 3
    rm -rf "$TEMP_WORKSPACE"
    exit "$1"
}

trap 'finish 4' INT TERM

if echo "$FILE" | grep -q "\.c$"; then
    BUILD_TOOL="cc"
    FILE_TYPE="c"
elif echo "$FILE" | grep -q "\.tex$"; then
    BUILD_TOOL="pdflatex"
    FILE_TYPE="tex"
else
    echo "Error: File must be .c or .tex" >&2
    finish 5
fi

TARGET=$(awk '/&Output:/ {sub(/.*&Output:/, ""); print $1}' "$FILE")
if [ -z "$TARGET" ]; then
    echo "Error: No &Output: found in file" >&2
    finish 6
fi

cp "$FILE" "$TEMP_WORKSPACE/" || {
    echo "Error: Failed to copy file" >&2
    finish 7
}
cd "$TEMP_WORKSPACE" || {
    echo "Error: Failed to enter temp workspace" >&2
    finish 8
}

FILE_NAME=$(echo "$FILE" | rev | cut -d'/' -f1 | rev)

if [ "$FILE_TYPE" = "c" ]; then
    "$BUILD_TOOL" "$FILE_NAME" -o "$TARGET" 2>errors.log
    if [ $? -ne 0 ]; then
        cat errors.log >&2
        finish 9
    fi
else
    "$BUILD_TOOL" "$FILE_NAME" >build.log 2>errors.log
    PDF_NAME="${FILE_NAME%.tex}.pdf"
    if [ -f "$PDF_NAME" ]; then
        mv "$PDF_NAME" "$TARGET" || {
            echo "Error: Failed to rename PDF" >&2
            finish 10
        }
    else
        cat errors.log >&2
        finish 11
    fi
fi

if [ ! -f "$TARGET" ]; then
    echo "Error: Target file not generated" >&2
    finish 12
fi

mv "$TARGET" "$BASE_DIR/" || {
    echo "Error: Failed to move target file" >&2
    finish 13
}

echo "Success: $TARGET created in $BASE_DIR" >&2
finish 0