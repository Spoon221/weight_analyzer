#ifndef WEIGHTTRACKER_H
#define WEIGHTTRACKER_H

#include <QObject>

class WeightTracker : public QObject
{
    Q_OBJECT
public:
    explicit WeightTracker(QObject *parent = nullptr);

public slots:
    void addWeight(float weight);

signals:
    void weightChanged(float newWeight);

private:
    float m_previousWeight;
};

#endif // WEIGHTTRACKER_H
