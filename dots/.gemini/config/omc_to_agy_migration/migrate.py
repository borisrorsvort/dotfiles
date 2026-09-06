import os
import re

SKILLS_DIR = os.path.expanduser("~/.gemini/config/skills/")

replacements = {
    r"Claude Code": "Antigravity",
    r"Claude": "Antigravity",
    r"oh-my-claudecode:": "agy-",
    r"~/\.claude/": "~/.gemini/config/",
    r"\.omc/": ".agents/",
    r"model=\"haiku\"": "model=\"flash_lite\"",
    r"model=\"sonnet\"": "model=\"flash\"",
    r"model=\"opus\"": "model=\"pro\"",
    r"CLAUDE_SESSION_ID": "AGY_CONVERSATION_ID",
    r"CLAUDECODE_SESSION_ID": "AGY_CONVERSATION_ID",
    r"Agent\(": "invoke_subagent(",
    r"subagent_type=": "TypeName="
}

for root, dirs, files in os.walk(SKILLS_DIR):
    for file in files:
        if file.endswith(".md") or file.endswith(".json") or file.endswith(".sh") or file.endswith(".mjs"):
            filepath = os.path.join(root, file)
            try:
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                original_content = content
                for pattern, replacement in replacements.items():
                    content = re.sub(pattern, replacement, content, flags=re.IGNORECASE if "claude" in pattern.lower() else 0)
                
                if content != original_content:
                    with open(filepath, 'w', encoding='utf-8') as f:
                        f.write(content)
                    print(f"Updated: {filepath}")
            except Exception as e:
                print(f"Failed to process {filepath}: {e}")
