# ANIME FISSURE — Auditoria de design e implementação

**Consolidado em 22/11/2026**. Base: decisões do projeto discutidas com o criador e arquivos da branch `main` revisados neste dia, até a beta de Towers v1.1.

**Significado das classificações**
- **[BETA NO CÓDIGO]**: existe lógica ou visual publicado no GitHub, mas não implica aprovação em Roblox Studio.
- **[CATÁLOGO/ESPECIFICAÇÃO]**: regra ou conteúdo definido, ainda sem execução completa.
- **[PENDENTE]**: precisa de implementação ou decisão de design.
- **[DIVERGÊNCIA]**: o protótipo atual não corresponde integralmente ao comportamento pedido.
- **[NÃO TESTADO]**: falta teste real de Roblox Studio, de dispositivo, de DataStore, de multiplayer e de desempenho. Build Rojo sozinho não aprova a jogabilidade.

## 1. Visão, pilares e regras já decididas

- Nome do jogo: **Anime Fissure**. Tower Defense de crossover de animes, projeto solo para PC e mobile, estética **Anime Arcade**, visual de personagens estilizados, não estilo KoGaMa.
- Arena de porte médio; solo ou coop até **4 jogadores**. Jogo não impõe limite global de unidades simultâneas, apenas limites **por unidade**, salvo decisões de balanceamento futuras.
- **Deck de 6 unidades**, sem unidade repetida no mesmo deck; duplicatas entre jogadores são permitidas. **Três decks salvos**, arrastar para reordenar, favoritos/cadeados e duplicatas como instâncias separadas.
- Formação sugerida do deck: **1 Farm, 1 Buffer, 1 Controle, 3 Dano** — orientação de composição, não bloqueio obrigatório.
- **Classic: 15 waves**; **Hard: 20 waves**; desafios variáveis e **Challengers** planejados.
- **3 HP de base**, vazamento normal **-1 HP**, chefe principal pode causar derrota imediata; sem cura passiva da base.
- **700 Yen** iniciais por partida; Yen dentro do combate, **Gold fora da partida**. Venda: **50% do total investido** (incluindo upgrades).
- Wave manual por votação, Auto Start individual; 1×/2× grátis, 3× para líder com gamepass (beneficia todo grupo); sucessão de liderança prioriza detentor do passe.
- Reconexão até **3 minutos**; ao desconectar, suas unidades são removidas, conforme acordo. Tela final **30s** com Continuar / Sair / Avançar; sem resposta → lobby. Auto Replay desligado por padrão.
- HUD: centro livre, painel superior de wave/base/recursos, barra inferior expansível, seleção e prévia; cursor deslocado em mobile; painel de Upgrade e MAX, venda com confirmação e aba Habilidades com estado pronto.
- **Stage Info** no local da referência do usuário, contendo fase, elemento, inimigos que aparecem, Gold, XP, itens especiais, pity e ✔ de obtido sem apagar o pity para o próximo drop.

## 2. Estado atual no GitHub (Beta v1.1)

