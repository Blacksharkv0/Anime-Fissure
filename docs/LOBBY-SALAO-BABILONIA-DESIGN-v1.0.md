# ANIME FISSURE — Salão da Babilônia
## Documento de design do Lobby de Relíquias · Conceito v1.0 · 26/11/2026

**Estado: proposta de design, não implementação 3D no Roblox Studio.** O projeto já possui os cinco modelos de anéis em laboratório e seu sistema de efeitos no combate de teste; este documento define a futura **área permanente de NPC e UI do lobby**, sem alterar os scripts executáveis nesta entrega.

## Visão

Uma joalheria imperial impossível, comandada por **Gilgamesh (Fate)**, o Rei dos Tesouros. O jogador entra por um corredor dourado saindo do lobby azul-neon de Anime Fissure, atravessa um arco de pedra negra com runas e se vê diante do mestre das relíquias, de cinco vitrines mágicas e de portais radiantes abertos como um leque. O salão deve comunicar três coisas de imediato: **valiosidade, poder e clareza de interação**.

**Nome de exibição**: SALÃO DA BABILÔNIA  
**NPC**: Gilgamesh — Mestre das Relíquias  
**Fantasia principal**: o rei inspeciona, revela e autentica tesouros de vários animes; não é o dono literal dos equipamentos do jogador.  
**Direção artística**: anime stylized / Roblox Studio 3D premium, ouro, ônix, rubi, púrpura e luzes azul-elétricas em pequenos detalhes para manter unidade com a marca Anime Fissure.

## 1. Referências de identidade — sem importar assets de terceiros

Versão principal escolhida: Gilgamesh em armadura clássica dourada, cabelo loiro espetado, olhos vermelho-rubi, peitoral em placas angulares, ombreiras largas, tecido vermelho escuro, expressão de superioridade e postura régia. Preservar **silhueta reconhecível**, mas adaptar peças e proporções a um NPC Roblox 3D.

Não usar modelos raspados de jogos, meshes/texturas de origem desconhecida, avatares de catálogo de outros usuários sem checar licença, nem copiar arquivos 3D de obras. Referências visuais para artistas/modeladores não concedem autorização comercial. Antes de publicar personagens de Fate no jogo público, revisar direitos/licenças; alternativa publicável é criar uma versão original do "Rei do Tesouro" com identidade própria.

**Três abordagens de visual:** NPC padrão econômico, NPC premium recomendado, estátua/ícone monumental. Ver `docs/GILGAMESH-NPC-PROMPTS-ROBLOX-v1.0.md`.

## 2. Planta sugerida no lobby atual

Inspecionado em `src/server/BetaLobby.server.luau`:
- Centro do lobby: `CENTER = Vector3.new(260,0,0)`.
- Piso existente: 110 × 110 studs, limites aproximados de x205–315, z−55–55.
- Portal de missões: posição relativa (0,10,−38).
- Spawn do jogador: posição relativa (0,0.5,+25).
- Outro script não deve destruir, mover ou sobrescrever `Workspace.FissureLobby`.

**Implantação planejada** (posições em studs, apenas sugestão, não world parts prontas):
- Ala direita para o jogador que sai do spawn olhando o Portal de Missões (sentido −Z).
- Área: faixa aproximada x=275…312 e z=−22…20, contida dentro do piso atual.
- Entrada/portal arquitetônico do salão: x≈275, z≈+15.
- Átrio central e espaço livre de circulação: x≈287, z≈+6.
- Pedestal de Gilgamesh: x≈298, z≈−3, NPC olhando para o corredor de chegada (direção −X).
- Cinco vitrines de anéis: semicírculo de pedestais nas bordas, sem bloquear a frente do NPC.
- Arco do tesouro e portais dourados decorativos: atrás do NPC, direção +X, sem bloquear o piso.
- Rota transitável de largura desejada >= 8 studs, sobretudo para mobile e quatro jogadores.

### Planta funcional, não em escala

    [CENTRO DO LOBBY]               [ALA DIREITA: SALÃO DA BABILÔNIA]
         Portal das Missões
                  |
              praça azul ---- arco imperial ---- catálogo 3D
                  |                         \
           Lobby Spawn                      vitrines (5 anéis)
                                             |            |
                                        Gilgamesh     altar de evolução
                                             |
                                         tela de relíquias

