# Lobby Reference Project — biblioteca de modelos e benchmark
Data: 27/11/2026. Pesquisa pública de guias e catálogos; não foram extraídos arquivos de experiências alheias. Nenhum asset abaixo foi inserido, inspecionado no Studio ou comprado.
## Referências
- Anime Expeditions: https://allthings.how/anime-expeditions-robloxs-upcoming-anime-tower-defense-game/ — cidade, água, árvores, arquitetura, áreas identificáveis.
- Anime Vanguards: https://allthings.how/anime-vanguards-on-roblox-how-to-get-and-equip-units/ — atalhos de áreas e invocação.
- ASTD X: https://progameguides.com/roblox/all-star-tower-defense-x-mission-npc-locations/ — NPCs junto a marcos arquitetônicos, jardins e fonte.
- Anime Adventures: https://allthings.how/how-to-get-shinobi-awakened/ — painel de unidades na área Summon.
- Anime Defenders: https://animedefenders.fandom.com/wiki/Traits — proximidade entre serviços relacionados.
- TDS: https://tds.wiki/w/Main_Lobby — áreas de descanso, modos, eventos e decoração.
## Candidatos Creator Store
| ID | Pacote | Uso | Estado |
|---|---|---|---|
| 6933438443 | Synty Nature Pack | vegetação, pedras | candidato |
| 6933556508 | Synty City Pack | fachadas, ruas, parques | candidato |
| 6934021345 | Synty Dungeon Pack: Cave & Castle Interiors | arcos, runas, interiores, Babilônia | candidato |
| 6432306802 | Forest Pack (Roblox) | árvores, plantas, pedras | alternativa |
| 6370681139 | City Props Pack (Roblox) | postes, bancos, vasos | alternativa |
| 137359325549586 | PBR Modular Sci-Fi Kit | painéis e arquitetura futurista | avaliar autor, licença, custo e desempenho |
| 119500909260565 | Japanese temple by DAV | santuário japonês | avaliar autor, licença, custo e desempenho |
Links: https://create.roblox.com/store/asset/{ID} (substituir pelo ID).
Alternativas externas: https://quaternius.com/packs/modularscifimegakit (CC0); https://kenney.nl/assets/nature-kit (CC0); https://baziliqgames.itch.io/japanese-town (verificar licença e preço, não redistribuir como asset independente).
## Integração
1. Em arquivo separado Baseplate, no modo Edit, adquirir os pacotes autorizados pelo proprietário via Toolbox/Creator Store. Nunca baixar mapa extraído de jogo protegido.
2. Inspecionar árvore de objetos, remover scripts, módulos, remotes, prompts e outros elementos que não sejam arte. Verificar dependências de malhas e texturas e permissões do jogo final. Selecionar apenas peças úteis, não importar pacote inteiro para o lobby.
3. Criar biblioteca de modelos estáticos com pivôs coerentes, nomes descritivos e escala em studs; registrar autor, URL, licença, data, versão, triângulos, partes, dependências, uso e teste.
4. Exportar seleção como .rbxmx ou .rbxm para avaliação e integração Rojo. Não usar require(assetId), carregamento remoto em produção ou scripts de terceiros.
5. Substituir exclusivamente arte decorativa por setor, mantendo IDs, remotes, prompts, piso e rotas funcionais. Não alterar economia, progressão, eventos ou combate.
6. Medir FPS/memória PC e mobile e verificar carregamento, colisão e luz. NPCs com visual de anime exigem modelos próprios ou autorização de direitos correspondente.
Fontes de segurança: https://create.roblox.com/docs/production/creator-store ; https://github.com/Roblox/creator-docs/blob/main/content/en-us/scripting/security/third-party-vulnerabilities.md
## Ordem proposta
A: natureza Synty; B: arquitetura Synty City/Dungeon; C: identidade sci-fi (somente se compatível); D: testar um distrito inteiro (Vergil + Dante); E: expandir após aprovação visual. Preservar versão 0.3.5 como base. Não incluir candidatos sem aprovação de licença e revisão.

## Fissure City Reborn 0.3.6 — primeiro estágio implementado
- Biblioteca ServerStorage/LobbyAssetLibrary mapeada via Rojo em assets/lobby. Ainda vazia, sem modelos externos efetivamente importados.
- Slots GardenTree (12 cópias, até 3 BaseParts cada) e SakuraTree (16 cópias, até 8 BaseParts cada), pelo menos uma malha. Escala e pivô normalizados e colisão desativada. Na falta de modelo aprovado, continua o cenário procedural.
- Para importar: abrir Baseplate separado em modo Edit; Toolbox > Creator Store > Synty Nature Pack (6933438443); selecionar individualmente uma árvore com as permissões adequadas. Executar tools/StudioAssetIntake.luau na Command Bar depois de preencher SLOT, SOURCE, CREATOR, LICENSE e confirmar direitos. Conferir visual e malhas/texturas no Studio; exportar a seleção preparada como GardenTree.rbxmx ou SakuraTree.rbxmx e entregar para integração em assets/lobby. Não executar Play com pacote bruto.
- Não confundir validação estrutural com garantia de segurança, licença ou desempenho; testar aparência e permissões em experiência de teste. Exportar apenas se a licença permite armazenar/compartilhar no repositório; caso contrário manter importação na experiência autorizada. Não publicar modelos de personagens sem direitos.
- Próxima fase: piloto arquitetônico Vergil + Dante após receber modelos revisados. Não substituir fachadas por assets ainda não escolhidos ou disponíveis.

