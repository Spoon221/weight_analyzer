#include "weighttracker.h"
#include <QDebug>

WeightTracker::WeightTracker(QObject *parent) : QObject(parent)
{
    // Initialize any necessary variables or settings here
}

void WeightTracker::addWeight(float weight)
{
    // Add your weight tracking logic here
    // Compare current weight with previous weight to determine if it has increased or decreased
    // Based on the comparison, you can emit a signal to trigger a notification
    if (weight > 0) {
        qDebug() << "New weight added: " << weight;
    }
}
