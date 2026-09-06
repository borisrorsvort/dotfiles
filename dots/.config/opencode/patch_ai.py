import re
import sys

def patch_theme(path):
    with open(path, "r") as f: content = f.read()
    if "aiAgyHas" in content: return
    
    props = """    property int    aiOcToday: 0
    property var    aiOcModels: []

    property bool   aiAgyHas: false
    property bool   aiAgyFresh: false
    property int    aiAgyPct5h: 0
    property int    aiAgyPct7d: 0"""
    content = content.replace("    property int    aiOcToday: 0\n    property var    aiOcModels: []", props)

    proc = """
    Process {
        id: aiReadAntigravity
        command: ["bash", "-c", "agy --print /usage | awk '/Gemini Models.*Weekly/ {w=100-int($6)} /Gemini Models.*Five Hour/ {f=100-int($7)} END {print \\"{\\\\\\"5h-utilization\\\\\\":\\\\\\"\\"f\\"%\\\\\\", \\\\\\"7d-utilization\\\\\\":\\\\\\"\\"w\\"%\\\\\\"}\\"}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var d = JSON.parse(this.text.trim())
                    theme.aiAgyHas = true
                    theme.aiAgyFresh = true
                    theme.aiAgyPct5h = theme.aiPct(d["5h-utilization"])
                    theme.aiAgyPct7d = theme.aiPct(d["7d-utilization"])
                } catch (e) {
                    theme.aiAgyHas = false; theme.aiAgyFresh = false
                    theme.aiAgyPct5h = 0; theme.aiAgyPct7d = 0
                }
            }
        }
    }
"""
    content = re.sub(r'(Timer \{\s+interval: aiRefreshSec)', proc + r'\n    \1', content)

    refresh = """        if (!only || aiTool === "opencode") {
            aiReadOpenCode.running = false; aiReadOpenCode.running = true
        }
        if (!only || aiTool === "antigravity") {
            aiReadAntigravity.running = false; aiReadAntigravity.running = true
        }"""
    content = content.replace("""        if (!only || aiTool === "opencode") {
            aiReadOpenCode.running = false; aiReadOpenCode.running = true
        }""", refresh)
        
    with open(path, "w") as f: f.write(content)

def patch_widget(path):
    with open(path, "r") as f: content = f.read()
    if "isAntigravity" in content: return

    content = content.replace('readonly property bool isOpenCode: root.aiTool === "opencode"', 'readonly property bool isOpenCode: root.aiTool === "opencode"\n    readonly property bool isAntigravity: root.aiTool === "antigravity"')
    
    content = content.replace('property bool ocActive: false', 'property bool ocActive: false\n    property bool agyActive: true')
    content = content.replace('readonly property bool   ocFresh:', 'readonly property bool   agyFresh:     root.aiAgyFresh\n    readonly property int    agyPct5h:     root.aiAgyPct5h\n    readonly property int    agyPct7d:     root.aiAgyPct7d\n    readonly property bool   ocFresh:')
    
    content = content.replace('readonly property bool ocSignal: ocActive || ((ocPct5h > 0 || ocToday > 0) && ocFresh)', 'readonly property bool ocSignal: ocActive || ((ocPct5h > 0 || ocToday > 0) && ocFresh)\n    readonly property bool agySignal: agyActive || (agyPct5h > 0 && agyFresh)')
    
    content = content.replace('readonly property int  pct5h:   isOpenCode ? ocPct5h : (isCodex ? cxPrimaryPct : clPct5h)', 'readonly property int  pct5h:   isAntigravity ? agyPct5h : (isOpenCode ? ocPct5h : (isCodex ? cxPrimaryPct : clPct5h))')
    content = content.replace('readonly property bool selFresh: isOpenCode ? ocFresh : (isCodex ? cxFresh : clFresh)', 'readonly property bool selFresh: isAntigravity ? agyFresh : (isOpenCode ? ocFresh : (isCodex ? cxFresh : clFresh))')
    content = content.replace('readonly property bool selSignal: isOpenCode ? ocSignal : (isCodex ? cxSignal : clSignal)', 'readonly property bool selSignal: isAntigravity ? agySignal : (isOpenCode ? ocSignal : (isCodex ? cxSignal : clSignal))')
    content = content.replace('readonly property bool blocked:  (isCodex || isOpenCode) ? false : clBlocked', 'readonly property bool blocked:  (isCodex || isOpenCode || isAntigravity) ? false : clBlocked')

    content = content.replace('rootMod.isOpenCode ? rootMod.ocMarkW', '(rootMod.isOpenCode || rootMod.isAntigravity) ? rootMod.ocMarkW')
    content = content.replace('rootMod.isOpenCode ? rootMod.ocMarkH', '(rootMod.isOpenCode || rootMod.isAntigravity) ? rootMod.ocMarkH')

    with open(path, "w") as f: f.write(content)

def patch_panel(path):
    with open(path, "r") as f: content = f.read()
    if "showAntigravity" in content: return

    content = content.replace('readonly property bool   showOpenCode: root.aiTool === "opencode"', 'readonly property bool   showOpenCode: root.aiTool === "opencode"\n    readonly property bool   showAntigravity: root.aiTool === "antigravity"')
    
    content = content.replace('model: [ { id: "claude", label: "Claude" }, { id: "codex", label: "Codex" }, { id: "opencode", label: "OpenCode" } ]', 'model: [ { id: "claude", label: "Claude" }, { id: "codex", label: "Codex" }, { id: "opencode", label: "OpenCode" }, { id: "antigravity", label: "AGY" } ]')
    content = content.replace('width: root.evenW((parent.width - 12) / 3)', 'width: root.evenW((parent.width - 18) / 4)')
    
    agy_ui = """
                UiText {
                    visible: aiPanel.showAntigravity && !theme.aiAgyHas
                    width: parent.width
                    text: "no data — run agy"
                    color: root.sumiHi; font.family: root.mono; font.pixelSize: 11
                }
                UsageRow { visible: aiPanel.showAntigravity && theme.aiAgyHas; label: "5h"; pct: theme.aiAgyPct5h; dim: !theme.aiAgyFresh }
                UsageRow { visible: aiPanel.showAntigravity && theme.aiAgyHas; label: "7d"; pct: theme.aiAgyPct7d; dim: !theme.aiAgyFresh }
"""
    content = content.replace('                Item {\n                    width: 10\n                    height: 8', agy_ui + '                Item {\n                    width: 10\n                    height: 8')

    with open(path, "w") as f: f.write(content)

patch_theme("/home/boris/.config/quickshell/bar/variants/V2/Theme.qml")
patch_widget("/home/boris/.config/quickshell/bar/variants/V2/modules/ClaudeWidget.qml")
patch_panel("/home/boris/.config/quickshell/bar/variants/V2/panels/AiUsagePanel.qml")
