#include <QObject>
#include <QDate>
#include <QList>
#include <QString>

class WeightTracker : public QObject
{
    Q_OBJECT

public:
    explicit WeightTracker(QObject *parent = nullptr) : QObject(parent) {}

    QList<QVariantMap> weights;

    void addWeight(double pastWeight, double currentWeight)
    {
        if (pastWeight > 0 && currentWeight > 0) {
            QDate date = QDate::currentDate();
            QString formattedDate = date.toString("dd.MM.yyyy");

            QVariantMap weightData;
            weightData["date"] = formattedDate;
            weightData["pastWeight"] = pastWeight;
            weightData["currentWeight"] = currentWeight;
            weightData["weightChange"] = QString::number(currentWeight - pastWeight, 'f', 2);

            weights.append(weightData);
            emit weightsChanged();
        }
    }

    QString weightChange() const
    {
        if (weights.size() > 1) {
            double lastWeight = weights.last()["currentWeight"].toDouble();
            double previousWeight = weights.at(weights.size() - 2)["currentWeight"].toDouble();

            if (lastWeight > previousWeight) {
                return "Вес увеличился";
            } else if (lastWeight < previousWeight) {
                return "Вес уменьшился";
            } else {
                return "Вес не изменился";
            }
        }
        return "";
    }

signals:
    void weightsChanged();

};
