package com.soundamplifier.volumeboosterforandroid.volumeboostergoodev.bassboosterequalizer.fragments;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.app.PendingIntent;
import android.content.ActivityNotFoundException;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.graphics.Paint;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.media.audiofx.BassBoost;
import android.media.audiofx.Equalizer;
import android.media.audiofx.LoudnessEnhancer;
import android.media.audiofx.PresetReverb;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.os.VibrationEffect;
import android.os.Vibrator;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.SeekBar;
import android.widget.TextView;
import android.widget.Toast;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.view.GravityCompat;
import androidx.drawerlayout.widget.DrawerLayout;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;
import androidx.recyclerview.widget.ItemTouchHelper;


import com.soundamplifier.volumeboosterforandroid.volumeboostergoodev.bassboosterequalizer.R;
import com.soundamplifier.volumeboosterforandroid.volumeboostergoodev.bassboosterequalizer.Utility.AnalogController;
import com.soundamplifier.volumeboosterforandroid.volumeboostergoodev.bassboosterequalizer.Utility.CircleSeekBar;
import com.soundamplifier.volumeboosterforandroid.volumeboostergoodev.bassboosterequalizer.Utility.HelperResizer;
import com.soundamplifier.volumeboosterforandroid.volumeboostergoodev.bassboosterequalizer.Utility.KnobImageViewUtils;
import com.soundamplifier.volumeboosterforandroid.volumeboostergoodev.bassboosterequalizer.Utility.LedView;
import com.soundamplifier.volumeboosterforandroid.volumeboostergoodev.bassboosterequalizer.Utility.MyUtils;
import com.soundamplifier.volumeboosterforandroid.volumeboostergoodev.bassboosterequalizer.Utility.RotaryKnob;
import com.soundamplifier.volumeboosterforandroid.volumeboostergoodev.bassboosterequalizer.activities.MainHomeActivity;
import com.soundamplifier.volumeboosterforandroid.volumeboostergoodev.bassboosterequalizer.activities.PlayerActivity;
import com.soundamplifier.volumeboosterforandroid.volumeboostergoodev.bassboosterequalizer.interfaces.IOnBackPressed;
import com.soundamplifier.volumeboosterforandroid.volumeboostergoodev.bassboosterequalizer.interfaces.OnMediaListener;
import com.soundamplifier.volumeboosterforandroid.volumeboostergoodev.bassboosterequalizer.interfaces.OnTrackListener;
import com.soundamplifier.volumeboosterforandroid.volumeboostergoodev.bassboosterequalizer.model.AudioModel;
import com.soundamplifier.volumeboosterforandroid.volumeboostergoodev.bassboosterequalizer.model.EqualizerModel;
import com.soundamplifier.volumeboosterforandroid.volumeboostergoodev.bassboosterequalizer.model.Settings;
import com.soundamplifier.volumeboosterforandroid.volumeboostergoodev.bassboosterequalizer.services.MusicService;
import com.soundamplifier.volumeboosterforandroid.volumeboostergoodev.bassboosterequalizer.services.NotificationService;
import com.soundamplifier.volumeboosterforandroid.volumeboostergoodev.bassboosterequalizer.services.VolumeBoosterService;

import java.util.ArrayList;
import java.util.Random;

public class EqualizerFragment extends Fragment implements IOnBackPressed {
    public static final String ARG_AUDIO_SESSIOIN_ID = "audio_session_id";
    public static BassBoost bassBoost;
    static EqualizerFragment fragment;
    public static LedView led_right_1;
    public static LedView led_right_2;
    public static Equalizer mEqualizer;
    public static LedView mLedLeft1;
    public static LedView mLedLeft2;
    public static ImageView play;
    public static PresetReverb presetReverb;
    static boolean showBackButton = true;
    public static Handler someHandler;
    public static Handler someHandler2;
    public static TextView song_txt;
    public static TextView textView;
    public static int themeColor = Color.parseColor("#FFA036");
    private FrameLayout adContainerView;
    private int audioSesionId;
    ImageView backBtn;
    AnalogController bassController;
    TextView bass_pg;
    private RotaryKnob bass_rotaryKnobEars = null;
    AnalogController circular;
    CircleSeekBar circular_bass;
    CircleSeekBar circular_vir;
    LinearLayout drawer;
    DrawerLayout drawer_layout;

    public RotaryKnob earsKnob = null;
    boolean enable_flag;
    LinearLayout eq_layer;
    ImageView eq_switch;
    ArrayList<String> equalizerPresetNames;
    ArrayAdapter<String> equalizerPresetSpinnerAdapter;
    ImageView equalizerSwitch;
    RelativeLayout fd_rel;
    ImageView firstimg;
    ImageView ic_bass;
    ImageView ic_enable;
    ImageView ic_eq;
    ImageView ic_hun;
    ImageView ic_max;
    ImageView ic_mute;
    ImageView ic_onesevfive;
    ImageView ic_onetwentyfive;
    ImageView ic_onfifty;
    ImageView ic_sixty_btn;
    ImageView ic_thirty_btn;
    ImageView ic_vibrate;
    ImageView ic_vir;
    ImageView ic_visu;
    ImageView ic_visulizer;
    ImageView ic_vol;
    ImageView ic_vol_icon;
    ImageView iv_next;
    ImageView iv_previous;
    LinearLayout layfive;
    LinearLayout layfour;
    LinearLayout layone;
    ImageView layone_off;
    LinearLayout laythree;
    LinearLayout laytwo;
    ImageView laytwo_off;
    Context mContext;
    LinearLayout mLinearLayout;
    LinearLayout main_bg;
    RelativeLayout main_rel;
    ImageView main_round_btm;
    ImageView main_round_btm2;

