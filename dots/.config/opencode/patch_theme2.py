with open("/home/boris/.config/quickshell/bar/variants/V2/Theme.qml", "r") as f: lines = f.readlines()
for i, line in enumerate(lines):
    if "function refreshAiUsage(selectedOnly)" in line:
        insert_idx = i
        break

proc = """    Process {
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
lines.insert(insert_idx, proc)
with open("/home/boris/.config/quickshell/bar/variants/V2/Theme.qml", "w") as f: f.writelines(lines)
