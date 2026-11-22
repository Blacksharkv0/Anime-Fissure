# Anime Fissure — Beta v0.9: HUD principal + Stage Info

**Publicação:** arquivos atualizados na branch `main`. Integração estrutural revisada; **Roblox Studio ainda precisa ser testado**.

## Mudanças

- `src/client/BetaHUD.client.luau`: mantém um único `ScreenGui` chamado `AnimeFissureBetaHUD` e cria o Stage Info dentro dele.
- `src/client/StageIntelPanel.luau`: módulo `StageIntelPanel.Attach(gui)` que recebe os snapshots do HUD principal; nenhum segundo listener da rede.
- `src/client/StageIntelHUD.client.luau`: script antigo **apagado** para não exibir painéis duplicados.
- `src/server/BetaBridge.server.luau`: mantém envio existente de `MatchState.StageInfo`, wave, base, Yen, Skip e Auto Skip.
- `.github/workflows/build-beta.yml`: valida presença do novo ModuleScript.
- Animação para abrir/fechar o Stage Info; cards de inimigos, drops e recompensas; wave atual visível dentro do Stage Info.
- Barra de wave, título da fase e recursos mais limpos no HUD principal; cabeçalhos e barra inferior adaptam escala em PC e mobile.

## Checklist de teste

1. Abra o GitHub Actions e baixe `AnimeFissure-Beta.rbxlx` da execução mais recente da branch `main` **com status de sucesso**.
2. No Roblox Studio, inicie **Play**.
3. No lobby, não deve aparecer o HUD de combate nem o Stage Info.
4. Entre em Carne Village pelo botão **JOGAR**.
5. No topo esquerdo: `ANIME FISSURE`, `CARNE VILLAGE`, wave atual e status de combate.
6. No topo direito: Yen e HP da base.
7. Na parte inferior: contador de inimigos, barra de progresso, Skip e Auto Skip devem continuar aparecendo.
8. Na lateral direita, encontre **um único** botão `STAGE INFO`.
9. Abra o Stage Info: nome, dificuldade, **wave atual**, elemento ainda não definido, inimigos e drops.
10. Use a rolagem para encontrar a Insígnia Solar: chance 8% no Classic, hard pity máximo de 15.
11. Apenas no Studio, pressione o botão de simulação para mostrar **✔ obtido** e o contador de pity reiniciado e progredindo; esse teste não salva nenhum item.
12. Feche e reabra Stage Info; nenhuma segunda janela deve aparecer.
13. Com o painel aberto, vote Skip na preparação e altere Auto Skip; os comandos ainda devem funcionar.
14. Em **Test → Device Emulator**, verifique resolução celular em retrato e paisagem. A interface deve continuar clicável e rolável.
15. Saia da arena/encerre Play. O painel não deve ficar preso na tela.

## O que está ligado e o que ainda não está

- **Ligado:** wave atual, inimigos restantes, HP da base, nome e dificuldade da fase, lista de inimigos, recompensas configuradas, chance e teto do pity.
- **Sem backend real ainda:** XP, elemento da fase, atualização persistente do pity, inventário de itens raros e entrega de recompensas. A interface sinaliza campos pendentes e não atribui nada.
- **Sem funcionalidade completa ainda:** gerenciamento de unidades, seis slots posicionáveis e cálculo de dano por jogador. Não foram criados botões falsos para essas ações.

## Diagnóstico se aparecer problema

- Na janela `View → Output`, busque por `BetaHUD v0.9` e `StageIntelPanel`.
- Se o Stage Info não aparecer, verifique se o `StageIntelPanel` virou **ModuleScript** em `StarterPlayerScripts/AnimeFissureClient`, e se o jogo já marcou o jogador com `InArena=true`.
- Se houver um Stage Info duplicado, confira se o `StageIntelHUD.client.luau` antigo não foi mantido em um projeto local importado à mão.
- Para erros ou partes cortadas, envie print do HUD e do `Output`.

**Observação:** um build concluído pelo Rojo não comprova comportamento em Play; esta verificação continua pendente.
