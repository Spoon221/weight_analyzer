#ifndef WEIGHTTRACKER_H
#define WEIGHTTRACKER_H

#include <QObject>

class WeightTrackerWrapper : public QObject
{
    Q_OBJECT
    Q_PROPERTY(float previousWeight READ previousWeight NOTIFY previousWeightChanged)

public:
    explicit WeightTrackerWrapper(QObject *parent = nullptr);

    float previousWeight() const;

signals:
    void previousWeightChanged();

public slots:
    void addWeight(float weight);
};

#endif // WEIGHTTRACKER_H
