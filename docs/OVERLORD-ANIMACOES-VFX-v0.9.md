# Anime Fissure — Overlord: animações, expressões, armas e VFX v0.9

**Data:** 26/11/2026. **Estado:** código publicado em main, execução no Roblox Studio ainda não confirmada.

## Meta e decisões preservadas

- Todos os seis possuem passiva, inclusive Comum e Raro.
- Base + **três mudanças de ataques e animação**: upgrades provisórios **3, 6 e 9**.
- Ainz é o Secreto e permanece **fora do banner**; origem especial a decidir. Os demais cinco estão previstos para banner futuro.
- Não houve mudança no Summon, Gems, Gold, Traits, Relics, pity ou salvamento.

## 1. Animação de ataque — seis movimentos diferentes

Módulos:
- src/shared/OverlordMotionController.luau
- src/client/OverlordCombatAnimator.client.luau

Essas animações são **procedurais**: movimentam as juntas Motor6D.Transform dos rigs R6 no cliente, por RunService.PreSimulation, com preparação, impacto e recuperação; acrescentam leve movimento de idle.

| Unidade | Movimento principal | Mudanças nos upgrades 3/6/9 |
|---|---|---|
| Climb | Corte disciplinado, postura de guarda | Vertical / combo / Limit Breaker visual |
| Brain | Corte de katana extremamente rápido | God Flash / Nail Clipper / True Nail Clipper |
| Gazef | Golpe pesado de espadão | Fourfold / Razor Edge / Sixfold |
| Shalltear | Estocada de Spuit Lance | Vampírico / Blood Frenzy / eco de Einherjar |
| Albedo | Posição protetora e arma de guardiã | Asas / Hermes / Comando |
| Ainz | Mãos e cajado conjurando | Reality Slash / Grasp Heart / magia superior |

Isso entrega movimentos por ataque, mas **não é um AnimationTrack profissional com keyframes** e não significa que as habilidades ativas completas já foram implementadas.

## 2. Rosto e armas detalhados

Módulos:
- src/shared/OverlordModelFinish.luau
- src/shared/OverlordTowerModelBuilder.luau

Cada rig possui expressão **neutra, concentrada e atacando** por peças faciais que alternam transparência. Ainz usa mandíbula de esqueleto e brilho mágico em vez de rosto humano.

Armas agora têm acabamento:
- Climb: bisel prateado e gema azul.
- Brain: fio da katana e revestimento do cabo.
- Gazef: reforço Razor Edge, guarda e gema.
- Shalltear: lâminas e rubi na Spuit Lance.
- Albedo: alabarda e emblema dourado.
- Ainz: cetro ornamental com pontas e gema.

Um Attachment chamado **WeaponFocus** é preso ao Right Arm de cada rig. Ele acompanha a animação e pode ser usado pelo VFX. Todos os novos acessórios são peças visuais sem colisão e soldadas ao rig.

## 3. VFX no combate

- src/server/TowerService.luau envia AttackFX com Serial da Tower e alvo.
- src/client/OverlordCombatAnimator.client.luau encontra a Tower e inicia o movimento.
- src/client/OverlordCombatVFX.client.luau espera aproximadamente 0,095s para mostrar o contato visual, usando WeaponFocus como origem quando disponível.
- Cada personagem possui sua assinatura de cor e efeitos específicos adicionais nos estágios 1, 2 e 3.
- O servidor continua responsável por HP, dano, resistências, buffs e cooldowns. Animação visual não concede habilidades novas.

## 4. Model Lab interativo e testes

No Roblox Studio:
1. Acesse https://github.com/Blacksharkv0/Anime-Fissure/actions, confirme a execução verde mais recente em main e abra o arquivo .rbxlx.
2. Pressione **Play**; no lobby clique **MODELOS OVERLORD**.
3. Selecione uma unit, clique **BASE**, **ATAQUE 1**, **ATAQUE 2** ou **ATAQUE 3** e depois **ANIMAR ATAQUE + VFX**.
4. Confira braço da arma, gesto corporal, rosto, direção da arma e VFX. Faça isso para as seis unidades, **24 combinações**.
5. Entre em Carne Village e coloque Towers do deck Overlord. O servidor deve aplicar dano enquanto o cliente anima o rig e o golpe.
6. Verifique no Output o registro **OVERLORD ANIMATION SMOKE OK: 24 motion stages**.
7. Teste no Device Emulator, principalmente FPS, armas acompanhando o braço, poses em movimento e legibilidade dos efeitos.

Arquivo do teste: src/server/OverlordAnimationSmokeTest.server.luau.

## Limites honestos

**Este trabalho foi publicado e inspecionado estaticamente, mas não foi possível executar o Roblox Studio nem confirmar a build verde.** As skills completas continuam pendentes: Einherjar jogável, Fallen Down em área real, Limit Breaker ativo, etc. VFX não significa habilidade ativada.

Os modelos ainda são estilizados em peças Roblox, sem malhas UV/PBR ou clips de animação finais. Personagens e nomes de Overlord são IP de terceiros: publicação pública requer avaliação de licença.

Fontes técnicas:
- https://create.roblox.com/docs/reference/engine/classes/Motor6D/Transform
- https://create.roblox.com/docs/performance-optimization/microprofiler/task-scheduler
