package com.example.whiteboard.view;

import com.herewhite.sdk.domain.WhiteObject;

public class Cursor extends WhiteObject {
    private final String cursorName;

    public Cursor(String name) {
        this.cursorName = name;
    }
}
