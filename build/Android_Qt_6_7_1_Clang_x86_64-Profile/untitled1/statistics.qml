import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 400
    height: 400
    title: "Статистика"

    Rectangle {
        width: parent.width
        height: parent.height

        Column {
            spacing: 10
            anchors.centerIn: parent

            Text {
                id: weightText
                text: "Статистика веса: "
            }

            Button {
                text: "Обратно"
                onClicked: {
                    stackView.push("Main.qml")
                }
            }
        }
    }

    StackView {
        id: stackView
        initialItem: Item {}
    }

    WeightTracker {
        id: weightTracker

        onPreviousWeightChanged: {
            weightText.text = "Статистика веса: " + previousWeight
        }
    }
}
