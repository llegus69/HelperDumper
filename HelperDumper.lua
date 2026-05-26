-- 1. LOCALIZACIÓN (Idiomas con soporte para Personajes y Bots)
local L = {
    ES = {
        title = "|TInterface\\Icons\\Trade_Engineering:22:22:0:0|t HelperDumper",
        note = "|cffaaaaaa*Siempre que vayas a guardar un personaje o bot, recuerda limpiar cache para evitar conflictos*|r",
        btn_save_menu = "Salvar Personaje",
        btn_load_menu = "Cargar Personaje",
        btn_bots_menu = "Gestionar Bots",
        btn_clear = "Limpiar Cache",
        btn_back = "Atrás",
        char_name = "Nombre Personaje:",
        file_name = "Nombre Archivo:",
        acc_name = "Nombre Cuenta:",
        btn_confirm_save = "Confirmar Guardado",
        btn_confirm_load = "Confirmar Carga",
        err_exists = "|cffff0000Error: Ya existe ese archivo.|r",
        err_manual_hint = "|cffdfb300Si el archivo ya existe, debes borrarlo manualmente. Los archivos se encuentran en el Core del servidor.|r",
        cache_cleared = "|cff00ff00HelperDumper: Cache limpiada por completo.|r",
        file_deleted = "|cff00ff00Caché limpia. Cuadro vaciado.|r",
        lang_label = "Idioma:",
        credits = "|cffdfb300Creado por Lleguito|r",
    },
    EN = {
        title = "|TInterface\\Icons\\Trade_Engineering:22:22:0:0|t HelperDumper",
        note = "|cffaaaaaa*Whenever you are going to save a character or bot, remember to clear cache to avoid conflicts*|r",
        btn_save_menu = "Save Character",
        btn_load_menu = "Load Character",
        btn_bots_menu = "Manage Bots",
        btn_clear = "Clear Cache",
        btn_back = "Back",
        char_name = "Char Name:",
        file_name = "File Name:",
        acc_name = "Account Name:",
        btn_confirm_save = "Confirm Save",
        btn_confirm_load = "Confirm Load",
        err_exists = "|cffff0000Error: A file with that name already exists.|r",
        err_manual_hint = "|cffdfb300If the file already exists, you must delete it manually. The files are located in the server Core.|r",
        cache_cleared = "|cff00ff00HelperDumper: Cache entirely cleared.|r",
        file_deleted = "|cff00ff00Addon cache cleared. Box emptied.|r",
        lang_label = "Language:",
        credits = "|cffdfb300Created by Lleguito|r",
    }
}

local lang = "ES"

-- 2. VENTANA PRINCIPAL
local frame = CreateFrame("Frame", "HelperDumperFrame", UIParent)
frame:SetSize(300, 400) 
frame:SetPoint("CENTER", 0, 0)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
frame:Hide() 

local bg = frame:CreateTexture(nil, "BACKGROUND")
bg:SetAllPoints(frame)
bg:SetTexture("Interface\\TutorialFrame\\TutorialFrameBackground")

local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
title:SetPoint("TOP", 0, -12)

local noteText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
noteText:SetPoint("TOP", 0, -55)
noteText:SetWidth(250)

-- Botón X de Cierre de la Ventana Principal
local btnCloseFrame = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
btnCloseFrame:SetSize(22, 22)
btnCloseFrame:SetPoint("TOPRIGHT", -10, -10)
btnCloseFrame:SetText("|cffff0000X|r")
btnCloseFrame:SetScript("OnClick", function() frame:Hide() end)

-- 3. CONTENEDORES DE RAMAS (Paneles independientes)
local MainMenu = CreateFrame("Frame", nil, frame) MainMenu:SetAllPoints()
local SavePanel = CreateFrame("Frame", nil, frame) SavePanel:SetAllPoints(); SavePanel:Hide()
local LoadPanel = CreateFrame("Frame", nil, frame) LoadPanel:SetAllPoints(); LoadPanel:Hide()
local BotsMenu = CreateFrame("Frame", nil, frame) BotsMenu:SetAllPoints(); BotsMenu:Hide()
local SaveBotsPanel = CreateFrame("Frame", nil, frame) SaveBotsPanel:SetAllPoints(); SaveBotsPanel:Hide()
local LoadBotsPanel = CreateFrame("Frame", nil, frame) LoadBotsPanel:SetAllPoints(); LoadBotsPanel:Hide()

-- Función interna para cambiar entre vistas limpiamente
local function ShowPanel(panel)
    MainMenu:Hide(); SavePanel:Hide(); LoadPanel:Hide()
    BotsMenu:Hide(); SaveBotsPanel:Hide(); LoadBotsPanel:Hide()
    panel:Show()
