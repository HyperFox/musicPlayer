/*
  * 本程序使用GPLv2协议发布
  */
#include "lyricmodel.h"
#include "playlistmodel.h"

#include <QApplication>
#include <QQuickView>
#include <QQmlContext>
#include <QtQml>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    qmlRegisterType<lyricModel>("dataModel", 1, 0, "LyricModel");
    qmlRegisterType<playListModel>("dataModel", 1, 0, "PlayListModel");

    QQuickView view(QUrl(QStringLiteral("qrc:/main.qml")));
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.setFlags(Qt::FramelessWindowHint);
    view.setDefaultAlphaBuffer(true);
    view.setColor(QColor(Qt::transparent));
    view.rootContext() -> setContextProperty("mainWindow", &view);
    view.show();

    return app.exec();
}
