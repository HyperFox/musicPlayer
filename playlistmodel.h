#ifndef PLAYLISTMODEL_H
#define PLAYLISTMODEL_H

#include <QAbstractListModel>
#include <QAudioDecoder>
#include <QAudioDeviceInfo>
#include <QDebug>
#include <QUrl>

class song {
public:
    explicit song(QUrl path, QString title, QString author);
    QString getauthor() const;
    QString gettitle() const;
    QUrl getpath() const;
    void setauthor(QString author);
    void settitle(QString title);

private:
    QString m_author, m_title;
    QUrl m_path;
};

class playListModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit playListModel(QObject *parent = 0);
    int currentIndex() const;
    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
    Q_INVOKABLE int randomIndex();
    Q_INVOKABLE QString getcurrentTitle() const;
    Q_INVOKABLE QUrl getcurrentPath() const;
    Q_INVOKABLE void add(QList<QUrl> paths);
    Q_INVOKABLE void move(int from, int to);
    Q_INVOKABLE void remove(int first, int last);
    Q_INVOKABLE void setCurrentTitle(QString title);
    Q_INVOKABLE void setCurrentAuthor(QString author);
    Q_PROPERTY(int currentIndex READ currentIndex WRITE setCurrentIndex NOTIFY currentIndexChanged)
    void setCurrentIndex(const int & i);

    enum songRole {
        pathRole = Qt::UserRole + 1,
        titleRole,
        authorRole,
    };

signals:
    void currentIndexChanged();

public slots:

private:
    QHash<int, QByteArray> roleNames() const;
    void addSong(QUrl path, QString title, QString author);

    int m_currentIndex;
    QList<song> playListData;

};

#endif // PLAYLISTMODEL_H