end

-- FUNCIÓN AUXILIAR: EditBoxes con diseño elegante
local function CreateCustomEditBox(parent)
    local eb = CreateFrame("EditBox", nil, parent)
    eb:SetFontObject("GameFontHighlightSmall")
    eb:SetAutoFocus(false)
    eb:SetTextInsets(6, 6, 0, 0)
    eb:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 12,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    eb:SetBackdropColor(0, 0, 0, 0.6)
    eb:SetBackdropBorderColor(0.8, 0.6, 0, 0.7)
    eb:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    eb:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
    return eb
end

-- 4. ELEMENTOS DEL MENÚ PRINCIPAL
local btnGoSave = CreateFrame("Button", nil, MainMenu, "UIPanelButtonTemplate")
btnGoSave:SetSize(180, 32) btnGoSave:SetPoint("TOP", 0, -110)
btnGoSave:SetScript("OnClick", function() ShowPanel(SavePanel) end)

local btnGoLoad = CreateFrame("Button", nil, MainMenu, "UIPanelButtonTemplate")
btnGoLoad:SetSize(180, 32) btnGoLoad:SetPoint("TOP", 0, -155)
btnGoLoad:SetScript("OnClick", function() ShowPanel(LoadPanel) end)

local btnGoBots = CreateFrame("Button", nil, MainMenu, "UIPanelButtonTemplate")
btnGoBots:SetSize(180, 32) btnGoBots:SetPoint("TOP", 0, -200)
btnGoBots:SetScript("OnClick", function() ShowPanel(BotsMenu) end)

local btnClear = CreateFrame("Button", nil, MainMenu, "UIPanelButtonTemplate")
btnClear:SetSize(180, 32) btnClear:SetPoint("TOP", 0, -245)

-- 5. ELEMENTOS DE LA RAMA: SALVAR PERSONAJE
local lblSaveFile = SavePanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
lblSaveFile:SetPoint("TOPLEFT", 30, -100)
local inputSaveFile = CreateCustomEditBox(SavePanel)
inputSaveFile:SetSize(210, 24) inputSaveFile:SetPoint("TOPLEFT", 30, -115)

local btnDelChar = CreateFrame("Button", nil, SavePanel, "UIPanelButtonTemplate")
btnDelChar:SetSize(24, 24) btnDelChar:SetPoint("LEFT", inputSaveFile, "RIGHT", 6, 0)
btnDelChar:SetText("|cffff0000X|r") btnDelChar:Hide()

local hintSaveChar = SavePanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
hintSaveChar:SetPoint("TOPLEFT", 30, -145) hintSaveChar:SetWidth(240) hintSaveChar:SetJustifyH("LEFT") hintSaveChar:Hide()

local lblSaveChar = SavePanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
lblSaveChar:SetPoint("TOPLEFT", 30, -210)
local inputSaveChar = CreateCustomEditBox(SavePanel)
inputSaveChar:SetSize(240, 24) inputSaveChar:SetPoint("TOPLEFT", 30, -225)

local btnConfirmSave = CreateFrame("Button", nil, SavePanel, "UIPanelButtonTemplate")
btnConfirmSave:SetSize(140, 30) btnConfirmSave:SetPoint("BOTTOM", 0, 75)

local btnBackSave = CreateFrame("Button", nil, SavePanel, "UIPanelButtonTemplate")
btnBackSave:SetSize(80, 25) btnBackSave:SetPoint("BOTTOM", 0, 42)
btnBackSave:SetScript("OnClick", function() 
    inputSaveFile:SetBackdropBorderColor(0.8, 0.6, 0, 0.7)
    btnDelChar:Hide() hintSaveChar:Hide()
    ShowPanel(MainMenu) 
end)

inputSaveFile:SetScript("OnTextChanged", function(self)
    self:SetBackdropBorderColor(0.8, 0.6, 0, 0.7)
    btnDelChar:Hide() hintSaveChar:Hide()
end)

btnDelChar:SetScript("OnClick", function(self)
    local file = inputSaveFile:GetText()
    if file ~= "" and HelperDumperDB.chars then
        HelperDumperDB.chars[file] = nil
        print(L[lang].file_deleted)
    end
    inputSaveFile:SetText("")
    inputSaveFile:SetBackdropBorderColor(0.8, 0.6, 0, 0.7)
    self:Hide() hintSaveChar:Hide()
end)

