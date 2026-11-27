# ANIME FISSURE — Salão da Babilônia
## Documento de design do Lobby de Relíquias · Conceito v1.1 / primeiro protótipo 3D · 26/11/2026

**Estado atualizado:** o primeiro **Salão da Babilônia 3D foi publicado** como protótipo procedural no GitHub, com 11 portais de armas originais, 5 vitrines 3D dos anéis e Gilgamesh como **modelo decorativo estático** com ProximityPrompt abrindo um **catálogo somente leitura**. A build e a exibição no Roblox Studio ainda não foram verificadas. Não existem equipamento persistente, reroll, drops ou evoluções executáveis no salão.

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

**Implantação 3D de protótipo — corrigida após inspeção dos NPCs existentes**:
- Edward e a oficina de alquimia já ocupam a direita do lobby (Edward em x≈301,z≈−8,5; oficina em x≈293,z≈5). Por isso a antiga planta dentro do piso, x275–312, foi **descartada por conflito espacial**.
- O salão passa a ser um **anexo na ala direita**, fora do limite leste do piso existente, mas conectado por uma ponte jogável.
- Piso do salão: centro `Vector3.new(347,0,19)`, largura ≈61 studs em X e 62 em Z; faixa x≈316,5–377,5, z≈−12–50.
- Ponte de acesso pela praça em x≈304–332, z≈14–26, sem atravessar Edward nem a oficina.
- Arco dourado de entrada em x≈318, z≈20. Gilgamesh está em um pedestal em x≈356, z≈20 e olha para o jogador que vem do oeste.
- Os **11 portais armados** ficam na parede do fundo (x≈374), em alturas e formatos variados; todos são decorativos sem colisão.
- As cinco vitrines distribuem-se nas bordas z≈−4 e z≈42, longe do corredor central.
- Piso de acesso e ponte possuem colisão; ornamentos, portais e armas não possuem colisão.

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

**Implementado**: `src/server/BabylonHallBuilder.luau` + `src/server/BabylonHall.server.luau` geram somente `Workspace.FissureLobby.BabylonHall` depois do spawn e do portal de missão carregarem, preservando `LobbySpawn`, `ArenaPortal` e remotes.

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
- **11 portais âmbar suspensos** com armas de estilos geek distintos, flutuando atrás de Gilgamesh; cada portal é não colidente, com brilho local suave.
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
- `src/client/RelicRingGallery.client.luau`: **catálogo visual agora disponível no lobby** por botão ou ProximityPrompt de Gilgamesh; previews 3D são renderizados localmente. Não oferece ações de inventário.
- `src/shared/RelicRingConfig.luau`: efeitos, elementos e regra Ainz imutáveis nesta etapa.
- `src/shared/OverlordEvolutionLootConfig.luau`: seis fases, sete materiais, cinco anéis dual-use.
- `src/server/TowerService.luau`: buffs e troca de anel Studio-only no combate.

**Integração entregue nesta revisão**:
1. `BabylonHallBuilder.luau` cria arquitetura, ponte, NPC decorativo, 11 portais, armas estilo geek e vitrines das cinco relíquias, sem tocar no sistema de missão.
2. `BabylonHall.server.luau` monta o salão depois de localizar `FissureLobby` e seus componentes.
3. `RelicRingGallery.client.luau` abre catálogo 3D somente leitura pelo botão do lobby ou ProximityPrompt.
4. `BabylonHallVFX.client.luau` faz cintilação local de portais, limitada a 4 superfícies no touch e 9 no PC; sem atualização constante por frame.
5. `BabylonHallSmokeTest.server.luau` faz checagens de cena no Studio, sem alterar os sistemas já existentes.

**Próximas etapas reais**:
1. Transformar a versão decorativa estática de Gilgamesh em um rig animável com aparência premium, após playtest da silhueta.
2. Transformar o catálogo em painel definitivo com outras abas; equipar/evoluir/reroll devem aguardar inventário e servidor.
3. Testar colisões, portal das missões, iluminação, FPS e UI no Roblox Studio/Android.
4. Revisar licenças de referências geek antes de uma publicação pública.

**Performance**:
- Construir arquitetura com blocos/meshes reutilizáveis, ancorados; ornamentos não colidentes.
- Distância de renderização dos portais ornamentais e animação em LOD; evitar 5 partículas contínuas por portal × todos os jogadores.
- No mobile, meta de projeto: visual bonito sem comprometer combate; preferir poucas luzes, baixo overdraw e animações locais.
- Interações ProximityPrompt sempre acessíveis em toque, gamepad e PC.
- Separar colisão de piso, paredes e ornamentos; portais ilustrativos não teletransportam ninguém.
- UI com UIScale, rolagem e estados legíveis em telas pequenas.

## 8. Checklist de aceitação para implementação futura

- [x] Hall montado como anexo à direita, com ponte e sem alterar o portal/spawn em código (**pendente playtest de navegação**).
- [x] Protótipo **estático** de Gilgamesh em ouro/rubi criado (rig premium e animação ainda pendentes).
- [x] Prompt conectado ao catálogo visual do cliente (teste interativo em Studio ainda pendente).
- [x] Cinco pedestais com os cinco modelos 3D exatos, usando RelicRingModelBuilder.
- [x] Catálogo 3D em modo somente leitura implementado (teste em Studio pendente).
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
