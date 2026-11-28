--!strict
-- ANIME FISSURE | Universal lobby functions / NPC roster v1.0
-- Design selections: Whis = unit evolution; Urahara = Traits;
-- Sung Jinwoo = permanent Challenges & Raids. Gilgamesh/Edward/Virgil
-- keep their existing, separate responsibilities.
-- DATA ONLY: no evolution, reroll, raid or event is activated by this file.
local Config={}
Config.Version="1.1.0"
Config.LobbyCenter=Vector3.new(260,0,0)
Config.CurrentEventId=nil -- Change only when an actual supported event ships.
Config.DevelopmentEventPreviewId="NANATSU_ESCANOR" -- STUDIO ONLY example, never live.

Config.Stations={
    Evolution={
        Id="Evolution",NPC="Whis",Universe="Dragon Ball Super",
        Name="SANTUÁRIO DA ASCENSÃO",Title="MESTRE DA EVOLUÇÃO",
        Action="CONSULTAR EVOLUÇÃO",
        Subtitle="Desperte o potencial de suas unidades",
        Description="Evoluções das unidades de todos os mundos, incluindo transformações que requerem materiais específicos.",
        Features={"Selecionar unidade da coleção","Conferir forma anterior e evoluída","Requisitos de nível e materiais","Confirmar evolução no servidor"},
        Position=Vector3.new(290,0,33),Yaw=0,
        Accent=Color3.fromRGB(119,235,244),
        Secondary=Color3.fromRGB(186,154,244),
        DisabledReason="A evolução real aguarda coleção, receitas, materiais e persistência.",
        Enabled=false,Prototype="StaticNPC",
    },
    Traits={
        Id="Traits",NPC="Kisuke Urahara",Universe="Bleach",
        Name="LABORATÓRIO DAS APTIDÕES",Title="MESTRE DAS TRAITS",
        Action="CONSULTAR TRAITS",
        Subtitle="Um talento transforma o combate",
        Description="Reroll e consulta das Traits das unidades, separados das relíquias administradas por Gilgamesh.",
        Features={"Ver a Trait equipada","Consultar bônus por raridade","Reroll com recurso específico","Confirmar antes de substituir Trait valiosa"},
        Position=Vector3.new(230,0,33),Yaw=0,
        Accent=Color3.fromRGB(158,235,145),
        Secondary=Color3.fromRGB(220,212,164),
        DisabledReason="Reroll de Traits aguarda inventário, chances, moeda e serviço real.",
        Enabled=false,Prototype="StaticNPC",
    },
    Index={
        Id="Index",NPC="Dante",Universe="Devil May Cry",
        Name="ARQUIVO DOS CAÇADORES",Title="MESTRE DO INDEX",
        Action="ABRIR INDEX",
        Subtitle="Conheça todas as unidades dos universos",
        Description="Arquivo universal das unidades, raridades e formas de obtenção. Não se confunde com Summon nem com a coleção pessoal.",
        Features={"Consultar personagens de todos os mundos","Ver raridades e formas de obtenção","Explorar unidades ainda não disponíveis","Coleção pessoal será integrada futuramente"},
        Position=Vector3.new(247,0,-8),Yaw=math.rad(180),
        Accent=Color3.fromRGB(236,68,86),
        Secondary=Color3.fromRGB(233,235,242),
        DisabledReason="Index de leitura ativo; coleção de unidades ainda não conectada.",
        Enabled=false,Prototype="StaticNPC",
    },
    Raids={
        Id="Raids",NPC="Sung Jinwoo",Universe="Solo Leveling",
        Name="PORTÃO DOS CAÇADORES",Title="MESTRE DOS DESAFIOS E RAIDS",
        Action="CONSULTAR DESAFIOS",
        Subtitle="Desafios permanentes e incursões",
        Description="Portões para desafios e raids PERMANENTES. Eventos sazonais têm seu próprio anfitrião na praça central.",
        Features={"Desafios permanentes","Raids permanentes","Requisitos e recompensas oficiais","Formação de equipe quando coop estiver pronto"},
        Position=Vector3.new(281,0,-30),Yaw=math.rad(180),
        Accent=Color3.fromRGB(155,95,247),
        Secondary=Color3.fromRGB(68,204,247),
        DisabledReason="Raids e desafios ainda não possuem fases/entradas implementadas nesta beta.",
        Enabled=false,Prototype="StaticNPC",
    },
}
Config.Order={"Evolution","Traits","Raids","Index"}

Config.EventHub={
    Id="EventHub",Name="PRAÇA DOS EVENTOS",Title="EVENTO SAZONAL",
    Action="VER EVENTOS",NPC="A definir",
    Position=Vector3.new(270.6,0,8),
    Accent=Color3.fromRGB(250,186,98),
    Secondary=Color3.fromRGB(255,224,145), -- Required by stationaryCharacter eye and preview art.
    Subtitle="O anfitrião muda conforme o evento ativo",
    Description="Um personagem temporário de anime ocupa o centro e apresenta sua Raid ou missão sazonal.",
    DisabledReason="Nenhum evento oficial ativo nesta beta.",
    Enabled=false,Prototype="RotatingCenter",
}

-- Example given by the creator, explicitly DISABLED.
-- Does not claim Nanatsu or Escanor event exists this month.
Config.EventExamples={
    NANATSU_ESCANOR={
        Id="NANATSU_ESCANOR",Name="O Orgulho do Sol",
        NPC="Escanor",Universe="Nanatsu no Taizai",
        Subtitle="Exemplo conceitual de raid sazonal do Escanor",
        Accent=Color3.fromRGB(255,172,56),
        RaidId=nil,RewardsEnabled=false,Playable=false,
        ApprovedForRelease=false,
    },
}

function Config.GetStation(id: string)
    local station=Config.Stations[id]
    return if station then table.clone(station) else nil
end
function Config.GetEvent(): any
    local id=Config.CurrentEventId
    if not id then return nil end
    local data=Config.EventExamples[id]
    if not data or data.ApprovedForRelease~=true or data.Playable~=true then
        return nil
    end
    return table.clone(data)
end
function Config.GetEventPreview(): any
    local data=Config.EventExamples[Config.DevelopmentEventPreviewId]
    return if data then table.clone(data) else nil
end
function Config.Get(id: string)
    if id=="EventHub" then
        local result=table.clone(Config.EventHub)
        local event=Config.GetEvent()
        if event then
            result.NPC=event.NPC
            result.Subtitle=event.Subtitle
            result.Description=event.Name
            result.Universe=event.Universe
            result.Accent=event.Accent
            result.DisabledReason="Evento listado; acesso só após raid e servidor estarem prontos."
        end
        return result
    end
    return Config.GetStation(id)
end

return Config
