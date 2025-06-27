#include "mainwindow.h"
#include <QVBoxLayout>
#include <QMessageBox>

MainWindow::MainWindow(QWidget *parent) : QMainWindow(parent) {
    QWidget *centralWidget = new QWidget(this);
    setCentralWidget(centralWidget);

    QVBoxLayout *layout = new QVBoxLayout(centralWidget);

    button = new QPushButton("Click me", this);
    checkbox = new QCheckBox("Check me", this);
    statusLabel = new QLabel("Checkbox is not checked", this);
    toggleButton = new QPushButton("Toggle CheckBox", this);

    layout->addWidget(button);
    layout->addWidget(checkbox);
    layout->addWidget(statusLabel);
    layout->addWidget(toggleButton);

    connect(button, &QPushButton::clicked, this, &MainWindow::onButtonClicked);
    connect(checkbox, &QCheckBox::stateChanged, this, &MainWindow::onCheckBoxStateChanged);
    connect(toggleButton, &QPushButton::clicked, this, &MainWindow::onToggleButtonClicked);

    // Устанавливаем начальное состояние
    onCheckBoxStateChanged(checkbox->checkState());
}

void MainWindow::onButtonClicked() {
    if (checkbox->isChecked()) {
        QMessageBox::information(this, "CheckBox State", "The checkbox is checked.");
    } else {
        QMessageBox::information(this, "CheckBox State", "The checkbox is not checked.");
    }
}

void MainWindow::onCheckBoxStateChanged(int state) {
    if (state == Qt::Checked) {
        statusLabel->setText("Checkbox is checked");
        centralWidget()->setStyleSheet("background-color: green;");
    } else {
        statusLabel->setText("Checkbox is not checked");
        centralWidget()->setStyleSheet("background-color: red;");
    }
}

void MainWindow::onToggleButtonClicked() {
    checkbox->setChecked(!checkbox->isChecked());
}