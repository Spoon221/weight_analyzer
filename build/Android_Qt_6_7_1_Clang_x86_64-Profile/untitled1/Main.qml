import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    width: 300
    height: 200
    color: "lightgray"

    Column {
        spacing: 10
        anchors.centerIn: parent

        Text {
            text: "Вчерашний вес:"
        }

        TextField {
            id: yesterdayWeight
            placeholderText: "Введите вес"
            inputMethodHints: Qt.ImhDigitsOnly
        }

        Text {
            text: "Сегодняшний вес:"
        }

        TextField {
            id: todayWeight
            placeholderText: "Введите вес"
            inputMethodHints: Qt.ImhDigitsOnly
        }

        Text {
            id: weightChangeText
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
        }
    }

    Connections {
        target: yesterdayWeight
        onTextChanged: {
            updateWeightChange();
        }
    }

    Connections {
        target: todayWeight
        onTextChanged: {
            updateWeightChange();
        }
    }

    function updateWeightChange() {
        var yesterday = yesterdayWeight.text.trim();
        var today = todayWeight.text.trim();

        if (yesterday === "" || today === "") {
            weightChangeText.text = "";
            return;
        }

        var yesterdayFloat = parseFloat(yesterday);
        var todayFloat = parseFloat(today);

        if (todayFloat > yesterdayFloat) {
            weightChangeText.text = "Вес повысился";
        } else if (todayFloat < yesterdayFloat) {
            weightChangeText.text = "Вес понизился";
        } else {
            weightChangeText.text = "Вес остался прежним";
        }
    }
}
