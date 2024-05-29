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

            Rectangle {
                id: showStatistics
                visible: false
                width: parent.width
                height: 200
                color: "lightgray"

                Column {
                    spacing: 10

                    Text {
                        text: "Статистика:"
                    }

                    TableView {
                        id: weightTable
                        model: ListModel {
                            id: weightModel
                            ListElement {
                                pastWeight: 0
                                currentWeight: 0
                                weightChange: "Изменение веса"
                            }
                        }
                    }

                    Text {
                        id: weightChangeText
                        text: weightTracker.weightChange
                        visible: weightModel.count > 1
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
                weightChangeText.text = weightChange;
            }
        }

        function updateWeightChange() {
            if (weights.length > 1) {
                var lastWeight = weights[weights.length - 1].currentWeight;
                var previousWeight = weights[weights.length - 2].currentWeight;

                if (lastWeight > previousWeight) {
                    weightChange = "Вес увеличился";
                } else if (lastWeight < previousWeight) {
                    weightChange = "Вес уменьшился";
                } else if (Math.abs(lastWeight - previousWeight) < 0.0001) { // Сравнение с погрешностью
                    weightChange = "Вес не изменился";
                }
            }
        }
    }
}