**Observação**: tudo deve ser construído em modelo filho separado de `FissureLobby` (ex.: `RelicHall`), com script de construção independente que aguarda o lobby estar pronto. Respeitar o Spawn e o MissionBoardPrompt existentes.

## 3. Arquitetura e direção de arte

### Entrada — Portão da Babilônia
- Arco negro-dourado com entalhes geométricos originais, não decals copiados.
- Letreiro legível em PC e celular: "SALÃO DA BABILÔNIA".
- Pequeno tapete rubi e duas colunas com gemas.
- Transição de luz azul do lobby para luz dourada/âmbar do salão.

### Salão principal
- Piso de placas de ônix com filigranas douradas, reflexos moderados.
- Paredes ou molduras semiabertas que não causem clipping na câmera Roblox.
- Trono opcional atrás do NPC: **Gilgamesh deve ficar em pé**, destacado do fundo, acessível pela frente.
- 5 portais âmbar suspensos, não colidentes; um arco central maior se destaca.
- Céu/paredes não devem ser tomados por efeitos; permitir leitura rápida de NPC e botões.
- Duas salas funcionais representadas por ornamentos, não por loadings distintos: **Relíquias** (esquerda) e **Evolução** (direita).

### Vitrines: conservar o visual dos anéis aprovados

| Anel | Cor | Identidade | Efeito quando equipado em quem NÃO é Ainz |
|---|---|---|---|
| Magic Power | Roxo / ouro | ametista, runas e portal místico | +20% dano mágico para unidades Magic |
| Dano Físico | Rubi / aço | garras de metal, pedra vermelha | +20% dano físico para unidades Physical |
| SPA | Ciano / prata | relógio e ponteiros luminosos | SPA ×0,80 (ataque mais frequente) |
| Range | Verde / prata | esmeralda e mira geométrica | Range ×1,20 |
| Restrição | Vermelho escuro / violeta | núcleos gêmeos e correntes | Dano ×2 e SPA ×2 |

**Importante**: esses cinco anéis são simultaneamente **Relíquias e Materiais de Evolução de Ainz**. Equipados no Ainz **não produzem o efeito normal**. O item da evolução da Shalltear e o da Albedo **não são anéis**, e permanecem em suas vitrines/catalogação de evolução à parte.

Os cinco modelos 3D de anéis já têm builder de Studio em `src/shared/RelicRingModelBuilder.luau`; o salão deve **reutilizar os mesmos IDs**: MagicPowerRing, PhysicalDamageRing, SPARing, RangeRing, RestrictionRing.

## 4. Gilgamesh — NPC e atuação

### Aparência escolhida (premium)
- Rig proporcional Roblox R15 estilizado ou rig customizado equivalente; não usar formato blocky puro como versão final.
- Cabelo amarelo-ouro com mechas modeladas em ponta, olhos rubi, sobrancelhas marcantes, sorriso sutilmente presunçoso.
- Ombreiras grandes, armadura em camadas douradas, roupa interna índigo quase preta e tecido rubi pendendo da cintura.
- Silhueta destacável de longe; cerca de 1,15× um avatar Roblox padrão em dimensão visual.
- Detalhes densos apenas no torso e nas ombreiras, sem 100 partes minúsculas por armadura.
- Materiais sugeridos: Metal, SmoothPlastic, Glass e Neon somente nos acentos. Poucos PointLights.

### Animação de lobby (planejada)
1. Idle: respiração quase imperceptível, um pé à frente, queixo erguido.
2. Aproximação: Gilgamesh vira os olhos e inclina a cabeça.
3. Interação: braço direito estendido, dois pequenos portais abrem atrás dele.
4. Inspeção de relíquia: anel holográfico flutua sobre a mão.
5. Evolução (futura): círculo dourado no chão, portal atrás do NPC, pulso de luz + confirmação.

Evitar repetição incessante de partículas: efeitos pontuais e leves, com animação somente quando houver jogador próximo.

### Falas originais sugeridas
- Abertura: "Hmph. Vejo que chegou alguém interessado nos tesouros deste rei."
- Catálogo: "Olhe com atenção. Cada relíquia cobra respeito de quem a carrega."
- Anel da Restrição: "Deseja mais poder? Então suporte o peso da demora."
- Ainz: "Esses anéis têm um propósito maior para o soberano dos mortos."
- Item ainda não obtido: "Um tesouro não se conquista com pressa."

