package com.example.test;

import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.app.WindowDecorActionBar;

import android.graphics.Color;
import android.media.MediaPlayer;
import android.os.Build;
import android.os.Bundle;
import android.text.format.Time;
import android.view.View;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Button;

import java.time.LocalTime;
import java.util.ArrayList;

import logic.SoundFile;
import logic.Timer;

public class MainActivity extends AppCompatActivity implements View.OnClickListener{
    Button StopButton;
    Button StartButton;
    EditText NumberInput;
    EditText TimerInput;
    TextView TimerField;
    TextView ErrorText;

    Thread mainThread = new Thread();
    Thread timerThread = new Thread();
    boolean play = true;
    LocalTime Time;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        StopButton = (Button) findViewById(R.id.StopButton);
        StartButton = (Button) findViewById(R.id.StartButton);
        TimerInput = (EditText) findViewById(R.id.TimerInput);
        TimerField = (TextView) findViewById(R.id.TimerText);
        NumberInput = (EditText) findViewById(R.id.NumberInput);
        ErrorText = (TextView) findViewById(R.id.ErrorText);

        StopButton.setOnClickListener(this);
        StartButton.setOnClickListener(this);
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    @Override
    public void onClick(View view) {
        if (view.getId() == R.id.StartButton){
            try {
                check();
            } catch (Exception e) {
                return;
            }
            playSequence();
        }
        if (view.getId() == R.id.StopButton){
            play = false;
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    public void check() throws Exception{
        try {
            System.out.println(TimerInput.getText().toString());
            Time = LocalTime.parse(TimerInput.getText().toString());
        } catch (Exception exception){
            setErrorLabel("Check if all fields are filled in correctly");
        }
    }

    public void setErrorLabel(String text){
        runOnUiThread(() -> {
            ErrorText.setText(text);
            ErrorText.setTextColor(Color.red(1));
        });
    }

    public void setTimerField(String text){
        runOnUiThread(() -> TimerField.setText(text));
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    public void playSequence(){
        if(mainThread.isAlive())
            return;
        play = true;
        mainThread = new Thread(() -> {
            while (play){
                timer();
                playSound(Integer.parseInt(NumberInput.getText().toString()));
                try {
                    Thread.sleep((Time.toSecondOfDay() * 1000));
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        });
        mainThread.start();
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    public void timer(){
        timerThread = new Thread(() -> {
            LocalTime time = LocalTime.of(Time.getHour(), Time.getMinute(), Time.getSecond());
            while (time.toSecondOfDay() > 0 && play){
                time = time.minusSeconds(1);
                setTimerField(time.toString());
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    System.out.println(e.getMessage());
                    e.printStackTrace();
                }
            }
            setTimerField("00:00:00");
        });
        timerThread.start();
    }

    public void playSound(int i) {

        if (i == 2){
            final MediaPlayer GUN2 = MediaPlayer.create(MainActivity.this, R.raw.gun2);
            GUN2.start();
        } else if (i == 3){
            final MediaPlayer GUN3 = MediaPlayer.create(MainActivity.this, R.raw.gun3);
            GUN3.start();
        } else if (i == 4){
            final MediaPlayer GUN4 = MediaPlayer.create(MainActivity.this, R.raw.gun4);
            GUN4.start();
        } else if( i == 5){
            final MediaPlayer GUN5 = MediaPlayer.create(MainActivity.this, R.raw.gun5);
            GUN5.start();
        } else {
            final MediaPlayer GUN1 = MediaPlayer.create(MainActivity.this, R.raw.gun1);
            GUN1.start();
        }

    }


}