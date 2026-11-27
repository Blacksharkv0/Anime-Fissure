# ANIME FISSURE — ROADMAP DE PRODUÇÃO 1.0
## Operação ASCENSION
Plano de trabalho proposto em 27/11/2026. As versões abaixo são marcos de entrega, não datas ou garantias de lançamento. Desenvolvimento solo; cada entrega tem critérios de aceitação. Estado inicial: demo com Story Carne Village, Vergil e Edward visíveis no teste do usuário, diagnóstico anterior 4/13, hotfix de bootstrap publicado mas ainda não confirmado no Play. Modelos procedurais e vários serviços somente informativos. Não confundir build Rojo com execução real.

## 0.1 Foundation — P0, bloqueante
- [ ] AF-001 — Investigar Output do Studio; confirmar hotfix de BabylonHall e LobbyServiceStations. Capturar erros de compilação Luau e stack traces.
- [ ] AF-002 — Garantir 13/13 no diagnóstico; testar prompts dos sete NPCs e praça central, inclusive toque. Nenhum verde falso: separar presença, interação e função transacional.
- [ ] AF-003 — Adicionar compilação sintática Luau aos checks da CI (não apenas grep e Rojo). Registrar falhas de inicialização com nome de módulo e etapa.
- [ ] AF-004 — Validar Story Classic/Hard, venda/upgrade, pós-partida e retorno ao lobby; repetir sessões. Preservar branch main e artefato de build anterior.
Aceite: carregamento completo, nenhum erro bloqueante no Output; testes de interação executados em Studio, build associado ao SHA publicado.

## 0.2 Character Reborn — P1
- [ ] AF-010 — Criar padrão de rig e proporções anime estilizadas, rosto, cabelo em mechas, roupas em camadas, acessórios, idle e pontos de interação. Usar modelos próprios/licenciados; protótipos podem ser feitos com Parts, malhas finais demandam modelagem/importação. Padronizar pivot, hitboxes, escala e materiais.
- [ ] AF-011 — Vergil: sobretudo azul longo, cabelo prateado, bainha/espada, pose serena, aura de invocação.
- [ ] AF-012 — Edward: casaco vermelho, trança loira, braço metálico, luvas e pose de alquimista.
- [ ] AF-013 — Gilgamesh: armadura dourada segmentada, ornamentos, postura real, pedestal e brilho controlado.
- [ ] AF-014 — Sung Jinwoo: casaco escuro, adagas espectrais, olhos violetas, aura de sombras.
- [ ] AF-015 — Dante: casaco vermelho aberto, cabelo branco, espada, pose relaxada.
- [ ] AF-016 — Whis: cabelo alto, pele azul, aro celestial, cajado e detalhes geométricos.
- [ ] AF-017 — Urahara: chapéu listrado, quimono verde, leque e sandálias.
- [ ] AF-018 — Escanor como prévia sazonal exclusivamente no Studio; manter evento desligado.
Aceite: cada silhueta reconhecível sem etiqueta, câmera de inspeção frente/lado/costas, materiais consistentes, sem bloquear caminhos e prompts. Aprovação visual pelo criador no Studio.

## 0.3 Fissure City — P1
- [ ] AF-020 — Masterplan do hub, eixo central, rotas, distância entre NPCs e expansão do piso; preservar portal/spawn e referências de navegação.
- [ ] AF-021 — Vergil altar/cápsulas; Edward oficina com frascos, orbes e livros; Dante arquivo holográfico adjacente ao Vergil.
- [ ] AF-022 — Whis santuário celestial; Urahara loja/laboratório; Jinwoo portal dimensional.
- [ ] AF-023 — Gilgamesh Salão da Babilônia: 11 portais de armas, cinco vitrines de anéis, trono, colunas e iluminação dourada.
- [ ] AF-024 — Praça central com símbolo da Fissure e anfitrião rotativo; sem simular evento ativo.
- [ ] AF-025 — Piso com caminhos, canteiros, bordas, sinalização e iluminação. Luz local por setor; evitar efeitos excessivos. Separar decoração e hitboxes.
Aceite: visita a pé a todas estações, caminhos sem colisões indevidas, interação em PC/toque, centro visível e performance medida no dispositivo alvo.

## 0.4 Anime Arcade — P1
- [ ] AF-030 — Design tokens de cor, tipografia, espaçamento e estados de botão. Menu lateral, terminal de missões, painéis de NPCs e transições.
- [ ] AF-031 — Coleção em grade, painel de detalhes, ordenação, favoritos/cadeado, duplicatas separadas e três decks salvos (interface integrada ao inventário na 0.5). Deck 6 unidades sem repetição.
- [ ] AF-032 — Summon com revelação, skip e feedback real; não simular prêmio.
- [ ] AF-033 — HUD de combate: barra expansível, preview, upgrade/MAX, venda confirmada, habilidades, Stage Info com pity e status reais.
- [ ] AF-034 — Mobile: arrastar/soltar, alvos de toque, safe area, teclado/controle, foco e modais. FX leve/padrão.
Aceite: sem sobreposição de modais, texto cortado ou controles inacessíveis em PC e mobile; sem operações falsas.

