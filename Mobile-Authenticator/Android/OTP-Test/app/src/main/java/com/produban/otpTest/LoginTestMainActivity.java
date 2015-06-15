package com.produban.otpTest;

import java.net.URI;
import java.sql.Timestamp;
import java.util.List;

import org.apache.http.NameValuePair;
import org.apache.http.client.utils.URLEncodedUtils;

import android.app.Activity;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager.NameNotFoundException;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.preference.PreferenceManager;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.produban.otpTest.otp.Totp;
import com.produban.otpTest.view.ProgressWheel;


public class LoginTestMainActivity extends Activity {

	private TextView lblOTP;
	private TextView lbluser;
	private Button btnGerar;
	private EditText txtSecret;
	private Button btnQRcode;
	private LinearLayout btnCopy;
	private Totp totp;
	private String testeSecret;
	private SharedPreferences preferences;
	private String user;
	private TextView lblCount;
	private CountDownTimer counter;
	private TextView lblExpire;
	ProgressWheel circular;
	
	private static boolean haveToken = false;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.otp_new_layout);
		Log.i("Oncreate","");
		btnGerar = (Button) findViewById(R.id.btnGerar);
		btnQRcode = (Button) findViewById(R.id.btnQRcode);
		lblOTP = (TextView) findViewById(R.id.lblOTP);
		lblExpire = (TextView) findViewById(R.id.lblExpire);
		lblCount = (TextView) findViewById(R.id.lblcount);
		lbluser = (TextView) findViewById(R.id.lbluser);
		txtSecret = (EditText) findViewById(R.id.txtSecret);
		circular = (ProgressWheel) findViewById(R.id.progressWheel1);
		btnCopy = (LinearLayout) findViewById(R.id.btnCopy);
		getActionBar().setIcon(new ColorDrawable(getResources().getColor(android.R.color.transparent)));
		getActionBar().setBackgroundDrawable(new ColorDrawable(Color.parseColor("#ae0000")));
		getActionBar().setTitle("TOKEN OTP");
		gerarOTP();

		btnQRcode.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View arg0) {

				adicionar();

			}
		});
		
		btnCopy.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				
				ClipboardManager _clipboard = (ClipboardManager) LoginTestMainActivity.this.getSystemService(Context.CLIPBOARD_SERVICE);
				ClipData clip = ClipData.newPlainText("token", lblOTP.getText().toString());
				_clipboard.setPrimaryClip(clip);
				
				Toast.makeText(getApplicationContext(), "Token "+_clipboard.getPrimaryClip().getItemAt(0).getText()+" copiado", Toast.LENGTH_LONG).show();
				
			}
		});

	}
	
	public void adicionar(){
		if (isQrCodeInstalled()) {
			Intent intent = new Intent(
					"com.google.zxing.client.android.SCAN");
			intent.putExtra("SCAN_MODE", "QR_CODE_MODE");
			startActivityForResult(intent, 0);
		} else {

			Toast.makeText(
					LoginTestMainActivity.this,
					"O Aplicativo Barcode Scan não está instalado. \nFavor instalar no Google Play",
					Toast.LENGTH_LONG).show();
		}
	}
	
	
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		
		 MenuInflater inflater = getMenuInflater();
	        inflater.inflate(R.menu.login_test_main, menu);
		return super.onCreateOptionsMenu(menu);
	}
	@Override
	public boolean onMenuItemSelected(int featureId, MenuItem item) {
		 switch (item.getItemId()) {
	        case R.id.action_add:
	        	adicionar();
	            return true;
	      
	        default:
	            return super.onOptionsItemSelected(item);
	        }
	}

	public Boolean isQrCodeInstalled() {
		android.content.pm.PackageManager mPm = getPackageManager(); // 1
		PackageInfo info = null;
		try {
			info = mPm.getPackageInfo("com.google.zxing.client.android", 0);
		} catch (NameNotFoundException e) {
			e.printStackTrace();
		} // 2,3
		return info != null;
	}

	public void saveSecret(String secret, String user) {

		txtSecret.setText("");
		totp = null;

		try {
			totp = new Totp(secret);
			// verifica se a chave é valida
			totp.now();

			preferences = PreferenceManager.getDefaultSharedPreferences(this);
			SharedPreferences.Editor editor = preferences.edit();
			editor.putString("SECRET", secret);

			editor.apply();

		} catch (Exception e) {
			// chave nao é valida
			totp = null;
			Toast.makeText(this,
					"Codigo com formato invalido, por favor verifique",
					Toast.LENGTH_LONG).show();
			return;
		}

	}

	public String getSecret() {

		preferences = PreferenceManager.getDefaultSharedPreferences(this);
		this.testeSecret = preferences.getString("SECRET", "");
		if (!testeSecret.equals("")) {
			haveToken = true;
		} else {
			haveToken = false;
		}

		return testeSecret;

	}

	public void gerarOTP() {
		
		if (totp==null) {
			String secret = getSecret();
			if (!haveToken) {
				hideContador();
				Toast.makeText(
						this,
						"Adicione uma semente,capture um codigo QRCode",
						Toast.LENGTH_LONG).show();
				return;
			}else{
				try {
					totp = new Totp(secret);

				} catch (Exception e) {
					Toast.makeText(this,
							"Codigo com formato invalido, por favor verifique",
							Toast.LENGTH_LONG).show();
					return;
				}
			}
		}
	
		showContador();
		iniciaCounter();
		lblOTP.setText(totp.now());

		android.util.Log.i("OTP URI", totp.uri("Teste"));
	}

	public void iniciaCounter() {

		
		long time = System.currentTimeMillis();
		Log.i("Time", "" + time);
		Timestamp timestamp = new Timestamp(time);
		Log.i("Timestamp", "" + timestamp);
		long intervalo = (30 - (timestamp.getSeconds() % 30)) * 1000;
		Log.i("Intervalo", "" + "" + intervalo);
		counter = new CountDownTimer(intervalo, 1000) {

			public void onTick(long millisUntilFinished) {
				lblCount.setText("" + millisUntilFinished / 1000);
				Double d = (double) millisUntilFinished/1000;
				Double percent = d /30.0;
//				indicator.setPhase(percent);
				circular.setProgress(d.intValue()*12);
				circular.setText(""+d.intValue()+" sec");
			}

			public void onFinish() {
				
				gerarOTP();
				circular.resetCount();
				
			}
		}.start();
	}

	public void showContador() {
		circular.setVisibility(View.VISIBLE);
		lblExpire.setVisibility(View.VISIBLE);
		btnCopy.setVisibility(View.VISIBLE);
	}

	public void hideContador() {
		circular.setVisibility(View.GONE);
		lblExpire.setVisibility(View.GONE);
		btnCopy.setVisibility(View.GONE);
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode,
			Intent intent) {

		if (requestCode == 0) {
			if (resultCode == RESULT_OK) {
				try {
					URI contents = URI.create(intent
							.getStringExtra("SCAN_RESULT"));
					List<NameValuePair> list = URLEncodedUtils.parse(contents,
							"UTF-8");
					String name = contents.getPath().replace("/", "");
					String value = list.get(0).getValue();
					this.testeSecret = value;
					this.user = name;
					saveSecret(value, name);
					gerarOTP();
				} catch (Exception e) {
					Toast.makeText(this,
							"Codigo com formato invalido, por favor verifique",
							Toast.LENGTH_LONG).show();
				}

			} else if (resultCode == RESULT_CANCELED) {
				// Handle cancel
			}
		}

	}

}