    public MusicService myService;
    LinearLayout nrm_bg;
    short numberOfFrequencyBands;
    OnMediaListener onMediaListener;
    OnTrackListener onTrackListener;
    Paint paint;
    float[] points;
    AnalogController reverbController;
    RelativeLayout sd_rel;
    ImageView secondimg;
    SeekBar seek1;
    SeekBar seek2;
    SeekBar seek3;
    SeekBar seek4;
    SeekBar seek5;
    SeekBar seekBar;
    SeekBar[] seekBarFinal = new SeekBar[5];
    ImageView seek_dot1;
    ImageView seek_dot2;
    ImageView seek_dot3;
    ImageView seek_dot4;
    ImageView seek_dot5;
    private ServiceConnection serviceConnection = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName componentName, IBinder iBinder) {
            Log.e("AAA", "Binder Connected");
            MusicService unused = EqualizerFragment.this.myService = ((MusicService.LocalBinder) iBinder).getService();
            EqualizerFragment.this.myService.setCallbacks(EqualizerFragment.this.onTrackListener);
            EqualizerFragment.this.myService.setMediaListener(EqualizerFragment.this.onMediaListener);
        }

        @Override
        public void onServiceDisconnected(ComponentName componentName) {
            Log.e("AAA", "Binder Disconnected");
        }
    };
    SharedPreferences sharedPreferences;
    LinearLayout spect;
    LinearLayout spect1;
    LinearLayout spect2;
    LinearLayout spect3;
    LinearLayout spect4;
    ImageView tap_icon;
    LinearLayout tap_layout;
    ImageView thirdimg;
    LinearLayout top_bar;
    ImageView top_icon;
    TextView tx_bass;
    TextView tx_vir;
    TextView txt_preset;
    View view;
    private RotaryKnob vir_rotaryKnobEars = null;
    TextView virtu_pg;
    LinearLayout vol_layer;
    SeekBar vol_seek;
    int y = 0;

    public static EqualizerFragment newInstance(int i) {
        Bundle bundle = new Bundle();
        bundle.putInt(ARG_AUDIO_SESSIOIN_ID, i);
        fragment = new EqualizerFragment();
        fragment.setArguments(bundle);
        return fragment;
    }

    @Override
    public void onCreate(@Nullable Bundle bundle) {
        super.onCreate(bundle);
        Settings.isEditing = true;
        if (getArguments() != null && getArguments().containsKey(ARG_AUDIO_SESSIOIN_ID)) {
            this.audioSesionId = getArguments().getInt(ARG_AUDIO_SESSIOIN_ID);
        }
        if (Settings.equalizerModel == null) {
            Settings.equalizerModel = new EqualizerModel();
            Settings.equalizerModel.setReverbPreset((short) 0);
            Settings.equalizerModel.setBassStrength((short) 52);
        }
        try {
            mEqualizer = new Equalizer(0, this.audioSesionId);
            bassBoost = new BassBoost(0, this.audioSesionId);
            bassBoost.setEnabled(Settings.isEqualizerEnabled);
            BassBoost.Settings settings = new BassBoost.Settings(bassBoost.getProperties().toString());
            settings.strength = Settings.equalizerModel.getBassStrength();
            bassBoost.setProperties(settings);
            presetReverb = new PresetReverb(0, this.audioSesionId);
            presetReverb.setPreset(Settings.equalizerModel.getReverbPreset());
            presetReverb.setEnabled(Settings.isEqualizerEnabled);
            mEqualizer.setEnabled(Settings.isEqualizerEnabled);
        } catch (Exception e) {
            e.printStackTrace();
            try {
                mEqualizer = new Equalizer(0, this.audioSesionId);
                bassBoost = new BassBoost(0, this.audioSesionId);
                bassBoost.setEnabled(Settings.isEqualizerEnabled);
                BassBoost.Settings settings2 = new BassBoost.Settings(bassBoost.getProperties().toString());
                settings2.strength = Settings.equalizerModel.getBassStrength();
                bassBoost.setProperties(settings2);
                presetReverb = new PresetReverb(0, this.audioSesionId);
                presetReverb.setPreset(Settings.equalizerModel.getReverbPreset());
                presetReverb.setEnabled(Settings.isEqualizerEnabled);
                mEqualizer.setEnabled(Settings.isEqualizerEnabled);
            } catch (Exception e2) {
                e2.printStackTrace();
            }
        }

    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        this.mContext = context;
    }

    @Override
    public View onCreateView(@NonNull LayoutInflater layoutInflater, ViewGroup viewGroup, Bundle bundle) {
        int i = 0;
        PresetReverb presetReverb2;
        int i2;
        this.view = LayoutInflater.from(this.mContext).inflate(R.layout.fragment_main_home_layout, viewGroup, false);
        HelperResizer.getheightandwidth(getContext());
        this.seek1 = (SeekBar) this.view.findViewById(R.id.seekBar1);
        this.seek2 = (SeekBar) this.view.findViewById(R.id.seekBar2);
        this.seek3 = (SeekBar) this.view.findViewById(R.id.seekBar3);
        this.seek4 = (SeekBar) this.view.findViewById(R.id.seekBar4);
        this.seek5 = (SeekBar) this.view.findViewById(R.id.seekBar5);
        this.laytwo_off = (ImageView) this.view.findViewById(R.id.laytwo_off);
        this.layone_off = (ImageView) this.view.findViewById(R.id.layone_off);
        this.tx_vir = (TextView) this.view.findViewById(R.id.tx_vir);
        this.tx_bass = (TextView) this.view.findViewById(R.id.tx_bass);
        this.virtu_pg = (TextView) this.view.findViewById(R.id.virtu_pg);
        this.circular_vir = (CircleSeekBar) this.view.findViewById(R.id.circular_vir);
        this.ic_vir = (ImageView) this.view.findViewById(R.id.ic_vir);
        this.main_round_btm2 = (ImageView) this.view.findViewById(R.id.main_round_btm2);
        this.sd_rel = (RelativeLayout) this.view.findViewById(R.id.sd_rel);
        this.bass_pg = (TextView) this.view.findViewById(R.id.bass_pg);
        this.ic_bass = (ImageView) this.view.findViewById(R.id.ic_bass);
        this.circular_bass = (CircleSeekBar) this.view.findViewById(R.id.circular_bass);
        this.main_round_btm = (ImageView) this.view.findViewById(R.id.main_round_btm);
        this.fd_rel = (RelativeLayout) this.view.findViewById(R.id.fd_rel);
        this.main_rel = (RelativeLayout) this.view.findViewById(R.id.main_rel);
        this.circular = (AnalogController) this.view.findViewById(R.id.circular);
        this.ic_max = (ImageView) this.view.findViewById(R.id.ic_max);
        this.ic_onesevfive = (ImageView) this.view.findViewById(R.id.ic_onsix);
        this.ic_onetwentyfive = (ImageView) this.view.findViewById(R.id.ic_onthree);
        this.ic_onfifty = (ImageView) this.view.findViewById(R.id.ic_onfifty);
        this.ic_hun = (ImageView) this.view.findViewById(R.id.ic_hun);
        this.ic_thirty_btn = (ImageView) this.view.findViewById(R.id.ic_normal_btn);
        this.ic_mute = (ImageView) this.view.findViewById(R.id.ic_mute);
        this.ic_sixty_btn = (ImageView) this.view.findViewById(R.id.ic_sixty_btn);
        this.vol_seek = (SeekBar) this.view.findViewById(R.id.vol_seek);
        this.eq_layer = (LinearLayout) this.view.findViewById(R.id.eq_layer);
        this.vol_layer = (LinearLayout) this.view.findViewById(R.id.vol_layer);
        this.spect = (LinearLayout) this.view.findViewById(R.id.spect);
        this.spect1 = (LinearLayout) this.view.findViewById(R.id.spect1);
        this.spect2 = (LinearLayout) this.view.findViewById(R.id.spect2);
        this.spect3 = (LinearLayout) this.view.findViewById(R.id.spect3);
        this.spect4 = (LinearLayout) this.view.findViewById(R.id.spect4);
        this.nrm_bg = (LinearLayout) this.view.findViewById(R.id.nrm_bg);
        this.ic_vol = (ImageView) this.view.findViewById(R.id.ic_vol);
        this.ic_eq = (ImageView) this.view.findViewById(R.id.ic_eq);
        this.drawer_layout = (DrawerLayout) this.view.findViewById(R.id.drawer_layout);
        this.top_icon = (ImageView) this.view.findViewById(R.id.top_icon);
        this.drawer = (LinearLayout) this.view.findViewById(R.id.drawer);
        this.ic_vibrate = (ImageView) this.view.findViewById(R.id.ic_vibrate);
        this.ic_enable = (ImageView) this.view.findViewById(R.id.ic_enable);
        this.ic_visu = (ImageView) this.view.findViewById(R.id.ic_visu);
        this.ic_visulizer = (ImageView) this.view.findViewById(R.id.ic_visulizer);
        this.layone = (LinearLayout) this.view.findViewById(R.id.layone);
        this.laytwo = (LinearLayout) this.view.findViewById(R.id.laytwo);
        this.laythree = (LinearLayout) this.view.findViewById(R.id.laythree);
        this.layfive = (LinearLayout) this.view.findViewById(R.id.layfive);
        this.layfour = (LinearLayout) this.view.findViewById(R.id.layfour);
        this.top_bar = (LinearLayout) this.view.findViewById(R.id.top_bar);
        this.backBtn = (ImageView) this.view.findViewById(R.id.equalizer_back_btn);
        this.eq_switch = (ImageView) this.view.findViewById(R.id.eq_switch);
        this.txt_preset = (TextView) this.view.findViewById(R.id.txt_preset);
        this.iv_previous = (ImageView) this.view.findViewById(R.id.iv_previous);
        this.iv_next = (ImageView) this.view.findViewById(R.id.iv_next);
        play = (ImageView) this.view.findViewById(R.id.play);
        song_txt = (TextView) this.view.findViewById(R.id.song_txt);
        this.firstimg = (ImageView) this.view.findViewById(R.id.firstimg);
        this.secondimg = (ImageView) this.view.findViewById(R.id.secondimg);
        this.thirdimg = (ImageView) this.view.findViewById(R.id.thirdimg);
        this.ic_vol_icon = (ImageView) this.view.findViewById(R.id.ic_vol_icon);
        this.tap_layout = (LinearLayout) this.view.findViewById(R.id.tap_layout);
        this.tap_icon = (ImageView) this.view.findViewById(R.id.tap_icon);
        this.main_bg = (LinearLayout) this.view.findViewById(R.id.main_bg);
        this.equalizerSwitch = (ImageView) this.view.findViewById(R.id.equalizer_switch);
        this.seek_dot1 = (ImageView) this.view.findViewById(R.id.seek_dot1);
        this.seek_dot2 = (ImageView) this.view.findViewById(R.id.seek_dot2);
        this.seek_dot3 = (ImageView) this.view.findViewById(R.id.seek_dot3);
        this.seek_dot4 = (ImageView) this.view.findViewById(R.id.seek_dot4);
        this.seek_dot5 = (ImageView) this.view.findViewById(R.id.seek_dot5);
        mLedLeft1 = (LedView) this.view.findViewById(R.id.led_left_1);
        led_right_1 = (LedView) this.view.findViewById(R.id.led_right_1);
        mLedLeft2 = (LedView) this.view.findViewById(R.id.led_left_2);
        led_right_2 = (LedView) this.view.findViewById(R.id.led_right_2);
        this.earsKnob = (RotaryKnob) this.view.findViewById(R.id.rotaryKnobEars);
        this.bass_rotaryKnobEars = (RotaryKnob) this.view.findViewById(R.id.bass_rotaryKnobEars);
        this.vir_rotaryKnobEars = (RotaryKnob) this.view.findViewById(R.id.vir_rotaryKnobEars);
        song_txt.setSelected(true);
        AudioManager audioManager = (AudioManager) this.mContext.getSystemService(Context.AUDIO_SERVICE);
        this.sharedPreferences = getContext().getSharedPreferences("mypref", 0);
        this.enable_flag = this.sharedPreferences.getBoolean("myswitch", true);
        this.eq_switch.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (EqualizerFragment.this.sharedPreferences.getBoolean("myswitch", true)) {
                    EqualizerFragment.this.enable_flag = false;
                    try {
                        Settings.isEqualizerEnabled = false;
                        Settings.equalizerModel.setEqualizerEnabled(false);
                        EqualizerFragment.mEqualizer.setEnabled(false);
                        EqualizerFragment.bassBoost.setEnabled(false);
                        EqualizerFragment.presetReverb.setEnabled(false);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    EqualizerFragment.this.eq_switch.setImageResource(R.drawable.toggle_off);
                } else {
                    EqualizerFragment.this.enable_flag = true;
                    try {
                        Settings.isEqualizerEnabled = true;
                        Settings.equalizerModel.setEqualizerEnabled(true);
                        EqualizerFragment.mEqualizer.setEnabled(true);
                        EqualizerFragment.bassBoost.setEnabled(true);
                        EqualizerFragment.presetReverb.setEnabled(true);
                    } catch (Exception e2) {
                        e2.printStackTrace();
                    }
                    EqualizerFragment.this.eq_switch.setImageResource(R.drawable.toggle_on);
                }
                SharedPreferences.Editor edit = EqualizerFragment.this.sharedPreferences.edit();
                edit.putBoolean("myswitch", EqualizerFragment.this.enable_flag);
                edit.apply();
                Settings.equalizerModel.setEqualizerEnabled(EqualizerFragment.this.enable_flag);
                EqualizerFragment.this.sendEQ();
                if (EqualizerFragment.this.enable_flag) {
                    EqualizerFragment.this.seek1.setEnabled(true);
                    EqualizerFragment.this.seek2.setEnabled(true);
                    EqualizerFragment.this.seek3.setEnabled(true);
                    EqualizerFragment.this.seek4.setEnabled(true);
                    EqualizerFragment.this.seek5.setEnabled(true);
                    return;
                }
                EqualizerFragment.this.seek1.setEnabled(false);
                EqualizerFragment.this.seek2.setEnabled(false);
                EqualizerFragment.this.seek3.setEnabled(false);
                EqualizerFragment.this.seek4.setEnabled(false);
                EqualizerFragment.this.seek5.setEnabled(false);
            }
        });
        this.paint = new Paint();
        this.bassController = (AnalogController) this.view.findViewById(R.id.controllerBass);
        this.reverbController = (AnalogController) this.view.findViewById(R.id.controller3D);
        AnalogController analogController = this.bassController;
        AnalogController.circlePaint2.setColor(themeColor);
        AnalogController analogController2 = this.bassController;
        AnalogController.linePaint.setColor(themeColor);
        this.bassController.invalidate();
        AnalogController analogController3 = this.reverbController;
        AnalogController.circlePaint2.setColor(themeColor);
        AnalogController analogController4 = this.bassController;
        AnalogController.linePaint.setColor(themeColor);
        this.reverbController.invalidate();
        if (!Settings.isEqualizerReloaded) {
            BassBoost bassBoost2 = bassBoost;
            if (bassBoost2 != null) {
                try {
                    i = (bassBoost2.getRoundedStrength() * 19) / 1000;
                } catch (Exception e) {
                    e.printStackTrace();
                }
                presetReverb2 = presetReverb;
                if (presetReverb2 != null) {
                    try {
                        this.y = (presetReverb2.getPreset() * 19) / 6;
                    } catch (Exception e2) {
                        e2.printStackTrace();
                    }
                }
                if (i != 0) {
                    this.bassController.setProgress(1);
                } else {
                    this.bassController.setProgress(i);
                }
                i2 = this.y;
                if (i2 != 0) {
                    this.reverbController.setProgress(1);
                } else {
                    this.reverbController.setProgress(i2);
                }
            }
            i = 0;
            presetReverb2 = presetReverb;
            if (presetReverb2 != null) {
            }
            if (i != 0) {
            }
            i2 = this.y;
            if (i2 != 0) {
            }
        } else {
            int i3 = (Settings.bassStrength * 19) / 1000;
            this.y = (Settings.reverbPreset * 19) / 6;
            if (i3 == 0) {
                this.bassController.setProgress(1);
            } else {
                this.bassController.setProgress(i3);
            }
            int i4 = this.y;
            if (i4 == 0) {
                this.reverbController.setProgress(1);
            } else {
                this.reverbController.setProgress(i4);
            }
        }
        this.bassController.setOnProgressChangedListener(new AnalogController.onProgressChangedListener() {
            @Override
            public void onProgressChanged(int i) {
                Settings.bassStrength = (short) ((int) (((float) i) * 52.63158f));
                try {
                    EqualizerFragment.bassBoost.setStrength(Settings.bassStrength);
                    Settings.equalizerModel.setBassStrength(Settings.bassStrength);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
        this.reverbController.setOnProgressChangedListener(new AnalogController.onProgressChangedListener() {
            @Override
            public void onProgressChanged(int i) {
                Settings.reverbPreset = (short) ((i * 6) / 19);
                Settings.equalizerModel.setReverbPreset(Settings.reverbPreset);
                try {
                    EqualizerFragment.presetReverb.setPreset(Settings.reverbPreset);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                EqualizerFragment.this.y = i;
            }
        });
        this.mLinearLayout = (LinearLayout) this.view.findViewById(R.id.equalizerContainer);
        TextView textView2 = new TextView(getContext());
        textView2.setText("Equalizer");
        textView2.setTextSize(20.0f);
        textView2.setGravity(1);
        this.numberOfFrequencyBands = 5;
        this.points = new float[this.numberOfFrequencyBands];
        final short s = mEqualizer.getBandLevelRange()[0];
        short s2 = mEqualizer.getBandLevelRange()[1];
        for (short s3 = 0; s3 < this.numberOfFrequencyBands; s3 = (short) (s3 + 1)) {
            TextView textView3 = new TextView(getContext());
            textView3.setLayoutParams(new ViewGroup.LayoutParams(-1, -2));
            textView3.setGravity(1);
            textView3.setTextColor(Color.parseColor("#FFFFFF"));
            textView3.setText((mEqualizer.getCenterFreq(s3) / 1000) + "Hz");
            new LinearLayout(getContext()).setOrientation(LinearLayout.VERTICAL);
            TextView textView4 = new TextView(getContext());
            textView4.setLayoutParams(new ViewGroup.LayoutParams(-2, -1));
            textView4.setTextColor(Color.parseColor("#FFFFFF"));
            textView4.setText((s / 100) + "dB");
            TextView textView5 = new TextView(getContext());
            textView4.setLayoutParams(new ViewGroup.LayoutParams(-2, -2));
            textView5.setTextColor(Color.parseColor("#FFFFFF"));
            textView5.setText((s2 / 100) + "dB");
            new LinearLayout.LayoutParams(-1, -2).weight = 1.0f;
            this.seekBar = new SeekBar(getContext());
            textView = new TextView(getContext());
            switch (s3) {
                case 0:
                    this.seekBar = (SeekBar) this.view.findViewById(R.id.seekBar1);
                    textView = (TextView) this.view.findViewById(R.id.textView1);
                    break;
                case 1:
                    this.seekBar = (SeekBar) this.view.findViewById(R.id.seekBar2);
                    textView = (TextView) this.view.findViewById(R.id.textView2);
                    break;
                case 2:
                    this.seekBar = (SeekBar) this.view.findViewById(R.id.seekBar3);
                    textView = (TextView) this.view.findViewById(R.id.textView3);
                    break;
                case 3:
                    this.seekBar = (SeekBar) this.view.findViewById(R.id.seekBar4);
                    textView = (TextView) this.view.findViewById(R.id.textView4);
                    break;
                case 4:
                    this.seekBar = (SeekBar) this.view.findViewById(R.id.seekBar5);
                    textView = (TextView) this.view.findViewById(R.id.textView5);
                    break;
            }
            SeekBar[] seekBarArr = this.seekBarFinal;
            SeekBar seekBar2 = this.seekBar;
            seekBarArr[s3] = seekBar2;
            setEnableDisable(this.view, this.enable_flag, seekBar2, textView);
            this.seekBar.setId(s3);
            this.seekBar.setMax(s2 - s);
            if (Settings.isEqualizerReloaded) {
                this.points[s3] = (float) (Settings.seekbarpos[s3] - s);
                if (Settings.seekbarpos[s3] - s >= 2730) {
                    this.seekBar.setProgress(2730);
                } else {
                    this.seekBar.setProgress(Settings.seekbarpos[s3] - s);
                }
            } else {
                this.points[s3] = (float) (mEqualizer.getBandLevel(s3) - s);
                this.seekBar.setProgress(mEqualizer.getBandLevel(s3) - s);
                Settings.seekbarpos[s3] = mEqualizer.getBandLevel(s3);
                Settings.isEqualizerReloaded = true;
            }
            if (this.seek1.getProgress() <= 240) {
                this.seek_dot1.setImageResource(R.drawable.red_dot);
            } else {
                this.seek_dot1.setImageResource(R.drawable.purple_dot);
            }
            if (this.seek2.getProgress() <= 240) {
                this.seek_dot2.setImageResource(R.drawable.red_dot);
            } else {
                this.seek_dot2.setImageResource(R.drawable.purple_dot);
            }
            if (this.seek3.getProgress() <= 240) {
                this.seek_dot3.setImageResource(R.drawable.red_dot);
            } else {
                this.seek_dot3.setImageResource(R.drawable.purple_dot);
            }
            if (this.seek4.getProgress() <= 240) {
                this.seek_dot4.setImageResource(R.drawable.red_dot);
            } else {
                this.seek_dot4.setImageResource(R.drawable.purple_dot);
            }
            if (this.seek5.getProgress() <= 240) {
                this.seek_dot5.setImageResource(R.drawable.red_dot);
            } else {
                this.seek_dot5.setImageResource(R.drawable.purple_dot);
            }
            short finalS = s3;
            this.seekBar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
                @Override
                public void onProgressChanged(SeekBar seekBar, int i, boolean z) {
                    if (EqualizerFragment.this.getContext().getSharedPreferences("mypref", 0).getString("vibrate", "true").equalsIgnoreCase("true")) {
                        Vibrator vibrator = (Vibrator) EqualizerFragment.this.getContext().getSystemService(Context.VIBRATOR_SERVICE);
                        if (Build.VERSION.SDK_INT >= 26) {
                            vibrator.vibrate(VibrationEffect.createOneShot(100, -1));
                        } else {
                            vibrator.vibrate(100);
                        }
                    }
                    int max = seekBar.getMax() - 270;
                    if (seekBar.getProgress() >= max - 240) {
                        seekBar.setProgress(max);
                        EqualizerFragment.mEqualizer.setBandLevel(finalS, (short) (s + max));
                        EqualizerFragment.this.points[seekBar.getId()] = (float) (EqualizerFragment.mEqualizer.getBandLevel(finalS) - s);
                        Settings.seekbarpos[seekBar.getId()] = s + max;
                        Settings.equalizerModel.getSeekbarpos()[seekBar.getId()] = max + s;
                    } else if (seekBar.getProgress() <= 240) {
                        seekBar.setProgress(240);
                        EqualizerFragment.mEqualizer.setBandLevel(finalS, (short) (s + 240));
                        EqualizerFragment.this.points[seekBar.getId()] = (float) (EqualizerFragment.mEqualizer.getBandLevel(finalS) - s);
                        Settings.seekbarpos[seekBar.getId()] = s + 240;
                        Settings.equalizerModel.getSeekbarpos()[seekBar.getId()] = s + 240;
                    } else {
                        EqualizerFragment.mEqualizer.setBandLevel(finalS, (short) (s + i));
                        EqualizerFragment.this.points[seekBar.getId()] = (float) (EqualizerFragment.mEqualizer.getBandLevel(finalS) - s);
                        Settings.seekbarpos[seekBar.getId()] = s + i;
                        Settings.equalizerModel.getSeekbarpos()[seekBar.getId()] = i + s;
                    }
                }

                @Override
                public void onStartTrackingTouch(SeekBar seekBar) {
                    EqualizerFragment.this.txt_preset.setText("Custom");
                    SharedPreferences.Editor edit = EqualizerFragment.this.sharedPreferences.edit();
                    edit.putString("txt_preset", "Custom");
                    edit.putInt("presetpos", 0);
                    edit.apply();
                    Settings.presetPos = 0;
                    Settings.equalizerModel.setPresetPos(0);
                }

                @Override
                public void onStopTrackingTouch(SeekBar seekBar) {
                    MainHomeActivity.saveEqualizerSettings(EqualizerFragment.this.getContext());
                    EqualizerFragment.this.sendEQ();
                    if (EqualizerFragment.this.seek1.getProgress() <= 240) {
                        EqualizerFragment.this.seek_dot1.setImageResource(R.drawable.red_dot);
                    } else {
                        EqualizerFragment.this.seek_dot1.setImageResource(R.drawable.purple_dot);
                    }
                    if (EqualizerFragment.this.seek2.getProgress() <= 240) {
                        EqualizerFragment.this.seek_dot2.setImageResource(R.drawable.red_dot);
                    } else {
                        EqualizerFragment.this.seek_dot2.setImageResource(R.drawable.purple_dot);
                    }
                    if (EqualizerFragment.this.seek3.getProgress() <= 240) {
                        EqualizerFragment.this.seek_dot3.setImageResource(R.drawable.red_dot);
                    } else {
                        EqualizerFragment.this.seek_dot3.setImageResource(R.drawable.purple_dot);
                    }
                    if (EqualizerFragment.this.seek4.getProgress() <= 240) {
                        EqualizerFragment.this.seek_dot4.setImageResource(R.drawable.red_dot);
                    } else {
                        EqualizerFragment.this.seek_dot4.setImageResource(R.drawable.purple_dot);
                    }
                    if (EqualizerFragment.this.seek5.getProgress() <= 240) {
                        EqualizerFragment.this.seek_dot5.setImageResource(R.drawable.red_dot);
                    } else {
                        EqualizerFragment.this.seek_dot5.setImageResource(R.drawable.purple_dot);
                    }
                }
            });
        }
        this.txt_preset.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                EqualizerFragment.this.equalizeSound();
            }
        });
        this.paint.setColor(Color.parseColor("#555555"));
        this.paint.setStrokeWidth((float) (Settings.ratio * 1.1d));
        Button button = new Button(getContext());
        button.setBackgroundColor(themeColor);
        button.setTextColor(-1);
        this.txt_preset.setText(this.sharedPreferences.getString("txt_preset", "Normal"));
        this.backBtn.setOnClickListener(new View.OnClickListener() {
            @SuppressLint({"WrongConstant"})
            public void onClick(View view) {
                if (!EqualizerFragment.this.drawer_layout.isDrawerOpen((int) GravityCompat.START)) {
                    EqualizerFragment.this.drawer_layout.openDrawer((int) GravityCompat.START);
                } else {
                    EqualizerFragment.this.drawer_layout.closeDrawer((int) GravityCompat.START);
                }
            }
        });
        this.laythree.setOnClickListener(new View.OnClickListener() {
            @SuppressLint({"WrongConstant"})
            public void onClick(View view) {
                EqualizerFragment.this.laythree.setBackground(EqualizerFragment.this.getResources().getDrawable(R.drawable.button_press_bg));
                Intent intent = new Intent();
                intent.setAction("android.intent.action.SEND");
                intent.putExtra("android.intent.extra.TEXT", "Hey check out my app at: https://play.google.com/store/apps/details?id=" + EqualizerFragment.this.getContext().getPackageName());
                intent.setType("text/plain");
                EqualizerFragment.this.startActivity(intent);
                new Handler().postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        EqualizerFragment.this.drawer_layout.closeDrawer((int) GravityCompat.START);
                        EqualizerFragment.this.laythree.setBackgroundColor(0);
                    }
                }, 100);
            }
        });
        this.layfour.setOnClickListener(new View.OnClickListener() {
            @SuppressLint({"WrongConstant"})
            public void onClick(View view) {
                EqualizerFragment.this.layfour.setBackground(EqualizerFragment.this.getResources().getDrawable(R.drawable.button_press_bg));
                Intent intent = new Intent("android.intent.action.VIEW", Uri.parse("market://details?id=" + EqualizerFragment.this.getContext().getPackageName()));
                intent.addFlags(1208483840);
                try {
                    EqualizerFragment.this.startActivity(intent);
                } catch (ActivityNotFoundException unused) {
                    EqualizerFragment equalizerFragment = EqualizerFragment.this;
                    equalizerFragment.startActivity(new Intent("android.intent.action.VIEW", Uri.parse("http://play.google.com/store/apps/details?id=" + EqualizerFragment.this.getContext().getPackageName())));
                }
                new Handler().postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        EqualizerFragment.this.drawer_layout.closeDrawer((int) GravityCompat.START);
                        EqualizerFragment.this.layfour.setBackgroundColor(0);
                    }
                }, 100);
            }
        });
        this.layfive.setOnClickListener(new View.OnClickListener() {
            @SuppressLint({"WrongConstant"})
            public void onClick(View view) {
                EqualizerFragment.this.layfive.setBackground(EqualizerFragment.this.getResources().getDrawable(R.drawable.button_press_bg));
                new Handler().postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        EqualizerFragment.this.drawer_layout.closeDrawer((int) GravityCompat.START);
                        EqualizerFragment.this.layfive.setBackgroundColor(0);
                    }
                }, 100);

                Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(getString(R.string.privacy_link)));
                startActivity(intent);

            }
        });
        this.ic_eq.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                EqualizerFragment.this.eq_layer.setVisibility(View.VISIBLE);
                EqualizerFragment.this.vol_layer.setVisibility(View.GONE);
                EqualizerFragment.this.ic_eq.setImageResource(R.drawable.equalizer_pressed);
                EqualizerFragment.this.ic_vol.setImageResource(R.drawable.volume_unpressed);
            }
        });
        this.ic_vol.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                EqualizerFragment.this.eq_layer.setVisibility(View.GONE);
                EqualizerFragment.this.vol_layer.setVisibility(View.VISIBLE);
                EqualizerFragment.this.ic_vol.setImageResource(R.drawable.volume_pressed);
                EqualizerFragment.this.ic_eq.setImageResource(R.drawable.equalizer_unpressed);
            }
        });
        if (this.sharedPreferences.getString("vibrate", "true").equalsIgnoreCase("true")) {
            this.ic_enable.setImageResource(R.drawable.toggle_on);
        } else {
            this.ic_enable.setImageResource(R.drawable.toggle_off);
        }
        this.layone.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String string = EqualizerFragment.this.sharedPreferences.getString("vibrate", "true");
                SharedPreferences.Editor edit = EqualizerFragment.this.sharedPreferences.edit();
                if (string.equalsIgnoreCase("true")) {
                    edit.putString("vibrate", "false");
                    edit.apply();
                    EqualizerFragment.this.ic_enable.setImageResource(R.drawable.toggle_off);
                    return;
                }
                edit.putString("vibrate", "true");
                edit.apply();
                EqualizerFragment.this.ic_enable.setImageResource(R.drawable.toggle_on);
            }
        });
        this.laytwo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String string = EqualizerFragment.this.sharedPreferences.getString("visu", "true");
                SharedPreferences.Editor edit = EqualizerFragment.this.sharedPreferences.edit();
                if (string.equalsIgnoreCase("true")) {
                    edit.putString("visu", "false");
                    edit.apply();
                    EqualizerFragment.this.ic_visulizer.setImageResource(R.drawable.toggle_off);
                    EqualizerFragment.this.laytwo_off.setVisibility(View.VISIBLE);
                } else {
                    edit.putString("visu", "true");
                    edit.apply();
                    EqualizerFragment.this.ic_visulizer.setImageResource(R.drawable.toggle_on);
                    EqualizerFragment.this.laytwo_off.setVisibility(View.GONE);
                    if (EqualizerFragment.this.sharedPreferences.getBoolean("myswitch", true)) {
                        EqualizerFragment.this.circular_vir.setThumbDrawable(EqualizerFragment.this.getResources().getDrawable(R.drawable.custom_pointer));
                        EqualizerFragment.this.circular_vir.setProgressColor(EqualizerFragment.this.mContext, EqualizerFragment.this.getResources().getColor(R.color.circular_enable));
                        EqualizerFragment.this.ic_vir.setImageResource(R.drawable.virtualizer_icon);
                        EqualizerFragment.this.main_round_btm2.setImageResource(R.drawable.main_round);
                    }
                }
                EqualizerFragment.this.laytwo_off.setOnTouchListener(new View.OnTouchListener() {
                    @Override
                    public boolean onTouch(View view, MotionEvent motionEvent) {
                        Log.e("CCC", "onTouch: ");
                        return true;
                    }
                });
            }
        });
        int streamVolume = audioManager.getStreamVolume(3);
        final int streamMaxVolume = audioManager.getStreamMaxVolume(3);
        this.vol_seek.setMax(streamMaxVolume / 2);
        this.vol_seek.setProgress(streamVolume);
        if (streamVolume == 0) {
            this.ic_mute.setImageResource(R.drawable.mute_pressed);
        } else if (streamVolume > 0 && streamVolume <= 2) {
            this.ic_thirty_btn.setImageResource(R.drawable.ic_normal_pressed);
        } else if (streamVolume >= 3 && streamVolume <= 5) {
            this.ic_sixty_btn.setImageResource(R.drawable.sixty_press);
        } else if (streamVolume >= 6 && streamVolume <= 8) {
            this.ic_hun.setImageResource(R.drawable.hun_pressed);
        } else if (streamVolume >= 9 && streamVolume <= 11) {
            this.earsKnob.setAngle(58.0f);
            this.ic_onetwentyfive.setImageResource(R.drawable.ontwentyfive_pressed);
        } else if (streamVolume >= 12 && streamVolume <= 14) {
            this.earsKnob.setAngle(116.0f);
            this.ic_onfifty.setImageResource(R.drawable.onefifty_pressed);
        } else if (streamVolume == 15) {
            this.earsKnob.setAngle(174.0f);
            this.ic_onesevfive.setImageResource(R.drawable.onesevfive_pressed);
        } else if (streamVolume == 16) {
            this.earsKnob.setAngle(232.0f);
            this.ic_max.setImageResource(R.drawable.max_pressed);
        }
        this.vol_seek.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {
            }

            @Override
            public void onProgressChanged(SeekBar seekBar, int i, boolean z) {
                if (EqualizerFragment.this.getContext().getSharedPreferences("mypref", 0).getString("vibrate", "true").equalsIgnoreCase("true")) {
                    Vibrator vibrator = (Vibrator) EqualizerFragment.this.getContext().getSystemService(Context.VIBRATOR_SERVICE);
                    if (Build.VERSION.SDK_INT >= 26) {
                        vibrator.vibrate(VibrationEffect.createOneShot(100, -1));
                    } else {
                        vibrator.vibrate(100);
                    }
                }
                KnobImageViewUtils.EarPosition fromAngle = KnobImageViewUtils.EarPosition.fromAngle((int) EqualizerFragment.this.earsKnob.getAngle());
                if (seekBar.getProgress() < 8 || fromAngle.getPosition() < 11) {
                    EqualizerFragment.this.earsKnob.setAngle(0.0f);
                    VolumeBoosterService.setVolume(i, i, EqualizerFragment.this.getContext());
                    return;
                }
                VolumeBoosterService.setVolume(16, 16, EqualizerFragment.this.getContext());
            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
                KnobImageViewUtils.EarPosition fromAngle = KnobImageViewUtils.EarPosition.fromAngle((int) EqualizerFragment.this.earsKnob.getAngle());
                if (seekBar.getProgress() == 0) {
                    EqualizerFragment.this.ic_mute.setImageResource(R.drawable.mute_pressed);
                    EqualizerFragment.this.ic_thirty_btn.setImageResource(R.drawable.ic_normal_unpressed);
                    EqualizerFragment.this.ic_sixty_btn.setImageResource(R.drawable.sixty_unpress);
                    EqualizerFragment.this.ic_hun.setImageResource(R.drawable.hun_unpressed);
                    EqualizerFragment.this.ic_onetwentyfive.setImageResource(R.drawable.onetwentyfive_unpressed);
                    EqualizerFragment.this.ic_onfifty.setImageResource(R.drawable.onefifty_unpressed);
                    EqualizerFragment.this.ic_onesevfive.setImageResource(R.drawable.onsevfive_unpressed);
                    EqualizerFragment.this.ic_max.setImageResource(R.drawable.max_unpressed);
                } else if (seekBar.getProgress() > 0 && seekBar.getProgress() <= 2) {
                    EqualizerFragment.this.ic_thirty_btn.setImageResource(R.drawable.ic_normal_pressed);
                    EqualizerFragment.this.ic_mute.setImageResource(R.drawable.mute_unpressed);
                    EqualizerFragment.this.ic_sixty_btn.setImageResource(R.drawable.sixty_unpress);
                    EqualizerFragment.this.ic_hun.setImageResource(R.drawable.hun_unpressed);
                    EqualizerFragment.this.ic_onetwentyfive.setImageResource(R.drawable.onetwentyfive_unpressed);
                    EqualizerFragment.this.ic_onfifty.setImageResource(R.drawable.onefifty_unpressed);
                    EqualizerFragment.this.ic_onesevfive.setImageResource(R.drawable.onsevfive_unpressed);
                    EqualizerFragment.this.ic_max.setImageResource(R.drawable.max_unpressed);
                } else if (seekBar.getProgress() >= 3 && seekBar.getProgress() <= 5) {
                    EqualizerFragment.this.ic_sixty_btn.setImageResource(R.drawable.sixty_press);
                    EqualizerFragment.this.ic_mute.setImageResource(R.drawable.mute_unpressed);
                    EqualizerFragment.this.ic_thirty_btn.setImageResource(R.drawable.ic_normal_unpressed);
                    EqualizerFragment.this.ic_hun.setImageResource(R.drawable.hun_unpressed);
                    EqualizerFragment.this.ic_onetwentyfive.setImageResource(R.drawable.onetwentyfive_unpressed);
                    EqualizerFragment.this.ic_onfifty.setImageResource(R.drawable.onefifty_unpressed);
                    EqualizerFragment.this.ic_onesevfive.setImageResource(R.drawable.onsevfive_unpressed);
                    EqualizerFragment.this.ic_max.setImageResource(R.drawable.max_unpressed);
                } else if (seekBar.getProgress() >= 7 && seekBar.getProgress() <= 8) {
                    EqualizerFragment.this.ic_hun.setImageResource(R.drawable.hun_pressed);
                    EqualizerFragment.this.ic_mute.setImageResource(R.drawable.mute_unpressed);
                    EqualizerFragment.this.ic_thirty_btn.setImageResource(R.drawable.ic_normal_unpressed);
                    EqualizerFragment.this.ic_sixty_btn.setImageResource(R.drawable.sixty_unpress);
                    EqualizerFragment.this.ic_onetwentyfive.setImageResource(R.drawable.onetwentyfive_unpressed);
                    EqualizerFragment.this.ic_onfifty.setImageResource(R.drawable.onefifty_unpressed);
                    EqualizerFragment.this.ic_onesevfive.setImageResource(R.drawable.onsevfive_unpressed);
                    EqualizerFragment.this.ic_max.setImageResource(R.drawable.max_unpressed);
                } else if (seekBar.getProgress() >= 8 && fromAngle.getPosition() > 10) {
                    EqualizerFragment.this.ic_mute.setImageResource(R.drawable.mute_unpressed);
                    EqualizerFragment.this.ic_thirty_btn.setImageResource(R.drawable.ic_normal_unpressed);
                    EqualizerFragment.this.ic_sixty_btn.setImageResource(R.drawable.sixty_unpress);
                    EqualizerFragment.this.ic_hun.setImageResource(R.drawable.hun_pressed);
                    EqualizerFragment.this.ic_onetwentyfive.setImageResource(R.drawable.onetwentyfive_unpressed);
                    EqualizerFragment.this.ic_onfifty.setImageResource(R.drawable.onefifty_unpressed);
                    EqualizerFragment.this.ic_onesevfive.setImageResource(R.drawable.onsevfive_unpressed);
                    EqualizerFragment.this.ic_max.setImageResource(R.drawable.max_unpressed);
                } else if (seekBar.getProgress() >= 8 && fromAngle.getPosition() <= 1) {
                    EqualizerFragment.this.ic_mute.setImageResource(R.drawable.mute_unpressed);
                    EqualizerFragment.this.ic_thirty_btn.setImageResource(R.drawable.ic_normal_unpressed);
                    EqualizerFragment.this.ic_sixty_btn.setImageResource(R.drawable.sixty_unpress);
                    EqualizerFragment.this.ic_hun.setImageResource(R.drawable.hun_pressed);
                    EqualizerFragment.this.ic_onetwentyfive.setImageResource(R.drawable.onetwentyfive_unpressed);
                    EqualizerFragment.this.ic_onfifty.setImageResource(R.drawable.onefifty_unpressed);
                    EqualizerFragment.this.ic_onesevfive.setImageResource(R.drawable.onsevfive_unpressed);
                    EqualizerFragment.this.ic_max.setImageResource(R.drawable.max_unpressed);
                } else if (seekBar.getProgress() < 8 || fromAngle.getPosition() < 11) {
                    EqualizerFragment.this.ic_mute.setImageResource(R.drawable.mute_unpressed);
                    EqualizerFragment.this.ic_thirty_btn.setImageResource(R.drawable.ic_normal_unpressed);
                    EqualizerFragment.this.ic_sixty_btn.setImageResource(R.drawable.sixty_unpress);
                    EqualizerFragment.this.ic_hun.setImageResource(R.drawable.hun_unpressed);
                    EqualizerFragment.this.ic_onetwentyfive.setImageResource(R.drawable.onetwentyfive_unpressed);
                    EqualizerFragment.this.ic_onfifty.setImageResource(R.drawable.onefifty_unpressed);
                    EqualizerFragment.this.ic_onesevfive.setImageResource(R.drawable.onsevfive_unpressed);
                    EqualizerFragment.this.ic_max.setImageResource(R.drawable.max_unpressed);
                } else {
                    EqualizerFragment.this.ic_mute.setImageResource(R.drawable.mute_unpressed);
                    EqualizerFragment.this.ic_thirty_btn.setImageResource(R.drawable.ic_normal_unpressed);
                    EqualizerFragment.this.ic_sixty_btn.setImageResource(R.drawable.sixty_unpress);
                    EqualizerFragment.this.ic_hun.setImageResource(R.drawable.hun_unpressed);
                    EqualizerFragment.this.ic_onetwentyfive.setImageResource(R.drawable.onetwentyfive_unpressed);
                    EqualizerFragment.this.ic_onfifty.setImageResource(R.drawable.onefifty_unpressed);
                    EqualizerFragment.this.ic_onesevfive.setImageResource(R.drawable.onsevfive_unpressed);
                    EqualizerFragment.this.ic_max.setImageResource(R.drawable.max_pressed);
                }
            }
        });
        this.earsKnob.setKnobListener(new RotaryKnob.RotaryKnobListener() {
            @Override
            public void onKnobChanged(int i, int i2) {
                KnobImageViewUtils.EarPosition fromAngle = KnobImageViewUtils.EarPosition.fromAngle(i2);
                int position = fromAngle.getPosition() + 8;
                Log.e("CCC", "Knob released on " + i2 + "°, ear position " + fromAngle.toString());
                StringBuilder sb = new StringBuilder();
                sb.append("Knob released on so Volume will be ");
                sb.append(position);
                Log.e("CCC", sb.toString());
                if (EqualizerFragment.this.mContext.getSharedPreferences("mypref", 0).getString("vibrate", "true").equalsIgnoreCase("true")) {
                    Vibrator vibrator = (Vibrator) EqualizerFragment.this.mContext.getSystemService(Context.VIBRATOR_SERVICE);
                    if (Build.VERSION.SDK_INT >= 26) {
                        vibrator.vibrate(VibrationEffect.createOneShot(100, -1));
                    } else {
                        vibrator.vibrate(100);
                    }
                }
                VolumeBoosterService.setVolume(position, position, EqualizerFragment.this.mContext);
                NotificationService.start(EqualizerFragment.this.mContext, NotificationService.ACTION_INIT);
                EqualizerFragment.this.ic_mute.setImageResource(R.drawable.mute_unpressed);
                EqualizerFragment.this.ic_thirty_btn.setImageResource(R.drawable.ic_normal_unpressed);
                EqualizerFragment.this.ic_sixty_btn.setImageResource(R.drawable.sixty_unpress);
                EqualizerFragment.this.ic_hun.setImageResource(R.drawable.hun_unpressed);
                EqualizerFragment.this.ic_onetwentyfive.setImageResource(R.drawable.onetwentyfive_unpressed);
                EqualizerFragment.this.ic_onfifty.setImageResource(R.drawable.onefifty_unpressed);
                EqualizerFragment.this.ic_onesevfive.setImageResource(R.drawable.onsevfive_unpressed);
                EqualizerFragment.this.ic_max.setImageResource(R.drawable.max_unpressed);
            }

            @Override
            public void onKnobReleased(int i, int i2) {
                KnobImageViewUtils.EarPosition fromAngle = KnobImageViewUtils.EarPosition.fromAngle(i2);
                if (fromAngle.getPosition() == 11 && EqualizerFragment.this.vol_seek.getProgress() >= 8) {
                    EqualizerFragment.this.ic_mute.setImageResource(R.drawable.mute_unpressed);
                    EqualizerFragment.this.ic_thirty_btn.setImageResource(R.drawable.ic_normal_unpressed);
                    EqualizerFragment.this.ic_sixty_btn.setImageResource(R.drawable.sixty_unpress);
                    EqualizerFragment.this.ic_hun.setImageResource(R.drawable.hun_unpressed);
                    EqualizerFragment.this.ic_onetwentyfive.setImageResource(R.drawable.onetwentyfive_unpressed);
                    EqualizerFragment.this.ic_onfifty.setImageResource(R.drawable.onefifty_unpressed);
                    EqualizerFragment.this.ic_onesevfive.setImageResource(R.drawable.onsevfive_unpressed);
                    EqualizerFragment.this.ic_max.setImageResource(R.drawable.max_pressed);
                    int i3 = streamMaxVolume;
                    VolumeBoosterService.setVolume(i3, i3, EqualizerFragment.this.mContext);
                } else if (fromAngle.getPosition() > 1 && fromAngle.getPosition() <= 3 && EqualizerFragment.this.vol_seek.getProgress() >= 8) {
                    EqualizerFragment.this.ic_mute.setImageResource(R.drawable.mute_unpressed);
                    EqualizerFragment.this.ic_thirty_btn.setImageResource(R.drawable.ic_normal_unpressed);
                    EqualizerFragment.this.ic_sixty_btn.setImageResource(R.drawable.sixty_unpress);
                    EqualizerFragment.this.ic_hun.setImageResource(R.drawable.hun_unpressed);
                    EqualizerFragment.this.ic_onetwentyfive.setImageResource(R.drawable.ontwentyfive_pressed);
                    EqualizerFragment.this.ic_onfifty.setImageResource(R.drawable.onefifty_unpressed);
                    EqualizerFragment.this.ic_onesevfive.setImageResource(R.drawable.onsevfive_unpressed);
                    EqualizerFragment.this.ic_max.setImageResource(R.drawable.max_unpressed);
                } else if (fromAngle.getPosition() >= 4 && fromAngle.getPosition() <= 6 && EqualizerFragment.this.vol_seek.getProgress() >= 8) {
                    EqualizerFragment.this.ic_mute.setImageResource(R.drawable.mute_unpressed);
                    EqualizerFragment.this.ic_thirty_btn.setImageResource(R.drawable.ic_normal_unpressed);
                    EqualizerFragment.this.ic_sixty_btn.setImageResource(R.drawable.sixty_unpress);
                    EqualizerFragment.this.ic_hun.setImageResource(R.drawable.hun_unpressed);
                    EqualizerFragment.this.ic_onetwentyfive.setImageResource(R.drawable.onetwentyfive_unpressed);
                    EqualizerFragment.this.ic_onfifty.setImageResource(R.drawable.onefifty_pressed);
                    EqualizerFragment.this.ic_onesevfive.setImageResource(R.drawable.onsevfive_unpressed);
                    EqualizerFragment.this.ic_max.setImageResource(R.drawable.max_unpressed);
                } else if (fromAngle.getPosition() >= 7 && fromAngle.getPosition() <= 10 && EqualizerFragment.this.vol_seek.getProgress() >= 8) {
                    EqualizerFragment.this.ic_mute.setImageResource(R.drawable.mute_unpressed);
                    EqualizerFragment.this.ic_thirty_btn.setImageResource(R.drawable.ic_normal_unpressed);
                    EqualizerFragment.this.ic_sixty_btn.setImageResource(R.drawable.sixty_unpress);
                    EqualizerFragment.this.ic_hun.setImageResource(R.drawable.hun_unpressed);
                    EqualizerFragment.this.ic_onetwentyfive.setImageResource(R.drawable.onetwentyfive_unpressed);
                    EqualizerFragment.this.ic_onfifty.setImageResource(R.drawable.onefifty_unpressed);
                    EqualizerFragment.this.ic_onesevfive.setImageResource(R.drawable.onesevfive_pressed);
                    EqualizerFragment.this.ic_max.setImageResource(R.drawable.max_unpressed);
                } else if (fromAngle.getPosition() >= 0 && fromAngle.getPosition() <= 1 && EqualizerFragment.this.vol_seek.getProgress() >= 8) {
                    EqualizerFragment.this.ic_mute.setImageResource(R.drawable.mute_unpressed);
                    EqualizerFragment.this.ic_thirty_btn.setImageResource(R.drawable.ic_normal_unpressed);
                    EqualizerFragment.this.ic_sixty_btn.setImageResource(R.drawable.sixty_unpress);
                    EqualizerFragment.this.ic_hun.setImageResource(R.drawable.hun_pressed);
                    EqualizerFragment.this.ic_onetwentyfive.setImageResource(R.drawable.onetwentyfive_unpressed);
                    EqualizerFragment.this.ic_onfifty.setImageResource(R.drawable.onefifty_unpressed);
                    EqualizerFragment.this.ic_onesevfive.setImageResource(R.drawable.onesevfive_unpressed);
                    EqualizerFragment.this.ic_max.setImageResource(R.drawable.max_unpressed);
                }
            }
        });
        this.ic_mute.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                EqualizerFragment.this.ic_mute.setImageResource(R.drawable.mute_pressed);
                EqualizerFragment.this.ic_thirty_btn.setImageResource(R.drawable.ic_normal_unpressed);
                EqualizerFragment.this.ic_sixty_btn.setImageResource(R.drawable.sixty_unpress);
                EqualizerFragment.this.ic_hun.setImageResource(R.drawable.hun_unpressed);
                EqualizerFragment.this.ic_onetwentyfive.setImageResource(R.drawable.onetwentyfive_unpressed);
                EqualizerFragment.this.ic_onfifty.setImageResource(R.drawable.onefifty_unpressed);
                EqualizerFragment.this.ic_onesevfive.setImageResource(R.drawable.onsevfive_unpressed);
                EqualizerFragment.this.ic_max.setImageResource(R.drawable.max_unpressed);
                EqualizerFragment.this.vol_seek.setProgress(0);
                EqualizerFragment.this.earsKnob.setAngle(0.0f);
                EqualizerFragment.this.circular.setProgress(0);
                EqualizerFragment.this.circular.invalidate();
                EqualizerFragment.this.vol_seek.invalidate();
                VolumeBoosterService.setVolume(0, 0, EqualizerFragment.this.mContext);
                NotificationService.start(EqualizerFragment.this.mContext, NotificationService.ACTION_INIT);
            }
        });
        this.ic_thirty_btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                EqualizerFragment.this.ic_mute.setImageResource(R.drawable.mute_unpressed);
                EqualizerFragment.this.ic_thirty_btn.setImageResource(R.drawable.ic_normal_pressed);
                EqualizerFragment.this.ic_sixty_btn.setImageResource(R.drawable.sixty_unpress);
                EqualizerFragment.this.ic_hun.setImageResource(R.drawable.hun_unpressed);
                EqualizerFragment.this.ic_onetwentyfive.setImageResource(R.drawable.onetwentyfive_unpressed);
                EqualizerFragment.this.ic_onfifty.setImageResource(R.drawable.onefifty_unpressed);
                EqualizerFragment.this.ic_onesevfive.setImageResource(R.drawable.onsevfive_unpressed);
                EqualizerFragment.this.ic_max.setImageResource(R.drawable.max_unpressed);
                EqualizerFragment.this.vol_seek.setProgress(3);
                EqualizerFragment.this.earsKnob.setAngle(0.0f);
                EqualizerFragment.this.circular.setProgress(0);
                EqualizerFragment.this.circular.invalidate();
                EqualizerFragment.this.vol_seek.invalidate();
                VolumeBoosterService.setVolume(3, 3, EqualizerFragment.this.mContext);
                NotificationService.start(EqualizerFragment.this.mContext, NotificationService.ACTION_INIT);
            }
        });
        this.ic_sixty_btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                EqualizerFragment.this.ic_mute.setImageResource(R.drawable.mute_unpressed);
                EqualizerFragment.this.ic_thirty_btn.setImageResource(R.drawable.ic_normal_unpressed);
                EqualizerFragment.this.ic_sixty_btn.setImageResource(R.drawable.sixty_press);
                EqualizerFragment.this.ic_hun.setImageResource(R.drawable.hun_unpressed);
                EqualizerFragment.this.ic_onetwentyfive.setImageResource(R.drawable.onetwentyfive_unpressed);
                EqualizerFragment.this.ic_onfifty.setImageResource(R.drawable.onefifty_unpressed);
                EqualizerFragment.this.ic_onesevfive.setImageResource(R.drawable.onesevfive_unpressed);
                EqualizerFragment.this.ic_max.setImageResource(R.drawable.max_unpressed);
                EqualizerFragment.this.vol_seek.setProgress(6);
                EqualizerFragment.this.earsKnob.setAngle(0.0f);
                EqualizerFragment.this.circular.setProgress(0);
                EqualizerFragment.this.circular.invalidate();
                EqualizerFragment.this.vol_seek.invalidate();
                VolumeBoosterService.setVolume(6, 6, EqualizerFragment.this.mContext);
                NotificationService.start(EqualizerFragment.this.mContext, NotificationService.ACTION_INIT);
            }
        });
        this.ic_hun.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                EqualizerFragment.this.ic_mute.setImageResource(R.drawable.mute_unpressed);
                EqualizerFragment.this.ic_thirty_btn.setImageResource(R.drawable.ic_normal_unpressed);
                EqualizerFragment.this.ic_sixty_btn.setImageResource(R.drawable.sixty_unpress);
                EqualizerFragment.this.ic_hun.setImageResource(R.drawable.hun_pressed);
                EqualizerFragment.this.ic_onetwentyfive.setImageResource(R.drawable.onetwentyfive_unpressed);
                EqualizerFragment.this.ic_onfifty.setImageResource(R.drawable.onefifty_unpressed);
                EqualizerFragment.this.ic_onesevfive.setImageResource(R.drawable.onesevfive_unpressed);
                EqualizerFragment.this.ic_max.setImageResource(R.drawable.max_unpressed);
                EqualizerFragment.this.vol_seek.setProgress(streamMaxVolume / 2);
                EqualizerFragment.this.earsKnob.setAngle(0.0f);
                EqualizerFragment.this.circular.setProgress(0);
                EqualizerFragment.this.circular.invalidate();
                EqualizerFragment.this.vol_seek.invalidate();
                VolumeBoosterService.setVolume(8, 8, EqualizerFragment.this.mContext);
                NotificationService.start(EqualizerFragment.this.mContext, NotificationService.ACTION_INIT);
            }
        });
        this.ic_onetwentyfive.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                EqualizerFragment.this.ic_mute.setImageResource(R.drawable.mute_unpressed);
                EqualizerFragment.this.ic_thirty_btn.setImageResource(R.drawable.ic_normal_unpressed);
                EqualizerFragment.this.ic_sixty_btn.setImageResource(R.drawable.sixty_unpress);
                EqualizerFragment.this.ic_hun.setImageResource(R.drawable.hun_unpressed);
                EqualizerFragment.this.ic_onetwentyfive.setImageResource(R.drawable.ontwentyfive_pressed);
                EqualizerFragment.this.ic_onfifty.setImageResource(R.drawable.onefifty_unpressed);
                EqualizerFragment.this.ic_onesevfive.setImageResource(R.drawable.onesevfive_unpressed);
                EqualizerFragment.this.ic_max.setImageResource(R.drawable.max_unpressed);
                EqualizerFragment.this.vol_seek.setProgress(8);
                EqualizerFragment.this.earsKnob.setAngle(58.0f);
                EqualizerFragment.this.circular.setProgress(5);
                EqualizerFragment.this.circular.invalidate();
                EqualizerFragment.this.vol_seek.invalidate();
                VolumeBoosterService.setVolume(10, 10, EqualizerFragment.this.mContext);
                NotificationService.start(EqualizerFragment.this.mContext, NotificationService.ACTION_INIT);
            }
        });
        this.ic_onfifty.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                EqualizerFragment.this.ic_mute.setImageResource(R.drawable.mute_unpressed);
                EqualizerFragment.this.ic_thirty_btn.setImageResource(R.drawable.ic_normal_unpressed);
                EqualizerFragment.this.ic_sixty_btn.setImageResource(R.drawable.sixty_unpress);
                EqualizerFragment.this.ic_hun.setImageResource(R.drawable.hun_unpressed);
                EqualizerFragment.this.ic_onetwentyfive.setImageResource(R.drawable.onetwentyfive_unpressed);
                EqualizerFragment.this.ic_onfifty.setImageResource(R.drawable.onefifty_pressed);
                EqualizerFragment.this.ic_onesevfive.setImageResource(R.drawable.onesevfive_unpressed);
                EqualizerFragment.this.ic_max.setImageResource(R.drawable.max_unpressed);
                EqualizerFragment.this.vol_seek.setProgress(8);
                EqualizerFragment.this.earsKnob.setAngle(116.0f);
                EqualizerFragment.this.circular.setProgress(10);
                EqualizerFragment.this.circular.invalidate();
                EqualizerFragment.this.vol_seek.invalidate();
                VolumeBoosterService.setVolume(12, 12, EqualizerFragment.this.mContext);
                NotificationService.start(EqualizerFragment.this.mContext, NotificationService.ACTION_INIT);
            }
        });
        this.ic_onesevfive.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                EqualizerFragment.this.ic_mute.setImageResource(R.drawable.mute_unpressed);
                EqualizerFragment.this.ic_thirty_btn.setImageResource(R.drawable.ic_normal_unpressed);
                EqualizerFragment.this.ic_sixty_btn.setImageResource(R.drawable.sixty_unpress);
                EqualizerFragment.this.ic_hun.setImageResource(R.drawable.hun_unpressed);
                EqualizerFragment.this.ic_onetwentyfive.setImageResource(R.drawable.onetwentyfive_unpressed);
                EqualizerFragment.this.ic_onfifty.setImageResource(R.drawable.onefifty_unpressed);
                EqualizerFragment.this.ic_onesevfive.setImageResource(R.drawable.onesevfive_pressed);
                EqualizerFragment.this.ic_max.setImageResource(R.drawable.max_unpressed);
                EqualizerFragment.this.vol_seek.setProgress(8);
                EqualizerFragment.this.earsKnob.setAngle(174.0f);
                EqualizerFragment.this.circular.setProgress(15);
                EqualizerFragment.this.circular.invalidate();
                EqualizerFragment.this.vol_seek.invalidate();
                VolumeBoosterService.setVolume(14, 14, EqualizerFragment.this.mContext);
                NotificationService.start(EqualizerFragment.this.mContext, NotificationService.ACTION_INIT);
            }
        });
        this.ic_max.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                EqualizerFragment.this.ic_mute.setImageResource(R.drawable.mute_unpressed);
                EqualizerFragment.this.ic_thirty_btn.setImageResource(R.drawable.ic_normal_unpressed);
                EqualizerFragment.this.ic_sixty_btn.setImageResource(R.drawable.sixty_unpress);
                EqualizerFragment.this.ic_hun.setImageResource(R.drawable.hun_unpressed);
                EqualizerFragment.this.ic_onetwentyfive.setImageResource(R.drawable.onetwentyfive_unpressed);
                EqualizerFragment.this.ic_onfifty.setImageResource(R.drawable.onefifty_unpressed);
                EqualizerFragment.this.ic_onesevfive.setImageResource(R.drawable.onesevfive_unpressed);
                EqualizerFragment.this.ic_max.setImageResource(R.drawable.max_pressed);
                EqualizerFragment.this.vol_seek.setProgress(8);
                EqualizerFragment.this.earsKnob.setAngle(232.0f);
                EqualizerFragment.this.circular.setProgress(19);
                EqualizerFragment.this.circular.invalidate();
                EqualizerFragment.this.vol_seek.invalidate();
                VolumeBoosterService.setVolume(16, 16, EqualizerFragment.this.mContext);
                NotificationService.start(EqualizerFragment.this.mContext, NotificationService.ACTION_INIT);
            }
        });
        this.circular.setOnProgressChangedListener(new AnalogController.onProgressChangedListener() {
            @Override
            public void onProgressChanged(int i) {
                if (EqualizerFragment.this.mContext.getSharedPreferences("mypref", 0).getString("vibrate", "true").equalsIgnoreCase("true")) {
                    Vibrator vibrator = (Vibrator) EqualizerFragment.this.mContext.getSystemService(Context.VIBRATOR_SERVICE);
                    if (Build.VERSION.SDK_INT >= 26) {
                        vibrator.vibrate(VibrationEffect.createOneShot(100, -1));
                    } else {
                        vibrator.vibrate(100);
                    }
                }
                int i2 = i * 5;
                VolumeBoosterService.setVolume(i2, i2, EqualizerFragment.this.mContext);
                NotificationService.start(EqualizerFragment.this.mContext, NotificationService.ACTION_INIT);
            }
        });
        this.bass_rotaryKnobEars.setKnobListener(new RotaryKnob.RotaryKnobListener() {
            @Override
            public void onKnobChanged(int i, int i2) {
                if (EqualizerFragment.this.getContext().getSharedPreferences("mypref", 0).getString("vibrate", "true").equalsIgnoreCase("true")) {
                    Vibrator vibrator = (Vibrator) EqualizerFragment.this.getContext().getSystemService(Context.VIBRATOR_SERVICE);
                    if (Build.VERSION.SDK_INT >= 26) {
                        vibrator.vibrate(VibrationEffect.createOneShot(100, -1));
                    } else {
                        vibrator.vibrate(100);
                    }
                }
            }

            @Override
            public void onKnobReleased(int i, int i2) {
                Settings.bassStrength = (short) ((int) (((float) ((KnobImageViewUtils.EarPosition.fromAngle(i2).getPosition() * 10) - 10)) * 52.63158f));
                try {
                    EqualizerFragment.bassBoost.setStrength(Settings.bassStrength);
                    Settings.equalizerModel.setBassStrength(Settings.bassStrength);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
        this.circular_bass.setSeekBarChangeListener(new CircleSeekBar.OnSeekBarChangedListener() {
            @Override
            public void onStartTrackingTouch(CircleSeekBar circleSeekBar) {
            }

            @Override
            public void onPointsChanged(CircleSeekBar circleSeekBar, int i, boolean z) {
                if (EqualizerFragment.this.getContext().getSharedPreferences("mypref", 0).getString("vibrate", "true").equalsIgnoreCase("true")) {
                    Vibrator vibrator = (Vibrator) EqualizerFragment.this.getContext().getSystemService(Context.VIBRATOR_SERVICE);
                    if (Build.VERSION.SDK_INT >= 26) {
                        vibrator.vibrate(VibrationEffect.createOneShot(100, -1));
                    } else {
                        vibrator.vibrate(100);
                    }
                }
                TextView textView = EqualizerFragment.this.bass_pg;
                textView.setText(((int) circleSeekBar.getCurrentProgress()) + "%");
            }

            @Override
            public void onStopTrackingTouch(CircleSeekBar circleSeekBar) {
                Settings.bassStrength = (short) ((int) (circleSeekBar.getCurrentProgress() * 52.63158f));
                try {
                    EqualizerFragment.bassBoost.setStrength(Settings.bassStrength);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                EqualizerFragment.this.circular_bass.setProgressDisplayAndInvalidate((int) circleSeekBar.getCurrentProgress());
                EqualizerFragment.this.circular_bass.invalidate();
            }
        });
        this.vir_rotaryKnobEars.setKnobListener(new RotaryKnob.RotaryKnobListener() {
            @Override
            public void onKnobChanged(int i, int i2) {
                if (EqualizerFragment.this.getContext().getSharedPreferences("mypref", 0).getString("vibrate", "true").equalsIgnoreCase("true")) {
                    Vibrator vibrator = (Vibrator) EqualizerFragment.this.getContext().getSystemService(Context.VIBRATOR_SERVICE);
                    if (Build.VERSION.SDK_INT >= 26) {
                        vibrator.vibrate(VibrationEffect.createOneShot(100, -1));
                    } else {
                        vibrator.vibrate(100);
                    }
                }
            }

            @Override
            public void onKnobReleased(int i, int i2) {
                Settings.reverbPreset = (short) ((((KnobImageViewUtils.EarPosition.fromAngle(i2).getPosition() * 10) - 10) * 6) / 19);
                try {
                    EqualizerFragment.presetReverb.setPreset(Settings.reverbPreset);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
        this.circular_vir.setSeekBarChangeListener(new CircleSeekBar.OnSeekBarChangedListener() {
            @Override
            public void onStartTrackingTouch(CircleSeekBar circleSeekBar) {
            }

            @Override
            public void onPointsChanged(CircleSeekBar circleSeekBar, int i, boolean z) {
                if (EqualizerFragment.this.getContext().getSharedPreferences("mypref", 0).getString("vibrate", "true").equalsIgnoreCase("true")) {
                    Vibrator vibrator = (Vibrator) EqualizerFragment.this.getContext().getSystemService(Context.VIBRATOR_SERVICE);
                    if (Build.VERSION.SDK_INT >= 26) {
                        vibrator.vibrate(VibrationEffect.createOneShot(100, -1));
                    } else {
                        vibrator.vibrate(100);
                    }
                }
                TextView textView = EqualizerFragment.this.virtu_pg;
                textView.setText(((int) circleSeekBar.getCurrentProgress()) + "%");
            }

            @Override
            public void onStopTrackingTouch(CircleSeekBar circleSeekBar) {
                Settings.reverbPreset = (short) ((int) ((circleSeekBar.getCurrentProgress() * 6.0f) / 19.0f));
                try {
                    EqualizerFragment.presetReverb.setPreset(Settings.reverbPreset);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                EqualizerFragment.this.y = (int) circleSeekBar.getCurrentProgress();
                EqualizerFragment.this.circular_vir.setProgressDisplayAndInvalidate((int) circleSeekBar.getCurrentProgress());
                EqualizerFragment.this.circular_vir.invalidate();
            }
        });
        if (this.enable_flag) {
            this.eq_switch.setImageResource(R.drawable.toggle_on);
        } else {
            this.eq_switch.setImageResource(R.drawable.toggle_off);
        }
        NotificationService.start(getContext(), NotificationService.ACTION_INIT);
        setEqu(this.sharedPreferences.getInt("presetpos", 1), this.sharedPreferences.getString("txt_preset", "Normal"));
        this.equalizerSwitch.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                EqualizerFragment.this.next();

            }
        });
        song_txt.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                EqualizerFragment.this.next();
            }
        });
        play.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                new MyUtils(EqualizerFragment.this.mContext);
                String string = MyUtils.pref.getString("path", (String) null);
                if (MusicService.mediaPlayer == null || TextUtils.isEmpty(string)) {
                    Toast.makeText(EqualizerFragment.this.mContext, "Please Select Music First", Toast.LENGTH_SHORT).show();
                } else if (MusicService.mediaPlayer.isPlaying()) {
                    EqualizerFragment.play.setImageResource(R.drawable.play_button);
                    EqualizerFragment.stopVisualizer();
                } else {
                    EqualizerFragment.play.setImageResource(R.drawable.pause_button);
                    EqualizerFragment.startVisualizer();
                }
                Intent intent = new Intent(EqualizerFragment.this.mContext, MusicService.class);
                intent.setAction("TOGGLE");
                try {
                    PendingIntent.getService(EqualizerFragment.this.mContext, 0, intent,  PendingIntent.FLAG_MUTABLE).send();
                } catch (PendingIntent.CanceledException e) {
                    e.printStackTrace();
                }
            }
        });
        this.iv_previous.setOnClickListener(new View.OnClickListener() {
            @SuppressLint({"WrongConstant"})
            public void onClick(View view) {
                Intent intent = new Intent(EqualizerFragment.this.mContext, MusicService.class);
                intent.setAction("PREV");
                try {
                    PendingIntent.getService(EqualizerFragment.this.mContext, 0, intent, PendingIntent.FLAG_MUTABLE).send();
                } catch (PendingIntent.CanceledException e) {
                    e.printStackTrace();
                }
            }
        });
        this.iv_next.setOnClickListener(new View.OnClickListener() {
            @SuppressLint({"WrongConstant"})
            public void onClick(View view) {
                Intent intent = new Intent(EqualizerFragment.this.mContext, MusicService.class);
                intent.setAction("NEXT");
                try {
                    PendingIntent.getService(EqualizerFragment.this.mContext, 0, intent,  PendingIntent.FLAG_MUTABLE).send();
                } catch (PendingIntent.CanceledException e) {
                    e.printStackTrace();
                }
            }
        });
        setinter();
        resize();




        return this.view;
    }


    public void next() {
        startActivity(new Intent(this.mContext, PlayerActivity.class));
    }

    @SuppressLint({"NewApi"})
    public static LoudnessEnhancer getLoudnessEnhancer() {
        try {
            return new LoudnessEnhancer(0);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private void setinter() {
        this.onMediaListener = new OnMediaListener() {
            @Override
            public void onCurrentDuration(MediaPlayer mediaPlayer) {
            }
        };
        this.onTrackListener = new OnTrackListener() {
            @Override
            public void onSessionId(int i) {
            }

            @Override
            public void onToggle(Boolean bool, Object obj) {
                AudioModel audioModel = (AudioModel) obj;
                if (bool.booleanValue()) {
                    EqualizerFragment.play.setImageResource(R.drawable.pause_button);
                } else {
                    EqualizerFragment.play.setImageResource(R.drawable.play_button);
                }
                EqualizerFragment.song_txt.setText(audioModel.getName());
            }

            @Override
            public void onNext(Object obj) {
                EqualizerFragment.play.setImageResource(R.drawable.pause_button);
                EqualizerFragment.song_txt.setText(((AudioModel) obj).getName());
            }

            @Override
            public void onPre(Object obj) {
                EqualizerFragment.play.setImageResource(R.drawable.pause_button);
                EqualizerFragment.song_txt.setText(((AudioModel) obj).getName());
            }
        };
    }


    @SuppressLint({"WrongConstant"})
    public void sendEQ() {
        Intent intent = new Intent(this.mContext, MusicService.class);
        intent.setAction("EQ");
        intent.putExtra("eq", Settings.equalizerModel);
        try {
            PendingIntent.getService(this.mContext, 0, intent, PendingIntent.FLAG_MUTABLE).send();
        } catch (PendingIntent.CanceledException e) {
            e.printStackTrace();
        }
    }

    public static void stopVisualizer() {
        LedView ledView = mLedLeft1;
        if (ledView != null && led_right_1 != null && mLedLeft2 != null && led_right_2 != null && someHandler != null && someHandler2 != null) {
            ledView.increaseValue = 0;
            ledView.postInvalidate();
            LedView ledView2 = led_right_1;
            ledView2.increaseValue = 0;
            ledView2.postInvalidate();
            LedView ledView3 = mLedLeft2;
            ledView3.increaseValue = 0;
            ledView3.postInvalidate();
            LedView ledView4 = led_right_2;
            ledView4.increaseValue = 0;
            ledView4.postInvalidate();
            someHandler.removeCallbacksAndMessages((Object) null);
            someHandler2.removeCallbacksAndMessages((Object) null);
            ImageView imageView = play;
            if (imageView != null) {
                imageView.setImageResource(R.drawable.play_button);
            }
            if (PlayerActivity.btnplay != null) {
                PlayerActivity.btnplay.setImageResource(R.drawable.ic_play);
            }
        }
    }

    public static void startVisualizer() {
        someHandler = new Handler(Looper.getMainLooper());
        someHandler.postDelayed(new Runnable() {


            @Override

            public void run() {
                int nextInt = (int) (((float) (new Random().nextInt(1412) + 88)) / 87.5f);
                EqualizerFragment.mLedLeft1.increaseValue = nextInt;
                EqualizerFragment.mLedLeft1.postInvalidate();
                EqualizerFragment.led_right_1.increaseValue = nextInt;
                EqualizerFragment.led_right_1.postInvalidate();
                EqualizerFragment.someHandler.postDelayed(this, 150);
            }
        }, 10);
        someHandler2 = new Handler(Looper.getMainLooper());
        someHandler2.postDelayed(new Runnable() {
            @Override
            public void run() {
                int nextInt = (int) (((float) (new Random().nextInt(1412) + 88)) / 87.5f);
                EqualizerFragment.mLedLeft2.increaseValue = nextInt;
                EqualizerFragment.mLedLeft2.postInvalidate();
                EqualizerFragment.led_right_2.increaseValue = nextInt;
                EqualizerFragment.led_right_2.postInvalidate();
                EqualizerFragment.someHandler2.postDelayed(this, 150);
            }
        }, 10);
        ImageView imageView = play;
        if (imageView != null) {
            imageView.setImageResource(R.drawable.pause_button);
        }
        if (PlayerActivity.btnplay != null) {
            PlayerActivity.btnplay.setImageResource(R.drawable.ic_pause);
        }
    }

    private void setEnableDisable(View view2, boolean z, SeekBar seekBar2, TextView textView2) {
        if (z) {
            seekBar2.setProgressDrawable(getResources().getDrawable(R.drawable.seek_progress_copy));
            seekBar2.setThumb(getResources().getDrawable(R.drawable.untitled));
            this.tx_bass.setTextColor(-1);
            this.tx_vir.setTextColor(-1);
            seekBar2.setEnabled(true);
            this.txt_preset.setEnabled(true);
            this.layone_off.setVisibility(View.GONE);
            this.laytwo_off.setVisibility(View.GONE);
            this.layone_off.setOnTouchListener(new View.OnTouchListener() {
                @Override
                public boolean onTouch(View view, MotionEvent motionEvent) {
                    Log.e("CCC", "onTouch: ");
                    return true;
                }
            });
            this.laytwo_off.setOnTouchListener(new View.OnTouchListener() {
                @Override
                public boolean onTouch(View view, MotionEvent motionEvent) {
                    Log.e("CCC", "onTouch: ");
                    return true;
                }
            });
            this.circular_bass.setThumbDrawable(getResources().getDrawable(R.drawable.custom_pointer));
            this.circular_bass.setProgressColor(this.mContext, getResources().getColor(R.color.circular_enable));
            this.circular_bass.invalidate();
            this.circular_vir.setThumbDrawable(getResources().getDrawable(R.drawable.custom_pointer));
            this.circular_vir.setProgressColor(this.mContext, getResources().getColor(R.color.circular_enable));
            this.circular_vir.invalidate();
            this.ic_bass.setImageResource(R.drawable.bass_icon);
            this.ic_vir.setImageResource(R.drawable.virtualizer_icon);
            this.main_round_btm.setImageResource(R.drawable.main_round);
            this.main_round_btm2.setImageResource(R.drawable.main_round);
            return;
        }
        seekBar2.setProgressDrawable(getResources().getDrawable(R.drawable.seek_progress_copy));
        seekBar2.setThumb(getResources().getDrawable(R.drawable.untitled));
        seekBar2.setEnabled(false);
        this.txt_preset.setEnabled(false);
        this.layone_off.setVisibility(View.VISIBLE);
        this.laytwo_off.setVisibility(View.VISIBLE);
        this.layone_off.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View view, MotionEvent motionEvent) {
                Log.e("CCC", "onTouch: ");
                return true;
            }
        });
        this.laytwo_off.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View view, MotionEvent motionEvent) {
                Log.e("CCC", "onTouch: ");
                return true;
            }
        });
    }

    private void resize() {
        HelperResizer.getheightandwidth(this.mContext);
        HelperResizer.setHeight(this.mContext, this.top_bar, 140);
        HelperResizer.setSize(this.main_rel, 640, 612);
        HelperResizer.setSize(this.earsKnob, 472, 472, true);
        HelperResizer.setSize(this.fd_rel, 442, 442, true);
        HelperResizer.setSize(this.bass_rotaryKnobEars, 330, 330, true);
        HelperResizer.setSize(this.vir_rotaryKnobEars, 330, 330, true);
        HelperResizer.setSize(this.sd_rel, 442, 442, true);
        HelperResizer.setWidth(this.mContext, this.drawer, 643);
        HelperResizer.setSize(this.backBtn, 80, 80, true);
        HelperResizer.setSize(this.equalizerSwitch, 80, 80, true);
        HelperResizer.setSize(this.circular, 440, 440, true);
        HelperResizer.setSize(this.circular_bass, 440, 440, true);
        HelperResizer.setSize(this.circular_vir, 440, 440, true);
        HelperResizer.setSize(this.main_round_btm, 370, 370, true);
        HelperResizer.setSize(this.main_round_btm2, 370, 370, true);
        HelperResizer.setSize(this.eq_switch, 143, 65);
        HelperResizer.setSize(this.ic_vol, 404, 104);
        HelperResizer.setSize(this.ic_eq, 404, 104);
        HelperResizer.setSize(this.ic_mute, ItemTouchHelper.Callback.DEFAULT_DRAG_ANIMATION_DURATION, 100, true);
        HelperResizer.setSize(this.ic_thirty_btn, ItemTouchHelper.Callback.DEFAULT_DRAG_ANIMATION_DURATION, 100, true);
        HelperResizer.setSize(this.ic_sixty_btn, ItemTouchHelper.Callback.DEFAULT_DRAG_ANIMATION_DURATION, 100, true);
        HelperResizer.setSize(this.ic_hun, ItemTouchHelper.Callback.DEFAULT_DRAG_ANIMATION_DURATION, 100, true);
        HelperResizer.setSize(this.ic_onetwentyfive, ItemTouchHelper.Callback.DEFAULT_DRAG_ANIMATION_DURATION, 100, true);
        HelperResizer.setSize(this.ic_onfifty, ItemTouchHelper.Callback.DEFAULT_DRAG_ANIMATION_DURATION, 100, true);
        HelperResizer.setSize(this.ic_onesevfive, ItemTouchHelper.Callback.DEFAULT_DRAG_ANIMATION_DURATION, 100, true);
        HelperResizer.setSize(this.ic_max, ItemTouchHelper.Callback.DEFAULT_DRAG_ANIMATION_DURATION, 100, true);
        HelperResizer.setSize(this.nrm_bg, 357, 80);
        HelperResizer.setSize(this.main_bg, 1000, 670);
        HelperResizer.setSize(this.spect, 75, 447);
        HelperResizer.setSize(this.spect1, 75, 447);
        HelperResizer.setSize(this.spect2, 75, 447);
        HelperResizer.setSize(this.spect3, 75, 447);
        HelperResizer.setSize(this.spect4, 75, 447);
        HelperResizer.setSize(this.seek_dot1, 12, 12, true);
        HelperResizer.setSize(this.seek_dot2, 12, 12, true);
        HelperResizer.setSize(this.seek_dot3, 12, 12, true);
        HelperResizer.setSize(this.seek_dot4, 12, 12, true);
        HelperResizer.setSize(this.seek_dot5, 12, 12, true);
        HelperResizer.setSize(this.ic_bass, 140, 170);
        HelperResizer.setSize(this.ic_vir, 140, 170);
        HelperResizer.setSize(this.layone, 643, 100);
        HelperResizer.setSize(this.laytwo, 643, 100);
        HelperResizer.setSize(this.laythree, 600, 100);
        HelperResizer.setSize(this.layfour, 600, 100);
        HelperResizer.setSize(this.layfive, 600, 100);
        HelperResizer.setSize(this.ic_enable, 125, 56);
        HelperResizer.setSize(this.ic_visulizer, 125, 56);
        HelperResizer.setSize(this.firstimg, 600, 100);
        HelperResizer.setSize(this.secondimg, 600, 100);
        HelperResizer.setSize(this.thirdimg, 600, 100);
        HelperResizer.setSize(this.iv_next, 80, 80, true);
        HelperResizer.setSize(this.iv_previous, 80, 80, true);
        HelperResizer.setSize(play, 120, 120, true);
        HelperResizer.setSize(this.ic_visu, 110, 110, true);
        HelperResizer.setSize(this.ic_vibrate, 110, 110, true);
        HelperResizer.setSize(this.top_icon, 600, 350);
        HelperResizer.setSize(this.ic_vol_icon, 116, 116, true);
        HelperResizer.setSize(this.tap_layout, 470, 100);
        HelperResizer.setSize(this.tap_icon, 50, 50, true);
        HelperResizer.setMargin(this.tap_icon, 35, 0, 0, 0);
    }

    public void equalizeSound() {
        final Dialog dialog = new Dialog(getContext(), R.style.CustomSwitch);
        dialog.requestWindowFeature(1);
        dialog.setContentView(R.layout.activity_select_equ);
        ImageView imageView = (ImageView) dialog.findViewById(R.id.back);
        ImageView imageView2 = (ImageView) dialog.findViewById(R.id.ic_normal);
        ImageView imageView3 = (ImageView) dialog.findViewById(R.id.ic_classical);
        ImageView imageView4 = (ImageView) dialog.findViewById(R.id.ic_dance);
        ImageView imageView5 = (ImageView) dialog.findViewById(R.id.ic_folk);
        ImageView imageView6 = (ImageView) dialog.findViewById(R.id.ic_heavy);
        ImageView imageView7 = (ImageView) dialog.findViewById(R.id.ic_hip);
        ImageView imageView8 = (ImageView) dialog.findViewById(R.id.ic_jazz);
        ImageView imageView9 = (ImageView) dialog.findViewById(R.id.ic_pop);
        ImageView imageView10 = (ImageView) dialog.findViewById(R.id.ic_rock);
        HelperResizer.getheightandwidth(this.mContext);
        HelperResizer.setSize(imageView, 80, 80, true);
        HelperResizer.setSize(imageView2, 310, 300);
        HelperResizer.setSize(imageView3, 310, 300);
        HelperResizer.setSize(imageView4, 310, 300);
        HelperResizer.setSize(imageView5, 310, 300);
        HelperResizer.setSize(imageView6, 310, 300);
        HelperResizer.setSize(imageView7, 310, 300);
        HelperResizer.setSize(imageView8, 310, 300);
        HelperResizer.setSize(imageView9, 310, 300);
        HelperResizer.setSize(imageView10, 310, 300);
        HelperResizer.setMargin(dialog.findViewById(R.id.sec_lay), 0, 30, 0, 0);
        HelperResizer.setMargin(dialog.findViewById(R.id.third_lay), 0, 30, 0, 0);
        int i = this.sharedPreferences.getInt("presetpos", 1);
        if (i == 1) {
            imageView2.setImageResource(R.drawable.normal_pressed);
            imageView3.setImageResource(R.drawable.classical_unpressed);
            imageView4.setImageResource(R.drawable.dance_unpressed);
            imageView5.setImageResource(R.drawable.folk_unpressed);
            imageView6.setImageResource(R.drawable.heavy_metal_unpresse);
            imageView7.setImageResource(R.drawable.hip_hop_unpressed);
            imageView8.setImageResource(R.drawable.jazz_unpressed);
            imageView9.setImageResource(R.drawable.pop_unpressed);
            imageView10.setImageResource(R.drawable.rock_unpressed);
        } else if (i == 2) {
            imageView2.setImageResource(R.drawable.normal_unpressed);
            imageView3.setImageResource(R.drawable.classical_pressed);
            imageView4.setImageResource(R.drawable.dance_unpressed);
            imageView5.setImageResource(R.drawable.folk_unpressed);
            imageView6.setImageResource(R.drawable.heavy_metal_unpresse);
            imageView7.setImageResource(R.drawable.hip_hop_unpressed);
            imageView8.setImageResource(R.drawable.jazz_unpressed);
            imageView9.setImageResource(R.drawable.pop_unpressed);
            imageView10.setImageResource(R.drawable.rock_unpressed);
        } else if (i == 3) {
            imageView2.setImageResource(R.drawable.normal_unpressed);
            imageView3.setImageResource(R.drawable.classical_unpressed);
            imageView4.setImageResource(R.drawable.dance_pressed);
            imageView5.setImageResource(R.drawable.folk_unpressed);
            imageView6.setImageResource(R.drawable.heavy_metal_unpresse);
            imageView7.setImageResource(R.drawable.hip_hop_unpressed);
            imageView8.setImageResource(R.drawable.jazz_unpressed);
            imageView9.setImageResource(R.drawable.pop_unpressed);
            imageView10.setImageResource(R.drawable.rock_unpressed);
        } else if (i == 4) {
            imageView2.setImageResource(R.drawable.normal_unpressed);
            imageView3.setImageResource(R.drawable.classical_unpressed);
            imageView4.setImageResource(R.drawable.dance_unpressed);
            imageView5.setImageResource(R.drawable.folk_pressed);
            imageView6.setImageResource(R.drawable.heavy_metal_unpresse);
            imageView7.setImageResource(R.drawable.hip_hop_unpressed);
            imageView8.setImageResource(R.drawable.jazz_unpressed);
            imageView9.setImageResource(R.drawable.pop_unpressed);
            imageView10.setImageResource(R.drawable.rock_unpressed);
        } else if (i == 5) {
            imageView2.setImageResource(R.drawable.normal_unpressed);
            imageView3.setImageResource(R.drawable.classical_unpressed);
            imageView4.setImageResource(R.drawable.dance_unpressed);
            imageView5.setImageResource(R.drawable.folk_unpressed);
            imageView6.setImageResource(R.drawable.heavy_metal_presse);
            imageView7.setImageResource(R.drawable.hip_hop_unpressed);
            imageView8.setImageResource(R.drawable.jazz_unpressed);
            imageView9.setImageResource(R.drawable.pop_unpressed);
            imageView10.setImageResource(R.drawable.rock_unpressed);
        } else if (i == 6) {
            imageView2.setImageResource(R.drawable.normal_unpressed);
            imageView3.setImageResource(R.drawable.classical_unpressed);
            imageView4.setImageResource(R.drawable.dance_unpressed);
            imageView5.setImageResource(R.drawable.folk_unpressed);
            imageView6.setImageResource(R.drawable.heavy_metal_unpresse);
            imageView7.setImageResource(R.drawable.hip_hop_pressed);
            imageView8.setImageResource(R.drawable.jazz_unpressed);
            imageView9.setImageResource(R.drawable.pop_unpressed);
            imageView10.setImageResource(R.drawable.rock_unpressed);
        } else if (i == 7) {
            imageView2.setImageResource(R.drawable.normal_unpressed);
            imageView3.setImageResource(R.drawable.classical_unpressed);
            imageView4.setImageResource(R.drawable.dance_unpressed);
            imageView5.setImageResource(R.drawable.folk_unpressed);
            imageView6.setImageResource(R.drawable.heavy_metal_unpresse);
            imageView7.setImageResource(R.drawable.hip_hop_unpressed);
            imageView8.setImageResource(R.drawable.jazz_pressed);
            imageView9.setImageResource(R.drawable.pop_unpressed);
            imageView10.setImageResource(R.drawable.rock_unpressed);
        } else if (i == 8) {
            imageView2.setImageResource(R.drawable.normal_unpressed);
            imageView3.setImageResource(R.drawable.classical_unpressed);
            imageView4.setImageResource(R.drawable.dance_unpressed);
            imageView5.setImageResource(R.drawable.folk_unpressed);
            imageView6.setImageResource(R.drawable.heavy_metal_unpresse);
            imageView7.setImageResource(R.drawable.hip_hop_unpressed);
            imageView8.setImageResource(R.drawable.jazz_unpressed);
            imageView9.setImageResource(R.drawable.pop_pressed);
            imageView10.setImageResource(R.drawable.rock_unpressed);
        } else if (i == 9) {
            imageView2.setImageResource(R.drawable.normal_unpressed);
            imageView3.setImageResource(R.drawable.classical_unpressed);
            imageView4.setImageResource(R.drawable.dance_unpressed);
            imageView5.setImageResource(R.drawable.folk_unpressed);
            imageView6.setImageResource(R.drawable.heavy_metal_unpresse);
            imageView7.setImageResource(R.drawable.hip_hop_unpressed);
            imageView8.setImageResource(R.drawable.jazz_unpressed);
            imageView9.setImageResource(R.drawable.pop_unpressed);
            imageView10.setImageResource(R.drawable.rock_pressed);
        } else {
            imageView2.setImageResource(R.drawable.normal_unpressed);
            imageView3.setImageResource(R.drawable.classical_unpressed);
            imageView4.setImageResource(R.drawable.dance_unpressed);
            imageView5.setImageResource(R.drawable.folk_unpressed);
            imageView6.setImageResource(R.drawable.heavy_metal_unpresse);
            imageView7.setImageResource(R.drawable.hip_hop_unpressed);
            imageView8.setImageResource(R.drawable.jazz_unpressed);
            imageView9.setImageResource(R.drawable.pop_unpressed);
            imageView10.setImageResource(R.drawable.rock_unpressed);
        }
        imageView2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                EqualizerFragment.this.seek_dot1.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot2.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot3.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot4.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot5.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.setEqu(1, "Normal");
                SharedPreferences.Editor edit = EqualizerFragment.this.sharedPreferences.edit();
                edit.putInt("presetpos", 1);
                edit.apply();
                dialog.dismiss();
            }
        });
        imageView3.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                EqualizerFragment.this.seek_dot1.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot2.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot3.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot4.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot5.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.setEqu(2, "Classical");
                SharedPreferences.Editor edit = EqualizerFragment.this.sharedPreferences.edit();
                edit.putInt("presetpos", 2);
                edit.apply();
                dialog.dismiss();
            }
        });
        imageView4.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                EqualizerFragment.this.seek_dot1.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot2.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot3.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot4.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot5.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.setEqu(3, "Dance");
                SharedPreferences.Editor edit = EqualizerFragment.this.sharedPreferences.edit();
                edit.putInt("presetpos", 3);
                edit.apply();
                dialog.dismiss();
            }
        });
        imageView5.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                EqualizerFragment.this.seek_dot1.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot2.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot3.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot4.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot5.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.setEqu(4, "Folk");
                SharedPreferences.Editor edit = EqualizerFragment.this.sharedPreferences.edit();
                edit.putInt("presetpos", 4);
                edit.apply();
                dialog.dismiss();
            }
        });
        imageView6.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                EqualizerFragment.this.seek_dot1.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot2.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot3.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot4.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot5.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.setEqu(5, "Heavy Metal");
                SharedPreferences.Editor edit = EqualizerFragment.this.sharedPreferences.edit();
                edit.putInt("presetpos", 5);
                edit.apply();
                dialog.dismiss();
            }
        });
        imageView7.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                EqualizerFragment.this.seek_dot1.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot2.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot3.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot4.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot5.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.setEqu(6, "Hip Hop");
                SharedPreferences.Editor edit = EqualizerFragment.this.sharedPreferences.edit();
                edit.putInt("presetpos", 6);
                edit.apply();
                dialog.dismiss();
            }
        });
        imageView8.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                EqualizerFragment.this.seek_dot1.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot2.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot3.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot4.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot5.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.setEqu(7, "Jazz");
                SharedPreferences.Editor edit = EqualizerFragment.this.sharedPreferences.edit();
                edit.putInt("presetpos", 7);
                edit.apply();
                dialog.dismiss();
            }
        });
        imageView9.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                EqualizerFragment.this.seek_dot1.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot2.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot3.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot4.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot5.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.setEqu(8, "Pop");
                SharedPreferences.Editor edit = EqualizerFragment.this.sharedPreferences.edit();
                edit.putInt("presetpos", 8);
                edit.apply();
                dialog.dismiss();
            }
        });
        imageView10.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                EqualizerFragment.this.seek_dot1.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot2.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot3.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot4.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.seek_dot5.setImageResource(R.drawable.purple_dot);
                EqualizerFragment.this.setEqu(9, "Rock");
                SharedPreferences.Editor edit = EqualizerFragment.this.sharedPreferences.edit();
                edit.putInt("presetpos", 9);
                edit.apply();
                dialog.dismiss();
            }
        });
        imageView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dialog.dismiss();
                EqualizerFragment.this.onBackPressed();
            }
        });
        dialog.show();
    }

    public void setEqu(int i, String str) {
        if (i != 0) {
            try {
                mEqualizer.usePreset((short) (i - 1));
                Settings.presetPos = i;
                short s = mEqualizer.getBandLevelRange()[0];
                for (short s2 = 0; s2 < 5; s2 = (short) (s2 + 1)) {
                    this.seekBarFinal[s2].setProgress(mEqualizer.getBandLevel(s2) - s);
                    this.points[s2] = (float) (mEqualizer.getBandLevel(s2) - s);
                    Settings.seekbarpos[s2] = mEqualizer.getBandLevel(s2);
                    Settings.equalizerModel.getSeekbarpos()[s2] = mEqualizer.getBandLevel(s2);
                }
            } catch (Exception unused) {
                Toast.makeText(this.mContext, "Error while updating Equalizer", Toast.LENGTH_SHORT).show();
            }
        } else {
            for (short s3 = 0; s3 < mEqualizer.getNumberOfBands(); s3 = (short) (s3 + 1)) {
                mEqualizer.setBandLevel(s3, (short) Settings.seekbarpos[s3]);
            }
        }
        MainHomeActivity.saveEqualizerSettings(getContext());
        sendEQ();
        this.txt_preset.setText(str);
        SharedPreferences.Editor edit = this.sharedPreferences.edit();
        edit.putString("txt_preset", str);
        edit.putInt("presetpos", i);
        edit.apply();
        Settings.equalizerModel.setPresetPos(i);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        Settings.isEditing = true;
    }

    public static Builder newBuilder() {
        return new Builder();
    }

    @Override
    public boolean onBackPressed() {
        if (this.eq_layer.getVisibility() != View.VISIBLE) {
            return false;
        }
        this.vol_layer.setVisibility(View.VISIBLE);
        this.eq_layer.setVisibility(View.GONE);
        this.ic_eq.setImageResource(R.drawable.equalizer_unpressed);
        this.ic_vol.setImageResource(R.drawable.volume_pressed);
        return true;
    }

    public static class Builder {
        private int id = -1;

        public Builder setAudioSessionId(int i) {
            this.id = i;
            return this;
        }

        public Builder setAccentColor(int i) {
            EqualizerFragment.themeColor = i;
            return this;
        }

        public Builder setShowBackButton(boolean z) {
            EqualizerFragment.showBackButton = z;
            return this;
        }

        public EqualizerFragment build() {
            return EqualizerFragment.newInstance(this.id);
        }
    }

    @SuppressLint({"WrongConstant"})
    public void onResume() {
        super.onResume();
        if (MusicService.mediaPlayer != null) {
            if (MusicService.mediaPlayer.isPlaying()) {
                play.setImageResource(R.drawable.pause_button);
            } else {
                play.setImageResource(R.drawable.play_button);
            }
        }
        FragmentActivity activity = getActivity();
        activity.getClass();
        activity.bindService(new Intent(this.mContext, MusicService.class), this.serviceConnection, 1);
    }

    @Override
    public void onPause() {
        Log.e("AAA", "onpause player page");
        super.onPause();
    }

    }

