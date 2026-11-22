# Anime Fissure — Beta v1.1: primeiras Towers jogáveis

**Status:** código na branch `main`; testes de execução no Roblox Studio ainda pendentes.

## Unidades implementadas

| Unidade | Status | Função | Custo inicial | Ataque | Limite |
|---|---|---|---:|---|---:|
| Espadachim da Fissura (`FissureBlade`) | Protótipo temporário livre | Dano físico | 220 Yen | 40 dmg a cada 0,90s, range 23 | 4 |
| Arcanista da Fissura (`FissureMage`) | Protótipo temporário livre | Dano mágico | 320 Yen | 85 dmg a cada 1,80s, range 29 | 3 |
| Capsule (`Capsule`) | Unidade do Summon, exige posse | Farm | 500 Yen | Não ataca; renda por wave | 3 |

- Todos começam no nível zero. **Espadachim/Arcanista** têm três upgrades provisórios; dano +50%/nível, range +1,8/nível e SPA -7%/nível. São para testar o motor de combate, **não unidades definitivas do crossover**.
- **Capsule** usa o cadastro oficial em `CapsuleUnitConfig`: renda base de **700 Yen por wave** (conforme valor atualmente no repositório), oito upgrades, três colocações, e crescimento/evolução da fonte original. Não foi inventado upgrade da mítica CapsuleCorp, que **ainda não está disponível para colocar**.
- A propriedade **Shiny** existe na coleção do Summon, mas não produz visual alternativo de Tower nesta beta.
- O deck mostra **seis slots** como estrutura; somente os três primeiros têm unidade. Os slots quatro, cinco e seis não possuem unidade configurável ainda.
- Models são **Parts procedurais**, não MeshParts/animações profissionais. Não afirmar que personagens de anime foram esculpidos.

## Fluxo de entrada e primeira wave

1. No lobby, aproxime-se de Virgil e obtenha Capsule pelo Summon, caso queira testar a unidade econômica. Sem Capsule no inventário, o slot 3 deve mostrar **BLOQUEADA**.
2. Abra o terminal de Overlord, escolha Carne Village Classic ou Hard e clique para entrar.
3. A partida inicia com **700 Yen** e **24 segundos de preparação inicial**. Os jogadores podem votar **SKIP** para começar a wave 1 antes.
4. O HUD anterior permanece com base/wave/Skip/Auto Skip/Stage Info. O painel de comandos de wave foi movido para a parte superior esquerda, deixando o rodapé central para o deck.
5. Escolha uma unidade clicando num slot habilitado. Mova o mouse sobre **grama livre próxima ao caminho** para ver o marcador de posicionamento. Clique/tap para posicionar.
6. **Validação de servidor:** posição em terreno jogável, longe da trilha, de outras Towers e dos spawns. A posição não é aceita se atingir construções, se estiver muito perto do trajeto ou fora da arena.
7. Para selecionar uma Tower já colocada, **clique/toque na base circular dela**. O painel oferece Upgrade, Venda e Fechar.
8. **Venda:** recebe 50% do valor investido, incluindo upgrades; cada colocação e upgrade gasta Yen real do estado da partida.
9. **Combate:** Espadachim/Arcanista identificam inimigos reais dentro do range, atacam automaticamente e causam dano por API privada de servidor do `EnemyService`, inclusive em bosses com resistências existentes. Tracers neon mostram os disparos.
10. **Yen por kill:** ocorre no servidor quando inimigo morre. O `StoryRewardConfig` passou a reconhecer os IDs `Invader`, `Scout`, `Armored`, preservando os valores existentes de 15/18/40 e chefes. Segue `GameConfig.Coop.SharedYenFromKills = true`, compartilhando com participantes numa futura coop.
11. **Farm:** a Capsule não ataca; recebe os valores de renda da configuração por wave concluída enquanto a partida está ativa.
12. **Fim da partida:** comandos não permitem colocar/vender depois que o status deixa de ser Playing. Os modelos permanecem para inspeção. A beta ainda não tem replay/retorno ao lobby.

## Checklist no Roblox Studio

- [ ] `GitHub → Actions → Anime Fissure - Build Beta`: artefato **mais recente na branch main** e execução verde.
- [ ] Abrir `AnimeFissure-Beta.rbxlx` e clicar em **Play**.
- [ ] Lobby sem deck, sem HUD de combate; Virgil e Edward continuam funcionando.
- [ ] Entrar em Carne Village: **deck com 6 posições** no rodapé, duas disponíveis e Capsule apenas se obtida.
- [ ] HUD de wave no canto superior esquerdo e painel Stage Info à direita; nenhum painel duplicado.
- [ ] Preparação inicial de 24s; SKIP inicia wave 1, sem pular direto para wave 2.
- [ ] Selecionar Espadachim e posicionar próximo ao caminho: **-220 Yen** e modelo em pé.
- [ ] Selecionar Arcanista: **-320 Yen**, modelo e ataques de magia.
- [ ] Ver VFX dos disparos, inimigos perdendo HP e contador de inimigos diminuindo.
- [ ] Clicar em uma base circular: aparecer Upgrade, Venda e stats da Tower.
- [ ] Tentar Upgrade com Yen insuficiente: servidor recusa e explica.
- [ ] Vender uma Tower: devolução de 50% do custo + upgrades.
- [ ] Tentar colocar no caminho, na casa ou sobre outra Tower: servidor recusa.
- [ ] Testar limite por unidade, dano de chefe, fuga de inimigo e partida encerrada.
- [ ] Summonar Capsule em Virgil antes de entrar; testar colocar e receber renda de wave.
- [ ] Comparar Yen no deck e no HUD principal; ambos devem mostrar o mesmo total.
- [ ] Emulador mobile: tocar nos slots, tocar no terreno, selecionar torre, upgrade e venda.
- [ ] `View → Output`: conferir erros Lua/Luau e logs `[Anime Fissure Towers]`.

## Segurança e limitações

- Toda ação **Place / Upgrade / Sell** é revalidada no servidor: participante, status de partida, distância do caminho, terreno, saldo, limite e propriedade da Tower.
- O cliente **não** controla dano nem concede dinheiro. O dano aos inimigos é aplicado somente via ModuleScript servidor.
- Não foi criado inventário ou deck persistente de seis unidades. Os dois atacantes são unidades beta provisórias e aparecem mesmo sem serem obtidos no Summon.
- A Capsule só pode ser colocada se a coleção do `SummonProfileStore` confirmar sua posse.
- Recompensas Gold/XP e pity no Stage Info permanecem sem backend de entrega.
- **Não foi possível executar uma sessão de Play no Roblox Studio a partir da conexão GitHub; este é um roteiro de verificação manual.**

## Arquivos

- `src/shared/TowerConfig.luau`
- `src/server/TowerModelBuilder.luau`
- `src/server/TowerService.luau`
- `src/client/TowerHUD.client.luau`
- `src/server/EnemyService.luau` (API de dano/target só servidor)
- `src/server/Main.server.luau` (inicialização + preparação inicial)
- `src/server/WaveService.luau` (preparação inicial válida)
- `src/shared/StoryRewardConfig.luau` (aliases de IDs de inimigos)
- `src/server/BetaBridge.server.luau` (Yen personalizado)
- `src/client/BetaHUD.client.luau` (wave controls deslocados)
