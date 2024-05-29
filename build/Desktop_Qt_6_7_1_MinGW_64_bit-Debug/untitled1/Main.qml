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
                    onTextChanged: {
                        weightTracker.addWeight(parseFloat(pastWeightInput.text), 0);
                    }
                }
            }

            Row {
                Text {
                    text: "Введите свой нынешний вес:"
                }
                TextField {
                    id: currentWeightInput
                    placeholderText: "Вес (кг)"
                    onTextChanged: {
                        weightTracker.addWeight(0, parseFloat(currentWeightInput.text));
                    }
                }
            }

            Button {
                text: "Показать статистику"
                onPressed: {
                    showStatistics.visible = true;
                    weightTable.forceActiveFocus();
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
                                color: "black"
                            }
                        }
                    }

                    Text {
                        id: weightChangeText
                        text: weightTracker.weightChange
                        color: weightTracker.weightChangeColor
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
        property color weightChangeColor: "black"

        function addWeight(pastWeight, currentWeight) {
            if (pastWeight > 0 || currentWeight > 0) {
                weights.push({
                    pastWeight: pastWeight,
                    currentWeight: currentWeight,
                    weightChange: (currentWeight - pastWeight).toFixed(2)
                });

                updateWeightChange();

                // Добавляем данные в модель, устанавливая цвет
                weightModel.append({
                    pastWeight: pastWeight,
                    currentWeight: currentWeight,
                    weightChange: (currentWeight - pastWeight).toFixed(2),
                    color: (currentWeight > pastWeight) ? "red" : ((currentWeight < pastWeight) ? "green" : "black")
                });
            }
        }

        function updateWeightChange() {
            if (weights.length > 1) {
                var lastWeight = weights[weights.length - 1].currentWeight;
                var previousWeight = weights[weights.length - 2].currentWeight;

                if (lastWeight === previousWeight) {
                    weightChange = "Вес не изменился";
                    weightChangeColor = "black";
                } else if (lastWeight > previousWeight) {
                    weightChange = "Вес увеличился";
                    weightChangeColor = "red";
                } else if (lastWeight < previousWeight) {
                    weightChange = "Вес уменьшился";
                    weightChangeColor = "green";
                }
            }
        }
    }
}