Falas são criação original para Anime Fissure, não transcrições de Fate.

## 5. Fluxo de interação / interface

**Entrada**: `ProximityPrompt` próximo ao NPC (PC tecla E, gamepad X, toque mobile), com `ObjectText = "GILGAMESH • MESTRE DAS RELÍQUIAS"` e `ActionText = "ABRIR TESOURO"`. Abertura e validações no servidor; HUD do cliente somente exibe dados que o servidor autoriza.

**Tela principal**: SALÃO DA BABILÔNIA  
Painel em duas colunas, carrossel de anéis e visualizador 3D, escalável.

    +-----------------------------------------------------------+
    | SALÃO DA BABILÔNIA          GILGAMESH            [X]      |
    |-----------------------------------------------------------|
    | CATÁLOGO | EQUIPAR | EVOLUIR | REROLL | INFORMAÇÕES        |
    |-----------------------------------------------------------|
    | [lista de itens] | [modelo 3D do item selecionado]         |
    |                   | Nome / tipo / bônus / mapa / posse      |
    |                   | Efeito no Ainz: inativo                 |
    |-----------------------------------------------------------|
    |                 STATUS REAL DO JOGADOR                     |
    +-----------------------------------------------------------+

### CATÁLOGO — fase 1
- Lista dos cinco anéis + materiais de evolução exclusivos de Shalltear/Albedo.
- Seleção gira o modelo 3D existente no ViewportFrame.
- Detalhes: benefício, origem, elemento elegível, penalidade do Restrição, papel no Ainz.
- Nunca declarar "Obtido" baseado no laboratório; usar "Posse ainda não conectada" enquanto não existir inventário persistente.

### EQUIPAR — fase 2
- Selecionar uma unidade **realmente possuída** e um item **realmente possuído**.
- Um slot de anel por Tower é o comportamento atual de laboratório, passível de revisão antes do lançamento.
- Mostrar comparação antes/depois de Dano/SPA/Range com cálculo do servidor.
- Ainz exibe aviso "BÔNUS DESATIVADO NO AINZ • material para evolução".
- Se o inventário não estiver implementado, botão **bloqueado** em produção, com explicação clara. No Studio já existe `EquipRelic` temporário no HUD de combate; não confundir esse comando com equipamento persistente.

### EVOLUIR — fase 3
- Escolher Ainz, Shalltear ou Albedo quando suas evoluções estiverem prontas.
- À direita, slots dos materiais necessários, cada qual com contagem real e status.
- Fórmulas/quantidades e evolução definitiva ainda **não aprovadas**. Não criar receita fictícia nem executar consumo nesta fase de design.
- "Iniciar evolução" somente habilitar após backend validar posse, materiais, requisitos e transação.

### REROLL DE RELÍQUIAS — fase 4
- Reusar a moeda de reroll de relíquia **já planejada**, sem misturar com reroll de Traits.
- Atributos rerroláveis, custos, limites, chance e proteções ainda não definidos.
- Mostrar botão desativado até existir contrato de dados real, distinto do protótipo de anéis fixos.

### INFORMAÇÕES — fase 5
- Tutorial curto sobre Magic/Physical, porcentagens, SPA menor = mais rápido, e Restrição: Dano ×2 / SPA ×2.
- Lista de origens por fase e regra de que o mesmo anel pode servir como relíquia OU material de evolução, sem duplicação automática.

## 6. Estados e comunicação honesta

Quatro estados visuais para cada item:
- **Não conectado** — inventário ainda não existe; exibir status neutro, sem dado de posse.
- **Bloqueado** — item inacessível por requisito real, caso esse requisito exista.
- **Disponível** — confirmado pelo servidor como possuído.
- **Equipado** — confirmado pelo servidor no slot da unidade.

**Não mostrar obtido / chance / pity** onde o backend ainda não tem tais dados. O Hard de Carne Village é destino do Anel de Magic Power no planejamento, **não drop habilitado nesta beta**.

## 7. Contratos técnicos e desempenho mobile