| Módulo | Situação | Evidência |
|---|---|---|
| Mundo inicial Overlord | [BETA NO CÓDIGO] | `src/shared/StoryConfig.luau`: seis fases descritas |
| Lobby, Virgil e Edward | [BETA NO CÓDIGO] | `BetaLobby.server.luau`, `BetaLobby.client.luau`, `NPCResidents.server.luau`, `LobbyAtrium.server.luau` |
| Seleção de mundos/fases | [BETA NO CÓDIGO] | `LobbyStageConfig.luau`; somente `OVL_01` jogável |
| Carne Village / waypoints / base | [BETA NO CÓDIGO] | `BetaMap.server.luau`, `EnemyService.luau` |
| Boss Capitão, Nigun e invocações | [BETA NO CÓDIGO] | `BossConfig.luau`, `BossService.luau` |
| Classic / Hard | [BETA NO CÓDIGO] | `GameConfig.luau`, `MatchService.luau`, `Main.server.luau` |
| Stage Info / HUD | [BETA NO CÓDIGO] | `BetaHUD.client.luau`, `StageIntelPanel.luau`, `StageInfoConfig.luau` |
| Towers: posicionamento / alvo / dano / venda / upgrade | [BETA NO CÓDIGO] | `TowerService.luau`, `TowerConfig.luau`, `TowerHUD.client.luau` |
| Deck configurável e persistido | [PENDENTE] | Apenas barra visual de seis slots e três slots preenchidos |
| Summon e coleção persistida de Capsule | [BETA NO CÓDIGO] | `SummonService.server.luau`, `SummonProfileStore.luau` |
| Farm de Capsule e upgrades | [BETA NO CÓDIGO] | `CapsuleUnitConfig.luau`, `TowerService.luau` |
| Artes/modelos das Towers definitivas | [PENDENTE] | Modelos atuais feitos em Parts procedurais |
| Relíquias, inventário, alquimia e evolução jogável | [PENDENTE] | `RelicIndexConfig.luau` como catálogo, oficina visual e snapshot sem crafting |
| Recompensas Gold/XP/drop raro persistente | [PENDENTE] | `StoryRewardConfig.luau` calcula valores, mas não entrega |
| Traits e motor de efeitos | [PENDENTE] | Não há sistema de Traits equipáveis nem pipeline DOT/crit/elemental em `TowerService.luau` |
| Coop completo, desconexão/reconexão, resultado, velocidade | [PENDENTE] | Regras em configs; servidor beta opera com entrada/trava de uma partida |
| Playtest, performance, testes de dados e devices | [NÃO TESTADO] | GitHub não executa uma sessão Roblox Studio |

### Towers que existem agora

| Unidade | Papel | Base | Observação |
|---|---|---|---|
| `FissureBlade` / Espadachim da Fissura | Dano físico | ¥220; 40 dano; 0,90 SPA; alcance 23 | Protótipo original temporário; 3 upgrades |
| `FissureMage` / Arcanista da Fissura | Dano mágico | ¥320; 85 dano; 1,80 SPA; alcance 29 | Protótipo original temporário; 3 upgrades |
| `Capsule` lendária | Farm | ¥500; ¥700/wave; 8 upgrades; máx. 3 | Exige posse no perfil de Summon; visual de máquina ainda provisório |

Essas três unidades ocupam os três primeiros slots **apenas como deck de demonstração**, não substituem os três decks salvos acordados.

## 3. Sistema de combate acordado versus atual

### Elementos, efeitos e resistências

**[CATÁLOGO/ESPECIFICAÇÃO]:**
- Dano físico, mágico, reações elementais e vulnerabilidades coexistem.
- Resistência/vulnerabilidade por elemento, com compensação direta quando são do mesmo elemento. Resistência normal máxima acordada: **50%**; **90%** e vulnerabilidades excepcionais reservadas a Challengers.
- Escudo absorve dano antes de HP, com exceções especificadas em habilidades.
- Crítico baseado em multiplicador. Alguns ticks de DOT podem critar **somente quando a habilidade declarar isso**.
- DOT: instâncias independentes e acumuláveis (dano por tick e frequência); mesma categoria de bônus soma, categorias diferentes multiplicam.
- Buffs/debuffs precisam de limite de empilhamento e ordem de cálculo; suporte afeta a equipe toda.
- Chefes ganham resistência progressiva a controle; regeneração ou interrupção apenas por habilidade específica. Bosses com fases, aviso de habilidade e comportamento adaptativo.
- Arquétipos de inimigo principal e secundário modificam HP, escudo e atributos; regeneração apenas HP.

**[BETA NO CÓDIGO]:** ataques diretos físico/mágico, seleção automática de alvo avançado no caminho, resistência física em bosses/elite, HP e habilidades específicas de bosses.

**[PENDENTE]:** pipeline extensível de ataque, DOT, crítico, área/AoE, elemento, reação, controle, buff, suporte, escudo normal, prioridade configurável de alvo, habilidades ativas/passivas e ataques com animação.