-- 6. ELEMENTOS DE LA RAMA: CARGAR PERSONAJE
local lblLoadFile = LoadPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
lblLoadFile:SetPoint("TOPLEFT", 30, -110)
local inputLoadFile = CreateCustomEditBox(LoadPanel)
inputLoadFile:SetSize(240, 24) inputLoadFile:SetPoint("TOPLEFT", 30, -125)

local lblLoadAcc = LoadPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
lblLoadAcc:SetPoint("TOPLEFT", 30, -165)
local inputLoadAcc = CreateCustomEditBox(LoadPanel)
inputLoadAcc:SetSize(240, 24) inputLoadAcc:SetPoint("TOPLEFT", 30, -180)

local btnConfirmLoad = CreateFrame("Button", nil, LoadPanel, "UIPanelButtonTemplate")
btnConfirmLoad:SetSize(140, 30) btnConfirmLoad:SetPoint("BOTTOM", 0, 75)

local btnBackLoad = CreateFrame("Button", nil, LoadPanel, "UIPanelButtonTemplate")
btnBackLoad:SetSize(80, 25) btnBackLoad:SetPoint("BOTTOM", 0, 42)
btnBackLoad:SetScript("OnClick", function() ShowPanel(MainMenu) end)

-- 7. SUBMENÚ: GESTIONAR BOTS
local btnGoSaveBots = CreateFrame("Button", nil, BotsMenu, "UIPanelButtonTemplate")
btnGoSaveBots:SetSize(180, 35) btnGoSaveBots:SetPoint("TOP", 0, -120)
btnGoSaveBots:SetScript("OnClick", function() ShowPanel(SaveBotsPanel) end)

local btnGoLoadBots = CreateFrame("Button", nil, BotsMenu, "UIPanelButtonTemplate")
btnGoLoadBots:SetSize(180, 35) btnGoLoadBots:SetPoint("TOP", 0, -175)
btnGoLoadBots:SetScript("OnClick", function() ShowPanel(LoadBotsPanel) end)

local btnBackBotsMenu = CreateFrame("Button", nil, BotsMenu, "UIPanelButtonTemplate")
btnBackBotsMenu:SetSize(100, 28) btnBackBotsMenu:SetPoint("BOTTOM", 0, 50)
btnBackBotsMenu:SetScript("OnClick", function() ShowPanel(MainMenu) end)

-- 8. RAMA: SALVAR BOTS
local lblSaveBotFile = SaveBotsPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
lblSaveBotFile:SetPoint("TOPLEFT", 30, -110)
local inputSaveBotFile = CreateCustomEditBox(SaveBotsPanel)
inputSaveBotFile:SetSize(210, 24) inputSaveBotFile:SetPoint("TOPLEFT", 30, -125)

local btnDelBot = CreateFrame("Button", nil, SaveBotsPanel, "UIPanelButtonTemplate")
btnDelBot:SetSize(24, 24) btnDelBot:SetPoint("LEFT", inputSaveBotFile, "RIGHT", 6, 0)
btnDelBot:SetText("|cffff0000X|r") btnDelBot:Hide()

local hintSaveBot = SaveBotsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
hintSaveBot:SetPoint("TOPLEFT", 30, -160) hintSaveBot:SetWidth(240) hintSaveBot:SetJustifyH("LEFT") hintSaveBot:Hide()

local btnConfirmSaveBots = CreateFrame("Button", nil, SaveBotsPanel, "UIPanelButtonTemplate")
btnConfirmSaveBots:SetSize(140, 30) btnConfirmSaveBots:SetPoint("BOTTOM", 0, 75)

local btnBackSaveBots = CreateFrame("Button", nil, SaveBotsPanel, "UIPanelButtonTemplate")
btnBackSaveBots:SetSize(80, 25) btnBackSaveBots:SetPoint("BOTTOM", 0, 42)
btnBackSaveBots:SetScript("OnClick", function() 
    inputSaveBotFile:SetBackdropBorderColor(0.8, 0.6, 0, 0.7)
    btnDelBot:Hide() hintSaveBot:Hide()
    ShowPanel(BotsMenu) 
end)

inputSaveBotFile:SetScript("OnTextChanged", function(self)
    self:SetBackdropBorderColor(0.8, 0.6, 0, 0.7)
    btnDelBot:Hide() hintSaveBot:Hide()
end)

btnDelBot:SetScript("OnClick", function(self)
    local file = inputSaveBotFile:GetText()
    if file ~= "" and HelperDumperDB.bots then
        HelperDumperDB.bots[file] = nil
        print(L[lang].file_deleted)
    end
    inputSaveBotFile:SetText("")
    inputSaveBotFile:SetBackdropBorderColor(0.8, 0.6, 0, 0.7)
    self:Hide() hintSaveBot:Hide()
end)

