package com.produban.otpTest;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.BitmapDrawable;
import android.os.AsyncTask;
import android.widget.ImageView;

public class requestTask extends AsyncTask<Object,Object , Bitmap>{

	private ImageView imageView;
	private Context ctx;
	private String secret;

	public requestTask(Context ctx,ImageView imageView,String secret) {
		this.imageView = imageView;
		this.ctx = ctx;
		this.secret = secret;
	}
	
	private Bitmap generateQrcode() {
	    URL aURL;

	    try {
	        aURL = new URL("http://chart.apis.google.com//chart?chs=450x450&cht=qr&chl="+this.secret);
	        URLConnection conn = aURL.openConnection();
	        conn.connect();
	        InputStream is = conn.getInputStream();
	        BufferedInputStream bis = new BufferedInputStream(is);
	        Bitmap bm = BitmapFactory.decodeStream(bis);
	        bis.close();
	        is.close();

	        return bm;
	    } catch (MalformedURLException e) {
	        e.printStackTrace();
	    } catch (IOException e) {
	        e.printStackTrace();
	    }
	    return null;
	}

	@Override
	protected Bitmap doInBackground(Object... params) {
		
		Bitmap bmp = generateQrcode();
		return bmp;
	}
	
	@Override
	protected void onPostExecute(Bitmap result) {
		super.onPostExecute(result);
		
		 BitmapDrawable ob = new BitmapDrawable(ctx.getResources(), result);
		 imageView.setBackground(ob);
		
	}
}