**Ponto de alinhamento:** o conceito geral discutia mudança de fase de boss a aproximadamente **50% de HP**, mas `Nigun` em `BossConfig.luau` usa **40%**. Pode ser uma exceção de personagem; não alterar sem decidir.

### Traits — uma por unidade; raridade não determina melhor sinergia

| Raridade | Trait | Efeito acordado |
|---|---|---|
| Common | Force | +10% dano |
| Common | Quickdraw | -8% SPA |
| Common | Eagle Eye | +10% alcance |
| Rare | Precision | +10 p.p. chance crítica e +20% multiplicador |
| Rare | Venom | +25% DOT |
| Rare | Scavenger | +15% Yen |
| Epic | Executioner | +30% dano contra inimigos abaixo de 30% HP |
| Epic | Rupture | +40% DOT e +15% frequência |
| Epic | Deadeye | +20 p.p. chance crítica e +35% multiplicador |
| Mythic | Godspeed | +25% velocidade de ataque |
| Mythic | Golden | +30% dano; para unidades econômicas, +25% renda |
| Mythic | Arcanist | +75% DOT e +25% frequência |
| Mythic | Transcendent | Especializada em elementos/sinergias; definição exata pendente |
| Secret | Unique | +250% dano; sem bônus DOT |

**Pendências:** reroll usa recurso exclusivo; aviso para Legendary/Mythic/Secret; sem aumento do custo de colocação. Faltam taxas de reroll, limites de acumulação e sistema de equipar/salvar/aplicar na Tower. A trait adequada depende da mecânica da unidade, não apenas da raridade.

## 4. Economia, coleção, Summon e evolução

### Capsule (família Bulma)

A especificação mais recente **substituiu a ideia antiga de ¥500 por wave**: a lendária agora dá **¥700 por wave**, custa **¥500 para colocar**, tem **8 upgrades** e **3 colocações**. Crescimento da renda por melhoria: +40% em geral, +70% nas melhorias 4 e 8; primeira melhoria ¥540, seguintes multiplicador 1,40 sobre o custo anterior. Invenções nos upgrades 4 e 8 com bônus de +20% cada conforme configuração.

A **Capsule (Corp)** mítica tem **¥1200 por wave**, 12 upgrades, limite 1 e **somente por evolução**, nunca no banner. Custo/curva de upgrades míticos ainda não definidos. Normal/Shiny da lendária vêm do Summon e a evolução conserva Shiny. Item **Money Capsule** planejado como relíquia exclusiva: -30% custo de colocação e +50% renda daquela unidade.

**Hoje implementado:** parte da configuração econômica da Capsule e aplicação dos upgrades na renda, posse via Summon e colocação. **Falta:** evolução realmente transacionada, modelo humano/roupas Bulma, shiny próprio, troca visual em níveis, aparelhos/invenções conectados ao modelo colocado, equipar relíquia, animações, desejo das Esferas do Dragão (7 esferas / uma escolha global por partida entre Poder e Dinheiro, conforme ideia anterior; rever compatibilidade com o sistema atual).

**Observação:** `TowerModelBuilder` usa um modelo de fábrica/terminal para Capsule, não os modelos Bulma 3D que idealizamos; já existe `CapsuleVisualService` para invenções, mas `TowerService` não o aciona nas melhorias.

### Summon, coleção, decks

**[BETA NO CÓDIGO]:** `SummonConfig` tem banner de **somente Capsule**; Summon Tickets são 25 temporários **apenas no Studio** e 0 no jogo publicado até existir fonte legítima; a taxa Shiny de 1% é provisória, sem pity Shiny. `SummonProfileStore` salva a coleção de unidades e Tickets e mantém duplicatas com `Uid`.

