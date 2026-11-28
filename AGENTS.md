# Anime Fissure — Convenções para trabalho com ChatGPT

## Preferência expressa pelo responsável do projeto (22/11/2026)

**Quando o usuário solicitar criação ou alteração de código do Anime Fissure, publicar diretamente no repositório GitHub `Blacksharkv0/Anime-Fissure` sempre que o acesso de escrita estiver disponível.** O usuário acessa frequentemente pelo celular e prefere **não receber grandes blocos de código na conversa**.

Fluxo esperado:

1. Ler o arquivo atual no GitHub e validar dependências e integração.
2. Criar ou atualizar arquivos diretamente no GitHub, normalmente na branch `main`, conforme a solicitação.
3. Confirmar o commit e verificar o conteúdo publicado.
4. Responder em português do Brasil, com um resumo curto, links para arquivos/commits e um pequeno roteiro de teste.
5. Se o GitHub estiver indisponível ou sem permissão, avisar com clareza. **Não afirmar que publicou algo sem confirmação do GitHub**; nesse caso, preparar patch apenas se ajudar.
6. Separar características **funcionais**, **planejadas** e **demonstrações no Roblox Studio**. Nunca fingir saldo, drops, pity, propriedades de unidades ou funcionalidades persistidas sem backend.
7. Proteger o jogo existente: preservar contratos de `Main.server`, `BetaBridge`, `EnemyService`, `MatchService`, `WaveService`, NPCs, Summon e economia; mudanças que alterem mecânicas acordadas devem ser explicitadas.

## Contexto do HUD

O botão **Stage Info** da fase deve mostrar elementos/inimigos/recompensas reais do catálogo, e o pity com marca de item obtido sem apagar o próximo ciclo. Até existir um perfil persistente de pity e inventário real, apresentar estado desconectado. Qualquer simulação deve ser restrita ao Studio e rotulada como prévia.

Esta nota registra uma **preferência de fluxo de trabalho**, não substitui testes no Roblox Studio.

## Instruções compartilhadas — ChatGPT e Codex (27/11/2026)

**Antes de trabalhar, ler [manual mestre](docs/ANIME-FISSURE-MASTER.md) e [diário de handoff](docs/DEV-HANDOFF.md).** Ambos registram decisões do criador e estado real. Não presumir acesso à conversa original nem a alterações locais não sincronizadas. Consultar os arquivos específicos vinculados no manual e o código atual. Em divergências, preservar comportamento funcional, registrar e consultar o criador antes de modificar mecânicas.

### Codex com Roblox Studio MCP
- Confirmar sessão e arquivo local corretos, modo Edit/Play e permissões. Não repetir diagnóstico já realizado se houver resultado registrado.
- Ler estado atual, verificar Output e concluir playtest inicial antes de alterações amplas. Workspace vazio em Edit é esperado: lobby/arena são montados em Play.
- Prioridade imediata: importação **efetiva** de modelos reutilizáveis autorizados, lobby de qualidade, seis unidades Overlord e VFX. Primeiro piloto pequeno, prova visual, aprovação, depois expansão. Não declarar asset importado se só existe ID, slot, candidato ou código.
- Backup local antes de editar; mudanças no Play não persistem. Exportar/sincronizar assets aprovados e código para os caminhos Rojo corretos. Preservar IDs, remotes, anchors, prompts, combate, economia e progressão.
- Usar ferramentas conforme escopo autorizado. Não publicar experiência Roblox, comprar assets, executar scripts de terceiros, expor credenciais ou ampliar permissões sem consentimento explícito. Modelos da Creator Store não garantem direitos de IP de anime; confirmar procedência, permissão de meshes/texturas, inspeção visual e desempenho. Não extrair conteúdo de jogos de terceiros. Sem carregamento remoto de código em produção.
- Exigir separação entre sintaxe/build verde, testes Studio efetivamente executados e aprovação artística. Registrar falhas e reproduções; não prometer zero bugs. Diagnóstico 13/13 mede presença, não toda a lógica transacional.

### Sincronização
- Conferir HEAD e git status antes de trabalhar. Não sobrescrever alterações não sincronizadas de outro agente ou do criador. A preferência é publicar código solicitado na main; se houver conflitos ou mudanças extensas sem autorização, preservar os arquivos e informar.
- Depois de cada lote, atualizar docs/DEV-HANDOFF.md com SHA/base, arquivos, assets efetivamente utilizados, resultados de testes e pendências. Atualizar o manual mestre apenas quando houver decisão nova ou correção comprovada de estado; preservar decisões anteriores relevantes.
- Retornar em português do Brasil, instruções pequenas e verificáveis. Preferir alterações no repositório a colar código longo no chat. Nunca afirmar commit, importação, teste, compra ou publicação sem evidência.
