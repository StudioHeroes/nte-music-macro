#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent
SetWorkingDir A_ScriptDir
SetKeyDelay -1, -1
A_MaxHotkeysPerInterval := 1000

global Running := false
global OverlayVisible := true
global QpcFreq := InitQpcFreq()
global TimelineMaxMs := 123716.667
global TimelineLeft := 90
global TimelineTop := 34
global TimelineWidth := 980
global TimelineHeight := 106
global Playhead := ""
global OverlayGui := ""
global OverlayText := ""
global JitterMs := 3
global Events := [
    Map("t", 0.000, "k", "k", "tc", "00:00:05:35", "src", "original"),
    Map("t", 583.334, "k", "k", "tc", "00:00:06:10", "src", "original"),
    Map("t", 1233.334, "k", "d", "tc", "00:00:06:49", "src", "original"),
    Map("t", 1233.334, "k", "k", "tc", "00:00:06:49", "src", "original"),
    Map("t", 2516.667, "k", "d", "tc", "00:00:08:06", "src", "original"),
    Map("t", 2516.667, "k", "k", "tc", "00:00:08:06", "src", "original"),
    Map("t", 3150.000, "k", "d", "tc", "00:00:08:44", "src", "original"),
    Map("t", 3150.000, "k", "f", "tc", "00:00:08:44", "src", "original"),
    Map("t", 3483.334, "k", "j", "tc", "00:00:09:04", "src", "original"),
    Map("t", 3800.000, "k", "d", "tc", "00:00:09:23", "src", "original"),
    Map("t", 3800.000, "k", "k", "tc", "00:00:09:23", "src", "original"),
    Map("t", 4366.667, "k", "f", "tc", "00:00:09.950", "src", "audio_corrected_minus_500ms"),
    Map("t", 4983.334, "k", "d", "tc", "00:00:10:34", "src", "original"),
    Map("t", 4983.334, "k", "k", "tc", "00:00:10:34", "src", "original"),
    Map("t", 5633.334, "k", "f", "tc", "00:00:11:13", "src", "original"),
    Map("t", 6000.000, "k", "f", "tc", "00:00:11:35", "src", "original"),
    Map("t", 6316.667, "k", "d", "tc", "00:00:11:54", "src", "original"),
    Map("t", 6316.667, "k", "k", "tc", "00:00:11:54", "src", "original"),
    Map("t", 6633.334, "k", "d", "tc", "00:00:12:13", "src", "original"),
    Map("t", 6633.334, "k", "k", "tc", "00:00:12:13", "src", "original"),
    Map("t", 6950.000, "k", "d", "tc", "00:00:12:32", "src", "original"),
    Map("t", 6950.000, "k", "k", "tc", "00:00:12:32", "src", "original"),
    Map("t", 7266.667, "k", "d", "tc", "00:00:12:51", "src", "original"),
    Map("t", 7266.667, "k", "k", "tc", "00:00:12:51", "src", "original"),
    Map("t", 7583.334, "k", "d", "tc", "00:00:13:10", "src", "original"),
    Map("t", 7583.334, "k", "k", "tc", "00:00:13:10", "src", "original"),
    Map("t", 7916.667, "k", "d", "tc", "00:00:13:30", "src", "original"),
    Map("t", 7916.667, "k", "k", "tc", "00:00:13:30", "src", "original"),
    Map("t", 8216.667, "k", "d", "tc", "00:00:13:48", "src", "original"),
    Map("t", 8216.667, "k", "k", "tc", "00:00:13:48", "src", "original"),
    Map("t", 8533.334, "k", "f", "tc", "00:00:14:07", "src", "original"),
    Map("t", 8533.334, "k", "k", "tc", "00:00:14:07", "src", "original"),
    Map("t", 8850.000, "k", "d", "tc", "00:00:14:26", "src", "original"),
    Map("t", 8850.000, "k", "k", "tc", "00:00:14:26", "src", "original"),
    Map("t", 9166.667, "k", "d", "tc", "00:00:14:45", "src", "original"),
    Map("t", 9166.667, "k", "k", "tc", "00:00:14:45", "src", "original"),
    Map("t", 9483.334, "k", "d", "tc", "00:00:15:04", "src", "original"),
    Map("t", 9483.334, "k", "k", "tc", "00:00:15:04", "src", "original"),
    Map("t", 9800.000, "k", "d", "tc", "00:00:15:23", "src", "original"),
    Map("t", 9800.000, "k", "k", "tc", "00:00:15:23", "src", "original"),
    Map("t", 10100.000, "k", "d", "tc", "00:00:15:41", "src", "original"),
    Map("t", 10100.000, "k", "k", "tc", "00:00:15:41", "src", "original"),
    Map("t", 10416.667, "k", "d", "tc", "00:00:16:00", "src", "original"),
    Map("t", 10416.667, "k", "k", "tc", "00:00:16:00", "src", "original"),
    Map("t", 10716.667, "k", "d", "tc", "00:00:16:18", "src", "original"),
    Map("t", 10716.667, "k", "k", "tc", "00:00:16:18", "src", "original"),
    Map("t", 11050.000, "k", "d", "tc", "00:00:16:38", "src", "original"),
    Map("t", 11050.000, "k", "k", "tc", "00:00:16:38", "src", "original"),
    Map("t", 11366.667, "k", "d", "tc", "00:00:16:57", "src", "original"),
    Map("t", 11366.667, "k", "j", "tc", "00:00:16:57", "src", "original"),
    Map("t", 11683.334, "k", "f", "tc", "00:00:17:16", "src", "original"),
    Map("t", 12000.000, "k", "j", "tc", "00:00:17:35", "src", "original"),
    Map("t", 12650.000, "k", "d", "tc", "00:00:18:14", "src", "original"),
    Map("t", 12650.000, "k", "j", "tc", "00:00:18:14", "src", "original"),
    Map("t", 12966.667, "k", "f", "tc", "00:00:18:33", "src", "original"),
    Map("t", 13266.667, "k", "j", "tc", "00:00:18:51", "src", "original"),
    Map("t", 13916.667, "k", "d", "tc", "00:00:19:30", "src", "original"),
    Map("t", 13916.667, "k", "j", "tc", "00:00:19:30", "src", "original"),
    Map("t", 14200.000, "k", "f", "tc", "00:00:19:47", "src", "original"),
    Map("t", 14516.667, "k", "j", "tc", "00:00:20:06", "src", "original"),
    Map("t", 15150.000, "k", "d", "tc", "00:00:20:44", "src", "original"),
    Map("t", 15150.000, "k", "j", "tc", "00:00:20:44", "src", "original"),
    Map("t", 15416.667, "k", "f", "tc", "00:00:21:00", "src", "original"),
    Map("t", 15766.667, "k", "j", "tc", "00:00:21:21", "src", "original"),
    Map("t", 16400.000, "k", "d", "tc", "00:00:21:59", "src", "original"),
    Map("t", 16400.000, "k", "k", "tc", "00:00:21:59", "src", "original"),
    Map("t", 16666.667, "k", "f", "tc", "00:00:22:15", "src", "original"),
    Map("t", 17033.334, "k", "j", "tc", "00:00:22:37", "src", "original"),
    Map("t", 17650.000, "k", "d", "tc", "00:00:23:14", "src", "original"),
    Map("t", 17650.000, "k", "j", "tc", "00:00:23:14", "src", "original"),
    Map("t", 17966.667, "k", "f", "tc", "00:00:23:33", "src", "original"),
    Map("t", 18300.000, "k", "j", "tc", "00:00:23:53", "src", "original"),
    Map("t", 18916.667, "k", "d", "tc", "00:00:24:30", "src", "original"),
    Map("t", 18916.667, "k", "j", "tc", "00:00:24:30", "src", "original"),
    Map("t", 19200.000, "k", "f", "tc", "00:00:24:47", "src", "original"),
    Map("t", 19550.000, "k", "j", "tc", "00:00:25:08", "src", "original"),
    Map("t", 20183.334, "k", "d", "tc", "00:00:25:46", "src", "original"),
    Map("t", 20183.334, "k", "j", "tc", "00:00:25:46", "src", "original"),
    Map("t", 20450.000, "k", "f", "tc", "00:00:26:02", "src", "original"),
    Map("t", 20833.334, "k", "j", "tc", "00:00:26:25", "src", "original"),
    Map("t", 21450.000, "k", "d", "tc", "00:00:27:02", "src", "original"),
    Map("t", 21450.000, "k", "k", "tc", "00:00:27:02", "src", "original"),
    Map("t", 21766.667, "k", "f", "tc", "00:00:27:21", "src", "original"),
    Map("t", 22100.000, "k", "d", "tc", "00:00:27:41", "src", "original"),
    Map("t", 22100.000, "k", "k", "tc", "00:00:27:41", "src", "original"),
    Map("t", 22416.667, "k", "f", "tc", "00:00:28:00", "src", "original"),
    Map("t", 22716.667, "k", "d", "tc", "00:00:28:18", "src", "original"),
    Map("t", 22716.667, "k", "k", "tc", "00:00:28:18", "src", "original"),
    Map("t", 23050.000, "k", "f", "tc", "00:00:28:38", "src", "original"),
    Map("t", 23366.667, "k", "d", "tc", "00:00:28:57", "src", "original"),
    Map("t", 23366.667, "k", "k", "tc", "00:00:28:57", "src", "original"),
    Map("t", 23683.334, "k", "f", "tc", "00:00:29:16", "src", "original"),
    Map("t", 24000.000, "k", "d", "tc", "00:00:29:35", "src", "original"),
    Map("t", 24000.000, "k", "k", "tc", "00:00:29:35", "src", "original"),
    Map("t", 24300.000, "k", "f", "tc", "00:00:29:53", "src", "original"),
    Map("t", 24616.667, "k", "d", "tc", "00:00:30:12", "src", "original"),
    Map("t", 24616.667, "k", "k", "tc", "00:00:30:12", "src", "original"),
    Map("t", 24933.334, "k", "f", "tc", "00:00:30:31", "src", "original"),
    Map("t", 25250.000, "k", "d", "tc", "00:00:30:50", "src", "original"),
    Map("t", 25250.000, "k", "k", "tc", "00:00:30:50", "src", "original"),
    Map("t", 25566.667, "k", "f", "tc", "00:00:31:09", "src", "original"),
    Map("t", 25883.334, "k", "d", "tc", "00:00:31:28", "src", "original"),
    Map("t", 25883.334, "k", "k", "tc", "00:00:31:28", "src", "original"),
    Map("t", 26200.000, "k", "f", "tc", "00:00:31:47", "src", "original"),
    Map("t", 26516.667, "k", "d", "tc", "00:00:32:06", "src", "original"),
    Map("t", 26516.667, "k", "k", "tc", "00:00:32:06", "src", "original"),
    Map("t", 26833.334, "k", "f", "tc", "00:00:32:25", "src", "original"),
    Map("t", 27150.000, "k", "d", "tc", "00:00:32:44", "src", "original"),
    Map("t", 27150.000, "k", "k", "tc", "00:00:32:44", "src", "original"),
    Map("t", 27466.667, "k", "f", "tc", "00:00:33:03", "src", "original"),
    Map("t", 27783.334, "k", "d", "tc", "00:00:33:22", "src", "original"),
    Map("t", 27783.334, "k", "k", "tc", "00:00:33:22", "src", "original"),
    Map("t", 28100.000, "k", "f", "tc", "00:00:33:41", "src", "original"),
    Map("t", 28400.000, "k", "d", "tc", "00:00:33:59", "src", "original"),
    Map("t", 28400.000, "k", "k", "tc", "00:00:33:59", "src", "original"),
    Map("t", 28733.334, "k", "f", "tc", "00:00:34:19", "src", "original"),
    Map("t", 29050.000, "k", "d", "tc", "00:00:34:38", "src", "original"),
    Map("t", 29050.000, "k", "k", "tc", "00:00:34:38", "src", "original"),
    Map("t", 29366.667, "k", "f", "tc", "00:00:34:57", "src", "original"),
    Map("t", 29683.334, "k", "d", "tc", "00:00:35:16", "src", "original"),
    Map("t", 29683.334, "k", "k", "tc", "00:00:35:16", "src", "original"),
    Map("t", 30000.000, "k", "f", "tc", "00:00:35:35", "src", "original"),
    Map("t", 30300.000, "k", "d", "tc", "00:00:35:53", "src", "original"),
    Map("t", 30300.000, "k", "k", "tc", "00:00:35:53", "src", "original"),
    Map("t", 30600.000, "k", "d", "tc", "00:00:36:11", "src", "original"),
    Map("t", 30600.000, "k", "f", "tc", "00:00:36:11", "src", "original"),
    Map("t", 30933.334, "k", "d", "tc", "00:00:36:31", "src", "original"),
    Map("t", 30933.334, "k", "j", "tc", "00:00:36:31", "src", "original"),
    Map("t", 31266.667, "k", "d", "tc", "00:00:36:51", "src", "original"),
    Map("t", 31266.667, "k", "j", "tc", "00:00:36:51", "src", "original"),
    Map("t", 31583.334, "k", "d", "tc", "00:00:37:10", "src", "original"),
    Map("t", 31583.334, "k", "k", "tc", "00:00:37:10", "src", "original"),
    Map("t", 31883.334, "k", "d", "tc", "00:00:37:28", "src", "original"),
    Map("t", 31883.334, "k", "j", "tc", "00:00:37:28", "src", "original"),
    Map("t", 32200.000, "k", "d", "tc", "00:00:37:47", "src", "original"),
    Map("t", 32200.000, "k", "j", "tc", "00:00:37:47", "src", "original"),
    Map("t", 32200.000, "k", "k", "tc", "00:00:37:47", "src", "original"),
    Map("t", 32483.334, "k", "d", "tc", "00:00:38:04", "src", "original"),
    Map("t", 32483.334, "k", "j", "tc", "00:00:38:04", "src", "original"),
    Map("t", 32816.667, "k", "d", "tc", "00:00:38:24", "src", "original"),
    Map("t", 32816.667, "k", "j", "tc", "00:00:38:24", "src", "original"),
    Map("t", 33150.000, "k", "d", "tc", "00:00:38:44", "src", "original"),
    Map("t", 33150.000, "k", "j", "tc", "00:00:38:44", "src", "original"),
    Map("t", 33416.667, "k", "d", "tc", "00:00:39:00", "src", "original"),
    Map("t", 33416.667, "k", "j", "tc", "00:00:39:00", "src", "original"),
    Map("t", 33733.334, "k", "d", "tc", "00:00:39:19", "src", "original"),
    Map("t", 33733.334, "k", "j", "tc", "00:00:39:19", "src", "original"),
    Map("t", 34050.000, "k", "d", "tc", "00:00:39:38", "src", "original"),
    Map("t", 34050.000, "k", "k", "tc", "00:00:39:38", "src", "original"),
    Map("t", 34366.667, "k", "d", "tc", "00:00:39:57", "src", "original"),
    Map("t", 34366.667, "k", "j", "tc", "00:00:39:57", "src", "original"),
    Map("t", 34700.000, "k", "d", "tc", "00:00:40:17", "src", "original"),
    Map("t", 34700.000, "k", "j", "tc", "00:00:40:17", "src", "original"),
    Map("t", 35000.000, "k", "d", "tc", "00:00:40:35", "src", "original"),
    Map("t", 35000.000, "k", "j", "tc", "00:00:40:35", "src", "original"),
    Map("t", 35366.667, "k", "d", "tc", "00:00:40:57", "src", "original"),
    Map("t", 35366.667, "k", "j", "tc", "00:00:40:57", "src", "original"),
    Map("t", 35683.334, "k", "d", "tc", "00:00:41:16", "src", "original"),
    Map("t", 35683.334, "k", "j", "tc", "00:00:41:16", "src", "original"),
    Map("t", 36000.000, "k", "f", "tc", "00:00:41:35", "src", "original"),
    Map("t", 36000.000, "k", "k", "tc", "00:00:41:35", "src", "original"),
    Map("t", 36316.667, "k", "f", "tc", "00:00:41:54", "src", "original"),
    Map("t", 36316.667, "k", "k", "tc", "00:00:41:54", "src", "original"),
    Map("t", 36600.000, "k", "d", "tc", "00:00:42:11", "src", "original"),
    Map("t", 36600.000, "k", "k", "tc", "00:00:42:11", "src", "original"),
    Map("t", 36933.334, "k", "f", "tc", "00:00:42:31", "src", "original"),
    Map("t", 37266.667, "k", "k", "tc", "00:00:42:51", "src", "original"),
    Map("t", 37416.667, "k", "d", "tc", "00:00:43:00", "src", "original"),
    Map("t", 37650.000, "k", "f", "tc", "00:00:43:14", "src", "original"),
    Map("t", 37883.334, "k", "k", "tc", "00:00:43:28", "src", "original"),
    Map("t", 38200.000, "k", "f", "tc", "00:00:43:47", "src", "original"),
    Map("t", 38516.667, "k", "d", "tc", "00:00:44:06", "src", "original"),
    Map("t", 38516.667, "k", "k", "tc", "00:00:44:06", "src", "original"),
    Map("t", 38833.334, "k", "f", "tc", "00:00:44:25", "src", "original"),
    Map("t", 39150.000, "k", "d", "tc", "00:00:44:44", "src", "original"),
    Map("t", 39150.000, "k", "k", "tc", "00:00:44:44", "src", "original"),
    Map("t", 39466.667, "k", "f", "tc", "00:00:45:03", "src", "original"),
    Map("t", 39783.334, "k", "d", "tc", "00:00:45:22", "src", "original"),
    Map("t", 39783.334, "k", "k", "tc", "00:00:45:22", "src", "original"),
    Map("t", 40100.000, "k", "f", "tc", "00:00:45:41", "src", "original"),
    Map("t", 40416.667, "k", "d", "tc", "00:00:46:00", "src", "original"),
    Map("t", 40416.667, "k", "k", "tc", "00:00:46:00", "src", "original"),
    Map("t", 40733.334, "k", "f", "tc", "00:00:46:19", "src", "original"),
    Map("t", 41050.000, "k", "d", "tc", "00:00:46:38", "src", "original"),
    Map("t", 41050.000, "k", "k", "tc", "00:00:46:38", "src", "original"),
    Map("t", 41366.667, "k", "f", "tc", "00:00:46:57", "src", "original"),
    Map("t", 41666.667, "k", "d", "tc", "00:00:47:15", "src", "original"),
    Map("t", 41666.667, "k", "k", "tc", "00:00:47:15", "src", "original"),
    Map("t", 41983.334, "k", "f", "tc", "00:00:47:34", "src", "original"),
    Map("t", 42300.000, "k", "d", "tc", "00:00:47:53", "src", "original"),
    Map("t", 42300.000, "k", "k", "tc", "00:00:47:53", "src", "original"),
    Map("t", 42616.667, "k", "f", "tc", "00:00:48:12", "src", "original"),
    Map("t", 42933.334, "k", "d", "tc", "00:00:48:31", "src", "original"),
    Map("t", 42933.334, "k", "k", "tc", "00:00:48:31", "src", "original"),
    Map("t", 43250.000, "k", "f", "tc", "00:00:48:50", "src", "original"),
    Map("t", 43566.667, "k", "d", "tc", "00:00:49:09", "src", "original"),
    Map("t", 43566.667, "k", "k", "tc", "00:00:49:09", "src", "original"),
    Map("t", 43700.000, "k", "f", "tc", "00:00:49:17", "src", "original"),
    Map("t", 43883.334, "k", "j", "tc", "00:00:49:28", "src", "original"),
    Map("t", 44050.000, "k", "j", "tc", "00:00:49:38", "src", "original"),
    Map("t", 44200.000, "k", "d", "tc", "00:00:49:47", "src", "original"),
    Map("t", 45466.667, "k", "d", "tc", "00:00:51:03", "src", "original"),
    Map("t", 45466.667, "k", "k", "tc", "00:00:51:03", "src", "original"),
    Map("t", 45766.667, "k", "f", "tc", "00:00:51:21", "src", "original"),
    Map("t", 46100.000, "k", "d", "tc", "00:00:51:41", "src", "original"),
    Map("t", 46100.000, "k", "k", "tc", "00:00:51:41", "src", "original"),
    Map("t", 46400.000, "k", "f", "tc", "00:00:51:59", "src", "original"),
    Map("t", 46716.667, "k", "d", "tc", "00:00:52:18", "src", "original"),
    Map("t", 46716.667, "k", "k", "tc", "00:00:52:18", "src", "original"),
    Map("t", 47033.334, "k", "f", "tc", "00:00:52:37", "src", "original"),
    Map("t", 47366.667, "k", "d", "tc", "00:00:52:57", "src", "original"),
    Map("t", 47366.667, "k", "k", "tc", "00:00:52:57", "src", "original"),
    Map("t", 47683.334, "k", "f", "tc", "00:00:53:16", "src", "original"),
    Map("t", 47983.334, "k", "d", "tc", "00:00:53:34", "src", "original"),
    Map("t", 47983.334, "k", "k", "tc", "00:00:53:34", "src", "original"),
    Map("t", 48300.000, "k", "f", "tc", "00:00:53:53", "src", "original"),
    Map("t", 48616.667, "k", "d", "tc", "00:00:54:12", "src", "original"),
    Map("t", 48616.667, "k", "k", "tc", "00:00:54:12", "src", "original"),
    Map("t", 48933.334, "k", "f", "tc", "00:00:54:31", "src", "original"),
    Map("t", 49250.000, "k", "d", "tc", "00:00:54:50", "src", "original"),
    Map("t", 49250.000, "k", "k", "tc", "00:00:54:50", "src", "original"),
    Map("t", 49550.000, "k", "f", "tc", "00:00:55:08", "src", "original"),
    Map("t", 49883.334, "k", "d", "tc", "00:00:55:28", "src", "original"),
    Map("t", 49883.334, "k", "k", "tc", "00:00:55:28", "src", "original"),
    Map("t", 50183.334, "k", "f", "tc", "00:00:55:46", "src", "original"),
    Map("t", 50500.000, "k", "d", "tc", "00:00:56:05", "src", "original"),
    Map("t", 50500.000, "k", "k", "tc", "00:00:56:05", "src", "original"),
    Map("t", 50816.667, "k", "f", "tc", "00:00:56:24", "src", "original"),
    Map("t", 51133.334, "k", "d", "tc", "00:00:56:43", "src", "original"),
    Map("t", 51133.334, "k", "k", "tc", "00:00:56:43", "src", "original"),
    Map("t", 51416.667, "k", "f", "tc", "00:00:57:00", "src", "original"),
    Map("t", 51733.334, "k", "d", "tc", "00:00:57:19", "src", "original"),
    Map("t", 51733.334, "k", "k", "tc", "00:00:57:19", "src", "original"),
    Map("t", 52066.667, "k", "f", "tc", "00:00:57:39", "src", "original"),
    Map("t", 52366.667, "k", "d", "tc", "00:00:57:57", "src", "original"),
    Map("t", 52366.667, "k", "k", "tc", "00:00:57:57", "src", "original"),
    Map("t", 52666.667, "k", "f", "tc", "00:00:58:15", "src", "original"),
    Map("t", 53016.667, "k", "d", "tc", "00:00:58:36", "src", "original"),
    Map("t", 53016.667, "k", "k", "tc", "00:00:58:36", "src", "original"),
    Map("t", 53366.667, "k", "f", "tc", "00:00:58:57", "src", "original"),
    Map("t", 53666.667, "k", "d", "tc", "00:00:59:15", "src", "original"),
    Map("t", 53666.667, "k", "k", "tc", "00:00:59:15", "src", "original"),
    Map("t", 53983.334, "k", "f", "tc", "00:00:59:34", "src", "original"),
    Map("t", 54300.000, "k", "d", "tc", "00:00:59:53", "src", "original"),
    Map("t", 54300.000, "k", "k", "tc", "00:00:59:53", "src", "original"),
    Map("t", 54616.667, "k", "d", "tc", "00:01:00:12", "src", "original"),
    Map("t", 54616.667, "k", "f", "tc", "00:01:00:12", "src", "original"),
    Map("t", 54933.334, "k", "f", "tc", "00:01:00:31", "src", "original"),
    Map("t", 55100.000, "k", "f", "tc", "00:01:00:41", "src", "original"),
    Map("t", 55250.000, "k", "f", "tc", "00:01:00:50", "src", "original"),
    Map("t", 55416.667, "k", "f", "tc", "00:01:01:00", "src", "original"),
    Map("t", 55566.667, "k", "d", "tc", "00:01:01:09", "src", "original"),
    Map("t", 55566.667, "k", "k", "tc", "00:01:01:09", "src", "original"),
    Map("t", 55883.334, "k", "f", "tc", "00:01:01:28", "src", "original"),
    Map("t", 56100.000, "k", "d", "tc", "00:01:01:41", "src", "original"),
    Map("t", 56100.000, "k", "k", "tc", "00:01:01:41", "src", "original"),
    Map("t", 56483.334, "k", "f", "tc", "00:01:02:04", "src", "original"),
    Map("t", 56816.667, "k", "d", "tc", "00:01:02:24", "src", "original"),
    Map("t", 56816.667, "k", "k", "tc", "00:01:02:24", "src", "original"),
    Map("t", 57150.000, "k", "f", "tc", "00:01:02:44", "src", "original"),
    Map("t", 57466.667, "k", "d", "tc", "00:01:03:03", "src", "original"),
    Map("t", 57466.667, "k", "k", "tc", "00:01:03:03", "src", "original"),
    Map("t", 57783.334, "k", "f", "tc", "00:01:03:22", "src", "original"),
    Map("t", 58100.000, "k", "d", "tc", "00:01:03:41", "src", "original"),
    Map("t", 58100.000, "k", "k", "tc", "00:01:03:41", "src", "original"),
    Map("t", 58416.667, "k", "f", "tc", "00:01:04:00", "src", "original"),
    Map("t", 58733.334, "k", "d", "tc", "00:01:04:19", "src", "original"),
    Map("t", 58733.334, "k", "k", "tc", "00:01:04:19", "src", "original"),
    Map("t", 59050.000, "k", "f", "tc", "00:01:04:38", "src", "original"),
    Map("t", 59366.667, "k", "d", "tc", "00:01:04:57", "src", "original"),
    Map("t", 59366.667, "k", "k", "tc", "00:01:04:57", "src", "original"),
    Map("t", 59683.334, "k", "f", "tc", "00:01:05:16", "src", "original"),
    Map("t", 59983.334, "k", "d", "tc", "00:01:05:34", "src", "original"),
    Map("t", 59983.334, "k", "k", "tc", "00:01:05:34", "src", "original"),
    Map("t", 60316.667, "k", "f", "tc", "00:01:05:54", "src", "original"),
    Map("t", 60616.667, "k", "d", "tc", "00:01:06:12", "src", "original"),
    Map("t", 60616.667, "k", "k", "tc", "00:01:06:12", "src", "original"),
    Map("t", 60933.334, "k", "f", "tc", "00:01:06:31", "src", "original"),
    Map("t", 61250.000, "k", "d", "tc", "00:01:06:50", "src", "original"),
    Map("t", 61250.000, "k", "k", "tc", "00:01:06:50", "src", "original"),
    Map("t", 61566.667, "k", "f", "tc", "00:01:07:09", "src", "original"),
    Map("t", 61866.667, "k", "d", "tc", "00:01:07:27", "src", "original"),
    Map("t", 61866.667, "k", "k", "tc", "00:01:07:27", "src", "original"),
    Map("t", 62200.000, "k", "f", "tc", "00:01:07:47", "src", "original"),
    Map("t", 62500.000, "k", "d", "tc", "00:01:08:05", "src", "original"),
    Map("t", 62500.000, "k", "k", "tc", "00:01:08:05", "src", "original"),
    Map("t", 62816.667, "k", "f", "tc", "00:01:08:24", "src", "original"),
    Map("t", 63133.334, "k", "d", "tc", "00:01:08:43", "src", "original"),
    Map("t", 63133.334, "k", "k", "tc", "00:01:08:43", "src", "original"),
    Map("t", 63466.667, "k", "f", "tc", "00:01:09:03", "src", "original"),
    Map("t", 63766.667, "k", "d", "tc", "00:01:09:21", "src", "original"),
    Map("t", 63766.667, "k", "k", "tc", "00:01:09:21", "src", "original"),
    Map("t", 64100.000, "k", "f", "tc", "00:01:09:41", "src", "original"),
    Map("t", 64366.667, "k", "d", "tc", "00:01:09:57", "src", "original"),
    Map("t", 64366.667, "k", "k", "tc", "00:01:09:57", "src", "original"),
    Map("t", 64650.000, "k", "f", "tc", "00:01:10:14", "src", "original"),
    Map("t", 65033.334, "k", "f", "tc", "00:01:10:37", "src", "original"),
    Map("t", 65216.667, "k", "f", "tc", "00:01:10:48", "src", "original"),
    Map("t", 65316.667, "k", "j", "tc", "00:01:10:54", "src", "original"),
    Map("t", 65500.000, "k", "j", "tc", "00:01:11:05", "src", "original"),
    Map("t", 65666.667, "k", "d", "tc", "00:01:11:15", "src", "original"),
    Map("t", 65666.667, "k", "k", "tc", "00:01:11:15", "src", "original"),
    Map("t", 65950.000, "k", "f", "tc", "00:01:11:32", "src", "original"),
    Map("t", 66283.334, "k", "f", "tc", "00:01:11:52", "src", "original"),
    Map("t", 66283.334, "k", "k", "tc", "00:01:11:52", "src", "original"),
    Map("t", 66566.667, "k", "d", "tc", "00:01:12:09", "src", "original"),
    Map("t", 66750.000, "k", "f", "tc", "00:01:12:20", "src", "original"),
    Map("t", 67216.667, "k", "f", "tc", "00:01:12:48", "src", "original"),
    Map("t", 67416.667, "k", "f", "tc", "00:01:13:00", "src", "original"),
    Map("t", 67600.000, "k", "f", "tc", "00:01:13:11", "src", "original"),
    Map("t", 67883.334, "k", "j", "tc", "00:01:13:28", "src", "original"),
    Map("t", 68016.667, "k", "j", "tc", "00:01:13:36", "src", "original"),
    Map("t", 68200.000, "k", "d", "tc", "00:01:13:47", "src", "original"),
    Map("t", 68200.000, "k", "k", "tc", "00:01:13:47", "src", "original"),
    Map("t", 68500.000, "k", "d", "tc", "00:01:14:05", "src", "original"),
    Map("t", 68816.667, "k", "f", "tc", "00:01:14:24", "src", "original"),
    Map("t", 68816.667, "k", "k", "tc", "00:01:14:24", "src", "original"),
    Map("t", 69116.667, "k", "d", "tc", "00:01:14:42", "src", "original"),
    Map("t", 69450.000, "k", "k", "tc", "00:01:15:02", "src", "original"),
    Map("t", 69733.334, "k", "d", "tc", "00:01:15:19", "src", "original"),
    Map("t", 70066.667, "k", "f", "tc", "00:01:15:39", "src", "original"),
    Map("t", 70066.667, "k", "k", "tc", "00:01:15:39", "src", "original"),
    Map("t", 70383.334, "k", "d", "tc", "00:01:15:58", "src", "original"),
    Map("t", 70700.000, "k", "d", "tc", "00:01:16:17", "src", "original"),
    Map("t", 70700.000, "k", "k", "tc", "00:01:16:17", "src", "original"),
    Map("t", 71016.667, "k", "d", "tc", "00:01:16:36", "src", "original"),
    Map("t", 71350.000, "k", "f", "tc", "00:01:16:56", "src", "original"),
    Map("t", 71350.000, "k", "k", "tc", "00:01:16:56", "src", "original"),
    Map("t", 71650.000, "k", "d", "tc", "00:01:17:14", "src", "original"),
    Map("t", 71983.334, "k", "k", "tc", "00:01:17:34", "src", "original"),
    Map("t", 72266.667, "k", "d", "tc", "00:01:17:51", "src", "original"),
    Map("t", 72566.667, "k", "f", "tc", "00:01:18:09", "src", "original"),
    Map("t", 72566.667, "k", "k", "tc", "00:01:18:09", "src", "original"),
    Map("t", 72883.334, "k", "f", "tc", "00:01:18:28", "src", "original"),
    Map("t", 73166.667, "k", "d", "tc", "00:01:18:45", "src", "original"),
    Map("t", 73166.667, "k", "k", "tc", "00:01:18:45", "src", "original"),
    Map("t", 73516.667, "k", "d", "tc", "00:01:19:06", "src", "original"),
    Map("t", 73833.334, "k", "f", "tc", "00:01:19:25", "src", "original"),
    Map("t", 73833.334, "k", "k", "tc", "00:01:19:25", "src", "original"),
    Map("t", 74133.334, "k", "d", "tc", "00:01:19:43", "src", "original"),
    Map("t", 74483.334, "k", "k", "tc", "00:01:20:04", "src", "original"),
    Map("t", 74800.000, "k", "d", "tc", "00:01:20:23", "src", "original"),
    Map("t", 75033.334, "k", "f", "tc", "00:01:20:37", "src", "original"),
    Map("t", 75033.334, "k", "k", "tc", "00:01:20:37", "src", "original"),
    Map("t", 75416.667, "k", "d", "tc", "00:01:21:00", "src", "original"),
    Map("t", 75733.334, "k", "d", "tc", "00:01:21:19", "src", "original"),
    Map("t", 75733.334, "k", "k", "tc", "00:01:21:19", "src", "original"),
    Map("t", 76050.000, "k", "d", "tc", "00:01:21:38", "src", "original"),
    Map("t", 76366.667, "k", "f", "tc", "00:01:21:57", "src", "original"),
    Map("t", 76366.667, "k", "k", "tc", "00:01:21:57", "src", "original"),
    Map("t", 76666.667, "k", "d", "tc", "00:01:22:15", "src", "original"),
    Map("t", 76983.334, "k", "k", "tc", "00:01:22:34", "src", "original"),
    Map("t", 77300.000, "k", "d", "tc", "00:01:22:53", "src", "original"),
    Map("t", 77633.334, "k", "f", "tc", "00:01:23:13", "src", "original"),
    Map("t", 77633.334, "k", "k", "tc", "00:01:23:13", "src", "original"),
    Map("t", 77950.000, "k", "f", "tc", "00:01:23:32", "src", "original"),
    Map("t", 78266.667, "k", "d", "tc", "00:01:23:51", "src", "original"),
    Map("t", 78266.667, "k", "k", "tc", "00:01:23:51", "src", "original"),
    Map("t", 78566.667, "k", "f", "tc", "00:01:24:09", "src", "original"),
    Map("t", 78900.000, "k", "d", "tc", "00:01:24:29", "src", "original"),
    Map("t", 78900.000, "k", "k", "tc", "00:01:24:29", "src", "original"),
    Map("t", 79200.000, "k", "f", "tc", "00:01:24:47", "src", "original"),
    Map("t", 79516.667, "k", "d", "tc", "00:01:25:06", "src", "original"),
    Map("t", 79516.667, "k", "k", "tc", "00:01:25:06", "src", "original"),
    Map("t", 79833.334, "k", "f", "tc", "00:01:25:25", "src", "original"),
    Map("t", 80150.000, "k", "d", "tc", "00:01:25:44", "src", "original"),
    Map("t", 80150.000, "k", "k", "tc", "00:01:25:44", "src", "original"),
    Map("t", 80466.667, "k", "f", "tc", "00:01:26:03", "src", "original"),
    Map("t", 80783.334, "k", "d", "tc", "00:01:26:22", "src", "original"),
    Map("t", 80783.334, "k", "k", "tc", "00:01:26:22", "src", "original"),
    Map("t", 81100.000, "k", "f", "tc", "00:01:26:41", "src", "original"),
    Map("t", 81433.334, "k", "d", "tc", "00:01:27:01", "src", "original"),
    Map("t", 81433.334, "k", "k", "tc", "00:01:27:01", "src", "original"),
    Map("t", 81733.334, "k", "f", "tc", "00:01:27:19", "src", "original"),
    Map("t", 82050.000, "k", "d", "tc", "00:01:27:38", "src", "original"),
    Map("t", 82050.000, "k", "k", "tc", "00:01:27:38", "src", "original"),
    Map("t", 82366.667, "k", "f", "tc", "00:01:27:57", "src", "original"),
    Map("t", 82683.334, "k", "d", "tc", "00:01:28:16", "src", "original"),
    Map("t", 82683.334, "k", "k", "tc", "00:01:28:16", "src", "original"),
    Map("t", 83000.000, "k", "f", "tc", "00:01:28:35", "src", "original"),
    Map("t", 83316.667, "k", "d", "tc", "00:01:28:54", "src", "original"),
    Map("t", 83316.667, "k", "k", "tc", "00:01:28:54", "src", "original"),
    Map("t", 83600.000, "k", "f", "tc", "00:01:29:11", "src", "original"),
    Map("t", 83950.000, "k", "k", "tc", "00:01:29:32", "src", "original"),
    Map("t", 84116.667, "k", "d", "tc", "00:01:29:42", "src", "original"),
    Map("t", 84250.000, "k", "f", "tc", "00:01:29:50", "src", "original"),
    Map("t", 84583.334, "k", "f", "tc", "00:01:30:10", "src", "original"),
    Map("t", 84583.334, "k", "k", "tc", "00:01:30:10", "src", "original"),
    Map("t", 84866.667, "k", "d", "tc", "00:01:30:27", "src", "original"),
    Map("t", 85050.000, "k", "f", "tc", "00:01:30:38", "src", "original"),
    Map("t", 85183.334, "k", "k", "tc", "00:01:30:46", "src", "original"),
    Map("t", 85500.000, "k", "f", "tc", "00:01:31:05", "src", "original"),
    Map("t", 85800.000, "k", "f", "tc", "00:01:31:23", "src", "original"),
    Map("t", 85800.000, "k", "k", "tc", "00:01:31:23", "src", "original"),
    Map("t", 86150.000, "k", "d", "tc", "00:01:31:44", "src", "original"),
    Map("t", 86250.000, "k", "f", "tc", "00:01:31:50", "src", "original"),
    Map("t", 86450.000, "k", "k", "tc", "00:01:32:02", "src", "original"),
    Map("t", 86766.667, "k", "f", "tc", "00:01:32:21", "src", "original"),
    Map("t", 87066.667, "k", "d", "tc", "00:01:32:39", "src", "original"),
    Map("t", 87066.667, "k", "k", "tc", "00:01:32:39", "src", "original"),
    Map("t", 87366.667, "k", "d", "tc", "00:01:32:57", "src", "original"),
    Map("t", 87366.667, "k", "k", "tc", "00:01:32:57", "src", "original"),
    Map("t", 87733.334, "k", "d", "tc", "00:01:33:19", "src", "original"),
    Map("t", 87733.334, "k", "k", "tc", "00:01:33:19", "src", "original"),
    Map("t", 88050.000, "k", "d", "tc", "00:01:33:38", "src", "original"),
    Map("t", 88050.000, "k", "k", "tc", "00:01:33:38", "src", "original"),
    Map("t", 88366.667, "k", "d", "tc", "00:01:33:57", "src", "original"),
    Map("t", 88366.667, "k", "k", "tc", "00:01:33:57", "src", "original"),
    Map("t", 88666.667, "k", "d", "tc", "00:01:34:15", "src", "original"),
    Map("t", 88666.667, "k", "k", "tc", "00:01:34:15", "src", "original"),
    Map("t", 88983.334, "k", "d", "tc", "00:01:34:34", "src", "original"),
    Map("t", 88983.334, "k", "k", "tc", "00:01:34:34", "src", "original"),
    Map("t", 89300.000, "k", "d", "tc", "00:01:34:53", "src", "original"),
    Map("t", 89300.000, "k", "k", "tc", "00:01:34:53", "src", "original"),
    Map("t", 89616.667, "k", "d", "tc", "00:01:35:12", "src", "original"),
    Map("t", 89616.667, "k", "k", "tc", "00:01:35:12", "src", "original"),
    Map("t", 95950.000, "k", "d", "tc", "00:01:41:32", "src", "original"),
    Map("t", 95950.000, "k", "k", "tc", "00:01:41:32", "src", "original"),
    Map("t", 96266.667, "k", "d", "tc", "00:01:41:51", "src", "original"),
    Map("t", 96566.667, "k", "d", "tc", "00:01:42:09", "src", "original"),
    Map("t", 96900.000, "k", "d", "tc", "00:01:42:29", "src", "original"),
    Map("t", 97216.667, "k", "d", "tc", "00:01:42:48", "src", "original"),
    Map("t", 97516.667, "k", "d", "tc", "00:01:43:06", "src", "original"),
    Map("t", 97816.667, "k", "d", "tc", "00:01:43:24", "src", "original"),
    Map("t", 98016.667, "k", "d", "tc", "00:01:43:36", "src", "original"),
    Map("t", 98133.334, "k", "f", "tc", "00:01:43:43", "src", "original"),
    Map("t", 98450.000, "k", "d", "tc", "00:01:44:02", "src", "original"),
    Map("t", 98450.000, "k", "k", "tc", "00:01:44:02", "src", "original"),
    Map("t", 98716.667, "k", "f", "tc", "00:01:44:18", "src", "original"),
    Map("t", 99083.334, "k", "f", "tc", "00:01:44:40", "src", "original"),
    Map("t", 99233.334, "k", "d", "tc", "00:01:44:49", "src", "original"),
    Map("t", 99400.000, "k", "f", "tc", "00:01:44:59", "src", "original"),
    Map("t", 99566.667, "k", "d", "tc", "00:01:45:09", "src", "original"),
    Map("t", 99733.334, "k", "k", "tc", "00:01:45:19", "src", "original"),
    Map("t", 100033.334, "k", "d", "tc", "00:01:45:37", "src", "original"),
    Map("t", 100300.000, "k", "f", "tc", "00:01:45:53", "src", "original"),
    Map("t", 100516.667, "k", "f", "tc", "00:01:46:06", "src", "original"),
    Map("t", 100683.334, "k", "f", "tc", "00:01:46:16", "src", "original"),
    Map("t", 100833.334, "k", "f", "tc", "00:01:46:25", "src", "original"),
    Map("t", 101000.000, "k", "d", "tc", "00:01:46:35", "src", "original"),
    Map("t", 101000.000, "k", "k", "tc", "00:01:46:35", "src", "original"),
    Map("t", 101316.667, "k", "f", "tc", "00:01:46:54", "src", "original"),
    Map("t", 101633.334, "k", "d", "tc", "00:01:47:13", "src", "original"),
    Map("t", 101633.334, "k", "k", "tc", "00:01:47:13", "src", "original"),
    Map("t", 101950.000, "k", "f", "tc", "00:01:47:32", "src", "original"),
    Map("t", 102266.667, "k", "d", "tc", "00:01:47:51", "src", "original"),
    Map("t", 102266.667, "k", "k", "tc", "00:01:47:51", "src", "original"),
    Map("t", 102566.667, "k", "f", "tc", "00:01:48:09", "src", "original"),
    Map("t", 102900.000, "k", "d", "tc", "00:01:48:29", "src", "original"),
    Map("t", 102900.000, "k", "k", "tc", "00:01:48:29", "src", "original"),
    Map("t", 103216.667, "k", "f", "tc", "00:01:48:48", "src", "original"),
    Map("t", 103533.334, "k", "d", "tc", "00:01:49:07", "src", "original"),
    Map("t", 103533.334, "k", "k", "tc", "00:01:49:07", "src", "original"),
    Map("t", 103850.000, "k", "f", "tc", "00:01:49:26", "src", "original"),
    Map("t", 104166.667, "k", "d", "tc", "00:01:49:45", "src", "original"),
    Map("t", 104166.667, "k", "k", "tc", "00:01:49:45", "src", "original"),
    Map("t", 104466.667, "k", "f", "tc", "00:01:50:03", "src", "original"),
    Map("t", 104783.334, "k", "d", "tc", "00:01:50:22", "src", "original"),
    Map("t", 104783.334, "k", "k", "tc", "00:01:50:22", "src", "original"),
    Map("t", 105100.000, "k", "f", "tc", "00:01:50:41", "src", "original"),
    Map("t", 105416.667, "k", "d", "tc", "00:01:51:00", "src", "original"),
    Map("t", 105416.667, "k", "k", "tc", "00:01:51:00", "src", "original"),
    Map("t", 105750.000, "k", "f", "tc", "00:01:51:20", "src", "original"),
    Map("t", 106050.000, "k", "d", "tc", "00:01:51:38", "src", "original"),
    Map("t", 106050.000, "k", "k", "tc", "00:01:51:38", "src", "original"),
    Map("t", 106383.334, "k", "f", "tc", "00:01:51:58", "src", "original"),
    Map("t", 106683.334, "k", "d", "tc", "00:01:52:16", "src", "original"),
    Map("t", 106683.334, "k", "k", "tc", "00:01:52:16", "src", "original"),
    Map("t", 106983.334, "k", "f", "tc", "00:01:52:34", "src", "original"),
    Map("t", 107316.667, "k", "d", "tc", "00:01:52:54", "src", "original"),
    Map("t", 107316.667, "k", "k", "tc", "00:01:52:54", "src", "original"),
    Map("t", 107633.334, "k", "f", "tc", "00:01:53:13", "src", "original"),
    Map("t", 107950.000, "k", "d", "tc", "00:01:53:32", "src", "original"),
    Map("t", 107950.000, "k", "k", "tc", "00:01:53:32", "src", "original"),
    Map("t", 108266.667, "k", "f", "tc", "00:01:53:51", "src", "original"),
    Map("t", 108583.334, "k", "d", "tc", "00:01:54:10", "src", "original"),
    Map("t", 108583.334, "k", "k", "tc", "00:01:54:10", "src", "original"),
    Map("t", 108900.000, "k", "f", "tc", "00:01:54:29", "src", "original"),
    Map("t", 109216.667, "k", "d", "tc", "00:01:54:48", "src", "original"),
    Map("t", 109216.667, "k", "k", "tc", "00:01:54:48", "src", "original"),
    Map("t", 109533.334, "k", "f", "tc", "00:01:55:07", "src", "original"),
    Map("t", 109833.334, "k", "d", "tc", "00:01:55:25", "src", "original"),
    Map("t", 109833.334, "k", "k", "tc", "00:01:55:25", "src", "original"),
    Map("t", 110150.000, "k", "f", "tc", "00:01:55:44", "src", "original"),
    Map("t", 110466.667, "k", "f", "tc", "00:01:56:03", "src", "original"),
    Map("t", 110566.667, "k", "f", "tc", "00:01:56:09", "src", "original"),
    Map("t", 110750.000, "k", "j", "tc", "00:01:56:20", "src", "original"),
    Map("t", 110916.667, "k", "j", "tc", "00:01:56:30", "src", "original"),
    Map("t", 111100.000, "k", "d", "tc", "00:01:56:41", "src", "added_d"),
    Map("t", 111100.000, "k", "k", "tc", "00:01:56:41", "src", "original"),
    Map("t", 111416.667, "k", "f", "tc", "00:01:57:00", "src", "original"),
    Map("t", 111716.667, "k", "f", "tc", "00:01:57:18", "src", "original"),
    Map("t", 111716.667, "k", "k", "tc", "00:01:57:18", "src", "original"),
    Map("t", 112050.000, "k", "d", "tc", "00:01:57:38", "src", "added_d"),
    Map("t", 112150.000, "k", "f", "tc", "00:01:57:44", "src", "original"),
    Map("t", 112666.667, "k", "f", "tc", "00:01:58:15", "src", "original"),
    Map("t", 112866.667, "k", "f", "tc", "00:01:58:27", "src", "original"),
    Map("t", 113033.334, "k", "f", "tc", "00:01:58:37", "src", "original"),
    Map("t", 113183.334, "k", "j", "tc", "00:01:58:46", "src", "original"),
    Map("t", 113316.667, "k", "j", "tc", "00:01:58:54", "src", "original"),
    Map("t", 113483.334, "k", "j", "tc", "00:01:59:04", "src", "original"),
    Map("t", 113666.667, "k", "f", "tc", "00:01:59:15", "src", "original"),
    Map("t", 113666.667, "k", "k", "tc", "00:01:59:15", "src", "original"),
    Map("t", 113933.334, "k", "d", "tc", "00:01:59:31", "src", "added_d"),
    Map("t", 114083.334, "k", "f", "tc", "00:01:59:40", "src", "original"),
    Map("t", 114250.000, "k", "k", "tc", "00:01:59:50", "src", "original"),
    Map("t", 114383.334, "k", "d", "tc", "00:01:59:58", "src", "added_d"),
    Map("t", 114550.000, "k", "f", "tc", "00:02:00:08", "src", "original"),
    Map("t", 114866.667, "k", "f", "tc", "00:02:00:27", "src", "original"),
    Map("t", 114866.667, "k", "k", "tc", "00:02:00:27", "src", "original"),
    Map("t", 115166.667, "k", "d", "tc", "00:02:00:45", "src", "added_d"),
    Map("t", 115350.000, "k", "f", "tc", "00:02:00:56", "src", "original"),
    Map("t", 115516.667, "k", "k", "tc", "00:02:01:06", "src", "original"),
    Map("t", 115666.667, "k", "d", "tc", "00:02:01:15", "src", "added_d"),
    Map("t", 115816.667, "k", "f", "tc", "00:02:01:24", "src", "original"),
    Map("t", 116116.667, "k", "f", "tc", "00:02:01:42", "src", "original"),
    Map("t", 116116.667, "k", "k", "tc", "00:02:01:42", "src", "original"),
    Map("t", 116450.000, "k", "d", "tc", "00:02:02:02", "src", "added_d"),
    Map("t", 116633.334, "k", "f", "tc", "00:02:02:13", "src", "original"),
    Map("t", 116783.334, "k", "k", "tc", "00:02:02:22", "src", "original"),
    Map("t", 116933.334, "k", "d", "tc", "00:02:02:31", "src", "added_d"),
    Map("t", 117083.334, "k", "f", "tc", "00:02:02:40", "src", "original"),
    Map("t", 117400.000, "k", "d", "tc", "00:02:02:59", "src", "added_d"),
    Map("t", 117400.000, "k", "k", "tc", "00:02:02:59", "src", "original"),
    Map("t", 117733.334, "k", "f", "tc", "00:02:03:19", "src", "original"),
    Map("t", 118016.667, "k", "f", "tc", "00:02:03:36", "src", "original"),
    Map("t", 118200.000, "k", "f", "tc", "00:02:03:47", "src", "original"),
    Map("t", 118350.000, "k", "f", "tc", "00:02:03:56", "src", "original"),
    Map("t", 118366.667, "k", "j", "tc", "00:02:03:57", "src", "original"),
    Map("t", 118516.667, "k", "j", "tc", "00:02:04:06", "src", "original"),
    Map("t", 118666.667, "k", "d", "tc", "00:02:04:15", "src", "added_d"),
    Map("t", 118666.667, "k", "k", "tc", "00:02:04:15", "src", "original"),
    Map("t", 118983.334, "k", "d", "tc", "00:02:04:34", "src", "added_d"),
    Map("t", 118983.334, "k", "k", "tc", "00:02:04:34", "src", "original"),
    Map("t", 119316.667, "k", "d", "tc", "00:02:04:54", "src", "added_d"),
    Map("t", 119316.667, "k", "k", "tc", "00:02:04:54", "src", "original"),
    Map("t", 119633.334, "k", "d", "tc", "00:02:05:13", "src", "added_d"),
    Map("t", 119633.334, "k", "k", "tc", "00:02:05:13", "src", "original"),
    Map("t", 119933.334, "k", "d", "tc", "00:02:05:31", "src", "added_d"),
    Map("t", 119933.334, "k", "k", "tc", "00:02:05:31", "src", "original"),
    Map("t", 120233.334, "k", "d", "tc", "00:02:05:49", "src", "added_d"),
    Map("t", 120233.334, "k", "k", "tc", "00:02:05:49", "src", "original"),
    Map("t", 120550.000, "k", "d", "tc", "00:02:06:08", "src", "added_d"),
    Map("t", 120550.000, "k", "k", "tc", "00:02:06:08", "src", "original"),
    Map("t", 120866.667, "k", "f", "tc", "00:02:06:27", "src", "original"),
    Map("t", 120866.667, "k", "k", "tc", "00:02:06:27", "src", "original"),
    Map("t", 121200.000, "k", "d", "tc", "00:02:06:47", "src", "added_d"),
    Map("t", 121200.000, "k", "k", "tc", "00:02:06:47", "src", "original"),
    Map("t", 121516.667, "k", "d", "tc", "00:02:07:06", "src", "added_d"),
    Map("t", 121516.667, "k", "k", "tc", "00:02:07:06", "src", "original"),
    Map("t", 121850.000, "k", "d", "tc", "00:02:07:26", "src", "added_d"),
    Map("t", 121850.000, "k", "k", "tc", "00:02:07:26", "src", "original"),
    Map("t", 122166.667, "k", "d", "tc", "00:02:07:45", "src", "added_d"),
    Map("t", 122166.667, "k", "k", "tc", "00:02:07:45", "src", "original"),
    Map("t", 122450.000, "k", "d", "tc", "00:02:08:02", "src", "added_d"),
    Map("t", 122450.000, "k", "k", "tc", "00:02:08:02", "src", "original"),
    Map("t", 122733.334, "k", "d", "tc", "00:02:08:19", "src", "added_d"),
    Map("t", 122733.334, "k", "k", "tc", "00:02:08:19", "src", "original"),
    Map("t", 123066.667, "k", "f", "tc", "00:02:08:39", "src", "original"),
    Map("t", 123066.667, "k", "k", "tc", "00:02:08:39", "src", "original"),
    Map("t", 123350.000, "k", "d", "tc", "00:02:08:56", "src", "added_d"),
    Map("t", 123350.000, "k", "k", "tc", "00:02:08:56", "src", "original"),
    Map("t", 123716.667, "k", "d", "tc", "00:02:09:18", "src", "added_d"),
    Map("t", 123716.667, "k", "k", "tc", "00:02:09:18", "src", "original")
]

