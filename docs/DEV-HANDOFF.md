# Anime Fissure — Diário compartilhado de desenvolvimento
Atualizar após cada lote de trabalho. Este é o ponto de passagem entre ChatGPT e Codex, não um substituto do histórico Git. Não incluir dados pessoais ou credenciais.

## 27/11/2026 — Primeira sessão Codex MCP
- **Base de código:** fd8ef1ec6cac366acc9bdcf3995cd42736057e04 (build verde 46093756066). Documentação posterior no GitHub; conferir HEAD atual.
- **Arquivo local relatado:** AnimeFissure-Reborn-Overlord.rbxlx.
- **Conexão:** usuário relatou 1 cliente conectado e Codex identificou 41 ferramentas e uma sessão em Edit. Inspeção execute_luau de leitura autorizada. Workspace Edit contém câmera/terreno; geração ocorre em Play.
- **Playtest:** relatório do Codex ainda não recebido neste ponto; 13/13, FPS, ausência de erro e interações não confirmados.
- **Arte:** repositório observado contém apenas .gitkeep em assets/lobby e assets/overlord. Importadores/slots prontos, nenhuma aquisição confirmada. Conferir estado local.
- **Próxima ação:** concluir diagnóstico inicial, registrar resultado abaixo, preparar piloto de importação real em cópia local. Não repetir trabalho já realizado. Consultar [manual mestre](ANIME-FISSURE-MASTER.md).

## Modelo para próximas entradas (duplicar e preencher)
### AAAA-MM-DD — Título da entrega
- Agente / base SHA / branch:
- Objetivo e decisões do criador:
- Estado do Studio antes/depois, Edit ou Play:
- Mudanças e arquivos reais (incluindo assets exportados):
- Origem/licença/permissões dos assets, modelos realmente carregados e fallbacks:
- Testes executados e resultados (PC/mobile, logs, evidência; não executado se pendente):
- Commit e build correspondente:
- Limites, regressões, rollback e próxima ação:

