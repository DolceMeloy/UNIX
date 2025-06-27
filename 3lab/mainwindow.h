#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QPushButton>
#include <QCheckBox>
#include <QLabel>

class MainWindow : public QMainWindow {
    Q_OBJECT

public:
    MainWindow(QWidget* parent = nullptr);

private slots:
    void onButtonClicked();
    void onCheckBoxStateChanged(int state);
    void onToggleButtonClicked();

private:
    QPushButton* button;
    QCheckBox* checkbox;
    QLabel* statusLabel;
    QPushButton* toggleButton;
};

#endif // MAINWINDOW_H