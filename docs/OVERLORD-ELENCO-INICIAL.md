# Anime Fissure — Elenco inicial de Overlord

**Decisão do criador em 22/11/2026.** Este arquivo registra **identidade e raridade**, não confirma habilidades, preços, aparência, banner, disponibilidade ou drops.

## Raridades aprovadas

| Raridade | Unidade | ID reservado |
|---|---|---|
| **Secreto** | **Ainz** | OVL_Ainz |
| **Mítico** | **Albedo** | OVL_Albedo |
| **Lendário** | **Shalltear** | OVL_Shalltear |
| **Épico** | **Gazef** | OVL_Gazef |
| **Raro** | **Brain** | OVL_Brain |
| **Comum** | **Climb** | OVL_Climb |

O catálogo está em src/shared/OverlordUnitRoster.luau. Todos os seis registros possuem Status = Planned e ObtainMethod = Undecided. **Nenhum está liberado para colocação nem adicionado ao Summon.** Não alterar o banner simplesmente por registrar os personagens.

## Possíveis papéis de jogo — apenas SUGESTÕES

Não são atributos, habilidades ou valores confirmados pelo criador.

| Unidade | Direção criativa a discutir | Sistema necessário |
|---|---|---|
| Climb | Espadachim terrestre, ataque básico consistente | alvo único, progressão simples |
| Brain | Esgrimista de precisão, crítico ou golpe carregado | crítico, passiva condicional |
| Gazef | Guerreiro físico, cortes frontais e dano em área | AoE/cone, VFX de golpe |
| Shalltear | DPS vampírico de lança, sustentação e transformação | passivas, efeitos persistentes |
| Albedo | Guardiã híbrida de suporte/controle/armadura | buff/debuff, controle |
| Ainz | Mago secreto com área, maldições e cooldowns especiais | magia, AoE, DOT e skills ativas |

**Ordem técnica sugerida:** Climb → Brain → Gazef → Shalltear → Albedo → Ainz. Ela aumenta gradualmente a complexidade do motor de combate. Não significa que raridade alta seja melhor em toda função.

## Regras prévias a preservar

- Uma Trait equipada por unidade; raridade da Trait não determina automaticamente a melhor sinergia.
- Deck de 6 unidades, sem repetição da mesma unidade no deck; duplicatas armazenadas separadamente.
- Limites individuais de colocação, venda por 50% do custo total investido.
- Interações de crítico, DOT, elementos, reações, controle, escudos e boss devem seguir a auditoria de design do projeto.
- Visual anime com desempenho aceitável em mobile.
- Ainz jogável (OVL_Ainz) é separado do boss futuro da fase OVL_06; Shalltear jogável (OVL_Shalltear) é separada do boss de OVL_04.
- Raridade Secret da unidade não concede Trait Unique automaticamente.

## Antes de tornar uma unidade jogável

1. Definir método de obtenção, forma normal/Shiny e evolução, quando existir.
2. Aprovar papel, tipo de alvo, custo, dano, alcance, SPA, limites e upgrades.
3. Aprovar ataques, habilidades ativas/passivas, cooldowns, elementos e efeitos.
4. Criar modelo, animações e VFX (com alternativa leve mobile).
5. Integrar ao motor de Towers, coleção/deck e, apenas se aprovado, Summon.
6. Testar no Roblox Studio.

**Estado atual:** lista de personagens e raridades confirmada; gameplay, números e disponibilidade ainda pendentes.
