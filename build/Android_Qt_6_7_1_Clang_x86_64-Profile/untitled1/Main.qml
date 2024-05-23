import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 400
    height: 400
    title: "Анализатор веса"

    Rectangle {
        width: parent.width
        height: parent.height

        Column {
            spacing: 10
            anchors.centerIn: parent

            Text {
                text: "Введите свой вес:"
            }

            TextField {
                id: weightInput
                placeholderText: "Вес (кг)"
            }

            Button {
                text: "Подтвердить"
                onClicked: {
                    weightTracker.addWeight(parseFloat(weightInput.text))
                    weightInput.text = ""
                }
            }

            Button {
                text: "Показать статистику"
                onClicked: {
                    stackView.push("statistics.qml")
                }
            }
        }
    }

    StackView {
        id: stackView
        initialItem: Item { }
    }
}