**[PENDENTE]:** coleção com filtros e favoritos/cadeado, três decks com 6 unidades e drag-and-drop, selecionar uma instância exata por `Uid`, atributos persistidos por instância (nível, Trait, Shiny, evolução), gestão de duplicatas e uso de unidades futuras no banner. A permissão de Summon **não** deve ser automaticamente ampliada ao criar uma Tower; origem e raridade precisam ser aprovadas.

### Recompensas / drops / pity / inventário

Carne Village, segundo `StoryRewardConfig`:
- Classic: **150 Gold, 3 fragmentos, 8% Insígnia Solar**, bônus da primeira vitória de 100 Gold.
- Hard: **240 Gold, 5 fragmentos, 12% Insígnia Solar**, bônus da primeira vitória de 150 Gold.
- **Pity 15 vitórias elegíveis** compartilhado entre Classic e Hard, no mesmo item.
- Derrota: até 20% do Gold normal, sem item raro.
- XP ainda **não configurado**. `StageInfoConfig` informa elemento da fase **não definido**.
- Backend persistente para concessão/posse/pity de itens **ainda não existe**; Stage Info exibe `--/15` e só simula o ✔ no Studio. A marca ✔ precisa permanecer visível após obter o item, enquanto novo ciclo de pity continua.
- O **Anel da Restrição (0/10)** foi exemplo do usuário para formato de Stage Info, mas **não é o item oficial atualmente cadastrado para Carne Village**; validar futuro mapa/raridade antes de adicioná-lo.
- `RelicIndexConfig` lista 7 relíquias com `Availability = "Planned"`. Catálogo não significa estoque, crafting ou buffs funcionais.

## 5. Lobby, mapas, waves, coop e HUD

**[BETA NO CÓDIGO]**
- Lobby com portal de missões, Virgil/Edward e decoração; 6 fases de Overlord no catálogo. Somente OVL_01 tem mapa e inimigos jogáveis.
- Carne Village com trilha de oito waypoints, portal, base, casas, plantações e detalhes. Inimigos comuns e bosses têm modelos procedurais; sem importação profissional de malhas.
- Stage Info integrado ao HUD, com inimigos/dificuldade/recompensas da configuração. Mini-boss wave 10; Nigun wave 15/20.
- Interface de Towers tem seis slots visuais, dois de dano de teste + Capsule condicionada à posse, botão de upgrade unitário e venda instantânea. Velocidade 1×/2×/3× está apenas em configuração.
- Antes da primeira wave, o protótipo concede **24 segundos de preparação** e permite Skip.

**[PENDENTE]**
- Menu real de coleção e deck; seleção/equipamentos entre partidas, preservação do deck, três slots restantes.
- Auto Start individual, votação manual como padrão e política de começar wave; atualmente **a wave 1 inicia sozinha após 24s** — **[DIVERGÊNCIA]** em relação à ideia de início manual por votação.
- Troca de decks apenas antes da primeira wave, quando permitido; não durante a batalha.
- Upgrade **MAX**/aba Habilidades/indicador de cooldown, confirmação antes da venda, modo de priorização de alvo, controle de arrastar/arrumar posição, feedback de alcance válido/inválido.
- **Cursor deslocado no mobile**: o protótipo de toque mira diretamente na posição pressionada, diferente da regra já combinada.
- Coop real de até 4, fila/líder, sucessão do 3×, estado de jogador desconectado, limpeza das Torres e reconexão de 3 minutos. Hoje o lobby usa uma partida por servidor sem fila coop operacional.
- Modo Challenges/Challengers, três níveis de velocidade aplicados ao movimento e ataque, resultado 30s, avançar de mapa, saída, retorno ao lobby e auto replay.
- Mais cinco mapas de Overlord ainda não construídos, outros mundos de animes planejados.
- Testes de performance em celular com efeitos especiais, modelos 3D e gerenciamento de número de Parts.

## 6. Riscos técnicos e alinhamentos antes de produzir grande lote de Towers

### P0 — validar protótipo no Roblox Studio

