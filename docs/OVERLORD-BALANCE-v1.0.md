# Anime Fissure — Overlord: hierarquia de Dano, SPA e Range v1.0

**Publicado na branch main — 26/11/2026.** Configuração destinada **somente ao Studio** por enquanto. Não foi feita confirmação de build nem Play no Roblox Studio.

## 1. Regra geral

A hierarquia deste **primeiro mundo Overlord** é:
**Comum → Raro → Épico → Lendário → Mítico → Secreto**, comparando unidades no **mesmo nível**.

O Secreto Ainz deve permanecer líder em **dano bruto, alcance e DPS básico por alvo**, mesmo ao considerar os **+30%** que a sinergia Ainz/Albedo dá à Albedo. SPA pode variar por personagem e função; Brain, por exemplo, é mais ágil que Gazef, mas permanece com menos DPS.

A classificação é referência inicial **por unidade**, não um multiplicador global rígido: futuramente, diferentes animes podem ter forças e papéis específicos sem reutilizar a mesma tabela.

**Importante:** **Lv1 é o primeiro upgrade comprado**. Ao posicionar uma Tower ela está no **Lv0**, com stats mais baixos.

## 2. Estatísticas aprovadas para teste no Lv1

| Raridade | Unidade | Dano Lv1 | SPA Lv1 | Range Lv1 (studs) | DPS básico aprox. |
|---|---|---:|---:|---:|---:|
| Comum | Climb | 120 | 1.55s | 20 | 77.4 |
| Raro | Brain | 200 | 1.30s | 23 | 153.8 |
| Épico | Gazef | 320 | 1.72s | 25 | 186.0 |
| Lendário | Shalltear | 480 | 1.83s | 28 | 262.3 |
| Mítico | Albedo | 700 | 2.10s | 30 | 333.3 |
| Secreto | Ainz | 1000 | 1.88s | 36 | 531.9 |

DPS básico = Dano / SPA, antes de críticos, sinergias, ataques multi-alvo, passivas, resistências, e modificadores de stage. O número **não é DPS real medido numa luta**.

## 3. Evolução do dano bruto

| Unidade | Lv0 | Lv1 | Lv3 | Lv6 | Lv9 |
|---|---:|---:|---:|---:|---:|
| Climb | 103 | 120 | 161 | 222 | 283 |
| Brain | 171 | 200 | 268 | 370 | 472 |
| Gazef | 274 | 320 | 429 | 592 | 755 |
| Shalltear | 410 | 480 | 643 | 888 | 1133 |
| Albedo | 598 | 700 | 938 | 1295 | 1652 |
| Ainz | 855 | 1000 | 1340 | 1850 | 2360 |

**Fórmula por unidade:**
- Lv0 Dano = arredondar(DanoLv1 / 1,17).
- Lv1 Dano = alvo exato definido na tabela.
- Lv2–Lv9 Dano = arredondar(DanoLv1 × [1 + 0,17 × (nível − 1)]).
- Lv0 SPA = SPA Lv1 × 1,028; depois de Lv1, SPA cai 2,8% da SPA Lv1 por upgrade (arredondado a 2 casas, piso 0,32s).
- Range: Lv0 = RangeLv1 − 0,75; do Lv1 em diante ganha +0,75 studs por upgrade.
- As **três mudanças de ataque** continuam nos upgrades **3, 6 e 9**, preservando todos os padrões, passivas e VFX.

## 4. Sinergia Albedo + Ainz e o HUD

A dupla **Devoção ao Supremo** permanece ativa na mesma partida (inclusive coop): **Albedo +30% dano**, sem acumular por mais Ainz. Não dá +30% a Ainz.

Sem outras auras ou críticos:
- Albedo **Lv0**: 598 base → **777** com Ainz.
- Albedo **Lv1**: 700 base → **910** com Ainz.
- Ainz **Lv1**: 1.000 base e DPS básico ≈ 532; Albedo com par tem 910 e DPS básico ≈ 433. O Secreto permanece superior.

O painel **Tower Info** distingue o Dano bruto enviado por Config.GetStats do **EffectiveDamage** mostrado, que inclui estágios de ataque, a dupla e a aura geral de +12% da Albedo Lv9. Críticos, skills situacionais, Blood Pool e resistência de inimigos não entram nesse número informativo.

## 5. Arquivos implementados

- `src/shared/OverlordBalanceConfig.luau`: fonte única dos seis alvos Lv1 e suas curvas Lv0–9.
- `src/shared/TowerConfig.luau`: Stats e valores base dos seis lidos da fonte única, preservando FissureBlade, FissureMage e Capsule.
- `src/server/OverlordBalanceSmokeTest.server.luau`: **60 combinações unidade/nível** verificadas, além de evolução de SPA, ranking dano/DPS/range, +30% Albedo e roster.
- `.github/workflows/build-beta.yml`: exige módulos e anotações de teste.
- `src/server/TowerService.luau`: já atualiza informações do HUD e calcula o dano efetivo com estágios e dupla.
- `src/server/OverlordCombatPrototype.luau`: ataques reais continuam executados no servidor, e os multiplicadores por estilo de ataque (0/1/2/3) permanecem.

## 6. Limite atual: ainda não é balanceamento completo das partidas

O mapa Carne Village ainda possui **Invader 95 HP, Scout 75 HP, Armored 220 HP** e **Nigun Classic 2.000 HP**, da versão anterior. Com um Ainz de 1.000 Dano no Lv1, as waves provavelmente serão derrotadas com extrema facilidade.

Esta etapa **não alterou HP dos inimigos, chefes, renda, custos, número de waves, passivas nem summon** para não modificar mais variáveis sem testar. **Ajustar HP/escudos/dificuldade de Carne Village para a nova escala deve ser o próximo ciclo de balanceamento.** Isso é indispensável antes de considerar a fase equilibrada.

## 7. Teste Studio

1. Abra https://github.com/Blacksharkv0/Anime-Fissure/actions e confirme uma build verde da main.
2. Baixe o arquivo `AnimeFissure-Beta.rbxlx`, abra no Roblox Studio e pressione Play.
3. No laboratório Overlord, coloque um personagem de cada raridade; clique na Tower e compare Dano, SPA e Range nos upgrades Lv0, 1, 3, 6 e 9.
4. Confira o **Ainz Lv1 = 1.000** e **Albedo Lv1 = 700** antes de buffs.
5. Posicione Ainz junto da Albedo: espere **910 Dano Lv1** nela; os stats de Ainz não recebem a dupla.
6. Verifique no Output **OVERLORD BALANCE SMOKE OK**. Erros de execução precisam de prints do Output para diagnóstico.

**Sem teste de execução confirmado nesta interação:** essas são regras implementadas e auditadas por inspeção do repositório; não substituem playtest com ondas reais.