-- 9. RAMA: CARGAR BOTS
local lblLoadBotFile = LoadBotsPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
lblLoadBotFile:SetPoint("TOPLEFT", 30, -110)
local inputLoadBotFile = CreateCustomEditBox(LoadBotsPanel)
inputLoadBotFile:SetSize(240, 24) inputLoadBotFile:SetPoint("TOPLEFT", 30, -125)

local btnConfirmLoadBots = CreateFrame("Button", nil, LoadBotsPanel, "UIPanelButtonTemplate")
btnConfirmLoadBots:SetSize(140, 30) btnConfirmLoadBots:SetPoint("BOTTOM", 0, 75)

local btnBackLoadBots = CreateFrame("Button", nil, LoadBotsPanel, "UIPanelButtonTemplate")
btnBackLoadBots:SetSize(80, 25) btnBackLoadBots:SetPoint("BOTTOM", 0, 42)
btnBackLoadBots:SetScript("OnClick", function() ShowPanel(BotsMenu) end)

-- 10. MENU DESPLEGABLE DE IDIOMA Y FIRMA
local lblLang = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
lblLang:SetPoint("BOTTOMLEFT", 20, 15) lblLang:SetDrawLayer("OVERLAY", 7)

local langDropdown = CreateFrame("Frame", "HelperDumperLangDropdown", frame, "UIDropDownMenuTemplate")
langDropdown:SetPoint("BOTTOMLEFT", 60, 5) UIDropDownMenu_SetWidth(langDropdown, 50)
langDropdown:SetFrameLevel(frame:GetFrameLevel() + 2)

local creditsText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
creditsText:SetPoint("BOTTOMRIGHT", -20, 15) creditsText:SetDrawLayer("OVERLAY", 7)

-- 11. FUNCIONES DE ACTUALIZACIÓN DE TEXTO E IDIOMA
local function UpdateTexts()
    local text = L[lang]
    title:SetText(text.title) noteText:SetText(text.note) creditsText:SetText(text.credits)
    
    btnGoSave:SetText(text.btn_save_menu) btnGoLoad:SetText(text.btn_load_menu)
    btnGoBots:SetText(text.btn_bots_menu) btnClear:SetText(text.btn_clear)
    
    lblSaveFile:SetText(text.file_name) lblSaveChar:SetText(text.char_name)
    btnConfirmSave:SetText(text.btn_confirm_save) btnBackSave:SetText(text.btn_back)
    lblLoadFile:SetText(text.file_name) lblLoadAcc:SetText(text.acc_name)
    btnConfirmLoad:SetText(text.btn_confirm_load) btnBackLoad:SetText(text.btn_back)
    
    btnGoSaveBots:SetText(text.btn_save_menu .. " (Bots)") btnGoLoadBots:SetText(text.btn_load_menu .. " (Bots)")
    btnBackBotsMenu:SetText(text.btn_back) btnConfirmSaveBots:SetText(text.btn_confirm_save)
    btnConfirmLoadBots:SetText(text.btn_confirm_load) btnBackSaveBots:SetText(text.btn_back) btnBackLoadBots:SetText(text.btn_back)
    lblSaveBotFile:SetText(text.file_name) lblLoadBotFile:SetText(text.file_name)
    
    hintSaveChar:SetText(text.err_manual_hint)
    hintSaveBot:SetText(text.err_manual_hint)
    
    lblLang:SetText(text.lang_label) UIDropDownMenu_SetText(langDropdown, lang)
end

local function Dropdown_OnClick(self)
    lang = self.value if HelperDumperDB then HelperDumperDB.lang = lang end
    UpdateTexts() CloseMenus()
end

local function InitializeDropdown(self, level)
    local info = UIDropDownMenu_CreateInfo()
    for _, l in ipairs({"ES", "EN"}) do
        info.text = l; info.value = l; info.func = Dropdown_OnClick; info.checked = (lang == l)
        UIDropDownMenu_AddButton(info)
    end
end

-- 12. LÓGICA DE EJECUCIÓN DE COMANDOS DEL SERVIDOR

-- Confirmar Guardar Personaje
btnConfirmSave:SetScript("OnClick", function()
    local file, char = inputSaveFile:GetText(), inputSaveChar:GetText()
    if file == "" or char == "" then return end
    
    if HelperDumperDB.chars[file] then
        print(L[lang].err_exists)
        inputSaveFile:SetBackdropBorderColor(1, 0, 0, 1)
        btnDelChar:Show()
        hintSaveChar:Show()
        return 
    end
    
    HelperDumperDB.chars[file] = true
    SendChatMessage(string.format(".pdump write %s %s", file, char), "SAY")
    
    inputSaveFile:SetText(""); inputSaveChar:SetText("")
    inputSaveFile:SetBackdropBorderColor(0.8, 0.6, 0, 0.7)
    btnDelChar:Hide(); hintSaveChar:Hide()
    ShowPanel(MainMenu)
end)

