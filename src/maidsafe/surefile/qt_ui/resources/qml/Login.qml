import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.0
import LifeStuff 1.0
import QtGraphicalEffects 1.0
import "."

Rectangle {
    border.width: 0
    width: root.width
    height: root.height
    implicitHeight: 600
    implicitWidth:  1000
    color: "#2053e0"
    gradient: Gradient {
        GradientStop {
            position: 0.00;
            color: "#2053e0";
        }
        GradientStop {
            position: 0.96;
            color: "#ffffff";
        }
        GradientStop {
            position: 1.00;
            color: "#ffffff";
        }
    }



    Column {
        id: content
        anchors.centerIn: parent
        width: 250
        spacing: 25
        Image {
            id: main_image
            anchors.horizontalCenter: parent.horizontalCenter
            source: mouseArea.containsMouse ? "qrc:/images/NewTux.svg" : "qrc:/images/splash_screen.png"
            fillMode: Image.PreserveAspectFit
            height: 350
            clip: true
            scale:  mouseArea.containsMouse ? 0.95 : 1.0
            smooth: mouseArea.containsMouse
            //rotation: mouseArea.containsMouse ? 10 : 0
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                anchors.margins: -10
                hoverEnabled: true
                onClicked: Qt.quit()
            }
            DropShadow {
                anchors.fill: main_image
                horizontalOffset: 3
                verticalOffset: 3
                radius: 8.0
                samples: 16
                color: "#80000000"
                source: main_image
            }
        }

        Column {
            id: column
            spacing: 15
            width: parent.width
            visible: true // !LifeStuff.pendingConnectionRequest && LifeStuff.connectionStatus == LifeStuff.LoggedOut

//            Connections {
//                target: LifeStuff
//                onConnectionErrorChanged: {
//                   // if (LifeStuff.connectionError != LifeStuff.Ok) {
//                   //     errorText.text = LifeStuff.connectionErrorMessage;
//                   // } else {
//                        errorText.text = ""
//                  //  }
//                }
//            }

            function login()
            {
                errorText.text = "";

                if (usernameField.text.length === 0 || passwordField.text.length === 0)
                    return;
                var j = 0;
                for (var i=0;i< 1000000000;i++) // pause a few seconds
                {
                 j += 1;
                }
              //  LifeStuff.login(usernameField.text, passwordField.text, rememberMe.checked);
              //  passwordField.text = "";
            }

            TextField {
                id: usernameField
                width: parent.width
                placeholderText: "Username"
                focus: true

                Keys.onTabPressed: pinField.forceActiveFocus()
                Keys.onReturnPressed: {
                    if (usernameField.text.length === 0)
                        usernameField.forceActiveFocus();
                    else
                        column.login();
                }
            }

            TextField {
                id: pinField
                width: parent.width
                placeholderText: "Pin"
                echoMode: TextInput.Password
                Keys.onTabPressed: passwordField.forceActiveFocus()
                Keys.onReturnPressed: {
                    if (pinField.text.length === 0)
                        pinField.forceActiveFocus();
                    else
                        column.login();
                }
            }


            TextField {
                id: passwordField
                width: parent.width
                placeholderText: "Password"
                echoMode: TextInput.Password
                Keys.onTabPressed: loginButton.forceActiveFocus()
                Keys.onReturnPressed: {
                    if (passwordField.text.length === 0)
                        passwordField.forceActiveFocus();
                    else
                        column.login();
                }
            }

            Text {
                id: errorText
                width: parent.width
                wrapMode: Text.WordWrap
                color: "#e23a3a"
            }

            Item {
                height: loginButton.height
                width: parent.width

                CheckBox {
                    id: rememberMe
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Remember me"
                    checked: true
                }

                CustomButton {
                    anchors.right: parent.right
                    width: 80
                    borderTop: 3
                    borderBottom: 3
                    borderLeft: 3
                    borderRight: 3
                    id: loginButton
                    iconName: "login-button"
                    text: "Log In"
                    enabled: usernameField.text.length > 0 && passwordField.text.length > 0
                    onClicked: column.login();
                }
            }
        }

        Item {
            height: column.height
            width: parent.width
            visible: !column.visible
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                id: waitingText
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -40
                text: "Logging In..."
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 15

//                Connections {
//                    target: LifeStuff
//                    onLoggingIn: waitingText.text = "Logging In..."
//                    onLoggingOut: waitingText.text = "Logging Out..."
//                }
            }

            Throbber {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: waitingText.bottom
                anchors.topMargin: 25
                running: !column.visible
                visible: running
                invertedStyle: true
            }
        }

    }
}
