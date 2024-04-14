package com.kofoos.api.image;

public class ImageException extends RuntimeException{
    private String msg;

    public ImageException(String msg){
        super(msg);
    }
}
