# Anime Fissure — Stage Info v0.8

**Status:** código no GitHub (`main`). Execução do build e teste funcional em Roblox Studio ainda pendentes.

## Onde fica

Dentro da arena (depois de clicar em **JOGAR** no lobby), aparece um **botão STAGE INFO** à direita, abaixo dos indicadores superiores. Clique/toque para abrir e fechar. O painel é rolável e ajusta a escala para PC e celular.

## O que o jogador vê

**Dados de fontes reais:**
- Carne Village, Overlord, dificuldade Classic/Hard, número de waves;
- Inimigos e a partir de qual wave: Invasor, Batedor, Blindado, Capitão Invasor, Nigun e invocações angelicais;
- Gold, fragmentos do Selo Solar e bônus previsto de primeira vitória, conforme `StoryRewardConfig`;
- Drop raro **Insígnia Solar**, chance de **8% no Classic / 12% no Hard** e **hard pity de 15 vitórias elegíveis**;
- O **elemento da fase** aparece como *a definir* porque o catálogo ainda não o estabelece;
- **XP** aparece como *não configurado*.

**Importante:** o atual `StoryRewardConfig` descreve recompensas e o cálculo do sorteio, mas ainda não há serviço integrado de entrega/salvamento de drops. Portanto:
- O progresso real de pity e a posse da Insígnia Solar aparecem como **--/15** / *ainda não conectado*;
- Não é concedida nenhuma recompensa pelo HUD;
- O **Anel da Restrição 0/10** foi um exemplo de interface anterior, não o item raro real configurado para Carne Village.

## Prévia visual do pity no Studio

Somente no **Roblox Studio**, a seção do item raro exibe o botão **SIMULAR CHECK / PRÓXIMO PITY**.

Ao tocá-lo, o estado visual local alterna:
1. `Não obtido — 0/15`;
2. `✓ Obtido — Próximo pity: 0/15` (o contador reiniciou, mas o check permaneceu);
3. `✓ Obtido — Próximo pity: 3/15` (o novo ciclo continuou, mantendo o check);
4. Volta ao estado inicial para testar novamente.

Isso demonstra o comportamento visual. **Não salva, não atribui itens e não altera a chance dos drops.**

## Checklist para quando abrir o Roblox Studio

- [ ] Baixar da execução mais recente de `Anime Fissure - Build Beta` na branch `main` (check verde).
- [ ] Abrir `AnimeFissure-Beta.rbxlx` no Roblox Studio.
- [ ] Entrar em Play: ainda no lobby, o Stage Info **não** aparece.
- [ ] Clicar em JOGAR; já na arena, o botão `STAGE INFO` aparece na direita.
- [ ] Abrir o painel; ver Carne Village, Classic/Normal e 15 waves.
- [ ] Conferir a seção de inimigos com suas ondas de aparição.
- [ ] Conferir Gold 150, 3 fragmentos, bônus 100 na primeira vitória e a Insígnia Solar 8% / 15 pity.
- [ ] Conferir as mensagens de elemento e XP ainda não configurados.
- [ ] Usar o botão do Studio para simular check e o reinício do pity (duas vezes). O check deve continuar no segundo ciclo.
- [ ] Fechar o painel; o botão deve permanecer pequeno e clicável.
- [ ] Verificar que o HUD básico de waves, Yen, vida e botões de Skip/Auto Skip continua funcionando.
- [ ] Testar em emulador mobile do Studio, conferindo se o painel é rolável e cabe na tela.
- [ ] Voltar ao lobby/encerrar Play e verificar que não existe GUI de Stage Info fora da arena.

Se houver erro, enviar captura do **View → Output** e da área direita da tela.

## Arquivos envolvidos

- `src/shared/StageInfoConfig.luau`
- `src/server/BetaBridge.server.luau`
- `src/client/StageIntelHUD.client.luau`
- `src/shared/StoryRewardConfig.luau` (somente leitura, não modificado)
- `AGENTS.md` (preferência registrada: enviar códigos diretamente ao GitHub)
