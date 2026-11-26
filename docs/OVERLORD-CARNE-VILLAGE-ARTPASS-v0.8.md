# Anime Fissure — Opção C: Carne Village + 6 personagens (v0.8)

**Data:** 26 de novembro de 2026. **Estado:** código publicado diretamente na branch main, sem Play confirmado no Roblox Studio.

## Direção visual

Referência: Overlord, cenário da **primeira invasão de Carne Village** (Mundo 1, Carne Village / OVL_01).
Objetivo: reproduzir uma vila rural humilde com silhuetas que lembrem o anime. A ambientação mais fortificada das temporadas posteriores não substitui o cenário inicial.

Referências úteis:
- Anime: https://www.crunchyroll.com/watch/G6K52J5PY/battle-at-carne-village
- Anime III, reconstrução posterior: https://www.crunchyroll.com/watch/GPWUK5Z3X/carne-village-once-more
- Estúdio: https://madhouse.co.jp/english/works/tv_overlord/

## 1. Carne Village — Art Pass v0.8

**O que foi adicionado:**
- Madeira de vigas cruzadas e relevo nas fachadas de oito casas.
- Faixas de palha envelhecida nos telhados inclinados.
- Ferragens das portas, degraus e materiais de aparência rural.
- Trigo com caules e espigas extras sobre as plantações existentes.
- Mais acabamento no poço, corda, balde e telhado.
- Carroças com feno, caixotes marcados e sacos de grãos.
- Arbustos de periferia sem encostar no caminho de combate.

**Arquivos:**
- src/server/CarneVillageArtPass.luau: geometria decorativa, API Art.Apply(arena).
- src/server/CarneVillageArtPass.server.luau: aplica a arte após o mapa anunciar Ready=true.
- src/server/CarneVillageArtSmokeTest.server.luau: valida no Studio a segurança da cena.

**IMPORTANTE:**
- Não alteramos BetaMap.server.luau. O art pass é uma camada separada, que não substitui terreno, waypoint ou portal.
- Todas as novas partes são Anchored=true, CanCollide=false, CanQuery=false, CanTouch=false; não obstruem posicionamento das Towers nem raycasts.
- Contratos preservados: EnemyPath com 8 waypoints na ordem original, PlayerSpawns com 4 posições, FissureBase.BaseCore, portal, StageId=OVL_01.
- A estética do portal e o núcleo de vida da base são elementos *originais de Tower Defense*, não réplicas do anime.
- Não foram adicionadas novas fortalezas/paredes de temporadas futuras ao primeiro ataque.

## 2. Personagens — Art Pass v0.8

**O que foi refinado em cada R6:**

| Unit | Direção de detalhes | Identidade a preservar |
|---|---|---|
| Climb | Armadura branca/pálida de guarda real, insígnia azul, rebites, luvas, grevas e cabelo loiro | Mais simples e jovem que Gazef |
| Brain | Gola e sobreposição de casaco de espadachim, faixa violeta, bainha/katana, cabelos mais desarrumados e rabo de cabelo | Ronin esguio de técnica/precisão |
| Gazef | Placas de metal por cima da armadura escarlate, gola, emblema de guerreiro, cintos e proteção de braços/pernas | Silhueta mais robusta e experiente |
| Shalltear | Babados brancos em camadas, vestido gótico, presilhas florais, cachos laterais, gema e acabamento da lança | Vampira aristocrática, forma normal |
| Albedo | Vestido de seda em camadas, desenho dourado, chifres mais definidos, cabelos longos e penas negras adicionais | Autoridade e guarda suprema |
| Ainz | Orlas douradas e roxas no robe, detalhes ósseos, olhos afundados e mais acabamento do cetro | Líder arcano; silhueta mais imponente |

**Arquivos:**
- src/shared/OverlordCharacterArtPass.luau: detalhes das seis roupas/cabelos/armas.
- src/shared/OverlordTowerModelBuilder.luau: chama CharacterArt.Apply(model) para cada personagem.
- src/server/OverlordModelSmokeTest.server.luau: valida a existência de detalhes, welds e as 24 variantes (base + 3 estágios por personagem).

**Segurança:**
- Todos os novos detalhes são peças R6 soldadas ao corpo por WeldConstraint, Massless=true, CanCollide/CanQuery/CanTouch=false.
- Nenhuma alteração de dano, passiva, traits, raridade, custos, cooldown ou Summon.
- Ainz permanece fora do banner; os outros cinco só estão previstos para banner futuro.
- Rigs continuam estilizados com peças nativas Roblox, sem texturas/malhas premium ou animações profissionais importadas. Estar mais próximo do anime não significa reprodução 1:1.

## 3. Como verificar

1. Acesse https://github.com/Blacksharkv0/Anime-Fissure/actions e escolha a build mais recente de main, **somente se a execução estiver verde**.
2. Abra o arquivo AnimeFissure-Beta.rbxlx no Roblox Studio.
3. Pressione **Play**, abra **MODELOS OVERLORD**, selecione um personagem e gire para ver frente/costas.
4. Teste os estágios BASE, ATAQUE 1, ATAQUE 2 e ATAQUE 3. Os novos detalhes devem aparecer em todas as formas.
5. Entre em Carne Village e examine telhados, portas, plantações, carroças e poço.
6. Confira se as oito marcações de caminho, o spawn dos jogadores, o portal e a vida da base continuam funcionando.
7. No **View > Output**, procure:
   - CARNE VILLAGE ART PASS v0.8
   - CARNE VILLAGE ART TEST OK
   - OVERLORD MODEL TESTE ESTATICO OK: 24 variantes
8. Faça um teste em Device Emulator para medir FPS (detalhes decorativos adicionam partes).
9. Envie prints dos personagens e da vila. Ajustamos proporção, silhueta e materiais com base no render real.

## 4. Próximo passe recomendado após o teste

- Refinar proporções e poses, sobretudo cabeça/rosto e telas pequenas de celular.
- Investigar malhas autorais/UV e texturas PBR próprias para as seis Towers.
- Otimizar o total de partes dos modelos e do cenário para aparelhos intermediários.
- Finalizar três conjuntos de animação de ataque por personagem e habilidades especiais.

**Aviso:** personagens e nomes de Overlord são de propriedade intelectual de terceiros. Antes de publicar comercialmente, avaliar permissões/licenciamento ou desenvolver aparências autorais que não repliquem expressão protegida.
