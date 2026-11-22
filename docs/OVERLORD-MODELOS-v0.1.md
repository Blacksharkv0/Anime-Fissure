# Anime Fissure — Modelagem Overlord v0.1 (22/11/2026)

**Data da decisão:** 22/11/2026. **Status:** arquivos no GitHub; **não validado ainda em Play no Roblox Studio**. Esta versão prioriza **modelos** e não executa combate novo nem adiciona personagens ao banner atual.

## Decisões confirmadas pelo criador

- Secreto: **Ainz Ooal Gown** — **fora de qualquer banner**; obtenção futura especial (Legend Stage é possibilidade, ainda **não confirmada**).
- Mítico: **Albedo** — planejada para banner.
- Lendário: **Shalltear Bloodfallen** — planejada para banner.
- Épico: **Gazef Stronoff** — planejado para banner.
- Raro: **Brain Unglaus** — planejado para banner.
- Comum: **Climb** — planejado para banner.
- **TODOS** os personagens, inclusive Comum e Raro, precisam ter uma **passiva própria**.
- **TODO personagem terá três mudanças de padrão de ataque ao evoluir via upgrades**, além do padrão inicial. Os níveis exatos dos upgrades ainda não foram aprovados, então os previews usam **BASE → ATAQUE 1 → ATAQUE 2 → ATAQUE 3**.
- **Secreto Ainz será o mais forte em capacidade geral, mas unidades comuns e raras devem continuar úteis e com identidade.** Os valores finais ainda serão balanceados. Raridade de personagem não garante automaticamente melhor Trait.

## O que foi criado na v0.1

### Modelos 3D na Roblox Studio

Os seis modelos usam **Parts e WedgeParts** customizados, **Motor6D tipo R6**, Humanoid e acessórios com WeldConstraint. **São protótipos 3D estilizados/low-poly gerados por código**: não são MeshParts profissionais importadas, não possuem texturas 2D autorais, animações completas, roupas especiais por Shiny ou efeitos ativos de combate.

| Personagem | Silhueta e elementos distintivos | Três mudanças de ataque ilustradas |
|---|---|---|
| **Climb** | Armadura prateada, cabelo loiro, olhos azuis, detalhes azul-violeta, espada e ombreiras | lâmina azul; cortes dourados; aura dourada de Limit Breaker |
| **Brain** | Cabelo escuro, traje de espadachim, faixa violeta, bainha lateral e katana | lâmina brilhante do God Flash; quatro cortes Nail Clipper; seis cortes True Nail Clipper |
| **Gazef** | Armadura escarlate, placas prateadas/douradas, capa e Razor Edge | quatro arcos; lâmina encantada; seis golpes radiantes |
| **Shalltear** | Vestido gótico rubro, cabelo prateado, olhos vermelhos, Spuit Lance | lança escarlate; armadura de fúria; duplicata espectral decorativa |
| **Albedo** | Vestido branco, cabelo preto longo, chifres, asas pretas e arma guardiã | penas energizadas; armadura escura; aura de comando e escudo |
| **Ainz** | Crânio de esqueleto, olhos vermelhos, robes negros/roxos, gemas no ombro e cajado | fenda dimensional; coração espectral; grande coroa de magia |

Os efeitos dos estágios são **decorações estáticas**, não ataques produzindo dano. O código usa 4 estados visuais cumulativos, de 0 a 3.

### Biblioteca de templates

- `src/shared/OverlordTowerModelBuilder.luau` — Builder.Build(id), Builder.SetVisualStage(model, stage 0..3), Builder.BuildAll(parent).
- `src/shared/OverlordModelProgression.luau` — catálogo de BASE/ATAQUE 1/ATAQUE 2/ATAQUE 3; cada uma de seis unidades com quatro etapas de ataque; valida existência de passiva.
- `src/server/OverlordModels.server.luau` — **somente no Roblox Studio**, cria os seis modelos na pasta **ReplicatedStorage.OverlordTowerModels**.
- `src/server/OverlordModelSmokeTest.server.luau` — faz teste automático no Studio das **24 variantes** (seis modelos × quatro estágios), verifica Humanoid/R6, passiva, transformação visual cumulativa e regra de Ainz fora do banner.
- `src/client/OverlordModelGallery.client.luau` — galeria GUI no lobby, **somente no Studio**, com ViewportFrame 3D, rotação por arraste/setas, seletor dos seis personagens e dos quatro looks; possui layout para telas estreitas e largas.
- `src/shared/OverlordUnitRoster.luau` — flags `BannerCandidate` e `ObtainMethod`, sem alterar status Planned.
- `.github/workflows/build-beta.yml` — presença dos arquivos verificada no CI.

