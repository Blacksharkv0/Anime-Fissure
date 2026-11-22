# Anime Fissure — Lobby v1.0 / Terminal de Fissuras

**Status:** scripts publicados em `main`. Teste de Play no Roblox Studio e compilação pelo GitHub Actions **ainda não confirmados**.

## O que entrou

- **Interface nova de lobby:** brand no alto, dock pequeno no canto inferior direito, botão `JOGAR · SELECIONAR FASE` e `GUIA DO LOBBY` (informa como acessar NPCs).
- **Terminal de missões:** catálogo de seis fases de Overlord derivado de `StoryConfig`, com nomes, chefes e estado de disponibilidade.
- **Carne Village `OVL_01`:** único mapa jogável da beta. Os demais estágios podem ser selecionados para ler os nomes/chefes, mas não iniciam partidas.
- **Dificuldade selecionável:** Classic (**15 waves**) ou Hard (**20 waves**), usando a configuração de `GameConfig`, `MatchService` e `BossConfig`.
- **Servidor valida todas as escolhas** por `LobbyStageConfig.CanEnter`. Não há prêmio, inventário, drop ou acesso a estágios falsos.
- **Portal funcional:** interação E/gamepad/toque no portal abre o mesmo terminal de missões. O botão do HUD também abre.
- **Aparência da praça:** `LobbyAtrium.server.luau` adiciona jardins, cristais, bandeiras, pórtico e emblema flutuante sem colisão, preservando o ambiente e as lojas originais.
- **Virgil e Edward:** permanecem com NPCs e diálogos anteriores; não foram removidos nem alterados por esta atualização.
- **Roblox Studio:** o menu se adapta a telas largas e estreitas com rolagem nos detalhes de fase.

## Teste passo a passo (PC e celular)

1. Abra `https://github.com/Blacksharkv0/Anime-Fissure/actions`.
2. Escolha a última execução de **Anime Fissure - Build Beta** na `main`; só use o artefato `AnimeFissure-Beta` se a execução concluir **verde**.
3. Abra o `.rbxlx` no Roblox Studio e clique **Play**.
4. Verifique se aparece uma pequena tela de carregamento e depois o lobby.
5. Confira os jardins nos cantos, a iluminação da praça, os cristais, o portal e as estações de Virgil/Edward.
6. Abra `GUIA DO LOBBY` e feche em `ENTENDI`.
7. Clique `JOGAR · SELECIONAR FASE`: deve surgir um terminal com **seis estágios de Overlord**.
8. Clique em OVL_02 e em outra fase futura; verifique que o botão de iniciar mostra **INDISPONÍVEL**.
9. Selecione `OVL_01` e `CLASSIC`. Os valores previstos são **Gold 150**, **3 fragmentos**, **8% Insígnia Solar**, **Hard Pity 15**. A entrega de recompensas ainda não está ligada.
10. Selecione `HARD`; os valores previstos mudam para **Gold 240**, **5 fragmentos**, **12%**, **Hard Pity 15**.
11. Teste clicar em `X` para fechar, caminhar até o portal e usar **E** (ou prompt de toque) para abrir o terminal novamente.
12. Inicie Classic ou Hard. Confirme, na arena, a contagem de waves apropriada (**15 ou 20**), as ondas e o novo Stage Info.
13. Volte a um Play novo para testar a outra dificuldade. A beta tem **uma partida por servidor**, sem botão de replay.
14. Confira NPCs: Virgil abre Summon; Edward abre oficina. No lobby novo esses prompts não podem ter desaparecido.
15. Use **Test → Device Emulator** e tente tela de celular na vertical e na horizontal: menu rolável, itens selecionáveis, botão de iniciar acessível.
16. Se houver falha, envie print do terminal e da janela **View → Output**.

## Limites da beta

- **Uma partida por servidor:** o jogo ainda não possui a fila cooperativa de quatro jogadores ou retorno automático ao lobby. O menu declara **BETA SOLO**, sem prometer coop implementado.
- **Apenas OVL_01 construído.** Os outros cinco mapas são catálogo/planejamento, não fases falsas.
- **Drops e Gold** da tela são valores **previstos**, não liberados. O serviço de concessão e de inventário/pity ainda não foi finalizado.
- **Hard** agora está ligado ao modo de partida no servidor, mas seu comportamento em jogo ainda precisa de teste funcional.
- **Coleção e decks** não foram anunciados como botões funcionais: ainda serão desenvolvidos no lobby.
- Os novos objetos da praça são visuais gerados por código, não modelos externos profissionais.
- A tela de carregamento é uma **transição visual**, não medição de download de assets.

## Arquivos

- `src/client/BetaLobby.client.luau` — interface responsiva e painel de missões
- `src/server/BetaLobby.server.luau` — autorização, feedback e prompt no portal
- `src/shared/LobbyStageConfig.luau` — catálogo e validação
- `src/server/Main.server.luau` — modo selecionado pelo lobby
- `src/server/LobbyAtrium.server.luau` — decoração nova
- `src/server/LobbyVisualPolish.server.luau` — decoração anterior preservada
- `.github/workflows/build-beta.yml` — conferência de presença dos scripts

**Nunca confundir a revisão dos arquivos no GitHub com teste funcional no Roblox Studio.**
