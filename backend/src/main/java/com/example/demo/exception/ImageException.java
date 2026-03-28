package com.example.demo.exception;

/**
 * 图片处理异常
 */
public class ImageException extends RuntimeException {

    public ImageException(String message) {
        super(message);
    }

    public ImageException(String message, Throwable cause) {
        super(message, cause);
    }
}
