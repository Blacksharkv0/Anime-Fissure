# Anime Fissure — Pesquisa e habilidades de Overlord v0.1

**Pesquisa e primeira proposta:** 22/11/2026. **Estado:** DESIGN PROPOSTO, ainda não é gameplay. O catálogo de propostas programáticas está em **src/shared/OverlordAbilityDesign.luau**. O elenco/raridades aprovado pelo criador está em **src/shared/OverlordUnitRoster.luau**.

> AVISO DE SPOILERS: inclui técnicas reveladas nos volumes posteriores da light novel, especialmente **True Nail Clipper** de Brain. O material oficial do anime determina as identidades dos personagens; informações específicas de habilidades foram cruzadas com artigos de referência de fãs que citam episódios e light novels. Os valores propostos abaixo **não são estatísticas canônicas de Overlord**.

## Como diferenciar canon, proposta e implementação

- **[OBRA]**: personagem, equipamento, arte marcial, magia ou peculiaridade descritos em fonte de referência da franquia.
- **[ADAPTAÇÃO]**: forma original de transformar essa habilidade em um Tower Defense. Exemplos: roubo de vida como cargas de Blood, armadura absorvendo um vazamento, ou morte instantânea como execução limitada.
- **[BALANCEAMENTO]**: números provisórios para primeiro teste; sujeitos a aprovação/revisão.
- **[IMPLEMENTADO]**: apenas os dados de design. Nenhuma skill/passiva é calculada por TowerService, que permanece com Espadachim, Arcanista e Capsule como beta.

### Elenco aprovado

| Raridade | Personagem | Identidade proposta de combate |
|---|---|---|
| Secreto | Ainz Ooal Gown | Magia, maldições, dano em área e execuções limitadas |
| Mítico | Albedo | Suporte defensivo, controle e proteção de base |
| Lendário | Shalltear Bloodfallen | DPS contínuo vampírico, lança e duplicata |
| Épico | Gazef Stronoff | Espadachim em área e especialidade contra armadura |
| Raro | Brain Unglaus | Preciso, críticos e golpes concentrados |
| Comum | Climb | Espadachim acessível com sobrecarga temporária |

## 1 — Climb · COMUM

**[OBRA]** É o guarda-costas leal de Renner. A descrição oficial do anime destaca que ele veio de origem humilde, não tem talento natural para espada, mas treina com perseverança. Em combate usa técnicas marciais como **High Vertical Strike**, **Fortress** e **Limit Breaker: Mind**. Esta última o força além dos limites corporais, com custo físico.

**Função [ADAPTAÇÃO]:** unidade terrestre de alvo único, barata, boa para primeiros mapas e emergências quando o inimigo se aproxima da base.

- **Passiva — Determinação do Guarda:** ao surgir um inimigo nos últimos 25% do percurso, Climb ganha **+12% velocidade de ataque por 5s**, com recarga interna de 20s. Reflete esforço e lealdade; bônus numérico inventado para o TD.
- **Golpe Vertical (High Vertical Strike):** a cada 5 ataques, executa um golpe concentrado de **180% do dano do ataque**.
- **Fortaleza (Fortress):** protege a si próprio de uma aplicação de desativação durante janela de 4s, recarga 26s. **Não protege a vida da base.**
- **Limit Breaker: Mind (ativa):** +30% dano e +20% velocidade de ataque por 7s; ao terminar, sofre penalidade de 14% na velocidade de ataque por 4s; cooldown 45s.

**Por que usar um Comum?** Progride com facilidade e ajuda a defender o fim do caminho. Não precisa competir em DPS com personagens secretos. **Não é um Climb com poderes de alto nível que não possui na obra.**

**Visual de upgrade:** armadura branca e espada simples; maior intensidade de aura dourada no Limit Breaker, sem transformação inexistente.

## 2 — Brain Unglaus · RARO

**[OBRA]** Espadachim humano especializado em katana, movido por sua busca de aprimoramento. **Field** é seu domínio de percepção de curta distância, **God Flash** é um golpe veloz, e **Nail Clipper** combina Field, God Flash e Fourfold Slash of Light. A versão **True Nail Clipper** é desenvolvida mais tarde na novel.

**Função [ADAPTAÇÃO]:** assassino físico de alvo único e crítico. Preferência por inimigos perigosos e bosses.