## 0.5 Core Systems — P0 para progressão
- [ ] AF-040 — Inventário persistente versionado com IDs únicos por unidade, validação servidor, migração, tratamento de falhas de DataStore, save/rejoin.
- [ ] AF-041 — Gold fora da partida, FissureGems para summon/loja conforme design aprovado; separar Yen em partida (700 inicial). Definir migração dos SummonTickets existentes sem alterar economia silenciosamente.
- [ ] AF-042 — Summon com chances publicadas, pity, resultado transacional e proteção contra requisição duplicada. Ainz fora do banner.
- [ ] AF-043 — Coleção, decks, evolução com Whis preservando nível e trait, crafting de orbes/materiais com Edward, relíquias universais com Gilgamesh.
- [ ] AF-044 — Traits com Urahara: uma por unidade, reroll com moeda própria, alerta para traits raras definidas; raridade não define melhor sinergia. Reroll de relíquias separado.
- [ ] AF-045 — Recompensas reais, pity individual visível, persistência e idempotência.
Aceite: nenhum item/moeda concedido pelo cliente, nenhum saldo negativo, duplicação ou perda em reconexão; inventário e pity sobrevivem reinício.

## 0.6 Overlord — P1
- [ ] AF-050 — Finalizar Carne Village Classic (15 waves) e Hard (20), testar inimigos, escudos e chefe Nigun Grid Luin; expandir demais fases apenas após primeira concluída.
- [ ] AF-051 — Climb, Brain, Gazef, Shalltear, Albedo e Ainz com modelos, progressão visual de ataques, passivas e VFX; Ainz secreto de Legend Stage.
- [ ] AF-052 — Integrar cinco anéis e itens de evolução conforme regras existentes; efeitos comuns suprimidos em Ainz. Conferir sinergia Albedo/Ainz.
- [ ] AF-053 — Stage Info e drops reais, Legend Stage jogável antes de conceder Ainz.
Aceite: fase completa repetível, recompensas reais, seis unidades com comportamento verificável e performance medida.

## 0.7 Combat Ascension
- [ ] AF-060 — Elementos/resistências, Shield antes de HP, DOT independente e acúmulo controlado, crítico, buffs/debuffs, limites individuais.
- [ ] AF-061 — Bosses de duas fases com avisos, controle progressivo e habilidades interrompíveis conforme regra específica.
- [ ] AF-062 — Bulma farm: unevo 3 cópias, evo 1; renda por wave e bônus final; sete esferas e desejo manual único (poder ou dinheiro), números conforme design aprovado.
- [ ] AF-063 — Balancear Traits e sinergias com simulações e partidas reais; venda 50% incluindo upgrades.
Aceite: testes determinísticos de dano e economia, chefes legíveis e nenhuma estratégia obrigatória por raridade.

## 0.8 Multiplayer
- [ ] AF-070 — Lobby/arena separados logicamente, ciclo de partidas repetível, coop de até 4, decks individuais, repetição entre jogadores permitida.
- [ ] AF-071 — Votação de início, Auto Start individual, 1x/2x grátis, 3x condicionado ao passe/líder conforme regras aprovadas.
- [ ] AF-072 — Reconexão por até 3 min, tratamento de desconexões e remoção de unidades conforme regra acordada.
- [ ] AF-073 — Resultado com janela de 30s, Continuar/Sair/Avançar somente quando disponíveis; retorno automático ao lobby.
Aceite: quatro clientes em Studio, teste de entrada/saída do líder, reconexão, vitória/derrota e segunda partida sem reiniciar servidor.

## 0.9 Closed Beta
- [ ] AF-080 — Medir FPS, memória e tempo de entrada no PC e Android (incluindo Poco X7 Pro), comparar FX leve/padrão; metas provisórias de 30 FPS mobile e 60 FPS PC quando hardware permitir.
- [ ] AF-081 — Testes de segurança dos remotes, abuso de transações, falhas de rede, salvamento e recuperação.
- [ ] AF-082 — Testes de UX com jogadores, acessibilidade, correção de bugs, relatórios e regressões.
- [ ] AF-083 — Revisão de propriedade intelectual, direitos de uso dos personagens/assets e políticas Roblox antes de disponibilização pública.
Aceite: zero bloqueadores conhecidos, métricas verificadas em dispositivos reais, aprovação do criador e licenças resolvidas.

## 1.0 Genesis
- [ ] AF-090 — Publicar somente sistemas testados; raids e eventos sazonais entram quando tiverem fases, recompensas e matchmaking implementados.
- [ ] AF-091 — Tutorial, onboarding, changelog, comunicação e plano de rollback.
- [ ] AF-092 — Monitorar estabilidade, economia e feedback pós-lançamento.

## Fluxo de trabalho
P0 bloqueia entrega; P1 é essencial; P2 é polimento opcional. Fazer entregas pequenas e verificáveis. Backlog -> Em desenvolvimento -> Revisão estática/CI -> Studio Play -> Aprovado. Cada pacote registra SHA, artefato .rbxlx, testes efetivamente executados, bugs conhecidos e o que não mudou. Não marcar aprovação visual/funcional sem evidência. Próxima entrega: Foundation (13/13 e Output), seguida por primeiro pacote visual Vergil/Edward/Gilgamesh; o restante continua no backlog.
