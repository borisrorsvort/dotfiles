with open("/home/boris/.config/quickshell/bar/variants/V2/panels/AiUsagePanel.qml", "r") as f: content = f.read()
if "theme.aiAgyHas" not in content:
    target = """                    }
                }
            }
        }"""
    replacement = """                    }
                }
                
                Rectangle { visible: false; width: parent.width; height: 1; color: root.sep }

                // ── Antigravity ──
                Item {
                    visible: aiPanel.showAntigravity
                    width: parent.width; height: 16
                    UiText {
                        anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter
                        text: "limits"
                        color: root.sumi
                        font.family: root.mono; font.pixelSize: 10
                    }
                    UiText {
                        anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
                        text: "antigravity"
                        color: theme.aiAgyFresh ? root.sumi : root.sealRaw
                        font.family: root.mono; font.pixelSize: 10
                    }
                }
                UiText {
                    visible: aiPanel.showAntigravity && !theme.aiAgyHas
                    width: parent.width
                    text: "no data — run agy"
                    color: root.sumiHi; font.family: root.mono; font.pixelSize: 11
                }
                UsageRow { visible: aiPanel.showAntigravity && theme.aiAgyHas; label: "5h"; pct: theme.aiAgyPct5h; dim: !theme.aiAgyFresh }
                UsageRow { visible: aiPanel.showAntigravity && theme.aiAgyHas; label: "7d"; pct: theme.aiAgyPct7d; dim: !theme.aiAgyFresh }
            }
        }"""
    content = content.replace(target, replacement)
    with open("/home/boris/.config/quickshell/bar/variants/V2/panels/AiUsagePanel.qml", "w") as f: f.write(content)
