# ANIME FISSURE — Revisão do lobby em 27/11/2026

## Sete NPCs permanentes

| NPC | Função | Situação |
|---|---|---|
| Vergil (Virgil no código) | Summon; Warp reservado para depois | Protótipo de Summon preservado |
| Dante | Index universal de unidades | Interface de leitura com seis Overlord e duas Capsule |
| Edward | Alquimia, orbes e craft | Interface existente, craft real ainda não implementado |
| Gilgamesh | Todas as relíquias do jogo | Catálogo 3D, salão dourado com 11 portais e cinco anéis |
| Whis | Evolução de TODAS as unidades | Painel de consulta; evolução real bloqueada |
| Kisuke Urahara | Traits das unidades | Painel de consulta; reroll real bloqueado |
| Sung Jinwoo | Desafios e Raids permanentes | Painel de consulta; raids não ativadas |

A **Praça Central dos Eventos** tem um slot de anfitrião rotativo; **Escanor é apenas exemplo visual no Studio**. Não existe evento Nanatsu ativo. Story Mode permanece no Portal das Fissuras.

## Melhoria artística publicada nesta revisão

- Módulo de detalhes: src/shared/LobbyNPCArtFinish.luau
- Gilgamesh: detalhes de armadura dourada, coroa, sobrancelhas, rubis e aro geométrico atrás do rei
- Whis: cabelo prateado alto, colar angelical circular, manto e cajado
- Urahara: chapéu listrado, cabelos claros, quimono e leque
- Jinwoo: sobretudos escuros, faixas, olhos violetas e detalhes espectrais
- Dante: casaco vermelho, fivelas, mechas prateadas, espada e núcleo de Index
- Escanor (prévia Studio): ornamentos solares; nunca ativo no jogo público sem evento
- Símbolo de caçadores gêmeos em vermelho e azul entre Vergil e Dante
- Brilhos locais moderados, controlados por distância e com redução no mobile: src/client/LobbyMentorVFX.client.luau
- Diagnóstico visual na tela do Studio, com 12 verificações de carregamento: src/client/LobbyStudioAudit.client.luau

**Os modelos são peças Roblox/WedgeParts estilizadas e detalhadas, não rigs R15 profissionais ou meshes perfeitos importados do Blender.** O visual definitivo dos personagens precisa ser aprovado em Play no Roblox Studio. Evitar publicar referências licenciadas sem verificar direitos.

## Como obter a beta recompilada

1. Abrir https://github.com/Blacksharkv0/Anime-Fissure/actions/workflows/build-beta.yml
2. Escolher a execução mais recente da branch main com status verde, confirmando o commit da revisão.
3. Em Artifacts, baixar AnimeFissure-Beta e extrair o ZIP.
4. Abrir AnimeFissure-Beta.rbxlx no Roblox Studio e clicar Play.
5. Ver o botão DIAGNÓSTICO DO LOBBY no canto inferior esquerdo. Ele verifica Portal, spawn, sete NPCs, portais da Babilônia, vitrines, praça sazonal e interfaces.
6. Em View > Output, buscar: PREMIUM LOBBY ART SMOKE OK; BABYLON HALL SMOKE OK; DANTE UNIVERSAL INDEX SMOKE OK; LOBBY SERVICE NETWORK SMOKE OK.

**Importante:** compilação via Rojo testa criação do .rbxlx, mas não simula execução do Play, rigging ou iluminação real no Roblox Studio. O painel verde indica que o modelo carregou, não que o sistema de evolução, reroll ou raids esteja funcional.

## Teste de interação

No lobby, interagir com Vergil para Summon, Edward para Alquimia, Dante para Index, Gilgamesh para Catálogo de Relíquias, Whis para Evolução, Urahara para Traits e Jinwoo para Raids/Desafios. Apenas os serviços já integrados realmente executam gameplay; os outros são painéis de apresentação.

Na praça, Escanor aparece somente no Studio com texto EXEMPLO NÃO ATIVO. Nenhuma raid ou recompensa é concedida.

## Pendências que não foram inventadas

Coleção e Decks persistentes, chance/pity reais, receita de evolução, reroll de Traits, reroll de relíquias, raids jogáveis, crafting, sistemas de eventos temporários, rigs R15 e animações profissionais. A implementação de inventário, economia ou drop necessita validação do servidor e regras aprovadas.

Alterações preservam os sistemas anteriores e o portal de Story Mode. Todas as novas peças de acabamento têm colisão desativada; pisos e bases originais preservam suas próprias colisões.
