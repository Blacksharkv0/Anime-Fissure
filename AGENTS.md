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