InitQpcFreq() {
    freq := 0
    DllCall("QueryPerformanceFrequency", "Int64*", &freq)
    return freq
}

QpcMs() {
    global QpcFreq
    counter := 0
    DllCall("QueryPerformanceCounter", "Int64*", &counter)
    return (counter * 1000.0) / QpcFreq
}

BuildOverlay()
]::ToggleMacro()
F10::ToggleOverlay()
Esc::ExitApp()

BuildOverlay() {
    global OverlayGui, OverlayText, Playhead, TimelineLeft, TimelineWidth
    OverlayGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
    OverlayGui.BackColor := "0F1115"
    OverlayGui.MarginX := 0
    OverlayGui.MarginY := 0
    OverlayGui.SetFont("s10", "Segoe UI")
    OverlayGui.AddText("x18 y10 cFFFFFF", "NTE Beats Overlay")
    OverlayGui.AddText("x18 y34 c3B82F6", "D")
    OverlayGui.AddText("x18 y64 cFACC15", "F")
    OverlayGui.AddText("x18 y94 cEF4444", "J")
    OverlayGui.AddText("x18 y124 cA855F7", "K")
    OverlayText := OverlayGui.AddText("x90 y10 w980 cD1D5DB", "Press ] to start/stop · ±3ms jitter on each run · F10 show/hide")
    OverlayGui.AddProgress("x" TimelineLeft " y38 w" TimelineWidth " h2 c2A3140 Background2A3140 Disabled", 100)
    OverlayGui.AddProgress("x" TimelineLeft " y68 w" TimelineWidth " h2 c2A3140 Background2A3140 Disabled", 100)
    OverlayGui.AddProgress("x" TimelineLeft " y98 w" TimelineWidth " h2 c2A3140 Background2A3140 Disabled", 100)
    OverlayGui.AddProgress("x" TimelineLeft " y128 w" TimelineWidth " h2 c2A3140 Background2A3140 Disabled", 100)
    AddMarker(0.000, 128, "a855f7")
    AddMarker(583.334, 128, "a855f7")
    AddMarker(1233.334, 38, "3b82f6")
    AddMarker(1233.334, 128, "a855f7")
    AddMarker(2516.667, 38, "3b82f6")
    AddMarker(2516.667, 128, "a855f7")
    AddMarker(3150.000, 38, "3b82f6")
    AddMarker(3150.000, 68, "facc15")
    AddMarker(3483.334, 98, "ef4444")
    AddMarker(3800.000, 38, "3b82f6")
    AddMarker(3800.000, 128, "a855f7")
    AddMarker(4366.667, 68, "facc15")
    AddMarker(4983.334, 38, "3b82f6")
    AddMarker(4983.334, 128, "a855f7")
    AddMarker(5633.334, 68, "facc15")
    AddMarker(6000.000, 68, "facc15")
    AddMarker(6316.667, 38, "3b82f6")
    AddMarker(6316.667, 128, "a855f7")
    AddMarker(6633.334, 38, "3b82f6")
    AddMarker(6633.334, 128, "a855f7")
    AddMarker(6950.000, 38, "3b82f6")
    AddMarker(6950.000, 128, "a855f7")
    AddMarker(7266.667, 38, "3b82f6")
    AddMarker(7266.667, 128, "a855f7")
    AddMarker(7583.334, 38, "3b82f6")
    AddMarker(7583.334, 128, "a855f7")
    AddMarker(7916.667, 38, "3b82f6")
    AddMarker(7916.667, 128, "a855f7")
    AddMarker(8216.667, 38, "3b82f6")
    AddMarker(8216.667, 128, "a855f7")
    AddMarker(8533.334, 68, "facc15")
    AddMarker(8533.334, 128, "a855f7")
    AddMarker(8850.000, 38, "3b82f6")
    AddMarker(8850.000, 128, "a855f7")
    AddMarker(9166.667, 38, "3b82f6")
    AddMarker(9166.667, 128, "a855f7")
    AddMarker(9483.334, 38, "3b82f6")
    AddMarker(9483.334, 128, "a855f7")
    AddMarker(9800.000, 38, "3b82f6")
    AddMarker(9800.000, 128, "a855f7")
    AddMarker(10100.000, 38, "3b82f6")
    AddMarker(10100.000, 128, "a855f7")
    AddMarker(10416.667, 38, "3b82f6")
    AddMarker(10416.667, 128, "a855f7")
    AddMarker(10716.667, 38, "3b82f6")
    AddMarker(10716.667, 128, "a855f7")
    AddMarker(11050.000, 38, "3b82f6")
    AddMarker(11050.000, 128, "a855f7")
    AddMarker(11366.667, 38, "3b82f6")
    AddMarker(11366.667, 98, "ef4444")
    AddMarker(11683.334, 68, "facc15")
    AddMarker(12000.000, 98, "ef4444")
    AddMarker(12650.000, 38, "3b82f6")
    AddMarker(12650.000, 98, "ef4444")
    AddMarker(12966.667, 68, "facc15")
    AddMarker(13266.667, 98, "ef4444")
    AddMarker(13916.667, 38, "3b82f6")
    AddMarker(13916.667, 98, "ef4444")
    AddMarker(14200.000, 68, "facc15")
    AddMarker(14516.667, 98, "ef4444")
    AddMarker(15150.000, 38, "3b82f6")
    AddMarker(15150.000, 98, "ef4444")
    AddMarker(15416.667, 68, "facc15")
    AddMarker(15766.667, 98, "ef4444")
    AddMarker(16400.000, 38, "3b82f6")
    AddMarker(16400.000, 128, "a855f7")
    AddMarker(16666.667, 68, "facc15")
    AddMarker(17033.334, 98, "ef4444")
    AddMarker(17650.000, 38, "3b82f6")
    AddMarker(17650.000, 98, "ef4444")
    AddMarker(17966.667, 68, "facc15")
    AddMarker(18300.000, 98, "ef4444")
    AddMarker(18916.667, 38, "3b82f6")
    AddMarker(18916.667, 98, "ef4444")
    AddMarker(19200.000, 68, "facc15")
    AddMarker(19550.000, 98, "ef4444")
    AddMarker(20183.334, 38, "3b82f6")
    AddMarker(20183.334, 98, "ef4444")
    AddMarker(20450.000, 68, "facc15")
    AddMarker(20833.334, 98, "ef4444")
    AddMarker(21450.000, 38, "3b82f6")
    AddMarker(21450.000, 128, "a855f7")
    AddMarker(21766.667, 68, "facc15")
    AddMarker(22100.000, 38, "3b82f6")
    AddMarker(22100.000, 128, "a855f7")
    AddMarker(22416.667, 68, "facc15")
    AddMarker(22716.667, 38, "3b82f6")
    AddMarker(22716.667, 128, "a855f7")
    AddMarker(23050.000, 68, "facc15")
    AddMarker(23366.667, 38, "3b82f6")
    AddMarker(23366.667, 128, "a855f7")
    AddMarker(23683.334, 68, "facc15")
    AddMarker(24000.000, 38, "3b82f6")
    AddMarker(24000.000, 128, "a855f7")
    AddMarker(24300.000, 68, "facc15")
    AddMarker(24616.667, 38, "3b82f6")
    AddMarker(24616.667, 128, "a855f7")
    AddMarker(24933.334, 68, "facc15")
    AddMarker(25250.000, 38, "3b82f6")
    AddMarker(25250.000, 128, "a855f7")
    AddMarker(25566.667, 68, "facc15")
    AddMarker(25883.334, 38, "3b82f6")
    AddMarker(25883.334, 128, "a855f7")
    AddMarker(26200.000, 68, "facc15")
    AddMarker(26516.667, 38, "3b82f6")
    AddMarker(26516.667, 128, "a855f7")
    AddMarker(26833.334, 68, "facc15")
    AddMarker(27150.000, 38, "3b82f6")
    AddMarker(27150.000, 128, "a855f7")
    AddMarker(27466.667, 68, "facc15")
    AddMarker(27783.334, 38, "3b82f6")
    AddMarker(27783.334, 128, "a855f7")
    AddMarker(28100.000, 68, "facc15")
    AddMarker(28400.000, 38, "3b82f6")
    AddMarker(28400.000, 128, "a855f7")
    AddMarker(28733.334, 68, "facc15")
    AddMarker(29050.000, 38, "3b82f6")
    AddMarker(29050.000, 128, "a855f7")
    AddMarker(29366.667, 68, "facc15")
    AddMarker(29683.334, 38, "3b82f6")
    AddMarker(29683.334, 128, "a855f7")
    AddMarker(30000.000, 68, "facc15")
    AddMarker(30300.000, 38, "3b82f6")
    AddMarker(30300.000, 128, "a855f7")
    AddMarker(30600.000, 38, "3b82f6")
    AddMarker(30600.000, 68, "facc15")
    AddMarker(30933.334, 38, "3b82f6")
    AddMarker(30933.334, 98, "ef4444")
    AddMarker(31266.667, 38, "3b82f6")
    AddMarker(31266.667, 98, "ef4444")
    AddMarker(31583.334, 38, "3b82f6")
    AddMarker(31583.334, 128, "a855f7")
    AddMarker(31883.334, 38, "3b82f6")
    AddMarker(31883.334, 98, "ef4444")
    AddMarker(32200.000, 38, "3b82f6")
    AddMarker(32200.000, 98, "ef4444")
    AddMarker(32200.000, 128, "a855f7")
    AddMarker(32483.334, 38, "3b82f6")
    AddMarker(32483.334, 98, "ef4444")
    AddMarker(32816.667, 38, "3b82f6")
    AddMarker(32816.667, 98, "ef4444")
    AddMarker(33150.000, 38, "3b82f6")
    AddMarker(33150.000, 98, "ef4444")
    AddMarker(33416.667, 38, "3b82f6")
    AddMarker(33416.667, 98, "ef4444")
    AddMarker(33733.334, 38, "3b82f6")
    AddMarker(33733.334, 98, "ef4444")
    AddMarker(34050.000, 38, "3b82f6")
    AddMarker(34050.000, 128, "a855f7")
    AddMarker(34366.667, 38, "3b82f6")
    AddMarker(34366.667, 98, "ef4444")
    AddMarker(34700.000, 38, "3b82f6")
    AddMarker(34700.000, 98, "ef4444")
    AddMarker(35000.000, 38, "3b82f6")
    AddMarker(35000.000, 98, "ef4444")
    AddMarker(35366.667, 38, "3b82f6")
    AddMarker(35366.667, 98, "ef4444")
    AddMarker(35683.334, 38, "3b82f6")
    AddMarker(35683.334, 98, "ef4444")
    AddMarker(36000.000, 68, "facc15")
    AddMarker(36000.000, 128, "a855f7")
    AddMarker(36316.667, 68, "facc15")
    AddMarker(36316.667, 128, "a855f7")
    AddMarker(36600.000, 38, "3b82f6")
    AddMarker(36600.000, 128, "a855f7")
    AddMarker(36933.334, 68, "facc15")
    AddMarker(37266.667, 128, "a855f7")
    AddMarker(37416.667, 38, "3b82f6")
    AddMarker(37650.000, 68, "facc15")
    AddMarker(37883.334, 128, "a855f7")
    AddMarker(38200.000, 68, "facc15")
    AddMarker(38516.667, 38, "3b82f6")
    AddMarker(38516.667, 128, "a855f7")
    AddMarker(38833.334, 68, "facc15")
    AddMarker(39150.000, 38, "3b82f6")
    AddMarker(39150.000, 128, "a855f7")
    AddMarker(39466.667, 68, "facc15")
    AddMarker(39783.334, 38, "3b82f6")
    AddMarker(39783.334, 128, "a855f7")
    AddMarker(40100.000, 68, "facc15")
    AddMarker(40416.667, 38, "3b82f6")
    AddMarker(40416.667, 128, "a855f7")
    AddMarker(40733.334, 68, "facc15")
    AddMarker(41050.000, 38, "3b82f6")
    AddMarker(41050.000, 128, "a855f7")
    AddMarker(41366.667, 68, "facc15")
    AddMarker(41666.667, 38, "3b82f6")
    AddMarker(41666.667, 128, "a855f7")
    AddMarker(41983.334, 68, "facc15")
    AddMarker(42300.000, 38, "3b82f6")
    AddMarker(42300.000, 128, "a855f7")
    AddMarker(42616.667, 68, "facc15")
    AddMarker(42933.334, 38, "3b82f6")
    AddMarker(42933.334, 128, "a855f7")
    AddMarker(43250.000, 68, "facc15")
    AddMarker(43566.667, 38, "3b82f6")
    AddMarker(43566.667, 128, "a855f7")
    AddMarker(43700.000, 68, "facc15")
    AddMarker(43883.334, 98, "ef4444")
    AddMarker(44050.000, 98, "ef4444")
    AddMarker(44200.000, 38, "3b82f6")
    AddMarker(45466.667, 38, "3b82f6")
    AddMarker(45466.667, 128, "a855f7")
    AddMarker(45766.667, 68, "facc15")
    AddMarker(46100.000, 38, "3b82f6")
    AddMarker(46100.000, 128, "a855f7")
    AddMarker(46400.000, 68, "facc15")
    AddMarker(46716.667, 38, "3b82f6")
    AddMarker(46716.667, 128, "a855f7")
    AddMarker(47033.334, 68, "facc15")
    AddMarker(47366.667, 38, "3b82f6")
    AddMarker(47366.667, 128, "a855f7")
    AddMarker(47683.334, 68, "facc15")
    AddMarker(47983.334, 38, "3b82f6")
    AddMarker(47983.334, 128, "a855f7")
    AddMarker(48300.000, 68, "facc15")
    AddMarker(48616.667, 38, "3b82f6")
    AddMarker(48616.667, 128, "a855f7")
    AddMarker(48933.334, 68, "facc15")
    AddMarker(49250.000, 38, "3b82f6")
    AddMarker(49250.000, 128, "a855f7")
    AddMarker(49550.000, 68, "facc15")
    AddMarker(49883.334, 38, "3b82f6")
    AddMarker(49883.334, 128, "a855f7")
    AddMarker(50183.334, 68, "facc15")
    AddMarker(50500.000, 38, "3b82f6")
    AddMarker(50500.000, 128, "a855f7")
    AddMarker(50816.667, 68, "facc15")
    AddMarker(51133.334, 38, "3b82f6")
    AddMarker(51133.334, 128, "a855f7")
    AddMarker(51416.667, 68, "facc15")
    AddMarker(51733.334, 38, "3b82f6")
    AddMarker(51733.334, 128, "a855f7")
    AddMarker(52066.667, 68, "facc15")
    AddMarker(52366.667, 38, "3b82f6")
    AddMarker(52366.667, 128, "a855f7")
    AddMarker(52666.667, 68, "facc15")
    AddMarker(53016.667, 38, "3b82f6")
    AddMarker(53016.667, 128, "a855f7")
    AddMarker(53366.667, 68, "facc15")
    AddMarker(53666.667, 38, "3b82f6")
    AddMarker(53666.667, 128, "a855f7")
    AddMarker(53983.334, 68, "facc15")
    AddMarker(54300.000, 38, "3b82f6")
    AddMarker(54300.000, 128, "a855f7")
    AddMarker(54616.667, 38, "3b82f6")
    AddMarker(54616.667, 68, "facc15")
    AddMarker(54933.334, 68, "facc15")
    AddMarker(55100.000, 68, "facc15")
    AddMarker(55250.000, 68, "facc15")
    AddMarker(55416.667, 68, "facc15")
    AddMarker(55566.667, 38, "3b82f6")
    AddMarker(55566.667, 128, "a855f7")
    AddMarker(55883.334, 68, "facc15")
    AddMarker(56100.000, 38, "3b82f6")
    AddMarker(56100.000, 128, "a855f7")
    AddMarker(56483.334, 68, "facc15")
    AddMarker(56816.667, 38, "3b82f6")
    AddMarker(56816.667, 128, "a855f7")
    AddMarker(57150.000, 68, "facc15")
    AddMarker(57466.667, 38, "3b82f6")
    AddMarker(57466.667, 128, "a855f7")
    AddMarker(57783.334, 68, "facc15")
    AddMarker(58100.000, 38, "3b82f6")
    AddMarker(58100.000, 128, "a855f7")
    AddMarker(58416.667, 68, "facc15")
    AddMarker(58733.334, 38, "3b82f6")
    AddMarker(58733.334, 128, "a855f7")
    AddMarker(59050.000, 68, "facc15")
    AddMarker(59366.667, 38, "3b82f6")
    AddMarker(59366.667, 128, "a855f7")
    AddMarker(59683.334, 68, "facc15")
    AddMarker(59983.334, 38, "3b82f6")
    AddMarker(59983.334, 128, "a855f7")
    AddMarker(60316.667, 68, "facc15")
    AddMarker(60616.667, 38, "3b82f6")
    AddMarker(60616.667, 128, "a855f7")
    AddMarker(60933.334, 68, "facc15")
    AddMarker(61250.000, 38, "3b82f6")
    AddMarker(61250.000, 128, "a855f7")
    AddMarker(61566.667, 68, "facc15")
    AddMarker(61866.667, 38, "3b82f6")
    AddMarker(61866.667, 128, "a855f7")
    AddMarker(62200.000, 68, "facc15")
    AddMarker(62500.000, 38, "3b82f6")
    AddMarker(62500.000, 128, "a855f7")
    AddMarker(62816.667, 68, "facc15")
    AddMarker(63133.334, 38, "3b82f6")
    AddMarker(63133.334, 128, "a855f7")
    AddMarker(63466.667, 68, "facc15")
    AddMarker(63766.667, 38, "3b82f6")
    AddMarker(63766.667, 128, "a855f7")
    AddMarker(64100.000, 68, "facc15")
    AddMarker(64366.667, 38, "3b82f6")
    AddMarker(64366.667, 128, "a855f7")
    AddMarker(64650.000, 68, "facc15")
    AddMarker(65033.334, 68, "facc15")
    AddMarker(65216.667, 68, "facc15")
    AddMarker(65316.667, 98, "ef4444")
    AddMarker(65500.000, 98, "ef4444")
    AddMarker(65666.667, 38, "3b82f6")
    AddMarker(65666.667, 128, "a855f7")
    AddMarker(65950.000, 68, "facc15")
    AddMarker(66283.334, 68, "facc15")
    AddMarker(66283.334, 128, "a855f7")
    AddMarker(66566.667, 38, "3b82f6")
    AddMarker(66750.000, 68, "facc15")
    AddMarker(67216.667, 68, "facc15")
    AddMarker(67416.667, 68, "facc15")
    AddMarker(67600.000, 68, "facc15")
    AddMarker(67883.334, 98, "ef4444")
    AddMarker(68016.667, 98, "ef4444")
    AddMarker(68200.000, 38, "3b82f6")
    AddMarker(68200.000, 128, "a855f7")
    AddMarker(68500.000, 38, "3b82f6")
    AddMarker(68816.667, 68, "facc15")
    AddMarker(68816.667, 128, "a855f7")
    AddMarker(69116.667, 38, "3b82f6")
    AddMarker(69450.000, 128, "a855f7")
    AddMarker(69733.334, 38, "3b82f6")
    AddMarker(70066.667, 68, "facc15")
    AddMarker(70066.667, 128, "a855f7")
    AddMarker(70383.334, 38, "3b82f6")
    AddMarker(70700.000, 38, "3b82f6")
    AddMarker(70700.000, 128, "a855f7")
    AddMarker(71016.667, 38, "3b82f6")
    AddMarker(71350.000, 68, "facc15")
    AddMarker(71350.000, 128, "a855f7")
    AddMarker(71650.000, 38, "3b82f6")
    AddMarker(71983.334, 128, "a855f7")
    AddMarker(72266.667, 38, "3b82f6")
    AddMarker(72566.667, 68, "facc15")
    AddMarker(72566.667, 128, "a855f7")
    AddMarker(72883.334, 68, "facc15")
    AddMarker(73166.667, 38, "3b82f6")
    AddMarker(73166.667, 128, "a855f7")
    AddMarker(73516.667, 38, "3b82f6")
    AddMarker(73833.334, 68, "facc15")
    AddMarker(73833.334, 128, "a855f7")
    AddMarker(74133.334, 38, "3b82f6")
    AddMarker(74483.334, 128, "a855f7")
    AddMarker(74800.000, 38, "3b82f6")
    AddMarker(75033.334, 68, "facc15")
    AddMarker(75033.334, 128, "a855f7")
    AddMarker(75416.667, 38, "3b82f6")
    AddMarker(75733.334, 38, "3b82f6")
    AddMarker(75733.334, 128, "a855f7")
    AddMarker(76050.000, 38, "3b82f6")
    AddMarker(76366.667, 68, "facc15")
    AddMarker(76366.667, 128, "a855f7")
    AddMarker(76666.667, 38, "3b82f6")
    AddMarker(76983.334, 128, "a855f7")
    AddMarker(77300.000, 38, "3b82f6")
    AddMarker(77633.334, 68, "facc15")
    AddMarker(77633.334, 128, "a855f7")
    AddMarker(77950.000, 68, "facc15")
    AddMarker(78266.667, 38, "3b82f6")
    AddMarker(78266.667, 128, "a855f7")
    AddMarker(78566.667, 68, "facc15")
    AddMarker(78900.000, 38, "3b82f6")
    AddMarker(78900.000, 128, "a855f7")
    AddMarker(79200.000, 68, "facc15")
    AddMarker(79516.667, 38, "3b82f6")
    AddMarker(79516.667, 128, "a855f7")
    AddMarker(79833.334, 68, "facc15")
    AddMarker(80150.000, 38, "3b82f6")
    AddMarker(80150.000, 128, "a855f7")
    AddMarker(80466.667, 68, "facc15")
    AddMarker(80783.334, 38, "3b82f6")
    AddMarker(80783.334, 128, "a855f7")
    AddMarker(81100.000, 68, "facc15")
    AddMarker(81433.334, 38, "3b82f6")
    AddMarker(81433.334, 128, "a855f7")
    AddMarker(81733.334, 68, "facc15")
    AddMarker(82050.000, 38, "3b82f6")
    AddMarker(82050.000, 128, "a855f7")
    AddMarker(82366.667, 68, "facc15")
    AddMarker(82683.334, 38, "3b82f6")
    AddMarker(82683.334, 128, "a855f7")
    AddMarker(83000.000, 68, "facc15")
    AddMarker(83316.667, 38, "3b82f6")
    AddMarker(83316.667, 128, "a855f7")
    AddMarker(83600.000, 68, "facc15")
    AddMarker(83950.000, 128, "a855f7")
    AddMarker(84116.667, 38, "3b82f6")
    AddMarker(84250.000, 68, "facc15")
    AddMarker(84583.334, 68, "facc15")
    AddMarker(84583.334, 128, "a855f7")
    AddMarker(84866.667, 38, "3b82f6")
    AddMarker(85050.000, 68, "facc15")
    AddMarker(85183.334, 128, "a855f7")
    AddMarker(85500.000, 68, "facc15")
    AddMarker(85800.000, 68, "facc15")
    AddMarker(85800.000, 128, "a855f7")
    AddMarker(86150.000, 38, "3b82f6")
    AddMarker(86250.000, 68, "facc15")
    AddMarker(86450.000, 128, "a855f7")
    AddMarker(86766.667, 68, "facc15")
    AddMarker(87066.667, 38, "3b82f6")
    AddMarker(87066.667, 128, "a855f7")
    AddMarker(87366.667, 38, "3b82f6")
    AddMarker(87366.667, 128, "a855f7")
    AddMarker(87733.334, 38, "3b82f6")
    AddMarker(87733.334, 128, "a855f7")
    AddMarker(88050.000, 38, "3b82f6")
    AddMarker(88050.000, 128, "a855f7")
    AddMarker(88366.667, 38, "3b82f6")
    AddMarker(88366.667, 128, "a855f7")
    AddMarker(88666.667, 38, "3b82f6")
    AddMarker(88666.667, 128, "a855f7")
    AddMarker(88983.334, 38, "3b82f6")
    AddMarker(88983.334, 128, "a855f7")
    AddMarker(89300.000, 38, "3b82f6")
    AddMarker(89300.000, 128, "a855f7")
    AddMarker(89616.667, 38, "3b82f6")
    AddMarker(89616.667, 128, "a855f7")
    AddMarker(95950.000, 38, "3b82f6")
    AddMarker(95950.000, 128, "a855f7")
    AddMarker(96266.667, 38, "3b82f6")
    AddMarker(96566.667, 38, "3b82f6")
    AddMarker(96900.000, 38, "3b82f6")
    AddMarker(97216.667, 38, "3b82f6")
    AddMarker(97516.667, 38, "3b82f6")
    AddMarker(97816.667, 38, "3b82f6")
    AddMarker(98016.667, 38, "3b82f6")
    AddMarker(98133.334, 68, "facc15")
    AddMarker(98450.000, 38, "3b82f6")
    AddMarker(98450.000, 128, "a855f7")
    AddMarker(98716.667, 68, "facc15")
    AddMarker(99083.334, 68, "facc15")
    AddMarker(99233.334, 38, "3b82f6")
    AddMarker(99400.000, 68, "facc15")
    AddMarker(99566.667, 38, "3b82f6")
    AddMarker(99733.334, 128, "a855f7")
    AddMarker(100033.334, 38, "3b82f6")
    AddMarker(100300.000, 68, "facc15")
    AddMarker(100516.667, 68, "facc15")
    AddMarker(100683.334, 68, "facc15")
    AddMarker(100833.334, 68, "facc15")
    AddMarker(101000.000, 38, "3b82f6")
    AddMarker(101000.000, 128, "a855f7")
    AddMarker(101316.667, 68, "facc15")
    AddMarker(101633.334, 38, "3b82f6")
    AddMarker(101633.334, 128, "a855f7")
    AddMarker(101950.000, 68, "facc15")
    AddMarker(102266.667, 38, "3b82f6")
    AddMarker(102266.667, 128, "a855f7")
    AddMarker(102566.667, 68, "facc15")
    AddMarker(102900.000, 38, "3b82f6")
    AddMarker(102900.000, 128, "a855f7")
    AddMarker(103216.667, 68, "facc15")
    AddMarker(103533.334, 38, "3b82f6")
    AddMarker(103533.334, 128, "a855f7")
    AddMarker(103850.000, 68, "facc15")
    AddMarker(104166.667, 38, "3b82f6")
    AddMarker(104166.667, 128, "a855f7")
    AddMarker(104466.667, 68, "facc15")
    AddMarker(104783.334, 38, "3b82f6")
    AddMarker(104783.334, 128, "a855f7")
    AddMarker(105100.000, 68, "facc15")
    AddMarker(105416.667, 38, "3b82f6")
    AddMarker(105416.667, 128, "a855f7")
    AddMarker(105750.000, 68, "facc15")
    AddMarker(106050.000, 38, "3b82f6")
    AddMarker(106050.000, 128, "a855f7")
    AddMarker(106383.334, 68, "facc15")
    AddMarker(106683.334, 38, "3b82f6")
    AddMarker(106683.334, 128, "a855f7")
    AddMarker(106983.334, 68, "facc15")
    AddMarker(107316.667, 38, "3b82f6")
    AddMarker(107316.667, 128, "a855f7")
    AddMarker(107633.334, 68, "facc15")
    AddMarker(107950.000, 38, "3b82f6")
    AddMarker(107950.000, 128, "a855f7")
    AddMarker(108266.667, 68, "facc15")
    AddMarker(108583.334, 38, "3b82f6")
    AddMarker(108583.334, 128, "a855f7")
    AddMarker(108900.000, 68, "facc15")
    AddMarker(109216.667, 38, "3b82f6")
    AddMarker(109216.667, 128, "a855f7")
    AddMarker(109533.334, 68, "facc15")
    AddMarker(109833.334, 38, "3b82f6")
    AddMarker(109833.334, 128, "a855f7")
    AddMarker(110150.000, 68, "facc15")
    AddMarker(110466.667, 68, "facc15")
    AddMarker(110566.667, 68, "facc15")
    AddMarker(110750.000, 98, "ef4444")
    AddMarker(110916.667, 98, "ef4444")
    AddMarker(111100.000, 38, "3b82f6")
    AddMarker(111100.000, 128, "a855f7")
    AddMarker(111416.667, 68, "facc15")
    AddMarker(111716.667, 68, "facc15")
    AddMarker(111716.667, 128, "a855f7")
    AddMarker(112050.000, 38, "3b82f6")
    AddMarker(112150.000, 68, "facc15")
    AddMarker(112666.667, 68, "facc15")
    AddMarker(112866.667, 68, "facc15")
    AddMarker(113033.334, 68, "facc15")
    AddMarker(113183.334, 98, "ef4444")
    AddMarker(113316.667, 98, "ef4444")
    AddMarker(113483.334, 98, "ef4444")
    AddMarker(113666.667, 68, "facc15")
    AddMarker(113666.667, 128, "a855f7")
    AddMarker(113933.334, 38, "3b82f6")
    AddMarker(114083.334, 68, "facc15")
    AddMarker(114250.000, 128, "a855f7")
    AddMarker(114383.334, 38, "3b82f6")
    AddMarker(114550.000, 68, "facc15")
    AddMarker(114866.667, 68, "facc15")
    AddMarker(114866.667, 128, "a855f7")
    AddMarker(115166.667, 38, "3b82f6")
    AddMarker(115350.000, 68, "facc15")
    AddMarker(115516.667, 128, "a855f7")
    AddMarker(115666.667, 38, "3b82f6")
    AddMarker(115816.667, 68, "facc15")
    AddMarker(116116.667, 68, "facc15")
    AddMarker(116116.667, 128, "a855f7")
    AddMarker(116450.000, 38, "3b82f6")
    AddMarker(116633.334, 68, "facc15")
    AddMarker(116783.334, 128, "a855f7")
    AddMarker(116933.334, 38, "3b82f6")
    AddMarker(117083.334, 68, "facc15")
    AddMarker(117400.000, 38, "3b82f6")
    AddMarker(117400.000, 128, "a855f7")
    AddMarker(117733.334, 68, "facc15")
    AddMarker(118016.667, 68, "facc15")
    AddMarker(118200.000, 68, "facc15")
    AddMarker(118350.000, 68, "facc15")
    AddMarker(118366.667, 98, "ef4444")
    AddMarker(118516.667, 98, "ef4444")
    AddMarker(118666.667, 38, "3b82f6")
    AddMarker(118666.667, 128, "a855f7")
    AddMarker(118983.334, 38, "3b82f6")
    AddMarker(118983.334, 128, "a855f7")
    AddMarker(119316.667, 38, "3b82f6")
    AddMarker(119316.667, 128, "a855f7")
    AddMarker(119633.334, 38, "3b82f6")
    AddMarker(119633.334, 128, "a855f7")
    AddMarker(119933.334, 38, "3b82f6")
    AddMarker(119933.334, 128, "a855f7")
    AddMarker(120233.334, 38, "3b82f6")
    AddMarker(120233.334, 128, "a855f7")
    AddMarker(120550.000, 38, "3b82f6")
    AddMarker(120550.000, 128, "a855f7")
    AddMarker(120866.667, 68, "facc15")
    AddMarker(120866.667, 128, "a855f7")
    AddMarker(121200.000, 38, "3b82f6")
    AddMarker(121200.000, 128, "a855f7")
    AddMarker(121516.667, 38, "3b82f6")
    AddMarker(121516.667, 128, "a855f7")
    AddMarker(121850.000, 38, "3b82f6")
    AddMarker(121850.000, 128, "a855f7")
    AddMarker(122166.667, 38, "3b82f6")
    AddMarker(122166.667, 128, "a855f7")
    AddMarker(122450.000, 38, "3b82f6")
    AddMarker(122450.000, 128, "a855f7")
    AddMarker(122733.334, 38, "3b82f6")
    AddMarker(122733.334, 128, "a855f7")
    AddMarker(123066.667, 68, "facc15")
    AddMarker(123066.667, 128, "a855f7")
    AddMarker(123350.000, 38, "3b82f6")
    AddMarker(123350.000, 128, "a855f7")
    AddMarker(123716.667, 38, "3b82f6")
    AddMarker(123716.667, 128, "a855f7")
    Playhead := OverlayGui.AddProgress("x" TimelineLeft " y32 w2 h106 cFF6B6B BackgroundFF6B6B Disabled", 100)
    OverlayGui.Show("x20 y20 w1095 h150 NoActivate")
    WinSetTransparent(235, "ahk_id " OverlayGui.Hwnd)
}

