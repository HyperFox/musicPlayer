/*
  * 本程序使用GPLv2协议发布
  */
#include "lyricmodel.h"

#include <QApplication>
#include <QQuickView>
#include <QQmlContext>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    lyricModel lm;

    QQuickView view(QUrl(QStringLiteral("qrc:/main.qml")));
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.setFlags(Qt::FramelessWindowHint);
    view.setDefaultAlphaBuffer(true);
    view.setColor(QColor(Qt::transparent));
    view.rootContext() -> setContextProperty("lyricModel", &lm);
    view.rootContext() -> setContextProperty("mainWindow", &view);
    view.show();

    return app.exec();
}
