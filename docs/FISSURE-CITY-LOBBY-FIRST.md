# FISSURE CITY — Lobby First | tarefas de Studio
Marco 0.3, primeira passagem de arquitetura. O lobby tem prioridade sobre novo refinamento de NPCs. Preservar floor 110x110, spawn (260,.5,25), Story portal (260,10,-38), estações e ponte existente da Babilônia. Nenhum sistema de progressão novo nesta entrega.

| Setor | Implementado no código | Próxima tarefa de Studio / aceitação |
|---|---|---|
| Entrada | Pórtico, letreiro Anime Fissure, anel do spawn | Ver câmera inicial PC/mobile; letreiro legível, andar sem obstáculos |
| Praça central | Medalhão de ônix, anéis e símbolo F flutuante | Conferir silhueta e iluminação, sem esconder o portal Story |
| Story | Moldura arquitetônica e boulevard azul | Abrir painel e entrar em Carne Village Classic/Hard |
| Vergil | Pavilhão azul, arco e cápsulas decorativas | Conferir prompt de Summon, contraste e espaço livre |
| Edward | Pavilhão dourado, prateleiras e frascos | Bancada acessível; alquimia sem transações simuladas |
| Dante | Arquivo vermelho/prata, colunas de dados | Abrir Index; conferir proximidade do Vergil |
| Whis | Arcos celestes e cristais | Consultar evolução; evitar interseção com o NPC |
| Urahara | Laboratório verde, telas e sigilos | Consultar Traits; nenhum reroll falso |
| Jinwoo | Arco dimensional e fragmentos sombrios | Consultar desafios; nenhum raid ativa sem implementação |
| Gilgamesh | Entrada dourada e abertura da borda na ponte | Caminhar sem pular; 11 portais e 5 vitrines intactos |
| Eventos | Contorno e bandeiras modulares | Escanor apenas Studio; praça central sem evento ativo |
| Cidade | 81 placas, 9 rotas, jardins geométricos e skyline | Caminhada completa, teste de FPS e memória; inspeção de sobreposição |

## Próximos passes de arte
- [ ] FC-01 — Rodar o .rbxlx em Studio; capturar Output, diagnóstico 13/13 e smoke FISSURE CITY.
- [ ] FC-02 — Capturar vista do spawn, praça, cada estação e ponte; corrigir escalas, recortes e caminhos.
- [ ] FC-03 — Refinar as fachadas e interiores com props e malhas originais/licenciadas; substituir formas procedurais quando necessário.
- [ ] FC-04 — Ambientação local de lobby separada da arena; testar configuração FX leve, legibilidade, sombras, FPS e memória PC/mobile.
- [ ] FC-05 — Ajustar colisões reais onde necessário, acessibilidade e bordas de segurança. Os elementos novos são não sólidos nesta passagem; o piso, spawn e bases funcionais existentes continuam sólidos.
- [ ] FC-06 — Aprovação visual do criador, testes das interações e registro de build.

A primeira passagem é procedural, não uma cidade final importada de Blender. Compilação Luau/Rojo não substitui Play. Sem alteração dos remotes, recompensas, moedas ou evento. 

## World Polish 0.3.2 — implementação
- Fachadas e Immersion publicados; validação Luau/Rojo da versão 0.3.1 concluída.
- Horizonte em camadas, torres de alturas variadas e ilhas distantes sem colisão.
- Sete guarda-corpos sólidos na borda e ponte; canal central preservado. Não são proteção absoluta contra saltos deliberados.
- Whis e Dante orientados para a avenida; pontos de interação e props de fundo seguem o yaw de cada NPC.
- Testes Studio de geometria, posição de prompts, perímetro e orçamento de partes adicionados; execução real ainda pendente.
- Trilha e ambiência sonora aguardam asset original/licenciado com autorização Roblox; nenhum ID de áudio fictício foi incluído.

## Próximo teste de aceitação
Abrir o build 0.3.2, usar Play, verificar Output (FISSURE CITY e WORLD POLISH SMOKE OK), caminhar pela entrada, praça, oito NPCs e ponte. Testar FX padrão/leve e Story, capturar screenshots reais do spawn e das estações. Não publicar como jogo final antes de corrigir defeitos observados.

## City Soul 0.3.4 — Coração da Convergência
- O monumento central passa a ser uma fenda tridimensional de obsidiana, energia azul, aros inclinados e dois pilares laterais. O emblema F é transferido para o piso da praça.
- Seis caminhos de energia conectam visualmente Summon, Alquimia, Index, Raids, Traits e Evolução; não são portais nem sistemas adicionais.
- Dois pontos de contemplação (Convergência e Jardim Aether) dentro da área caminhável. Sem câmera forçada ou recompensas falsas.
- Pulsação lenta local em 11 partes, somente perto do monumento em FX padrão, restaurada ao sair da cidade ou reduzir efeitos.
- Menos detalhes repetitivos em fachadas, jardins e trilhas para manter o orçamento existente de menos de 900 peças decorativas da cidade (verificação Studio pendente).
- World Awakening 0.3.3 compilado com sucesso; City Soul exige nova compilação e Play real. Paisagem externa continua cenográfica, áudio próprio/licenciado ainda pendente.

### Critérios de aprovação visual
1. Ao terminar Rasgando a Realidade, enxergar a identidade do jogo e o monumento sem esconder a entrada Story.
2. Caminhar livremente da chegada até a praça, NPCs e Babilônia; conferir leitura dos seis caminhos e placas.
3. Fotografar os dois pontos e ajustar composição, material e escala; avaliar monitor, tela mobile e FX leve.
4. Confirmar FISSURE CITY SMOKE OK, ausência de erros no Output e desempenho medido no Studio. Não confundir compilação Luau/Rojo com teste de execução.
