// Copyright (C) 2016 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

import QtQuick
import QtCharts
import QtQml.Models
import QtQuick.Controls 2.1
import QtQuick.Layouts

Item {
    width: 800
    height: 600
    property int currentIndex: -1

    ColumnLayout {
        id: buttonsBar
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 10

        Button {
            id: startButton
            text: "Start Roasting!"
            onClicked: {

                startButton.enabled = false;
                startButton.text= "Please wait...";

                timer.stop();
                currentIndex = -1;
                chartView.removeAllSeries();

                for (var n = 0; n < speedsList.count; n++)  {
                    var lineSeries = chartView.series(speedsList.get(n).driver);
                    if(speedsList.get(n).driver === "Profile"){
                    if (!lineSeries) {
                        lineSeries = chartView.createSeries(ChartView.SeriesTypeSpline,
                                                            speedsList.get(n).driver);
                        chartView.axisY().min = 0;
                        chartView.axisY().max = 420;
                        chartView.axisY().tickCount = 6;
                        chartView.axisY().titleText = "temperature (ºC)";
                        chartView.axisX().titleText = "time (min)";
                        chartView.axisX().labelFormat = "%.0f";
                        chartView.axisX().min = 0;
                        chartView.axisX().max = 21;
                        chartView.axisX().tickCount = 21;
                    }
                    lineSeries.append(speedsList.get(n).speedTrap,
                                      speedsList.get(n).speed);

                    }
                }

                timer.start();
            }
        }

        Button {
            id: exitButton
            text: "Exit"
            onClicked: {
                Qt.quit();
            }
        }
    }
    //![1]
    ChartView {
        id: chartView
        title: "Roasting profile"
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        //anchors.left: controlPanel.right
        height: parent.height
        width: parent.width - buttonsBar.width - 10

        legend.alignment: Qt.AlignTop
        animationOptions: ChartView.SeriesAnimations
        antialiasing: true

    }

    //![1]

    //![2]
    // An example ListModel containing F1 legend drivers' speeds at speed traps
    SpeedsList {
        id: speedsList
        Component.onCompleted: {




            //timer.start();
        }
    }
    //![2]

    //![3]
    // A timer to mimic refreshing the data dynamically
    Timer {
        id: timer
        interval: 250
        repeat: true
        triggeredOnStart: true
        running: false
        onTriggered: {
            currentIndex++;
            if (currentIndex < speedsList.count) {
                // Check if there is a series for the data already
                // (we are using driver name to identify series)
                var lineSeries = chartView.series(speedsList.get(currentIndex).driver);
                var lineSeries2 = chartView.series("Gas BTU");
                if(speedsList.get(currentIndex).driver === "Measured temp"){
                    if (!lineSeries) {
                        lineSeries = chartView.createSeries(ChartView.SeriesTypeSpline,
                                                            speedsList.get(currentIndex).driver);
                        lineSeries2 = chartView.createSeries(ChartView.SeriesTypeLine,
                                                            "Gas BTU");
                        chartView.axisY().min = 0;
                        chartView.axisY().max = 420;
                        chartView.axisY().tickCount = 6;
                        chartView.axisY().titleText = "temperature (ºC)";
                        chartView.axisX().titleText = "time (min)";
                        chartView.axisX().labelFormat = "%.0f";
                        chartView.axisX().min = 0;
                        chartView.axisX().max = 21;
                        chartView.axisX().tickCount = 21;
                    }
                    lineSeries.append(speedsList.get(currentIndex).speedTrap,
                                      speedsList.get(currentIndex).speed);

                    lineSeries2.append(speedsList.get(currentIndex).speedTrap,
                                      speedsList.get(currentIndex).btu);


                }
            } else {
                // No more data, change x-axis range to show all the data
                timer.stop();
                startButton.enabled = true;
                startButton.text= "Start roasting!";
            }
        }
    }
    //![3]
}
