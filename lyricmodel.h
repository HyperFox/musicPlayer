#ifndef LYRICMODEL_H
#define LYRICMODEL_H

#include <QAbstractListModel>
#include <QDebug>
#include <QFile>
#include <QFileInfo>
#include <QTextStream>

class lyricLine {
public:
    explicit lyricLine(int m,QString t);
    explicit lyricLine();
    int getmilliseconds() const;
    QString gettext() const;

private:
    int milliseconds;
    QString text;
};

class lyricModel : public QAbstractListModel {
    Q_OBJECT
public:
    //不是所有函数都用到了，有些函数估计要用可实际上发现没有用到，暂时保留着吧
    explicit lyricModel(QObject *parent = 0);
    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
    Q_INVOKABLE bool setPathofSong(QString path);
    Q_INVOKABLE int getIndex(int position);
    Q_INVOKABLE int findIndex(int position);
    Q_PROPERTY(int currentIndex READ currentIndex WRITE setcurrentIndex NOTIFY currentIndexChanged)
    int currentIndex() const;
    void setcurrentIndex(const int & i);
    void addSingleLine(lyricLine l);
    void removeTopLine();

    enum lyricRoles {
        timeRole = Qt::UserRole + 1,
        textRole,
    };

signals:
    void currentIndexChanged();

public slots:

private:
    void clearData();

    QHash<int, QByteArray> roleNames() const;
    QList<lyricLine> lyricData;
    int m_currentIndex;
};

#endif // LYRICMODEL_H
