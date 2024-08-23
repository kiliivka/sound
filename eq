package com.soundamplifier.volumeboosterforandroid.volumeboostergoodev.bassboosterequalizer.activities;

import android.app.Dialog;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.RatingBar;
import android.widget.Toast;
import androidx.activity.OnBackPressedCallback;
import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import com.facebook.ads.*;
import com.google.gson.Gson;
import com.soundamplifier.volumeboosterforandroid.volumeboostergoodev.bassboosterequalizer.R;
import com.soundamplifier.volumeboosterforandroid.volumeboostergoodev.bassboosterequalizer.Utility.EqualizerSettings;
import com.soundamplifier.volumeboosterforandroid.volumeboostergoodev.bassboosterequalizer.Utility.HelperResizer;
import com.soundamplifier.volumeboosterforandroid.volumeboostergoodev.bassboosterequalizer.fragments.EqualizerFragment;
import com.soundamplifier.volumeboosterforandroid.volumeboostergoodev.bassboosterequalizer.model.EqualizerModel;
import com.soundamplifier.volumeboosterforandroid.volumeboostergoodev.bassboosterequalizer.model.Settings;
import com.soundamplifier.volumeboosterforandroid.volumeboostergoodev.bassboosterequalizer.services.MusicService;
import com.soundamplifier.volumeboosterforandroid.volumeboostergoodev.bassboosterequalizer.services.VolumeBoosterService;

import java.util.ArrayList;
import java.util.List;

public class MainHomeActivity extends AppCompatActivity {

    public static final String PREF_KEY = "equalizer";
    private static final int PERMISSION_REQUEST_CODE = 123;
    boolean enable_flag;
    FrameLayout eqFrame;
    EqualizerFragment equalizerFragment;
    Context mContext;
    int sessionId;
    SharedPreferences sharedPreferences;
    private InterstitialAd interstitialAd;