- **Passiva — Field: Domínio de Percepção:** **+10 pontos percentuais** de chance crítica e bônus de precisão de 15% no alvo; o valor numérico é proposta.
- **God Flash:** a cada 5 ataques, corte de **200%** com +12 p.p. de crítico.
- **Nail Clipper:** 4 golpes rápidos no **mesmo alvo**, cada um com 65% do dano; cooldown 19s.
- **True Nail Clipper (final):** 6 golpes concentrados, cada um com 62% do dano, cooldown 57s. Técnica avançada com aviso de spoiler da novel.

**Limites:** sem execução instantânea; crítico depende das regras de Trait e armadura. O foco é single target, diferente dos cortes de área de Gazef.

**Visual de upgrade:** katana, brilho da zona Field, riscos de corte em branco e depois azul-prateado. Animações curtas e legíveis no mobile.

## 3 — Gazef Stronoff · ÉPICO

**[OBRA]** Capitão-guerreiro de Re-Estize, respeitado como um dos maiores combatentes humanos, armado com a espada **Razor Edge**. Suas artes incluem **Focus Battle Aura**, **Fourfold Slash of Light** e o cansativo **Sixfold Slash of Light**. Fontes indicam que o Sixfold é sobretudo golpe de vários cortes contra grupos, difícil de direcionar individualmente.

**Função [ADAPTAÇÃO]:** guerreiro físico de alcance médio, varrendo grupos e explorando resistência física.

- **Passiva — Focus Battle Aura:** ignora provisoriamente **15% da resistência física** do alvo. Não atravessa escudo de fases ou invulnerabilidade de boss.
- **Fourfold Slash of Light:** a cada 5 ataques, 4 cortes num cone de 45°, cada um com 45% de dano.
- **Razor Edge (ativa):** golpe linear com **220% de dano** e mais 10% de penetração de resistência; recarga de 24s. Primeiro danifica escudos, depois HP.
- **Sixfold Slash of Light (final):** seis golpes de 72% distribuídos entre inimigos em raio 12; recarga de 49s. Não é um "seis hits garantidos no boss" como a versão do Brain.

**Diferencial:** ótimo contra pequenos grupos de blindados, com dano de área e penetração; Brain vence na precisão individual.

**Visual:** espada longa e seis arcos luminosos cruzando o caminho, com VFX reduzidos em celulares.

## 4 — Shalltear Bloodfallen · LENDÁRIO

**[OBRA]** Vampira guardiã dos primeiros três andares de Nazarick, extremamente forte em duelo. Usa **Spuit Lance**, arma que absorve vida, **Blood Pool/Blood Frenzy**, e pode invocar uma duplicata **Einherjar**. A fúria sanguínea aumenta agressividade e pode atrapalhar discernimento.

**Problema de tradução para TD:** Towers atualmente não recebem dano nem têm barra de HP própria; seria incorreto fingir que roubar vida as cura.

**Função [ADAPTAÇÃO]:** DPS sustentado, com recurso próprio de sangue e pico temporário de ataques.

- **Passiva — Blood Pool:** acumula até 5 cargas de sangue por mortes dentro do alcance; cada carga concede **+4% dano** até o fim da wave.
- **Spuit Lance:** a cada 4 ataques, golpe de 140% e +1 carga de sangue; não "cura uma Tower" inexistente.
- **Blood Frenzy (ativa):** ao consumir 5 cargas, +45% velocidade de ataque por 9s, com penalidade temporária de 12% de alcance; cooldown 42s.
- **Einherjar (final):** uma duplicata esbranquiçada temporária por 12s, replicando ataques básicos com 40% do dano; cooldown 75s. A duplicata **não é uma segunda Tower permanente**, não ocupa slot de deck e não permite duplicar renda.

**Visual:** forma vestido gótico → armadura de combate para golpes de lança; olhos e aura vermelhos no Frenzy; Einherjar quase branco/translúcido. Troca real de rigs/skins continua em desenvolvimento.

## 5 — Albedo · MÍTICO

**[OBRA]** Guardiã Suprema de Nazarick, uma das melhores defesas entre os NPCs. **Hermes Trismegistus** é sua armadura pessoal de altíssima defesa. Ela possui uma técnica que transfere dano recebido para camadas de sua armadura, com uso limitado. Também são citadas **Aegis**, **Walls of Jericho** e aptidão para comandar guardiões.

**Adaptação principal:** como as Towers não têm HP próprio, Albedo deve proteger **aliados e a base**. O bloqueio não pode anular a derrota instantânea de um chefe final.

