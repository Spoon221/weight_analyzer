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

        // Используем anchors для Column, а не для элементов внутри него
        Column {
            spacing: 10
            anchors.centerIn: parent

            Row {
                Text {
                    text: "Введите свой прошлый вес:"
                }
                TextField {
                    id: pastWeightInput
                    placeholderText: "Вес (кг)"
                }
            }

            Row {
                Text {
                    text: "Введите свой нынешний вес:"
                }
                TextField {
                    id: currentWeightInput
                    placeholderText: "Вес (кг)"
                }
            }

            Button {
                text: "Показать статистику"
                onClicked: {
                    var pastWeight = parseFloat(pastWeightInput.text);
                    var currentWeight = parseFloat(currentWeightInput.text);
                    if (!isNaN(pastWeight) && !isNaN(currentWeight)) {
                        weightTracker.addWeight(pastWeight, currentWeight);
                        showStatistics.visible = true;
                        pastWeightInput.text = "";
                        currentWeightInput.text = "";
                    } else {
                        // Обработка ошибки - ввести число
                    }
                }
            }

            // Внутренний Rectangle для статистики
            Rectangle {
                id: showStatistics
                visible: false
                width: parent.width
                height: 200
                color: "lightgray"

                // Используем anchors для Column, а не для элементов внутри него
                Column {
                    spacing: 10
                    anchors.centerIn: parent

                    Text {
                        text: "Статистика:"
                    }

                    TableView {
                        id: weightTable
                        anchors.fill: parent
                        model: ListModel {
                            id: weightModel
                            ListElement {
                                date: "Дата"
                                pastWeight: 0
                                currentWeight: 0
                                weightChange: "Изменение веса"
                            }
                        }
                    }

                    Text {
                        id: weightChangeText
                        text: ""
                        visible: weightModel.count > 1  // Показываем текст только если есть более одной записи
                    }
                }
            }
        }
    }

    QtObject {
        id: weightTracker

        property var weights: []
        property string weightChange: ""

        function addWeight(pastWeight, currentWeight) {
            if (pastWeight > 0 && currentWeight > 0) {
                var date = new Date();
                var formattedDate = date.toLocaleDateString();
                weights.push({ date: formattedDate, pastWeight: pastWeight, currentWeight: currentWeight, weightChange: (currentWeight - pastWeight).toFixed(2) });
                weightModel.append({ date: formattedDate, pastWeight: pastWeight, currentWeight: currentWeight, weightChange: (currentWeight - pastWeight).toFixed(2) });
                updateWeightChange();
            }
        }

        function updateWeightChange() {
            if (weights.length > 1) {
                var lastWeight = weights[weights.length - 1].currentWeight;
                var previousWeight = weights[weights.length - 2].currentWeight;

                if (lastWeight > previousWeight) {
                    weightChangeText.text = "Вес увеличился";
                } else if (lastWeight < previousWeight) {
                    weightChangeText.text = "Вес уменьшился";
                } else {
                    weightChangeText.text = "Вес не изменился";
                }
            }
        }
    }
}
