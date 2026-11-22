# Anime Fissure — Beta v0.7: Carne Village + novos inimigos

**Status:** scripts publicados em `main`; teste real dentro do Roblox Studio ainda pendente.

## Escopo e compatibilidade

- `src/server/EnemyModelBuilder.luau`: troca visual de inimigos comuns e chefes. Mantém `Builder.Build(stats)`, `Builder.UpdateHealth(model, health, maxHealth)`, `Body` como `PrimaryPart` e `EnemyHealthGui`.
- `src/server/BetaMap.server.luau`: recria `Workspace.FissureArena` com a ambientação rural **Carne Village** (mundo Overlord, fase `OVL_01`).
- Preservados os **8 waypoints** com atributo `Order` e deslocamento `+2Y`, os **4** `PlayerSpawns` invisíveis, `FissureBase.BaseCore` e `FissurePortal`.
- `Main.server`, `EnemyService`, `BossService`, `NPCResidents`, `SummonService` e o sistema de Tickets não foram modificados por esta atualização.
- A versão anterior da arena genérica não existe mais no build novo; o jogo ainda usa o nome interno `FissureArena` para compatibilidade.

## Como baixar a versão atual

1. Acesse **GitHub → Blacksharkv0/Anime-Fissure → Actions**.
2. Selecione **Anime Fissure - Build Beta** na branch `main`. **Não** baixe uma execução antiga da v0.6.
3. Se estiver com check verde, baixe `AnimeFissure-Beta` e extraia `AnimeFissure-Beta.rbxlx`.
4. Abra o arquivo no **Roblox Studio**, clique em **Play** e use **View → Output** para acompanhar erros.

## Checklist de validação visual

- [ ] O jogador inicia no lobby, não na arena.
- [ ] Virgil e Edward continuam interativos; os diálogos v0.5 continuam abrindo os respectivos menus.
- [ ] Ao entrar pelo lobby, a arena tem grama, terra, casas de madeira e reboco, telhados, campos de cultivo, cercas, carroças, poço, árvores e portal mágico.
- [ ] Não existe mais plataforma escura genérica com bordas neon azuis no centro do mapa.
- [ ] Nenhuma construção importante bloqueia o caminho dos inimigos.
- [ ] Os jogadores surgem juntos em posições seguras na área lateral do mapa.
- [ ] Invasor, Batedor e Blindado exibem roupas/armaduras diferentes e barras de HP.
- [ ] Capitão Invasor e Nigun são maiores e reconhecíveis por capa, armadura/cajado.
- [ ] Anjo da Guerra e Dominion Authority têm asas e halos.
- [ ] O modelo inteiro anda junto; nenhuma parte fica para trás no caminho.
- [ ] Braços, armas e cabelos não aparecem enterrados sob o solo.
- [ ] A barra de HP acompanha a vida e some quando o inimigo é derrotado.
- [ ] O contador de inimigos no HUD acompanha o combate.
- [ ] Os inimigos surgem pelo portal, seguem os oito pontos e chegam à base.
- [ ] Um inimigo normal que atravessa tira 1 de HP da base.
- [ ] Na wave 10 aparece o Capitão. Na wave 15 (Classic) aparece Nigun.
- [ ] Os movimentos de chefe continuam funcionando, inclusive invocação de anjos.
- [ ] A performance permanece jogável no PC e no dispositivo móvel que for usado nos testes.

**Teste temporário:** enquanto não existem torres posicionáveis, no Roblox Studio clique nos corpos dos inimigos para aplicar dano de treinamento. Isso não funciona como ataque das unidades do jogador.

## O que ainda não existe

- Modelos em MeshPart fiéis quadro a quadro aos personagens de Overlord; os modelos atuais ainda são **procedurais em peças nativas**.
- Animações de caminhada com ossos/rig profissional, texturas personalizadas, NPCs com diálogos de missão na fase, bosses finais esculpidos em Blender.
- Construções internas exploráveis em todas as casas.
- Combate definitivo de torres/unidades. 

O build automático do GitHub valida presença dos scripts e gera um `.rbxlx`, mas **não substitui** um Play Test no Roblox Studio.

## Dicas de depuração

Se a arena estiver vazia, verifique mensagens que começam com `[Anime Fissure]` e o atributo `Workspace.FissureArena.Ready`.
Se os inimigos não surgirem, verifique `EnemyService` e `FissureArena.EnemyPath` (8 partes com atributo numérico `Order`).
Se algum modelo perder peças em movimento, inspecione `LiveEnemies`, `Body` e `PrimaryPart`.
