# Anime Fissure — Playtest Overlord v1.2
Atualização: 24 de novembro de 2026. **Código no GitHub, Roblox Studio ainda não testado nesta sessão.**

## Decisões mantidas

- Todos os seis personagens têm passiva e três transformações de ataque ao longo dos upgrades.
- **Climb (Comum), Brain (Raro), Gazef (Épico), Shalltear (Lendário) e Albedo (Mítico):** planejados para banner futuro, sem taxas definidas e sem alterar o Summon atual.
- **Ainz (Secreto):** fora do banner; Legend Stage é uma possibilidade, NÃO definida.
- Os seis ficam disponíveis gratuitamente apenas no laboratório do Roblox Studio. Isto não atribui unidades, Gold ou Tickets persistentes.
- Publicação real mantém a beta anterior e o banner Capsule até ser definida a integração de obtenção.

## Como abrir e testar hoje

1. Abra https://github.com/Blacksharkv0/Anime-Fissure/actions e escolha a última execução verde da workflow **Anime Fissure - Build Beta** na main. Baixe o artefato AnimeFissure-Beta.
2. Abra o arquivo .rbxlx no Roblox Studio; clique em **Play**.
3. No lobby clique **MODELOS OVERLORD** (somente no Studio). Escolha cada personagem; gire o modelo e alterne **BASE / ATAQUE 1 / ATAQUE 2 / ATAQUE 3**.
4. Clique **TESTAR VFX INICIAL** no Model Lab: demonstra efeitos próprios de cada personagem sem causar dano.
5. Feche o laboratório. Abra **JOGAR**, selecione Carne Village Classic e inicie.
6. O deck inferior deve mostrar os seis personagens: Climb, Brain, Gazef, Shalltear, Albedo e Ainz. O saldo inicial Studio é **18.000 Yen de laboratório**, diferente da regra real de 700 Yen.
7. Clique em um slot e depois na GRAMA livre próxima do caminho para colocar a Tower. O servidor valida distância, Yen, posse, modo e terreno.
8. No Studio a wave 1 começa após **24s de preparação** ou antecipadamente com Skip. Observe o dano real nos inimigos e os VFX dos seis tipos de ataque.
9. Clique no corpo do personagem ou na base circular para selecionar. Faça upgrades até o nível **3**, depois **6**, depois **9**: cada marco troca o visual E o comportamento básico do ataque.
10. Use **+20.000 YEN (STUDIO)** para testar upgrades sem farm, até o limite de 100.000 Yen por sessão.
11. Use **DECK: OVERLORD** para alternar ao deck Legacy (dois protótipos + Capsule condicionada à posse).
12. Abra View → Output: procure erros em vermelho e o log do teste de **24 variantes de modelos (6×4)**.
13. Refaça um Play novo para testar outro personagem desde o começo e teste em Device Emulator se possível.

## Atributos de teste (ainda não são balanceamento aprovado)

| Tower | Raridade | Custo Yen | Dano base | SPA | Alcance | Limite |
|---|---|---:|---:|---:|---:|---:|
| Climb | Comum | 180 | 30 | 0,93s | 20 | 4 |
| Brain | Raro | 270 | 55 | 1,15s | 22 | 3 |
| Gazef | Épico | 390 | 95 | 1,50s | 24 | 3 |
| Shalltear | Lendário | 620 | 133 | 1,44s | 26 | 2 |
| Albedo | Mítico | 750 | 91 | 1,62s | 27 | 1 |
| Ainz | Secreto | 1150 | 245 | 2,35s | 35 | 1 |

Todos possuem **9 upgrades**. Marcos visuais e de ataques **3, 6 e 9** são provisórios. São R6 em Parts, não MeshParts de nível profissional.

## Passivas funcionais de protótipo

- **Climb:** Determinação do Guarda aumenta velocidade de ataque temporariamente ao alcançar inimigos perto da base.
- **Brain:** Field eleva chance de crítico; melhora as janelas de multigolpes.
- **Gazef:** Focus Battle Aura é representada por bônus contra blindados; penetração completa está pendente.
- **Shalltear:** Blood Pool acumula até 5 cargas após kills em alcance, gerando até +20% dano na wave.
- **Albedo:** Hermes Trismegistus bloqueia até 3 vazamentos normais, se posicionada perto da base e respeitando recarga. Não bloqueia derrota instantânea de chefes.
- **Ainz:** Despair Aura desacelera periodicamente inimigos comuns próximos; bosses são imunes.

**Ataques ativos definitivos, ultimates, modelos finais, animações, habilidades especiais e balanceamento são tarefas seguintes.** Os efeitos de múltiplos golpes ainda são implementações simplificadas em pacotes de dano e VFX.

## Problemas a relatar

- **Modelos invisíveis ou enterrados:** print de frente e lado + View → Output.
- **Torre não posiciona:** print de posição, Yen e mensagem de erro. Escolher VillageMeadow ao lado da trilha, não casas, caminho ou outra Tower.
- **Não aparece DECK: OVERLORD:** conferir se .rbxlx é da última build na main e se TowerHUD.client.luau está presente.
- **VFX não saem:** confira OverlordCombatVFX.client.luau e AttackFX na pasta TowerRemotes.
- **HP inimigo não diminui:** encaminhar print do output e da wave; dano é resolvido exclusivamente no servidor.

## Arquivos principais

- src/shared/TowerConfig.luau
- src/shared/OverlordTowerModelBuilder.luau
- src/shared/OverlordModelProgression.luau
- src/server/TowerModelBuilder.luau
- src/server/TowerService.luau
- src/server/OverlordCombatPrototype.luau
- src/server/EnemyService.luau
- src/server/Main.server.luau
- src/client/OverlordCombatVFX.client.luau
- src/client/OverlordModelGallery.client.luau
- src/client/TowerHUD.client.luau

**Este é um playtest programado, não uma confirmação de execução dentro do Roblox Studio.**