    @Override
    public void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        setContentView((int) R.layout.activity_main_home);
        this.mContext = this;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            Window window = getWindow();
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            window.setStatusBarColor(getResources().getColor(R.color.main));
        }
        AdSettings.addTestDevice("HASHED ID");
        checkAndRequestPermissions();
        init();
        resize();
        loadFanInterstitialAd();
        getOnBackPressedDispatcher().addCallback(this, new OnBackPressedCallback(true) {
            @Override
            public void handleOnBackPressed() {
                showRatingDialog();
            }
        });
    }

    private void checkAndRequestPermissions() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            String[] permissions = {
                    android.Manifest.permission.INTERNET,
                    android.Manifest.permission.MODIFY_AUDIO_SETTINGS,
                    android.Manifest.permission.ACCESS_NETWORK_STATE,
                    android.Manifest.permission.READ_EXTERNAL_STORAGE,
                    android.Manifest.permission.WRITE_EXTERNAL_STORAGE
            };
            List<String> permissionsToRequest = new ArrayList<>();
            for (String permission : permissions) {
                if (ContextCompat.checkSelfPermission(this, permission) != PackageManager.PERMISSION_GRANTED) {
                    permissionsToRequest.add(permission);
                }
            }
            if (!permissionsToRequest.isEmpty()) {
                ActivityCompat.requestPermissions(this, permissionsToRequest.toArray(new String[0]), PERMISSION_REQUEST_CODE);
            }
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == PERMISSION_REQUEST_CODE) {
            boolean allGranted = true;
            for (int result : grantResults) {
                if (result != PackageManager.PERMISSION_GRANTED) {
                    allGranted = false;
                    break;
                }
            }
            if (allGranted) {
                Toast.makeText(MainHomeActivity.this, "Welcome To Headphone Booster", Toast.LENGTH_LONG).show();
            } else {
                Toast.makeText(MainHomeActivity.this, "Welcome To Headphone Booster", Toast.LENGTH_LONG).show();
            }
        }
    }

    private void loadFanInterstitialAd() {
        String fanPlacementId = getString(R.string.fan_placement_id);
        interstitialAd = new InterstitialAd(this, fanPlacementId);
        InterstitialAdListener interstitialAdListener = new InterstitialAdListener() {
            @Override
            public void onInterstitialDisplayed(Ad ad) {}
            @Override
            public void onInterstitialDismissed(Ad ad) {}
            @Override
            public void onError(Ad ad, AdError adError) {}
            @Override
            public void onAdLoaded(Ad ad) {}
            @Override
            public void onAdClicked(Ad ad) {}
            @Override
            public void onLoggingImpression(Ad ad) {}
        };
        interstitialAd.loadAd(
                interstitialAd.buildLoadAdConfig()
                        .withAdListener(interstitialAdListener)
                        .build());
    }

    private void showFanInterstitialAd() {
        if (interstitialAd == null || !interstitialAd.isAdLoaded()) {
            return;
        }
        interstitialAd.show();
    }

    private void resize() {
        HelperResizer.getheightandwidth(this.mContext);
    }

    @Override
    public void onResume() {
        super.onResume();
        if (MusicService.mediaPlayer == null) {
            MusicService.mediaPlayer = MediaPlayer.create(this.mContext, R.raw.lenka);
        }
    }

    private void init() {
        this.eqFrame = findViewById(R.id.eqFrame);
        VolumeBoosterService.init(this.mContext);
        loadEqualizerSettings();
        if (MusicService.mediaPlayer == null) {
            MusicService.mediaPlayer = MediaPlayer.create(this.mContext, R.raw.lenka);
        }
        this.sessionId = MusicService.mediaPlayer.getAudioSessionId();
        MusicService.mediaPlayer.setLooping(true);
        this.equalizerFragment = EqualizerFragment.newBuilder()
                .setAccentColor(Color.parseColor("#4caf50"))
                .setAudioSessionId(this.sessionId)
                .build();
        getSupportFragmentManager().beginTransaction().replace(R.id.eqFrame, this.equalizerFragment).commit();
        this.sharedPreferences = this.mContext.getSharedPreferences("mypref", 0);
        this.enable_flag = this.sharedPreferences.getBoolean("myswitch", true);
    }

    private void loadEqualizerSettings() {
        EqualizerSettings equalizerSettings = new Gson().fromJson(
                PreferenceManager.getDefaultSharedPreferences(this).getString(PREF_KEY, "{}"),
                EqualizerSettings.class);
        EqualizerModel equalizerModel = new EqualizerModel();
        equalizerModel.setBassStrength(equalizerSettings.bassStrength);
        equalizerModel.setPresetPos(equalizerSettings.presetPos);
        equalizerModel.setReverbPreset(equalizerSettings.reverbPreset);
        equalizerModel.setSeekbarpos(equalizerSettings.seekbarpos);
        Settings.isEqualizerEnabled = true;
        Settings.isEqualizerReloaded = true;
        Settings.bassStrength = equalizerSettings.bassStrength;
        Settings.presetPos = equalizerSettings.presetPos;
        Settings.reverbPreset = equalizerSettings.reverbPreset;
        Settings.seekbarpos = equalizerSettings.seekbarpos;
        Settings.equalizerModel = equalizerModel;
    }

    @Override
    public void onStop() {
        super.onStop();
        saveEqualizerSettings(this.mContext);
    }

    public static void saveEqualizerSettings(Context context) {
        if (Settings.equalizerModel != null) {
            EqualizerSettings equalizerSettings = new EqualizerSettings();
            equalizerSettings.bassStrength = Settings.equalizerModel.getBassStrength();
            equalizerSettings.presetPos = Settings.equalizerModel.getPresetPos();
            equalizerSettings.reverbPreset = Settings.equalizerModel.getReverbPreset();
            equalizerSettings.seekbarpos = Settings.equalizerModel.getSeekbarpos();
            PreferenceManager.getDefaultSharedPreferences(context).edit()
                    .putString(PREF_KEY, new Gson().toJson(equalizerSettings)).apply();
        }
    }

    private Dialog ratingDialog;

    private void showRatingDialog() {
        ratingDialog = new Dialog(this);
        ratingDialog.getWindow().requestFeature(Window.FEATURE_ACTION_BAR);
        ratingDialog.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        ratingDialog.setContentView(R.layout.dialog_rating);
        ratingDialog.setCancelable(false);
        ImageView rating_cancel_btn = ratingDialog.findViewById(R.id.cancel_button);
        RatingBar ratingBar = ratingDialog.findViewById(R.id.ratingBar);
        ratingBar.setOnRatingBarChangeListener((ratingBar1, rating, fromUser) -> {
            if (fromUser) {
                if (rating > 3) {
                    openPlayStore();
                } else {
                    ratingDialog.dismiss();
                    finish();
                }
            }
        });
        rating_cancel_btn.setOnClickListener(v -> {
            ratingDialog.dismiss();
            finish();
        });
        ratingDialog.show();
    }

    private void openPlayStore() {
        String packageName = getPackageName();
        Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=" + packageName));
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        try {
            startActivity(intent);
        } catch (ActivityNotFoundException e) {
            intent = new Intent(Intent.ACTION_VIEW,
                    Uri.parse("https://play.google.com/store/apps/details?id=" + packageName));
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            try {
                startActivity(intent);
            } catch (ActivityNotFoundException e2) {
                Toast.makeText(this, "Could not open Play Store", Toast.LENGTH_SHORT).show();
            }
        } finally {
            if (ratingDialog != null && ratingDialog.isShowing()) {
                ratingDialog.dismiss();
            }
        }
    }



}
