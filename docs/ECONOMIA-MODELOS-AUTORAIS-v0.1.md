# Anime Fissure — Gems, Gold e Rerolls autorais | Model Lab v0.1

**Data:** 24/11/2026. **Status:** arquivos publicados no GitHub; build e Play no Roblox Studio ainda sem confirmação.

## Identidade dos quatro recursos

| ID técnico | Nome proposto | Uso futuro | Identidade visual original |
|---|---|---|---|
| FissureGems | Gemas da Fissura | Summon e loja futura | Cristal partido em duas metades flutuantes, fissura azul, três fragmentos e aro hexagonal |
| Gold | Gold | Progressão fora da partida | Moeda dourada familiar com marca angular própria |
| TraitRerollCore | Núcleo de Reescrita | Reroll de Trait de unidade | Engrenagem hexagonal azul, núcleo turquesa e três eixos móveis |
| RelicTraitSeal | Selo de Ressonância | Reroll de Trait de relíquia | Mandala octogonal violeta, runas geométricas originais e espinhos de metal |

Os nomes são propostas criativas. Os IDs já estão cadastrados em **src/shared/EconomyVisualConfig.luau**.

## Arquivos feitos

- **src/shared/EconomyVisualConfig.luau:** catálogo de nomes, cores e utilidades; Status=VisualOnly, IsLive sempre false.
- **src/shared/EconomyItemModelBuilder.luau:** quatro mini modelos 3D em peças nativas Roblox, sem IDs externos, imagens importadas ou cópia de outros jogos. Builder.Build(id) permite reutilização posterior nos menus.
- **src/server/EconomyModels.server.luau:** biblioteca de modelos gerada somente no Roblox Studio em ReplicatedStorage.EconomyPreviewModels.
- **src/client/EconomyModelGallery.client.luau:** galeria no lobby do Studio, botão **◇ GEMAS & ITENS** abaixo de **MODELOS OVERLORD**, seleção de quatro itens, zoom, rotação, arraste e giro automático.
- **src/server/EconomyModelSmokeTest.server.luau:** verifica quatro modelos, separação visual, ausência de colisões, peças ancoradas e que não existem importações de MeshPart/Decal.
- **.github/workflows/build-beta.yml:** valida a presença desses arquivos, mantendo SummonTickets no banner real.

## Como testar

1. Visite https://github.com/Blacksharkv0/Anime-Fissure/actions e confira a última execução de **Anime Fissure - Build Beta**, branch main. Baixe somente se estiver **verde**.
2. Abra AnimeFissure-Beta.rbxlx no Roblox Studio e execute **Play**.
3. No lobby, clique **◇ GEMAS & ITENS**, canto superior direito.
4. Selecione Gemas da Fissura, Gold, Núcleo de Reescrita e Selo de Ressonância; gire os modelos e teste **AUTO, ESQUERDA, DIREITA, − e +**.
5. No **View → Output**, procure **ECONOMY MODEL SMOKE OK**. Se aparecer erro, envie print do Output e da galeria.
6. Teste com o Device Emulator, se possível, em paisagem e retrato.

## O que NÃO foi alterado

- Summon continua usando **SummonTickets**; nada foi trocado automaticamente por Gems.
- Loja de Gems e compra de moedas **ainda não existem**.
- Nenhum valor de Gold, inventário, transação, saldo, moeda ou pity foi criado por esses modelos.
- Reroll de Trait de unidade e reroll de Trait de relíquia são apenas **dois modelos de consumíveis distintos**, sem gastar ou gerar resultados.
- Não foram definidos custos, chance, origem de materiais ou regras de loja.
- Não são MeshParts profissionais nem ícones 2D; são **modelos low-poly de Parts**.

## Próxima etapa

Após a aprovação dos quatro modelos, decidir Gems versus Tickets, fontes de moedas, preços, gastos e taxas de reroll. Os modelos poderão virar ícones 3D nas interfaces de Summon, loja e inventário sem redesenhar a identidade.

**Verificação atual:** publicação e revisão estática do GitHub. A aparência real e a execução no Studio precisam de playtest.
