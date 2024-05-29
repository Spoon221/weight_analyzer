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


            // Ввод прошлого веса
            Row {
                Text {
                    text: "Введите свой прошлый вес:"
                }
                TextField {
                    horizontalAlignment: Alignment.left
                    id: pastWeightInput
                    placeholderText: "Вес (кг)"
                    onTextChanged: {
                        weightTracker.pastWeight = parseFloat(pastWeightInput.text);
                        weightTracker.updateWeightChange();
                    }
                }
            }

            // Ввод текущего веса
            Row {
                Text {
                    text: "Введите свой нынешний вес:"
                }
                TextField {
                    id: currentWeightInput
                    placeholderText: "Вес (кг)"
                    onTextChanged: {
                        weightTracker.currentWeight = parseFloat(currentWeightInput.text);
                        weightTracker.updateWeightChange();
                    }
                }
            }

            // Кнопка для показа/скрытия статистики
            Button {
                id: showStatisticsButton // Добавили идентификатор
                text: "Показать статистику"
                onPressed: {
                    showStatistics.visible = !showStatistics.visible; // Переключение видимости
                    if (showStatistics.visible) {
                        weightTable.forceActiveFocus(); // Фокус на таблицу, если статистика видна
                    }
                }
            }

            // Блок с отображением статистики
            Rectangle {
                id: showStatistics
                visible: false // Скрыто по умолчанию
                width: parent.width
                height: 200
                color: "lightblue"


                Column {
                    spacing: 10
                    anchors.centerIn: parent // Выравниваем все элементы по центру

                    Text {
                        text: "Статистика:"
                        font.pointSize: 18 // Увеличиваем размер шрифта
                        font.bold: true // Делаем шрифт жирным
                        horizontalAlignment: Text.AlignHCenter // Выравниваем по центру
                    }

                    // Таблица с данными о весе
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
                        anchors.horizontalCenter: parent // Выравниваем по центру
                    }

                    // Текст, отображающий изменение веса
                    Text {
                        id: weightChangeText
                        text: weightTracker.weightChange
                        color: weightTracker.weightChangeColor
                        // Выравниваем по центру
                        horizontalAlignment: Text.AlignHCenter
                        // Увеличиваем размер шрифта
                        font.pointSize: 14
                        // Добавляем отступ сверху
                        anchors.topMargin: 10
                    }
                }
            }
        }
    }

    // Объект для отслеживания и обработки данных о весе
    QtObject {
        id: weightTracker
        property var weights: []
        property string weightChange: ""
        property color weightChangeColor: "black"
        property real pastWeight: 0
        property real currentWeight: 0

        // Функция для добавления данных о весе в массив
        function addWeight() {
            if (pastWeight > 0 && currentWeight > 0) {
                weights.push({
                                 pastWeight: pastWeight,
                                 currentWeight: currentWeight,
                                 weightChange: (currentWeight - pastWeight).toFixed(2)
                             });

                // Добавляем данные в модель, устанавливая цвет
                weightModel.append({
                                       pastWeight: pastWeight,
                                       currentWeight: currentWeight,
                                       weightChange: (currentWeight - pastWeight).toFixed(2),
                                       color: (currentWeight > pastWeight) ? "red" : ((currentWeight < pastWeight) ? "green" : "black")
                                   });
            }
        }

        // Функция для обновления текста и цвета изменения веса
        function updateWeightChange() {
            if (pastWeight > 0 && currentWeight > 0) {
                if (pastWeight === currentWeight) {
                    weightChange = "Вес не изменился";
                    weightChangeColor = "black";
                } else if (currentWeight > pastWeight) {
                    weightChange = "Вес увеличился";
                    weightChangeColor = "red";
                } else if (currentWeight < pastWeight) {
                    weightChange = "Вес уменьшился";
                    weightChangeColor = "green";
                }
            } else {
                weightChange = "";
                weightChangeColor = "black";
            }
        }
    }
}
