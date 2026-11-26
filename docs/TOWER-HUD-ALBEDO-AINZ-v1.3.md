# Anime Fissure — Tower HUD v1.3 + sinergia Albedo/Ainz

**Estado:** arquivos publicados na branch main em 26/11/2026; Roblox Studio e build real ainda precisam de validação manual.

## Passiva bônus: Devoção ao Supremo

**Regra aprovada:** enquanto Ainz e Albedo estão ambos posicionados no campo da mesma partida, **cada Albedo ganha +30% de dano**. Esta é uma sinergia criada para o gameplay de Anime Fissure, não uma afirmação sobre uma habilidade canônica de Overlord.

- Funciona entre jogadores cooperativos na mesma partida.
- **Não precisa de distância específica**, basta ambos estarem colocados.
- **Não acumula:** duas ou mais cópias de Ainz continuam dando somente +30%.
- Ainz participa da sinergia, mas **não recebe +30% de dano**.
- Quando o último Ainz é vendido/removido, a sinergia deixa de valer; ao colocar outro, reativa.
- Se a última Albedo sair, a dupla deixa de estar ativa.
- A sinergia é multiplicativa e independente da aura geral +12% da Albedo no upgrade 9; esta aura existente segue sem acumular entre Albedos. Ex.: com aura e parceria simultâneas, multiplicador no ataque de Albedo = 1,12 × 1,30.
- O multiplicador é aplicado **no servidor**, sobre o dano principal e os golpes secundários quando existirem, sem depender de UI ou cliente.
- Esta funcionalidade é somente de teste no Studio, pois as Towers Overlord não estão liberadas no Summon atual.

### Exemplo numérico

Atributos provisórios da Albedo no nível 0: 91 de dano base, SPA 1,62s, Range 27.0. Com Ainz em campo e sem aura de upgrade 9: **91 × 1,30 = 118,3 → 118** de dano mostrado no HUD e calculado antes de críticos/resistências.

## Painel ao clicar na Tower

O painel atualizado fica **acima do deck de batalha** e oferece a seguinte estrutura:

    ┌───────────────────────────────────────────────────┐
    │ ALBEDO • LV 0                         [ MYTHIC ]  │
    │                                                   │
    │      DANO              RANGE             SPA      │
    │      118               27.0              1.62s    │
    │                                                   │
    │ UPGRADES   0 / 9   •   ATAQUE 0                   │
    │         ○  ○  ○  ○  ○  ○  ○  ○  ○                 │
    │ ATTACK: Guarda do Guardião (SINGLE)               │
    │ PASSIVA: Hermes Trismegistus • 3 cargas           │
    │ DEVOÇÃO AO SUPREMO ATIVA • +30% DANO (AINZ)       │
    │                                                   │
    │ [UPGRADE ¥...] [VENDER ¥...] [ X ]               │
    └───────────────────────────────────────────────────┘

Nomes dos ataques e seus tipos são enviados pelo servidor com base no **OverlordModelProgression.luau**. Ex.: no upgrade 9, Ainz exibe **ATTACK: Fallen Down (AOE)**. Isso representa o **ataque de protótipo em área**, não a ultimate Fallen Down completa, que ainda precisa de um sistema de habilidades ativas.

### Características

- Nome da unidade e raridade com cor.
- Dano efetivo por golpe normal (considera estágio de ataque e buffs permanentes da equipe); críticos, resistências e efeitos situacionais ficam fora do número.
- Range e SPA atuais.
- Progresso do upgrade atual até o máximo, com **até 12 círculos**, e marcos 3/6/9 destacados para Overlord.
- Nome e tipo do ataque, como SINGLE, AOE, MULTI-HIT ou LINHA.
- Passiva existente, cargas de sangue da Shalltear ou proteções da Albedo.
- Sinergia Albedo/Ainz em estado **ATIVA / AINDA NÃO ATIVA**.
- Permite selecionar Towers de outros jogadores para **consultar a ficha**, mas o jogador não pode fazer upgrade ou vender Towers alheias; o servidor também valida a posse.
- Cards funcionam para as duas Towers legadas e para Capsule. Capsule exibe Renda/wave, sem inventar dano.

## Arquivos envolvidos

- src/shared/OverlordPairSynergy.luau — regra pura e multiplicador não cumulativo.
- src/shared/TowerAttackInfo.luau — nomes/tipos dos ataques apresentados no card.
- src/server/TowerService.luau — cálculo da sinergia autoritativo, informação e sincronização da equipe.
- src/client/TowerHUD.client.luau — card com raridade, estatísticas, upgrades, ataque e bônus.
- src/server/OverlordPairSynergySmokeTest.server.luau — testa duo, coop, não empilhamento, remoção e 24 ataques.
- .github/workflows/build-beta.yml — verifica arquivos e pontos de integração da UI e passiva.

## Checklist de testes no Roblox Studio

1. Abra https://github.com/Blacksharkv0/Anime-Fissure/actions e escolha uma build **verde** da branch main, após a publicação.
2. Abra o arquivo .rbxlx gerado e clique Play; inicie Carne Village no Studio.
3. Posicione Albedo sem Ainz, clique nela e confira **SINERGIA: posicione Ainz ...**, além dos stats.
4. Posicione Ainz. Selecione Albedo novamente e confira o bônus **+30%**; no nível 0 o HUD deverá mostrar aproximadamente **118 Dano** (sem outra aura).
5. Selecione Ainz: ele mostra a parceria ativa que **beneficia Albedo**, sem atribuir bônus a ele próprio.
6. Venda o último Ainz: o bônus deve desaparecer e o dano da Albedo voltar ao normal.
7. Se possível, com dois jogadores no Studio Coop: coloque Albedo em um jogador e Ainz no outro. Os dois podem ver as fichas das Towers; só o dono deve ter botões ativos de upgrade e venda.
8. Teste níveis 3, 6 e 9 em cada Tower; os círculos e o campo ATTACK devem atualizar.
9. Teste em mobile Device Emulator; abra o card em landscape e portrait.
10. No Output, procure **PAIR SYNERGY + INFO SMOKE OK**; se houver erro, envie print da mensagem.

**Verificação disponível nesta etapa:** revisão estática do GitHub. Não é confirmação de funcionamento em Play/Roblox Studio.