Código atual consultado:
- `src/server/BetaLobby.server.luau`: gera `Workspace.FissureLobby`, respawn e Portal das Missões; **não modificar o fluxo do lobby/arena** para adicionar o salão.
- `src/client/RelicRingGallery.client.luau`: laboratório de previews existente **apenas no Studio**, deve se tornar a base da aba CATÁLOGO, não ser removido.
- `src/shared/RelicRingConfig.luau`: efeitos, elementos e regra Ainz imutáveis nesta etapa.
- `src/shared/OverlordEvolutionLootConfig.luau`: seis fases, sete materiais, cinco anéis dual-use.
- `src/server/TowerService.luau`: buffs e troca de anel Studio-only no combate.

**Plano de integração futuro**:
1. Criar `src/server/BabylonHall.server.luau` após o lobby estar pronto, construindo só `Workspace.FissureLobby.RelicHall` e prompt, sem mexer em `LobbyRemotes.EnterArena`.
2. Criar `src/shared/BabylonHallConfig.luau` para posições propostas, paleta, NPC e estados de tela.
3. Criar `src/client/BabylonRelicHUD.client.luau` para a tela de catálogo e diálogo com NPC.
4. Reutilizar os `RelicRingPreviewModels` de Studio para protótipo; em produção, disponibilizar modelos visuais com política de desempenho validada.
5. Em etapa separada, criar inventário persistente real, serviço de equipar seguro, reroll e receitas de evolução.
6. Testar em PC, Android e coop no Studio; o salão deve ficar visível para jogadores que ainda não entraram na arena.

**Performance**:
- Construir arquitetura com blocos/meshes reutilizáveis, ancorados; ornamentos não colidentes.
- Distância de renderização dos portais ornamentais e animação em LOD; evitar 5 partículas contínuas por portal × todos os jogadores.
- No mobile, meta de projeto: visual bonito sem comprometer combate; preferir poucas luzes, baixo overdraw e animações locais.
- Interações ProximityPrompt sempre acessíveis em toque, gamepad e PC.
- Separar colisão de piso, paredes e ornamentos; portais ilustrativos não teletransportam ninguém.
- UI com UIScale, rolagem e estados legíveis em telas pequenas.

## 8. Checklist de aceitação para implementação futura

- [ ] Hall no canto direito sem interceptar portal/spawn atuais nem bloquear caminhada.
- [ ] O Gilgamesh tem silhueta ouro/rubi legível e pose de rei.
- [ ] Prompt abre painel em PC/mobile/gamepad, não emite recompensa.
- [ ] Cinco pedestais representam os cinco anéis exatos, com mesma cor e nomenclatura da RelicRingConfig.
- [ ] Aba catálogo abre previews 3D sem conceder itens.
- [ ] Ainz não recebe bônus normais dos anéis, em nenhum estado.
- [ ] Restrição continua +100% dano e +100% SPA (multiplicadores 2×/2×).
- [ ] Shalltear/Albedo têm materiais próprios, não anéis.
- [ ] Equipar / Evoluir / Reroll aparecem bloqueados até serviço real ser implementado.
- [ ] Nenhuma modificação no Summon, ArenaRequested, Yen, drops/pity, DataStore ou combate é necessária para o **layout**.
- [ ] Cliente mobile mantém FPS aceitável com o salão aberto.
- [ ] Revisar direito de uso de Gilgamesh/Fate antes de publicar projeto comercial.

## 9. Decisões ainda abertas

- Utilizar modelo autoral inspirado em Gilgamesh ou obter licença para o NPC de Fate no lançamento público.
- Rig R15 / customização 3D definitiva e animações profissionais.
- Se a evolução de Ainz consome um de cada anel ou alguma combinação/quantidade.
- Se as relíquias poderão ser equipadas em unidade da coleção fora da partida (preferível) ou somente em Towers posicionadas (modelo de teste atual).
- Regras e custos de reroll, limite de relics por unidade, filtros de classe e UI de inventário.
- Posicionamento definitivo do hall após revisão visual no Roblox Studio.

**Próximo passo de execução recomendado:** fazer primeiro a área física decorativa e Gilgamesh de laboratório, seguida do NPC com CATÁLOGO 3D funcional (somente leitura). Só depois abrir ações que precisam de persistência ou consumo de itens.
