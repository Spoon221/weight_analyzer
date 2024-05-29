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
                    showStatistics.visible = true
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
                                        weight: "Вес"
                                    }
                                }
                    }

                    Text {
                        id: weightChangeText
                        text: ""
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        weightTracker.loadWeightsFromStorage()
        weightTracker.updateWeightChange()
    }

    QtObject {
        id: weightTracker

        property var weights: []
        property string weightChange: ""

        function addWeight(weight) {
                    if (weight > 0) {
                        var date = new Date();
                        var formattedDate = date.toLocaleDateString();
                        weights.push({ date: formattedDate, weight: weight });
                        weightModel.append({ date: formattedDate, weight: weight });
                        saveWeightsToStorage();
                        updateWeightChange();
                    }
                }

        function loadWeightsFromStorage() {
                    var storedWeights = Qt.LocalStorage.getItem('weights');
                    if (storedWeights) {
                        weights = JSON.parse(storedWeights);
                        for (var i = 0; i < weights.length; i++) {
                            weightModel.append(weights[i]);
                        }
                    }
                }

        function saveWeightsToStorage() {
                    Qt.LocalStorage.setItem('weights', JSON.stringify(weights));
                }

        function updateWeightChange() {
            if (weights.length > 1) {
                var lastWeight = weights[weights.length - 1].weight;
                var previousWeight = weights[weights.length - 2].weight;

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