- **Passiva — Hermes Trismegistus:** 3 cargas totais por partida; se colocada perto da base, consome uma carga para anular um vazamento **normal** com recarga interna 28s. Não salva de chefes com derrota instantânea.
- **Walls of Jericho (ativa):** barreira em raio 13 que aplica lentidão de 24% em inimigos comuns por 5s; recarga 27s; boss usa resistência progressiva a controle.
- **Aegis (ativa):** Towers aliadas em raio 20 ignoram até uma desativação por 7s; recarga 39s.
- **Comando da Guardiã Suprema (final):** buff de **+12% dano para o time inteiro por 10s**; recarga 70s. Nome e bônus são **adaptação original da função de comandante** — não uma magia explicitamente apresentada com esse efeito na obra.

**Diferencial:** a rara Tower que mantém uma defesa frágil viva e dá ferramentas para a equipe, sem substituir um DPS.

**Visual:** asas negras, traje branco em forma básica, armadura escura e escudos transparentes nas habilidades. Atenção ao gasto de partículas no mobile.

## 6 — Ainz Ooal Gown · SECRETO

**[OBRA]** Líder de Nazarick e especialista em necromancia e magias de alta categoria. Técnicas marcantes: **Despair Aura**, **Reality Slash**, **Grasp Heart**, **Fallen Down**, e a habilidade especial de Eclipse **The Goal of All Life Is Death** (ligada a magia de morte com atraso). A obra permite morte instantânea em certos contextos, mas um Tower Defense não pode acabar com o boss final com um clique.

**Função [ADAPTAÇÃO]:** mago de alto custo, controle de massas, dano mágico elevado, poderes ativos de longa recarga e limites bem definidos contra chefes.

- **Passiva — Despair Aura:** pulso de medo a cada 13s que reduz a velocidade dos inimigos **comuns** em 14% durante 2,5s; bosses não são afetados automaticamente.
- **Reality Slash:** a cada 4 ataques, corte dimensional com **210% dano mágico** e 25% de penetração de resistência mágica.
- **Grasp Heart (ativa):** pode executar um inimigo comum com até 20% HP restante. Contra chefes, causa até **2,5% do HP máximo, limitado a 500 de dano**. Recarga 32s. A versão de stun ao resistir deve respeitar imunidade progressiva.
- **Fallen Down (final):** após canalização de 3s, atinge círculo de raio 19 com 500% do dano normal; recarga 81s. VFX com versão reduzida em celulares.
- **The Goal of All Life Is Death (suprema exclusiva):** até **uma utilização por partida**, aviso de 12s, executando apenas inimigos comuns abaixo de 25% de HP. Contra bosses, máximo de 7% do HP e teto de 1300; **nunca atravessa imunidade de fase, invulnerabilidade ou escudo com exceções inexistentes**.

**Diferencial:** muitos botões poderosos com janelas de risco. Não deve ganhar tudo que um personagem de suporte, farm e controle possui. Secret é raridade, **não uma licença para quebrar as regras**.

**Visual:** robe negro, aura de ossos e partículas escuras, fenda espacial, coração espectral, coluna de luz azul e contagem regressiva para a suprema. Nunca usar VFX idênticos a assets extraídos do anime.

## 7 — Resumo das mecânicas que cada uma ensina ao motor

| Unidade | Mecânicas inaugurais |
|---|---|
| Climb | Contadores de ataque; buffs temporários e fadiga |
| Brain | Crítico e multigolpe em alvo travado |
| Gazef | Cone/linha, área e penetração de resistência |
| Shalltear | Cargas, skills de fúria e invocações temporárias |
| Albedo | Proteção contra vazamento comum, debuffs e buff de equipe |
| Ainz | Execução controlada, telegraph, delay, AoE e recargas longas |

**Regras de base:** crítico aditivo em pontos percentuais; multiplicador de crítico calculado em categoria própria. Buffs da mesma categoria somam até limites, categorias distintas multiplicam. DOT tem stacks independentes e frequência própria; nenhuma dessas seis Towers recebe DOT automaticamente se a habilidade não o declarar. Escudo absorve antes do HP; exceções devem estar nomeadas e aprovadas. Resistência de controle de chefe cresce conforme cada efeito bem-sucedido.

**Para o design inicial, não atribuir automaticamente** Trait, Shiny, relic, evolução, limite de posicionamento, raridade de summoning, dano base, SPA ou custo de colocação definitivos. Esses valores serão decididos por unidade e testados, não importados como "estatísticas oficiais" da obra.

