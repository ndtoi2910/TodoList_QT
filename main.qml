import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    visible: true
    width: 400
    height: 600
    title: "Todo-List"

    property int todoModelIndex: 0
    property int cntTodoIndex: 0
    property bool titleTimeVisible: true

    function getCurrentDate() {
        var today = new Date()
        var day = today.getDate()
        var month = today.getMonth() + 1
        var year = today.getFullYear()

        return day + "/" + month + "/" + year
    }

    ListModel {
        id: todoModel
        ListElement {date: "14/2/2025"; name: "A"; taskDone: "false"}
    }

    Column {
        id: todoComponent
        visible: true
        anchors.fill: parent
        // spacing: 10

        
        Rectangle {
            id: rect1
            width: parent.width
            height: parent.height / 20
            // color: "red"

            Row {
                anchors.fill: parent
                spacing: 10

                Rectangle {
                    width: parent.width - 60
                    height: parent.height
                    
                    TextField {
                        id: todoText
                        anchors.fill: parent
                        verticalAlignment: TextInput.AlignVCenter
                        font.pixelSize: 12
                        placeholderText: "Nhập từ khóa ..."
                        background: Rectangle {
                            color: "white"
                            radius: 20 
                            border.color: "silver"
                            border.width: 1
                        }
                    }
                }

                Rectangle {
                    width: 50
                    height: parent.height
                    radius: 25
                    border.width: 2
                    border.color: "silver"
                    
                    Text {
                        text: "Add"
                        anchors.centerIn: parent
                        font.pixelSize: 12
                        color: "silver"
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            if(todoText.text != ""){
                                todoModel.append({date: getCurrentDate(), name: todoText.text, taskDone: "false"})
                                todoText.text = ""
                                cntTodoIndex++
                            }
                        }
                    }
                }
            }
        }

        TabBar {
            id: tabBar
            width: parent.width

            Repeater {
                model: ["Tasks", "Tasks Completed", "Recently deleted"]

                TabButton {
                    text: modelData
                    width: Math.max(100, tabBar.width / 3)

                    // background: Rectangle {
                    //     radius: 20
                    // }
                }
            }
        }

        StackLayout {
            id: stackLayout
            // anchors.top: tabBar.bottom
            width: parent.width
            height: parent.height - rect1.height - tabBar.height
            currentIndex: tabBar.currentIndex

            Item {
                Rectangle {
                    anchors.fill: parent
                    // color: "yellow"

                    ListView {
                        anchors.fill: parent
                        spacing: 10
                        boundsBehavior: Flickable.StopAtBounds
                        model: todoModel
                        
                        section.property: "date"
                        section.delegate: 
                        Rectangle {
                            width: parent.width
                            height: 30
                            Text {
                                text: section
                                font.pixelSize: 14
                                font.bold: true
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                                anchors.top: parent.top
                                anchors.topMargin: 5
                            }
                        }
                        
                        delegate: 
                        Rectangle {
                            width: parent.width
                            height: 30

                            Row {
                                anchors.fill: parent
                                spacing: 5

                                Rectangle {
                                    width: parent.width - 135
                                    height: parent.height
                                    color: "#e0e0e0"
                                    radius: 25
                                    border.width: 2
                                    border.color: "silver"

                                    Text {
                                        text: model.name
                                        font.pixelSize: 14
                                        anchors {
                                            left: parent.left
                                            leftMargin: 10
                                            verticalCenter: parent.verticalCenter
                                        }
                                    }
                                }

                                Rectangle {
                                    width: 40
                                    height: parent.height
                                    radius: 15
                                    border.width: 2
                                    border.color: "silver"

                                    Text {
                                        text: "Edit"
                                        color: "silver"
                                        font.pixelSize: 10
                                        anchors.centerIn: parent
                                    }

                                    MouseArea {
                                        anchors.fill: parent

                                        onClicked: {
                                            todoComponent.visible = false
                                            popupEdit.visible = true
                                            todoModelIndex = model.index
                                            todoTextEdit.text = model.name
                                        }
                                    }
                                }

                                Rectangle {
                                    width: 40
                                    height: parent.height
                                    radius: 15
                                    border.width: 2
                                    border.color: "silver"

                                    Text {
                                        text: "Done!"
                                        color: "silver"
                                        font.pixelSize: 10
                                        anchors.centerIn: parent
                                    }

                                    MouseArea {
                                        anchors.fill: parent

                                        onClicked: {

                                        }
                                    }
                                }

                                Rectangle {
                                    width: 40
                                    height: parent.height
                                    radius: 15
                                    border.width: 2
                                    border.color: "silver"

                                    Text {
                                        text: "Delete"
                                        color: "silver"
                                        font.pixelSize: 10
                                        anchors.centerIn: parent
                                    }

                                    MouseArea {
                                        anchors.fill: parent

                                        onClicked: {
                                            todoModel.remove(index)

                                        }
                                    }
                                }
                            }

                            // MouseArea {
                            //     anchors.fill: parent

                            //     onClicked: {
                                    
                            //     }
                            // }
                        }

                        ScrollBar.vertical: ScrollBar {
                            id: scrollBar
                            opacity: 0

                            Behavior on opacity {
                                NumberAnimation { duration: 300 }
                            }
                        }

                        onMovementStarted: {
                            scrollBar.opacity = 1;
                        }

                        onMovementEnded: {
                            scrollBar.opacity = 0;
                        }
                    }
                }
            }

            Item {
                Rectangle {
                    color: "blue"
                    anchors.fill: parent
                    Text {
                        text: "Home Page"
                        anchors.centerIn: parent
                        font.pixelSize: 20
                    }
                }
            }

            Item {
                Rectangle {
                    color: "green"
                    anchors.fill: parent
                    Text {
                        text: "Home Page"
                        anchors.centerIn: parent
                        font.pixelSize: 20
                    }
                }
            }
        }
    }

    Rectangle {
        id: popupEdit
        visible: false
        width: 200
        height: 200
        anchors.centerIn: parent

        Column {
            anchors.fill: parent
            spacing: 10

            Rectangle {
                width: parent.width
                height: 20

                Text {
                    text: "Edit Todo"
                    anchors.centerIn: parent
                    font.pixelSize: 12
                }
            }

            Rectangle {
                width: parent.width
                height: 140

                TextField {
                    id: todoTextEdit
                    anchors.fill: parent
                    verticalAlignment: TextInput.AlignVCenter
                    font.pixelSize: 12
                    placeholderText: "Nhập thay đổi ..."
                    background: Rectangle {
                        color: "white"
                        radius: 20 
                        border.color: "silver"
                        border.width: 1
                    }
                }
            }

            Row {
                width: parent.width
                height: 20
                spacing: 100

                Rectangle {
                    width: 50
                    height: parent.height
                    radius: 25
                    border.width: 2
                    border.color: "silver"

                    Text {
                        text: "OK"
                        anchors.centerIn: parent
                        font.pixelSize: 12
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            todoModel.setProperty(todoModelIndex, "name", todoTextEdit.text)
                            todoComponent.visible = true
                            popupEdit.visible = false
                        }
                    }
                }

                Rectangle {
                    width: 50
                    height: parent.height
                    radius: 25
                    border.width: 2
                    border.color: "silver"

                    Text {
                        text: "Cancel"
                        anchors.centerIn: parent
                        font.pixelSize: 12
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            todoComponent.visible = true
                            popupEdit.visible = false
                        }
                    }
                }
                
            }
        }
    }
}