## Premium modular shortlist — 0.3.7 (27/11/2026)
| Asset | Official source | Approval (catalog snapshot) | MeshParts | Intended use |
|---|---|---|---|---|
| Synty City | https://create.roblox.com/store/asset/6933556508 | 96%, 1K votes | 332 | Summon, Index, Alchemy, Traits, skyline |
| Synty Dungeon | https://create.roblox.com/store/asset/6934021345 | 97%, 700+ votes | 271 | Evolution, Raids, Babylon visual research |
| Synty Nature | https://create.roblox.com/store/asset/6933438443 | 96%, 800+ votes | 200 | Garden and landscape |
| City Props | https://create.roblox.com/store/asset/6370681139 | 96%, 600+ votes | 94 | benches and props; contains 2 scripts, reject all scripts |
| Low Poly Fountain | https://create.roblox.com/store/asset/8466452406 | 98%, 100+ votes | not verified | optional fountain; check rights and inspect |
Catalog votes are not a guarantee of quality or safety. Total 897 MeshParts across four official packs, not distinct models. None acquired or downloaded into repo.

### Slots and geometry
- SummonFacade, IndexFacade, AlchemyFacade, EvolutionFacade, TraitsFacade, RaidsFacade: one each, <=24 parts, thin backdrop maximum 5 studs deep, 13–16 studs target height, width per existing district. Reject models too short after fitting. Only replace procedural structural facade after accepted placement; retain thematic props and prompts.
- SkylineTower: nine copies, <=5 parts each. CityBench: four copies, <=4 parts each. GardenFountain: two optional copies, <=12 parts each, outer terraces only. GardenTree and SakuraTree unchanged.
- StudioAssetIntake now stages all slots with Reviewed=false. Check visual geometry, asset permission, actual license and scale; set Reviewed=true only after final review. Export .rbxmx only if allowed by license. Keep original map if none accepted.
- Studio run and visual comparison are still required. No full external map or third-party NPC has been imported. No purchase authorized or made.

## Character asset pipeline
Pesquisa: Creator Store contém R6 Anime Characters pack (https://create.roblox.com/store/asset/135335653753962/R6-Anime-Characters-pack), Legendary Anime Character Pack (https://create.roblox.com/store/asset/133980450223134) e Voxel Characters NPC Pack (https://create.roblox.com/store/asset/102696004386746). Não são os oito mentores comprovadamente autorizados; não adquirir ou importar automaticamente. O pack voxel custa US$4,99, sem avaliações na consulta, com scripts; não priorizar.
Bases preferidas: arquivos oficiais Roblox (https://create.roblox.com/docs/avatar/character-bodies/project-files), Robuta-HigherFidelity e Lola; Quaternius Ultimate Animated Character Pack (https://quaternius.com/packs/ultimatedanimatedcharacter), Modular Character Outfits Fantasy (https://quaternius.com/packs/modularcharacteroutfitsfantasy.html), 12 roupas e 62 partes CC0. As fontes externas exigem importação/conversão; não são modelos prontos dos mentores.
Slots estáticos NPC_Vergil, NPC_Edward, NPC_Dante, NPC_Whis, NPC_Urahara, NPC_Jinwoo, NPC_Gilgamesh, NPC_Escanor. <=24 BaseParts por modelo, pelo menos uma malha, metadados de origem/licença e revisão explícita. A aparência aceita é colocada por tamanho e orientação; os IDs, anchors, prompts e pedestais originais permanecem. Sem modelo aprovado, mantém procedimento anterior. Escanor apenas prévia Studio. Nenhum modelo novo foi adquirido, importado ou animado nesta entrega.
Para pipeline atual, preparar malhas e texturas com pose estática, sem bones, roupa em camadas, acessórios dependentes de scripts ou Humanoid. Para rigs animados, implementar validação independente antes de uso. Não extrair modelos de jogos; presença na Creator Store não prova direito sobre personagens de terceiros. https://create.roblox.com/docs/ip-licensing/creators . Piloto: Vergil e Dante, depois outros. Personalizar paleta e insígnias Fissure depois de aprovar visual, desempenho e direitos.
