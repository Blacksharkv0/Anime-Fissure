# Anime Fissure — Beta v0.6: mapa e inimigos reais

**Status:** código publicado na branch `main`. Build automático e funcionamento no Roblox Studio ainda precisam ser confirmados.

## O que esta beta traz

| Arquivo | Finalidade |
| --- | --- |
| `src/server/BetaMap.server.luau` | Arena 3D, portal, base, 8 waypoints e 4 spawns de jogadores (mapa já existente, preservado) |
| `src/shared/EnemyConfig.luau` | Invasor, Batedor, Blindado e Anjo; HP/velocidade por wave e coop |
| `src/server/EnemyModelBuilder.luau` | Modelos 3D nativos, barras de HP e cores diferenciadas |
| `src/server/EnemyService.luau` | Criação de inimigos, movimento, dano, chegada à base e conclusão real da wave |
| `src/server/Main.server.luau` | Integra EnemyService com MatchService e WaveService |
| `src/server/ArenaCombatVisuals.server.luau` | Barra de vida da base + painel de instruções no Studio |
| `src/shared/BossConfig.luau` | Capitão Invasor na wave 10 e Nigun na wave 15 (Classic)/20 (Hard) |
| `src/server/BossService.luau` | Escudo, mudança de fase, invocação de anjos e Dominion |

## Como testar de uma vez

1. No GitHub, abra **Actions → Anime Fissure - Build Beta** e selecione a execução recente da **main** que terminou com sucesso.
2. Baixe o artefato `AnimeFissure-Beta`. Extraia `AnimeFissure-Beta.rbxlx` e abra no Roblox Studio.
3. Aperte **Play** e confirme que o personagem inicia no lobby (waves ainda não devem começar).
4. Verifique Virgil e Edward, diálogos e os menus (checklist v0.5).
5. Entre na arena pelo fluxo **JOGAR** do lobby. Só então a primeira wave começa.
6. Confira os soldados saindo do portal e seguindo os **8 waypoints** até a base.
7. **Apenas no Studio:** clique nos modelos dos inimigos para causar **450 de dano físico de teste por clique**. Este recurso é temporário, não é o sistema real de unidades/towers.
8. Confira a diminuição do contador de inimigos e o aviso de preparação quando a wave termina.
9. Deixe um inimigo alcançar a base e confira a redução de 1 HP. A base inicia com 3 HP.
10. Teste os tipos especiais: Batedor após wave 3, Blindado após wave 6, Capitão na wave 10 e Nigun na wave 15 (Classic).
11. Contra Nigun, reduza a vida até menos de 40% e observe os eventos de segunda fase. As invocações passam a contar como inimigos reais.
12. Envie uma captura de **View → Output** caso o Studio exiba erros.

## Notas e limites

- Este é um **protótipo do combate com inimigos**. As unidades do jogador ainda não atacam; o dano por clique só existe em Play/Test do Roblox Studio.
- Todos os inimigos, inclusive os invocados por chefe, são criados e contabilizados pelo servidor. O cliente não decide dano nem recompensa.
- O modo **Classic** está definido como padrão em `Main.server.luau`. A configuração de Hard já existe, mas a seleção de modo por interface ainda não foi conectada.
- O mapa atualmente **jogável** é `FissureArena`. As demais fases de Overlord estão catalogadas em `StoryConfig` e ainda não foram construídas como mapas selecionáveis.
- O jogo continua sem o combate definitivo, deck/unidades posicionáveis e retorno completo ao lobby após uma partida.
- Esta entrega **não altera** Tickets do Summon, probabilidades, coleção, alquimia ou inventário.
- A compilação pelo Rojo no GitHub não prova que todos os comportamentos funcionam em Play. Precisamos testar no Studio.