AddMarker(ms, y, color) {
    global OverlayGui, TimelineLeft, TimelineWidth, TimelineMaxMs
    x := TimelineLeft + Round((ms / TimelineMaxMs) * TimelineWidth)
    OverlayGui.AddProgress("x" x-2 " y" y-3 " w6 h6 c" color " Background" color " Disabled", 100)
}

ToggleOverlay() {
    global OverlayVisible, OverlayGui
    if OverlayVisible {
        OverlayGui.Hide()
        OverlayVisible := false
    } else {
        OverlayGui.Show("NoActivate")
        OverlayVisible := true
    }
}

ToggleMacro() {
    global Running, OverlayText
    if Running {
        Running := false
        OverlayText.Text := "Stopped · Press ] to start again"
        SetTimer(UpdatePlayhead, 0)
        return
    }
    Running := true
    OverlayText.Text := "Running · Press ] to stop"
    SetTimer(RunMacro, -1)
}

RunMacro() {
    global Running, Events, OverlayText, MacroStartMs, JitterMs
    DllCall("winmm\timeBeginPeriod", "UInt", 1)
    MacroStartMs := QpcMs()
    SetTimer(UpdatePlayhead, 15)
    UpdatePlayhead()
    lastTargetMs := 0
    for evt in Events {
        if !Running
            break
        jitter := Random(-JitterMs, JitterMs)
        targetMs := evt["t"] + jitter
        if (targetMs < 0)
            targetMs := 0
        if (targetMs < lastTargetMs)
            targetMs := lastTargetMs
        lastTargetMs := targetMs
        while Running {
            elapsedMs := QpcMs() - MacroStartMs
            remaining := targetMs - elapsedMs
            if (remaining <= 0)
                break
            if (remaining > 12)
                Sleep(Floor(remaining - 6))
            else if (remaining > 2)
                Sleep(1)
        }
        if !Running
            break
        SendEvent("{" evt["k"] " down}")
        SendEvent("{" evt["k"] " up}")
    }
    DllCall("winmm\timeEndPeriod", "UInt", 1)
    SetTimer(UpdatePlayhead, 0)
    finishedNaturally := Running
    Running := false
    if finishedNaturally
        OverlayText.Text := "Finished · Press ] to run again"
}

UpdatePlayhead() {
    global Running, Playhead, TimelineLeft, TimelineWidth, TimelineMaxMs, OverlayText, MacroStartMs
    if !Running {
        Playhead.Move(TimelineLeft, 32, 2, 106)
        return
    }
    elapsed := QpcMs() - MacroStartMs
    if (elapsed < 0)
        elapsed := 0
    if (elapsed > TimelineMaxMs)
        elapsed := TimelineMaxMs
    x := TimelineLeft + Round((elapsed / TimelineMaxMs) * TimelineWidth)
    Playhead.Move(x, 32, 2, 106)
    OverlayText.Text := "Running · " FormatTimeMs(elapsed)
    if (elapsed >= TimelineMaxMs)
        SetTimer(UpdatePlayhead, 0)
}

FormatTimeMs(ms) {
    total := Floor(ms)
    mins := Floor(total / 60000)
    secs := Floor(Mod(total, 60000) / 1000)
    milli := Mod(total, 1000)
    return Format("{:02}:{:02}.{:03}", mins, secs, milli)
}
