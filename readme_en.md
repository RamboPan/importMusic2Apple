## Batch Import to Apple Music

If you are looking for a way to batch import songs to your iPad or iPhone, this method should help you.

Since there is no Music app on Windows, and it also requires using Apple's script application, this approach may not be suitable for you if you don't have those.

##### Convert Music to MP3

1. Install ffmpeg

```
brew install ffmpeg
```

1. Prepare the script by downloading the file and setting the script permissions.

```
chmod 711 cvt.sh
```

1. Run the script with the appropriate parameters.

```
bash cvt.sh <testMusic> <outputMusic>
```

Next, check the output folder to see if all the music files are present.

##### Batch Import Music

1. Organize the required files into the corresponding format:

```
outputMusic
├── folder1
│   ├── music1
│   ├── music2
│   └── ...
├── folder2
│   ├── music1
│   ├── music2
│   └── ...
```

Here, folder1 and folder2 represent the names of the corresponding playlists.

1. Run the script with the correct parameters:

```
osascript importMusic.scpt <outputMusic>
```

Next, check if all songs have been imported successfully.

Finally, use iTunes (Finder) to sync your music library.