### 27/11/2026 — Carne Village restaurada e diagnóstico do lobby
- Codex, main. Base da sincronização `27af31e4c1e1412db884d9b92b29660c371cd95c`. Leitura integral de AGENTS, manual mestre e diário. Arquivo local AnimeFissure-Reborn-Overlord.rbxlx.
- Falha original em Play: `Unable to assign property Color. Color3 expected, got nil`, em BetaMap, durante a montagem da primeira casa. A cor ausente interrompia a arena antes da criação de BaseCore.
- Alteração única em `src/server/BetaMap.server.luau`: definir Gold com RGB(177, 146, 106). Aplicada e salva no Studio e sincronizada no [commit 32e0955](https://github.com/Blacksharkv0/Anime-Fissure/commit/32e095502b62a658a8ba711b2596c8021104efe6). Conteúdo da main relido. Build desse SHA ainda sem confirmação.
- Play após a correção: oito casas, oito waypoints, quatro spawns, 655 detalhes e BaseCore presente. Entrada OVL_01 Classic pelo remote do cliente aceita pelo servidor, onda 1 iniciada e HUD da arena ativo.
- Sessão de diagnóstico complementar: painel LobbyStudioAudit aberto no cliente por MCP. O próprio painel reportou 13/13, incluindo 11 portais, cinco vitrines, mentores, remotes e diretório/FX. Mede presença. Teste encerrado e modo Edit confirmado.
- Referência visual anterior: placas/pilares disputam a vista para Story no spawn e o botão de diagnóstico cobre parte da mensagem inferior esquerda no PC. Amostra anterior de 3.986 BaseParts e 16 MeshParts no Workspace do cliente, ainda com a arena incompleta. Refazer a medição com a arena corrigida antes do piloto visual.
- Arte: nenhuma importação neste lote. Bibliotecas de arte vazias na inspeção em Edit. Testes internos anteriores passaram para 24 variantes Overlord, 24 estágios de movimento e 42 acertos simulados. Sem aprovação artística ou medição de FPS.
- Rollback: backup local pré-correção AnimeFissure-antes-CarneVillage-20261127-225915.rbxlx validado por SHA-256 contra o original; no Git, reverter o commit da cor. Nenhuma publicação da experiência.
- Pendências: conferir CI do commit, fim e retorno de partida, Hard, interações e desempenho em mobile/multiplayer. Para arte, importar um único modelo de cenário de procedência verificada em cópia local, comparar visual e desempenho e obter aprovação antes de expandir.

### 27/11/2026 — Piloto de árvore da Creator Store
- Codex / main / base 7e02dc687cb82322636ce21aabefde61e2be1509. Backup local pré-piloto conferido por SHA-256. Em Edit, instalação local em ServerStorage/LobbyAssetLibrary/GardenTree, StudioPreviewOnly=true. Pacotes de inspeção removidos antes do Play. Sem mudança de scripts ou publicação Roblox.
- Fonte: [Roblox, pacote de natureza](https://create.roblox.com/store/asset/6933438443), peça Meshes/PolygonNature_Tree_03, mesh 6436440579, textura 6900342848. Uma MeshPart estática por árvore, sem scripts; 12 instâncias GardenTree_Imported confirmadas no cliente. Banco do City Props Pack era UnionOperation, incompatível com o validador atual; descartado.
- Cena capturada no Studio (GardenTree-piloto.png, entrega local). Diagnóstico do lobby 13/13. Amostras de 120 quadros no cliente Studio: piloto 15,0 FPS / p95 68,94 ms; procedural 14,8 FPS / p95 69,20 ms. Medição curta, sem ganho demonstrado e sem teste em celular. O modelo foi restaurado após a comparação, Studio em Edit.
- Busca de VFX e rig: candidatos gratuitos encontrados, sem validar direitos de texturas, procedência de todas as malhas ou compatibilidade R6. Nenhum aplicado. Aguardando revisão visual do piloto antes de expandir/exportar para Rojo. Sem build novo de código. Rollback: remover apenas o template GardenTree para reativar fallback ou restaurar backup pré-piloto.

### 28/11/2026 — Duas composições nos jardins
- Criador aprovou usar os dois estilos. Base do lote: handoff e8e954e. Backup local anterior conferido por SHA-256. No Studio, dois canteiros a leste com três árvores claras cada; dois a oeste com duas árvores mais escuras, espaçadas e de alturas diferentes. Mesmo mesh e textura do pacote oficial Roblox 6933438443. Sem VFX, luzes ou animações adicionais.
- Template real exportado para assets/lobby/GardenTree.rbxmx (77a5557); src/server/LobbyAtrium.server.luau atualizado (1277248). Ambos relidos na main. StudioPreviewOnly preservado. Para rollback completo, reverter os dois commits ou restaurar o backup.
- Play no cliente: seis árvores claras, quatro escuras e 13/13 no diagnóstico. Captura lateral Jardim-oeste.png. Play encerrado e arquivo local salvo. Pendências: build Rojo desse lote, medição de FPS/mobile e escolha de piloto de personagem/VFX. Nenhuma publicação Roblox.

### 28/11/2026 — Chegada e orientação no lobby
- Base de continuidade f56e1a6. Backup local pré-chegada verificado por SHA-256. LobbyAtrium (6651b5c): entrada baixa e aberta, duas setas no piso em direção ao portal Story e placa da cidadela ajustada. LobbyStudioAudit (fb9e46d): botão acima da mensagem de entrada, painel reposicionado. Ambos relidos na main. Nenhum asset externo novo.
- Play no desktop, capturas locais EntradaOriginal.png e EntradaNova.png da mesma câmera. Depois: 5 px livres entre botão e mensagem, painel 13/13. FISSURE CITY SMOKE OK: 853 peças decorativas, nove rotas, spawn e portal preservados. Play encerrado, arquivo local salvo. Sem publicação Roblox.
- Pendentes: ergonomia em tela pequena, CI desta revisão e desempenho em dispositivo real. Rollback pelos dois commits ou pelo backup local pré-chegada.

### 28/11/2026 — Piloto de personagem: Climb
- Base de continuidade cbf65ad; backup local antes da edição conferido por SHA-256. Mudança procedural autoral apenas no construtor de Climb em src/shared/OverlordTowerModelBuilder.luau, commit bd68586c53aa7452ddc399048b9df36c15d0be78, conteúdo verificado na main. Nenhuma importação de terceiros, alteração de mecânica ou publicação Roblox.
- Franja e mechas laterais loiras, ombreiras arredondadas, tecido azul profundo sob as placas, tabardo com debrum e fivela de latão. Comparação local ClimbOriginal.png / ClimbGuarda.png com mesma câmera e estágio base. Objetos temporários de inspeção removidos.
- Play: 59 BaseParts no modelo base, seis Motor6D, WeaponFocus presente, quatro estágios aplicados com sucesso. Testes internos de modelos (24 variantes), animações (24 estágios), combate (42 acertos simulados) e balanceamento (60 níveis) passaram. Play encerrado e arquivo salvo.
- Pendente: aprovação visual do piloto, custo mobile, CI do commit e remodelagem dos cinco restantes. Rollback: reverter bd68586 ou restaurar backup local pré-Climb.

### 28/11/2026 — Climb: direção mais fiel ao anime, mantendo R6
- Direção do criador: fidelidade à forma do anime dentro da linguagem Roblox. Referência principal: [ficha oficial](https://overlord-anime.com/_season2/character/). Amostra de imagens públicas de Anime Vanguards, Anime Adventures, Anime Defenders, ASTD X, Anime Last Stand e Anime Expeditions para leitura de silhueta/miniatura. Sem extração de assets desses jogos.
- Base f3a7b88. Backup local antes das alterações. Creator Store: [Blonde Anime Boy Hair](https://create.roblox.com/store/asset/377071938), gratuito, EM_EarlyMorning. Asset inserido em área temporária, inspeção sem scripts. Mesh 375815502 (Roblox) e textura 377071700 (EM_EarlyMorning) incorporados no cabelo; Hat/Camera de inspeção removidos. Armadura autoral com peitoral curvo e placas claras. Nenhum corpo completo importado.
- OverlordTowerModelBuilder (e1b9582), OverlordCharacterArtPass (1b5a647), relidos na main. Play cliente: preload de mesh e textura Success; 54 BaseParts contra 59 do piloto anterior, quatro estágios aplicados, testes internos 24 variantes/24 estágios de movimento/42 acertos simulados aprovados. Studio salvo localmente; captura ClimbAnime.png. Sem publicação no Roblox.
- Pendências: avaliação visual do criador, medição mobile, CI e cinco unidades restantes. Rollback pelos dois commits ou backup pré-Climb-anime.

### 28/11/2026 — Climb: revisão da silhueta
- A pedido do criador, reduzir a aparência quadrada do piloto. Base 3199162, backup local pré-silhueta verificado. Corpo arredondado sobre R6, ombreiras inclinadas, cintura mais estreita, luvas, joelhos, grevas, pés e rosto adaptados. Sem novo asset externo.
- Código na main: 7ef0174, 6daadf9, cd4a727. Conteúdo dos três arquivos relido. Studio salvo em Edit. Rollback: reverter esses commits em ordem inversa ou usar o backup.
- Cliente em Play aplicou os quatro estágios e acionou a animação com expressão Focus. Testes internos 24 variantes, 24 estágios de movimento, 42 acertos simulados passaram. Captura local ClimbForma.png mostra a geometria corporal antes do ajuste fino dos olhos/boca; captura final do Studio não renderizou o personagem. Avaliação visual final, CI, mobile e outros cinco personagens pendentes.
