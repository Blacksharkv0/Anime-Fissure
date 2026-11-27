# Anime Fissure — Distribuição dos itens de evolução de Overlord (v1.0)

**Definições do criador registradas em 26/11/2026.** Os cinco anéis agora têm **dupla função: Relíquia + Material de Evolução**, com protótipo de equipamento no Studio. A entrega real, rates, receitas e pity ainda não estão habilitados. Consulte [ANEIS-RELIQUIAS-EVOLUCAO-v1.0.md](ANEIS-RELIQUIAS-EVOLUCAO-v1.0.md).

## Itens por fase

| História | StageId | Mapa | Item definido | Situação do modo |
|---|---|---|---|---|
| 1 | OVL_01 | Carne Village | **Anel de Magic Power** | **Hard**, conforme discussão anterior sobre o farm de evolução do Ainz |
| 2 | OVL_02 | Cemitério de E-Rantel | **Anel de SPA** | Dificuldade de drop a decidir |
| 3 | OVL_03 | O Rei da Floresta | **Anel de dano físico** | Dificuldade de drop a decidir |
| 4 | OVL_04 | A Valquíria Sangrenta | **Item de evolução da Shalltear** | Dificuldade de drop a decidir |
| 5 | OVL_05 | A Guerra dos Homens-Lagarto | **Anel de range** | Dificuldade de drop a decidir |
| 6 | OVL_06 | O Trono de Nazarick | **Anel da restrição** e **item de evolução da Albedo** | Dificuldade de drop a decidir |

**Total: sete materiais em seis mapas.**

## Escopo acordado

- O **Anel de Magic Power** de Carne Village Hard está associado ao planejamento de farm da evolução do **Ainz**, mas **quantidades, receita completa e destino dos demais anéis não foram definidos**.
- Item de evolução da **Shalltear** e da **Albedo** possuem vínculo explícito com essas unidades.
- **Efeitos dos anéis agora definidos:** Magic Power +20% dano mágico, Físico +20% dano físico, SPA ×0,80, Range ×1,20, Restrição Dano ×2 e SPA ×2. Esses bônus **somente valem quando a relíquia NÃO está equipada no Ainz**. Quando equipada no Ainz, vira apenas item de evolução, sem bônus comum.
- Os materiais **não estão sendo entregues** por vitória; não há taxas de drop e pity configurados para os sete novos itens.
- As chances e o Hard Pity já existentes para **Insígnia Solar** no protótipo de Carne Village são um sistema separado, ainda não conectado a entrega persistente. Não substituímos silenciosamente Insígnia Solar nem herdamos suas taxas e pity para o novo Anel de Magic Power.
- **Somente o primeiro mapa foi explicitamente associado ao Hard** até o momento. Não presumir as dificuldades dos outros cinco antes da definição.
- Os outros cinco mapas constam de StoryConfig como catálogo de história, mas não contam necessariamente com todas as cenas ou a entrega de recompensas prontas.

## Código publicado

- `src/shared/OverlordEvolutionLootConfig.luau`: registro original por StageId, IDs estáveis, nomes, vínculos conhecidos e dupla categoria EvolutionRelic para os cinco anéis; API `GetItem`, `GetStageItems`, `GetPlannedPreview` e `IsDropEnabled` (sempre false).
- `src/shared/RelicRingConfig.luau` e `src/shared/RelicRingModelBuilder.luau`: bônus, bloqueio no Ainz e modelos 3D autorais.
- `src/shared/StageInfoConfig.luau`: Carne Village Hard informa planejado o Anel de Magic Power; Classic não mostra esse item.
- `src/client/StageIntelPanel.luau`: área separada "ITENS DE EVOLUCAO • PLANEJADOS", sem fingir chance, pity, marca de obtido ou entrega.
- `src/server/OverlordEvolutionLootSmokeTest.server.luau`: valida catálogo de seis mapas/sete itens, dificuldade Hard do primeiro e ausência de drops ativos.
- `.github/workflows/build-beta.yml`: valida presença dos módulos e pontos de integração.

## Próximas decisões de design (ainda não tomadas)

1. Chances e Hard Pity **individual** para cada item; se drops de rings são exclusivos de Hard, ou existem no Classic com chances inferiores.
2. Quantidade de materiais necessária para as evoluções de Ainz, Shalltear e Albedo.
3. Se os anéis são consumíveis de evolução, materiais de crafting, equipamento ou mais de um desses.
4. Persistência no inventário, UI de recompensa ao fim da wave/fase, integração ao Stage Info e testes de concessão por vitória legítima.
5. Se as seis fases compartilharão um mesmo sistema de recompensas com 2 itens no Trono de Nazarick, cada um com pity independente.

## Como conferir agora

Depois de confirmar o build verde mais recente em https://github.com/Blacksharkv0/Anime-Fissure/actions, entre no Roblox Studio em Carne Village **Hard** e abra **Stage Info**. Deve aparecer o "Anel de Magic Power" como **planejado**, com texto "chance a definir • drop NÃO ativo". No Classic, esse item não deve aparecer nessa seção.

**Aviso:** arquivos publicados e checagem estática não equivalem à execução confirmada no Roblox Studio.
