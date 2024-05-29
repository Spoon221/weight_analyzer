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
                        text: weightTracker.weightChange // Связываем текст с weightTracker.weightChange
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
                updateWeightChange(); // Обновляем weightChange после добавления веса
            }
        }

        function updateWeightChange() {
            if (weights.length > 2) {
                var lastWeight = weights[weights.length - 1].currentWeight;
                var previousWeight = weights[weights.length - 2].currentWeight;
                var secondLastWeight = weights[weights.length - 3].currentWeight;

                if (lastWeight > previousWeight) {
                    if (previousWeight > secondLastWeight) {
                        weightChange = "Вес увеличился";
                    } else {
                        weightChange = "Вес увеличился, но темпы роста снизились";
                    }
                } else if (lastWeight < previousWeight) {
                    if (previousWeight < secondLastWeight) {
                        weightChange = "Вес уменьшился";
                    } else {
                        weightChange = "Вес уменьшился, но темпы снижения замедлились";
                    }
                } else {
                    weightChange = "Вес не изменился";
                }
            }
        }
    }
}