-- Confirmar Cargar Personaje
btnConfirmLoad:SetScript("OnClick", function()
    local file, acc = inputLoadFile:GetText(), inputLoadAcc:GetText()
    if file == "" or acc == "" then return end
    SendChatMessage(string.format(".pdump load %s %s", file, acc), "SAY")
    inputLoadFile:SetText(""); inputLoadAcc:SetText("")
    ShowPanel(MainMenu)
end)

-- Confirmar Salvar Bots
btnConfirmSaveBots:SetScript("OnClick", function()
    local file = inputSaveBotFile:GetText()
    if file == "" then return end
    
    if HelperDumperDB.bots[file] then
        print(L[lang].err_exists)
        inputSaveBotFile:SetBackdropBorderColor(1, 0, 0, 1)
        btnDelBot:Show()
        hintSaveBot:Show()
        return 
    end
    
    HelperDumperDB.bots[file] = true
    SendChatMessage(string.format(".npcbot dump write %s", file), "SAY")
    
    inputSaveBotFile:SetText("")
    inputSaveBotFile:SetBackdropBorderColor(0.8, 0.6, 0, 0.7)
    btnDelBot:Hide(); hintSaveBot:Hide()
    ShowPanel(BotsMenu)
end)

-- Confirmar Cargar Bots
btnConfirmLoadBots:SetScript("OnClick", function()
    local file = inputLoadBotFile:GetText()
    if file == "" then return end
    SendChatMessage(string.format(".npcbot dump load %s", file), "SAY")
    inputLoadBotFile:SetText("")
    ShowPanel(BotsMenu)
end)

-- Limpiar toda la caché
btnClear:SetScript("OnClick", function()
    if HelperDumperDB then
        HelperDumperDB.chars = {}
        HelperDumperDB.bots = {}
        print(L[lang].cache_cleared)
    end
end)

-- 13. GESTIÓN DEL BOTÓN DEL MINIMAPA
local mmBtn = CreateFrame("Button", "HelperDumperMinimapButton", Minimap)
mmBtn:SetSize(32, 32) mmBtn:SetFrameLevel(Minimap:GetFrameLevel() + 3)
mmBtn:SetNormalTexture("Interface\\Icons\\INV_Misc_Head_Gnome_01")
mmBtn:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

local function MoveMinimapButton(angle)
    local x = math.cos(math.rad(angle)) * 80
    local y = math.sin(math.rad(angle)) * 80
    mmBtn:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

mmBtn:RegisterForDrag("RightButton")
mmBtn:SetScript("OnDragStart", function(self)
    self:SetScript("OnUpdate", function(self)
        local mx, my = GetCursorPosition()
        local scale = Minimap:GetEffectiveScale()
        local cx, cy = Minimap:GetCenter()
        local x, y = (mx / scale) - cx, (my / scale) - cy
        local angle = math.deg(math.atan2(y, x))
        if HelperDumperDB then HelperDumperDB.minimapPos = angle end
        MoveMinimapButton(angle)
    end)
end)
mmBtn:SetScript("OnDragStop", function(self) self:SetScript("OnUpdate", nil) end)
mmBtn:SetScript("OnClick", function(self, button)
    if button == "LeftButton" then
        if frame:IsShown() then frame:Hide() else ShowPanel(MainMenu); frame:Show() end
    end
end)

-- 14. INICIALIZACIÓN DEL ADDON POR EVENTO
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "HelperDumper" then
        if not HelperDumperDB then HelperDumperDB = {} end
        if not HelperDumperDB.chars then HelperDumperDB.chars = {} end
        if not HelperDumperDB.bots then HelperDumperDB.bots = {} end
        if not HelperDumperDB.minimapPos then HelperDumperDB.minimapPos = 45 end
        if HelperDumperDB.lang then lang = HelperDumperDB.lang end
        
        UIDropDownMenu_Initialize(langDropdown, InitializeDropdown)
        UpdateTexts() MoveMinimapButton(HelperDumperDB.minimapPos)
        tinsert(UISpecialFrames, "HelperDumperFrame") 
    end
end)

-- 15. REGISTRO DE COMANDOS DE CONSOLA CHAT
SLASH_HELPERDUMPER1 = "/hdump"
SlashCmdList["HELPERDUMPER"] = function()
    if frame:IsShown() then frame:Hide() else ShowPanel(MainMenu); frame:Show() end
end