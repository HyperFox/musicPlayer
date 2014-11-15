#include "playlistmodel.h"

song::song(QUrl path, QString title, QString author) {
    m_author = author;
    m_path = path;
    m_title = title;
}

QString song::getauthor() const {
    return m_author;
}

QUrl song::getpath() const {
    return m_path;
}

QString song::gettitle() const {
    return m_title;
}

playListModel::playListModel(QObject *parent) : QAbstractListModel(parent) {
    m_currentIndex = -1;
}

int playListModel::currentIndex() const {
    return m_currentIndex;
}

int playListModel::rowCount(const QModelIndex & parent) const {
    Q_UNUSED(parent);
    return playListData.count();
}

QVariant playListModel::data(const QModelIndex & index, int role) const {
    if (index.row() < 0 || index.row() >= playListData.count())
            return QVariant();
    const song &s = playListData.at(index.row());
    switch (role) {
    case pathRole:
        return s.getpath();
    case authorRole:
        return s.getauthor();
    case titleRole:
        return s.gettitle();
    default:
        return QVariant();
    }
}

int playListModel::randomIndex() {
    int tmp;
    srand(time(NULL));
    do {
        tmp = qrand() % playListData.count();
    } while (tmp == m_currentIndex);
    setCurrentIndex(tmp);
    return tmp;
}

QString playListModel::getcurrentTitle() const {
    return playListData.at(m_currentIndex).gettitle();
}

QUrl playListModel::getcurrentPath() const {
    return playListData.at(m_currentIndex).getpath();
}

void playListModel::add(QList<QUrl> paths) {
    //不检查重名
    int count, index;
    QAudioDecoder ad;
    QAudioDeviceInfo adi(QAudioDeviceInfo::defaultOutputDevice());
    QString author, title;
    count = paths.count();
    for (index = 0; index < count; index ++) {
        ad.setSourceFilename(paths.at(index).toLocalFile());
        //why the func below always return false
        /*if (! adi.isFormatSupported(ad.audioFormat())) {
            qDebug() << "format not support";
            continue;
        }*/
        //these func cant get meta data,this must be async.
        if (ad.metaData("Title").isNull()) {
            title = paths.at(index).fileName(QUrl::FullyDecoded);
        } else {
            title = ad.metaData("Title").toString();
        }
        if (ad.metaData("Author").isNull()) {
            author = tr("匿名");
        } else {
            author = ad.metaData("Author").toStringList().first();
        }
        addSong(paths.at(index), title, author);
    }
    if (m_currentIndex < 0 && playListData.count()) {
        setCurrentIndex(0);
    }
}

void playListModel::move(int from, int to) {
    beginMoveRows(QModelIndex(), from, from, QModelIndex(), to);
    playListData.move(from, to);
    endMoveRows();
}

void playListModel::remove(int first, int last) {
    if ((first < 0) && (first >= playListData.count()))
        return;
    if ((last < 0) && (last >= playListData.count()))
        return;
    if (first > last) {
        first ^= last;
        last ^= first;
        first ^= last;
    }
    beginRemoveRows(QModelIndex(), first, last);
    while (first <= last) {
        playListData.removeAt(first);
        last --;
    }
    endRemoveRows();
    if (m_currentIndex >= playListData.count()) {
        setCurrentIndex(playListData.count() - 1);
    }
}

void setCurrentTitle(QString title) {
    ;
}

void setCurrentAuthor(QString author) {
    ;
}

void playListModel::setCurrentIndex(const int & i) {
    if (i >= playListData.count() && m_currentIndex != 0) {
        m_currentIndex = 0;
        emit currentIndexChanged();
    } else if ((i >= 0) && (i < playListData.count()) && (m_currentIndex != i)) {
        m_currentIndex = i;
        emit currentIndexChanged();
    }
}

QHash<int, QByteArray> playListModel::roleNames() const {
    QHash<int, QByteArray> role;
    role[authorRole] = "author";
    role[pathRole] = "path";
    role[titleRole] = "title";
    return role;
}

void playListModel::addSong(QUrl path, QString title, QString author) {
    beginInsertRows(QModelIndex(), playListData.count(), playListData.count());
    playListData.append(song(path, title, author));
    endInsertRows();
}