// import QtQuick 2.15
// import QtQuick.Controls 2.15

// ApplicationWindow {
//     visible: true
//     width: 300
//     height: 400
//     title: "Fixed Scroll ListView"

//     ListView {
//         id: listView
//         width: parent.width
//         height: parent.height
//         model: ListModel {
//             ListElement { name: "Alice" }
//             ListElement { name: "Bob" }
//             ListElement { name: "Charlie" }
//             ListElement { name: "David" }
//             ListElement { name: "Eva" }
//             ListElement { name: "Frank" }
//             ListElement { name: "Grace" }
//             ListElement { name: "Henry" }
//             ListElement { name: "Ivy" }
//             ListElement { name: "Jack" }
//             ListElement { name: "Kevin" }
//             ListElement { name: "Laura" }
//             ListElement { name: "Michael" }
//             ListElement { name: "Nancy" }
//         }

//         spacing: 10
//         boundsBehavior: Flickable.StopAtBounds // Chặn kéo ra ngoài

//         delegate: Rectangle {
//             width: parent.width
//             height: 50
//             color: index % 2 === 0 ? "#f0f0f0" : "#e0e0e0"

//             Text {
//                 anchors.centerIn: parent
//                 text: model.name
//                 font.pixelSize: 18
//             }
//         }

//         // Thanh cuộn tự ẩn khi không cuộn
//         ScrollBar.vertical: ScrollBar {
//             id: scrollBar
//             opacity: 0

//             Behavior on opacity {
//                 NumberAnimation { duration: 300 }
//             }
//         }

//         onMovementStarted: {
//             scrollBar.opacity = 1;
//         }

//         onMovementEnded: {
//             scrollBar.opacity = 0;
//         }
//     }
// }