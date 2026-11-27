# Gilgamesh — 3 prompts de design para Roblox | Anime Fissure

**Status**: prompts de conceito para imagem de referência / modelagem, **não são arquivos 3D, meshes, animações nem personagem já publicado no jogo**. Complementa [SALÃO DA BABILÔNIA](LOBBY-SALAO-BABILONIA-DESIGN-v1.0.md).

## Seleção recomendada

**Escolha principal: B — Premium, o Mestre das Relíquias.**

Para a fase inicial de desenvolvimento, usar a A como modelo de performance-base, depois elevar para a B. A C é ótima para estátuas ornamentais e ícones, **não** para substituir o NPC interativo.

Identidade de Fate a reconhecer: cabelos loiros espetados, olhos rubi, armadura majestosa dourada com revestimentos escuros, capa/tecido vermelho vinho, linguagem corporal orgulhosa. Evitar corpos hipermusculosos, cabeças realistas, animação rígida ou modelagem "Roblox blocky" grosseira.

## PROMPT A — Gilgamesh NPC padrão (leve e pronto para Roblox)

**Uso**: versão intermediária de baixo custo visual, com rig R15 compatível e formas simples, para validar escalas e navegação.

> Create a full-body character turnaround reference sheet for a ROBLOX STUDIO 3D NPC depicting Gilgamesh from Fate as the King of Treasures. Three clear orthographic views: FRONT, LEFT SIDE, and BACK, all showing exactly the same stylized character. He is a tall youthful anime man with short sharply swept spiky golden-blond hair, crimson red eyes, narrow confident eyebrows, a smug regal smile, and slightly elongated Roblox R15-compatible humanoid proportions. He wears recognizable bright polished golden plate armor with a clean angular layered chestplate, broad but readable shoulder pauldrons, gold bracers, shin guards and boots, dark navy-black fabric between plates, engraved sapphire-dark line accents, and a single deep red waist cape behind him. The silhouette must be readable at medium game camera distance and attractive in a Roblox anime tower defense lobby. Use crisp anime-inspired 3D shapes, hard edges with subtle beveling, simplified geometry, authored materials, and restrained highlights. Character stands in a neutral relaxed A-POSE suitable for rigging; no weapon in hand, no portals, no environment. Plain neutral background, consistent perspective-free view, equal proportions across all three angles. Prioritize animation-ready separable armor parts and performance-friendly Roblox Studio construction.

**Negative prompt A**:
> photorealistic human, realistic skin pores, a standard cube Roblox noob, chibi head, disproportionate arms, extra fingers, floating armor, missing hands, huge unreadable hair, excessive glow, text overlays, watermarks, external scenery, violent expressions, weapons intersecting body, low-resolution blurry material.

**Nota de produção A**: R15 ou custom equivalente; 1 Humanoid, 1 PrimaryPart; armor pieces welded/rigged to limbs. Não usar modelo importado de outro jogo sem licença. O prompt produz **referência**, não um rig funcional por si só.

## PROMPT B — Gilgamesh Premium, Mestre das Relíquias (ESCOLHIDO)

**Uso**: direção final do NPC central. Fazer referência para modelador/Blender + Studio e uma versão isolada em pose de apresentação.

> Design an exceptionally polished anime-stylized Roblox 3D game character concept of GILGAMESH (Fate), reimagined as the proud MASTER OF RELICS in the golden Hall of Babylon of the anime tower defense game Anime Fissure. Full-body hero reference, elegant semi-stylized R15-compatible proportions, recognizable sharp swept-back golden-blond hair made of layered individual geometric locks, piercing ruby-red eyes with subtle glossy anime highlights, confident smirk, defined aristocratic face, and an unmistakable kingly silhouette. Luxurious golden plate armor with multiple interlocking sculpted layers: broad crescent-like shoulder guards, a finely articulated breastplate with symmetric dark midnight-blue inlays and ornamental lines, gold forearm guards, royal waist armor, shin plates, angular boots, small polished crimson gemstones at the chest and wrists, and a flowing deep red waist cape draped behind his legs. Hand-authored gold PBR-like metal response, subtle roughness variance, precise edge highlights; refined without photorealistic textures. His left hand rests naturally near his hip; his right arm extends slightly forward in a commanding gesture as if unveiling the player's treasure, with a restrained golden ring of magical light floating ABOVE the open hand. Behind his silhouette, in a separated background layer, THREE large luminous geometric golden portals arranged in a majestic fan, showing only subtle silhouettes of rare treasures, never covering his face or hands. Palace setting of black onyx, gold trims, dim ruby silk and warm amber volumetric lighting; elegant and slightly mysterious atmosphere. Camera at human eye level with a slightly low heroic angle, show the ENTIRE character including feet, strong readable silhouette, medium-distance readability for mobile, professional videogame character art direction, Roblox Studio feasible geometry. The character should be beautiful, proud, theatrical, and clearly interactive as a high-value NPC, NOT a combat tower.

**Negative prompt B**:
> generic armored knight, medieval realistic crusader, long hair covering eyes, adult photorealism, overly shiny chrome, giant clipping cape, overbright yellow bloom, countless tiny spikes, messy armor silhouette, excessive particle spam, cropped feet, flat two-dimensional anime drawing, extra limbs, hair covering face, illegible runes or UI text, watermark, unrelated characters, fighting pose, imported Roblox avatar accessories.

