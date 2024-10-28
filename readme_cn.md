## 批量导入苹果音乐

如果你正在寻找一种方式大量导入歌曲到 iPad 或者 iPhone 上，这个方法应该能帮到你。

因为 Windows 上没有音乐这个应用，并且还需要用到苹果的脚本应用。如果没有的话，这个办法就不太适合你了。

##### 音乐统一转 mp3

1. 安装 ffmpeg

```
brew install ffmpeg
```

2. 准备脚本，下载文件，将脚本权限添加。

```
chmod 711 cvt.sh
```

3. 运行脚本，传入适当的参数。

```
bash cvt.sh <testMusic> <outputMusic>
```

接下来就可以看导出的文件夹是否已经有所有音乐了。

##### 音乐批量导入

1. 将需要的文件整理为对应的格式

```
outputMusic
├── folder1
│   ├── music1
│   ├── music2
│   ……
├── folder2
│   ├── music1
│   ├── music2
│		……
```

folder1 和 folder2 为对应的歌单名字

2. 传入正确的参数运行脚本

```
osascript importMusic.scpt <outputMusic>
```

接下来就可以音乐是否已经导入所有歌曲。

最后使用 iTunes(Finder) 同步音乐库就行了。

