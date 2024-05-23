#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "weighttracker.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    WeightTracker weightTracker;

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.rootContext()->setContextProperty("weightTracker", &weightTracker);
    engine.loadFromModule("untitled1", "Main");

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