## 8 — Questões de balanceamento a fechar antes do gameplay

1. **Raridade vs. função:** Climb não deve superar Ainz em poder total, mas pode ser mais barato e eficiente no início; Albedo é suporte e não deveria disputar DPS puro com Gazef.
2. **Alcance e posicionamento:** melee de Climb, Brain, Gazef e Shalltear; Albedo tende a alcance médio curto; Ainz alcança longe. Distâncias em studs pendentes.
3. **Aéreo:** estabelecer quais personagens podem atingir inimigos Air, não inferir da aparência.
4. **Cooldowns de ativas:** jogador controla em botão/cooldown; gamepass 3x deve manter tempos coerentes com escala da partida.
5. **Ultimates:** seleções e confirmações devem funcionar também no celular. Boss não pode ignorar mecânica de fases.
6. **Traits:** não deixar Unique aumentar automaticamente DOT; Godspeed e multigolpes devem passar por teste. Sinergias precisam ser verificadas caso a caso.
7. **Invocações:** Einherjar é um efeito especial temporário, não mais um slot permanente nem farm de renda.
8. **Debuffs e escudos:** Albedo não deve tornar a vida da base infinita. Boss de Nigun mantém morte instantânea em vazamento.
9. **Progressão real:** nenhum dos seis foi liberado no Summon nem colocado no deck da beta. Primeiro definir aquisição e cartas da coleção.
10. **Mudanças da obra:** Brain com True Nail Clipper usa material tardio da light novel; evitar spoilers visuais antes do upgrade correspondente.

## 9 — Fontes, classificadas pela função

**Fonte primária/official anime (apresentação dos personagens):**
- https://overlord-anime.com/_season2/character/ — Ainz, Albedo, Shalltear, Climb, Brain e Gazef e sua posição na obra.

**Referências de técnicas na light novel/anime (compilações de fãs, não fonte oficial):**
- https://overlordmaruyama.fandom.com/wiki/Climb
- https://overlordmaruyama.fandom.com/wiki/Brain_Unglaus
- https://overlordmaruyama.fandom.com/wiki/Gazef_Stronoff
- https://overlordmaruyama.fandom.com/wiki/Martial_Arts
- https://overlordmaruyama.fandom.com/wiki/Shalltear_Bloodfallen/Abilities_and_Powers
- https://overlordmaruyama.fandom.com/wiki/Spuit_Lance
- https://overlordmaruyama.fandom.com/wiki/Einherjar
- https://overlordmaruyama.fandom.com/wiki/Albedo/Abilities_and_Powers
- https://overlordmaruyama.fandom.com/wiki/Hermes_Trismegistus
- https://overlordmaruyama.fandom.com/wiki/Ainz_Ooal_Gown/Abilities_and_Powers

**Identificação de adaptações:** a obra fornece personagens e técnicas, mas não percentuais em nosso jogo; os números e efeitos abaixo são **propostas originais de balanceamento**.

**Observação de publicação e licenciamento:** a Roblox proíbe uso não autorizado de propriedade intelectual de terceiros. Para publicar um jogo com personagens, nomes e visuais de Overlord é importante verificar se existe licença ou permissão adequada; caso não haja, usar personagens próprios e mecânicas inspiradas em arquétipos de fantasia, sem copiar a expressão protegida da obra. Veja:
- https://create.roblox.com/docs/production/publishing/ip-guidelines
- https://create.roblox.com/docs/pt-br/ip-licensing/creators

## 10 — Próximos passos técnicos

- Aprovar individualmente skills, passivas, papel da Tower e perfil de balanceamento.
- Criar módulos executáveis para habilidades acionadas, multi-hit, crítico, buffs/debuffs, cooldowns, summons e área. **Não implementar seis tipos de técnica copiando lógica em seis scripts**.
- Criar **primeiro Climb** como unidade de teste em branch ou beta controlada. Mantê-lo bloqueado na coleção real até a origem no Summon ou outra forma de obtenção ser definida.
- Depois validar Brain, Gazef, Shalltear, Albedo e Ainz, aumentando a complexidade.
- Fazer teste no Roblox Studio em PC/mobile, incluindo boss com resistências, fases e limitações de desempenho.

**Nenhum código de gameplay foi alterado nesta etapa; apenas o catálogo e as fichas de design foram publicados.**
