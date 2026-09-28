const fs = require('fs');

const patchFile = (filePath) => {
  let content = fs.readFileSync(filePath, 'utf8');
  
  const injection = `
      if (response.message.content && !response.message.tool_calls) {
        let txt = response.message.content.trim();
        if (txt.startsWith('\`\`\`json')) {
           txt = txt.replace(/^\`\`\`json\\n/, '').replace(/\\n\`\`\`$/, '').trim();
        }
        if (txt.startsWith('{') && txt.includes('"name"') && txt.includes('"arguments"')) {
          try {
            const parsed = JSON.parse(txt);
            if (parsed.name && parsed.arguments) {
              response.message.tool_calls = [{
                function: {
                  name: parsed.name,
                  arguments: typeof parsed.arguments === 'string' ? JSON.parse(parsed.arguments) : parsed.arguments
                }
              }];
              response.message.content = "";
            }
          } catch(e) {}
        }
      }
`;

  if (content.includes('const parsedToolCalls = parseOllamaToolCalls')) {
    content = content.replace(
      /const parsedToolCalls = parseOllamaToolCalls\(/g,
      injection + '\n      const parsedToolCalls = parseOllamaToolCalls('
    );
    fs.writeFileSync(filePath, content);
    console.log(`Patched ${filePath}`);
  }
};

patchFile('node_modules/ai-sdk-ollama/dist/index.js');
patchFile('node_modules/ai-sdk-ollama/dist/index.cjs');
