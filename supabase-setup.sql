-- Rode este script no SQL Editor do seu projeto Supabase (Database > SQL Editor).

create extension if not exists pgcrypto;

create table if not exists public.tasks (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text default '',
  responsavel text default '',
  priority text default 'Média',       -- Baixa | Média | Alta | Crítica
  impact text default 'Médio',         -- Baixo | Médio | Alto | Crítico
  ticket text default '',
  estimated_hours numeric default 0,
  tags text[] default '{}',
  status text not null default 'BACKLOG', -- BACKLOG | TODO | IN_PROGRESS | REVIEW | DELIVERED | DONE
  created_at timestamptz not null default now()
);

create table if not exists public.apontamentos (
  id uuid primary key default gen_random_uuid(),
  task_id uuid not null references public.tasks(id) on delete cascade,
  responsavel text default '',
  start_time timestamptz not null,
  end_time timestamptz,
  description text default '',
  created_at timestamptz not null default now()
);

create index if not exists apontamentos_task_id_idx on public.apontamentos(task_id);

-- Row Level Security: habilitado, mas com policy aberta para uso interno via anon key.
-- Se este quadro for exposto fora da rede/equipe, troque por policies com auth.uid()
-- (Supabase Auth) em vez de "using (true)".
alter table public.tasks enable row level security;
alter table public.apontamentos enable row level security;

create policy "tasks_all" on public.tasks
  for all using (true) with check (true);

create policy "apontamentos_all" on public.apontamentos
  for all using (true) with check (true);
