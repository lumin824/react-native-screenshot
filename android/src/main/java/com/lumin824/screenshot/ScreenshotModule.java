package com.lumin824.screenshot;

import android.graphics.Bitmap;
import android.view.View;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.util.UUID;


public class ScreenshotModule extends ReactContextBaseJavaModule {

  public ScreenshotModule(ReactApplicationContext reactContext) {
    super(reactContext);
  }

  @Override
  public String getName(){
    return "ScreenshotModule";
  }

  @ReactMethod
  public void capture(Promise promise){
    File cacheFolder = getReactApplicationContext().getCacheDir();
    String cacheFolderPath = cacheFolder.getAbsolutePath() + "/";

    String cacheFilePath = cacheFolderPath + UUID.randomUUID().toString() +".png";

    View view = getCurrentActivity().getWindow().getDecorView();
    view.setDrawingCacheEnabled(true);
    view.buildDrawingCache();
    Bitmap bitmap = view.getDrawingCache();

    FileOutputStream fos = null;
    try {
      fos = new FileOutputStream(cacheFilePath);
      bitmap.compress(Bitmap.CompressFormat.PNG, 100, fos);
      promise.resolve(cacheFilePath);
    } catch (FileNotFoundException e) {
      promise.reject(e);
    }
    view.destroyDrawingCache();
  }
}
