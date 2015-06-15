package com.produban.otpTest;

import com.produban.otpTest.otp.Totp;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;


public class MainActivity extends Activity {
	
	private EditText txtUser;
	private EditText txtKey;
	private Button btnOK;
	private Button btnValidar;
	private EditText txttxtValidating;
	private TextView lblOPT;
	private Totp totp;
	private ImageView imgQrCode;
	

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);

		txtUser = (EditText) findViewById(R.id.txtUser);
		txtKey = (EditText) findViewById(R.id.txtKeyr);
		btnOK = (Button) findViewById(R.id.btnOK);
		btnValidar = (Button) findViewById(R.id.btnValidar);
		txttxtValidating = (EditText) findViewById(R.id.txtValidating);
		lblOPT = (TextView) findViewById(R.id.lblOTP);
		imgQrCode = (ImageView) findViewById(R.id.imgQrcode);
		
		txtKey.setEnabled(false);

		btnOK.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View arg0) {
				getOTPNow();
			}
		});

		btnValidar.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View arg0) {
				
				if(isValidateEmpty()){
					return;
				}

				if (validateOTP(txttxtValidating.getText().toString())
						) {
					Toast.makeText(MainActivity.this,
							"Sucesso \nCodigo valido", Toast.LENGTH_LONG)
							.show();
				} else {
					Toast.makeText(MainActivity.this,
							"Falha \nCodigo invalido", Toast.LENGTH_LONG)
							.show();
				}
			}
		});
		totp = new Totp(getSecretKey());
		getQrCodeImage();
	}
	
	@Override
	protected void onResume() {
		super.onResume();
		
		getOTPNow();
		
	}
	
	public boolean isValidateEmpty(){
		return txttxtValidating.getText().toString().equals("");
	}

	public String getSecretKey() {

		txtUser.setText("Produban Test");
		String secret = txtKey.getText().toString();
		return secret;
	}
	
	public void getQrCodeImage(){
		
		new requestTask(this, imgQrCode, totp.uri(txtUser.getText().toString()))
		.execute();
	}

	public void getOTPNow() {
		
		lblOPT.setText(totp.now());
	}

	public Boolean validateOTP(String otp) {
		return totp.verify(otp);
	}

}
