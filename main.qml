/*
  * 本程序使用GPLv2协议发布
  */
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
            lyricModel.setPathofSong(source);
            sprogress.value = 0;
        }
        onPositionChanged: {
            sprogress.value = position;
            if (lyric.handled) {
                lyric.currentIndex = lyricModel.findIndex(position);
                lyric.handled = false;
            } else {
                lyric.currentIndex = lyricModel.getIndex(position);
            }
            //lyric.positionViewAtIndex(lyric.currentIndex, ListView.Center);
        }
        onPlaybackStateChanged: {
            switch (playbackState) {
            case Audio.PlayingState:
                btnplay.checked = true;
                break;
            }
        }
        onStatusChanged: {
            btnplay.checked = false;
            switch (status) {
            case Audio.Loaded:
                btnplay.checkable = true;
                if (metaData.title) {
                    ttitle.text = metaData.title;
                } else {
                    ttitle.text = "musicPlayer";//TODO
                }
                sprogress.maximumValue = duration;
                play();//自动播放
                break;
            case Audio.InvalidMedia:
                btnplay.checkable = false;
                switch (error) {
                case Audio.NoError:
                    break;
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
                sprogress.value = 0;
                break;
            }
        }
    }
    FileDialog {
        id:fmusic
        title: qsTr("选择一个音乐文件")
        property Audio target: ado
        nameFilters: [  "MP3 files (*.mp3)", "Wave files (*.wav)","All files (*)" ]
        onAccepted: {
            target.source = "";
            target.source = fmusic.fileUrl;
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
            onClicked: lyric.visible = checked
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
        MouseArea {
            anchors.left: btnmin.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: seperator.bottom
            property point clickPos
            property point delta
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
            onRunningChanged: if (running==false) {from=imgalbum.rotation,to=from+360}
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
            //TODO
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
            property bool handled: true
            highlight: Rectangle {
                color: Qt.rgba(0,0,0,0)
                Behavior on y {
                    SpringAnimation {
                        spring: 3
                        damping: 0.2
                    }
                }
            }
            model: lyricModel
            delegate: Rectangle {
                width: parent.width
                height: 15
                color: Qt.rgba(0,0,0,0)
                Text {
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    text: "" + textLine
                    color: "#4c4c4c"
                    font.pointSize: 10
                }
            }
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
                lyric.handled = true;//有人拖动进度条,通知lyric重新定位歌词
            }
            onValueChanged: {
                if (handled && ado.seekable) {
                    ado.seek(value);
                    ado.play();
                    handled = false;
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
            onCheckedChanged: {
               checked ? (anmimgalbum.running = true,ado.play()) : (anmimgalbum.running = false,ado.pause())
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

