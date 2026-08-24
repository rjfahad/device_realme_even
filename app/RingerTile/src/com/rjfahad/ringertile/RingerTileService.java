/*
 * Copyright (C) 2026 rjfahad
 *
 * SPDX-License-Identifier: Apache-2.0
 */

package com.rjfahad.ringertile;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.media.AudioManager;
import android.service.quicksettings.Tile;
import android.service.quicksettings.TileService;

/**
 * Quick Settings tile that cycles the ringer mode:
 * Ring -> Vibrate -> Silent -> Ring.
 */
public class RingerTileService extends TileService {

    private AudioManager mAudioManager;

    private final BroadcastReceiver mReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (AudioManager.RINGER_MODE_CHANGED_ACTION.equals(intent.getAction())) {
                updateTile();
            }
        }
    };

    @Override
    public void onCreate() {
        super.onCreate();
        mAudioManager = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
        IntentFilter filter = new IntentFilter(AudioManager.RINGER_MODE_CHANGED_ACTION);
        registerReceiver(mReceiver, filter);
    }

    @Override
    public void onDestroy() {
        unregisterReceiver(mReceiver);
        super.onDestroy();
    }

    @Override
    public void onStartListening() {
        updateTile();
    }

    @Override
    public void onClick() {
        int next;
        switch (mAudioManager.getRingerMode()) {
            case AudioManager.RINGER_MODE_VIBRATE:
                next = AudioManager.RINGER_MODE_SILENT;
                break;
            case AudioManager.RINGER_MODE_SILENT:
                next = AudioManager.RINGER_MODE_NORMAL;
                break;
            case AudioManager.RINGER_MODE_NORMAL:
            default:
                next = AudioManager.RINGER_MODE_VIBRATE;
                break;
        }
        mAudioManager.setRingerMode(next);
        updateTile();
    }

    private void updateTile() {
        Tile tile = getQsTile();
        if (tile == null) {
            return;
        }

        int mode = mAudioManager.getRingerMode();
        switch (mode) {
            case AudioManager.RINGER_MODE_VIBRATE:
                tile.setIcon(android.graphics.drawable.Icon
                        .createWithResource(this, R.drawable.ic_vibrate));
                tile.setLabel(getString(R.string.state_vibrate));
                tile.setState(Tile.STATE_ACTIVE);
                break;
            case AudioManager.RINGER_MODE_SILENT:
                tile.setIcon(android.graphics.drawable.Icon
                        .createWithResource(this, R.drawable.ic_silent));
                tile.setLabel(getString(R.string.state_silent));
                tile.setState(Tile.STATE_ACTIVE);
                break;
            case AudioManager.RINGER_MODE_NORMAL:
            default:
                tile.setIcon(android.graphics.drawable.Icon
                        .createWithResource(this, R.drawable.ic_ring));
                tile.setLabel(getString(R.string.state_ring));
                tile.setState(Tile.STATE_INACTIVE);
                break;
        }
        tile.updateTile();
    }
}