**Detalhes de modelagem B**:
- Criar **turnaround** (frente, lado, costas) separado do render dramático, pois render de cena não é blueprint para rigging.
- Braço direito deve ficar livre para gesto e apresentação de anel, com três poses animáveis: idle orgulhoso, saudação irônica e inspecionar relic.
- Não riggar portais junto ao corpo: são VFX/props independentes do salão, para LOD e desempenho mobile.
- Detalhes de armadura concentrados no peito/ombreiras. Mãos, rosto e perfil de cabelo têm prioridade máxima.
- Proporção alvo: escala visual de aproximadamente **1,15×** um avatar Roblox padrão, para presença sem obstruir o prompt e a câmera.

## PROMPT C — Gilgamesh estátua real / ícone da Babilônia

**Uso**: duas estátuas nas entradas, troféu decorativo, thumbnail da área ou elemento de interface. **Não substituir o NPC por estátua.**

> Create a museum-quality ROBLOX STUDIO compatible fantasy anime statue of GILGAMESH, the King of Treasures from Fate, designed as a monumental decorative landmark at the entrance to a Hall of Babylon relic chamber. Full-body original sculpt-like interpretation of his recognizable arrogant golden king silhouette: angular swept-up blond hair translated into sharp metal crown-like locks, ruby-inlaid eyes, large sweeping shoulder armor, ornate chest plates, deep red draped cape represented as elegant sculptural folds, regal boots and a calm, sovereign expression. Entire figure constructed in richly layered antique gold and dark bronze metallic material, with selective black onyx inset and two large polished ruby accents. Heroic upright pose, head raised slightly, one hand on hip, other presenting an angular golden key emblem. Solid hexagonal black stone pedestal with fine glowing amber line ornaments and a few floating gold geometric portal-shaped halos well behind the statue. Symmetrical composition, clear silhouette, elegant anime-inspired 3D Roblox game environment style, no photorealistic human skin, simplified geometry appropriate for a persistent lobby prop, softly lit with warm amber and subtle cool-blue rim. Include front and side views plus one isolated isometric beauty angle. No text on the monument.

**Negative prompt C**:
> living human skin, moving character, photorealistic castle, overly ornate tiny decals, excessive bloom, too many lights, thick fog, extreme perspective distortion, very fine unstable details, floating body parts, unreadable base, watermark, overlapping characters, clutter.

**Nota C**: versões estáticas ancoradas; iluminar com um PointLight por conjunto, não dezenas. Para portais, usar mesh/Parts em vez de ParticleEmitter ilimitado.

## Paleta visual de referência

| Material | Cor proposta | Hex |
|---|---|---|
| Ouro principal | Gold Royal | #E9B84D |
| Ouro iluminado | Pale Gold | #FFE29A |
| Armadura interna | Midnight Indigo | #161F39 |
| Rubi olhos/joias | Crimson Ruby | #C92C48 |
| Tecido | Deep Wine Red | #741B33 |
| Ônix do salão | Royal Onyx | #11131F |
| Azul de integração ao Anime Fissure | Electric Blue | #387BFF |

**Direção final**: salão quente, dourado e elegante, com detalhes azuis apenas onde conectamos à identidade de Anime Fissure; evitar torná-lo um mapa completamente desconectado do lobby.

## Prompt bônus — Ambiente / Salão da Babilônia (referência estática)

> Design a high-end ROBLOX STUDIO anime tower defense LOBBY ENVIRONMENT CONCEPT for a Hall of Babylon relic sanctuary. Three-quarter eye-level architectural view: a compact luxurious black onyx and gold hall integrated into the RIGHT WING of a larger blue-neon game lobby, grand golden arch entrance, regal raised NPC platform with a blond golden-armored relic master in the center, five smaller display pedestals showcasing purple magic ring, crimson physical ring, cyan clock SPA ring, emerald range ring, and dark red-violet chained restriction ring, plus a majestic restrained fan of golden magic portals behind the NPC. Polished dark stone floors with geometric golden inlays, warm soft amber lights, ruby accents, clean paths wide enough for Roblox players, readable signage and functional zoning. Do not create combat arena geometry, no furniture blocking the spawn, no giant scale, strong camera readability and mobile performance awareness, cinematic but buildable game environment, stylized 3D shapes and moderate visual effects. Wide 16:9 environment concept, no interface overlay, clean architecture, separate zones for relic catalog and evolution altar.

## Instruções de uso e limitações

- Os textos são **prompts de referência visual** para design/modelagem. Um render gerado não é automaticamente um modelo Roblox que possa ser importado, editado, equipado com Humanoid ou animado.
- Para um **modelo 3D utilizável**, modelar e riggar em Blender/Roblox Studio com peças ou meshes próprias e verificar permissões de uso.
- O rosto e as armaduras de Fate são propriedade intelectual de terceiros; avaliar licenciamento e, se necessário, criar um "Rei do Tesouro" original para publicação.
- Nenhuma imagem, arquivo `.rbxm`, `.rbxlx` ou NPC foi gerado por estes prompts — são documentação para execução futura.

**Conclusão:** aprovar visual B para o NPC, aproveitar A para proxy de performance e usar C como decoração/entrada. Construir primeiro as formas e hitbox do salão, depois o rig e a interface CATÁLOGO sem ações irreversíveis.
