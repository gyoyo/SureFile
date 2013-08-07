import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.0
//import LifeStuff 1.0
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

  Main { toolBar:login_button.text = "Login"}
 // Main { toolBar:onClicked = (loader.source = "qrc:/qml/Login.qml") }


Column {
    id: column
    spacing: 15
    width: 250
    visible: true

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

        CustomButton {
            anchors.right: parent.right
            width: 100
            borderTop: 3
            borderBottom: 3
            borderLeft: 3
            borderRight: 3
            id: loginButton
            iconName: "login-button"
            text: "Create"
            enabled: usernameField.text.length > 0 && passwordField.text.length > 0
            onClicked: column.login();
        }
    }
}
}
