# Anime Fissure — Anéis: Relíquias e Materiais de Evolução (v1.0)

**Data:** 26/11/2026. **Status:** publicação no GitHub. Inspeção estática, sem validação de execução no Roblox Studio.

## Definição aprovada

Os cinco anéis têm dupla função: **Relíquia equipável** e **Material de Evolução de Ainz**. Os benefícios abaixo funcionam quando o usuário NÃO equipa o item no Ainz. Se qualquer um dos anéis for colocado no Ainz, o bônus normal se torna **inativo**: o anel permanece reservado ao papel de item de evolução, mas ainda não temos receita, quantidades ou consumo configurados.

| Relíquia | Mapa de origem | Efeito fora do Ainz | Visual 3D |
|---|---|---|---|
| Anel de Magic Power | Carne Village Hard | +20% dano mágico em Towers Magic | Ouro, ametista violeta e runas suspensas |
| Anel de dano físico | O Rei da Floresta | +20% dano físico em Towers Physical | Garras de aço, rubi e halo vermelho |
| Anel de SPA | Cemitério de E-Rantel | SPA ×0,80 (intervalo 20% menor) | Relógio ciano com ponteiros prateados |
| Anel de range | Guerra dos Homens-Lagarto | Range ×1,20 (alcance 20% maior) | Esmeralda e mira de bússola verde |
| Anel da restrição | Trono de Nazarick | Dano ×2 e SPA ×2, ataque mais lento | Coroa escura, duas gemas e correntes |

**Anel da restrição:** apesar de aumentar o dano por golpe, ele dobra o intervalo de ataque, portanto não aumenta o DPS bruto: (2 × dano)/(2 × SPA) = mesmo DPS. O impacto tático pode mudar conforme críticos, multi-hit e efeitos disparados por ataque.

**Categoria dupla:** registro como EvolutionRelic no catálogo. Os outros itens da Shalltear e da Albedo continuam EvolutionMaterial, sem benefícios equipáveis definidos.

## Implantado no código

- **RelicRingConfig.luau** define todos os cinco bônus, cores, atributos e a exceção do Ainz.
- **OverlordEvolutionLootConfig.luau** mantém a distribuição nos seis mapas, com cinco anéis marcados simultaneamente como relíquia/evolução.
- **RelicRingModelBuilder.luau** monta cinco anéis usando apenas peças Roblox, metais, vidros, brilhos e ornamentos; sem MeshId de terceiros.
- **RelicRingModels.server.luau** gera modelos visuais no Studio.
- **RelicRingGallery.client.luau** cria laboratório de visualização em 3D, no lobby, separado da arena. O menu informa cada efeito e mapa de origem.
- **RelicRingEquipVisuals.client.luau** mostra marcador luminoso do anel acima da Tower equipada no Studio.
- **TowerService.luau** aplica no servidor as alterações de dano, alcance e tempo de ataque para seleção de alvo, combate e HUD.
- **OverlordCombatPrototype.luau** passa a respeitar Element: Albedo é Physical e Ainz é Magic; o Range da Shalltear também afeta a captação de Blood Pool.
- **TowerHUD.client.luau** apresenta relíquia, efeito e controle de laboratório.
- **StageInfoConfig.luau** e **StageIntelPanel.luau** indicam em Carne Village Hard que o Anel de Magic Power é relíquia e item de evolução planejado, sem inventar sua taxa.
- **RelicRingSmokeTest.server.luau** valida atributos, incompatibilidades, visual 3D, exceção do Ainz e não ativação dos drops.

## Controle de equipar — regras do protótipo

Cada Tower colocada possui **um slot de relíquia**. Essa é uma escolha de protótipo para o combate, ainda revisável para o futuro.

Na arena de laboratório do Roblox Studio, selecione uma Tower própria e use **EQUIPAR / TROCAR ANEL (STUDIO)**. Cada toque alterna Magic → Físico → SPA → Range → Restrição → Nenhum. Somente o dono pode alterar o equipamento; o servidor valida todos os pedidos. Os atributos são recalculados no servidor, sem dar um golpe extra ou reiniciar o cooldown na troca.

**Importante:** essa função funciona **apenas no Studio**, como teste visual e de combate. Não cria um item possuído, não salva a relíquia, não concede drops e não consome materiais. Em produção, equipar deverá verificar o inventário persistente e a propriedade da relíquia.

## Caso de teste

- Albedo Lv1: 700 de dano básico; equipando Anel de dano físico fica com 840 de dano, antes de sinergias. O anel mágico nela não funciona, porque a configuração e o servidor agora classificam seus ataques como Physical.
- FissureMage: anel de Magic Power ativa +20% no dano mágico.
- Brain: anel de SPA reduz intervalo de ataques em 20%.
- Ainz Lv1: 1000 de dano. **Nenhum** dos cinco anéis muda seu Dano/SPA/Range normal.
- Restrição em um personagem não-Ainz: Dano ×2, SPA ×2.
- Carne Village Hard no Stage Info: ver o anel com descrição de bônus e status **planejado, sem drop real**.

Verifique a build em https://github.com/Blacksharkv0/Anime-Fissure/actions e depois abra View > Output no Studio. A mensagem esperada do teste é **RELIC RINGS STUDIO OK**.

## Pendências intencionais

Faltam ainda o inventário de relíquias (persistência), chances de drop e Hard Pity, os requisitos/quantidades da evolução de Ainz, um serviço de evolução definitiva, e a disponibilização fora do Studio. Não se deve confundir o preview com posse real. A categoria separada RelicTraitSeal dos materiais de reroll da economia permanece intacta.