- Abrir a última build da branch `main` e confirmar que Rojo realmente gerou `.rbxlx`.
- Testar fluxo **Lobby → Carne Village → 24s de preparação → Tower → combate → boss → vitória/derrota**, em Classic e Hard.
- Verificar output de erros Luau, ataques que acertam HP real, venda, custo, status do Summon, visibilidade de GUI, toque em celular, compatibilidade de câmera, overhead de emissões e pathfinding.
- O CI atual **somente confirma presença de arquivos e compila via Rojo**. Não executa testes automatizados de unidade, testes integrados nem Play Roblox Studio. Não confundir [BETA NO CÓDIGO] com verificado.

### P1 — arquitetura mínima para futuras Towers com personalidade

Criar um contrato extensível em `TowerConfig`, `TowerService` e módulos específicos:
1. Identidade: `Id`, nome, anime/mundo, forma/evolução, raridade, método de obtenção, Shiny, modelo e animações.
2. Deck/economia: custo, limite individual, nível, upgrades, venda, tipo de posição `Ground/Air/Hybrid`.
3. Combate: tipo de dano, elemento, alvo `Single/AoE/Line/Cone`, targeting, range, SPA, crit, dano e prioridade de escudos.
4. Efeitos: DOT, duração, ticks, stacking, slow/stun, buffs/debuffs, resistência elementar e reações.
5. Skills: passivas/ativas, cooldown, gatilhos, efeitos visuais, interrupções e regras especiais de boss.
6. Persistência e teste: `Uid` da unidade, Traits e relics equipadas, logs de dano, testes de regressão.

Assim cada personagem pode ter sua própria habilidade **sem refazer o motor inteiro**.

### P2 — sistemas do metagame e experiência completa

Persistência de Gold/XP/itens/pity, coleção e 3 decks, Traits, relics, evolução, progressão das seis fases, coop, reconexão, resultados, Auto Replay e monetização de velocidade.

## 7. Decisões/ajustes que precisam ser claros quando a próxima Tower chegar

A ficha da próxima Tower deve especificar, no mínimo:
- **Personagem e anime de origem**, forma básica, raridade e se é versão evoluída/alternativa.
- **Função principal**: Dano, Farm, Buff, Controle ou Híbrida; terrestre/aérea/híbrida.
- **Método de obtenção**: Summon, drop, evolução, missão ou evento, sem desbloqueio gratuito involuntário.
- **Ataque inicial**: custo, dano, SPA, range, tipo físico/mágico/elemental, alvo single/AoE/linha e limite de colocações.
- **Upgrades**: quantidade, preço, aumento de stats, habilidades e mudanças visuais.
- **Skills especiais**: passivas/ativas, cooldowns, status, gatilhos e interação com DOT/crítico/elementos.
- **Sinergias**: Traits preferenciais, relíquias permitidas, buffs/controle com outros personagens.
- **Animações**: visual normal/Shiny, VFX e simplificações necessárias para celular.
- **Exceções**: interação com bosses, invulnerabilidade, shields, traits Unique e desafios.

Não é obrigatório resolver cada valor numérico antes de começar o primeiro design. É obrigatório separar valores **aprovados** de placeholders de teste.

## 8. Decisão da auditoria

**PODEMOS COMEÇAR AS NOVAS TOWERS AGORA.**

O motor v1.1 é base suficiente para **protótipos de ataque simples** e já dispõe de integração com inimigos, HP, Yen e GUI. Para novas Towers com poderes de anime, recomendamos implementar **conjuntamente** um sistema de habilidades modular, depois DOT, crítico e elementos; não é necessário aguardar coop e inventário completos para começar a desenhar as unidades.

A dívida que pode bloquear lançamento público, mas **não o design de personagens**, é: Playtest real, save/persistência da progressão, deck real, correção dos fluxos de wave e resultados.

**Prioridade recomendada:** ficha da primeira Tower nova → módulos de habilidades e targeting → protótipo no GitHub → teste em Studio → ajuste de dano/custo/efeitos → arte 3D/animação → integração ao Summon/coleção quando a origem for validada.
