/*
  * 本程序使用GPLv2协议发布
  */
import dataModel 1.0

import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Dialogs 1.1
import QtGraphicalEffects 1.0
import QtMultimedia 5.0

Rectangle {
    id:root
    implicitWidth: 400
    implicitHeight: 650
    color: Qt.rgba(0,0,0,0)
    Audio {
        //注意：使用该控件必须要保证运行环境下已安装解码器(linux: GStreamer)
        id: ado
        source: ""
        onSourceChanged: {
            lm.setPathofSong(source);
        }
        onPositionChanged: {
            sprogress.value = position;
        }
        onPlaybackStateChanged: {
            switch (playbackState) {
            case Audio.PlayingState:
                btnplay.checked = true;
                anmimgalbum.running = true;
                break;
            case Audio.PausedState:
            case Audio.StoppedState:
                btnplay.checked = false;
                anmimgalbum.running = false;
                break;
            }
        }
        onStatusChanged: {
            switch (status) {
            case Audio.NoMedia:
                console.log("status:nomedia");
                break;
            case Audio.Loading:
                console.log("status:loading");
                break;
            case Audio.Loaded:
                console.log("status:loaded");
                sprogress.maximumValue = duration;
                play();//自动播放
                if (metaData.title) {
                    plm.setCurrentTitle(metaData.title);
                }
                if (metaData.albumArtist) {
                    plm.setCurrentAuthor(metaData.albumArtist);
                }
                break;
            case Audio.Buffering:
                console.log("status:buffering");
                break;
            case Audio.Stalled:
                console.log("status:stalled");
                break;
            case Audio.Buffered:
                console.log("status:buffered");
                break;
            case Audio.InvalidMedia:
                console.log("status:invalid media");
                switch (error) {
                case Audio.FormatError:
                    ttitle.text = qsTr("需要安装解码器");
                    break;
                case Audio.ResourceError:
                    ttitle.text = qsTr("文件错误");
                    break;
                case Audio.NetworkError:
                    ttitle.text = qsTr("网络错误");
                    break;
                case Audio.AccessDenied:
                    ttitle.text = qsTr("权限不足");
                    break;
                case Audio.ServiceMissing:
                    ttitle.text = qsTr("无法启用多媒体服务");
                    break;
                }
                break;
            case Audio.EndOfMedia:
                console.log("status:end of media");
                lm.currentIndex = 0;
                sprogress.value = 0;
                switch (btnloopMode.loopMode) {
                case 1:
                    ado.play();
                    break;
                case 2:
                    plm.currentIndex ++;
                    break;
                case 3:
                    plm.randomIndex();
                    break;
                }
                break;
            }
        }
    }
    PlayListModel {
        id: plm
        onCurrentIndexChanged: {
            ado.source = getcurrentPath();
            playList.currentIndex = currentIndex;
        }
    }
    LyricModel {
        id: lm
        onCurrentIndexChanged: {
            lyric.currentIndex = currentIndex;
        }
    }
    FileDialog {
        id:fmusic
        title: qsTr("选择一个音乐文件")
        selectMultiple: true;
        property Audio target: ado
        nameFilters: [  qsTr("MP3 文件 (*.mp3)"), qsTr("WAV 文件 (*.wav)"), qsTr("WMA 文件 (*.wma)"), qsTr("所有文件 (*)") ]
        onAccepted: {
            plm.add(fmusic.fileUrls);
        }
    }
    Rectangle {
        id: rpanel
        width: 350
        height: 600
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 15
        radius: 10
        RectangularGlow {
            z: -1
            anchors.fill: parent
            color: "black"
            glowRadius: 10
            cornerRadius: parent.radius + glowRadius
        }
        gradient: Gradient {
            GradientStop {position: 0; color: "#f2f1f0"}
            GradientStop {position: 1; color: "#bbbbbb"}
        }
        MessageDialog {
            //TODO
            id: msgabout
            title: qsTr("关于作者")
            text: qsTr("作者：超时空飞狸.\n" +
                      "musicPlayer\n" +
                      "0.1.0\n" +
                      "musicPlayer是一个用来播放音乐的软件\n" +
                      "本程序在GPLv2协议下发布\n" +
                      "Copyright©2014 超时空飞狸\n" +
                      "本程序无任何担保。")
        }
        Button {
            id: btnquit
            width: 15
            height: 15
            anchors.left: parent.left
            anchors.leftMargin: 4
            anchors.top: parent.top
            anchors.topMargin: 4
            onClicked: mainWindow.close();
            style: ButtonStyle {
                background: Rectangle {
                    width: control.width
                    height: control.height
                    radius: width / 2
                    color: control.hovered ? "white" : Qt.rgba(0,0,0,0)
                    border.width: 1
                    border.color: control.hovered ? "#4c4c4c" : "#c0c0c0"
                    Text {
                        anchors.centerIn: parent
                        text: "X"
                        color: "gray"
                        font.pointSize: 7
                    }
                }
            }
        }
        Button {
            id: btnmin
            width: 15
            height: 15
            anchors.left: btnquit.right
            anchors.leftMargin: 4
            anchors.top: parent.top
            anchors.topMargin: 4
            onClicked: mainWindow.showMinimized();
            style: ButtonStyle {
                background: Rectangle {
                    width: control.width
                    height: control.height
                    radius: width / 2
                    color: control.hovered ? "white" : Qt.rgba(0,0,0,0)
                    border.width: 1
                    border.color: control.hovered ? "#4c4c4c" : "#c0c0c0"
                    Text {
                        anchors.centerIn: parent
                        text: "-"
                        color: "gray"
                        font.pointSize: 10
                    }
                }
            }
        }
        Button {
            id: btnabout
            width: 15
            height: 15
            anchors.right: parent.right
            anchors.rightMargin: 4
            anchors.top: parent.top
            anchors.topMargin: 4
            onClicked: msgabout.visible = true;
            style: ButtonStyle {
                background: Rectangle {
                    width: control.width
                    height: control.height
                    radius: width / 2
                    color: control.hovered ? "white" : Qt.rgba(0,0,0,0)
                    border.width: 1
                    border.color: control.hovered ? "#4c4c4c" : "#c0c0c0"
                    Text {
                        anchors.centerIn: parent
                        text: "?"
                        color: "gray"
                        font.pointSize: 10
                    }
                }
            }
        }
        TextInput {
            id: ttitle
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 4
            text: "musicPlayer"
            font.pointSize: 12
            color: "#4c4c4c"
            maximumLength: 30
        }
        Rectangle {
            id: seperator
            implicitWidth: 100
            height: 1
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.top: ttitle.bottom
            anchors.topMargin: 2
            color: "#b0b0b0"
        }
        Button {
            id: btnmenu
            width: 20
            height: 20
            anchors.top: seperator.bottom
            anchors.topMargin: 20
            anchors.right: parent.right
            anchors.rightMargin: 4
            tooltip: qsTr("打开音乐文件")
            onClicked: fmusic.visible = true
            style: ButtonStyle {
                background: Rectangle {
                    width: control.width
                    height: control.height
                    radius: 3
                    color: Qt.rgba(0,0,0,0)
                    Image {
                        id: imgmenu
                        anchors.centerIn: parent
                        source: "qrc:/resource/menu.svg"
                    }
                    DropShadow {
                        visible: control.hovered
                        anchors.fill: imgmenu
                        horizontalOffset: 0
                        verticalOffset: 0
                        radius: 1
                        samples: 2
                        source: imgmenu
                    }
                }
            }
        }
        Button {
            id: btnlrc
            width: 20
            height: 20
            anchors.top: btnmenu.bottom
            anchors.topMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 4
            checkable: true
            onClicked: {
                playList.visible = ! checked;
                lyricMask.visible = checked;
            }
            tooltip: qsTr("显示歌词")
            style: ButtonStyle {
                background: Rectangle {
                    width: control.width
                    height: control.height
                    radius: 3
                    color: Qt.rgba(0,0,0,0)
                    Image {
                        id: imglrc
                        anchors.centerIn: parent
                        source: "qrc:/resource/lrc.svg"
                    }
                    DropShadow {
                        visible: control.checked || control.hovered
                        anchors.fill: imglrc
                        horizontalOffset: 0
                        verticalOffset: 0
                        radius: 1
                        samples: 2
                        source: imglrc
                    }
                }
            }
        }
        Button {
            id: btnloopMode
            width: 20
            height: 20
            anchors.top: btnlrc.bottom
            anchors.topMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 4
            property int loopMode: 0
            onLoopModeChanged: {
                switch (loopMode) {
                case 0:
                    tooltip = qsTr("单曲播放")
                    break;
                case 1:
                    tooltip = qsTr("单曲循环")
                    break;
                case 2:
                    tooltip = qsTr("顺序播放");
                    break;
                case 3:
                    tooltip = qsTr("随机播放");
                    break;
                default:
                    loopMode = 0;
                }
            }
            onClicked: loopMode++
            tooltip: qsTr("单曲播放")
            style: ButtonStyle {
                background: Rectangle {
                    width: control.width
                    height: control.height
                    radius: 3
                    color: Qt.rgba(0,0,0,0)
                    Image {
                        id: imgloopMode
                        anchors.centerIn: parent
                        source: {
                            switch (control.loopMode) {
                            case 1:
                                return "qrc:/resource/loop_one.svg"
                            case 2:
                                return "qrc:/resource/loop_all.svg"
                            case 3:
                                return "qrc:/resource/loop_random.svg"
                            default:
                                return "qrc:/resource/loop_no.svg"
                            }
                        }
                    }
                }
            }
        }
        MouseArea {
            anchors.left: btnmin.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: seperator.bottom
            property point clickPos
            onPressed: {
                clickPos  = Qt.point(mouseX,mouseY)
            }
            onPositionChanged: {
                mainWindow.setX(mainWindow.x+mouseX - clickPos.x);
                mainWindow.setY(mainWindow.y+mouseY - clickPos.y);
            }
        }
        Image {
            id: imgalbum
            width: 240
            height: 240
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: seperator.bottom
            anchors.topMargin: 10
            source: "qrc:/resource/cd.png"
        }
        RotationAnimator {
            id: anmimgalbum
            target: imgalbum
            from: 0
            to: 360
            duration: 10000
            loops: Animation.Infinite
            running: false
            onRunningChanged: {
                if (running === false) {
                    from = imgalbum.rotation;
                    to = from+360;
                }
            }
        }
        Slider {
            id: svolumn
            width: 20
            height: 150
            anchors.top: seperator.bottom
            anchors.topMargin: 20
            anchors.left: parent.left
            tickmarksEnabled: true
            value: 1
            orientation: Qt.Vertical
            onValueChanged: ado.volume = value;
            style: SliderStyle {
                groove: Rectangle {
                    width: control.width
                    height: 1
                    color: "#b0b0b0"
                    Rectangle {
                        width: styleData.handlePosition
                        height: 1
                        color: "#4c4c4c"
                    }
                }
                handle: Image {
                    source: "qrc:/resource/handle.png"
                }
                tickmarks: Repeater {
                    model: 11
                    Rectangle {
                        x: control.height / 10 * index
                        y: 3
                        width: 1
                        height: 3
                        color: "#4c4c4c"
                    }
                }
            }
        }
        ListView {
            id: playList
            width: parent.width
            height: 210
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: imgalbum.bottom
            anchors.topMargin: 10
            clip: true
            highlight: Rectangle {
                //TODO
                color: Qt.rgba(255,0,0,0)
            }
            model: plm
            delegate: Rectangle {
                width: parent.width
                height: 20
                color: Qt.rgba(0,0,0,0)
                Text {
                    width: 170
                    anchors.left: parent.left
                    anchors.leftMargin: 45
                    text: title
                    elide: Text.ElideRight
                    color: "#4c4c4c"
                    font.pointSize: 10
                    font.bold: parent.ListView.isCurrentItem
                }
                Text {
                    width: 80
                    anchors.right: parent.right
                    anchors.rightMargin: 45
                    text: author
                    elide: Text.ElideRight
                    color: "#4c4c4c"
                    font.pointSize: 10
                    font.bold: parent.ListView.isCurrentItem
                }
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: {
                        if (mouse.button === Qt.RightButton) {
                            plm.remove(index, index);
                        }
                    }
                    onDoubleClicked: {
                        plm.currentIndex = index;
                    }
                }
            }
        }
        ListView {
            id: lyric
            visible: false
            width: parent.width
            height: 210
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: imgalbum.bottom
            anchors.topMargin: 10
            clip: true
            spacing: 3
            highlightRangeMode: ListView.StrictlyEnforceRange
            preferredHighlightBegin: 8
            preferredHighlightEnd: 30
            highlight: Rectangle {
                color: Qt.rgba(0,0,0,0)
                Behavior on y {
                    SmoothedAnimation {
                        duration: 300
                    }
                }
            }
            model: lm
            delegate: Rectangle {
                width: parent.width
                height: 15
                color: Qt.rgba(0,0,0,0)
                Text {
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    text: textLine
                    color: "#4c4c4c"
                    font.pointSize: 10
                    font.bold: parent.ListView.isCurrentItem
                }
            }
        }
        Image {
            id: imglyricMask
            visible: false
            anchors.top: imgalbum.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            source: "qrc:/resource/lyricmask.png"
        }
        OpacityMask {
            id: lyricMask
            visible: false
            anchors.fill: lyric
            source: lyric
            maskSource: imglyricMask
        }
        Slider {
            id: sprogress
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.top: imgalbum.bottom
            anchors.topMargin: lyric.height + 10
            updateValueWhileDragging: false
            stepSize: 10
            property bool handled: false
            onPressedChanged: {
                handled = true;
            }
            onValueChanged: {
                if (handled && ado.seekable) {
                    lm.findIndex(value);
                    ado.seek(value);
                    ado.play();
                    handled = false;
                } else {
                    lm.getIndex(value);
                }
            }
            style: SliderStyle {
                groove: Rectangle {
                    width: control.width
                    height: 1
                    color: "#909090"
                    Rectangle {
                        width: styleData.handlePosition
                        height: 1
                        color: "#e82828"
                    }
                }
                handle: Image {
                    source: "qrc:/resource/handle.png"
                }
            }
        }
        Button {
            id: btnplay
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: sprogress.bottom
            anchors.topMargin: 10
            checkable: true
            onClicked: {
                if (ado.hasAudio) {
                    (ado.playbackState === Audio.PlayingState) ? ado.pause() : ado.play();
                }
            }
            style: ButtonStyle {
                background: Image {
                    id: imgplay
                    source: control.checked ? "qrc:/resource/pause.svg" : "qrc:/resource/play.svg"
                    DropShadow {
                        visible: control.hovered
                        anchors.fill: parent
                        horizontalOffset: 0
                        verticalOffset: 0
                        radius: 8
                        samples: 16
                        source: parent
                    }
                }
            }
        }
        Button {
            id: btnbackward
            anchors.verticalCenter: btnplay.verticalCenter
            anchors.right: btnplay.left
            anchors.rightMargin: 50
            onClicked: {
                switch (btnloopMode.loopMode) {
                    case 0:
                        //单曲播放
                    case 1:
                        //单曲循环
                    case 2:
                        //顺序播放
                        plm.currentIndex --
                        break;
                    case 3:
                        //随机播放
                        plm.randomIndex();
                        break;
                }
            }
            style: ButtonStyle {
                background: Image {
                    id: imgbackward
                    source: "qrc:/resource/backward.svg"
                    DropShadow {
                        visible: control.hovered
                        anchors.fill: parent
                        horizontalOffset: 0
                        verticalOffset: 0
                        radius: 6
                        samples: 12
                        source: parent
                    }
                }
            }
        }
        Button {
            id: btnforward
            anchors.verticalCenter: btnplay.verticalCenter
            anchors.left: btnplay.right
            anchors.leftMargin: 50
            onClicked: {
                switch (btnloopMode.loopMode) {
                    case 0:
                        //单曲播放
                    case 1:
                        //单曲循环
                    case 2:
                        //顺序播放
                        plm.currentIndex ++
                        break;
                    case 3:
                        //随机播放
                        plm.randomIndex();
                        break;
                }
            }
            style: ButtonStyle {
                background: Image {
                    id: imgforward
                    source: "qrc:/resource/forward.svg"
                    DropShadow {
                        visible: control.hovered
                        anchors.fill: parent
                        horizontalOffset: 0
                        verticalOffset: 0
                        radius: 6
                        samples: 12
                        source: parent
                    }
                }
            }
        }
    }
}

