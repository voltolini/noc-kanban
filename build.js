const fs = require('fs');
const path = require('path');

const src = fs.readFileSync(path.join(__dirname, 'index.html'), 'utf8');

const url = process.env.SUPABASE_URL || '';
const key = process.env.SUPABASE_ANON_KEY || '';

if (!url || !key) {
  console.warn('Aviso: SUPABASE_URL ou SUPABASE_ANON_KEY não definidas nas variáveis de ambiente do projeto Vercel.');
}

const out = src
  .split('__SUPABASE_URL__').join(url)
  .split('__SUPABASE_ANON_KEY__').join(key);

fs.mkdirSync(path.join(__dirname, 'public'), { recursive: true });
fs.writeFileSync(path.join(__dirname, 'public', 'index.html'), out);
console.log('Build concluído: public/index.html gerado com as credenciais do Supabase.');