### Regras de não disponibilização

- **Não alteramos** `src/shared/SummonConfig.luau` nem `src/shared/TowerConfig.luau`: o Summon atual continua restrito à Capsule, e o deck jogável atual continua com os dois combatentes beta mais a Capsule condicionada à posse.
- **BannerPlanned** significa desejo de design, **não permissão para sorteio**. Taxas do futuro banner, pity, Shiny e moeda ainda precisam ser definidas e integradas.
- **Ainz** fica explicitamente bloqueado de banner. `SpecialStageUndecided` preserva a possibilidade de Legend Stage sem criar um Stage inexistente.
- As passivas continuam no catálogo `OverlordAbilityDesign.luau`; **não são calculadas pelo motor ainda**.
- Os 3 estados de mudança de ataque são **previews**, não upgrades do jogador; não alteram dano, SPA, posicionamento ou recursos.
- Os personagens de Overlord como Towers são separados dos NPC bosses que também podem aparecer em mapas futuros.

## Como testar agora no Roblox Studio

1. Abra [GitHub Actions](https://github.com/Blacksharkv0/Anime-Fissure/actions).
2. Localize a execução mais recente da workflow **Anime Fissure - Build Beta** na `main`. Só baixe o artefato **AnimeFissure-Beta** se a build estiver verde.
3. No Studio, abra o `.rbxlx`, clique **Play** e espere carregar o lobby.
4. No canto superior direito aparecerá o botão **MODELOS OVERLORD** — **apenas no Studio**. Clique nele.
5. Selecione **Climb, Brain, Gazef, Shalltear, Albedo e Ainz** na lista; cada um deve ter um rig 3D diferente.
6. Clique **BASE**, **ATAQUE 1**, **ATAQUE 2**, **ATAQUE 3**. A forma deve incorporar mais detalhes/camadas com cada etapa.
7. Arraste o modelo no preview (PC ou toque no emulador mobile) ou use as setas para girá-lo.
8. Veja a passiva e o nome do ataque proposto ao lado do modelo.
9. Verifique que **Ainz está marcado fora do banner** e os outros cinco com banner planejado.
10. No **View → Output** do Studio, verifique o log com **`OVERLORD MODEL TESTE ESTATICO OK: 24 variantes`** e nenhum erro vermelho relativo a `OverlordTowerModelBuilder`.
11. Faça teste em **Test → Device Emulator**, inclusive landscape e portrait; teste rolagem da lista e botões de transformação.
12. Saia de Play e envie prints de frente e costas de cada modelo — principalmente do Ainz, Albedo e Shalltear — para refinarmos forma, proporções e silhueta.

## Próximos incrementos após sua avaliação visual

1. Polir detalhes e proporções escolhidos nos prints, incluindo malhas autorais onde fizer sentido.
2. Criar 3 mudanças de **ataque real** por upgrades, em níveis que você aprovar; manter passivas de todos os personagens e habilidade especial.
3. Fazer VFX de ataque, rigs com animações de combate, poses e otimização mobile.
4. Criar cinco cartas de banner e a origem de Ainz via modo especial — **depois de definir peso/chance/pity e recompensas**.
5. Conectar os modelos aprovados a `TowerService`, `TowerHUD`, coleção, decks e Summon sem quebrar a beta anterior.

## Atenção antes de publicar

Os nomes e os visuais dos personagens pertencem a uma franquia de terceiros; é necessário avaliar direitos/licenciamento para utilização pública na plataforma Roblox. Nesta fase são **prototipagem em Studio**, não publicação de assets licenciados. Regras: https://create.roblox.com/docs/production/publishing/ip-guidelines

**Status de teste:** revisão estática e geração de arquivos realizadas; a execução efetiva do build e o Play no Studio ainda dependem de verificação.
