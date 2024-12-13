---@diagnostic disable: undefined-global, need-check-nil, lowercase-global, cast-local-type, unused-local

script_name("Prison Helper")
script_description('Ñêðèïò äëÿ Òþðüìû Ñòðîãîãî Ðåæèìà LV')
script_author("MTG MODS.")
script_version("0.2.10")

require('lib.moonloader')
require('encoding').default = 'CP1251'
local u8 = require('encoding').UTF8
local ffi = require('ffi')
local sampev = require('samp.events')
function isMonetLoader() return MONET_VERSION ~= nil end

-------------------------------------------- JSON SETTINGS ---------------------------------------------
local settings = {}
local default_settings = {
	general = {
		version = thisScript().version,
		accent_enable = true,
		auto_mask = false,
		rp_chat = true,
		rp_gun = true,
		auto_change_code_siren = false,
		auto_update_members = false,
		auto_notify_payday = false,
		auto_notify_port = false,
		auto_uval = false,
		auto_clicker_situation = true,
		use_form_su = false,
		moonmonet_theme_enable = true,
		moonmonet_theme_color = 8900331,
		mobile_fastmenu_button = true,
		mobile_stop_button = true,
		mobile_meg_button = true,
		use_binds = true,
		use_info_menu = false,
		bind_mainmenu = '[113]',
		bind_fastmenu = '[69]',
		bind_leader_fastmenu = '[71]',
		bind_command_stop = '[123]',
		auto_doklad = false,
		post_status = 'Íåèçâåñòíî',

	},
	player_info = {
		name_surname = '',
		accent = '[Èíîñòðàííûé àêöåíò]:',
		fraction = 'Íåèçâåñòíî',
		fraction_tag = 'Íåèçâåñòíî',
		fraction_rank = 'Íåèçâåñòíî',
		fraction_rank_number = 0,
		sex = 'Íåèçâåñòíî',
	},
	player_organization = {
		use_infojob_menu = false,
		materials = 0,
		postavki_kargobob = 0,
		postavki_materials = 0,
	},
	deportament = {
		dep_fm = '-',
		dep_tag1 = '',
		dep_tag2 = '[Âñåì]',
		dep_tags = {
			"[Âñåì]",
			"[Ïîõèòèòåëè]",
			"[Òåðîðèñòû]",
			"[Äèñïåò÷åð]",
			'skip',
			"[ÌÞ]",
			"[Ìèí.Þñò.]",
			"[ËÑÏÄ]",
			"[ÑÔÏÄ]",
			"[ËÂÏÄ]",
			"[ÐÊØÄ]",
			"[ÑÂÀÒ]",
			"[ÔÁÐ]",
			'skip',
			"[ÌÎ]",
			"[Ìèí.Îáîðîíû]",
			"[ËÑà]",
			"[ÑÔà]",
			"[ÒÑÐ]",
			'skip',
			"[ÌÇ]",
			"[Ìèí.Çäðàâ.]",
			"[ËÑÌÖ]",
			"[ÑÔÌÖ]",
			"[ËÂÌÖ]",
			"[ÄÌÖ]",
			'skip',
			"[ÖÀ]",
			"[ÖË]",
			"[ÑÊ]",
			"[Ïðà-âî]",
			"[Ãóáåðíàòîð]",
			"[Ïðîêóðîð]",
			'skip',
			"[ÑÌÈ]",
			"[ÑÌÈ ËÑ]",
			"[ÑÌÈ ÑÔ]",
			"[ÑÌÈ ËÂ]",
		},
		dep_tags_en = {
			"[ALL]",
			'skip',
			"[MJ]",
			"[Min.Just.]",
			"[LSPD]",
			"[SFPD]",
			"[LVPD]",
			"[RCSD]",
			"[SWAT]",
			"[FBI]",
			'skip',
			"[MD]",
			"[Mid.Def.]",
			"[LSa]",
			"[SFa]",
			"[MSP]",
			'skip',
			"[MH]",
			"[Min.Healt]",
			"[LSMC]",
			"[SFMC]",
			"[LVMC]",
			"[JMC]",
			'skip',
			"[GOV]",
			"[DES]",
			"[Prosecutor]",
			"[LC]",
			"[INS]",
			'skip',
			"[CNN]",
			"[CNN LS]",
			"[CNN LV]",
			"[CNN SF]",
		},
		dep_tags_custom = {},
		dep_fms = {
			'-',
			'- ç.ê. -',
			'- 101.1 FM - ',

		},
	},
}
local configDirectory = getWorkingDirectory():gsub('\\', '/') .. "/Prison Helper"
local path_helper = getWorkingDirectory():gsub('\\', '/') .. "/Prison Helper.lua"
local path_settings = configDirectory .. "/Settings.json"
function load_settings()
	if not doesDirectoryExist(configDirectory) then
		createDirectory(configDirectory)
	end
	if not doesFileExist(path_settings) then
		settings = default_settings
		print('[Prison Helper] Ôàéë ñ íàñòðîéêàìè íå íàéäåí, èñïîëüçóþ ñòàíäàðòíûå íàñòðîéêè!')
	else
		local file = io.open(path_settings, 'r')
		if file then
			local contents = file:read('*a')
			file:close()
			if #contents == 0 then
				settings = default_settings
				print('[Prison Helper] Íå óäàëîñü îòêðûòü ôàéë ñ íàñòðîéêàìè, èñïîëüçóþ ñòàíäàðòíûå íàñòðîéêè!')
			else
				local result, loaded = pcall(decodeJson, contents)
				if result then
					settings = loaded
					print('[Prison Helper] Íàñòðîéêè óñïåøíî çàãðóæåíû!')
					if settings.general.version ~= thisScript().version then
						print('[Prison Helper] Íîâàÿ âåðñèÿ, ñáðîñ íàñòðîåê!')
						settings = default_settings
						save_settings()
						reload_script = true
						thisScript():reload()
					else
						print('[Prison Helper] Íàñòðîéêè óñïåøíî çàãðóæåíû!')
					end
				else
					print('[Prison Helper] Íå óäàëîñü îòêðûòü ôàéë ñ íàñòðîéêàìè, èñïîëüçóþ ñòàíäàðòíûå íàñòðîéêè!')
				end
			end
		else
			settings = default_settings
			print('[Prison Helper] Íå óäàëîñü îòêðûòü ôàéë ñ íàñòðîéêàìè, èñïîëüçóþ ñòàíäàðòíûå íàñòðîéêè!')
		end
	end
end

function save_settings()
	local file, errstr = io.open(path_settings, 'w')
	if file then
		local result, encoded = pcall(encodeJson, settings)
		file:write(result and encoded or "")
		file:close()
		print('[Prison Helper] Íàñòðîéêè ñîõðàíåíû!')
		return result
	else
		print('[Prison Helper] Íå óäàëîñü ñîõðàíèòü íàñòðîéêè õåëïåðà, îøèáêà: ', errstr)
		return false
	end
end

load_settings()
-------------------------------------------- JSON MY NOTES ---------------------------------------------
local notes = {
	note = {
	}
}
local path_notes = configDirectory .. "/Notes.json"
function load_notes()
	if doesFileExist(path_notes) then
		local file, errstr = io.open(path_notes, 'r')
		if file then
			local contents = file:read('*a')
			file:close()
			if #contents == 0 then
				print('[Prison Helper] Íå óäàëîñü îòêðûòü ôàéë ñ çàìåòêàìè!')
				print('[Prison Helper] Ïðè÷èíà: ýòîò ôàéë ïóñòîé')
			else
				local result, loaded = pcall(decodeJson, contents)
				if result then
					notes = loaded
					print('[Prison Helper] Çàìåòêè èíèöèàëèçèðîâàíû!')
				else
					print('[Prison Helper] Íå óäàëîñü îòêðûòü ôàéë ñ çàìåòêàìè!')
					print('[Prison Helper] Ïðè÷èíà: Íå óäàëîñü äåêîäèðîâàòü json (îøèáêà â ôàéëå)')
				end
			end
		else
			print('[Prison Helper] Íå óäàëîñü îòêðûòü ôàéë ñ çàìåòêàìè!')
			print('[Prison Helper] Ïðè÷èíà: ')
		end
	else
		print('[Prison Helper] Íå óäàëîñü îòêðûòü ôàéë ñ çàìåòêàìè!')
		print('[Prison Helper] Ïðè÷èíà: ýòîãî ôàéëà íåòó â ïàïêå ' .. configDirectory)
	end
end

function save_notes()
	local file, errstr = io.open(path_notes, 'w')
	if file then
		local result, encoded = pcall(encodeJson, notes)
		file:write(result and encoded or "")
		file:close()
		print('[Prison Helper] Çàìåòêè ñîõðàíåíû!')
		return result
	else
		print('[Prison Helper] Íå óäàëîñü ñîõðàíèòü çàìåòêè, îøèáêà: ', errstr)
		return false
	end
end

load_notes()
----------------------- JSON SMART RPTP(Ðåãëàìåíò ïîâûøåíèÿ ñðîêà çàêëþ÷¸ííûì) --------------------------------------
local smart_rptp = {}
local path_rptp = configDirectory .. "/SmartRPTP.json"
function load_smart_rptp()
	if doesFileExist(path_rptp) then
		local file, errstr = io.open(path_rptp, 'r')
		if file then
			local contents = file:read('*a')
			file:close()
			if #contents == 0 then
				print('[Prison Helper] Íå óäàëîñü îòêðûòü ôàéë ñ ðåãëàìåíòîì ïîâûøåíèÿ ñðîêà çàêëþ÷¸ííûì!')
				print('[Prison Helper] Ïðè÷èíà: ýòîò ôàéë ïóñòîé')
			else
				local result, loaded = pcall(decodeJson, contents)
				if result then
					smart_rptp = loaded
					print('[Prison Helper] Ðåãëàìåíò ïîâûøåíèÿ ñðîêà çàêëþ÷¸ííûì èíèöèàëèçèðîâàí!')
				else
					print('[Prison Helper] Íå óäàëîñü îòêðûòü ôàéë ñ ðåãëàìåíòîì ïîâûøåíèÿ ñðîêà çàêëþ÷¸ííûì!')
					print('[Prison Helper] Ïðè÷èíà: Íå óäàëîñü äåêîäèðîâàòü json (îøèáêà â ôàéëå)')
				end
			end
		else
			print('[Prison Helper] Íå óäàëîñü îòêðûòü ôàéë ñ ðåãëàìåíòîì ïîâûøåíèÿ ñðîêà çàêëþ÷¸ííûì!')
			print('[Prison Helper] Ïðè÷èíà: ')
		end
	else
		print('[Prison Helper] Íå óäàëîñü îòêðûòü ôàéë ñ ðåãëàìåíòîì ïîâûøåíèÿ ñðîêà çàêëþ÷¸ííûì!')
		print('[Prison Helper] Ïðè÷èíà: ýòîãî ôàéëà íåòó â ïàïêå ' .. configDirectory)
	end
end

function save_smart_rptp()
	local file, errstr = io.open(path_rptp, 'w')
	if file then
		local result, encoded = pcall(encodeJson, smart_rptp)
		file:write(result and encoded or "")
		file:close()
		print('[Prison Helper] Óìíûé ðîçûñê ñîõðàí¸í!')
		return result
	else
		print('[Prison Helper] Íå óäàëîñü ñîõðàíèòü óìíûé ðîçûñê, îøèáêà: ', errstr)
		return false
	end
end

load_smart_rptp()
-------------------------------------------- JSON COMMANDS (Êîìàíäû) ---------------------------------------------
local commands = {
	commands = {
		{ cmd = 'zd', description = 'Ïðèâåñòâèå èãðîêà', text = 'Çäðàñòâóéòå {get_ru_nick({arg_id})}&ß {my_ru_nick} - {fraction_rank} {fraction_tag}&×åì ÿ ìîãó Âàì ïîìî÷ü?', arg = '{arg_id}', enable = true, waiting = '3.500' },
		{ cmd = 'take', description = 'Èçüÿòèå ïðåäìåòîâ èãðîêà', text = '/do Â ïîäñóìêå íàõîäèòüñÿ íåáîëüøîé çèï-ïàêåò.&/me äîñòà¸ò èç ïîäñóìêà çèï-ïàêåò è îòðûâàåò åãî&/me êëàä¸ò â çèï-ïàêåò èçüÿòûå ïðåäìåòû çàäåðæàííîãî ÷åëîâåêà&/take {arg_id}&/do Èçüÿòûå ïðåäìåòû â çèï-ïàêåòå.&/todo Îòëè÷íî*óáèðàÿ çèï-ïàêåò â ïîäñóìîê', arg = '{arg_id}', enable = true, waiting = '3.500' },
		{ cmd = 'cure', description = 'Ïîäíÿòü èãðîêà èç ñòàäèè', text = '/me íàêëîíÿåòñÿ íàä ÷åëîâåêîì, è ïðîùóïûâàåò åãî ïóëüñ íà ñîííîé àðòåðèè&/cure {arg_id}&/do Ïóëüñ îòñóòñòâóåò.&/me íà÷èíàåò äåëàòü ÷åëîâåêó íåïðÿìîé ìàññàæ ñåðäöà, âðåìÿ îò âðåìåíè ïðîâåðÿÿ ïóëüñ&/do Ñïóñòÿ íåñêîëüêî ìèíóò ñåðäöå ÷åëîâåêà íà÷àëîñü áèòüñÿ.&/do ×åëîâåê ïðèøåë â ñîçíàíèå.&/todo Îòëè÷íî*óëûáàÿñü', arg = '{arg_id}', enable = true, waiting = '3.500' },
		{ cmd = 'carcer', description = 'Ïîñàäêà â êàðöåð èãðîêà', text = '/do Íà ïîÿñå âèñèò ñâÿçêà êëþ÷åé.&/me ïðèñëîíèâ çàêëþ÷¸ííîãî ê ñòåíå, ñíÿë êëþ÷ ñî ñâÿçêè, îòêðûë äâåðöó êàìåðû&/me äâèæåíèÿìè ðóê çàòîëêíóë çàêëþ÷¸ííîãî â êàìåðó, ïîñëå ÷åãî çàêðûë å¸&/me äâèæåíèÿìè ðóê çàêðåïèë êëþ÷ ê ñâÿçêå&/carcer {arg_id} {arg2} {arg3} {arg4}', arg = '{arg_id} {arg2} {arg3} {arg4}', enable = true, waiting = '3.500' },
		{ cmd = 'uncarcer', description = 'Âûïóñê èç êàðöåðà èãðîêà', text = '/do Íà ïîÿñå âèñèò ñâÿçêà êëþ÷åé.&/me äâèæåíèÿìè ðóê ñíÿë êëþ÷ ñî ñâÿçêè, îòêðûë êàìåðó è âûòîëêíóë èç íå¸ çàêëþ÷¸ííîãî&/me çàêðûë äâåðöó êàìåðû, çàêðåïèë êëþ÷ ê ñâÿçêå&/uncarcer {arg_id}', arg = '{arg_id}', enable = true, waiting = '3.500' },
		{ cmd = 'setcarcer', description = 'Ñìåíà êàðöåðà èãðîêó', text = '/do Íà ïîÿñå âèñèò ñâÿçêà êëþ÷åé.&/me äâèæåíèÿìè ðóê ñíÿë êëþ÷ ñî ñâÿçêè, îòêðûë ñâîáîäíóþ êàìåðó è êàìåðó çàêëþ÷¸ííîãî&/me âûòîëêíóë  çàêëþ÷¸ííîãî èç ïåðâîé êàìåðû, çàòîëêíóë âî âòîðóþ, çàêðûâ äâåðè îáîèõ êàìåð&/me äâèæåíèÿìè ðóê çàêðåïèë êëþ÷ ê ñâÿçêå&/setcarcer {arg_id} {arg2}', arg = '{arg_id}, {arg2}', enable = true, waiting = '3.500' },
		{ cmd = 'cuff', description = 'Íàäåòü íàðó÷íèêè', text = '/do Íàðó÷íèêè íà òàêòè÷åñêîì ïîÿñå.&/me ñíèìàåò íàðó÷íèêè ñ ïîÿñà è íàäåâàåò èõ íà çàäåðæàííîãî&/cuff {arg_id}&/do Çàäåðæàííûé â íàðó÷íèêàõ.', arg = '{arg_id}', enable = true, waiting = '3.500' },
		{ cmd = 'uncuff', description = 'Ñíÿòü íàðó÷íèêè', text = '/do Íà òàêòè÷åñêîì ïîÿñå ïðèêðåïëåíû êëþ÷è îò íàðó÷íèêîâ.&/me ñíèìàåò ñ ïîÿñà êëþ÷ îò íàðó÷íèêîâ è âñòàâëÿåò èõ â íàðó÷íèêè çàäåðæàííîãî&/me ïðîêðó÷èâàåò êëþ÷ â íàðó÷íèêàõ è ñíèìàåò èõ ñ çàäåðæàííîãî&&/uncuff {arg_id}&/do Íàðó÷íèêè ñíÿòû ñ çàäåðæàííîãî&/me êëàä¸ò êëþ÷ è íàðó÷íèêè îáðàòíî íà òàêòè÷åñêèé ïîÿñ', arg = '{arg_id}', enable = true, waiting = '3.500' },
		{ cmd = 'gotome', description = 'Ïîâåñòè çà ñîáîé', text = '/me ñõâàòûâàåò çàäåðæàííîãî çà ðóêè è âåä¸ò åãî çà ñîáîé&/gotome {arg_id}&/do Çàäåðæàííûé èä¸ò â êîíâîå.', arg = '{arg_id}', enable = true, waiting = '3.500' },
		{ cmd = 'ungotome', description = 'Ïåðåñòàòü âåñòè çà ñîáîé', text = '/me îòïóñêàåò ðóêè çàäåðæàííîãî è ïåðåñòà¸ò âåñòè åãî çà ñîáîé&/ungotome {arg_id}', arg = '{arg_id}', enable = true, waiting = '3.500' },
		{ cmd = 't', description = 'Äîñòàòü òàçåð', text = '/taser', arg = '', enable = true, waiting = '3.500' },
		{ cmd = 'camon', description = 'Âêëþ÷èòü cêðûòóþ áîäè êàìåðó', text = '/do Ê ôîðìå ïðèêðåïëåíà ñêðûòàÿ áîäè êàìåðà.&/me íåçàìåòíûì äâèæåíèåì ðóêè âêëþ÷èë{sex} áîäè êàìåðó.&/do Ñêðûòàÿ áîäè êàìåðà âêëþ÷åíà è ñíèìàåò âñ¸ ïðîèñõîäÿùåå.', arg = '', enable = true, waiting = '3.500' },
		{ cmd = 'camoff', description = 'Âûêëþ÷èòü cêðûòóþ áîäè êàìåðó', text = '/do Ê ôîðìå ïðèêðåïëåíà ñêðûòàÿ áîäè êàìåðà.&/me íåçàìåòíûì äâèæåíèåì ðóêè âûêëþ÷èë{sex} áîäè êàìåðó.&/do Ñêðûòàÿ áîäè êàìåðà âûêëþ÷åíà è áîëüøå íå ñíèìàåò âñ¸ ïðîèñõîäÿùåå.', arg = '', enable = true, waiting = '3.500' },
		{ cmd = 'time', description = 'Ïîñìîòðåòü âðåìÿ', text = '/me âçãëÿíóë{sex} íà ñâîè ÷àñû ñ ãðàâèðîâêîé MSP One Love è ïîñìîòðåë{sex} âðåìÿ&/time&/do Íà ÷àñàõ âèäíî âðåìÿ {get_time}.', arg = '', enable = false, waiting = '3.500' },
		{ cmd = 'book', description = 'Âûäà÷à èãðîêó òðóäîâîé êíèãè', text = 'Îêàçûâàåòñÿ ó âàñ íåòó òðóäîâîé êíèãè, íî íå ïåðåæèâàéòå!&Ñåé÷àñ ÿ âàì âûäàì å¸, âàì íå íóæíî íèêóäà åõàòü, ñåêóíäó...&/me äîñòà¸ò èç ñâîåãî êàðìàíà íîâóþ òðóäîâóþ êíèæêó è ñòàâèò íà íåé ïå÷àòü {fraction_tag}&/todo Áåðèòå*ïåðåäàâàÿ òðóäîâóþ êíèãó ÷åëîêó íàïðîòèâ&/givewbook {arg_id} 100&/n {get_nick({arg_id})}, ïðèìèòå ïðåäëîæåíèå â /offer ÷òîáû ïîëó÷èòü òðóäîâóþ êíèãó!', arg = '{arg_id}', enable = true, waiting = '3.500' },
		{ cmd = 'frisk', description = 'Îáûñê çàêëþ÷¸ííîãî', text = '/do Ïåð÷àòêè íà ïîÿñå.&/me ñõâàòèë ïåð÷àòêè è îäåë&/do Ïåð÷àòêè îäåòû.&/me íà÷àë íàùóïûâàòü ÷åëîâåêà íàïðîòèâ&/frisk {arg_id}', arg = '{arg_id}', enable = true, waiting = '3.500' }
	},
	commands_senior_staff = {
		{ cmd = 'rp', description = 'Âûäà÷à ñîòðóäíèêó /fractionrp', text = '/fractionrp {arg_id}', arg = '{arg_id}', enable = true, waiting = '3.500' },
		{
			cmd = 'punish_raise',
			description = 'Ïîâûñèòü óðîâåíü íàêàçàíèÿ',
			text =
			'/me äîñòà¸ò ñâîé ÊÏÊ è îòêðûâàåò áàçó äàííûõ ïðåñòóïíèêîâ&/me âíîñèò èçìåíåíèÿ â áàçó äàííûõ ïðåñòóïíèêîâ&/do Ïðåñòóïíèê çàíåñ¸í â áàçó äàííûõ ïðåñòóïíèêîâ.&/punish {arg_id} {arg2} 2 {arg3}',
			arg = '{arg_id} {arg2} {arg3}',
			enable = true,
			waiting = '3.500'
		},
		{
			cmd = 'punish_lower',
			description = 'Ïîíèçèòü óðîâåíü íàêàçàíèÿ',
			text =
			'/me äîñòà¸ò ñâîé ÊÏÊ è îòêðûâàåò áàçó äàííûõ ïðåñòóïíèêîâ&/me âíîñèò èçìåíåíèÿ â áàçó äàííûõ ïðåñòóïíèêîâ&/do Ïðåñòóïíèê çàíåñ¸í â áàçó äàííûõ ïðåñòóïíèêîâ.&/punish {arg_id} {arg2} 1 {arg3}',
			arg = '{arg_id} {arg2} {arg3}',
			enable = true,
			waiting = '3.500'
		}
	},
	commands_manage = {
		{ cmd = 'inv', description = 'Ïðèíÿòèå èãðîêà â ôðàêöèþ', text = '/do Â êàðìàíå åñòü ñâÿçêà ñ êëþ÷àìè îò ðàçäåâàëêè.&/me äîñòà¸ò èç êàðìàíà îäèí êëþ÷ èç ñâÿçêè êëþ÷åé îò ðàçäåâàëêè&/todo Âîçüìèòå, ýòî êëþ÷ îò íàøåé ðàçäåâàëêè*ïåðåäàâàÿ êëþ÷ ÷åëîâåêó íàïðîòèâ&/invite {arg_id}', arg = '{arg_id}', enable = true, waiting = '3.500' },
		{ cmd = 'gr', description = 'Ïîâûøåíèå/ïîíèæåíèå cîòðóäíèêà', text = '{show_rank_menu}&/me äîñòà¸ò èç êàðìàíà ñâîé òåëåôîí è çàõîäèò â áàçó äàííûõ {fraction_tag}&/me èçìåíÿåò èíôîðìàöèþ î ñîòðóäíèêå {get_ru_nick({arg_id})} â áàçå äàííûõ {fraction_tag}&/me âûõîäèò ñ áàçû äàííûõ è óáèðàåò òåëåôîí îáðàòíî â êàðìàí&/giverank {arg_id} {get_rank}&/r Ñîòðóäíèê {get_ru_nick({arg_id})} ïîëó÷èë íîâóþ äîëæíîñòü!', arg = '{arg_id}', enable = true, waiting = '3.500' },
		{ cmd = 'vize', description = 'Óïðàâëåíèå Vice City âèçîé ñîòðóäíèêà', text = '/me äîñòà¸ò èç êàðìàíà ñâîé òåëåôîí è çàõîäèò â áàçó äàííûõ {fraction_tag}&/me èçìåíÿåò èíôîðìàöèþ î ñîòðóäíèêå {get_ru_nick({arg_id})} â áàçå äàííûõ {fraction_tag}&/me âûõîäèò ñ áàçû äàííûõ è óáèðàåò òåëåôîí îáðàòíî â êàðìàí&{lmenu_vc_vize}', arg = '{arg_id}', enable = true, waiting = '3.500' },
		{ cmd = 'cjob', description = 'Ïîñìîòðåòü óñïåøíîñòü ñîòðóäíèêà', text = '/checkjobprogress {arg_id}', arg = '{arg_id}', enable = true, waiting = '3.500' },
		{ cmd = 'fmutes', description = 'Âûäàòü ìóò ñîòðóäíèêó (10 min)', text = '/fmutes {arg_id} Í.Ó.&/r Ñîòðóäíèê {get_ru_nick({arg_id})} ëèøèëñÿ ïðàâà èñïîëüçîâàòü ðàöèþ íà 10 ìèíóò!', arg = '{arg_id}', enable = true, waiting = '3.500' },
		{ cmd = 'funmute', description = 'Ñíÿòü ìóò ñîòðóäíèêó', text = '/funmute {arg_id}&/r Ñîòðóäíèê {get_ru_nick({arg_id})} òåïåðü ìîæåò ïîëüçîâàòüñÿ ðàöèåé!', arg = '{arg_id}', enable = true, waiting = '3.500' },
		{ cmd = 'vig', description = 'Âûäà÷à âûãîâîðà cîòðóäíèêó', text = '/me äîñòà¸ò èç êàðìàíà ñâîé òåëåôîí è çàõîäèò â áàçó äàííûõ {fraction_tag}&/me èçìåíÿåò èíôîðìàöèþ î ñîòðóäíèêå {get_ru_nick({arg_id})} â áàçå äàííûõ {fraction_tag}&/me âûõîäèò ñ áàçû äàííûõ è óáèðàåò òåëåôîí îáðàòíî â êàðìàí&/fwarn {arg_id} {arg2}&/r Ñîòðóäíèêó {get_ru_nick({arg_id})} âûäàí âûãîâîð! Ïðè÷èíà: {arg2}', arg = '{arg_id} {arg2}', enable = true, waiting = '3.500' },
		{ cmd = 'unvig', description = 'Ñíÿòèå âûãîâîðà cîòðóäíèêó', text = '/me äîñòà¸ò èç êàðìàíà ñâîé òåëåôîí è çàõîäèò â áàçó äàííûõ {fraction_tag}&/me èçìåíÿåò èíôîðìàöèþ î ñîòðóäíèêå {get_ru_nick({arg_id})} â áàçå äàííûõ {fraction_tag}&/me âûõîäèò ñ áàçû äàííûõ è óáèðàåò òåëåôîí îáðàòíî â êàðìàí&/unfwarn {arg_id}&/r Ñîòðóäíèêó {get_ru_nick({arg_id})} áûë ñíÿò âûãîâîð!', arg = '{arg_id}', enable = true, waiting = '3.500' },
		{ cmd = 'unv', description = 'Óâîëüíåíèå èãðîêà èç ôðàêöèè', text = '/me äîñòà¸ò èç êàðìàíà ñâîé òåëåôîí è çàõîäèò â áàçó äàííûõ {fraction_tag}&/me èçìåíÿåò èíôîðìàöèþ î ñîòðóäíèêå {get_ru_nick({arg_id})} â áàçå äàííûõ {fraction_tag}&/me âûõîäèò ñ áàçû äàííûõ è óáèðàåò ñâîé òåëåôîí îáðàòíî â êàðìàí&/uninvite {arg_id} {arg2}&/r Ñîòðóäíèê {get_ru_nick({arg_id})} áûë óâîëåí ïî ïðè÷èíå: {arg2}', arg = '{arg_id} {arg2}', enable = true, waiting = '3.500' },
		{ cmd = 'point', description = 'Óñòàíîâèòü ìåòêó äëÿ ñîòðóäíèêîâ', text = '/r Ñðî÷íî âûäâèãàéòåñü êî ìíå, îòïðàâëÿþ âàì êîîðäèíàòû...&/point', arg = '', enable = true, waiting = '3.500' },
	}
}

local path_commands = configDirectory .. "/Commands.json"
function load_commands()
	if doesFileExist(path_commands) then
		local file, errstr = io.open(path_commands, 'r')
		if file then
			local contents = file:read('*a')
			file:close()
			if #contents == 0 then
				print('[Prison Helper] Íå óäàëîñü îòêðûòü ôàéë ñ êîìàíäàìè!')
				print('[Prison Helper] Ïðè÷èíà: ýòîò ôàéë ïóñòîé')
			else
				local result, loaded = pcall(decodeJson, contents)
				if result then
					commands = loaded
					print('[Prison Helper] Âñå êîìàíäû èíèöèàëèçèðîâàí!')
				else
					print('[Prison Helper] Íå óäàëîñü îòêðûòü ôàéë ñ êîìàíäàìè!')
					print('[Prison Helper] Ïðè÷èíà: Íå óäàëîñü äåêîäèðîâàòü json (îøèáêà â ôàéëå)')
				end
			end
		else
			print('[Prison Helper] Íå óäàëîñü îòêðûòü ôàéë ñ êîìàíäàìè!')
			print('[Prison Helper] Ïðè÷èíà: ', errstr)
		end
	else
		print('[Prison Helper] Íå óäàëîñü îòêðûòü ôàéë ñ êîìàíäàìè!')
		print('[Prison Helper] Ïðè÷èíà: ýòîãî ôàéëà íåòó â ïàïêå ' .. configDirectory)
		print('[Prison Helper] Èíèöèàëèçàöèÿ ñòàíäàðòíûõ êîìàíä...')
		save_commands()
		load_commands()
	end
end

function save_commands()
	local file, errstr = io.open(path_commands, 'w')
	if file then
		local result, encoded = pcall(encodeJson, commands)
		file:write(result and encoded or "")
		file:close()
		print('[Prison Helper] Âàøè êîìàíäû ñîõðàíåíû!')
		return result
	else
		print('[Prison Helper] Íå óäàëîñü ñîõðàíèòü êîìàíäû õåëïåðà, îøèáêà: ', errstr)
		return false
	end
end

load_commands()
-------------------------------------------- JSON ARZ VEHICLES ---------------------------------------------
local path_arzvehicles = configDirectory .. "/VehiclesArizona.json"
local arzvehicles = {}
function load_arzvehicles()
	if doesFileExist(path_arzvehicles) then
		local file, errstr = io.open(path_arzvehicles, 'r')
		if file then
			local contents = file:read('*a')
			file:close()
			if #contents == 0 then
				print('[Prison Helper] Íå óäàëîñü îòêðûòü ôàéë ñ ìîäåëÿìè êàðîâ àðèçîíû!')
				print('[Prison Helper] Ïðè÷èíà: ýòîò ôàéë ïóñòîé')
			else
				local result, loaded = pcall(decodeJson, contents)
				if result then
					arzvehicles = loaded
					print('[Prison Helper] Ìîäåëè êàñòîì êàðîâ àðèçîíû èíèöèàëèçèðîâàíû!')
				else
					print('[Prison Helper] Íå óäàëîñü îòêðûòü ôàéë ñ ìîäåëÿìè êàðîâ àðèçîíû!')
					print('[Prison Helper] Ïðè÷èíà: Íå óäàëîñü äåêîäèðîâàòü json (îøèáêà â ôàéëå)')
				end
			end
		else
			print('[Prison Helper] Íå óäàëîñü îòêðûòü ôàéë ñ ìîäåëÿìè êàðîâ àðèçîíû!')
			print('[Prison Helper] Ïðè÷èíà: ', errstr)
		end
	else
		print('[Prison Helper] Íå óäàëîñü îòêðûòü ôàéë ñ ìîäåëÿìè êàðîâ àðèçîíû!')
		print('[Prison Helper] Ïðè÷èíà: ýòîãî ôàéëà íåòó â ïàïêå ' .. configDirectory)
	end
end

load_arzvehicles()
local colorNames = {
	[0] = "÷¸ðíîãî",
	[1] = "áåëîãî",
	[2] = "áèðþçîâîãî",
	[3] = "áîðäîâîãî",
	[4] = "ò¸ìíî-çåë¸íîãî",
	[5] = "êðàñíî-ïóðïóðíîãî",
	[6] = "çîëîòèñòî-æ¸ëòîãî",
	[7] = "ñèíåãî",
	[8] = "ñâåòëî-ñåðîãî",
	[9] = "ñåðî-çåë¸íîãî",
	[10] = "ò¸ìíî-ñèíåãî",
	[11] = "ñåðî-ñèíåãî",
	[12] = "ãîëóáèíî-ñèíåãî",
	[13] = "ãðàôèòîâî-ñåðîãî",
	[14] = "î÷åíü ñâåòëî-ñåðîãî",
	[15] = "ñâåòëî-ñåðîãî",
	[16] = "ò¸ìíî-çåë¸íîãî",
	[17] = "íàñûùåííîãî êðàñíî-êîðè÷íåâîãî",
	[18] = "ò¸ìíî-ðîçîâîãî",
	[19] = "ñåðî-êîðè÷íåâîãî",
	[20] = "ò¸ìíî-ñèíåãî",
	[21] = "ñâåòëî-áóðäîâîãî",
	[22] = "áîðäîâî-êðàñíîãî",
	[23] = "ñåðîãî",
	[24] = "ãðàôèòîâîãî",
	[25] = "ò¸ìíî-ñåðîãî",
	[26] = "ñâåòëî-ñåðîãî",
	[27] = "òóñêëî-ñåðîãî",
	[28] = "ò¸ìíî-ñèíåãî",
	[29] = "ñâåòëî-ñåðîãî",
	[30] = "÷åðíî-êðàñíîãî",
	[31] = "ò¸ìíî-êðàñíîãî",
	[32] = "ñâåòëî-ñåðîãî ñ ãîëóáûì îòòåíêîì",
	[33] = "ñåðîé áåëêè",
	[34] = "òóñêëî-ñåðîãî",
	[35] = "ñåðî-êîðè÷íåâîãî",
	[36] = "ñåðî-ñèíåãî",
	[37] = "÷åðíî-çåë¸íîãî",
	[38] = "ñåðîãî",
	[39] = "ñåðî-ñèíåãî",
	[40] = "êðàñíîâàòî-÷åðíîãî",
	[41] = "ñåðî-êîðè÷íåâîãî",
	[42] = "êîðè÷íåâî-êðàñíîãî",
	[43] = "ò¸ìíî-áîðäîâîãî",
	[44] = "ò¸ìíî-çåë¸íîãî",
	[45] = "ò¸ìíî-áîðäîâîãî",
	[46] = "ñåðî-áåæåâîãî",
	[47] = "çåëåíîâàòî-ñåðîãî",
	[48] = "êâàðöåâîãî",
	[49] = "ñåðî-ãîëóáîãî",
	[50] = "ñåðåáðèñòî-ñåðîãî",
	[51] = "ò¸ìíî-çåë¸íîãî",
	[52] = "ñåðî-ñèíåãî",
	[53] = "î÷åíü ò¸ìíîãî ñèíåãî",
	[54] = "ò¸ìíî-ñèíåãî",
	[55] = "ò¸ìíî-êîðè÷íåâîãî",
	[56] = "ñåðî-ãîëóáîãî",
	[57] = "ñâåòëî-êîðè÷íåâîãî",
	[58] = "ò¸ìíî-êðàñíîãî",
	[59] = "îòäàëåííî-ñèíåãî",
	[60] = "ñâåòëî-ñåðîãî",
	[61] = "ò¸ìíî-êîðè÷íåâîãî",
	[62] = "ò¸ìíî-êðàñíîãî",
	[63] = "ñåðåáðèñòî-ñåðîãî",
	[64] = "ñâåòëî-ñåðîãî",
	[65] = "îëèâêîâîãî",
	[66] = "ò¸ìíîãî ñåðî-êðàñíî-êîðè÷íåâîãî",
	[67] = "àñïèäíî-ñåðîãî",
	[68] = "îëèâêîâî-ñåðîãî",
	[69] = "êâàðöåâîãî",
	[70] = "ò¸ìíî-êðàñíîãî",
	[71] = "ñâåòëî àñïèäíî-ñåðîãî",
	[72] = "ñåðîâàòî-çåëåíîãî",
	[73] = "îëèâêîâî-çåë¸íîãî",
	[74] = "ò¸ìíî-áîðäîâîãî",
	[75] = "î÷åíü ò¸ìíîãî ñèíåãî",
	[76] = "ñâåòëî-îëèâêîâîãî",
	[77] = "ñâåòëî-êîðè÷íåâîãî",
	[78] = "ò¸ìíî-ðîçîâîãî",
	[79] = "ò¸ìíî-ñèíåãî",
	[80] = "ò¸ìíî-ðîçîâîãî",
	[81] = "ñðåäíå-ñåðîãî",
	[82] = "ò¸ìíî-êðàñíîãî",
	[83] = "çåëåíî-ñèíåãî",
	[84] = "ò¸ìíî-êîðè÷íåâîãî",
	[85] = "ò¸ìíî-ðîçîâîãî",
	[86] = "ò¸ìíî-çåë¸íîãî",
	[87] = "ò¸ìíî-ñèíåãî",
	[88] = "âèííî-êðàñíîãî",
	[89] = "ñâåòëî-îëèâêîâîãî",
	[90] = "ñâåòëî-ñåðîãî",
	[91] = "ïóðïóðíî-ñèíåãî",
	[92] = "ò¸ìíî-ñåðîãî",
	[93] = "ñèíåãî",
	[94] = "ò¸ìíî-ñèíåãî",
	[95] = "ò¸ìíî-ñèíåãî",
	[96] = "ñâåòëî-ñåðîãî",
	[97] = "àñïèäíî-ñåðîãî",
	[98] = "ò¸ìíî-ñåðîãî",
	[99] = "áëåäíî ñåðî-êîðè÷íåâîãî",
	[100] = "áðèëèàíòîâî-ñèíåãî",
	[101] = "êîáàëüòî-ñèíåãî",
	[102] = "ñâåòëî-êîðè÷íåâîãî",
	[103] = "ñèíåãî",
	[104] = "ñâåòëî-êîðè÷íåâîãî",
	[105] = "ñåðîâàòî-ñèíåãî",
	[106] = "ñèíåãî",
	[107] = "êâàðöåâîãî",
	[108] = "áðèëèàíòîâî-ñèíåãî",
	[109] = "ñåðîâàòî-ñèíåãî",
	[110] = "ñâåòëî îëèâêîâî-ñåðîãî",
	[111] = "ñåðîâàòî-ãîëóáîãî",
	[112] = "ñèíåâàòî-ñåðîãî",
	[113] = "ò¸ìíî-êîðè÷íåâîãî",
	[114] = "ñåðîâàòî-çåë¸íîãî",
	[115] = "ò¸ìíî-êðàñíîãî",
	[116] = "ò¸ìíî-ñèíåãî",
	[117] = "ò¸ìíî-áîðäîâîãî",
	[118] = "ñâåòëî-ãîëóáîãî",
	[119] = "êðàñíîâàòî-êîðè÷íåâîãî",
	[120] = "êâàðöåâîãî",
	[121] = "ò¸ìíî-áîðäîâîãî",
	[122] = "ò¸ìíî-ñåðîãî",
	[123] = "ò¸ìíî-êîðè÷íåâîãî",
	[124] = "ò¸ìíî-êðàñíîãî",
	[125] = "ò¸ìíî-ñèíåãî",
	[126] = "ðîçîâîãî",
	[127] = "÷¸ðíîãî",
	[128] = "çåë¸íîãî",
	[129] = "ò¸ìíîãî áîðäîâîãî",
	[130] = "ñèíåãî",
	[131] = "ò¸ìíî-êîðè÷íåâîãî",
	[132] = "ò¸ìíî-êðàñíîãî",
	[133] = "÷¸ðíîãî ñ ë¸ãêèì îòòåíêîì çåë¸íîãî",
	[134] = "ò¸ìíî-ñèíåãî",
	[135] = "ÿðêî-ñèíåãî",
	[136] = "àìåòèñòîâîãî",
	[137] = "òðàâÿíîãî çåë¸íîãî",
	[138] = "ñâåòëî ñåðîãî",
	[139] = "íàñûùåííîãî ïóðïóðíî-ñèíåãî",
	[140] = "ñâåòëî-ñåðîãî",
	[141] = "ò¸ìíî-ñåðîãî",
	[142] = "îëèâêîâîãî",
	[143] = "ò¸ìíî-ñåðîãî ñ ôèîëåòîâûì îòòåíêîì",
	[144] = "ò¸ìíî-ôèîëåòîâîãî",
	[145] = "ñâåòëî-çåë¸íîãî",
	[146] = "ðîçîâàòî-êîðè÷íåâîãî",
	[147] = "ò¸ìíî-ôèîëåòîâîãî",
	[148] = "ò¸ìíîãî ñåðî-îëèâêîâî-çåë¸íîãî",
	[149] = "î÷åíü ò¸ìíî-êîðè÷íåâîãî",
	[150] = "îëèâêîâî-÷åðíîãî",
	[151] = "÷¸ðíîãî",
	[152] = "ò¸ìíî-çåë¸íîãî",
	[153] = "ñâåòëî-ðîçîâîãî",
	[154] = "ñâåòëî-ñåðîãî",
	[155] = "ò¸ìíî-çåë¸íîãî",
	[156] = "ñåðî-êîðè÷íåâîãî",
	[157] = "÷¸ðíîãî",
	[158] = "ò¸ìíî-çåë¸íîãî",
	[159] = "ò¸ìíî-êîðè÷íåâîãî",
	[160] = "ò¸ìíî-êðàñíîãî",
	[161] = "ñâåòëî-êîðè÷íåâîãî",
	[162] = "ò¸ìíî-êîðè÷íåâîãî",
	[163] = "ò¸ìíî-ðîçîâîãî",
	[164] = "ò¸ìíî-ñèíåãî",
	[165] = "ñâåòëî-êîðè÷íåâîãî",
	[166] = "ò¸ìíî-ñèíåãî",
	[167] = "ò¸ìíî-îðàíæåâîãî",
	[168] = "ò¸ìíî-ñèíåãî",
	[169] = "ò¸ìíî-ðîçîâîãî",
	[170] = "ò¸ìíî-îðàíæåâîãî",
	[171] = "ò¸ìíî-îðàíæåâîãî",
	[172] = "÷¸ðíîãî",
	[173] = "ò¸ìíî-ñèíåãî",
	[174] = "ñèíåãî",
	[175] = "ò¸ìíî-êîðè÷íåâîãî",
	[176] = "ò¸ìíî-îðàíæåâîãî",
	[177] = "ò¸ìíî-êîðè÷íåâîãî",
	[178] = "ò¸ìíî-çåë¸íîãî",
	[179] = "ò¸ìíî-ñèíåãî",
	[180] = "ñâåòëî-ñåðîãî",
	[181] = "ò¸ìíî-çåë¸íîãî",
	[182] = "ò¸ìíî-îðàíæåâîãî",
	[183] = "ñâåòëî-îëèâêîâîãî",
	[184] = "ñâåòëî-ñèíåãî",
	[185] = "÷¸ðíîãî",
	[186] = "ò¸ìíî-êîðè÷íåâîãî",
	[187] = "ò¸ìíî-ñèíåãî",
	[188] = "ò¸ìíî-êîðè÷íåâîãî",
	[189] = "ñâåòëî-îðàíæåâîãî",
	[190] = "ñâåòëî-çåë¸íîãî",
	[191] = "÷¸ðíîãî",
	[192] = "ò¸ìíî-îðàíæåâîãî",
	[193] = "ò¸ìíî-êîðè÷íåâîãî",
	[194] = "ò¸ìíî-çåë¸íîãî",
	[195] = "ò¸ìíî-êîðè÷íåâîãî",
	[196] = "÷¸ðíîãî",
	[197] = "ò¸ìíî-ñèíåãî",
	[198] = "ò¸ìíî-êîðè÷íåâîãî",
	[199] = "ò¸ìíî-îðàíæåâîãî",
	[200] = "÷¸ðíîãî",
	[201] = "ò¸ìíî-êîðè÷íåâîãî",
	[202] = "ñâåòëî-êîðè÷íåâîãî",
	[203] = "ñâåòëî-êîðè÷íåâîãî",
	[204] = "÷¸ðíîãî",
	[205] = "ò¸ìíî-ñèíåãî",
	[206] = "ò¸ìíî-çåë¸íîãî",
	[207] = "÷¸ðíîãî",
	[208] = "ò¸ìíî-ñèíåãî",
	[209] = "ò¸ìíî-çåë¸íîãî",
	[210] = "÷¸ðíîãî",
	[211] = "ò¸ìíî-ñèíåãî",
	[212] = "ò¸ìíî-çåë¸íîãî",
	[213] = "÷¸ðíîãî",
	[214] = "ò¸ìíî-ñèíåãî",
	[215] = "ò¸ìíî-êîðè÷íåâîãî",
	[216] = "ò¸ìíî-îðàíæåâîãî",
	[217] = "ò¸ìíî-êîðè÷íåâîãî",
	[218] = "ò¸ìíî-ñèíåãî",
	[219] = "÷¸ðíîãî",
	[220] = "ò¸ìíî-çåë¸íîãî",
	[221] = "÷¸ðíîãî",
	[222] = "ò¸ìíî-êîðè÷íåâîãî",
	[223] = "÷¸ðíîãî",
	[224] = "ò¸ìíî-ñèíåãî",
	[225] = "ò¸ìíî-çåë¸íîãî",
	[226] = "÷¸ðíîãî",
	[227] = "ò¸ìíî-ñèíåãî",
	[228] = "ò¸ìíî-êîðè÷íåâîãî",
	[229] = "ò¸ìíî-îðàíæåâîãî",
	[230] = "÷¸ðíîãî",
	[231] = "ò¸ìíî-êîðè÷íåâîãî",
	[232] = "ò¸ìíî-ñèíåãî",
	[233] = "÷¸ðíîãî",
	[234] = "ò¸ìíî-ñèíåãî",
	[235] = "ò¸ìíî-êîðè÷íåâîãî",
	[236] = "ò¸ìíî-çåë¸íîãî",
	[237] = "÷¸ðíîãî",
	[238] = "ò¸ìíî-îðàíæåâîãî",
	[239] = "ò¸ìíî-êîðè÷íåâîãî",
	[240] = "ò¸ìíî-çåë¸íîãî",
	[241] = "ò¸ìíî-ñèíåãî",
	[242] = "ò¸ìíî-êîðè÷íåâîãî",
	[243] = "ò¸ìíî-ñèíåãî",
	[244] = "÷¸ðíîãî",
	[245] = "ò¸ìíî-çåë¸íîãî",
	[246] = "ò¸ìíî-êîðè÷íåâîãî",
	[247] = "ò¸ìíî-ñèíåãî",
	[248] = "ò¸ìíî-çåë¸íîãî",
	[249] = "÷¸ðíîãî",
	[250] = "ò¸ìíî-îðàíæåâîãî",
	[251] = "ò¸ìíî-ñèíåãî",
	[252] = "÷¸ðíîãî",
	[253] = "ò¸ìíî-êîðè÷íåâîãî",
	[254] = "ò¸ìíî-çåë¸íîãî",
	[255] = "ò¸ìíî-ñèíåãî"
}
---------------------------------------------- Mimgui -----------------------------------------------------
--[[
		imgui.Begin("íàçâàíèå")  					-- Ñîçäà¸ì íîâîå îêíî ñ çàãîëîâêîì 'íàçâàíèå'
        imgui.Text("òåêñò")         				-- Âûâåñòè îïðåäåë¸ííûé òåêñò
        imgui.End()                 				-- Îáúÿâëÿåì êîíåö äàííîãî îêíà
		imgui.Button()								-- Ñîçäàíèå êíîïêè
		imgui.InputText()							-- Ñîçäàíèå ïîëÿ äëÿ ââîäà òåêñòà
		imgui.TextDisabled()						-- Îòêëþ÷¸ííûé òåêñò
		imgui.SetCursorPosX()						-- Ïîçâîëÿåò çàäàòü ïîëîæåíèå ôóíêöèè ïî ãîðèçîíòàëè
		imgui.SetCursorPosY()						-- Ïîçâîëÿåò çàäàòü ïîëîæåíèå ôóíêöèè ïî âåðòèêàëè
		imgui.SetCursorPos(imgui.ImVec2(50, 170)) 	-- 50 = ïî ãîðèçîíòàëè, 170 ïî âåðòèêàëè
		imgui.BeginTooltip()						-- Âûâîä îïðåäåë¸ííîãî òåêñòà ïðè íàâåäåíèè(ïîäñêàçêè)
		imgui.Columns(êîëè÷åñòâî)					-- Êîëè÷åñòâî ñòîëáöîâ â òàáëèöå
		imgui.CenterText(òåêñò)						-- Âûâîä òåêñòà ïî ñåðåäèíå
		imgui.EndTooltip()							-- Çàâåðøåíèå îòîáðàæåíèå ïîäñêàçêè
		imgui.Separator()							-- Âèçóàëüíûé ðàçäåëèòåëü ýëåìåíòîâ íà ýêðàíå
		imgui.ColoredButton(u8'íàçâàíèå êíîïêè', 'öâåò â HEX ôîðìàòå', ïðîçðà÷íîñòü,imgui.ImVec2(ðàçìåð êíîïêè(X,Y)))

		Flags:
		imgui.WindowFlags.NoDecoration - óáèðàåò âåðõíþþ áðîâü, ïîëóçíîê äëÿ èçìåíåíèÿ îêíà è ëþáûå äðóãèå ýëåìåíòû ìèìãóè îêíà
		imgui.WindowFlags.NoTitleBar - óáèðàåò çàãîëîâîê îêíà
		imgui.WindowFlags.NoResize - çàïðåùàåò èçìåíÿòü ðàçìåð
		imgui.WindowFlags.NoMove - çàïðåùàåò ïåðåäâèãàòü îêíî
		imgui.WindowFlags.AlwaysAutoResize - àâòîìàòè÷åñêè ñòàâèò ðàçìåð îêíà
		imgui.WindowFlags.NoBackground - äåëàåò ôîí îêíà ïðîçðà÷íûì
		imgui.WindowFlags.Tooltip - âêëþ÷àåò ïîäñêàçêè
		imgui.WindowFlags.ShowBorders - âêëþ÷àåò îáâîäêó ýëåìåíòîâ
		imgui.WindowFlags.NoScrollbar - óáèðàåò ïîëçóíîê ïðîêðóòêè
		imgui.WindowFlags.NoCollapse - çàïðåùàåò ìèíèìèçèðîâàòü îêíî ïðè äâîéíîì êëèêå
		imgui.WindowFlags.NoScrollWithMouse - îòêëþ÷àåò ïðîêðóòêó êîë¸ñèêîì ìûøè
		imgui.WindowFlags.NoSavedSettings - îòêëþ÷àåò ñîõðàíåíèÿ íàñòðîåê â ôàéë
		imgui.WindowFlags.AlwaysUseWindowPadding - ñîçäàåò îòñòóïû âîêðóã îêíà
		imgui.WindowFlags.NoInputs - îòêëþ÷àåò ìûøü è êëàâèàòóðó
		imgui.WindowFlags.NoFocusOnAppearing - îòêëþ÷àåò ôîêóñ ïðè ïåðåõîäå îò ñêðûòîãî ê âèäèìîìó ñîñòîÿíèþ
		
]] --
local imgui = require('mimgui')
local fa = require('fAwesome6_solid')
local sizeX, sizeY = getScreenResolution()

local MainWindow = imgui.new.bool()
local checkboxone = imgui.new.bool(false)
local checkbox_accent_enable = imgui.new.bool(settings.general.accent_enable or false)
local checkbox_automask = imgui.new.bool(settings.general.auto_mask or false)
local checkbox_update_members = imgui.new.bool(settings.general.auto_update_members or false)

local input_accent = imgui.new.char[256](u8(settings.player_info.accent))
local input_name_surname = imgui.new.char[256](u8(settings.player_info.name_surname))
local input_fraction_tag = imgui.new.char[256](u8(settings.player_info.fraction_tag))
local input_post_status = imgui.new.char[256](u8(settings.general.post_status))
local theme = imgui.new.int(0)
local fastmenu_type = imgui.new.int(settings.general.mobile_fastmenu_button and 1 or 0)
local stop_type = imgui.new.int(settings.general.mobile_stop_button and 1 or 0)


local DeportamentWindow = imgui.new.bool()
local input_dep_fm = imgui.new.char[32](u8(settings.deportament.dep_fm))
local input_dep_text = imgui.new.char[256]()
local input_dep_tag1 = imgui.new.char[32](u8(settings.deportament.dep_tag1))
local input_dep_tag2 = imgui.new.char[32](u8(settings.deportament.dep_tag2))
local input_dep_new_tag = imgui.new.char[32]()

local MembersWindow = imgui.new.bool()
local members = {}
local members_new = {}
local members_check = false
local members_fraction = nil
local update_members_check = false

local WantedWindow = imgui.new.bool()
local wanted = {}
local wanted_new = {}
local check_wanted = false
local update_wanted_check = false

local GiveRankMenu = imgui.new.bool()
local giverank = imgui.new.int(5)

local SobesMenu = imgui.new.bool()

local SumMenuWindow = imgui.new.bool()
local input_sum = imgui.new.char[128]()
local checkbox_sum = imgui.new.bool(settings.general.use_form_su)
local form_su = ''

local TsmMenuWindow = imgui.new.bool()
local input_tsm = imgui.new.char[128]()

local CommandStopWindow = imgui.new.bool()
local CommandPauseWindow = imgui.new.bool()

local LeaderFastMenu = imgui.new.bool()
local FastMenu = imgui.new.bool()
local FastPieMenu = imgui.new.bool()
local FastMenuButton = imgui.new.bool()
local FastMenuPlayers = imgui.new.bool()

local NoteWindow = imgui.new.bool()
local show_note_name = nil
local show_note_text = nil

local naidenpost = false

local InformationWindow = imgui.new.bool()
local JobInformationWindow = imgui.new.bool()
local MegafonWindow = imgui.new.bool()
local UpdateWindow = imgui.new.bool()
local updateUrl = ""
local updateVer = ""
local updateInfoText = ""
local need_update_helper = false
local download_helper = false
local download_smartRPTP = false
local download_arzvehicles = false

local BinderWindow = imgui.new.bool()
local waiting_slider = imgui.new.float(0)
local ComboTags = imgui.new.int()
local item_list = { u8 'Áåç àðãóìåíòà', u8 '{arg} - ïðèíèìàåò ëþáîé àðãóìåíò', u8 '{arg_id} - ïðèíèìàåò òîëüêî àðãóìåíò ID èãðîêà',
	u8 '{arg_id} {arg2} - ïðèíèìàåò 2 àðóãìåíòà: ID èãðîêà è ëþáîé àðãóìåíò', u8 '{arg_id} {arg2} {arg3} - ïðèíèìàåò 3 àðãóìåíòà: ID èãðîêà, îäíó öèôðó, è ëþáîé àðãóìåíò',
	u8 '{arg_id} {arg2} {arg3} {arg4} - ïðèíèìàåò 4 àðãóìåíòà: ID èãðîêà, îäíó öèôðó è äâà ëþáûõ àðãóìåíòà' }
local ImItems = imgui.new['const char*'][#item_list](item_list)
local change_waiting = nil
local change_cmd_bool = false
local change_cmd = nil
local change_description = nil
local change_text = nil
local change_arg = nil
local binder_create_command_9_10 = false
local binder_create_command_5_8 = false
local tagReplacements = {
	my_id = function() return select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)) end,
	my_nick = function() return sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) end,
	my_rp_nick = function()
		return sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub('_',
			' ')
	end,
	my_doklad_nick = function()
		local nick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
		if nick:find('(.+)%_(.+)') then
			local name, surname = nick:match('(.+)%_(.+)')
			return name:sub(1, 1) .. '.' .. surname
		else
			return nick
		end
	end,
	my_ru_nick = function() return TranslateNick(settings.player_info.name_surname) end,
	fraction_rank_number = function() return settings.player_info.fraction_rank_number end,
	fraction_rank = function() return settings.player_info.fraction_rank end,
	fraction_tag = function() return settings.player_info.fraction_tag end,
	post_status = function() return settings.general.post_status end,
	fraction = function() return settings.player_info.fraction end,
	sex = function()
		if settings.player_info.sex == 'Æåíùèíà' then
			local temp = 'à'
			return temp
		else
			return ''
		end
	end,
	get_time = function()
		return os.date("%H:%M:%S")
	end,
	get_rank = function()
		return giverank[0]
	end,
	get_square = function()
		return kvadrat()
	end,
	get_area = function()
		local x, y, z = getCharCoordinates(PLAYER_PED)
		return calculateZoneRu(x, y, z)
	end,
	get_city = function()
		local city = {
			[0] = "Âíå ãîðîäà",
			[1] = "Ëîñ Ñàíòîñ",
			[2] = "Ñàí Ôèåððî",
			[3] = "Ëàñ Âåíòóðàñ"
		}
		return city[getCityPlayerIsIn(PLAYER_PED)]
	end,
	get_storecar_model = function()
		local closest_car = nil
		local closest_distance = 75
		local my_pos = { getCharCoordinates(PLAYER_PED) }
		local my_car
		if isCharInAnyCar(PLAYER_PED) then
			my_car = storeCarCharIsInNoSave(PLAYER_PED)
		end
		for _, vehicle in ipairs(getAllVehicles()) do
			if doesCharExist(getDriverOfCar(vehicle)) and vehicle ~= my_car then
				local vehicle_pos = { getCarCoordinates(vehicle) }
				local distance = getDistanceBetweenCoords3d(my_pos[1], my_pos[2], my_pos[3], vehicle_pos[1],
					vehicle_pos[2], vehicle_pos[3])
				if distance < closest_distance and vehicle ~= my_car then
					closest_distance = distance
					closest_car = vehicle
				end
			end
		end
		if closest_car then
			local clr1, clr2 = getCarColours(closest_car)
			local CarColorName
			if clr1 == clr2 then
				CarColorName = colorNames[clr1] .. " öâåòà" or ""
			else
				CarColorName = colorNames[clr1] .. '-' .. colorNames[clr2] .. " öâåòà" or ""
			end
			function getVehPlateNumberByCarHandle(car)
				return ' '
			end

			return " " ..
				getNameOfARZVehicleModel(getCarModel(closest_car)) ..
				getVehPlateNumberByCarHandle(closest_car) .. CarColorName
		else
			sampAddChatMessage("[Prison Helper] {ffffff}Íå óäàëîñü ïîëó÷èòü ìîäåëü áëèæàéøåãî òðàíñïîðòà ñ âîäèòåëåì!",
				0x6E6E6E)
			return ''
		end
	end,
	get_form_su = function()
		return form_su
	end,
}

if MONET_DPI_SCALE == nil then
	MONET_DPI_SCALE = 1.0
end

local binder_tags_text = [[
{my_id} - Âàø ID
{my_nick} - Âàø Íèêíåéì
{my_rp_nick} - Âàø Íèêíåéì áåç _
{my_ru_nick} - Âàøå Èìÿ è Ôàìèëèÿ
{my_doklad_nick} - Ïåðâàÿ áóêâà âàøåãî èìåíè è ôàìèëèÿ

{fraction} - Âàøà ôðàêöèÿ
{fraction_rank} - Âàøà ôðàêöèîííàÿ äîëæíîñòü
{fraction_tag} - Òýã âàøåé ôðàêöèè
{post_status} - Ñòàòóñ ïîñòà

{sex} - Äîáàâëÿåò áóêâó "à" åñëè â õåëïåðå óêàçàí æåíñêèé ïîë

{get_time} - Ïîëó÷èòü òåêóùåå âðåìÿ
{get_city} - Ïîëó÷èòü òåêóùèé ãîðîä
{get_square} - Ïîëó÷èòü òåêóùèé êâàäðàò
{get_area} - Ïîëó÷èòü òåêóùèé ðàéîí
{get_storecar_model} - Ïîëó÷èòü ìîäåëü áëèæàéøåãî ê âàì àâòî ñ âîäèòåëåì

{get_nick({arg_id})} - ïîëó÷èòü Íèêíåéì èç àðãóìåíòà ID èãðîêà
{get_rp_nick({arg_id})} - ïîëó÷èòü Íèêíåéì áåç ñèìâîëà _ èç àðãóìåíòà ID èãðîêà
{get_ru_nick({arg_id})} - ïîëó÷èòü Íèêíåéì íà êèðèëèöå èç àðãóìåíòà ID èãðîêà
]]
local binder_tags_text2 = [[
{show_deportament_menu} - Îòêðûòü ìåíþ ðàöèè äåïàðòàìåíòà

{lmenu_vc_vize} - Àâòî-âûäà÷à âèçû Vice City

{give_platoon} - Íàçíà÷èòü âçâîä èãðîêó

{open_mimgui_members} - Îòêðûòü Mimgui Members

{show_rank_menu} - Îòêðûòü ìåíþ âûäà÷è ðàíãîâ
{get_rank} - Ïîëó÷èòü âûáðàííûé ðàíã

{pause} - Ïîñòàâèòü êîìàíäó íà ïàóçó è îæèäàòü íàæàòèÿ
]]

-------------------------------------------- MoonMonet ----------------------------------------------------

local monet_no_errors, moon_monet = pcall(require, 'MoonMonet') -- áåçîïàñíî ïîäêëþ÷àåì áèáëèîòåêó

local message_color = 0x87CEEB
local message_color_hex = '{87CEEB}'

if settings.general.moonmonet_theme_enable and monet_no_errors then
	function rgbToHex(rgb)
		local r = bit.band(bit.rshift(rgb, 16), 0xFF)
		local g = bit.band(bit.rshift(rgb, 8), 0xFF)
		local b = bit.band(rgb, 0xFF)
		local hex = string.format("%02X%02X%02X", r, g, b)
		return hex
	end

	message_color = settings.general.moonmonet_theme_color
	message_color_hex = '{' .. rgbToHex(settings.general.moonmonet_theme_color) .. '}'

	theme[0] = 1
else
	theme[0] = 0
end
local tmp = imgui.ColorConvertU32ToFloat4(settings.general.moonmonet_theme_color)
local mmcolor = imgui.new.float[3](tmp.z, tmp.y, tmp.x)
------------------------------------------- Mimgui Hotkey  -----------------------------------------------------
if not isMonetLoader() then
	hotkey_no_errors, hotkey = pcall(require, 'mimgui_hotkeys')
	if hotkey_no_errors then
		hotkey.Text.NoKey = u8 '< nil >'
		hotkey.Text.WaitForKey = u8 '< wait >'
		MainMenuHotKey = hotkey.RegisterHotKey('Open MainMenu', false, decodeJson(settings.general.bind_mainmenu),
			function()
				if settings.general.use_binds then
					if not MainWindow[0] then
						MainWindow[0] = true
					end
				end
			end)
		FastMenuHotKey = hotkey.RegisterHotKey('Open FastMenu', false, decodeJson(settings.general.bind_fastmenu),
			function()
				if settings.general.use_binds then
					local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
					if valid and doesCharExist(ped) then
						local result, id = sampGetPlayerIdByCharHandle(ped)
						if result and id ~= -1 and not LeaderFastMenu[0] then
							show_fast_menu(id)
						end
					end
				end
			end)
		LeaderFastMenuHotKey = hotkey.RegisterHotKey('Open LeaderFastMenu', false,
			decodeJson(settings.general.bind_leader_fastmenu), function()
				if settings.general.use_binds then
					if tonumber(settings.player_info.fraction_rank_number) >= 9 then
						local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
						if valid and doesCharExist(ped) then
							local result, id = sampGetPlayerIdByCharHandle(ped)
							if result and id ~= -1 and not FastMenu[0] then
								show_leader_fast_menu(id)
							end
						end
					end
				end
			end)
		CommandStopHotKey = hotkey.RegisterHotKey('Stop Command', false, decodeJson(settings.general.bind_command_stop),
			function()
				if settings.general.use_binds then
					sampProcessChatInput('/stop')
				end
			end)
		function getNameKeysFrom(keys)
			local keys = decodeJson(keys)
			local keysStr = {}
			for _, keyId in ipairs(keys) do
				local keyName = require('vkeys').id_to_name(keyId) or ''
				table.insert(keysStr, keyName)
			end
			return tostring(table.concat(keysStr, ' + '))
		end

		addEventHandler('onWindowMessage', function(msg, key, lparam)
			if msg == 641 or msg == 642 or lparam == -1073741809 then hotkey.ActiveKeys = {} end
			if msg == 0x0005 then hotkey.ActiveKeys = {} end
		end)
	end
end
------------------------------------------------- Other --------------------------------------------------------
local PlayerID = nil
local player_id = nil
local check_stats = false
local check_jobs = false
local anti_flood_auto_uval = false
local spawncar_bool = false

local vc_vize_bool = false
local vc_vize_player_id = nil

local clicked = false

local message1
local message2
local message3

local isActiveCommand = false

local debug_mode = false

local command_stop = false
local command_pause = false

local auto_uval_checker = false

local platoon_check = false

local enemy = {}
local enem_show = false

local InfraredVision = false
local NightVision = false

local message_color = 0x87CEEB
local message_color_hex = '{87CEEB}'

local post = imgui.new.char[256]()
------------------------------------------- Main -----------------------------------------------------
function welcome_message()
	if not sampIsLocalPlayerSpawned() then
		sampAddChatMessage('[Prison Helper] {ffffff}Èíèöèàëèçàöèÿ õåëïåðà ïðîøëà óñïåøíî!', message_color)
		sampAddChatMessage(
			'[Prison Helper] {ffffff}Äëÿ ïîëíîé çàãðóçêè õåëïåðà ñíà÷àëî çàñïàâíèòåñü (âîéäèòå íà ñåðâåð)', message_color)
		repeat wait(0) until sampIsLocalPlayerSpawned()
	end
	sampAddChatMessage('[Prison Helper] {ffffff}Çàãðóçêà õåëïåðà ïðîøëà óñïåøíî!', message_color)
	show_cef_notify('info', 'Prison Helper', "Çàãðóçêà õåëïåðà ïðîøëà óñïåøíî!", 3000)
	if hotkey_no_errors and settings.general.bind_mainmenu and settings.general.use_binds then
		sampAddChatMessage(
			'[Prison Helper] {ffffff}×òîá îòêðûòü ìåíþ õåëïåðà íàæìèòå ' ..
			message_color_hex ..
			getNameKeysFrom(settings.general.bind_mainmenu) ..
			' {ffffff}èëè ââåäèòå êîìàíäó ' .. message_color_hex .. '/ph',
			message_color)
	else
		sampAddChatMessage(
			'[Prison Helper] {ffffff}×òîá îòêðûòü ìåíþ õåëïåðà ââåäèòå êîìàíäó ' .. message_color_hex .. '/ph',
			message_color)
	end
end

function registerCommandsFrom(array)
	for _, command in ipairs(array) do
		if command.enable then
			register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
		end
	end
end

function register_command(chat_cmd, cmd_arg, cmd_text, cmd_waiting)
	sampRegisterChatCommand(chat_cmd, function(arg)
		if not isActiveCommand then
			local arg_check = false
			local modifiedText = cmd_text
			if cmd_arg == '{arg}' then
				if arg and arg ~= '' then
					modifiedText = modifiedText:gsub('{arg}', arg or "")
					arg_check = true
				else
					sampAddChatMessage(
						'[Prison Helper] {ffffff}Èñïîëüçóéòå ' .. message_color_hex .. '/' .. chat_cmd .. ' [àðãóìåíò]',
						message_color)
					play_error_sound()
				end
			elseif cmd_arg == '{arg_id}' then
				if isParamSampID(arg) then
					arg = tonumber(arg)
					modifiedText = modifiedText:gsub('%{get_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg) or "")
					modifiedText = modifiedText:gsub('%{get_rp_nick%(%{arg_id%}%)%}',
						sampGetPlayerNickname(arg):gsub('_', ' ') or "")
					modifiedText = modifiedText:gsub('%{get_ru_nick%(%{arg_id%}%)%}',
						TranslateNick(sampGetPlayerNickname(arg)) or "")
					modifiedText = modifiedText:gsub('%{arg_id%}', arg or "")
					arg_check = true
				else
					sampAddChatMessage(
						'[Prison Helper] {ffffff}Èñïîëüçóéòå ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID èãðîêà]',
						message_color)
					play_error_sound()
				end
			elseif cmd_arg == '{arg_id} {arg2}' then
				if arg and arg ~= '' then
					local arg_id, arg2 = arg:match('(%d+) (.+)')
					if isParamSampID(arg_id) and arg2 then
						arg_id = tonumber(arg_id)
						modifiedText = modifiedText:gsub('%{get_nick%(%{arg_id%}%)%}',
							sampGetPlayerNickname(arg_id) or "")
						modifiedText = modifiedText:gsub('%{get_rp_nick%(%{arg_id%}%)%}',
							sampGetPlayerNickname(arg_id):gsub('_', ' ') or "")
						modifiedText = modifiedText:gsub('%{get_ru_nick%(%{arg_id%}%)%}',
							TranslateNick(sampGetPlayerNickname(arg_id)) or "")
						modifiedText = modifiedText:gsub('%{arg_id%}', arg_id or "")
						modifiedText = modifiedText:gsub('%{arg2%}', arg2 or "")
						arg_check = true
					else
						sampAddChatMessage(
							'[Prison Helper] {ffffff}Èñïîëüçóéòå ' ..
							message_color_hex .. '/' .. chat_cmd .. ' [ID èãðîêà] [àðãóìåíò]', message_color)
						play_error_sound()
					end
				else
					sampAddChatMessage(
						'[Prison Helper] {ffffff}Èñïîëüçóéòå ' ..
						message_color_hex .. '/' .. chat_cmd .. ' [ID èãðîêà] [àðãóìåíò]', message_color)
					play_error_sound()
				end
			elseif cmd_arg == '{arg_id} {arg2} {arg3}' then
				if arg and arg ~= '' then
					local arg_id, arg2, arg3 = arg:match('(%d+) (%d) (.+)')
					if isParamSampID(arg_id) and arg2 and arg3 then
						arg_id = tonumber(arg_id)
						modifiedText = modifiedText:gsub('%{get_nick%(%{arg_id%}%)%}',
							sampGetPlayerNickname(arg_id) or "")
						modifiedText = modifiedText:gsub('%{get_rp_nick%(%{arg_id%}%)%}',
							sampGetPlayerNickname(arg_id):gsub('_', ' ') or "")
						modifiedText = modifiedText:gsub('%{get_ru_nick%(%{arg_id%}%)%}',
							TranslateNick(sampGetPlayerNickname(arg_id)) or "")
						modifiedText = modifiedText:gsub('%{arg_id%}', arg_id or "")
						modifiedText = modifiedText:gsub('%{arg2%}', arg2 or "")
						modifiedText = modifiedText:gsub('%{arg3%}', arg3 or "")
						arg_check = true
					else
						sampAddChatMessage(
							'[Prison Helper] {ffffff}Èñïîëüçóéòå ' ..
							message_color_hex .. '/' .. chat_cmd .. ' [ID èãðîêà] [àðãóìåíò] [àðãóìåíò]', message_color)
						play_error_sound()
					end
				else
					sampAddChatMessage(
						'[Prison Helper] {ffffff}Èñïîëüçóéòå ' ..
						message_color_hex .. '/' .. chat_cmd .. ' [ID èãðîêà] [àðãóìåíò] [àðãóìåíò]', message_color)
					play_error_sound()
				end
			elseif cmd_arg == '{arg_id} {arg2} {arg3} {arg4}' then
				if arg and arg ~= '' then
					local arg_id, arg2, arg3, arg4 = arg:match('(%d+) (%d) (.+) (.+)')
					if isParamSampID(arg_id) and arg2 and arg3 and arg4 then
						arg_id = tonumber(arg_id)
						modifiedText = modifiedText:gsub('%{get_nick%(%{arg_id%}%)%}',
							sampGetPlayerNickname(arg_id) or "")
						modifiedText = modifiedText:gsub('%{get_rp_nick%(%{arg_id%}%)%}',
							sampGetPlayerNickname(arg_id):gsub('_', ' ') or "")
						modifiedText = modifiedText:gsub('%{get_ru_nick%(%{arg_id%}%)%}',
							TranslateNick(sampGetPlayerNickname(arg_id)) or "")
						modifiedText = modifiedText:gsub('%{arg_id%}', arg_id or "")
						modifiedText = modifiedText:gsub('%{arg2%}', arg2 or "")
						modifiedText = modifiedText:gsub('%{arg3%}', arg3 or "")
						modifiedText = modifiedText:gsub('%{arg4%}', arg4 or "")
						arg_check = true
					else
						sampAddChatMessage(
							'[Prison Helper] {ffffff}Èñïîëüçóéòå ' ..
							message_color_hex .. '/' .. chat_cmd .. ' [ID èãðîêà] [àðãóìåíò] [àðãóìåíò] [àðãóìåíò]',
							message_color)
						play_error_sound()
					end
				else
					sampAddChatMessage(
						'[Prison Helper] {ffffff}Èñïîëüçóéòå ' ..
						message_color_hex .. '/' .. chat_cmd .. ' [ID èãðîêà] [àðãóìåíò] [àðãóìåíò] [àðãóìåíò]',
						message_color)
					play_error_sound()
				end
			elseif cmd_arg == '' then
				arg_check = true
			end
			if arg_check then
				lua_thread.create(function()
					isActiveCommand = true
					command_pause = false
					if modifiedText:find('&.+&') then
						if isMonetLoader() and settings.general.mobile_stop_button then
							sampAddChatMessage(
								'[Prison Helper] {ffffff}×òîáû îñòàíîâèòü îòûãðîâêó êîìàíäû èñïîëüçóéòå ' ..
								message_color_hex .. '/stop {ffffff}èëè íàæìèòå êíîïêó âíèçó ýêðàíà', message_color)
							CommandStopWindow[0] = true
						elseif not isMonetLoader() and hotkey_no_errors and settings.general.bind_command_stop and settings.general.use_binds then
							sampAddChatMessage(
								'[Prison Helper] {ffffff}×òîáû îñòàíîâèòü îòûãðîâêó êîìàíäû èñïîëüçóéòå ' ..
								message_color_hex ..
								'/stop {ffffff}èëè íàæìèòå ' ..
								message_color_hex .. getNameKeysFrom(settings.general.bind_command_stop), message_color)
						else
							sampAddChatMessage(
								'[Prison Helper] {ffffff}×òîáû îñòàíîâèòü îòûãðîâêó êîìàíäû èñïîëüçóéòå ' ..
								message_color_hex .. '/stop', message_color)
						end
					end
					local lines = {}
					for line in string.gmatch(modifiedText, "[^&]+") do
						table.insert(lines, line)
					end
					for line_index, line in ipairs(lines) do
						if command_stop then
							command_stop = false
							isActiveCommand = false
							sampAddChatMessage(
								'[Prison Helper] {ffffff}Îòûãðîâêà êîìàíäû /' .. chat_cmd .. " óñïåøíî îñòàíîâëåíà!",
								message_color)
							return
						end
						for tag, replacement in pairs(tagReplacements) do
							if line:find("{" .. tag .. "}") then
								local success, result = pcall(string.gsub, line, "{" .. tag .. "}", replacement())
								if success then
									line = result
								end
							end
						end
						if line == '{lmenu_vc_vize}' then
							if cmd_arg == '{arg_id}' then
								vc_vize_player_id = arg
							elseif cmd_arg == '{arg_id} {arg2}' then
								local arg_id, arg2 = arg:match('(%d+) (.+)')
								if arg_id and arg2 and isParamSampID(arg_id) then
									vc_vize_player_id = tonumber(arg_id)
								end
							end
							vc_vize_bool = true
							sampSendChat("/lmenu")
							break
						elseif line == '{give_platoon}' then
							if cmd_arg == '{arg_id}' then
								player_id = arg
							elseif cmd_arg == '{arg_id} {arg2}' then
								local arg_id, arg2 = arg:match('(%d+) (.+)')
								if arg_id and arg2 and isParamSampID(arg_id) then
									player_id = arg_id
								end
							end
							platoon_check = true
							sampSendChat("/platoon")
							break
						elseif line == '{show_rank_menu}' then
							if cmd_arg == '{arg_id}' then
								player_id = arg
							elseif cmd_arg == '{arg_id} {arg2}' then
								local arg_id, arg2 = arg:match('(%d+) (.+)')
								if arg_id and arg2 and isParamSampID(arg_id) then
									player_id = arg_id
								end
							end
							GiveRankMenu[0] = true
							break
						elseif line == "{pause}" then
							sampAddChatMessage(
								'[Prison Helper] {ffffff}Êîìàíäà /' .. chat_cmd .. ' ïîñòàâëåíà íà ïàóçó!', message_color)
							command_pause = true
							CommandPauseWindow[0] = true
							while command_pause do
								wait(0)
							end
							if not command_stop then
								sampAddChatMessage('[Prison Helper] {ffffff}Ïðîäîëæàþ îòûãðîâêó êîìàíäû /' .. chat_cmd,
									message_color)
							end
						else
							if line_index ~= 1 then wait(cmd_waiting * 1000) end
							sampSendChat(line)
							if debug_mode then
								sampAddChatMessage('[Prison Helper DEBUG] {ffffff}SEND: ' .. line,
									message_color)
							end
						end
					end
					isActiveCommand = false
					if isMonetLoader() and settings.general.mobile_stop_button then
						CommandStopWindow[0] = false
					end
				end)
			end
		else
			sampAddChatMessage('[Prison Helper] {ffffff}Äîæäèòåñü çàâåðøåíèÿ îòûãðîâêè ïðåäûäóùåé êîìàíäû!',
				message_color)
			play_error_sound()
		end
	end)
end

function find_and_use_command(cmd, cmd_arg)
	local check = false
	local all_commands = {}

	-- Îáúåäèíÿåì âñå êîìàíäû â îäèí ñïèñîê
	--print("Îáúåäèíåíèå âñåõ êîìàíä â îäèí ñïèñîê...") -- Îòëàäî÷íàÿ èíôîðìàöèÿ
	for _, command in ipairs(commands.commands) do
		--	print("Äîáàâëåíèå êîìàíäû èç commands: " .. command.text) -- Îòëàäî÷íàÿ èíôîðìàöèÿ
		table.insert(all_commands, command)
	end
	for _, command in ipairs(commands.commands_manage) do
		--	print("Äîáàâëåíèå êîìàíäû èç commands_manage: " .. command.text) -- Îòëàäî÷íàÿ èíôîðìàöèÿ
		table.insert(all_commands, command)
	end
	for _, command in ipairs(commands.commands_senior_staff) do
		--	print("Äîáàâëåíèå êîìàíäû èç commands_senior_staff: " .. command.text) -- Îòëàäî÷íàÿ èíôîðìàöèÿ
		table.insert(all_commands, command)
	end

	-- Èùåì êîìàíäó ñðåäè âñåõ
	--print("Ïîèñê êîìàíäû: " .. cmd) -- Îòëàäî÷íàÿ èíôîðìàöèÿ
	for _, command in ipairs(all_commands) do
		if command.enable and command.text:find(cmd) then
			--		print("Íàéäåíà êîìàíäà: " .. command.cmd) -- Îòëàäî÷íàÿ èíôîðìàöèÿ
			check = true
			sampProcessChatInput("/" .. command.cmd .. " " .. cmd_arg)
			return
			--	else
			--		print("Êîìàíäà íå ïîäîøëà: " .. command.text) -- Îòëàäî÷íàÿ èíôîðìàöèÿ
		end
	end

	-- Åñëè êîìàíäà íå íàéäåíà
	if not check then
		--print("Êîìàíäà íå íàéäåíà!") -- Îòëàäî÷íàÿ èíôîðìàöèÿ
		sampAddChatMessage('[Prison Helper] {ffffff}Îøèáêà, íå ìîãó íàéòè áèíä äëÿ âûïîëíåíèÿ ýòîé êîìàíäû!',
			message_color)
		play_error_sound()
		return
	end
end

function initialize_commands()
	-- Ðåãèñòðàöèÿ êîìàíä èç commands.commands
	registerCommandsFrom(commands.commands)
	-- Ðåãèñòðàöèÿ êîìàíä èç commands.commands_manage
	registerCommandsFrom(commands.commands_manage)
	-- Ðåãèñòðàöèÿ âñåõ êîìíàä êîòîðûå åñòü â json äëÿ 5+
	registerCommandsFrom(commands.commands_senior_staff)

	sampRegisterChatCommand("ph", function() MainWindow[0] = not MainWindow[0] end)
	sampRegisterChatCommand("jm", show_fast_menu)
	sampRegisterChatCommand("stop", function()
		if isActiveCommand then
			command_stop = true
		else
			sampAddChatMessage('[Prison Helper] {ffffff}Â äàííûé ìîìåíò íåòó íèêàêîé àêòèâíîé êîìàíäû/îòûãðîâêè!',
				message_color)
			play_error_sound()
		end
	end)
	sampRegisterChatCommand("sum", function(arg)
		if not isActiveCommand then
			if isParamSampID(arg) then
				if #smart_rptp ~= 0 then
					player_id = tonumber(arg)
					SumMenuWindow[0] = true
				else
					sampAddChatMessage(
						'[Prison Helper] {ffffff}Ñíà÷àëî çàãðóçèòå/îòðåäàêòèðóéòå óìíûé ðåãëàìåíò ïîâûøåíèÿ ñðîêà â /ph',
						message_color)
					play_error_sound()
				end
			else
				sampAddChatMessage('[Prison Helper] {ffffff}Èñïîëüçóéòå ' .. message_color_hex .. '/sum [ID èãðîêà]',
					message_color)
				play_error_sound()
			end
		else
			sampAddChatMessage('[Prison Helper] {ffffff}Äîæäèòåñü çàâåðøåíèÿ îòûãðîâêè ïðåäûäóùåé êîìàíäû!',
				message_color)
			play_error_sound()
		end
	end)
	sampRegisterChatCommand("sob", function(arg)
		if not isActiveCommand then
			if isParamSampID(arg) then
				player_id = tonumber(arg)
				SobesMenu[0] = not SobesMenu[0]
			else
				sampAddChatMessage('[Prison Helper] {ffffff}Èñïîëüçóéòå ' .. message_color_hex .. '/sob [ID èãðîêà]',
					message_color)
				play_error_sound()
			end
		else
			sampAddChatMessage('[Prison Helper] {ffffff}Äîæäèòåñü çàâåðøåíèÿ îòûãðîâêè ïðåäûäóùåé êîìàíäû!',
				message_color)
			play_error_sound()
		end
	end)
	sampRegisterChatCommand("debug", function() debug_mode = not debug_mode end)
	sampRegisterChatCommand("mask", function()
		if not isActiveCommand then
			isActiveCommand = true
			if isMonetLoader() and settings.general.mobile_stop_button then
				sampAddChatMessage(
					'[Prison Helper] {ffffff}×òîáû îñòàíîâèòü îòûãðîâêó êîìàíäû èñïîëüçóéòå ' ..
					message_color_hex .. '/stop {ffffff}èëè íàæìèòå êíîïêó âíèçó ýêðàíà', message_color)
				CommandStopWindow[0] = true
			elseif not isMonetLoader() and hotkey_no_errors and settings.general.bind_command_stop and settings.general.use_binds then
				sampAddChatMessage(
					'[Prison Helper] {ffffff}×òîáû îñòàíîâèòü îòûãðîâêó êîìàíäû èñïîëüçóéòå ' ..
					message_color_hex ..
					'/stop {ffffff}èëè íàæìèòå ' ..
					message_color_hex .. getNameKeysFrom(settings.general.bind_command_stop),
					message_color)
			else
				sampAddChatMessage(
					'[Prison Helper] {ffffff}×òîáû îñòàíîâèòü îòûãðîâêó êîìàíäû èñïîëüçóéòå ' ..
					message_color_hex .. '/stop',
					message_color)
			end
			if sampGetPlayerColor(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) == 23486046 then
				lua_thread.create(function()
					sampSendChat('/do Áàëàêëàâà íà ãîëîâå.')
					wait(1200)
					if command_stop then
						command_stop = false
						isActiveCommand = false
						if isMonetLoader() and settings.general.mobile_stop_button then
							CommandStopWindow[0] = false
						end
						sampAddChatMessage('[Prison Helper] {ffffff}Îòûãðîâêà êîìàíäû /mask óñïåøíî îñòàíîâëåíà!',
							message_color)
						return
					end
					sampSendChat('/me ñòÿãèâàåò áàëàêëàâó ñ ãîëîâû è ïðèöåïëÿåò å¸ ê òàêòè÷åêîìó ïîÿñó')
					wait(1200)
					if command_stop then
						command_stop = false
						isActiveCommand = false
						if isMonetLoader() and settings.general.mobile_stop_button then
							CommandStopWindow[0] = false
						end
						sampAddChatMessage('[Prison Helper] {ffffff}Îòûãðîâêà êîìàíäû /mask óñïåøíî îñòàíîâëåíà!',
							message_color)
						return
					end
					sampSendChat('/mask')
					wait(1200)
					if command_stop then
						command_stop = false
						isActiveCommand = false
						if isMonetLoader() and settings.general.mobile_stop_button then
							CommandStopWindow[0] = false
						end
						sampAddChatMessage('[Prison Helper] {ffffff}Îòûãðîâêà êîìàíäû /mask óñïåøíî îñòàíîâëåíà!',
							message_color)
						return
					end
					sampSendChat('/do Áàëàêëàâà ïðèêðåïëåíà ê òàêòè÷åñêîìó ïîÿñó.')
					isActiveCommand = false
				end)
			else
				lua_thread.create(function()
					sampSendChat('/do Áàëàêëàâà ïðèêðåïëåíà ê òàêòè÷åñêîìó ïîÿñó.')
					wait(1200)
					if command_stop then
						command_stop = false
						isActiveCommand = false
						if isMonetLoader() and settings.general.mobile_stop_button then
							CommandStopWindow[0] = false
						end
						sampAddChatMessage('[Prison Helper] {ffffff}Îòûãðîâêà êîìàíäû /mask óñïåøíî îñòàíîâëåíà!',
							message_color)
						return
					end
					sampSendChat('/me äîñòà¸ò áàëàêëàâó è íàòÿãèâàåò å¸ ñåáå íà ãîëîâó')
					wait(1200)
					if command_stop then
						command_stop = false
						isActiveCommand = false
						if isMonetLoader() and settings.general.mobile_stop_button then
							CommandStopWindow[0] = false
						end
						sampAddChatMessage('[Prison Helper] {ffffff}Îòûãðîâêà êîìàíäû /mask óñïåøíî îñòàíîâëåíà!',
							message_color)
						return
					end
					sampSendChat('/mask')
					wait(1200)
					if command_stop then
						command_stop = false
						isActiveCommand = false
						if isMonetLoader() and settings.general.mobile_stop_button then
							CommandStopWindow[0] = false
						end
						sampAddChatMessage('[Prison Helper] {ffffff}Îòûãðîâêà êîìàíäû /mask óñïåøíî îñòàíîâëåíà!',
							message_color)
						return
					end
					sampSendChat('/do Áàëàêëàâà íà ãîëîâå.')
					isActiveCommand = false
				end)
			end
		else
			sampAddChatMessage('[Prison Helper] {ffffff}Äîæäèòåñü çàâåðøåíèÿ îòûãðîâêè ïðåäûäóùåé êîìàíäû!',
				message_color)
			play_error_sound()
		end
	end)
	sampRegisterChatCommand("mb", function(arg)
		if not isActiveCommand then
			if MembersWindow[0] then
				MembersWindow[0] = false
			else
				members_new = {}
				members_check = true
				sampSendChat("/members")
				--MembersWindow[0] = true
			end
		else
			sampAddChatMessage('[Prison Helper] {ffffff}Äîæäèòåñü çàâåðøåíèÿ îòûãðîâêè ïðåäûäóùåé êîìàíäû!',
				message_color)
			play_error_sound()
		end
	end)
	sampRegisterChatCommand("dep", function(arg)
		if not isActiveCommand then
			DeportamentWindow[0] = not DeportamentWindow[0]
		else
			sampAddChatMessage('[Prison Helper] {ffffff}Äîæäèòåñü çàâåðøåíèÿ îòûãðîâêè ïðåäûäóùåé êîìàíäû!',
				message_color)
			play_error_sound()
		end
	end)
	sampRegisterChatCommand("meg", function()
		MegafonWindow[0] = not MegafonWindow[0]
	end)

	if tonumber(settings.player_info.fraction_rank_number) >= 9 then
		sampRegisterChatCommand("jlm", show_leader_fast_menu)
		sampRegisterChatCommand("spcar", function()
			if not isActiveCommand then
				lua_thread.create(function()
					isActiveCommand = true
					if isMonetLoader() and settings.general.mobile_stop_button then
						sampAddChatMessage(
							'[Prison Helper] {ffffff}×òîáû îñòàíîâèòü îòûãðîâêó êîìàíäû èñïîëüçóéòå ' ..
							message_color_hex .. '/stop {ffffff}èëè íàæìèòå êíîïêó âíèçó ýêðàíà', message_color)
						CommandStopWindow[0] = true
					elseif not isMonetLoader() and hotkey_no_errors and settings.general.bind_command_stop and settings.general.use_binds then
						sampAddChatMessage(
							'[Prison Helper] {ffffff}×òîáû îñòàíîâèòü îòûãðîâêó êîìàíäû èñïîëüçóéòå ' ..
							message_color_hex ..
							'/stop {ffffff}èëè íàæìèòå ' ..
							message_color_hex .. getNameKeysFrom(settings.general.bind_command_stop), message_color)
					else
						sampAddChatMessage(
							'[Prison Helper] {ffffff}×òîáû îñòàíîâèòü îòûãðîâêó êîìàíäû èñïîëüçóéòå ' ..
							message_color_hex .. '/stop', message_color)
					end
					sampSendChat("/rb Âíèìàíèå! ×åðåç 15 ñåêóíä áóäåò ñïàâí òðàíñïîðòà îðãàíèçàöèè.")
					wait(1500)
					if command_stop then
						command_stop = false
						isActiveCommand = false
						if isMonetLoader() and settings.general.mobile_stop_button then
							CommandStopWindow[0] = false
						end
						sampAddChatMessage('[Prison Helper] {ffffff}Îòûãðîâêà êîìàíäû /spcar óñïåøíî îñòàíîâëåíà!',
							message_color)
						return
					end
					sampSendChat("/rb Çàéìèòå òðàíñïîðò, èíà÷å îí áóäåò çàñïàâíåí.")
					wait(13500)
					if command_stop then
						command_stop = false
						isActiveCommand = false
						if isMonetLoader() and settings.general.mobile_stop_button then
							CommandStopWindow[0] = false
						end
						sampAddChatMessage('[Prison Helper] {ffffff}Îòûãðîâêà êîìàíäû /spcar óñïåøíî îñòàíîâëåíà!',
							message_color)
						return
					end
					spawncar_bool = true
					sampSendChat("/lmenu")
					isActiveCommand = false
					if isMonetLoader() and settings.general.mobile_stop_button then
						CommandStopWindow[0] = false
					end
				end)
			else
				sampAddChatMessage('[Prison Helper] {ffffff}Äîæäèòåñü çàâåðøåíèÿ îòûãðîâêè ïðåäûäóùåé êîìàíäû!',
					message_color)
			end
		end)
	end
end

local russian_characters = {
	[168] = '¨',
	[184] = '¸',
	[192] = 'À',
	[193] = 'Á',
	[194] = 'Â',
	[195] = 'Ã',
	[196] = 'Ä',
	[197] = 'Å',
	[198] = 'Æ',
	[199] = 'Ç',
	[200] = 'È',
	[201] = 'É',
	[202] = 'Ê',
	[203] = 'Ë',
	[204] = 'Ì',
	[205] = 'Í',
	[206] = 'Î',
	[207] = 'Ï',
	[208] = 'Ð',
	[209] = 'Ñ',
	[210] = 'Ò',
	[211] = 'Ó',
	[212] = 'Ô',
	[213] = 'Õ',
	[214] = 'Ö',
	[215] = '×',
	[216] = 'Ø',
	[217] = 'Ù',
	[218] = 'Ú',
	[219] = 'Û',
	[220] = 'Ü',
	[221] = 'Ý',
	[222] = 'Þ',
	[223] = 'ß',
	[224] = 'à',
	[225] = 'á',
	[226] = 'â',
	[227] = 'ã',
	[228] = 'ä',
	[229] = 'å',
	[230] = 'æ',
	[231] = 'ç',
	[232] = 'è',
	[233] = 'é',
	[234] = 'ê',
	[235] = 'ë',
	[236] = 'ì',
	[237] = 'í',
	[238] = 'î',
	[239] = 'ï',
	[240] = 'ð',
	[241] = 'ñ',
	[242] = 'ò',
	[243] = 'ó',
	[244] = 'ô',
	[245] = 'õ',
	[246] = 'ö',
	[247] = '÷',
	[248] = 'ø',
	[249] = 'ù',
	[250] = 'ú',
	[251] = 'û',
	[252] = 'ü',
	[253] = 'ý',
	[254] = 'þ',
	[255] = 'ÿ',
}
function string.rlower(s)
	s = s:lower()
	local strlen = s:len()
	if strlen == 0 then return s end
	s = s:lower()
	local output = ''
	for i = 1, strlen do
		local ch = s:byte(i)
		if ch >= 192 and ch <= 223 then -- upper russian characters
			output = output .. russian_characters[ch + 32]
		elseif ch == 168 then     -- ¨
			output = output .. russian_characters[184]
		else
			output = output .. string.char(ch)
		end
	end
	return output
end

function string.rupper(s)
	s = s:upper()
	local strlen = s:len()
	if strlen == 0 then return s end
	s = s:upper()
	local output = ''
	for i = 1, strlen do
		local ch = s:byte(i)
		if ch >= 224 and ch <= 255 then -- lower russian characters
			output = output .. russian_characters[ch - 32]
		elseif ch == 184 then     -- ¸
			output = output .. russian_characters[168]
		else
			output = output .. string.char(ch)
		end
	end
	return output
end

-------------------------------------------- Ïåðåâîä÷èê íèêîâ ---------------------------------------------
function TranslateNick(name)
	if name:match('%a+') then
		for k, v in pairs({ ['Giuliano'] = 'Äæóëèàí', ['DeMedici'] = 'ÄåÌåäè÷è', ['ight'] = 'àéò', ['Aleksey'] = 'Àëåêñåé', ['Shved'] = 'Øâåä', ['William'] = 'Âèëüÿì', ['Wright'] = 'Ðàéò', ['ph'] = 'ô', ['Ph'] = 'Ô', ['Ch'] = '×', ['ch'] = '÷', ['Th'] = 'Ò', ['th'] = 'ò', ['Sh'] = 'Ø', ['sh'] = 'ø', ['ea'] = 'è', ['Ae'] = 'Ý', ['ae'] = 'ý', ['size'] = 'ñàéç', ['Jj'] = 'Äæåéäæåé', ['Whi'] = 'Âàé', ['lack'] = 'ëýê', ['whi'] = 'âàé', ['Ck'] = 'Ê', ['ck'] = 'ê', ['Kh'] = 'Õ', ['kh'] = 'õ', ['hn'] = 'í', ['Hen'] = 'Ãåí', ['Zh'] = 'Æ', ['zh'] = 'æ', ['Yu'] = 'Þ', ['yu'] = 'þ', ['Yo'] = '¨', ['yo'] = '¸', ['Cz'] = 'Ö', ['cz'] = 'ö', ['ia'] = 'ÿ', ['ea'] = 'è', ['Ya'] = 'ß', ['ya'] = 'ÿ', ['ove'] = 'àâ', ['ay'] = 'ýé', ['rise'] = 'ðàéç', ['oo'] = 'ó', ['Oo'] = 'Ó', ['Ee'] = 'È', ['ee'] = 'è', ['Un'] = 'Àí', ['un'] = 'àí', ['Ci'] = 'Öè', ['ci'] = 'öè', ['yse'] = 'óç', ['cate'] = 'êåéò', ['eow'] = 'ÿó', ['rown'] = 'ðàóí', ['yev'] = 'óåâ', ['Babe'] = 'Áýéáè', ['Jason'] = 'Äæåéñîí', ['liy'] = 'ëèé', ['ane'] = 'åéí', ['ame'] = 'åéì' }) do
			name = name:gsub(k, v)
		end
		for k, v in pairs({ ['B'] = 'Á', ['Z'] = 'Ç', ['T'] = 'Ò', ['Y'] = 'É', ['P'] = 'Ï', ['J'] = 'Äæ', ['X'] = 'Êñ', ['G'] = 'Ã', ['V'] = 'Â', ['H'] = 'Õ', ['N'] = 'Í', ['E'] = 'Å', ['I'] = 'È', ['D'] = 'Ä', ['O'] = 'Î', ['K'] = 'Ê', ['F'] = 'Ô', ['y`'] = 'û', ['e`'] = 'ý', ['A'] = 'À', ['C'] = 'Ê', ['L'] = 'Ë', ['M'] = 'Ì', ['W'] = 'Â', ['Q'] = 'Ê', ['U'] = 'À', ['R'] = 'Ð', ['S'] = 'Ñ', ['zm'] = 'çüì', ['h'] = 'õ', ['q'] = 'ê', ['y'] = 'è', ['a'] = 'à', ['w'] = 'â', ['b'] = 'á', ['v'] = 'â', ['g'] = 'ã', ['d'] = 'ä', ['e'] = 'å', ['z'] = 'ç', ['i'] = 'è', ['j'] = 'æ', ['k'] = 'ê', ['l'] = 'ë', ['m'] = 'ì', ['n'] = 'í', ['o'] = 'î', ['p'] = 'ï', ['r'] = 'ð', ['s'] = 'ñ', ['t'] = 'ò', ['u'] = 'ó', ['f'] = 'ô', ['x'] = 'x', ['c'] = 'ê', ['``'] = 'ú', ['`'] = 'ü', ['_'] = ' ' }) do
			name = name:gsub(k, v)
		end
		return name
	end
	return name
end

function isParamSampID(id)
	id = tonumber(id)
	if id ~= nil and tostring(id):find('%d') and not tostring(id):find('%D') and string.len(id) >= 1 and string.len(id) <= 3 then
		if id == select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)) then
			return true
		elseif sampIsPlayerConnected(id) then
			return true
		else
			return false
		end
	else
		return false
	end
end

function play_error_sound()
	if not isMonetLoader() and sampIsLocalPlayerSpawned() then
		addOneOffSound(getCharCoordinates(PLAYER_PED), 1149)
	end
	show_cef_notify('error', 'Prison Helper', "Ïðîèçîøëà îøèáêà!", 1500)
end

function show_fast_menu(id)
	if isParamSampID(id) then
		player_id = tonumber(id)
		FastMenu[0] = true
	else
		if isMonetLoader() or settings.general.bind_fastmenu == nil then
			if not FastMenuPlayers[0] then
				sampAddChatMessage('[Prison Helper] {ffffff}Èñïîëüçóéòå ' .. message_color_hex .. '/jm [ID]',
					message_color)
			end
		elseif settings.general.bind_fastmenu and settings.general.use_binds and hotkey_no_errors then
			sampAddChatMessage(
				'[Prison Helper] {ffffff}Èñïîëüçóéòå ' ..
				message_color_hex ..
				'/jm [ID] {ffffff}èëè íàâåäèòåñü íà èãðîêà ÷åðåç ' ..
				message_color_hex .. 'ÏÊÌ + ' .. getNameKeysFrom(settings.general.bind_fastmenu), message_color)
		else
			sampAddChatMessage('[Prison Helper] {ffffff}Èñïîëüçóéòå ' .. message_color_hex .. '/jm [ID]', message_color)
		end
		play_error_sound()
	end
end

function show_leader_fast_menu(id)
	if isParamSampID(id) then
		player_id = tonumber(id)
		LeaderFastMenu[0] = true
	else
		if isMonetLoader() or settings.general.bind_leader_fastmenu == nil then
			sampAddChatMessage('[Prison Helper] {ffffff}Èñïîëüçóéòå ' .. message_color_hex .. '/jlm [ID]', message_color)
		elseif settings.general.bind_leader_fastmenu and settings.general.use_binds and hotkey_no_errors then
			sampAddChatMessage(
				'[Prison Helper] {ffffff}Èñïîëüçóéòå ' ..
				message_color_hex ..
				'/jlm [ID] {ffffff}èëè íàâåäèòåñü íà èãðîêà ÷åðåç ' ..
				message_color_hex .. 'ÏÊÌ + ' .. getNameKeysFrom(settings.general.bind_leader_fastmenu), message_color)
		else
			sampAddChatMessage('[Prison Helper] {ffffff}Èñïîëüçóéòå ' .. message_color_hex .. '/jlm [ID]', message_color)
		end
		play_error_sound()
	end
end

function get_players()
	local myPlayerId = sampGetPlayerIdByCharHandle(PLAYER_PED)
	local myX, myY, myZ = getCharCoordinates(PLAYER_PED)
	local playersInRange = {}
	for temp1, h in pairs(getAllChars()) do
		temp2, id = sampGetPlayerIdByCharHandle(h)
		temp3, m = sampGetPlayerIdByCharHandle(PLAYER_PED)
		id = tonumber(id)
		if id ~= -1 and id ~= m and doesCharExist(h) then
			local x, y, z = getCharCoordinates(h)
			local mx, my, mz = getCharCoordinates(PLAYER_PED)
			local dist = getDistanceBetweenCoords3d(mx, my, mz, x, y, z)
			if dist <= 5 then
				table.insert(playersInRange, id)
			end
		end
	end
	return playersInRange
end

function show_cef_notify(type, title, text, time)
	--[[
	1) type - òèï óâåäîìëåíèÿ ( 'info' / 'error' / 'success' / 'halloween' / '' )
	2) title - òåêñò çàãîëîâêà/íàçâàíèÿ óâåäîìëåíèÿ ( óêàçûâàéòå òåêñò )
	3) text - òåêñò ñîäåðæèìîãî óâåäîìëåíèÿ ( óêàçûâàéòå òåêñò )
	4) time - âðåìÿ îòîáðàæåíèÿ óâåäîìëåíèÿ â ìèëëèñåêóíäàõ ( óêàçûâàéòå ëþáîå ÷èñëî ).
	]]
	local str = ('window.executeEvent(\'event.notify.initialize\', \'["%s", "%s", "%s", "%s"]\');'):format(type, title,
		text, time)
	local bs = raknetNewBitStream()
	raknetBitStreamWriteInt8(bs, 17)
	raknetBitStreamWriteInt32(bs, 0)
	raknetBitStreamWriteInt32(bs, #str)
	raknetBitStreamWriteString(bs, str)
	raknetEmulPacketReceiveBitStream(220, bs)
	raknetDeleteBitStream(bs)
end

function code(code)
	local bs = raknetNewBitStream();
	raknetBitStreamWriteInt8(bs, 17);
	raknetBitStreamWriteInt32(bs, 0);
	raknetBitStreamWriteInt32(bs, string.len(code));
	raknetBitStreamWriteString(bs, code);
	raknetEmulPacketReceiveBitStream(220, bs);
	raknetDeleteBitStream(bs);
end

function openLink(link)
	if isMonetLoader() then
		gta._Z12AND_OpenLinkPKc(link)
	else
		os.execute("explorer " .. link)
	end
end

function sampGetPlayerIdByNickname(nick)
	local id = nil
	nick = tostring(nick)
	local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	if nick == sampGetPlayerNickname(myid) then return myid end
	for i = 0, 999 do
		if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == nick then
			id = i
			break
		end
	end
	return id
end

local weapons = {
	FIST = 0,
	BRASSKNUCKLES = 1,
	GOLFCLUB = 2,
	NIGHTSTICK = 3,
	KNIFE = 4,
	BASEBALLBAT = 5,
	SHOVEL = 6,
	POOLCUE = 7,
	KATANA = 8,
	CHAINSAW = 9,
	PURPLEDILDO = 10,
	WHITEDILDO = 11,
	WHITEVIBRATOR = 12,
	SILVERVIBRATOR = 13,
	FLOWERS = 14,
	CANE = 15,
	GRENADE = 16,
	TEARGAS = 17,
	MOLOTOV = 18,
	COLT45 = 22,
	SILENCED = 23,
	DESERTEAGLE = 24,
	SHOTGUN = 25,
	SAWNOFFSHOTGUN = 26,
	COMBATSHOTGUN = 27,
	UZI = 28,
	MP5 = 29,
	AK47 = 30,
	M4 = 31,
	TEC9 = 32,
	RIFLE = 33,
	SNIPERRIFLE = 34,
	ROCKETLAUNCHER = 35,
	HEATSEEKER = 36,
	FLAMETHROWER = 37,
	MINIGUN = 38,
	SATCHELCHARGE = 39,
	DETONATOR = 40,
	SPRAYCAN = 41,
	FIREEXTINGUISHER = 42,
	CAMERA = 43,
	NIGHTVISION = 44,
	THERMALVISION = 45,
	PARACHUTE = 46,
	WEAPON_VEHICLE = 49,
	HELI = 50,
	BOMB = 51,
	COLLISION = 54,
	-- ARZ CUSTOM GUN
	DEAGLE_STEEL = 71,
	DEAGLE_GOLD = 72,
	GLOCK_GRADIENT = 73,
	DEAGLE_FLAME = 74,
	PYTHON_ROYAL = 75,
	PYTHON_SILVER = 76,
	AK47_ROSES = 77,
	AK47_GOLD = 78,
	M249_GRAFFITI = 79,
	SAIGA_GOLD = 80,
	PPSH_STANDART = 81,
	M249_STANDART = 82,
	SKORP_STANDART = 83,
	AKS74_CAMOUFLAGE1 = 84,
	AK47_CAMOUFLAGE1 = 85,
	REBECCA_SHOTGUN = 86,
	OBJ58_PORTALGUN = 87,
	ICE_SWORD = 88,
	PORTALGUN = 89,
	SOUND_GRENADE = 90,
	EYE_GRENADE = 91,
	MCMILLIAN_TAC50 = 92
}
local id = weapons
weapons.names = {
	[id.FIST] = 'êóëàêè',
	[id.BRASSKNUCKLES] = 'êàñòåòû',
	[id.GOLFCLUB] = 'êëþøêó äëÿ ãîëüôà',
	[id.NIGHTSTICK] = 'äóáèíêó',
	[id.KNIFE] = 'îñòðûé íîæ',
	[id.BASEBALLBAT] = 'áèòó',
	[id.SHOVEL] = 'ëîïàòó',
	[id.POOLCUE] = 'êèé',
	[id.KATANA] = 'êàòàíó',
	[id.CHAINSAW] = 'áåíçîïèëó',
	[id.PURPLEDILDO] = 'äèäëî',
	[id.WHITEDILDO] = 'äèäëî',
	[id.WHITEVIBRATOR] = 'âèáðàòîð',
	[id.SILVERVIBRATOR] = 'âèáðàòîð',
	[id.FLOWERS] = 'áóêåò öâåòîâ',
	[id.CANE] = 'òðîñòü',
	[id.GRENADE] = 'îñêîëî÷íóþ ãðàíàòó',
	[id.TEARGAS] = 'äûìîâóþ ãðàíàòó',
	[id.MOLOTOV] = 'êîêòåéëü Ìîëîòîâà',
	[id.COLT45] = 'ïèñòîëåò Colt45',
	[id.SILENCED] = "ýëåêòðîøîêåð Taser-X26P",
	[id.DESERTEAGLE] = 'ïèñòîëåò Desert Eagle',
	[id.SHOTGUN] = 'äðîáîâèê',
	[id.SAWNOFFSHOTGUN] = 'îáðåç',
	[id.COMBATSHOTGUN] = 'óëó÷øåííûé îáðåç',
	[id.UZI] = 'ïèñòîëåò-ïóëåì¸ò Micro Uzi',
	[id.MP5] = 'ïèñòîëåò-ïóëåì¸ò MP5',
	[id.AK47] = 'àâòîìàò AK-47',
	[id.M4] = 'àâòîìàò M4',
	[id.TEC9] = 'ïèñòîëåò-ïóëåì¸ò Tec-9',
	[id.RIFLE] = 'âèíòîâêó Rifle',
	[id.SNIPERRIFLE] = 'ñíàéïåðñêóþ âèíòîâêó Rifle',
	[id.ROCKETLAUNCHER] = 'ðó÷íóþ ïðîòèâîòàíêîâóþ ðàêåòó',
	[id.HEATSEEKER] = 'óñòðîéñòâî äëÿ çàïóñêà ðàêåò',
	[id.FLAMETHROWER] = 'îãíåì¸ò',
	[id.MINIGUN] = 'ìèíèãàí',
	[id.SATCHELCHARGE] = 'äèíàìèò',
	[id.DETONATOR] = 'äåòîíàòîð',
	[id.SPRAYCAN] = 'ïåðöîâûé áàëàí÷èê',
	[id.FIREEXTINGUISHER] = 'îãíåòóøèòåëü',
	[id.CAMERA] = 'ôîòîàïàðàò Canon',
	[id.NIGHTVISION] = 'ïðèáîð íî÷íîãî âèäåíèÿ',
	[id.THERMALVISION] = 'òåïëîâèçîð',
	[id.PARACHUTE] = 'ðó÷íîé ïàðàøóò',
	[id.WEAPON_VEHICLE] = 'àâòîìîáèëü',
	[id.HELI] = 'ëîïàñòè âåðòîë¸òà',
	[id.BOMB] = 'âçðûâ',
	[id.COLLISION] = 'êîëëèçèþ',
	-- ARZ LAUNCHER GUNS
	[id.DEAGLE_STEEL] = 'ïèñòîëåò Desert Eagle Steel',
	[id.DEAGLE_GOLD] = 'ïèñòîëåò Desert Eagle Gold',
	[id.GLOCK_GRADIENT] = 'ïèñòîëåò Glock',
	[id.DEAGLE_FLAME] = 'ïèñòîëåò Desert Eagle Flame',
	[id.PYTHON_ROYAL] = 'ïèñòîëåò Colt Python',
	[id.PYTHON_SILVER] = 'ïèñòîëåò Colt Python Silver',
	[id.AK47_ROSES] = 'àâòîìàò AK-47 Roses',
	[id.AK47_GOLD] = 'àâòîìàò AK-47 Gold',
	[id.M249_GRAFFITI] = 'ïóëåì¸ò M249 Graffiti',
	[id.SAIGA_GOLD] = 'çîëîòóþ Ñàéãó',
	[id.PPSH_STANDART] = 'ïèñòîëåò-ïóëåì¸ò Standart',
	[id.M249_STANDART] = 'ïóëåì¸ò M249',
	[id.SKORP_STANDART] = 'ïèñòîëåò-ïóëåì¸ò Skorp',
	[id.AKS74_CAMOUFLAGE1] = 'àâòîìàò AKS-74 êàìóôëÿæíûé',
	[id.AK47_CAMOUFLAGE1] = 'àâòîìàò AK-47 êàìóôëÿæíûé',
	[id.REBECCA_SHOTGUN] = 'äðîáîâèê Rebecca',
	[id.OBJ58_PORTALGUN] = 'ïîðòàëüíóþ ïóøêó',
	[id.PORTALGUN] = 'ïîðòàëüíóþ ïóøêó',
	[id.ICE_SWORD] = 'ëåäÿíîé ìå÷',
	[id.SOUND_GRENADE] = 'îãëóøàþùóþ ãðàíàòà',
	[id.EYE_GRENADE] = 'îñëåïëÿþùóþ ãðàíàòà',
	[id.MCMILLIAN_TAC50] = 'ñíàéïåðñêóþ âèíòîâêó McMillian TAC-50'
}
function weapons.get_name(id)
	return weapons.names[id]
end

local gunOn = {}
local gunOff = {}
local gunPartOn = {}
local gunPartOff = {}
local oldGun = nil
local nowGun = 0
local rpTakeNames = { { "èç-çà ñïèíû", "çà ñïèíó" }, { "èç êàðìàíà", "â êàðìàí" }, { "èç ïîÿñà", "íà ïîÿñ" }, { "èç êîáóðû", "â êîáóðó" } }
local rpTake = {
	[2] = 1,
	[5] = 1,
	[6] = 1,
	[7] = 1,
	[8] = 1,
	[9] = 1,
	[14] = 1,
	[15] = 1,
	[25] = 1,
	[26] = 1,
	[27] = 1,
	[28] = 1,
	[29] = 1,
	[30] = 1,
	[31] = 1,
	[32] = 1,
	[33] = 1,
	[34] = 1,
	[35] = 1,
	[36] = 1,
	[37] = 1,
	[38] = 1,
	[42] = 1,
	[77] = 1,
	[78] = 1,
	[78] = 1,
	[79] = 1,
	[80] = 1,
	[81] = 1,
	[82] = 1,
	[83] = 1,
	[84] = 1,
	[85] = 1,
	[86] = 1,
	[92] = 1,
	[87] = 1,
	[88] = 1,
	[49] = 1,
	[50] = 1,
	[51] = 1,
	[54] = 1, -- ñïèíà
	[1] = 2,
	[4] = 2,
	[10] = 2,
	[11] = 2,
	[12] = 2,
	[13] = 2,
	[41] = 2,
	[43] = 2,
	[44] = 2,
	[45] = 2,
	[46] = 2, -- êàðìàí
	[16] = 3,
	[17] = 3,
	[18] = 3,
	[39] = 3,
	[40] = 3,
	[90] = 3,
	[91] = 3,
	[3] = 3, -- ïîÿñ
	[22] = 4,
	[23] = 4,
	[24] = 4,
	[71] = 4,
	[72] = 4,
	[73] = 4,
	[74] = 4,
	[75] = 4,
	[76] = 4,
	[89] = 4, -- êîáóðà
}
for id, weapon in pairs(weapons.names) do
	if (id == 3 or (id > 15 and id < 19) or (id == 90 or id == 91)) then -- 3 16 17 18 (for gunOn)
		if settings.player_info.sex == "Ìóæ÷èíà" or settings.player_info.sex then
			gunOn[id] = 'ñíÿë'
		elseif settings.player_info.sex == "Æåíùèíà" then
			gunOn[id] = 'ñíÿëa'
		end
	else
		if settings.player_info.sex == "Ìóæ÷èíà" or settings.player_info.sex == "Íåèçâåñòíî" then
			gunOn[id] = 'äîñòàë'
		elseif settings.player_info.sex == "Æåíùèíà" then
			gunOn[id] = 'äîñòàëa'
		end
	end
	if (id == 3 or (id > 15 and id < 19) or (id > 38 and id < 41) or (id == 90 or id == 91)) then -- 3 16 17 18 39 40 (for gunOff)
		if settings.player_info.sex == "Ìóæ÷èíà" or settings.player_info.sex == "Íåèçâåñòíî" then
			gunOff[id] = 'ïîâåñèë'
		elseif settings.player_info.sex == "Æåíùèíà" then
			gunOff[id] = 'ïîâåñèëa'
		end
	else
		if settings.player_info.sex == "Ìóæ÷èíà" or settings.player_info.sex == "Íåèçâåñòíî" then
			gunOff[id] = 'óáðàë'
		elseif settings.player_info.sex == "Æåíùèíà" then
			gunOff[id] = 'óáðàëa'
		end
	end
	if id > 0 then
		gunPartOn[id] = rpTakeNames[rpTake[id]][1]
		gunPartOff[id] = rpTakeNames[rpTake[id]][2]
	end
end
function getNameOfARZVehicleModel(id)
	if doesFileExist(path_arzvehicles) then
		if #arzvehicles ~= 0 then
			for _, vehicle in ipairs(arzvehicles) do
				if vehicle.model_id == id then
					return vehicle.name
				end
			end
		else
			sampAddChatMessage(
				'[Prison Helper] {ffffff}Íå óäàëîñü ïîëó÷èòü ìîäåëü òðàíñïîðòà ñ ID ' ..
				id .. "! Ïðè÷èíà: îøèáêà èíèöèàëèçàöèè VehiclesArizona.json", message_color)
			load_arzvehicles()
			return ''
		end
	else
		sampAddChatMessage(
			'[Prison Helper] {ffffff}Íå óäàëîñü ïîëó÷èòü ìîäåëü òðàíñïîðòà ñ ID ' ..
			id .. "! Ïðè÷èíà: îòñóñòâóåò ôàéë VehiclesArizona.json", message_color)
		sampAddChatMessage(
			'[Prison Helper] {ffffff}Ïûòàþñü ñêà÷àòü ôàéë VehiclesArizona.json â ïàïêó ' .. path_arzvehicles,
			message_color)
		download_arzvehicles = true
		downloadFileFromUrlToPath(
			'https://github.com/MTGMODS/lua_scripts/raw/refs/heads/main/justice-helper/VehiclesArizona/VehiclesArizona.json',
			path_arzvehicles)
		return ''
	end
end

function kvadrat()
	local KV = {
		[1] = "À",
		[2] = "Á",
		[3] = "Â",
		[4] = "Ã",
		[5] = "Ä",
		[6] = "Æ",
		[7] = "Ç",
		[8] = "È",
		[9] = "Ê",
		[10] = "Ë",
		[11] = "Ì",
		[12] = "Í",
		[13] = "Î",
		[14] = "Ï",
		[15] = "Ð",
		[16] = "Ñ",
		[17] = "Ò",
		[18] = "Ó",
		[19] = "Ô",
		[20] = "Õ",
		[21] = "Ö",
		[22] = "×",
		[23] = "Ø",
		[24] = "ß",
	}
	local X, Y, Z = getCharCoordinates(playerPed)
	X = math.ceil((X + 3000) / 250)
	Y = math.ceil((Y * -1 + 3000) / 250)
	Y = KV[Y]
	if Y ~= nil then
		local KVX = (Y .. "-" .. X)
		return KVX
	else
		return X
	end
end

function calculateZoneRu(x, y, z)
	local streets = {
		{ "Êëóá Àâèñïà", -2667.810, -302.135, -28.831, -2646.400, -262.320, 71.169 },
		{ "Àýðîïîðò", -1315.420, -405.388, 15.406, -1264.400, -209.543, 25.406 },
		{ "Êëóá Àâèñïà", -2550.040, -355.493, 0.000, -2470.040, -318.493, 39.700 },
		{ "Àýðîïîðò", -1490.330, -209.543, 15.406, -1264.400, -148.388, 25.406 },
		{ "Ãàðñèÿ", -2395.140, -222.589, -5.3, -2354.090, -204.792, 200.000 },
		{ "Øåéäè-Êýáèí", -1632.830, -2263.440, -3.0, -1601.330, -2231.790, 200.000 },
		{ "Âîñòî÷íûé ËÑ", 2381.680, -1494.030, -89.084, 2421.030, -1454.350, 110.916 },
		{ "Ãðóçîâîå äåïî", 1236.630, 1163.410, -89.084, 1277.050, 1203.280, 110.916 },
		{ "Ïåðåñå÷åíèå Áëýêôèëä", 1277.050, 1044.690, -89.084, 1315.350, 1087.630, 110.916 },
		{ "Êëóá Àâèñïà", -2470.040, -355.493, 0.000, -2270.040, -318.493, 46.100 },
		{ "Òåìïë", 1252.330, -926.999, -89.084, 1357.000, -910.170, 110.916 },
		{ "Ñòàíöèÿ Þíèòè", 1692.620, -1971.800, -20.492, 1812.620, -1932.800, 79.508 },
		{ "Ãðóçîâîå äåïî ËÂ", 1315.350, 1044.690, -89.084, 1375.600, 1087.630, 110.916 },
		{ "Ëîñ-Ôëîðåñ", 2581.730, -1454.350, -89.084, 2632.830, -1393.420, 110.916 },
		{ "Êàçèíî", 2437.390, 1858.100, -39.084, 2495.090, 1970.850, 60.916 },
		{ "Õèìçàâîä Èñòåð-Áýé", -1132.820, -787.391, 0.000, -956.476, -768.027, 200.000 },
		{ "Äåëîâîé ðàéîí", 1370.850, -1170.870, -89.084, 1463.900, -1130.850, 110.916 },
		{ "Âîñòî÷íàÿ Ýñïàëàíäà", -1620.300, 1176.520, -4.5, -1580.010, 1274.260, 200.000 },
		{ "Ñòàíöèÿ Ìàðêåò", 787.461, -1410.930, -34.126, 866.009, -1310.210, 65.874 },
		{ "Ñòàíöèÿ Ëèíäåí", 2811.250, 1229.590, -39.594, 2861.250, 1407.590, 60.406 },
		{ "Ïåðåñå÷åíèå Ìîíòãîìåðè", 1582.440, 347.457, 0.000, 1664.620, 401.750, 200.000 },
		{ "Ìîñò Ôðåäåðèê", 2759.250, 296.501, 0.000, 2774.250, 594.757, 200.000 },
		{ "Ñòàíöèÿ Éåëëîó-Áåëë", 1377.480, 2600.430, -21.926, 1492.450, 2687.360, 78.074 },
		{ "Äåëîâîé ðàéîí", 1507.510, -1385.210, 110.916, 1582.550, -1325.310, 335.916 },
		{ "Äæåôôåðñîí", 2185.330, -1210.740, -89.084, 2281.450, -1154.590, 110.916 },
		{ "Ìàëõîëëàíä", 1318.130, -910.170, -89.084, 1357.000, -768.027, 110.916 },
		{ "Êëóá Àâèñïà", -2361.510, -417.199, 0.000, -2270.040, -355.493, 200.000 },
		{ "Äæåôôåðñîí", 1996.910, -1449.670, -89.084, 2056.860, -1350.720, 110.916 },
		{ "Çàïàäàíîå øîññå", 1236.630, 2142.860, -89.084, 1297.470, 2243.230, 110.916 },
		{ "Äæåôôåðñîí", 2124.660, -1494.030, -89.084, 2266.210, -1449.670, 110.916 },
		{ "Ñåâåðíîå øîññå", 1848.400, 2478.490, -89.084, 1938.800, 2553.490, 110.916 },
		{ "Ðîäåî", 422.680, -1570.200, -89.084, 466.223, -1406.050, 110.916 },
		{ "Ñòàíöèÿ Êðýíáåððè", -2007.830, 56.306, 0.000, -1922.000, 224.782, 100.000 },
		{ "Äåëîâîé ðàéîí", 1391.050, -1026.330, -89.084, 1463.900, -926.999, 110.916 },
		{ "Çàïàäíûé Ðýäñýíäñ", 1704.590, 2243.230, -89.084, 1777.390, 2342.830, 110.916 },
		{ "Ìàëåíüêàÿ Ìåêñèêà", 1758.900, -1722.260, -89.084, 1812.620, -1577.590, 110.916 },
		{ "Ïåðåñå÷åíèå Áëýêôèëä", 1375.600, 823.228, -89.084, 1457.390, 919.447, 110.916 },
		{ "Àýðîïîðò", 1974.630, -2394.330, -39.084, 2089.000, -2256.590, 60.916 },
		{ "Áåêîí-Õèëë", -399.633, -1075.520, -1.489, -319.033, -977.516, 198.511 },
		{ "Ðîäåî", 334.503, -1501.950, -89.084, 422.680, -1406.050, 110.916 },
		{ "Ðè÷ìàí", 225.165, -1369.620, -89.084, 334.503, -1292.070, 110.916 },
		{ "Äåëîâîé ðàéîí", 1724.760, -1250.900, -89.084, 1812.620, -1150.870, 110.916 },
		{ "Ñòðèï-êëóá", 2027.400, 1703.230, -89.084, 2137.400, 1783.230, 110.916 },
		{ "Äåëîâîé ðàéîí", 1378.330, -1130.850, -89.084, 1463.900, -1026.330, 110.916 },
		{ "Ïåðåñå÷åíèå Áëýêôèëä", 1197.390, 1044.690, -89.084, 1277.050, 1163.390, 110.916 },
		{ "Êîíôåðåíö Öåíòð", 1073.220, -1842.270, -89.084, 1323.900, -1804.210, 110.916 },
		{ "Ìîíòãîìåðè", 1451.400, 347.457, -6.1, 1582.440, 420.802, 200.000 },
		{ "Äîëèíà Ôîñòåð", -2270.040, -430.276, -1.2, -2178.690, -324.114, 200.000 },
		{ "×àñîâíÿ Áëýêôèëä", 1325.600, 596.349, -89.084, 1375.600, 795.010, 110.916 },
		{ "Àýðîïîðò", 2051.630, -2597.260, -39.084, 2152.450, -2394.330, 60.916 },
		{ "Ìàëõîëëàíä", 1096.470, -910.170, -89.084, 1169.130, -768.027, 110.916 },
		{ "Ïîëå äëÿ ãîëüôà", 1457.460, 2723.230, -89.084, 1534.560, 2863.230, 110.916 },
		{ "Ñòðèï", 2027.400, 1783.230, -89.084, 2162.390, 1863.230, 110.916 },
		{ "Äæåôôåðñîí", 2056.860, -1210.740, -89.084, 2185.330, -1126.320, 110.916 },
		{ "Ìàëõîëëàíä", 952.604, -937.184, -89.084, 1096.470, -860.619, 110.916 },
		{ "Àëüäåà-Ìàëüâàäà", -1372.140, 2498.520, 0.000, -1277.590, 2615.350, 200.000 },
		{ "Ëàñ-Êîëèíàñ", 2126.860, -1126.320, -89.084, 2185.330, -934.489, 110.916 },
		{ "Ëàñ-Êîëèíàñ", 1994.330, -1100.820, -89.084, 2056.860, -920.815, 110.916 },
		{ "Ðè÷ìàí", 647.557, -954.662, -89.084, 768.694, -860.619, 110.916 },
		{ "Ãðóçîâîå äåïî", 1277.050, 1087.630, -89.084, 1375.600, 1203.280, 110.916 },
		{ "Ñåâåðíîå øîññå", 1377.390, 2433.230, -89.084, 1534.560, 2507.230, 110.916 },
		{ "Óèëëîóôèëä", 2201.820, -2095.000, -89.084, 2324.000, -1989.900, 110.916 },
		{ "Ñåâåðíîå øîññå", 1704.590, 2342.830, -89.084, 1848.400, 2433.230, 110.916 },
		{ "Òåìïë", 1252.330, -1130.850, -89.084, 1378.330, -1026.330, 110.916 },
		{ "Ìàëåíüêàÿ Ìåêñèêà", 1701.900, -1842.270, -89.084, 1812.620, -1722.260, 110.916 },
		{ "Êâèíñ", -2411.220, 373.539, 0.000, -2253.540, 458.411, 200.000 },
		{ "Àýðîïîðò", 1515.810, 1586.400, -12.500, 1729.950, 1714.560, 87.500 },
		{ "Ðè÷ìàí", 225.165, -1292.070, -89.084, 466.223, -1235.070, 110.916 },
		{ "Òåìïë", 1252.330, -1026.330, -89.084, 1391.050, -926.999, 110.916 },
		{ "Âîñòî÷íûé ËÑ", 2266.260, -1494.030, -89.084, 2381.680, -1372.040, 110.916 },
		{ "Âîññòî÷íîå øîññå", 2623.180, 943.235, -89.084, 2749.900, 1055.960, 110.916 },
		{ "Óèëëîóôèëä", 2541.700, -1941.400, -89.084, 2703.580, -1852.870, 110.916 },
		{ "Ëàñ-Êîëèíàñ", 2056.860, -1126.320, -89.084, 2126.860, -920.815, 110.916 },
		{ "Âîññòî÷íîå øîññå", 2625.160, 2202.760, -89.084, 2685.160, 2442.550, 110.916 },
		{ "Ðîäåî", 225.165, -1501.950, -89.084, 334.503, -1369.620, 110.916 },
		{ "Ëàñ-Áðóõàñ", -365.167, 2123.010, -3.0, -208.570, 2217.680, 200.000 },
		{ "Âîññòî÷íîå øîññå", 2536.430, 2442.550, -89.084, 2685.160, 2542.550, 110.916 },
		{ "Ðîäåî", 334.503, -1406.050, -89.084, 466.223, -1292.070, 110.916 },
		{ "Âàéíâóä", 647.557, -1227.280, -89.084, 787.461, -1118.280, 110.916 },
		{ "Ðîäåî", 422.680, -1684.650, -89.084, 558.099, -1570.200, 110.916 },
		{ "Ñåâåðíîå øîññå", 2498.210, 2542.550, -89.084, 2685.160, 2626.550, 110.916 },
		{ "Äåëîâîé ðàéîí", 1724.760, -1430.870, -89.084, 1812.620, -1250.900, 110.916 },
		{ "Ðîäåî", 225.165, -1684.650, -89.084, 312.803, -1501.950, 110.916 },
		{ "Äæåôôåðñîí", 2056.860, -1449.670, -89.084, 2266.210, -1372.040, 110.916 },
		{ "Õýìïòîí-Áàðíñ", 603.035, 264.312, 0.000, 761.994, 366.572, 200.000 },
		{ "Òåìïë", 1096.470, -1130.840, -89.084, 1252.330, -1026.330, 110.916 },
		{ "Ìîñò Êèíêåéä", -1087.930, 855.370, -89.084, -961.950, 986.281, 110.916 },
		{ "Ïëÿæ Âåðîíà", 1046.150, -1722.260, -89.084, 1161.520, -1577.590, 110.916 },
		{ "Êîììåð÷åñêèé ðàéîí", 1323.900, -1722.260, -89.084, 1440.900, -1577.590, 110.916 },
		{ "Ìàëõîëëàíä", 1357.000, -926.999, -89.084, 1463.900, -768.027, 110.916 },
		{ "Ðîäåî", 466.223, -1570.200, -89.084, 558.099, -1385.070, 110.916 },
		{ "Ìàëõîëëàíä", 911.802, -860.619, -89.084, 1096.470, -768.027, 110.916 },
		{ "Ìàëõîëëàíä", 768.694, -954.662, -89.084, 952.604, -860.619, 110.916 },
		{ "Þæíîå øîññå", 2377.390, 788.894, -89.084, 2537.390, 897.901, 110.916 },
		{ "Àéäëâóä", 1812.620, -1852.870, -89.084, 1971.660, -1742.310, 110.916 },
		{ "Îêåàíñêèå äîêè", 2089.000, -2394.330, -89.084, 2201.820, -2235.840, 110.916 },
		{ "Êîììåð÷åñêèé ðàéîí", 1370.850, -1577.590, -89.084, 1463.900, -1384.950, 110.916 },
		{ "Ñåâåðíîå øîññå", 2121.400, 2508.230, -89.084, 2237.400, 2663.170, 110.916 },
		{ "Òåìïë", 1096.470, -1026.330, -89.084, 1252.330, -910.170, 110.916 },
		{ "Ãëåí Ïàðê", 1812.620, -1449.670, -89.084, 1996.910, -1350.720, 110.916 },
		{ "Àýðîïîðò Èñòåð-Áýé", -1242.980, -50.096, 0.000, -1213.910, 578.396, 200.000 },
		{ "Ìîñò Ìàðòèí", -222.179, 293.324, 0.000, -122.126, 476.465, 200.000 },
		{ "Ñòðèï", 2106.700, 1863.230, -89.084, 2162.390, 2202.760, 110.916 },
		{ "Óèëëîóôèëä", 2541.700, -2059.230, -89.084, 2703.580, -1941.400, 110.916 },
		{ "Êàíàë Ìàðèíà", 807.922, -1577.590, -89.084, 926.922, -1416.250, 110.916 },
		{ "Àýðîïîðò", 1457.370, 1143.210, -89.084, 1777.400, 1203.280, 110.916 },
		{ "Àéäëâóä", 1812.620, -1742.310, -89.084, 1951.660, -1602.310, 110.916 },
		{ "Âîñòî÷íàÿ Ýñïàëàíäà", -1580.010, 1025.980, -6.1, -1499.890, 1274.260, 200.000 },
		{ "Äåëîâîé ðàéîí", 1370.850, -1384.950, -89.084, 1463.900, -1170.870, 110.916 },
		{ "Ìîñò Ìàêî", 1664.620, 401.750, 0.000, 1785.140, 567.203, 200.000 },
		{ "Ðîäåî", 312.803, -1684.650, -89.084, 422.680, -1501.950, 110.916 },
		{ "Ïëîùàäü Ïåðøèíã", 1440.900, -1722.260, -89.084, 1583.500, -1577.590, 110.916 },
		{ "Ìàëõîëëàíä", 687.802, -860.619, -89.084, 911.802, -768.027, 110.916 },
		{ "Ìîñò Ãàíò", -2741.070, 1490.470, -6.1, -2616.400, 1659.680, 200.000 },
		{ "Ëàñ-Êîëèíàñ", 2185.330, -1154.590, -89.084, 2281.450, -934.489, 110.916 },
		{ "Ìàëõîëëàíä", 1169.130, -910.170, -89.084, 1318.130, -768.027, 110.916 },
		{ "Ñåâåðíîå øîññå", 1938.800, 2508.230, -89.084, 2121.400, 2624.230, 110.916 },
		{ "Êîììåð÷åñêèé ðàéîí", 1667.960, -1577.590, -89.084, 1812.620, -1430.870, 110.916 },
		{ "Ðîäåî", 72.648, -1544.170, -89.084, 225.165, -1404.970, 110.916 },
		{ "Ðîêà-Ýñêàëàíòå", 2536.430, 2202.760, -89.084, 2625.160, 2442.550, 110.916 },
		{ "Ðîäåî", 72.648, -1684.650, -89.084, 225.165, -1544.170, 110.916 },
		{ "Öåíòðàëüíûé Ðûíîê", 952.663, -1310.210, -89.084, 1072.660, -1130.850, 110.916 },
		{ "Ëàñ-Êîëèíàñ", 2632.740, -1135.040, -89.084, 2747.740, -945.035, 110.916 },
		{ "Ìàëõîëëàíä", 861.085, -674.885, -89.084, 1156.550, -600.896, 110.916 },
		{ "Êèíãñ", -2253.540, 373.539, -9.1, -1993.280, 458.411, 200.000 },
		{ "Âîñòî÷íûé Ðýäñýíäñ", 1848.400, 2342.830, -89.084, 2011.940, 2478.490, 110.916 },
		{ "Äåëîâîé ðàéîí", -1580.010, 744.267, -6.1, -1499.890, 1025.980, 200.000 },
		{ "Êîíôåðåíö Öåíòð", 1046.150, -1804.210, -89.084, 1323.900, -1722.260, 110.916 },
		{ "Ðè÷ìàí", 647.557, -1118.280, -89.084, 787.461, -954.662, 110.916 },
		{ "Îóøåí-Ôëýòñ", -2994.490, 277.411, -9.1, -2867.850, 458.411, 200.000 },
		{ "Êîëëåäæ Ãðèíãëàññ", 964.391, 930.890, -89.084, 1166.530, 1044.690, 110.916 },
		{ "Ãëåí Ïàðê", 1812.620, -1100.820, -89.084, 1994.330, -973.380, 110.916 },
		{ "Ãðóçîâîå äåïî", 1375.600, 919.447, -89.084, 1457.370, 1203.280, 110.916 },
		{ "Ðåãüþëàð-Òîì", -405.770, 1712.860, -3.0, -276.719, 1892.750, 200.000 },
		{ "Ïëÿæ Âåðîíà", 1161.520, -1722.260, -89.084, 1323.900, -1577.590, 110.916 },
		{ "Âîñòî÷íûé ËÑ", 2281.450, -1372.040, -89.084, 2381.680, -1135.040, 110.916 },
		{ "Äâîðåö Êàëèãóëû", 2137.400, 1703.230, -89.084, 2437.390, 1783.230, 110.916 },
		{ "Àéäëâóä", 1951.660, -1742.310, -89.084, 2124.660, -1602.310, 110.916 },
		{ "Ïèëèãðèì", 2624.400, 1383.230, -89.084, 2685.160, 1783.230, 110.916 },
		{ "Àéäëâóä", 2124.660, -1742.310, -89.084, 2222.560, -1494.030, 110.916 },
		{ "Êâèíñ", -2533.040, 458.411, 0.000, -2329.310, 578.396, 200.000 },
		{ "Äåëîâîé ðàéîí", -1871.720, 1176.420, -4.5, -1620.300, 1274.260, 200.000 },
		{ "Êîììåð÷åñêèé ðàéîí", 1583.500, -1722.260, -89.084, 1758.900, -1577.590, 110.916 },
		{ "Âîñòî÷íûé ËÑ", 2381.680, -1454.350, -89.084, 2462.130, -1135.040, 110.916 },
		{ "Êàíàë Ìàðèíà", 647.712, -1577.590, -89.084, 807.922, -1416.250, 110.916 },
		{ "Ðè÷ìàí", 72.648, -1404.970, -89.084, 225.165, -1235.070, 110.916 },
		{ "Âàéíâóä", 647.712, -1416.250, -89.084, 787.461, -1227.280, 110.916 },
		{ "Âîñòî÷íûé ËÑ", 2222.560, -1628.530, -89.084, 2421.030, -1494.030, 110.916 },
		{ "Ðîäåî", 558.099, -1684.650, -89.084, 647.522, -1384.930, 110.916 },
		{ "Èñòåðñêèé Òîííåëü", -1709.710, -833.034, -1.5, -1446.010, -730.118, 200.000 },
		{ "Ðîäåî", 466.223, -1385.070, -89.084, 647.522, -1235.070, 110.916 },
		{ "Âîñòî÷íûé Ðýäñýíäñ", 1817.390, 2202.760, -89.084, 2011.940, 2342.830, 110.916 },
		{ "Êàçèíî", 2162.390, 1783.230, -89.084, 2437.390, 1883.230, 110.916 },
		{ "Àéäëâóä", 1971.660, -1852.870, -89.084, 2222.560, -1742.310, 110.916 },
		{ "Ïåðåñå÷åíèå Ìîíòãîìåðè", 1546.650, 208.164, 0.000, 1745.830, 347.457, 200.000 },
		{ "Óèëëîóôèëä", 2089.000, -2235.840, -89.084, 2201.820, -1989.900, 110.916 },
		{ "Òåìïë", 952.663, -1130.840, -89.084, 1096.470, -937.184, 110.916 },
		{ "Ïðèêë-Ïàéí", 1848.400, 2553.490, -89.084, 1938.800, 2863.230, 110.916 },
		{ "Àýðîïîðò", 1400.970, -2669.260, -39.084, 2189.820, -2597.260, 60.916 },
		{ "Ìîñò Ãàðâåð", -1213.910, 950.022, -89.084, -1087.930, 1178.930, 110.916 },
		{ "Ìîñò Ãàðâåð", -1339.890, 828.129, -89.084, -1213.910, 1057.040, 110.916 },
		{ "Ìîñò Êèíêåéä", -1339.890, 599.218, -89.084, -1213.910, 828.129, 110.916 },
		{ "Ìîñò Êèíêåéä", -1213.910, 721.111, -89.084, -1087.930, 950.022, 110.916 },
		{ "Ïëÿæ Âåðîíà", 930.221, -2006.780, -89.084, 1073.220, -1804.210, 110.916 },
		{ "Îáñåðâàòîðèÿ", 1073.220, -2006.780, -89.084, 1249.620, -1842.270, 110.916 },
		{ "Ãîðà Âàéíâóä", 787.461, -1130.840, -89.084, 952.604, -954.662, 110.916 },
		{ "Ãîðà Âàéíâóä", 787.461, -1310.210, -89.084, 952.663, -1130.840, 110.916 },
		{ "Êîììåð÷åñêèé ðàéîí", 1463.900, -1577.590, -89.084, 1667.960, -1430.870, 110.916 },
		{ "Öåíòðàëüíûé Ðûíîê", 787.461, -1416.250, -89.084, 1072.660, -1310.210, 110.916 },
		{ "Çàïàäíûé Ðîêøîð", 2377.390, 596.349, -89.084, 2537.390, 788.894, 110.916 },
		{ "Ñåâåðíîå øîññå", 2237.400, 2542.550, -89.084, 2498.210, 2663.170, 110.916 },
		{ "Âîñòî÷íûé ïëÿæ", 2632.830, -1668.130, -89.084, 2747.740, -1393.420, 110.916 },
		{ "Ìîñò Ôàëëîó", 434.341, 366.572, 0.000, 603.035, 555.680, 200.000 },
		{ "Óèëëîóôèëä", 2089.000, -1989.900, -89.084, 2324.000, -1852.870, 110.916 },
		{ "×àéíàòàóí", -2274.170, 578.396, -7.6, -2078.670, 744.170, 200.000 },
		{ "Ñêàëèñòûé ìàññèâ", -208.570, 2337.180, 0.000, 8.430, 2487.180, 200.000 },
		{ "Îêåàíñêèå äîêè", 2324.000, -2145.100, -89.084, 2703.580, -2059.230, 110.916 },
		{ "Õèìçàâîä Èñòåð-Áýé", -1132.820, -768.027, 0.000, -956.476, -578.118, 200.000 },
		{ "Êàçèíî Âèçàæ", 1817.390, 1703.230, -89.084, 2027.400, 1863.230, 110.916 },
		{ "Îóøåí-Ôëýòñ", -2994.490, -430.276, -1.2, -2831.890, -222.589, 200.000 },
		{ "Ðè÷ìàí", 321.356, -860.619, -89.084, 687.802, -768.027, 110.916 },
		{ "Íåôòÿíîé êîìïëåêñ", 176.581, 1305.450, -3.0, 338.658, 1520.720, 200.000 },
		{ "Ðè÷ìàí", 321.356, -768.027, -89.084, 700.794, -674.885, 110.916 },
		{ "Êàçèíî", 2162.390, 1883.230, -89.084, 2437.390, 2012.180, 110.916 },
		{ "Âîñòî÷íûé ïëÿæ", 2747.740, -1668.130, -89.084, 2959.350, -1498.620, 110.916 },
		{ "Äæåôôåðñîí", 2056.860, -1372.040, -89.084, 2281.450, -1210.740, 110.916 },
		{ "Äåëîâîé ðàéîí", 1463.900, -1290.870, -89.084, 1724.760, -1150.870, 110.916 },
		{ "Äåëîâîé ðàéîí", 1463.900, -1430.870, -89.084, 1724.760, -1290.870, 110.916 },
		{ "Ìîñò Ãàðâåð", -1499.890, 696.442, -179.615, -1339.890, 925.353, 20.385 },
		{ "Þæíîå øîññå", 1457.390, 823.228, -89.084, 2377.390, 863.229, 110.916 },
		{ "Âîñòî÷íûé ËÑ", 2421.030, -1628.530, -89.084, 2632.830, -1454.350, 110.916 },
		{ "Êîëëåäæ Ãðèíãëàññ", 964.391, 1044.690, -89.084, 1197.390, 1203.220, 110.916 },
		{ "Ëàñ-Êîëèíàñ", 2747.740, -1120.040, -89.084, 2959.350, -945.035, 110.916 },
		{ "Ìàëõîëëàíä", 737.573, -768.027, -89.084, 1142.290, -674.885, 110.916 },
		{ "Îêåàíñêèå äîêè", 2201.820, -2730.880, -89.084, 2324.000, -2418.330, 110.916 },
		{ "Âîñòî÷íûé ËÑ", 2462.130, -1454.350, -89.084, 2581.730, -1135.040, 110.916 },
		{ "Ãàíòîí", 2222.560, -1722.330, -89.084, 2632.830, -1628.530, 110.916 },
		{ "Êëóá Àâèñïà", -2831.890, -430.276, -6.1, -2646.400, -222.589, 200.000 },
		{ "Óèëëîóôèëä", 1970.620, -2179.250, -89.084, 2089.000, -1852.870, 110.916 },
		{ "Ñåâåðíàÿ Ýñïëàíàäà", -1982.320, 1274.260, -4.5, -1524.240, 1358.900, 200.000 },
		{ "Êàçèíî Õàé-Ðîëëåð", 1817.390, 1283.230, -89.084, 2027.390, 1469.230, 110.916 },
		{ "Îêåàíñêèå äîêè", 2201.820, -2418.330, -89.084, 2324.000, -2095.000, 110.916 },
		{ "Ìîòåëü", 1823.080, 596.349, -89.084, 1997.220, 823.228, 110.916 },
		{ "Áýéñàéíä-Ìàðèíà", -2353.170, 2275.790, 0.000, -2153.170, 2475.790, 200.000 },
		{ "Êèíãñ", -2329.310, 458.411, -7.6, -1993.280, 578.396, 200.000 },
		{ "Ýëü-Êîðîíà", 1692.620, -2179.250, -89.084, 1812.620, -1842.270, 110.916 },
		{ "×àñîâíÿ Áëýêôèëä", 1375.600, 596.349, -89.084, 1558.090, 823.228, 110.916 },
		{ "Ðîçîâûé ëåáåäü", 1817.390, 1083.230, -89.084, 2027.390, 1283.230, 110.916 },
		{ "Çàïàäíîå øîññå", 1197.390, 1163.390, -89.084, 1236.630, 2243.230, 110.916 },
		{ "Ëîñ-Ôëîðåñ", 2581.730, -1393.420, -89.084, 2747.740, -1135.040, 110.916 },
		{ "Êàçèíî Âèçàæ", 1817.390, 1863.230, -89.084, 2106.700, 2011.830, 110.916 },
		{ "Ïðèêë-Ïàéí", 1938.800, 2624.230, -89.084, 2121.400, 2861.550, 110.916 },
		{ "Ïëÿæ Âåðîíà", 851.449, -1804.210, -89.084, 1046.150, -1577.590, 110.916 },
		{ "Ïåðåñå÷åíèå Ðîáàäà", -1119.010, 1178.930, -89.084, -862.025, 1351.450, 110.916 },
		{ "Ëèíäåí-Ñàéä", 2749.900, 943.235, -89.084, 2923.390, 1198.990, 110.916 },
		{ "Îêåàíñêèå äîêè", 2703.580, -2302.330, -89.084, 2959.350, -2126.900, 110.916 },
		{ "Óèëëîóôèëä", 2324.000, -2059.230, -89.084, 2541.700, -1852.870, 110.916 },
		{ "Êèíãñ", -2411.220, 265.243, -9.1, -1993.280, 373.539, 200.000 },
		{ "Êîììåð÷åñêèé ðàéîí", 1323.900, -1842.270, -89.084, 1701.900, -1722.260, 110.916 },
		{ "Ìàëõîëëàíä", 1269.130, -768.027, -89.084, 1414.070, -452.425, 110.916 },
		{ "Êàíàë Ìàðèíà", 647.712, -1804.210, -89.084, 851.449, -1577.590, 110.916 },
		{ "Áýòòåðè-Ïîéíò", -2741.070, 1268.410, -4.5, -2533.040, 1490.470, 200.000 },
		{ "Êàçèíî 4 Äðàêîíà", 1817.390, 863.232, -89.084, 2027.390, 1083.230, 110.916 },
		{ "Áëýêôèëä", 964.391, 1203.220, -89.084, 1197.390, 1403.220, 110.916 },
		{ "Ñåâåðíîå øîññå", 1534.560, 2433.230, -89.084, 1848.400, 2583.230, 110.916 },
		{ "Ïîëå äëÿ ãîëüôà", 1117.400, 2723.230, -89.084, 1457.460, 2863.230, 110.916 },
		{ "Àéäëâóä", 1812.620, -1602.310, -89.084, 2124.660, -1449.670, 110.916 },
		{ "Çàïàäíûé Ðýäñýíäñ", 1297.470, 2142.860, -89.084, 1777.390, 2243.230, 110.916 },
		{ "Äîýðòè", -2270.040, -324.114, -1.2, -1794.920, -222.589, 200.000 },
		{ "Ôåðìà Õèëëòîï", 967.383, -450.390, -3.0, 1176.780, -217.900, 200.000 },
		{ "Ëàñ-Áàððàíêàñ", -926.130, 1398.730, -3.0, -719.234, 1634.690, 200.000 },
		{ "Êàçèíî Ïèðàòû", 1817.390, 1469.230, -89.084, 2027.400, 1703.230, 110.916 },
		{ "Ñèòè Õîëë", -2867.850, 277.411, -9.1, -2593.440, 458.411, 200.000 },
		{ "Êëóá Àâèñïà", -2646.400, -355.493, 0.000, -2270.040, -222.589, 200.000 },
		{ "Ñòðèï", 2027.400, 863.229, -89.084, 2087.390, 1703.230, 110.916 },
		{ "Õàøáåðè", -2593.440, -222.589, -1.0, -2411.220, 54.722, 200.000 },
		{ "Àýðîïîðò", 1852.000, -2394.330, -89.084, 2089.000, -2179.250, 110.916 },
		{ "Óàéòâóä-Èñòåéòñ", 1098.310, 1726.220, -89.084, 1197.390, 2243.230, 110.916 },
		{ "Âîäîõðàíèëèùå", -789.737, 1659.680, -89.084, -599.505, 1929.410, 110.916 },
		{ "Ýëü-Êîðîíà", 1812.620, -2179.250, -89.084, 1970.620, -1852.870, 110.916 },
		{ "Äåëîâîé ðàéîí", -1700.010, 744.267, -6.1, -1580.010, 1176.520, 200.000 },
		{ "Äîëèíà Ôîñòåð", -2178.690, -1250.970, 0.000, -1794.920, -1115.580, 200.000 },
		{ "Ëàñ-Ïàÿñàäàñ", -354.332, 2580.360, 2.0, -133.625, 2816.820, 200.000 },
		{ "Äîëèíà Îêóëüòàäî", -936.668, 2611.440, 2.0, -715.961, 2847.900, 200.000 },
		{ "Ïåðåñå÷åíèå Áëýêôèëä", 1166.530, 795.010, -89.084, 1375.600, 1044.690, 110.916 },
		{ "Ãàíòîí", 2222.560, -1852.870, -89.084, 2632.830, -1722.330, 110.916 },
		{ "Àýðîïîðò Èñòåð-Áýé", -1213.910, -730.118, 0.000, -1132.820, -50.096, 200.000 },
		{ "Âîñòî÷íûé Ðýäñýíäñ", 1817.390, 2011.830, -89.084, 2106.700, 2202.760, 110.916 },
		{ "Âîñòî÷íàÿ Ýñïàëàíäà", -1499.890, 578.396, -79.615, -1339.890, 1274.260, 20.385 },
		{ "Äâîðåö Êàëèãóëû", 2087.390, 1543.230, -89.084, 2437.390, 1703.230, 110.916 },
		{ "Êàçèíî Ðîÿëü", 2087.390, 1383.230, -89.084, 2437.390, 1543.230, 110.916 },
		{ "Ðè÷ìàí", 72.648, -1235.070, -89.084, 321.356, -1008.150, 110.916 },
		{ "Êàçèíî", 2437.390, 1783.230, -89.084, 2685.160, 2012.180, 110.916 },
		{ "Ìàëõîëëàíä", 1281.130, -452.425, -89.084, 1641.130, -290.913, 110.916 },
		{ "Äåëîâîé ðàéîí", -1982.320, 744.170, -6.1, -1871.720, 1274.260, 200.000 },
		{ "Õàíêè-Ïàíêè-Ïîéíò", 2576.920, 62.158, 0.000, 2759.250, 385.503, 200.000 },
		{ "Âîåííûé ñêëàä òîïëèâà", 2498.210, 2626.550, -89.084, 2749.900, 2861.550, 110.916 },
		{ "Øîññå Ãàððè-Ãîëä", 1777.390, 863.232, -89.084, 1817.390, 2342.830, 110.916 },
		{ "Òîííåëü Áýéñàéä", -2290.190, 2548.290, -89.084, -1950.190, 2723.290, 110.916 },
		{ "Îêåàíñêèå äîêè", 2324.000, -2302.330, -89.084, 2703.580, -2145.100, 110.916 },
		{ "Ðè÷ìàí", 321.356, -1044.070, -89.084, 647.557, -860.619, 110.916 },
		{ "Ïðîìñêëàä Ðýíäîëüôà", 1558.090, 596.349, -89.084, 1823.080, 823.235, 110.916 },
		{ "Âîñòî÷íûé ïëÿæ", 2632.830, -1852.870, -89.084, 2959.350, -1668.130, 110.916 },
		{ "Ôëèíò-Óîòåð", -314.426, -753.874, -89.084, -106.339, -463.073, 110.916 },
		{ "Áëóáåððè", 19.607, -404.136, 3.8, 349.607, -220.137, 200.000 },
		{ "Ñòàíöèÿ Ëèíäåí", 2749.900, 1198.990, -89.084, 2923.390, 1548.990, 110.916 },
		{ "Ãëåí Ïàðê", 1812.620, -1350.720, -89.084, 2056.860, -1100.820, 110.916 },
		{ "Äåëîâîé ðàéîí", -1993.280, 265.243, -9.1, -1794.920, 578.396, 200.000 },
		{ "Çàïàäíûé Ðýäñýíäñ", 1377.390, 2243.230, -89.084, 1704.590, 2433.230, 110.916 },
		{ "Ðè÷ìàí", 321.356, -1235.070, -89.084, 647.522, -1044.070, 110.916 },
		{ "Ìîñò Ãàíò", -2741.450, 1659.680, -6.1, -2616.400, 2175.150, 200.000 },
		{ "Áàð Probe Inn", -90.218, 1286.850, -3.0, 153.859, 1554.120, 200.000 },
		{ "Ïåðåñå÷åíèå Ôëèíò", -187.700, -1596.760, -89.084, 17.063, -1276.600, 110.916 },
		{ "Ëàñ-Êîëèíàñ", 2281.450, -1135.040, -89.084, 2632.740, -945.035, 110.916 },
		{ "Ñîáåëë-Ðåéë-ßðäñ", 2749.900, 1548.990, -89.084, 2923.390, 1937.250, 110.916 },
		{ "Èçóìðóäíûé îñòðîâ", 2011.940, 2202.760, -89.084, 2237.400, 2508.230, 110.916 },
		{ "Ñêàëèñòûé ìàññèâ", -208.570, 2123.010, -7.6, 114.033, 2337.180, 200.000 },
		{ "Ñàíòà-Ôëîðà", -2741.070, 458.411, -7.6, -2533.040, 793.411, 200.000 },
		{ "Ïëàéÿ-äåëü-Ñåâèëü", 2703.580, -2126.900, -89.084, 2959.350, -1852.870, 110.916 },
		{ "Öåíòðàëüíûé Ðûíîê", 926.922, -1577.590, -89.084, 1370.850, -1416.250, 110.916 },
		{ "Êâèíñ", -2593.440, 54.722, 0.000, -2411.220, 458.411, 200.000 },
		{ "Ïåðåñå÷åíèå Ïèëñîí", 1098.390, 2243.230, -89.084, 1377.390, 2507.230, 110.916 },
		{ "Ñïèíèáåä", 2121.400, 2663.170, -89.084, 2498.210, 2861.550, 110.916 },
		{ "Ïèëèãðèì", 2437.390, 1383.230, -89.084, 2624.400, 1783.230, 110.916 },
		{ "Áëýêôèëä", 964.391, 1403.220, -89.084, 1197.390, 1726.220, 110.916 },
		{ "Áîëüøîå óõî", -410.020, 1403.340, -3.0, -137.969, 1681.230, 200.000 },
		{ "Äèëëèìîð", 580.794, -674.885, -9.5, 861.085, -404.790, 200.000 },
		{ "Ýëü-Êåáðàäîñ", -1645.230, 2498.520, 0.000, -1372.140, 2777.850, 200.000 },
		{ "Ñåâåðíàÿ Ýñïëàíàäà", -2533.040, 1358.900, -4.5, -1996.660, 1501.210, 200.000 },
		{ "Àýðîïîðò Èñòåð-Áýé", -1499.890, -50.096, -1.0, -1242.980, 249.904, 200.000 },
		{ "Ðûáàöêàÿ ëàãóíà", 1916.990, -233.323, -100.000, 2131.720, 13.800, 200.000 },
		{ "Ìàëõîëëàíä", 1414.070, -768.027, -89.084, 1667.610, -452.425, 110.916 },
		{ "Âîñòî÷íûé ïëÿæ", 2747.740, -1498.620, -89.084, 2959.350, -1120.040, 110.916 },
		{ "Ñàí-Àíäðåàñ Ñàóíä", 2450.390, 385.503, -100.000, 2759.250, 562.349, 200.000 },
		{ "Òåíèñòûå ðó÷üè", -2030.120, -2174.890, -6.1, -1820.640, -1771.660, 200.000 },
		{ "Öåíòðàëüíûé Ðûíîê", 1072.660, -1416.250, -89.084, 1370.850, -1130.850, 110.916 },
		{ "Çàïàäíûé Ðîêøîð", 1997.220, 596.349, -89.084, 2377.390, 823.228, 110.916 },
		{ "Ïðèêë-Ïàéí", 1534.560, 2583.230, -89.084, 1848.400, 2863.230, 110.916 },
		{ "Áóõòà Ïàñõè", -1794.920, -50.096, -1.04, -1499.890, 249.904, 200.000 },
		{ "Ëèôè-Õîëëîó", -1166.970, -1856.030, 0.000, -815.624, -1602.070, 200.000 },
		{ "Ãðóçîâîå äåïî", 1457.390, 863.229, -89.084, 1777.400, 1143.210, 110.916 },
		{ "Ïðèêë-Ïàéí", 1117.400, 2507.230, -89.084, 1534.560, 2723.230, 110.916 },
		{ "Áëóáåððè", 104.534, -220.137, 2.3, 349.607, 152.236, 200.000 },
		{ "Ñêàëèñòûé ìàññèâ", -464.515, 2217.680, 0.000, -208.570, 2580.360, 200.000 },
		{ "Äåëîâîé ðàéîí", -2078.670, 578.396, -7.6, -1499.890, 744.267, 200.000 },
		{ "Âîñòî÷íûé Ðîêøîð", 2537.390, 676.549, -89.084, 2902.350, 943.235, 110.916 },
		{ "Çàëèâ Ñàí-Ôèåððî", -2616.400, 1501.210, -3.0, -1996.660, 1659.680, 200.000 },
		{ "Ïàðàäèçî", -2741.070, 793.411, -6.1, -2533.040, 1268.410, 200.000 },
		{ "Êàçèíî", 2087.390, 1203.230, -89.084, 2640.400, 1383.230, 110.916 },
		{ "Îëä-Âåíòóðàñ-Ñòðèï", 2162.390, 2012.180, -89.084, 2685.160, 2202.760, 110.916 },
		{ "Äæàíèïåð-Õèëë", -2533.040, 578.396, -7.6, -2274.170, 968.369, 200.000 },
		{ "Äæàíèïåð-Õîëëîó", -2533.040, 968.369, -6.1, -2274.170, 1358.900, 200.000 },
		{ "Ðîêà-Ýñêàëàíòå", 2237.400, 2202.760, -89.084, 2536.430, 2542.550, 110.916 },
		{ "Âîññòî÷íîå øîññå", 2685.160, 1055.960, -89.084, 2749.900, 2626.550, 110.916 },
		{ "Ïëÿæ Âåðîíà", 647.712, -2173.290, -89.084, 930.221, -1804.210, 110.916 },
		{ "Äîëèíà Ôîñòåð", -2178.690, -599.884, -1.2, -1794.920, -324.114, 200.000 },
		{ "Àðêî-äåëü-Îýñòå", -901.129, 2221.860, 0.000, -592.090, 2571.970, 200.000 },
		{ "Óïàâøåå äåðåâî", -792.254, -698.555, -5.3, -452.404, -380.043, 200.000 },
		{ "Ôåðìà", -1209.670, -1317.100, 114.981, -908.161, -787.391, 251.981 },
		{ "Äàìáà Øåðìàíà", -968.772, 1929.410, -3.0, -481.126, 2155.260, 200.000 },
		{ "Ñåâåðíàÿ Ýñïëàíàäà", -1996.660, 1358.900, -4.5, -1524.240, 1592.510, 200.000 },
		{ "Ôèíàíñîâûé ðàéîí", -1871.720, 744.170, -6.1, -1701.300, 1176.420, 300.000 },
		{ "Ãàðñèÿ", -2411.220, -222.589, -1.14, -2173.040, 265.243, 200.000 },
		{ "Ìîíòãîìåðè", 1119.510, 119.526, -3.0, 1451.400, 493.323, 200.000 },
		{ "Êðèê", 2749.900, 1937.250, -89.084, 2921.620, 2669.790, 110.916 },
		{ "Àýðîïîðò", 1249.620, -2394.330, -89.084, 1852.000, -2179.250, 110.916 },
		{ "Ïëÿæ Ñàíòà-Ìàðèÿ", 72.648, -2173.290, -89.084, 342.648, -1684.650, 110.916 },
		{ "Ïåðåñå÷åíèå Ìàëõîëëàíä", 1463.900, -1150.870, -89.084, 1812.620, -768.027, 110.916 },
		{ "Ýéíäæåë-Ïàéí", -2324.940, -2584.290, -6.1, -1964.220, -2212.110, 200.000 },
		{ "Â¸ðäàíò-Ìåäîóñ", 37.032, 2337.180, -3.0, 435.988, 2677.900, 200.000 },
		{ "Îêòàí-Ñïðèíãñ", 338.658, 1228.510, 0.000, 664.308, 1655.050, 200.000 },
		{ "Êàçèíî Êàì-ý-Ëîò", 2087.390, 943.235, -89.084, 2623.180, 1203.230, 110.916 },
		{ "Çàïàäíûé Ðýäñýíäñ", 1236.630, 1883.110, -89.084, 1777.390, 2142.860, 110.916 },
		{ "Ïëÿæ Ñàíòà-Ìàðèÿ", 342.648, -2173.290, -89.084, 647.712, -1684.650, 110.916 },
		{ "Îáñåðâàòîðèÿ", 1249.620, -2179.250, -89.084, 1692.620, -1842.270, 110.916 },
		{ "Àýðîïîðò", 1236.630, 1203.280, -89.084, 1457.370, 1883.110, 110.916 },
		{ "Îêðóã Ôëèíò", -594.191, -1648.550, 0.000, -187.700, -1276.600, 200.000 },
		{ "Îáñåðâàòîðèÿ", 930.221, -2488.420, -89.084, 1249.620, -2006.780, 110.916 },
		{ "Ïàëîìèíî Êðèê", 2160.220, -149.004, 0.000, 2576.920, 228.322, 200.000 },
		{ "Îêåàíñêèå äîêè", 2373.770, -2697.090, -89.084, 2809.220, -2330.460, 110.916 },
		{ "Àýðîïîðò Èñòåð-Áýé", -1213.910, -50.096, -4.5, -947.980, 578.396, 200.000 },
		{ "Óàéòâóä-Èñòåéòñ", 883.308, 1726.220, -89.084, 1098.310, 2507.230, 110.916 },
		{ "Êàëòîí-Õàéòñ", -2274.170, 744.170, -6.1, -1982.320, 1358.900, 200.000 },
		{ "Áóõòà Ïàñõè", -1794.920, 249.904, -9.1, -1242.980, 578.396, 200.000 },
		{ "Çàëèâ ËÑ", -321.744, -2224.430, -89.084, 44.615, -1724.430, 110.916 },
		{ "Äîýðòè", -2173.040, -222.589, -1.0, -1794.920, 265.243, 200.000 },
		{ "Ãîðà ×èëèàä", -2178.690, -2189.910, -47.917, -2030.120, -1771.660, 576.083 },
		{ "Ôîðò-Êàðñîí", -376.233, 826.326, -3.0, 123.717, 1220.440, 200.000 },
		{ "Äîëèíà Ôîñòåð", -2178.690, -1115.580, 0.000, -1794.920, -599.884, 200.000 },
		{ "Îóøåí-Ôëýòñ", -2994.490, -222.589, -1.0, -2593.440, 277.411, 200.000 },
		{ "Ôåðí-Ðèäæ", 508.189, -139.259, 0.000, 1306.660, 119.526, 200.000 },
		{ "Áýéñàéä", -2741.070, 2175.150, 0.000, -2353.170, 2722.790, 200.000 },
		{ "Àýðîïîðò", 1457.370, 1203.280, -89.084, 1777.390, 1883.110, 110.916 },
		{ "Ïîìåñòüå Áëóáåððè", -319.676, -220.137, 0.000, 104.534, 293.324, 200.000 },
		{ "Ïýëèñåéäñ", -2994.490, 458.411, -6.1, -2741.070, 1339.610, 200.000 },
		{ "Íîðò-Ðîê", 2285.370, -768.027, 0.000, 2770.590, -269.740, 200.000 },
		{ "Êàðüåð Õàíòåð", 337.244, 710.840, -115.239, 860.554, 1031.710, 203.761 },
		{ "Àýðîïîðò", 1382.730, -2730.880, -89.084, 2201.820, -2394.330, 110.916 },
		{ "Ìèññèîíåð-Õèëë", -2994.490, -811.276, 0.000, -2178.690, -430.276, 200.000 },
		{ "Çàëèâ ÑÔ", -2616.400, 1659.680, -3.0, -1996.660, 2175.150, 200.000 },
		{ "Çàïðåòíàÿ Çîíà", -91.586, 1655.050, -50.000, 421.234, 2123.010, 250.000 },
		{ "Ãîðà ×èëèàä", -2997.470, -1115.580, -47.917, -2178.690, -971.913, 576.083 },
		{ "Ãîðà ×èëèàä", -2178.690, -1771.660, -47.917, -1936.120, -1250.970, 576.083 },
		{ "Àýðîïîðò Èñòåð-Áýé", -1794.920, -730.118, -3.0, -1213.910, -50.096, 200.000 },
		{ "Ïàíîïòèêóì", -947.980, -304.320, -1.1, -319.676, 327.071, 200.000 },
		{ "Òåíèñòûå ðó÷üè", -1820.640, -2643.680, -8.0, -1226.780, -1771.660, 200.000 },
		{ "Áýê-î-Áåéîíä", -1166.970, -2641.190, 0.000, -321.744, -1856.030, 200.000 },
		{ "Ãîðà ×èëèàä", -2994.490, -2189.910, -47.917, -2178.690, -1115.580, 576.083 },
		{ "Òüåððà Ðîáàäà", -1213.910, 596.349, -242.990, -480.539, 1659.680, 900.000 },
		{ "Îêðóã Ôëèíò", -1213.910, -2892.970, -242.990, 44.615, -768.027, 900.000 },
		{ "Óýòñòîóí", -2997.470, -2892.970, -242.990, -1213.910, -1115.580, 900.000 },
		{ "Ïóñòûííûé îêðóã", -480.539, 596.349, -242.990, 869.461, 2993.870, 900.000 },
		{ "Òüåððà Ðîáàäà", -2997.470, 1659.680, -242.990, -480.539, 2993.870, 900.000 },
		{ "Îêðóæíîñòü ÑÔ", -2997.470, -1115.580, -242.990, -1213.910, 1659.680, 900.000 },
		{ "Îêðóæíîñòü ËÂ", 869.461, 596.349, -242.990, 2997.060, 2993.870, 900.000 },
		{ "Òóìàííûé îêðóã", -1213.910, -768.027, -242.990, 2997.060, 596.349, 900.000 },
		{ "Îêðóæíîñòü ËÑ", 44.615, -2892.970, -242.990, 2997.060, -768.027, 900.000 }
	}
	for i, v in ipairs(streets) do
		if (x >= v[2]) and (y >= v[3]) and (z >= v[4]) and (x <= v[5]) and (y <= v[6]) and (z <= v[7]) then
			return v[1]
		end
	end
	return 'Íåèçâåñòíî'
end

function argbToRgbNormalized(argb)
	local a = math.floor(argb / 0x1000000) % 0x100
	local r = math.floor(argb / 0x10000) % 0x100
	local g = math.floor(argb / 0x100) % 0x100
	local b = argb % 0x100
	local normalizedR = r / 255.0
	local normalizedG = g / 255.0
	local normalizedB = b / 255.0
	return { normalizedR, normalizedG, normalizedB }
end

function getARZServerNumber()
	local server = 0
	local servers = {
		{ name = 'Phoenix',      number = '01' },
		{ name = 'Tucson',       number = '02' },
		{ name = 'Scottdale',    number = '03' },
		{ name = 'Chandler',     number = '04' },
		{ name = 'Brainburg',    number = '05' },
		{ name = 'Saint%-Rose',  number = '06' },
		{ name = 'Mesa',         number = '07' },
		{ name = 'Red%-Rock',    number = '08' },
		{ name = 'Yuma',         number = '09' },
		{ name = 'Surprise',     number = '10' },
		{ name = 'Prescott',     number = '11' },
		{ name = 'Glendale',     number = '12' },
		{ name = 'Kingman',      number = '13' },
		{ name = 'Winslow',      number = '14' },
		{ name = 'Payson',       number = '15' },
		{ name = 'Gilbert',      number = '16' },
		{ name = 'Show Low',     number = '17' },
		{ name = 'Casa%-Grande', number = '18' },
		{ name = 'Page',         number = '19' },
		{ name = 'Sun%-City',    number = '20' },
		{ name = 'Queen%-Creek', number = '21' },
		{ name = 'Sedona',       number = '22' },
		{ name = 'Holiday',      number = '23' },
		{ name = 'Wednesday',    number = '24' },
		{ name = 'Yava',         number = '25' },
		{ name = 'Faraway',      number = '26' },
		{ name = 'Bumble Bee',   number = '27' },
		{ name = 'Christmas',    number = '28' },
		{ name = 'Mirage',       number = '29' },
		{ name = 'Love',         number = '30' },
		{ name = 'Drake',        number = '31' },
		{ name = 'Mobile III',   number = '103' },
		{ name = 'Mobile II',    number = '102' },
		{ name = 'Mobile I',     number = '101' },
		{ name = 'Vice City',    number = '200' },
	}
	for _, s in ipairs(servers) do
		if sampGetCurrentServerName():find(s.name) then
			server = s.number
			break
		end
	end
	return server
end

function getARZServerName(number)
	local server = ''
	local servers = {
		{ name = 'Phoenix',     number = '01' },
		{ name = 'Tucson',      number = '02' },
		{ name = 'Scottdale',   number = '03' },
		{ name = 'Chandler',    number = '04' },
		{ name = 'Brainburg',   number = '05' },
		{ name = 'Saint-Rose',  number = '06' },
		{ name = 'Mesa',        number = '07' },
		{ name = 'Red-Rock',    number = '08' },
		{ name = 'Yuma',        number = '09' },
		{ name = 'Surprise',    number = '10' },
		{ name = 'Prescott',    number = '11' },
		{ name = 'Glendale',    number = '12' },
		{ name = 'Kingman',     number = '13' },
		{ name = 'Winslow',     number = '14' },
		{ name = 'Payson',      number = '15' },
		{ name = 'Gilbert',     number = '16' },
		{ name = 'Show Low',    number = '17' },
		{ name = 'Casa-Grande', number = '18' },
		{ name = 'Page',        number = '19' },
		{ name = 'Sun-City',    number = '20' },
		{ name = 'Queen-Creek', number = '21' },
		{ name = 'Sedona',      number = '22' },
		{ name = 'Holiday',     number = '23' },
		{ name = 'Wednesday',   number = '24' },
		{ name = 'Yava',        number = '25' },
		{ name = 'Faraway',     number = '26' },
		{ name = 'Bumble Bee',  number = '27' },
		{ name = 'Christmas',   number = '28' },
		{ name = 'Mirage',      number = '29' },
		{ name = 'Love',        number = '30' },
		{ name = 'Drake',       number = '31' },
		{ name = 'Mobile III',  number = '103' },
		{ name = 'Mobile II',   number = '102' },
		{ name = 'Mobile I',    number = '101' },
		{ name = 'Vice City',   number = '200' },
	}
	for _, s in ipairs(servers) do
		if tostring(number) == tostring(s.number) then
			server = s.name
			break
		end
	end
	return server
end

function check_update()
	print('[Prison Helper] Íà÷èíàþ ïðîâåðêó íà íàëè÷èå îáíîâëåíèé...')
	sampAddChatMessage('[Prison Helper] {ffffff}Íà÷èíàþ ïðîâåðêó íà íàëè÷èå îáíîâëåíèé...', message_color)
	local path = configDirectory .. "/Update_Info.json"
	os.remove(path)
	local url =
	'https://raw.githubusercontent.com/WF-Helpers-MODS/Prison-Helper/refs/heads/main/Prison%20Helper/Update_Info.json'
	if isMonetLoader() then
		downloadToFile(url, path, function(type, pos, total_size)
			if type == "finished" then
				local updateInfo = readJsonFile(path)
				if updateInfo then
					local uVer = updateInfo.current_version
					local uUrl = updateInfo.update_url
					local uText = updateInfo.update_info
					print("[Prison Helper] Òåêóùàÿ óñòàíîâëåííàÿ âåðñèÿ:", thisScript().version)
					print("[Prison Helper] Òåêóùàÿ âåðñèÿ â îáëàêå:", uVer)
					if thisScript().version ~= uVer then
						print('[Prison Helper] Äîñòóïíî îáíîâëåíèå!')
						sampAddChatMessage('[Prison Helper] {ffffff}Äîñòóïíî îáíîâëåíèå!', message_color)
						need_update_helper = true
						updateUrl = uUrl
						updateVer = uVer
						updateInfoText = uText
						UpdateWindow[0] = true
					else
						print('[Prison Helper] Îáíîâëåíèå íå íóæíî!')
						sampAddChatMessage('[Prison Helper] {ffffff}Îáíîâëåíèå íå íóæíî, ó âàñ àêòóàëüíàÿ âåðñèÿ!',
							message_color)
					end
				end
			end
		end)
	else
		downloadUrlToFile(url, path, function(id, status)
			if status == 6 then -- ENDDOWNLOADDATA
				local updateInfo = readJsonFile(path)
				if updateInfo then
					local uVer = updateInfo.current_version
					local uUrl = updateInfo.update_url
					local uText = updateInfo.update_info
					print("[Prison Helper] Òåêóùàÿ óñòàíîâëåííàÿ âåðñèÿ:", thisScript().version)
					print("[Prison Helper] Òåêóùàÿ âåðñèÿ â îáëàêå:", uVer)
					if thisScript().version ~= uVer then
						print('[Prison Helper] Äîñòóïíî îáíîâëåíèå!')
						sampAddChatMessage('[Prison Helper] {ffffff}Äîñòóïíî îáíîâëåíèå!', message_color)
						need_update_helper = true
						updateUrl = uUrl
						updateVer = uVer
						updateInfoText = uText
						UpdateWindow[0] = true
					else
						print('[Prison Helper] Îáíîâëåíèå íå íóæíî!')
						sampAddChatMessage('[Prison Helper] {ffffff}Îáíîâëåíèå íå íóæíî, ó âàñ àêòóàëüíàÿ âåðñèÿ!',
							message_color)
					end
				end
			end
		end)
	end
	function readJsonFile(filePath)
		if not doesFileExist(filePath) then
			print("[Prison Helper] Îøèáêà: Ôàéë " .. filePath .. " íå ñóùåñòâóåò")
			return nil
		end
		local file = io.open(filePath, "r")
		local content = file:read("*a")
		file:close()
		local jsonData = decodeJson(content)
		if not jsonData then
			print("[Prison Helper] Îøèáêà: Íåâåðíûé ôîðìàò JSON â ôàéëå " .. filePath)
			return nil
		end
		return jsonData
	end
end

function downloadToFile(url, path, callback, progressInterval)
	callback = callback or function() end
	progressInterval = progressInterval or 0.1

	local effil = require("effil")
	local progressChannel = effil.channel(0)

	local runner = effil.thread(function(url, path)
		local http = require("socket.http")
		local ltn = require("ltn12")

		local r, c, h = http.request({
			method = "HEAD",
			url = url,
		})

		if c ~= 200 then
			return false, c
		end
		local total_size = h["content-length"]

		local f = io.open(path, "wb")
		if not f then
			return false, "failed to open file"
		end
		local success, res, status_code = pcall(http.request, {
			method = "GET",
			url = url,
			sink = function(chunk, err)
				local clock = os.clock()
				if chunk and not lastProgress or (clock - lastProgress) >= progressInterval then
					progressChannel:push("downloading", f:seek("end"), total_size)
					lastProgress = os.clock()
				elseif err then
					progressChannel:push("error", err)
				end

				return ltn.sink.file(f)(chunk, err)
			end,
		})

		if not success then
			return false, res
		end

		if not res then
			return false, status_code
		end

		return true, total_size
	end)
	local thread = runner(url, path)

	local function checkStatus()
		local tstatus = thread:status()
		if tstatus == "failed" or tstatus == "completed" then
			local result, value = thread:get()

			if result then
				callback("finished", value)
			else
				callback("error", value)
			end

			return true
		end
	end

	lua_thread.create(function()
		if checkStatus() then
			return
		end

		while thread:status() == "running" do
			if progressChannel:size() > 0 then
				local type, pos, total_size = progressChannel:pop()
				callback(type, pos, total_size)
			end
			wait(0)
		end

		checkStatus()
	end)
end

function downloadFileFromUrlToPath(url, path)
	print('[Prison Helper] Íà÷èíàþ ñêà÷èâàíèå ôàéëà â ' .. path)
	if isMonetLoader() then
		downloadToFile(url, path, function(type, pos, total_size)
			if type == "downloading" then
			elseif type == "finished" then
				if download_helper then
					sampAddChatMessage(
						'[Prison Helper] {ffffff}Çàãðóçêà íîâîé âåðñèè õåëïåðà çàâåðøåíà óñïåøíî! Ïåðåçàãðóçêà..',
						message_color)
					reload_script = true
					thisScript():unload()
				elseif download_smartRPTP then
					sampAddChatMessage(
						'[Prison Helper] {ffffff}Çàãðóçêà óìíîãî ðåãëàìåíòà ïîâûøåíèÿ ñðîêà äëÿ ñåðâåðà ' ..
						getARZServerName(getARZServerNumber()) .. '[' .. getARZServerNumber() .. '] çàâåðøåíà óñïåøíî!',
						message_color)
					download_smartRPTP = false
					load_smart_rptp()
				elseif download_arzvehicles then
					sampAddChatMessage(
						'[Prison Helper] {ffffff}Çàãðóçêà ñïèñêà ìîäåëåé êàñòîì êàðîâ àðèçîíû çàâåðåøåíà óñïåøíî!',
						message_color)
					download_arzvehicles = false
					load_arzvehicles()
				end
			elseif type == "error" then
				sampAddChatMessage('[Prison Helper] {ffffff}Îøèáêà çàãðóçêè: ' .. pos, message_color)
			end
		end)
	else
		downloadUrlToFile(url, path, function(id, status)
			if status == 6 then -- ENDDOWNLOADDATA
				if download_helper then
					sampAddChatMessage(
						'[Prison Helper] {ffffff}Çàãðóçêà íîâîé âåðñèè õåëïåðà çàâåðøåíà óñïåøíî! Ïåðåçàãðóçêà..',
						message_color)
					reload_script = true
					thisScript():unload()
				elseif download_smartRPTP then
					sampAddChatMessage(
						'[Prison Helper] {ffffff}Çàãðóçêà óìíîãî ðåãëàìåíòà ïîâûøåíèÿ ñðîêà äëÿ ñåðâåðà ' ..
						getARZServerName(getARZServerNumber()) .. '[' .. getARZServerNumber() .. '] çàâåðøåíà óñïåøíî!',
						message_color)
					download_smartRPTP = false
					load_smart_rptp()
				elseif download_arzvehicles then
					sampAddChatMessage(
						'[Prison Helper] {ffffff}Çàãðóçêà ñïèñêà ìîäåëåé êàñòîì êàðîâ àðèçîíû çàâåðåøåíà óñïåøíî!',
						message_color)
					download_arzvehicles = false
					load_arzvehicles()
				end
			end
		end)
	end
end

function sampev.onShowTextDraw(id, data)
	if data.text:find('~n~~n~~n~~n~~n~~n~~n~~n~~w~Style: ~r~Sport!') then
		sampAddChatMessage('[Prison Helper] {ffffff}Àêòèâèðîâàí ðåæèì åçäû Sport!', message_color)
		return false
	end
	if data.text:find('~n~~n~~n~~n~~n~~n~~n~~n~~w~Style: ~g~Comfort!') then
		sampAddChatMessage('[Prison Helper] {ffffff}Àêòèâèðîâàí ðåæèì åçäû Comfort!', message_color)
		return false
	end
end

function sampev.onDisplayGameText(style, time, text)
	if text:find('~n~~n~~n~~n~~n~~n~~n~~n~~w~Style: ~r~Sport!') then
		sampAddChatMessage('[Prison Helper] {ffffff}Àêòèâèðîâàí ðåæèì åçäû Sport!', message_color)
		return false
	end
	if text:find('~n~~n~~n~~n~~n~~n~~n~~n~~w~Style: ~g~Comfort!') then
		sampAddChatMessage('[Prison Helper] {ffffff}Àêòèâèðîâàí ðåæèì åçäû Comfort!', message_color)
		return false
	end
end

function sampev.onSendTakeDamage(playerId, damage, weapon)
	if playerId ~= 65535 then
		playerId2 = playerId1
		playerId1 = playerId
		if isParamSampID(playerId) and playerId1 ~= playerId2 and tonumber(playerId) ~= 0 and weapon then
			local weapon_name = weapons.get_name(weapon)
			if weapon_name then
				sampAddChatMessage(
					'[Prison Helper] {ffffff}Èãðîê ' ..
					sampGetPlayerNickname(playerId) ..
					'[' .. playerId .. '] íàïàë íà âàñ èñïîëüçóÿ ' .. weapon_name .. '.',
					message_color)
			end
		end
	end
end

function sampev.onServerMessage(color, text)
	if (settings.general.auto_uval and tonumber(settings.player_info.fraction_rank_number) >= 9) then
		if text:find("%[(.-)%] (.-) (.-)%[(.-)%]: (.+)") and color == 766526463 then -- /f /fb èëè /r /rb áåç òýãà
			local tag, rank, name, playerID, message = string.match(text, "%[(.-)%] (.+) (.-)%[(.-)%]: (.+)")
			lua_thread.create(function()
				wait(50)
				if ((not message:find(" îòïðàâüòå (.+) +++ ÷òîáû óâîëèòñÿ ÏÑÆ!") and not message:find("Ñîòðóäíèê (.+) áûë óâîëåí ïî ïðè÷èíå(.+)")) and (message:rupper():find("ÏÑÆ") or message:rupper():find("ÏÑÆ.") or message:rupper():find("ÓÂÎËÜÒÅ") or message:find("ÓÂÎËÜÒÅ.") or message:rupper():find("ÓÂÀË") or message:rupper():find("ÓÂÀË."))) then
					message3 = message2
					message2 = message1
					message1 = text
					PlayerID = playerID
					sampAddChatMessage(text, 0xFF2DB043)
					if message3 == text then
						auto_uval_checker = true
						sampSendChat('/fmute ' .. playerID .. ' 1 [AutoUval] Îæèäàéòå...')
					elseif tag == "R" then
						sampSendChat("/rb " .. name .. " îòïðàâüòå /rb +++ ÷òîáû óâîëèòñÿ ÏÑÆ!")
					elseif tag == "F" then
						sampSendChat("/fb " .. name .. " îòïðàâüòå /fb +++ ÷òîáû óâîëèòñÿ ÏÑÆ!")
					end
				elseif ((message == "(( +++ ))" or message == "(( +++. ))") and (PlayerID == playerID)) then
					sampAddChatMessage(text, 0xFF2DB043)
					auto_uval_checker = true
					sampSendChat('/fmute ' .. PlayerID .. ' 1 [AutoUval] Îæèäàéòå...')
				end
			end)
		elseif text:find("%[(.-)%] %[(.-)%] (.+) (.-)%[(.-)%]: (.+)") and color == 766526463 then -- /r èëè /f ñ òýãîì
			local tag, tag2, rank, name, playerID, message = string.match(text,
				"%[(.-)%] %[(.-)%] (.+) (.-)%[(.-)%]: (.+)")
			lua_thread.create(function()
				wait(50)
				if not message:find(" îòïðàâüòå (.+) +++ ÷òîáû óâîëèòñÿ ÏÑÆ!") and not message:find("Ñîòðóäíèê (.+) áûë óâîëåí ïî ïðè÷èíå(.+)") and message:rupper():find("ÏÑÆ") or message:rupper():find("ÏÑÆ.") or message:rupper():find("ÓÂÎËÜÒÅ") or message:find("ÓÂÎËÜÒÅ.") or message:rupper():find("ÓÂÀË") or message:rupper():find("ÓÂÀË.") then
					message3 = message2
					message2 = message1
					message1 = text
					PlayerID = playerID
					sampAddChatMessage(text, 0xFF2DB043)
					if message3 == text then
						auto_uval_checker = true
						sampSendChat('/fmute ' .. playerID .. ' 1 [AutoUval] Îæèäàéòå...')
					elseif tag == "R" then
						sampSendChat("/rb " .. name .. "[" .. playerID .. "], îòïðàâüòå /rb +++ ÷òîáû óâîëèòñÿ ÏÑÆ!")
					elseif tag == "F" then
						sampSendChat("/fb " .. name .. "[" .. playerID .. "], îòïðàâüòå /fb +++ ÷òîáû óâîëèòñÿ ÏÑÆ!")
					end
				elseif ((message == "(( +++ ))" or message == "(( +++. ))") and (PlayerID == playerID)) then
					auto_uval_checker = true
					sampSendChat('/fmute ' .. playerID .. ' 1 [AutoUval] Îæèäàéòå...')
				end
			end)
		end

		if text:find("(.+) çàãëóøèë%(à%) èãðîêà (.+) íà 1 ìèíóò. Ïðè÷èíà: %[AutoUval%] Îæèäàéòå...") and auto_uval_checker then
			local Name, PlayerName, Time, Reason = text:match(
				"(.+) çàãëóøèë%(à%) èãðîêà (.+) íà (%d+) ìèíóò. Ïðè÷èíà: (.+)")
			local MyName = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
			lua_thread.create(function()
				wait(50)
				if Name == MyName then
					sampAddChatMessage(
						'[Prison Helper] {ffffff}Óâîëüíÿþ èãðîêà ' .. sampGetPlayerNickname(PlayerID) .. '!',
						message_color)
					auto_uval_checker = false
					temp = PlayerID .. ' ÏÑÆ'
					find_and_use_command("/uninvite {arg_id} {arg2}", temp)
				else
					sampAddChatMessage(
						'[Prison Helper] {ffffff}Äðóãîé çàìåñòèòåëü/ëèäåð óæå óâîëüíÿåò èãðîêà ' ..
						sampGetPlayerNickname(PlayerID) .. '!', message_color)
					auto_uval_checker = false
				end
			end)
		end
	end
	if (text:find("{FFFFFF}(.-) ïðèíÿë âàøå ïðåäëîæåíèå âñòóïèòü ê âàì â îðãàíèçàöèþ.") and tonumber(settings.player_info.fraction_rank_number) >= 9) then
		sampAddChatMessage(text, 0xFF2DB043)
		local PlayerName = text:match("{FFFFFF}(.-) ïðèíÿë âàøå ïðåäëîæåíèå âñòóïèòü ê âàì â îðãàíèçàöèþ.")
		sampSendChat("/r " .. TranslateNick(PlayerName) .. " - íàø íîâûé ñîòðóäíèê!")
	end
	if (text:find("Ó (.+) îòñóòñòâóåò òðóäîâàÿ êíèæêà. Âû ìîæåòå âûäàòü åìó êíèæêó ñ ïîìîùüþ êîìàíäû /givewbook") and tonumber(settings.player_info.fraction_rank_number) >= 6) then
		local nick = text:match(
			"Ó (.+) îòñóòñòâóåò òðóäîâàÿ êíèæêà. Âû ìîæåòå âûäàòü åìó êíèæêó ñ ïîìîùüþ êîìàíäû /givewbook")
		local cmd = '/givewbook'
		for _, command in ipairs(commands.commands_manage) do
			if command.enable and command.text:find('/givewbook {arg_id}') then
				cmd = '/' .. command.cmd
			end
		end
		sampAddChatMessage(
			'[Prison Helper] {ffffff}Ó èãðîêà ' ..
			nick ..
			' íåòó òðóäîâîé êíèæêè, âûäàéòå å¸ èñïîëüçóÿ ' ..
			message_color_hex .. cmd .. ' ' .. sampGetPlayerIdByNickname(nick), message_color)
		return false
	end
	if (settings.general.auto_doklad) then
		if text:find('Âû óñïåøíî íà÷àëè ïàòðóëèðîâàíèå {ff6666}ïîñòà: (.+){ffffff}.') then
			local postnazvanie = text:match('Âû óñïåøíî íà÷àëè ïàòðóëèðîâàíèå {ff6666}ïîñòà: (.+){ffffff}.')
			imgui.StrCopy(post, postnazvanie)
		end

		if text:find('%[Ïàòðóëèðîâàíèå%] {ffffff}Äîëîæèòå î {ff6666}íà÷àëå âûïîëíåíèÿ ìàðøðóòà â ðàöèþ %(/r%){ffffff}, ÷òîáû ïðîäîëæèòü.') then
			local postStr = ffi.string(post)
			sampSendChat('/r Äîêëàäûâàåò ' ..
				settings.player_info.fraction_rank ..
				': ' ..
				settings.player_info.name_surname .. '. Ïîñò: ' .. postStr ..
				'. Ñîñòîÿíèå: ' .. settings.general.post_status .. '')
		end
	end
	if (settings.general.auto_mask) then
		if text:find('Âðåìÿ äåéñòâèÿ ìàñêè èñòåêëî, âàì ïðèøëîñü åå âûáðîñèòü.') then
			sampAddChatMessage('[Prison Helper] {ffffff}Âðåìÿ äåéñòâèÿ ìàñêè èñòåêëî, àâòîìàòè÷åñêè íàäåâàþ íîâóþ',
				message_color)
			sampSendChat("/mask")
			return false
		elseif (text:find('Âðåìÿ äåéñòâèÿ ìàñêè (%d+) ìèíóò, ïîñëå èñõîäà âðåìåíè åå ïðèä¸òñÿ âûáðîñèòü.')) then
			local min = text:match('Âðåìÿ äåéñòâèÿ ìàñêè (%d+) ìèíóò, ïîñëå èñõîäà âðåìåíè åå ïðèä¸òñÿ âûáðîñèòü.')
			sampAddChatMessage(
				'[Prison Helper] {ffffff}Âðåìÿ äåéñòâèÿ ìàñêè ' ..
				min .. ' ìèíóò, ïîñëå èñõîäà âðåìåíè àâòîìàòè÷åñêè íàäåâó íîâóþ!', message_color)
			return false
		end
	end
	if text:find("1%.{6495ED} 111 %- {FFFFFF}Ïðîâåðèòü áàëàíñ òåëåôîíà") or
		text:find("2%.{6495ED} 060 %- {FFFFFF}Ñëóæáà òî÷íîãî âðåìåíè") or
		text:find("3%.{6495ED} 911 %- {FFFFFF}Ïîëèöåéñêèé ó÷àñòîê") or
		text:find("4%.{6495ED} 912 %- {FFFFFF}Ñêîðàÿ ïîìîùü") or
		text:find("5%.{6495ED} 914 %- {FFFFFF}Òàêñè") or
		text:find("5%.{6495ED} 914 %- {FFFFFF}Ìåõàíèê") or
		text:find("6%.{6495ED} 8828 %- {FFFFFF}Ñïðàâî÷íàÿ öåíòðàëüíîãî áàíêà") or
		text:find("7%.{6495ED} 997 %- {FFFFFF}Ñëóæáà ïî âîïðîñàì æèëîé íåäâèæèìîñòè %(óçíàòü âëàäåëüöà äîìà%)") then
		return false
	end
	if text:find("Íîìåðà òåëåôîíîâ ãîñóäàðñòâåííûõ ñëóæá:") then
		sampAddChatMessage('[Prison Helper] {ffffff}Íîìåðà òåëåôîíîâ ãîñóäàðñòâåííûõ ñëóæá:', message_color)
		sampAddChatMessage(
			'[Prison Helper] {ffffff}111 Áàëàíñ | 60 Âðåìÿ | 911 ÌÞ | 912 ÌÇ | 913 Òàêñè | 914 Ìåõè | 8828 Áàíê | 997 Äîìà',
			message_color)
		return false
	end
	if text:find('{FFFFFF}Âðåìÿ äåéñòâèÿ ìàñêè 20 ìèíóò, ïîñëå èñõîäà âðåìåíè åå ïðèä¸òñÿ âûáðîñèòü.') then
		sampAddChatMessage(
			'[Prison Helper] {ffffff}Âðåìÿ äåéñòâèÿ ìàñêè 20 ìèíóò, ïîñëå èñõîäà âðåìåíè àâòîìàòè÷åñêè íàäåíó íîâóþ',
			message_color)
		return false
	end
	if text:find('Âðåìÿ äåéñòâèÿ ìàñêè èñòåêëî, âàì ïðèøëîñü åå âûáðîñèòü.') then
		sampAddChatMessage('[Prison Helper] {ffffff}Âðåìÿ äåéñòâèÿ ìàñêè èñòåêëî! Àâòîìàòè÷åñêè íàäåâàþ íîâóþ',
			message_color)
		sampProcessChatInput("/mask")
		return false
	end
	if text:find('DEBUG') or text:find('Mobile') then
		return false
	end
	if text:find("Âû óñïåøíî íàäåëè ìàñêó") then
		maska = true
		sampAddChatMessage('[Prison Helper] {ffffff}Âû íàäåëè ìàñêó', message_color)
		return false
	end
	if text:find("Òåïåðü âû â ìàñêå") then
		return false
	end
	if text:find("Âû óñïåøíî âûêèíóëè ìàñêó") or text:find("Âû ñíÿëè ìàñêó") then
		sampAddChatMessage('[Prison Helper] {ffffff}Âû ñíÿëè ìàñêó!', message_color)
		return false
	end
	if text:find("{BE2D2D} Èñïîëüçóéòå: /jobprogress [ ID èãðîêà ]") or text:find("Èñïîëüçóéòå: /jobprogress [ ID èãðîêà ]") then
		return false
	end
	if text:find("Âû óæå èçãîòîâèëè: {DC4747}(%d+){FFFFFF} ìàòåðèàëîâ") then
		local material = text:match("Âû óæå èçãîòîâèëè: {DC4747}(%d+){FFFFFF} ìàòåðèàëîâ")
		if material then
			local currentAmount = tonumber(material)          -- Ïðåîáðàçóåì ñòðîêó â ÷èñëî
			currentAmount = settings.player_organization.materials + 1 -- Ïðèáàâëÿåì 1 ìàòåðèàë

			settings.player_organization.materials = currentAmount
			return true
		end
	end
	if (text:find('William_Wright%[%d+%]') and getARZServerNumber():find('05')) or text:find('%[20%]William_Wright') then
		local lastColor = text:match("(.+){%x+}$")
		if not lastColor then
			lastColor = "{" .. rgba_to_hex(color) .. "}"
		end
		if text:find('%[VIP ADV%]') or text:find('%[FOREVER%]') then
			lastColor = "{FFFFFF}"
		end
		if text:find('%[20%]William_Wright%[%d+%]') then
			-- Ñëó÷àé 2: [20]William_Wright[123]
			local id = text:match('%[20%]William_Wright%[(%d+)%]') or ''
			text = string.gsub(text, '%[20%]William_Wright%[%d+%]',
				message_color_hex .. '[20]MTG MODS[' .. id .. ']' .. lastColor)
		elseif text:find('%[20%]William_Wright') then
			-- Ñëó÷àé 1: [20]William_Wright
			text = string.gsub(text, '%[20%]William_Wright', message_color_hex .. '[20]William Wright' .. lastColor)
		elseif text:find('William_Wright%[%d+%]') then
			-- Ñëó÷àé 3: William_Wright[123]
			local id = text:match('William_Wright%[(%d+)%]') or ''
			text = string.gsub(text, 'William_Wright%[%d+%]',
				message_color_hex .. 'William Wright[' .. id .. ']' .. lastColor)
		elseif text:find('William_Wright') then
			-- Ñëó÷àé 4: William_Wright
			text = string.gsub(text, 'William_Wright', message_color_hex .. 'William Wright' .. lastColor)
		end
		return { color, text }
	end
end

function sampev.onSendChat(text)
	local ignore = {
		[";)"] = true,
		[":D"] = true,
		[":O"] = true,
		[":|"] = true,
		[")"] = true,
		["))"] = true,
		["("] = true,
		["(("] = true,
		["xD"] = true,
		["q"] = true,
		["(+)"] = true,
		["(-)"] = true,
		[":)"] = true,
		[":("] = true,
		["=)"] = true,
		[":p"] = true,
		[";p"] = true,
		["(rofl)"] = true,
		["XD"] = true,
		["(agr)"] = true,
		["O.o"] = true,
		[">.<"] = true,
		[">:("] = true,
		["<3"] = true,
	}
	if ignore[text] then
		return { text }
	end
	if settings.general.rp_chat then
		text = text:sub(1, 1):rupper() .. text:sub(2, #text)
		if not text:find('(.+)%.') and not text:find('(.+)%!') and not text:find('(.+)%?') then
			text = text .. '.'
		end
	end
	if settings.general.accent_enable then
		text = settings.player_info.accent .. ' ' .. text
	end
	return { text }
end

function sampev.onSendCommand(text)
	if settings.general.rp_chat then
		local chats = { '/vr', '/fam', '/al', '/s', '/b', '/n', '/r', '/rb', '/f', '/fb', '/j', '/jb', '/m', '/do' }
		for _, cmd in ipairs(chats) do
			if text:find('^' .. cmd .. ' ') then
				local cmd_text = text:match('^' .. cmd .. ' (.+)')
				if cmd_text ~= nil then
					cmd_text = cmd_text:sub(1, 1):rupper() .. cmd_text:sub(2, #cmd_text)
					text = cmd .. ' ' .. cmd_text
					if not text:find('(.+)%.') and not text:find('(.+)%!') and not text:find('(.+)%?') then
						text = text .. '.'
					end
				end
			end
		end
	end
	return { text }
end

function sampev.onShowDialog(dialogid, style, title, button1, button2, text)
	if title:find('Îñíîâíàÿ ñòàòèñòèêà') and check_stats then -- ïîëó÷åíèå ñòàòèñòèêè
		if text:find("{FFFFFF}Èìÿ: {B83434}%[(.-)]") then
			settings.player_info.name_surname = TranslateNick(text:match("{FFFFFF}Èìÿ: {B83434}%[(.-)]"))
			input_name_surname = imgui.new.char[256](u8(settings.player_info.name_surname))
			sampAddChatMessage(
				'[Prison Helper] {ffffff}Âàøå Èìÿ è Ôàìèëèÿ îáíàðóæåíû, âû - ' .. settings.player_info.name_surname,
				message_color)
		end
		if text:find("{FFFFFF}Ïîë: {B83434}%[(.-)]") then
			settings.player_info.sex = text:match("{FFFFFF}Ïîë: {B83434}%[(.-)]")
			sampAddChatMessage('[Prison Helper] {ffffff}Âàø ïîë îáíàðóæåí, âû - ' .. settings.player_info.sex,
				message_color)
		end
		if text:find("{FFFFFF}Îðãàíèçàöèÿ: {B83434}%[(.-)]") then
			settings.player_info.fraction = text:match("{FFFFFF}Îðãàíèçàöèÿ: {B83434}%[(.-)]")
			if settings.player_info.fraction == 'Íå èìååòñÿ' then
				sampAddChatMessage('[Prison Helper] {ffffff}Âû íå ñîñòîèòå â îðãàíèçàöèè!', message_color)
				settings.player_info.fraction_tag = "Íåèçâåñòíî"
			else
				sampAddChatMessage(
					'[Prison Helper] {ffffff}Âàøà îðãàíèçàöèÿ îáíàðóæåíà, ýòî: ' .. settings.player_info.fraction,
					message_color)
				if settings.player_info.fraction == 'Ïîëèöèÿ ËÑ' or settings.player_info.fraction == 'Ïîëèöèÿ LS' then
					settings.player_info.fraction_tag = 'ËÑÏÄ'
				elseif settings.player_info.fraction == 'Ïîëèöèÿ ËÂ' or settings.player_info.fraction == 'Ïîëèöèÿ LV' then
					settings.player_info.fraction_tag = 'ËÂÏÄ'
				elseif settings.player_info.fraction == 'Ïîëèöèÿ ÑÔ' or settings.player_info.fraction == 'Ïîëèöèÿ SF' then
					settings.player_info.fraction_tag = 'ÑÔÏÄ'
				elseif settings.player_info.fraction == 'Îáëàñòíàÿ ïîëèöèÿ' then
					settings.player_info.fraction_tag = 'ÐÊØÄ'
				elseif settings.player_info.fraction == 'FBI' or settings.player_info.fraction == 'ÔÁÐ' then
					settings.player_info.fraction_tag = 'ÔÁÐ'
				elseif settings.player_info.fraction:find('Òþðüìà Ñòðîãîãî ðåæèìà') then
					settings.player_info.fraction_tag = 'MSP'
				elseif settings.player_info.fraction == 'Àðìèÿ SF' or settings.player_info.fraction == 'Àðìèÿ ÑÔ' then
					settings.player_info.fraction_tag = 'ÑÔà'
				elseif settings.player_info.fraction == 'Àðìèÿ ËÑ' or settings.player_info.fraction == 'Àðìèÿ LS' then
					settings.player_info.fraction_tag = 'ËÑà'
				else
					settings.player_info.fraction_tag = 'MSP'
				end
				settings.deportament.dep_tag1 = '[' .. settings.player_info.fraction_tag .. ']'
				input_dep_tag1 = imgui.new.char[32](u8(settings.deportament.dep_tag1))
				input_fraction_tag = imgui.new.char[256](u8(settings.player_info.fraction_tag))
				sampAddChatMessage(
					'[Prison Helper] {ffffff}Âàøåé îðãàíèçàöèè ïðèñâîåí òåã ' ..
					settings.player_info.fraction_tag .. ". Íî âû ìîæåòå èçìåíèòü åãî.", message_color)
			end
		end
		if text:find("{FFFFFF}Äîëæíîñòü: {B83434}(.+)%((%d+)%)") then
			settings.player_info.fraction_rank, settings.player_info.fraction_rank_number = text:match(
				"{FFFFFF}Äîëæíîñòü: {B83434}(.+)%((%d+)%)(.+)Óðîâåíü ðîçûñêà")
			sampAddChatMessage(
				'[Prison Helper] {ffffff}Âàøà äîëæíîñòü îáíàðóæåíà, ýòî: ' ..
				settings.player_info.fraction_rank .. " (" .. settings.player_info.fraction_rank_number .. ")",
				message_color)
			if tonumber(settings.player_info.fraction_rank_number) >= 9 then
				settings.general.auto_uval = true
				initialize_commands()
			end
		else
			settings.player_info.fraction_rank = "Íåèçâåñòíî"
			settings.player_info.fraction_rank_number = 0
			sampAddChatMessage('[Prison Helper] {ffffff}Ïðîèçîøëà îøèáêà, íå ìîãó ïîëó÷èòü âàø ðàíã!', message_color)
		end
		save_settings()
		sampSendDialogResponse(235, 0, 0, 0)
		check_stats = false
		return false
	end

	if title:find('Óñïåâàåìîñòü') and check_jobs then -- ïîëó÷åíèå ðàáî÷åé ñòàòèñòèêè
		if text:find("2%) Ñäåëàííûõ ïàòðîíîâ íà ñêëàäå: {FFB323}(%d+){FFFFFF}") then
			settings.player_organization.materials = text:match(
				"2%) Ñäåëàííûõ ïàòðîíîâ íà ñêëàäå: {FFB323}(%d+){FFFFFF}")
		end
		if text:find("3%) Äîñòàâëåííûõ â ÏÄ ôóð: {FFB323}(%d+){FFFFFF}") then
			settings.player_organization.postavki_materials = text:match(
				"3%) Äîñòàâëåííûõ â ÏÄ ôóð: {FFB323}(%d+){FFFFFF}")
		end
		if text:find("5%) Äîñòàâëåííûõ âåðòîë¸òîâ ñ ìàòåðèàëàìè: {FFB323}(%d+){FFFFFF}") then
			settings.player_organization.postavki_kargobob = text:match(
				"5%) Äîñòàâëåííûõ âåðòîë¸òîâ ñ ìàòåðèàëàìè: {FFB323}(%d+){FFFFFF}")
		end
		save_settings()
		sampSendDialogResponse(0, 0, 0, 0)
		check_jobs = false
		return false
	end

	if spawncar_bool and title:find('$') and text:find('Ñïàâí òðàíñïîðòà') then -- ñïàâí òðàíñïîðòà
		sampSendDialogResponse(dialogid, 2, 3, 0)
		spawncar_bool = false
		return false
	end

	if vc_vize_bool and text:find('Óïðàâëåíèå ðàçðåøåíèÿìè íà êîìàíäèðîâêó â Vice City') then -- VS Visa [0]
		sampSendDialogResponse(dialogid, 1, 11, 0)
		return false
	end

	if vc_vize_bool and title:find('Âûäà÷à ðàçðåøåíèé íà ïîåçäêè Vice City') then -- VS Visa [1]
		vc_vize_bool = false
		sampSendChat("/r Ñîòðóäíèêó " ..
			TranslateNick(sampGetPlayerNickname(tonumber(vc_vize_player_id))) .. " âûäàíà âèçà Vice City!")
		sampSendDialogResponse(dialogid, 1, 0, tostring(vc_vize_player_id))
		return false
	end

	if vc_vize_bool and title:find('Çàáðàòü ðàçðåøåíèå íà ïîåçäêè Vice City') then -- VS Visa [2]
		vc_vize_bool = false
		sampSendChat("/r Ó ñîòðóäíèêà " ..
			TranslateNick(sampGetPlayerNickname(tonumber(vc_vize_player_id))) .. " áûëà èçüÿòà âèçà Vice City!")
		sampSendDialogResponse(dialogid, 1, 0, tostring(sampGetPlayerNickname(vc_vize_player_id)))
		return false
	end

	if title:find('Ñóùíîñòè ðÿäîì') then -- arz fastmenu
		sampSendDialogResponse(dialogid, 0, 2, 0)
		return false
	end
	if members_check and title:find('(.+)%(Â ñåòè: (%d+)%)') then -- ìåìáåðñ
		local count = 0
		local next_page = false
		local next_page_i = 0
		members_fraction = string.match(title, '(.+)%(Â ñåòè')
		members_fraction = string.gsub(members_fraction, '{(.+)}', '')
		for line in text:gmatch('[^\r\n]+') do
			count = count + 1
			if not line:find('Íèê') and not line:find('ñòðàíèöà') then
				--local color, nickname, id, rank, rank_number, warns, afk = string.match(line, '{(.+)}(.+)%((%d+)%)\t(.+)%((%d+)%)\t(%d+) %((%d+)')
				local color, nickname, id, rank, rank_number, color2, warns, afk = string.match(line,
					"{(%x+)}([^%(]+)%((%d+)%)%s+([^%(]+)%((%d+)%)%s+{(%x+)}(%d+) %((%d)(.+)øò")
				if color ~= nil and nickname ~= nil and id ~= nil and rank ~= nil and rank_number ~= nil and warns ~= nil and afk ~= nil then
					local working = false
					if color:find('FF3B3B') then
						working = false
					elseif color:find('FFFFFF') then
						working = true
					end
					if nickname:find('%[%:(.+)%] (.+)') then
						tag, nick = nickname:match('%[(.+)%] (.+)')
						nickname = nick
					end
					table.insert(members_new,
						{
							nick = nickname,
							id = id,
							rank = rank,
							rank_number = rank_number,
							warns = warns,
							afk = afk,
							working =
								working
						})
				end
			end
			if line:match('Ñëåäóþùàÿ ñòðàíèöà') then
				next_page = true
				next_page_i = count - 2
			end
		end
		if next_page then
			sampSendDialogResponse(dialogid, 1, next_page_i, 0)
			next_page = false
			next_pagei = 0
		elseif #members_new ~= 0 then
			sampSendDialogResponse(dialogid, 0, 0, 0)
			members = members_new
			members_check = false
			MembersWindow[0] = true
		else
			sampSendDialogResponse(dialogid, 0, 0, 0)
			sampAddChatMessage('[Prison Helper]{ffffff} Ñïèñîê ñîòðóäíèêîâ ïóñò!', message_color)
			members_check = false
		end
		return false
	end

	if title:find('Âûáåðèòå ðàíã äëÿ (.+)') and text:find('âàêàíñèé') then -- invite
		sampSendDialogResponse(dialogid, 1, 0, 0)
		return false
	end
end

function onReceivePacket(id, bs)
	if isMonetLoader() then
		if id == 220 then
			local id = raknetBitStreamReadInt8(bs)
			local _1 = raknetBitStreamReadInt8(bs)
			local _2 = raknetBitStreamReadInt16(bs)
			local _3 = raknetBitStreamReadInt32(bs)
			-- àâòîìàòè÷åñêèé êëèê äëÿ ÌÎÁÀÉË "Êðóøåíèå ñàìîëåòà" è "Àâàðèÿ íà øîñå" (âçÿòî èç êîäà XRLM)
			if _3 > 2 and _3 <= raknetBitStreamGetNumberOfUnreadBits(bs) then
				local _4 = raknetBitStreamReadString(bs, _3)
				if _4:find('{"progress":%d+,"text":"Äëÿ âçàèìîäåéñòâèÿ, íàæèìàéòå íà êíîïêó ïîñåðåäèíå"}') and settings.general.auto_clicker_situation then
					clicked = true
				end
			end
		end
	else
		if id == 220 then
			raknetBitStreamIgnoreBits(bs, 8)
			if raknetBitStreamReadInt8(bs) == 17 then
				raknetBitStreamIgnoreBits(bs, 32)
				local cmd2 = raknetBitStreamReadString(bs, raknetBitStreamReadInt32(bs))
				-- àâòîìàòè÷åñêèé êëèê äëÿ ÏÊ "Êðóøåíèå ñàìîëåòà" è "Àâàðèÿ íà øîñå" (âçÿòî èç êîäà Chapo)
				local view = string.match(cmd2,
					"^window.executeEvent%('event%.setActiveView', [`']%[[\"%s]?(.-)[\"%s]?%][`']%);$")
				if view ~= nil and settings.general.auto_clicker_situation then
					clicked = (view == "Clicker")
				end

				if cmd2:find('Îñíîâíàÿ ñòàòèñòèêà') and check_stats then -- /jme
					sampAddChatMessage('[Prison Helper] {ffffff}Îøèáêà, íå ìîãó ïîëó÷èòü äàííûå èç íîâîãî CEF äèàëîãà!',
						message_color)
					sampAddChatMessage(
						'[Prison Helper] {ffffff}Âêëþ÷èòå ñòàðûé (êëàñè÷åññêèé) âèä äèàëîãîâ â /settings - Êàñòîìèçàöèÿ èíòåðôåéñà',
						message_color)
					run_code("window.executeEvent('cef.modals.closeModal', `[\"dialog\"]`);")
				end
			end
		end
	end
end

function onSendPacket(id, bs)
	if id == 220 and isMonetLoader() then
		local id = raknetBitStreamReadInt8(bs)
		local _1 = raknetBitStreamReadInt8(bs)
		local _2 = raknetBitStreamReadInt8(bs)
		if _1 == 66 and (_2 == 25 or _2 == 8) and settings.general.auto_clicker_situation then
			clicked = false
		end
	end
end

imgui.OnInitialize(function()
	imgui.GetIO().IniFilename = ni
	fa.Init(14 * MONET_DPI_SCALE)
	if settings.general.moonmonet_theme_enable and monet_no_errors then
		apply_moonmonet_theme()
	else
		apply_dark_theme()
	end
end)

imgui.OnFrame(
	function() return MainWindow[0] end,
	function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(700 * MONET_DPI_SCALE, 436 * MONET_DPI_SCALE), imgui.Cond.FirstUseEver) -- Ðàçìåðû âñåãî îêíà ñêðèïòà
		imgui.Begin(fa.BUILDING_SHIELD .. " Prison Helper##main", MainWindow,
			imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove)
		if imgui.BeginTabBar('ïîí') then
			if imgui.BeginTabItem(fa.HOUSE .. u8 ' Ãëàâíîå ìåíþ') then
				if imgui.BeginChild('##1', imgui.ImVec2(689 * MONET_DPI_SCALE, 195 * MONET_DPI_SCALE), true) then -- Ðàçìåðû ïåðâîé âêëàäêè
					imgui.CenterText(fa.USER_NURSE .. u8 ' Èíôîðìàöèÿ ïðî ñîòðóäíèêà')
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8 "Èìÿ è Ôàìèëèÿ:")
					imgui.SetColumnWidth(-1, 280 * MONET_DPI_SCALE) -- Äëèíà ïåðâîãî ñòîëáöà
					imgui.NextColumn()
					imgui.CenterColumnText(u8(settings.player_info.name_surname))
					imgui.SetColumnWidth(-1, 300 * MONET_DPI_SCALE) -- Äëèíà âòîðîãî ñòîëáöà
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8 'Èçìåíèòü##name_surname') then
						settings.player_info.name_surname = TranslateNick(sampGetPlayerNickname(select(2,
							sampGetPlayerIdByCharHandle(PLAYER_PED))))
						input_name_surname = imgui.new.char[256](u8(settings.player_info.name_surname))
						save_settings()
						imgui.OpenPopup(fa.USER_NURSE .. u8 ' Èìÿ è Ôàìèëèÿ##name_surname')
					end
					if imgui.BeginPopupModal(fa.USER_NURSE .. u8 ' Èìÿ è Ôàìèëèÿ##name_surname', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
						imgui.PushItemWidth(405 * MONET_DPI_SCALE)
						imgui.InputText(u8 '##name_surname', input_name_surname, 256)
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Îòìåíà', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8 ' Ñîõðàíèòü', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
							settings.player_info.name_surname = u8:decode(ffi.string(input_name_surname))
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.SetColumnWidth(-1, 100 * MONET_DPI_SCALE)
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8 "Ïîë:")
					imgui.NextColumn()
					imgui.CenterColumnText(u8(settings.player_info.sex))
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8 'Èçìåíèòü##sex') then
						if settings.player_info.sex == 'Íåèçâåñòíî' then
							settings.player_info.sex = 'Æåíùèíà'
							save_settings()
						elseif settings.player_info.sex == 'Ìóæ÷èíà' then
							settings.player_info.sex = 'Æåíùèíà'
							save_settings()
						elseif settings.player_info.sex == 'Æåíùèíà' then
							settings.player_info.sex = 'Ìóæ÷èíà'
							save_settings()
						end
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8 "Àêöåíò:")
					imgui.NextColumn()
					if checkbox_accent_enable[0] then
						imgui.CenterColumnText(u8(settings.player_info.accent))
					else
						imgui.CenterColumnText(u8 'Îòêëþ÷åíî')
					end
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8 'Èçìåíèòü##accent') then
						imgui.OpenPopup(fa.USER_NURSE .. u8 ' Àêöåíò ïåðñîíàæà##accent')
					end
					if imgui.BeginPopupModal(fa.USER_NURSE .. u8 ' Àêöåíò ïåðñîíàæà##accent', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
						if imgui.Checkbox('##checkbox_accent_enable', checkbox_accent_enable) then
							settings.general.accent_enable = checkbox_accent_enable[0]
							save_settings()
						end
						imgui.SameLine()
						imgui.PushItemWidth(375 * MONET_DPI_SCALE)
						imgui.InputText(u8 '##accent_input', input_accent, 256)
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Îòìåíà', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8 ' Ñîõðàíèòü', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
							settings.player_info.accent = u8:decode(ffi.string(input_accent))
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8 "Îðãàíèçàöèÿ:")
					imgui.NextColumn()
					imgui.CenterColumnText(u8(settings.player_info.fraction))
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8 'Îáíîâèòü##fraction') then
						check_stats = true
						sampSendChat('/stats')
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8 "Òýã îðãàíèçàöèè:")
					imgui.NextColumn()
					imgui.CenterColumnText(u8(settings.player_info.fraction_tag))
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8 'Èçìåíèòü##fraction_tag') then
						imgui.OpenPopup(fa.BUILDING_SHIELD .. u8 ' Òýã îðãàíèçàöèè##fraction_tag')
					end
					if imgui.BeginPopupModal(fa.BUILDING_SHIELD .. u8 ' Òýã îðãàíèçàöèè##fraction_tag', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
						imgui.PushItemWidth(405 * MONET_DPI_SCALE)
						imgui.InputText(u8 '##input_fraction_tag', input_fraction_tag, 256)
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Îòìåíà', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8 ' Ñîõðàíèòü', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
							settings.player_info.fraction_tag = u8:decode(ffi.string(input_fraction_tag))
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8 "Äîëæíîñòü â îðãàíèçàöèè:")
					imgui.NextColumn()
					imgui.CenterColumnText(u8(settings.player_info.fraction_rank) ..
						" (" .. settings.player_info.fraction_rank_number .. ")")
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8 "Îáíîâèòü##rank") then
						check_stats = true
						sampSendChat('/stats')
					end
					imgui.Columns(1)

					imgui.EndChild()
				end
				if imgui.BeginChild('##3', imgui.ImVec2(689 * MONET_DPI_SCALE, 170 * MONET_DPI_SCALE), true) then -- Ðàçìåðû îêíà "Äîïîëíèòåëüíûå ôóíêöèè õåëïåðà"
					imgui.CenterText(fa.SITEMAP .. u8 ' Äîïîëíèòåëüíûå ôóíêöèè õåëïåðà')
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8 "Èíôîðìàöèîííîå ìåíþ")
					imgui.SameLine(nil, 5)
					imgui.TextDisabled("[?]")
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8 "Îòîáðàæåíèå íà ýêðàíå ìåíþøêè ñ èíôîðìàöèåé")
					end
					imgui.SetColumnWidth(-1, 280 * MONET_DPI_SCALE) -- Äëèíà íàçâàíèÿ ïóíêòà
					imgui.NextColumn()
					if settings.general.use_info_menu then
						imgui.CenterColumnText(u8 'Âêëþ÷åíî')
					else
						imgui.CenterColumnText(u8 'Îòêëþ÷åíî')
					end
					imgui.SetColumnWidth(-1, 300 * MONET_DPI_SCALE) -- Äëèíà îïèñàíèå ïóíêòà
					imgui.NextColumn()
					if settings.general.use_info_menu then
						if imgui.CenterColumnSmallButton(u8 'Îòêëþ÷èòü##info_menu') then
							settings.general.use_info_menu = false
							InformationWindow[0] = false
							save_settings()
						end
					else
						if imgui.CenterColumnSmallButton(u8 'Âêëþ÷èòü##info_menu') then
							settings.general.use_info_menu = true
							InformationWindow[0] = true
							save_settings()
						end
					end
					imgui.SetColumnWidth(-1, 100 * MONET_DPI_SCALE) -- Ðàçìåð êíîïêè
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8 "Ðåæèì RP îòûãðîâêè îðóæèÿ")
					imgui.SameLine(nil, 5)
					imgui.TextDisabled("[?]")
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8 "Ïðè èñïîëüçîâàíèè/ñêðîëëå îðóæèÿ â ÷àòå áóäóò RP îòûãðîâêè.")
					end
					imgui.NextColumn()
					if settings.general.rp_gun then
						imgui.CenterColumnText(u8 'Âêëþ÷åíî')
					else
						imgui.CenterColumnText(u8 'Îòêëþ÷åíî')
					end
					imgui.NextColumn()
					if settings.general.rp_gun then
						if imgui.CenterColumnSmallButton(u8 'Îòêëþ÷èòü##rp_gun') then
							settings.general.rp_gun = false
							save_settings()
						end
					else
						if imgui.CenterColumnSmallButton(u8 'Âêëþ÷èòü##rp_gun') then
							settings.general.rp_gun = true
							save_settings()
						end
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8 "Ðåæèì RP îáùåíèÿ â ÷àòàõ")
					imgui.SameLine(nil, 5)
					imgui.TextDisabled("[?]")
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8 "Âñå âàøè ñîîáùåíèÿ áóäóò ñ çàãëàâíîé áóêâû è ñ òî÷êîé â êîíöå.\nÐàáîòàåò â îáû÷íîì ÷àòå è íåêîòîðûõ ÷àñòî èñïîëüçóåìûõ êîìàíäàõ:\n/r /rb /j /jb /m /s /b /n /do /vr /fam /al")
					end
					imgui.NextColumn()
					if settings.general.rp_chat then
						imgui.CenterColumnText(u8 'Âêëþ÷åíî')
					else
						imgui.CenterColumnText(u8 'Îòêëþ÷åíî')
					end
					imgui.NextColumn()
					if settings.general.rp_chat then
						if imgui.CenterColumnSmallButton(u8 'Îòêëþ÷èòü##rp_chat') then
							settings.general.rp_chat = false
							save_settings()
						end
					else
						if imgui.CenterColumnSmallButton(u8 'Âêëþ÷èòü##rp_chat') then
							settings.general.rp_chat = true
							save_settings()
						end
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8 "Ðåæèì àâòî-ìàñêà")
					imgui.SameLine(nil, 5)
					imgui.TextDisabled("[?]")
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8 "Ñïóñòÿ êàæäûå 20 ìèíóò àâòîìàòè÷åñêè áóäåò íàäåâàòü ìàñêó.")
					end
					imgui.NextColumn()
					if settings.general.auto_mask then
						imgui.CenterColumnText(u8 'Âêëþ÷åíî')
					else
						imgui.CenterColumnText(u8 'Îòêëþ÷åíî')
					end
					imgui.NextColumn()
					if settings.general.auto_mask then
						if imgui.CenterColumnSmallButton(u8 'Îòêëþ÷èòü##auto_mask') then
							settings.general.auto_mask = false
							save_settings()
						end
					else
						if imgui.CenterColumnSmallButton(u8 'Âêëþ÷èòü##auto_mask') then
							settings.general.auto_mask = true
							save_settings()
						end
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8 "Àâòîìàòè÷åñêèé óâàë")
					imgui.SameLine(nil, 5)
					imgui.TextDisabled("[?]")
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8 "Ôóíêöèÿ òîëüêî äëÿ ëèäåðà èëè åãî çàìåñòèòåëåé!\nÏîçâîëÿåò àâòîìàòè÷åñêè óâîëüíÿòü òåõ êòî ïðîñèò ÏÑÆ\nÑ ïîäâåðæäåíèåì îò èãðîêà, ïóò¸ì îòïðàâêè ñîîáùåíèÿ â /rb")
					end
					imgui.NextColumn()
					if settings.general.auto_uval then
						imgui.CenterColumnText(u8 'Âêëþ÷åíî')
					else
						imgui.CenterColumnText(u8 'Îòêëþ÷åíî')
					end
					imgui.NextColumn()
					if settings.general.auto_uval then
						if imgui.CenterColumnSmallButton(u8 'Îòêëþ÷èòü##auto_uval') then
							settings.general.auto_uval = false
							save_settings()
						end
					else
						if imgui.CenterColumnSmallButton(u8 'Âêëþ÷èòü##auto_uval') then
							if tonumber(settings.player_info.fraction_rank_number) == 9 or tonumber(settings.player_info.fraction_rank_number) == 10 then
								settings.general.auto_uval = true
								save_settings()
							else
								settings.general.auto_uval = false
								sampAddChatMessage(
									'[Prison Helper] {ffffff}Ýòà Ôóíêöèÿ äîñòóïíà òîëüêî ëèäåðó è çàìåñòèòåëÿì!',
									message_color)
							end
						end
					end
					imgui.Columns(1)
					-- imgui.Separator()
					imgui.EndChild()
				end
				imgui.EndTabItem()
			end
			if imgui.BeginTabItem(fa.RECTANGLE_LIST .. u8 ' Êîìàíäû è îòûãðîâêè') then
				if imgui.BeginTabBar('Tabs2') then
					if imgui.BeginTabItem(fa.BARS .. u8 ' Îáùèå êîìàíäû äëÿ âñåõ ðàíãîâ ') then
						if imgui.BeginChild('##1', imgui.ImVec2(689 * MONET_DPI_SCALE, 312 * MONET_DPI_SCALE), true) then -- Ðàçìåðû âêëàäêè "Êîìàíäû è îòûãðîâêè"
							imgui.Columns(3)
							imgui.CenterColumnText(u8 "Êîìàíäà")
							imgui.SetColumnWidth(-1, 200 * MONET_DPI_SCALE) -- Ðàçìåðû ïåðâîãî ïóíêòà âòîðîé âêëàäêè
							imgui.NextColumn()
							imgui.CenterColumnText(u8 "Îïèñàíèå")
							imgui.SetColumnWidth(-1, 370 * MONET_DPI_SCALE) -- Ðàçìåðû âòîðîãî ïóíêòà âòîðîé âêëàäêè
							imgui.NextColumn()
							imgui.CenterColumnText(u8 "Äåéñòâèå")
							imgui.SetColumnWidth(-1, 150 * MONET_DPI_SCALE) -- Ðàçìåðû òðåòüåãî ïóíêòà âòîðîé âêëàäêè
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(3)
							imgui.CenterColumnText(u8 "/ph")
							imgui.NextColumn()
							imgui.CenterColumnText(u8 "Îòêðûòü ãëàâíîå ìåíþ õåëïåðà")
							imgui.NextColumn()
							imgui.CenterColumnText(u8 "Íåäîñòóïíî")
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(3)
							imgui.CenterColumnText(u8 "/jm")
							imgui.NextColumn()
							imgui.CenterColumnText(u8 "Îòêðûòü áûñòðîå ìåíþ âçàèìîäåéñòâèÿ")
							imgui.NextColumn()
							imgui.CenterColumnText(u8 "Íåäîñòóïíî")
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(3)
							imgui.CenterColumnText(u8 "/mb")
							imgui.NextColumn()
							imgui.CenterColumnText(u8 "Îòêðûòü ìåíþ âñåãî /members")
							imgui.NextColumn()
							imgui.CenterColumnText(u8 "Íåäîñòóïíî")
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(3)
							imgui.CenterColumnText(u8 "/mask")
							imgui.NextColumn()
							imgui.CenterColumnText(u8 "Íàäåòü/ñíÿòü áàëàêëàâó")
							imgui.NextColumn()
							imgui.CenterColumnText(u8 "Íåäîñòóïíî")
							imgui.Columns(1)
							imgui.Separator()
							for index, command in ipairs(commands.commands) do
								imgui.Columns(3)
								if command.enable then
									imgui.CenterColumnText('/' .. u8(command.cmd))
									imgui.NextColumn()
									imgui.CenterColumnText(u8(command.description))
									imgui.NextColumn()
								else
									imgui.CenterColumnTextDisabled('/' .. u8(command.cmd))
									imgui.NextColumn()
									imgui.CenterColumnTextDisabled(u8(command.description))
									imgui.NextColumn()
								end
								imgui.Text(' ')
								imgui.SameLine()
								if command.enable then
									if imgui.SmallButton(fa.TOGGLE_ON .. '##' .. command.cmd) then
										command.enable = not command.enable
										save_commands()
										sampUnregisterChatCommand(command.cmd)
									end
									if imgui.IsItemHovered() then
										imgui.SetTooltip(u8 "Îòêëþ÷åíèå êîìàíäû /" .. command.cmd)
									end
								else
									if imgui.SmallButton(fa.TOGGLE_OFF .. '##' .. command.cmd) then
										command.enable = not command.enable
										save_commands()
										register_command(command.cmd, command.arg, command.text,
											tonumber(command.waiting))
									end
									if imgui.IsItemHovered() then
										imgui.SetTooltip(u8 "Âêëþ÷åíèå êîìàíäû /" .. command.cmd)
									end
								end
								imgui.SameLine()
								if imgui.SmallButton(fa.PEN_TO_SQUARE .. '##' .. command.cmd) then
									change_description = command.description
									input_description = imgui.new.char[256](u8(change_description))
									change_arg = command.arg
									if command.arg == '' then
										ComboTags[0] = 0
									elseif command.arg == '{arg}' then
										ComboTags[0] = 1
									elseif command.arg == '{arg_id}' then
										ComboTags[0] = 2
									elseif command.arg == '{arg_id} {arg2}' then
										ComboTags[0] = 3
									elseif command.arg == '{arg_id} {arg2} {arg3}' then
										ComboTags[0] = 4
									elseif command.arg == '{arg_id} {arg2} {arg3} {arg4}' then
										ComboTags[0] = 5
									end
									change_cmd = command.cmd
									input_cmd = imgui.new.char[256](u8(command.cmd))
									change_text = command.text:gsub('&', '\n')
									input_text = imgui.new.char[8192](u8(change_text))
									change_waiting = command.waiting
									waiting_slider = imgui.new.float(tonumber(command.waiting))
									BinderWindow[0] = true
								end
								if imgui.IsItemHovered() then
									imgui.SetTooltip(u8 "Èçìåíåíèå êîìàíäû /" .. command.cmd)
								end
								imgui.SameLine()
								if imgui.SmallButton(fa.TRASH_CAN .. '##' .. command.cmd) then
									imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8 ' Ïðåäóïðåæäåíèå ##' .. command.cmd)
								end
								if imgui.IsItemHovered() then
									imgui.SetTooltip(u8 "Óäàëåíèå êîìàíäû /" .. command.cmd)
								end
								if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8 ' Ïðåäóïðåæäåíèå ##' .. command.cmd, _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
									imgui.CenterText(u8 'Âû äåéñòâèòåëüíî õîòèòå óäàëèòü êîìàíäó /' ..
										u8(command.cmd) .. '?')
									imgui.Separator()
									if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Íåò, îòìåíèòü', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
										imgui.CloseCurrentPopup()
									end
									imgui.SameLine()
									if imgui.Button(fa.TRASH_CAN .. u8 ' Äà, óäàëèòü', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
										sampUnregisterChatCommand(command.cmd)
										table.remove(commands.commands, index)
										save_commands()
										imgui.CloseCurrentPopup()
									end
									imgui.End()
								end
								imgui.Columns(1)
								imgui.Separator()
							end
							imgui.EndChild()
						end
						if imgui.Button(fa.CIRCLE_PLUS .. u8 ' Ñîçäàòü íîâóþ êîìàíäó##new_cmd', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
							local new_cmd = {
								cmd = '',
								description = '',
								text = '',
								arg = '',
								enable = true,
								waiting =
								'3.500'
							}
							binder_create_command_9_10 = false
							binder_create_command_5_8 = false
							table.insert(commands.commands, new_cmd)
							change_description = new_cmd.description
							input_description = imgui.new.char[256](u8(change_description))
							change_arg = new_cmd.arg
							ComboTags[0] = 0
							change_cmd = new_cmd.cmd
							input_cmd = imgui.new.char[256](u8(new_cmd.cmd))
							change_text = new_cmd.text:gsub('&', '\n')
							input_text = imgui.new.char[8192](u8(change_text))
							change_waiting = 1.200
							waiting_slider = imgui.new.float(1.200)
							BinderWindow[0] = true
						end
						imgui.EndTabItem()
					end
					if imgui.BeginTabItem(fa.BARS .. u8 ' Êîìàíäû äëÿ 5+ ') then
						if tonumber(settings.player_info.fraction_rank_number) >= 5 or tonumber(settings.player_info.fraction_rank_number) == 9 or tonumber(settings.player_info.fraction_rank_number) == 10 then
							if imgui.BeginChild('##1', imgui.ImVec2(690 * MONET_DPI_SCALE, 312 * MONET_DPI_SCALE), true) then -- Ðàçìåðû âêëàäêè "Êîìàíäû äëÿ 5+"
								imgui.Columns(3)
								imgui.CenterColumnText(u8 "Êîìàíäà")
								imgui.SetColumnWidth(-1, 200 * MONET_DPI_SCALE) -- Ðàçìåðû ïåðâîãî ïóíêòà âòîðîé âêëàäêè
								imgui.NextColumn()
								imgui.CenterColumnText(u8 "Îïèñàíèå")
								imgui.SetColumnWidth(-1, 370 * MONET_DPI_SCALE) -- Ðàçìåðû âòîðîãî ïóíêòà âòîðîé âêëàäêè
								imgui.NextColumn()
								imgui.CenterColumnText(u8 "Äåéñòâèå")
								imgui.SetColumnWidth(-1, 150 * MONET_DPI_SCALE) -- Ðàçìåðû òðåòüåãî ïóíêòà âòîðîé âêëàäêè
								imgui.Columns(1)
								imgui.Separator()
								imgui.Columns(3)
								imgui.CenterColumnText(u8 "/dep")
								imgui.NextColumn()
								imgui.CenterColumnText(u8 "Îòêðûòü ìåíþ ðàöèè äåïàðòàìåíòà")
								imgui.NextColumn()
								imgui.CenterColumnText(u8 "Íåäîñòóïíî")
								imgui.Columns(1)
								imgui.Separator()
								imgui.Columns(3)
								for index, command in ipairs(commands.commands_senior_staff) do
									imgui.Columns(3)
									if command.enable then
										imgui.CenterColumnText('/' .. u8(command.cmd))
										imgui.NextColumn()
										imgui.CenterColumnText(u8(command.description))
										imgui.NextColumn()
									else
										imgui.CenterColumnTextDisabled('/' .. u8(command.cmd))
										imgui.NextColumn()
										imgui.CenterColumnTextDisabled(u8(command.description))
										imgui.NextColumn()
									end
									imgui.Text(' ')
									imgui.SameLine()
									if command.enable then
										if imgui.SmallButton(fa.TOGGLE_ON .. '##' .. command.cmd) then
											command.enable = not command.enable
											save_commands()
											sampUnregisterChatCommand(command.cmd)
										end
										if imgui.IsItemHovered() then
											imgui.SetTooltip(u8 "Îòêëþ÷åíèå êîìàíäû /" .. command.cmd)
										end
									else
										if imgui.SmallButton(fa.TOGGLE_OFF .. '##' .. command.cmd) then
											command.enable = not command.enable
											save_commands()
											register_command(command.cmd, command.arg, command.text,
												tonumber(command.waiting))
										end
										if imgui.IsItemHovered() then
											imgui.SetTooltip(u8 "Âêëþ÷åíèå êîìàíäû /" .. command.cmd)
										end
									end
									imgui.SameLine()
									if imgui.SmallButton(fa.PEN_TO_SQUARE .. '##' .. command.cmd) then
										change_description = command.description
										input_description = imgui.new.char[256](u8(change_description))
										change_arg = command.arg
										if command.arg == '' then
											ComboTags[0] = 0
										elseif command.arg == '{arg}' then
											ComboTags[0] = 1
										elseif command.arg == '{arg_id}' then
											ComboTags[0] = 2
										elseif command.arg == '{arg_id} {arg2}' then
											ComboTags[0] = 3
										elseif command.arg == '{arg_id} {arg2} {arg3}' then
											ComboTags[0] = 4
										elseif command.arg == '{arg_id} {arg2} {arg3} {arg4}' then
											ComboTags[0] = 5
										end
										change_cmd = command.cmd
										input_cmd = imgui.new.char[256](u8(command.cmd))
										change_text = command.text:gsub('&', '\n')
										input_text = imgui.new.char[8192](u8(change_text))
										change_waiting = command.waiting
										waiting_slider = imgui.new.float(tonumber(command.waiting))
										BinderWindow[0] = true
									end
									if imgui.IsItemHovered() then
										imgui.SetTooltip(u8 "Èçìåíåíèå êîìàíäû /" .. command.cmd)
									end
									imgui.SameLine()
									if imgui.SmallButton(fa.TRASH_CAN .. '##' .. command.cmd) then
										imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8 ' Ïðåäóïðåæäåíèå ##' .. command
											.cmd)
									end
									if imgui.IsItemHovered() then
										imgui.SetTooltip(u8 "Óäàëåíèå êîìàíäû /" .. command.cmd)
									end
									if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8 ' Ïðåäóïðåæäåíèå ##' .. command.cmd, _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
										imgui.CenterText(u8 'Âû äåéñòâèòåëüíî õîòèòå óäàëèòü êîìàíäó /' ..
											u8(command.cmd) .. '?')
										imgui.Separator()
										if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Íåò, îòìåíèòü', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
											imgui.CloseCurrentPopup()
										end
										imgui.SameLine()
										if imgui.Button(fa.TRASH_CAN .. u8 ' Äà, óäàëèòü', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
											sampUnregisterChatCommand(command.cmd)
											table.remove(commands.commands_senior_staff, index)
											save_commands()
											imgui.CloseCurrentPopup()
										end
										imgui.End()
									end
									imgui.Columns(1)
									imgui.Separator()
								end
								imgui.EndChild()
							end
							if imgui.Button(fa.CIRCLE_PLUS .. u8 ' Ñîçäàòü íîâóþ êîìàíäó##new_cmd', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
								local new_cmd = {
									cmd = '',
									description = '',
									text = '',
									arg = '',
									enable = true,
									waiting =
									'3.500'
								}
								binder_create_command_9_10 = false
								binder_create_command_5_8 = true
								table.insert(commands.commands_senior_staff, new_cmd)
								change_description = new_cmd.description
								input_description = imgui.new.char[256](u8(change_description))
								change_arg = new_cmd.arg
								ComboTags[0] = 0
								change_cmd = new_cmd.cmd
								input_cmd = imgui.new.char[256](u8(new_cmd.cmd))
								change_text = new_cmd.text:gsub('&', '\n')
								input_text = imgui.new.char[8192](u8(change_text))
								change_waiting = 1.200
								waiting_slider = imgui.new.float(1.200)
								BinderWindow[0] = true
							end
						else
							imgui.CenterText(fa.TRIANGLE_EXCLAMATION)
							imgui.Separator()
							imgui.CenterText(u8 "Ó âàñ íåò äîñòóïà ê äàííûì êîìàíäàì!")
							imgui.CenterText(u8 "Íåîáõîäèìî èìåòü ðàíã âûøå 5, ó âàñ æå " ..
								settings.player_info.fraction_rank_number .. u8 " ðàíã!")
							imgui.Separator()
						end
						imgui.EndTabItem()
					end
					if imgui.BeginTabItem(fa.BARS .. u8 ' Êîìàíäû äëÿ 9-10 ðàíãîâ') then
						if tonumber(settings.player_info.fraction_rank_number) == 9 or tonumber(settings.player_info.fraction_rank_number) == 10 then
							if imgui.BeginChild('##1', imgui.ImVec2(689 * MONET_DPI_SCALE, 312 * MONET_DPI_SCALE), true) then -- Ðàçìåðû îêíà
								imgui.Columns(3)
								imgui.CenterColumnText(u8 "Êîìàíäà")
								imgui.SetColumnWidth(-1, 200 * MONET_DPI_SCALE)
								imgui.NextColumn()
								imgui.CenterColumnText(u8 "Îïèñàíèå")
								imgui.SetColumnWidth(-1, 370 * MONET_DPI_SCALE)
								imgui.NextColumn()
								imgui.CenterColumnText(u8 "Äåéñòâèå")
								imgui.SetColumnWidth(-1, 150 * MONET_DPI_SCALE)
								imgui.Columns(1)
								imgui.Separator()
								imgui.Columns(3)
								imgui.CenterColumnText(u8 "/jlm")
								imgui.NextColumn()
								imgui.CenterColumnText(u8 "Îòêðûòü áûñòðîå ìåíþ óïðàâëåíèÿ")
								imgui.NextColumn()
								imgui.CenterColumnText(u8 "Íåäîñòóïíî")
								imgui.Columns(1)
								imgui.Separator()
								imgui.Columns(3)
								imgui.CenterColumnText(u8 "/spcar")
								imgui.NextColumn()
								imgui.CenterColumnText(u8 "Çàñïàâíèòü òðàíñïîðòà îðãàíèçàöèè")
								imgui.NextColumn()
								imgui.CenterColumnText(u8 "Íåäîñòóïíî")
								imgui.Columns(1)
								imgui.Separator()
								imgui.Columns(3)
								imgui.CenterColumnText(u8 "/sob")
								imgui.NextColumn()
								imgui.CenterColumnText(u8 "Îòêðûòü ìåíþ ñîáåñåäîâàíèÿ")
								imgui.NextColumn()
								imgui.CenterColumnText(u8 "Íåäîñòóïíî")
								imgui.Columns(1)
								imgui.Separator()
								for index, command in ipairs(commands.commands_manage) do
									imgui.Columns(3)
									if command.enable then
										imgui.CenterColumnText('/' .. u8(command.cmd))
										imgui.NextColumn()
										imgui.CenterColumnText(u8(command.description))
										imgui.NextColumn()
									else
										imgui.CenterColumnTextDisabled('/' .. u8(command.cmd))
										imgui.NextColumn()
										imgui.CenterColumnTextDisabled(u8(command.description))
										imgui.NextColumn()
									end
									imgui.Text('  ')
									imgui.SameLine()
									if command.enable then
										if imgui.SmallButton(fa.TOGGLE_ON .. '##' .. command.cmd) then
											command.enable = not command.enable
											save_commands()
											sampUnregisterChatCommand(command.cmd)
										end
										if imgui.IsItemHovered() then
											imgui.SetTooltip(u8 "Îòêëþ÷åíèå êîìàíäû /" .. command.cmd)
										end
									else
										if imgui.SmallButton(fa.TOGGLE_OFF .. '##' .. command.cmd) then
											command.enable = not command.enable
											save_commands()
											register_command(command.cmd, command.arg, command.text,
												tonumber(command.waiting))
										end
										if imgui.IsItemHovered() then
											imgui.SetTooltip(u8 "Âêëþ÷åíèå êîìàíäû /" .. command.cmd)
										end
									end
									imgui.SameLine()
									if imgui.SmallButton(fa.PEN_TO_SQUARE .. '##' .. command.cmd) then
										change_description = command.description
										input_description = imgui.new.char[256](u8(change_description))
										change_arg = command.arg
										if command.arg == '' then
											ComboTags[0] = 0
										elseif command.arg == '{arg}' then
											ComboTags[0] = 1
										elseif command.arg == '{arg_id}' then
											ComboTags[0] = 2
										elseif command.arg == '{arg_id} {arg2}' then
											ComboTags[0] = 3
										elseif command.arg == '{arg_id} {arg2} {arg3}' then
											ComboTags[0] = 4
										elseif command.arg == '{arg_id} {arg2} {arg3} {arg4}' then
											ComboTags[0] = 5
										end
										change_cmd = command.cmd
										input_cmd = imgui.new.char[256](u8(command.cmd))
										change_text = command.text:gsub('&', '\n')
										input_text = imgui.new.char[8192](u8(change_text))
										binder_create_command_9_10 = true
										binder_create_command_5_8 = false
										change_waiting = command.waiting
										waiting_slider = imgui.new.float(tonumber(command.waiting))
										BinderWindow[0] = true
									end
									if imgui.IsItemHovered() then
										imgui.SetTooltip(u8 "Èçìåíåíèå êîìàíäû /" .. command.cmd)
									end
									imgui.SameLine()
									if imgui.SmallButton(fa.TRASH_CAN .. '##' .. command.cmd) then
										imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION ..
											u8 ' Ïðåäóïðåæäåíèå ##9-10' .. command.cmd)
									end
									if imgui.IsItemHovered() then
										imgui.SetTooltip(u8 "Óäàëåíèå êîìàíäû /" .. command.cmd)
									end
									if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8 ' Ïðåäóïðåæäåíèå ##9-10' .. command.cmd, _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
										imgui.CenterText(u8 'Âû äåéñòâèòåëüíî õîòèòå óäàëèòü êîìàíäó /' ..
											u8(command.cmd) .. '?')
										imgui.Separator()
										if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Íåò, îòìåíèòü', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
											imgui.CloseCurrentPopup()
										end
										imgui.SameLine()
										if imgui.Button(fa.TRASH_CAN .. u8 ' Äà, óäàëèòü', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
											sampUnregisterChatCommand(command.cmd)
											table.remove(commands.commands_manage, index)
											save_commands()
											imgui.CloseCurrentPopup()
										end
										imgui.End()
									end
									imgui.Columns(1)
									imgui.Separator()
								end
								imgui.EndChild()
							end
							if imgui.Button(fa.CIRCLE_PLUS .. u8 ' Ñîçäàòü íîâóþ êîìàíäó##new_cmd_9-10', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
								binder_create_command_9_10 = true
								binder_create_command_5_8 = false
								local new_cmd = {
									cmd = '',
									description = '',
									text = '',
									arg = '',
									enable = true,
									waiting =
									'3.500'
								}
								table.insert(commands.commands_manage, new_cmd)
								change_description = new_cmd.description
								input_description = imgui.new.char[256](u8(change_description))
								change_arg = new_cmd.arg
								ComboTags[0] = 0
								change_cmd = new_cmd.cmd
								input_cmd = imgui.new.char[256](u8(new_cmd.cmd))
								change_text = new_cmd.text:gsub('&', '\n')
								input_text = imgui.new.char[8192](u8(change_text))
								change_waiting = 3.500
								waiting_slider = imgui.new.float(3.500)
								BinderWindow[0] = true
							end
						else
							imgui.CenterText(fa.TRIANGLE_EXCLAMATION)
							imgui.Separator()
							imgui.CenterText(u8 "Ó âàñ íåò äîñòóïà ê äàííûì êîìàíäàì!")
							imgui.CenterText(u8 "Íåîáõîäèìî èìåòü 9 èëè 10 ðàíã, ó âàñ æå " ..
								settings.player_info.fraction_rank_number .. u8 " ðàíã!")
							imgui.Separator()
						end
						imgui.EndTabItem()
					end
					if imgui.BeginTabItem(fa.BARS .. u8 ' Äîïîëíèòåëüíûå ôóíêöèè') then
						if imgui.BeginChild('##99', imgui.ImVec2(689 * MONET_DPI_SCALE, 342 * MONET_DPI_SCALE), true) then
							if isMonetLoader() then
								imgui.CenterText(u8 'Ñïîñîá îòêðûòèÿ áûñòðîãî ìåíþ âçàèìîäåéñòâèÿ ñ èãðîêîì:')
								if imgui.RadioButtonIntPtr(u8 " Òîëüêî èñïîëüçóÿ êîìàíäó /jm [ID èãðîêà]", fastmenu_type, 0) then
									fastmenu_type[0] = 0
									settings.general.mobile_fastmenu_button = false
									save_settings()
									FastMenuButton[0] = false
								end
								if imgui.RadioButtonIntPtr(u8 ' Èñïîëüçóÿ êîìàíäó /jm [ID èãðîêà] èëè êíîïêó "Âçàèìîäåéñòâèå" â ëåâîì óãëó ýêðàíà', fastmenu_type, 1) then
									fastmenu_type[0] = 1
									settings.general.mobile_fastmenu_button = true
									save_settings()
								end
								imgui.Separator()
								imgui.CenterText(u8 'Ñïîñîá ïðèîñòàíîâêè îòûãðîâêè êîìàíäû:')
								if imgui.RadioButtonIntPtr(u8 " Òîëüêî èñïîëüçóÿ êîìàíäó /stop", stop_type, 0) then
									stop_type[0] = 0
									settings.general.mobile_stop_button = false
									CommandStopWindow[0] = true
									save_settings()
								end
								if imgui.RadioButtonIntPtr(u8 ' Èñïîëüçóÿ êîìàíäó /stop èëè êíîïêó "Îñòàíîâèòü" âíèçó ýêðàíà', stop_type, 1) then
									stop_type[0] = 1
									settings.general.mobile_stop_button = true
									save_settings()
								end
								imgui.Separator()
							else
								imgui.CenterText(fa.KEYBOARD .. u8 ' Hotkeys')
								if hotkey_no_errors then
									imgui.SameLine()
									if settings.general.use_binds then
										if imgui.SmallButton(fa.TOGGLE_ON .. '##enable_binds') then
											settings.general.use_binds = not settings.general.use_binds
											save_settings()
										end
										if imgui.IsItemHovered() then
											imgui.SetTooltip(u8 "Îòêëþ÷èòü ñèñòåìó áèíäîâ")
										end
										if imgui.CenterButton(fa.KEYBOARD .. u8 ' Íàñòðîéêà êëàâèø') then
											imgui.OpenPopup(fa.KEYBOARD .. u8 ' Íàñòðîéêà êëàâèø')
										end
									else
										if imgui.SmallButton(fa.TOGGLE_OFF .. '##enable_binds') then
											settings.general.use_binds = not settings.general.use_binds
											save_settings()
										end
										if imgui.IsItemHovered() then
											imgui.SetTooltip(u8 "Âêëþ÷èòü ñèñòåìó áèíäîâ")
										end
										imgui.CenterButton(u8 'Ñèñòåìà Õîòêååâ (áèíäîâ) îòêëþ÷åíà!')
									end
								else
									imgui.SameLine()
									imgui.SmallButton(fa.TOGGLE_OFF .. '##enable_binds')
									imgui.CenterText(fa.TRIANGLE_EXCLAMATION ..
										u8 ' Îøèáêà: îòñóñòâóþò ôàéëû áèáëèîòåêè!')
								end
								imgui.Separator()

								if imgui.BeginPopupModal(fa.KEYBOARD .. u8 ' Íàñòðîéêà êëàâèø', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
									imgui.SetWindowSizeVec2(imgui.ImVec2(600 * MONET_DPI_SCALE, 425 * MONET_DPI_SCALE))
									if settings.general.use_binds and hotkey_no_errors then
										imgui.Separator()
										imgui.CenterText(u8 'Îòêðûòèå ãëàâíîãî ìåíþ õåëïåðà (àíàëîã /ph):')
										local width = imgui.GetWindowWidth()
										local calc = imgui.CalcTextSize(getNameKeysFrom(settings.general.bind_mainmenu))
										imgui.SetCursorPosX(width / 2 - calc.x / 2)
										if MainMenuHotKey:ShowHotKey() then
											settings.general.bind_mainmenu = encodeJson(MainMenuHotKey:GetHotKey())
											save_settings()
										end
										imgui.Separator()
										imgui.CenterText(u8 'Îòêðûòèå áûñòðîãî ìåíþ âçàèìîäåéñòâèÿ ñ èãðîêîì (àíàëîã /jm):')
										imgui.CenterText(u8 'Íàâåñòèñü íà èãðîêà ÷åðåç ÏÊÌ è íàæàòü')
										local width = imgui.GetWindowWidth()
										local calc = imgui.CalcTextSize(getNameKeysFrom(settings.general.bind_fastmenu))
										imgui.SetCursorPosX(width / 2 - calc.x / 2)
										if FastMenuHotKey:ShowHotKey() then
											settings.general.bind_fastmenu = encodeJson(FastMenuHotKey:GetHotKey())
											save_settings()
										end
										imgui.Separator()
										imgui.CenterText(u8 'Îòêðûòèå áûñòðîãî ìåíþ óïðàâëåíèÿ èãðîêîì (àíàëîã /jlm):')
										imgui.CenterText(u8 'Íàâåñòèñü íà èãðîêà ÷åðåç ÏÊÌ è íàæàòü')
										local width = imgui.GetWindowWidth()
										local calc = imgui.CalcTextSize(getNameKeysFrom(settings.general
											.bind_leader_fastmenu))
										imgui.SetCursorPosX(width / 2 - calc.x / 2)
										if LeaderFastMenuHotKey:ShowHotKey() then
											settings.general.bind_leader_fastmenu = encodeJson(LeaderFastMenuHotKey
												:GetHotKey())
											save_settings()
										end

										imgui.Separator()
										imgui.CenterText(u8 'Ïðèîñòàíîâèòü îòûãðîâêó êîìàíäû (àíàëîã /stop):')
										local width = imgui.GetWindowWidth()
										local calc = imgui.CalcTextSize(getNameKeysFrom(settings.general
											.bind_command_stop))
										imgui.SetCursorPosX(width / 2 - calc.x / 2)
										if CommandStopHotKey:ShowHotKey() then
											settings.general.bind_command_stop = encodeJson(CommandStopHotKey:GetHotKey())
											save_settings()
										end
										imgui.Separator()
										if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Çàêðûòü', imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * MONET_DPI_SCALE)) then
											imgui.CloseCurrentPopup()
										end
										imgui.Separator()
									end
									imgui.End()
								end
							end
							imgui.EndChild()
						end
						imgui.EndTabItem()
					end
					imgui.EndTabBar()
				end
				imgui.EndTabItem()
			end
			if imgui.BeginTabItem(fa.PLAY .. u8 ' Ôóíêöèè') then
				if imgui.BeginChild('##1', imgui.ImVec2(689 * MONET_DPI_SCALE, 195 * MONET_DPI_SCALE), true) then -- Ðàçìåðû ïåðâîé âêëàäêè
					imgui.CenterText(fa.USER_NURSE .. u8 ' Íàñòðîéêè ðàáîòû')
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8 "Èíôîðìàöèÿ î êîëè÷åñòâå ðàáîòû")
					imgui.SameLine(nil, 5)
					imgui.TextDisabled("[?]")
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8 "Îòîáðàæåíèå íà ýêðàíå ìåíþøêè ñ èíôîðìàöèåé")
					end
					imgui.SetColumnWidth(-1, 280 * MONET_DPI_SCALE) -- Äëèíà íàçâàíèÿ ïóíêòà
					imgui.NextColumn()
					if settings.player_organization.use_infojob_menu then
						imgui.CenterColumnText(u8 'Âêëþ÷åíî')
					else
						imgui.CenterColumnText(u8 'Îòêëþ÷åíî')
					end
					imgui.SetColumnWidth(-1, 300 * MONET_DPI_SCALE) -- Äëèíà îïèñàíèå ïóíêòà
					imgui.NextColumn()
					if settings.player_organization.use_infojob_menu then
						if imgui.CenterColumnSmallButton(u8 'Îòêëþ÷èòü##info_menu') then
							settings.player_organization.use_infojob_menu = false
							JobInformationWindow[0] = false
							save_settings()
						end
					else
						if imgui.CenterColumnSmallButton(u8 'Âêëþ÷èòü##info_menu') then
							settings.player_organization.use_infojob_menu = true
							JobInformationWindow[0] = true
							save_settings()
						end
					end
					imgui.SetColumnWidth(-1, 100 * MONET_DPI_SCALE) -- Ðàçìåð êíîïêè
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8 "Ñîñòîÿíèå ïîñòà:")
					imgui.SameLine(nil, 5)
					imgui.TextDisabled("[?]")
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8 "Ñîñòîÿíèå ïîñòà â àâòîäîêëàä(/r).")
					end
					imgui.SetColumnWidth(-1, 280 * MONET_DPI_SCALE) -- Äëèíà ïåðâîãî ñòîëáöà
					imgui.NextColumn()
					if checkbox_accent_enable[0] then
						imgui.CenterColumnText(u8(settings.general.post_status))
					end
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8 'Èçìåíèòü##post_status') then
						imgui.OpenPopup(fa.BUILDING_SHIELD .. u8 ' Ñîñòîÿíèå ïîñòà##post_status')
					end
					imgui.SetColumnWidth(-1, 300 * MONET_DPI_SCALE) -- Äëèíà âòîðîãî ñòîëáöà
					if imgui.BeginPopupModal(fa.BUILDING_SHIELD .. u8 ' Ñîñòîÿíèå ïîñòà##post_status', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
						imgui.PushItemWidth(405 * MONET_DPI_SCALE)
						imgui.InputText(u8 '##input_post_status', input_post_status, 256)
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Îòìåíà', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8 ' Ñîõðàíèòü', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
							settings.general.post_status = u8:decode(ffi.string(input_post_status))
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8 "Ðåæèì àâòîäîêëàäà")
					imgui.SameLine(nil, 5)
					imgui.TextDisabled("[?]")
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8 "Âñòàâàÿ íà ïîñò áóäåò ïðîèñõîäèòü àâòîìàòè÷åñêè äîêëàä â ðàöèþ îðãàíèçàöèè(/r).")
					end
					imgui.NextColumn()
					if settings.general.auto_doklad then
						imgui.CenterColumnText(u8 'Âêëþ÷åíî')
					else
						imgui.CenterColumnText(u8 'Îòêëþ÷åíî')
					end
					imgui.NextColumn()
					if settings.general.auto_doklad then
						if imgui.CenterColumnSmallButton(u8 'Îòêëþ÷èòü##auto_doklad') then
							settings.general.auto_doklad = false
							save_settings()
						end
					else
						if imgui.CenterColumnSmallButton(u8 'Âêëþ÷èòü##auto_doklad') then
							settings.general.auto_doklad = true
							save_settings()
						end
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8 "Êîëè÷åñòâî ñîçäàííûõ ïàòðîíîâ:")
					imgui.SameLine(nil, 5)
					imgui.TextDisabled("[?]")
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8 "Çà âñ¸ âðåìÿ êîëè÷åñòâî èçãîòîâëåííûõ ìàòåðèàëîâ.")
					end
					imgui.NextColumn()
					imgui.CenterColumnText(tostring(settings.player_organization.materials))
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8 "Îáíîâèòü##materials") then
						check_jobs = true
						sampSendChat('/jobprogress')
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8 "Êîëè÷åñòâî ïîñòàâîê â ÌÞ:")
					imgui.SameLine(nil, 5)
					imgui.TextDisabled("[?]")
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8 "Ñòàòèñòèêà âûïîëíåííûõ ïîñòàâîê íà ôóðå â ÌÞ.")
					end
					imgui.NextColumn()
					imgui.CenterColumnText(tostring(settings.player_organization.postavki_materials))
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8 "Îáíîâèòü##materials") then
						check_jobs = true
						sampSendChat('/jobprogress')
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8 "Êîëè÷åñòâî ïîñòàâîê èíãðåäèåíòîâ:")
					imgui.SameLine(nil, 5)
					imgui.TextDisabled("[?]")
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8 "Ñòàòèñòèêà âûïîëíåííûõ ïîñòàâîê íà êàðãîáîáå â ÌÎ è ÒÑÐ.")
					end
					imgui.NextColumn()
					imgui.CenterColumnText(tostring(settings.player_organization.postavki_kargobob))
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8 "Îáíîâèòü##materials") then
						check_jobs = true
						sampSendChat('/jobprogress')
					end
					imgui.Columns(1)

					imgui.EndChild()
				end
				imgui.EndTabItem()
			end
			if imgui.BeginTabItem(fa.STAR .. u8 'Ïîëîæåíèå') then
				if imgui.BeginChild('##smartRPTP', imgui.ImVec2(690 * MONET_DPI_SCALE, 354 * MONET_DPI_SCALE), true) then -- Ðàçìåðû îêíà "Ïîëîæåíèå"
					imgui.CenterText(fa.STAR .. u8 'Ðåãëàìåíò ïîâûøåíèÿ ñðîêà çàêëþ÷¸ííûì')
					imgui.Separator()
					imgui.SetCursorPosY(300 * MONET_DPI_SCALE) -- Îòñòóï êíîïêè "Çàãðóçèòü" îò âåðõíåãî êðàÿ
					imgui.SetCursorPosX(10 * MONET_DPI_SCALE) -- Îòñòóï êíîïêè "Çàãðóçèòü" îò ëåâîãî êðàÿ
					if imgui.Button(fa.DOWNLOAD .. u8 ' Çàãðóçèòü ##SmartRPTP') then
						if getARZServerNumber() ~= 0 then
							download_smartRPTP = true
							downloadFileFromUrlToPath(
								'https://raw.githubusercontent.com/WF-Helpers-MODS/Prison-Helper/refs/heads/main/Prison%20Helper/' ..
								getARZServerNumber() .. '/SmartRPTP.json', path_rptp) -- Ññûëêà íà ôàéë ñ ðåãëàìåíòîì ïîâûøåíèÿ ñðîêà çàêëþ÷¸ííûì
							imgui.OpenPopup(fa.CIRCLE_INFO .. u8 ' Prison Helper - Îïîâåùåíèå##donwloadsmartRPTP')
						else
							imgui.OpenPopup(fa.CIRCLE_INFO .. u8 ' Prison Helper - Îïîâåùåíèå##nocloudsmartRPTP')
						end
					end
					if imgui.BeginPopupModal(fa.CIRCLE_INFO .. u8 ' Prison Helper - Îïîâåùåíèå##nocloudsmartRPTP', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
						imgui.CenterText(u8 'Â áàçå äàííûõ åù¸ íåòó ðåãëàìåíòà ïîâûøåíèÿ ñðîêà çàêëþ÷¸ííûì äëÿ âàøåãî ñåðâåðà!')
						imgui.Separator()
						imgui.CenterText(u8 'Âû ìîæåòå âðó÷íóþ çàïîëíèòü åãî ïî êíîïêå "Îòðåäàêòèðîâàòü"')
						imgui.CenterText(u8 'Çàòåì âû ñìîæåòå ïîäåëèòüñÿ èì íà íàøåì Discord è îí áóäåò çàãðóæåí â áàçó äàííûõ')
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Õîðîøî', imgui.ImVec2(550 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
							imgui.CloseCurrentPopup()
						end
						imgui.EndPopup()
					end
					if imgui.BeginPopupModal(fa.CIRCLE_INFO .. u8 ' Prison Helper - Îïîâåùåíèå##donwloadsmartRPTP', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
						if download_smartRPTP then
							imgui.CenterText(u8 'Åñëè âû âèäèòå ýòî îêíî çíà÷èò èä¸ò ñêà÷èâàíèå ðåãëàìåíòà ïîâûøåíèÿ ñðîêà çàêëþ÷¸ííûì äëÿ ' ..
								getARZServerNumber() .. u8 ' ñåðâåðà!')
							imgui.CenterText(u8 'Ïîñëå çàâåðåøåíèÿ çàãðóçêè ýòî îêíî ïðîïàä¸ò è âû óâèäèòå ñîîáùåíèå â ÷àòå!')
							imgui.Separator()
							imgui.CenterText(u8 'Åñëè æå íè÷åãî íå ïðîèñõîäèò, çíà÷èò ïðîèçîøëà îøèáêà ñêà÷èâàíèÿ smartRPTP.json')
							imgui.CenterText(u8 'Âîçìîæíî â áàçå äàííûõ íåòó ôàéëà èìåííî äëÿ âàøåãî ñåðâåðà!')
							imgui.Separator()
							imgui.CenterText(u8 'Â ýòîì ñëó÷àå âû ìîæåòå âðó÷íóþ çàïîëíèòü åãî ïî êíîïêå "Îòðåäàêòèðîâàòü"')
							imgui.CenterText(u8 'Çàòåì âû ñìîæåòå ïîäåëèòüñÿ èì íà íàøåì Discord è îí áóäåò çàãðóæåí â áàçó äàííûõ')
							imgui.CenterText(u8 'Âàì íàäî áóäåò ñêèíóòü ôàéë smartRPTP.json , êîòîðûé íàõîäèòüñÿ ïî ïóòè:')
							imgui.CenterText(u8(path_rptp))
							imgui.Separator()
						else
							imgui.CloseCurrentPopup()
						end
						if imgui.Button(fa.CIRCLE_INFO .. u8 ' Õîðîøî', imgui.ImVec2(550 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
							imgui.CloseCurrentPopup()
						end
						imgui.EndPopup()
					end
					imgui.SetCursorPosY(300 * MONET_DPI_SCALE) -- Îòñòóï êíîïêè "Îòðåäàêòèðîâàòü" îò âåðõíåãî êðàÿ
					imgui.SetCursorPosX(540 * MONET_DPI_SCALE) -- Îòñòóï êíîïêè "Îòðåäàêòèðîâàòü" îò ëåâîãî êðàÿ
					if imgui.Button(fa.PEN_TO_SQUARE .. u8 ' Îòðåäàêòèðîâàòü ##smartRPTP') then
						imgui.OpenPopup(fa.STAR .. u8 ' Ðåãëàìåíò ïîâûøåíèÿ ñðîêà çàêëþ÷¸ííûì##smartRPTP')
					end
					imgui.SetCursorPosY(250 * MONET_DPI_SCALE)
					imgui.CenterText(u8('Èñïîëüçîâàíèå: /sum [ID èãðîêà]'))
					if imgui.BeginPopupModal(fa.STAR .. u8 ' Ðåãëàìåíò ïîâûøåíèÿ ñðîêà çàêëþ÷¸ííûì##smartRPTP', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
						imgui.BeginChild('##smartRPTPedit', imgui.ImVec2(589 * MONET_DPI_SCALE, 360 * MONET_DPI_SCALE),
							true)
						for chapter_index, chapter in ipairs(smart_rptp) do
							imgui.Columns(2)
							imgui.BulletText(u8(chapter.name))
							imgui.SetColumnWidth(-1, 515 * MONET_DPI_SCALE)
							imgui.NextColumn()
							if imgui.Button(fa.PEN_TO_SQUARE .. '##' .. chapter_index) then
								imgui.OpenPopup(u8(chapter.name) .. '##' .. chapter_index)
							end
							imgui.SameLine()
							if imgui.Button(fa.TRASH_CAN .. '##' .. chapter_index) then
								imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION ..
									u8 ' Prison Helper - Ïðåäóïðåæäåíèå ##' .. chapter_index)
							end
							if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8 ' Prison Helper - Ïðåäóïðåæäåíèå ##' .. chapter_index, _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
								imgui.CenterText(u8 'Âû äåéñòâèòåëüíî õîòèòå óäàëèòü ïóíêò?')
								imgui.CenterText(u8(chapter.name))
								imgui.Separator()
								if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Íåò, îòìåíèòü', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
									imgui.CloseCurrentPopup()
								end
								imgui.SameLine()
								if imgui.Button(fa.TRASH_CAN .. u8 ' Äà, óäàëèòü', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
									table.remove(smart_rptp, chapter_index)
									save_smart_rptp()
									imgui.CloseCurrentPopup()
								end
								imgui.End()
							end
							imgui.SetColumnWidth(-1, 100 * MONET_DPI_SCALE)
							imgui.Columns(1)
							if imgui.BeginPopupModal(u8(chapter.name) .. '##' .. chapter_index, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
								if imgui.BeginChild('##smartRPTPedititem', imgui.ImVec2(589 * MONET_DPI_SCALE, 390 * MONET_DPI_SCALE), true) then
									if chapter.item then
										for index, item in ipairs(chapter.item) do
											imgui.Columns(2)
											imgui.BulletText(u8(item.text))
											imgui.SetColumnWidth(-1, 515 * MONET_DPI_SCALE)
											imgui.NextColumn()
											if imgui.Button(fa.PEN_TO_SQUARE .. '##' .. chapter_index .. '##' .. index) then
												input_smartRPTP_text = imgui.new.char[256](u8(item.text))
												input_smartRPTP_lvl = imgui.new.char[256](u8(item.lvl))
												input_smartRPTP_reason = imgui.new.char[256](u8(item.reason))
												imgui.OpenPopup(fa.PEN_TO_SQUARE ..
													u8(" Ðåäàêòèðîâàíèå ïîäïóíêòà##") ..
													chapter.name .. index .. chapter_index)
											end
											if imgui.BeginPopupModal(fa.PEN_TO_SQUARE .. u8(" Ðåäàêòèðîâàíèå ïîäïóíêòà##") .. chapter.name .. index .. chapter_index, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
												if imgui.BeginChild('##smartRPTPedititeminput', imgui.ImVec2(489 * MONET_DPI_SCALE, 155 * MONET_DPI_SCALE), true) then
													imgui.CenterText(u8 'Íàçâàíèå ïîäïóíêòà:')
													imgui.PushItemWidth(478 * MONET_DPI_SCALE)
													imgui.InputText(u8 '##input_smartRPTP_text', input_smartRPTP_text,
														256)
													imgui.CenterText(u8 'Óðîâåíü ïîâûøåíèÿ ñðîêà äëÿ âûäà÷è (îò 1 äî 10):')
													imgui.PushItemWidth(478 * MONET_DPI_SCALE)
													imgui.InputText(u8 '##input_smartRPTP_lvl', input_smartRPTP_lvl, 256)
													imgui.CenterText(u8 'Ïðè÷èíà äëÿ ïîâûøåíèÿ ñðîêà:')
													imgui.PushItemWidth(478 * MONET_DPI_SCALE)
													imgui.InputText(u8 '##input_smartRPTP_reason', input_smartRPTP_reason,
														256)
													imgui.EndChild()
												end
												if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Îòìåíà', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
													imgui.CloseCurrentPopup()
												end
												imgui.SameLine()
												if imgui.Button(fa.FLOPPY_DISK .. u8 ' Ñîõðàíèòü', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
													if u8:decode(ffi.string(input_smartRPTP_lvl)) ~= '' and not u8:decode(ffi.string(input_smartRPTP_lvl)):find('%D') and tonumber(u8:decode(ffi.string(input_smartRPTP_lvl))) >= 1 and tonumber(u8:decode(ffi.string(input_smartRPTP_lvl))) <= 6 and u8:decode(ffi.string(input_smartRPTP_text)) ~= '' and u8:decode(ffi.string(input_smartRPTP_reason)) ~= '' then
														item.text = u8:decode(ffi.string(input_smartRPTP_text))
														item.lvl = u8:decode(ffi.string(input_smartRPTP_lvl))
														item.reason = u8:decode(ffi.string(input_smartRPTP_reason))
														save_smart_rptp()
														imgui.CloseCurrentPopup()
													else
														sampAddChatMessage(
															'[Prison Helper] {ffffff}Îøèáêà â óêàçàííûõ äàííûõ, èñïðàâüòå!',
															message_color)
													end
												end
												imgui.EndPopup()
											end
											imgui.SameLine()
											if imgui.Button(fa.TRASH_CAN .. '##' .. chapter_index .. '##' .. index) then
												imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION ..
													u8 ' Prison Helper - Ïðåäóïðåæäåíèå ##' ..
													chapter_index .. '##' .. index)
											end
											if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8 ' Prison Helper - Ïðåäóïðåæäåíèå ##' .. chapter_index .. '##' .. index, _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
												imgui.CenterText(u8 'Âû äåéñòâèòåëüíî õîòèòå óäàëèòü ïîäïóíêò?')
												imgui.CenterText(u8(item.text))
												imgui.Separator()
												if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Íåò, îòìåíèòü', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
													imgui.CloseCurrentPopup()
												end
												imgui.SameLine()
												if imgui.Button(fa.TRASH_CAN .. u8 ' Äà, óäàëèòü', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
													table.remove(chapter.item, index)
													save_smart_rptp()
													imgui.CloseCurrentPopup()
												end
												imgui.End()
											end
											imgui.SetColumnWidth(-1, 100 * MONET_DPI_SCALE)
											imgui.Columns(1)
											imgui.Separator()
										end
									end
									imgui.EndChild()
								end
								if imgui.Button(fa.CIRCLE_PLUS .. u8 ' Äîáàâèòü íîâûé ïîäïóíêò', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * MONET_DPI_SCALE)) then
									input_smartRPTP_text = imgui.new.char[256](u8(''))
									input_smartRPTP_lvl = imgui.new.char[256](u8(''))
									input_smartRPTP_reason = imgui.new.char[256](u8(''))
									imgui.OpenPopup(fa.CIRCLE_PLUS .. u8(' Äîáàâëåíèå íîâîãî ïîäïóíêòà'))
								end
								if imgui.BeginPopupModal(fa.CIRCLE_PLUS .. u8(' Äîáàâëåíèå íîâîãî ïîäïóíêòà'), _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
									if imgui.BeginChild('##smartRPTPedititeminput', imgui.ImVec2(489 * MONET_DPI_SCALE, 155 * MONET_DPI_SCALE), true) then
										imgui.CenterText(u8 'Íàçâàíèå ïîäïóíêòà:')
										imgui.PushItemWidth(478 * MONET_DPI_SCALE)
										imgui.InputText(u8 '##input_smartRPTP_text', input_smartRPTP_text, 256)
										imgui.CenterText(u8 'Óðîâåíü ðîçûñêà äëÿ âûäà÷è (îò 1 äî 6):')
										imgui.PushItemWidth(478 * MONET_DPI_SCALE)
										imgui.InputText(u8 '##input_smartRPTP_lvl', input_smartRPTP_lvl, 256)
										imgui.CenterText(u8 'Ïðè÷èíà äëÿ âûäà÷è ðîçûñêà:')
										imgui.PushItemWidth(478 * MONET_DPI_SCALE)
										imgui.InputText(u8 '##input_smartRPTP_reason', input_smartRPTP_reason, 256)
										imgui.EndChild()
									end
									if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Îòìåíà', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
										imgui.CloseCurrentPopup()
									end
									imgui.SameLine()
									if imgui.Button(fa.FLOPPY_DISK .. u8 ' Ñîõðàíèòü', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
										local text = u8:decode(ffi.string(input_smartRPTP_text))
										local lvl = u8:decode(ffi.string(input_smartRPTP_lvl))
										local reason = u8:decode(ffi.string(input_smartRPTP_reason))
										if lvl ~= '' and not tostring(lvl):find('%D') and tonumber(lvl) >= 1 and tonumber(lvl) <= 6 and text ~= '' and reason ~= '' then
											local temp = { text = text, lvl = lvl, reason = reason }
											table.insert(chapter.item, temp)
											save_smart_rptp()
											imgui.CloseCurrentPopup()
										else
											sampAddChatMessage(
												'[Prison Helper] {ffffff}Îøèáêà â óêàçàííûõ äàííûõ, èñïðàâüòå!',
												message_color)
										end
									end
									imgui.EndPopup()
								end
								imgui.SameLine()
								if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Çàêðûòü', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * MONET_DPI_SCALE)) then
									imgui.CloseCurrentPopup()
								end
								imgui.EndPopup()
							end
							imgui.Separator()
						end
						imgui.EndChild()
						if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Äîáàâèòü ïóíêò', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
							input_smartRPTP_name = imgui.new.char[256](u8(''))
							imgui.OpenPopup(fa.CIRCLE_PLUS .. u8 ' Äîáàâëåíèå íîâîãî ïóíêòà')
						end
						if imgui.BeginPopupModal(fa.CIRCLE_PLUS .. u8 ' Äîáàâëåíèå íîâîãî ïóíêòà', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
							imgui.CenterText(u8('Ââåäèòå íàçâàíèå/íîìåð ïóíêòà è íàæìèòå "Ñîõðàíèòü"'))
							imgui.PushItemWidth(500 * MONET_DPI_SCALE)
							imgui.InputText(u8 '##input_smartRPTP_name', input_smartRPTP_name, 256)
							imgui.CenterText(u8 'Îáðàòèòå âíèìàíèå, âû íå ñìîæåòå èçìåíèòü åãî â äàëüíåéøåì!')
							if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Îòìåíà', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
								imgui.CloseCurrentPopup()
							end
							imgui.SameLine()
							if imgui.Button(fa.CIRCLE_PLUS .. u8 ' Äîáàâèòü', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
								local temp = u8:decode(ffi.string(input_smartRPTP_name))
								local new_chapter = { name = temp, item = {} }
								table.insert(smart_rptp, new_chapter)
								save_smart_rptp()
								imgui.CloseCurrentPopup()
							end
							imgui.EndPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Çàêðûòü', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
							imgui.CloseCurrentPopup()
						end
						imgui.EndPopup()
					end
					imgui.EndChild()
				end
				imgui.CenterText(u8 'Ïðåäëîæåíèÿ ïî èçìåíåíèþ ðåãëàìåíòà ïîâûøåíèÿ ñðîêà îòïðàâëÿéòå â Discord.')
				imgui.EndTabItem()
			end
			if imgui.BeginTabItem(fa.FILE_PEN .. u8 ' Çàìåòêè') then
				imgui.BeginChild('##1', imgui.ImVec2(690 * MONET_DPI_SCALE, 340 * MONET_DPI_SCALE), true) -- Ðàçìåðû âêëàäêè "Çàìåòêè" (Y - 340px; X-690px)
				imgui.Columns(2)
				imgui.CenterColumnText(u8 "Ñïèñîê âñåõ âàøèõ çàìåòîê/øïàðãàëîê:")
				imgui.SetColumnWidth(-1, 595 * MONET_DPI_SCALE)
				imgui.NextColumn()
				imgui.CenterColumnText(u8 "Äåéñòâèå")
				imgui.SetColumnWidth(-1, 150 * MONET_DPI_SCALE)
				imgui.Columns(1)
				imgui.Separator()
				for i, note in ipairs(notes.note) do
					imgui.Columns(2)
					imgui.CenterColumnText(u8(note.note_name))
					imgui.NextColumn()
					if imgui.SmallButton(fa.UP_RIGHT_FROM_SQUARE .. '##' .. i) then
						show_note_name = u8(note.note_name)
						show_note_text = u8(note.note_text)
						NoteWindow[0] = true
					end
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8 'Îòêðûòü çàìåòêó "' .. u8(note.note_name) .. '"')
					end
					imgui.SameLine()
					if imgui.SmallButton(fa.PEN_TO_SQUARE .. '##' .. i) then
						local note_text = note.note_text:gsub('&', '\n')
						input_text_note = imgui.new.char[16384](u8(note_text))
						input_name_note = imgui.new.char[256](u8(note.note_name))
						imgui.OpenPopup(fa.PEN_TO_SQUARE .. u8 ' Èçìåíåíèå çàìåòêè' .. '##' .. i)
					end
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8 'Ðåäàêòèðîâàíèå çàìåòêè "' .. u8(note.note_name) .. '"')
					end
					if imgui.BeginPopupModal(fa.PEN_TO_SQUARE .. u8 ' Èçìåíåíèå çàìåòêè' .. '##' .. i, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
						if imgui.BeginChild('##9992', imgui.ImVec2(589 * MONET_DPI_SCALE, 360 * MONET_DPI_SCALE), true) then
							imgui.PushItemWidth(578 * MONET_DPI_SCALE)
							imgui.InputText(u8 '##note_name', input_name_note, 256)
							imgui.InputTextMultiline("##note_text", input_text_note, 16384,
								imgui.ImVec2(578 * MONET_DPI_SCALE, 320 * MONET_DPI_SCALE))
							imgui.EndChild()
						end
						if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Îòìåíà', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8 ' Ñîõðàíèòü çàìåòêó', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
							note.note_name = u8:decode(ffi.string(input_name_note))
							local temp = u8:decode(ffi.string(input_text_note))
							note.note_text = temp:gsub('\n', '&')
							save_notes()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.SameLine()
					if imgui.SmallButton(fa.TRASH_CAN .. '##' .. i) then
						imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8 ' Ïðåäóïðåæäåíèå ##' .. note.note_name)
					end
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8 'Óäàëåíèå çàìåòêè "' .. u8(note.note_name) .. '"')
					end
					if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8 ' Ïðåäóïðåæäåíèå ##' .. note.note_name, _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
						imgui.CenterText(u8 'Âû äåéñòâèòåëüíî õîòèòå óäàëèòü çàìåòêó "' .. u8(note.note_name) .. '" ?')
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Íåò, îòìåíèòü', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.TRASH_CAN .. u8 ' Äà, óäàëèòü', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
							table.remove(notes.note, i)
							save_notes()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.Columns(1)
					imgui.Separator()
				end
				imgui.EndChild()
				if imgui.Button(fa.CIRCLE_PLUS .. u8 ' Ñîçäàòü íîâóþ çàìåòêó', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
					input_name_note = imgui.new.char[256](u8("Íàçâàíèå"))
					input_text_note = imgui.new.char[16384](u8("Òåêñò"))
					imgui.OpenPopup(fa.PEN_TO_SQUARE .. u8 ' Ñîçäàíèå çàìåòêè')
				end
				if imgui.BeginPopupModal(fa.PEN_TO_SQUARE .. u8 ' Ñîçäàíèå çàìåòêè', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoResize) then
					if imgui.BeginChild('##999999', imgui.ImVec2(589 * MONET_DPI_SCALE, 360 * MONET_DPI_SCALE), true) then
						imgui.PushItemWidth(578 * MONET_DPI_SCALE)
						imgui.InputText(u8 '##note_name', input_name_note, 256)
						imgui.InputTextMultiline("##note_text", input_text_note, 16384,
							imgui.ImVec2(578 * MONET_DPI_SCALE, 320 * MONET_DPI_SCALE))
						imgui.EndChild()
					end
					if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Îòìåíà', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
						imgui.CloseCurrentPopup()
					end
					imgui.SameLine()
					if imgui.Button(fa.FLOPPY_DISK .. u8 ' Ñîçäàòü çàìåòêó', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
						local temp = u8:decode(ffi.string(input_text_note))
						local new_note = {
							note_name = u8:decode(ffi.string(input_name_note)),
							note_text = temp:gsub(
								'\n', '&')
						}
						table.insert(notes.note, new_note)
						save_notes()
						imgui.CloseCurrentPopup()
					end
					imgui.End()
				end
				imgui.EndTabItem()
			end
			if imgui.BeginTabItem(fa.GEAR .. u8 ' Íàñòðîéêè') then
				imgui.BeginChild('##1', imgui.ImVec2(690 * MONET_DPI_SCALE, 180 * MONET_DPI_SCALE), true) -- Ðàçìåðû âêëàäêè "Íàñòðîéêè"
				imgui.CenterText(fa.CIRCLE_INFO .. u8 ' Äîïîëíèòåëüíàÿ èíôîðìàöèÿ ïðî õåëïåð')
				imgui.Separator()
				imgui.Text(fa.CIRCLE_USER .. u8 " Ðàçðàáîò÷èê äàííîãî õåëïåðà: MTG MODS")
				imgui.Separator()
				imgui.Text(fa.CIRCLE_INFO .. u8 " Óñòàíîâëåííàÿ âåðñèÿ õåëïåðà: " .. u8(thisScript().version))
				imgui.SameLine()
				if imgui.SmallButton(u8 'Ïðîâåðèòü îáíîâëåíèÿ') then
					local result, check = pcall(check_update)
					if not result then
						sampAddChatMessage(
							'[Prison Helper] {ffffff}Ïðîèçîøëà îøèáêà ïðè ïîïûòêå ïðîâåðèòü íàëè÷èå îáíîâëåíèé!',
							message_color)
					end
				end
				imgui.Separator()
				imgui.Text(fa.BOOK .. u8 " Ãàéä ïî èñïîëüçîâàíèþ õåëïåðà:")
				imgui.SameLine()
				if imgui.SmallButton(u8 'https://youtu.be/dvTe0A61Hjw') then
					openLink('https://youtu.be/dvTe0A61Hjw')
				end
				imgui.Separator()
				imgui.Text(fa.HEADSET .. u8 " Òåõ.ïîääåðæêà ïî õåëïåðó:")
				imgui.SameLine()
				if imgui.SmallButton('https://discord.gg/mtgmods-samp') then
					openLink('https://discord.gg/mtgmods-samp')
				end
				imgui.SameLine()
				if imgui.SmallButton(u8 'ðåçåðâíàÿ ññûëêà') then
					openLink('https://discord.com/invite/mtg-mods-samp-1097643847774908526')
				end
				imgui.Separator()
				imgui.Text(fa.GLOBE .. u8 " Òåìà õåëïåðà íà ôîðóìå BlastHack:")
				imgui.SameLine()
				if imgui.SmallButton(u8 'https://www.blast.hk/threads/216130/') then
					openLink('https://www.blast.hk/threads/216130/')
				end
				imgui.Separator()
				imgui.Text(fa.HAND_HOLDING_DOLLAR .. u8 " Ïîääåðæàòü ðàçðàáîò÷èêà äîíàòîì:")
				imgui.SameLine()
				if imgui.SmallButton(u8 'Ïîëó÷èòü ðåêâèçèòû') then
					imgui.OpenPopup(fa.SACK_DOLLAR .. u8 ' Ïîääåðæêà ðàçðàáîò÷èêà')
				end
				if imgui.BeginPopupModal(fa.SACK_DOLLAR .. u8 ' Ïîääåðæêà ðàçðàáîò÷èêà', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoResize) then
					imgui.CenterText(u8 'Ðåêâèçèòû óêàçàíû íà íàøåì Discord ñåðâåðå òåõ.ïîääåðæêè')
					imgui.CenterText(u8 'Åñëè æå âû íå ìîæåòå çàéòè òóäà, òî ñâÿæèòåñü ñ MTG MODS:')
					imgui.SetCursorPosX(130 * MONET_DPI_SCALE)
					if imgui.Button(u8('Telegram')) then
						openLink('https://t.me/mtg_mods')
					end
					imgui.SameLine()
					if imgui.Button(u8('Discord')) then
						openLink('https://discordapp.com/users/514135796685602827')
					end
					imgui.SameLine()
					if imgui.Button(u8('VK')) then
						openLink('https://vk.com/mtgmods')
					end
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Çàêðûòü', imgui.ImVec2(400 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
						imgui.CloseCurrentPopup()
					end
					imgui.End()
				end
				imgui.EndChild()
				imgui.BeginChild('##3', imgui.ImVec2(689 * MONET_DPI_SCALE, 87 * MONET_DPI_SCALE), true)
				imgui.CenterText(fa.PALETTE .. u8 ' Öâåòîâàÿ òåìà õåëïåðà:')
				imgui.Separator()
				if imgui.RadioButtonIntPtr(u8 " Dark Theme ", theme, 0) then
					theme[0] = 0
					message_color = 0x6E6E6E
					message_color_hex = '{6E6E6E}'
					settings.general.moonmonet_theme_enable = false
					save_settings()

					apply_dark_theme()
				end
				if monet_no_errors then
					if imgui.RadioButtonIntPtr(u8 " MoonMonet Theme ", theme, 1) then
						theme[0] = 1
						local r, g, b = mmcolor[0] * 255, mmcolor[1] * 255, mmcolor[2] * 255
						local argb = join_argb(0, r, g, b)
						settings.general.moonmonet_theme_enable = true
						settings.general.moonmonet_theme_color = argb
						message_color = "0x" .. argbToHexWithoutAlpha(0, r, g, b)
						message_color_hex = '{' .. argbToHexWithoutAlpha(0, r, g, b) .. '}'
						apply_moonmonet_theme()
						save_settings()
					end
					imgui.SameLine()
					if theme[0] == 1 and imgui.ColorEdit3('## COLOR', mmcolor, imgui.ColorEditFlags.NoInputs) then
						local r, g, b = mmcolor[0] * 255, mmcolor[1] * 255, mmcolor[2] * 255
						local argb = join_argb(0, r, g, b)
						settings.general.moonmonet_theme_color = argb
						message_color = "0x" .. argbToHexWithoutAlpha(0, r, g, b)
						message_color_hex = '{' .. argbToHexWithoutAlpha(0, r, g, b) .. '}'
						if theme[0] == 1 then
							apply_moonmonet_theme()
							save_settings()
						end
					end
				else
					if imgui.RadioButtonIntPtr(u8 " MoonMonet Theme | " .. fa.TRIANGLE_EXCLAMATION .. u8 ' Îøèáêà: îòñóñòâóþò ôàéëû áèáëèîòåêè!', theme, 1) then
						theme[0] = 0
					end
				end
				imgui.EndChild()
				imgui.BeginChild("##2", imgui.ImVec2(689 * MONET_DPI_SCALE, 55 * MONET_DPI_SCALE), true)
				-- imgui.TextWrapped(u8('Íàøëè áàã èëè åñòü ïðåäëîæåíèå ïî óëó÷øåíèþ õåëïåðà? Ñîîáùèòå îá ýòîì íà íàøåì Discord ñåðâåðå èëè íà ôîðóìå BlastHack!'))
				-- imgui.TextWrapped(u8('Åñòü æåëàíèå  Âû ìîæåòå çàêèíóòü äîíàòèê! Ðåêâèçèòû åñòü íà íàøåì Discord ñåðâåðå.'))
				imgui.CenterText(u8 'Íàøëè áàã èëè åñòü ïðåäëîæåíèå ïî óëó÷øåíèþ õåëïåðà?')
				imgui.Separator()
				imgui.CenterText(u8 'Ñîîáùèòå îá ýòîì íà íàøåì Discord ñåðâåðå èëè íà ôîðóìå BlastHack!')
				imgui.EndChild()
				imgui.BeginChild("##4", imgui.ImVec2(689 * MONET_DPI_SCALE, 35 * MONET_DPI_SCALE), true)
				if imgui.Button(fa.POWER_OFF .. u8 " Âûêëþ÷åíèå ", imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * MONET_DPI_SCALE)) then
					imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8 ' Ïðåäóïðåæäåíèå ##off')
				end
				if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8 ' Ïðåäóïðåæäåíèå ##off', _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollbar) then
					imgui.CenterText(u8 'Âû äåéñòâèòåëüíî õîòèòå âûãðóçèòü (îòêëþ÷èòü) õåëïåð?')
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Íåò, îòìåíèòü', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
						imgui.CloseCurrentPopup()
					end
					imgui.SameLine()
					if imgui.Button(fa.POWER_OFF .. u8 ' Äà, âûãðóçèòü', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
						reload_script = true
						play_error_sound()
						sampAddChatMessage(
							'[Prison Helper] {ffffff}Õåëïåð ïðèîñòàíîâèë ñâîþ ðàáîòó äî ñëåäóùåãî âõîäà â èãðó!',
							message_color)
						if not isMonetLoader() then
							sampAddChatMessage(
								'[Prison Helper] {ffffff}Ëèáî èñïîëüçóéòå ' ..
								message_color_hex ..
								'CTRL {ffffff}+ ' .. message_color_hex .. 'R {ffffff}÷òîáû çàïóñòèòü õåëïåð.',
								message_color)
						end
						thisScript():unload()
					end
					imgui.End()
				end
				imgui.SameLine()
				if imgui.Button(fa.ROTATE_RIGHT .. u8 " Ïåðåçàãðóçêà ", imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * MONET_DPI_SCALE)) then
					reload_script = true
					thisScript():reload()
				end
				imgui.SameLine()
				if imgui.Button(fa.CLOCK_ROTATE_LEFT .. u8 " Ñáðîñ íàñòðîåê ", imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * MONET_DPI_SCALE)) then
					imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8 ' Ïðåäóïðåæäåíèå ##reset')
				end
				if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8 ' Ïðåäóïðåæäåíèå ##reset', _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
					imgui.CenterText(u8 'Âû äåéñòâèòåëüíî õîòèòå ñáðîñèòü âñå íàñòðîéêè õåëïåðà?')
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Íåò, îòìåíèòü', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
						imgui.CloseCurrentPopup()
					end
					imgui.SameLine()
					if imgui.Button(fa.CLOCK_ROTATE_LEFT .. u8 ' Äà, ñáðîñèòü', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
						play_error_sound()
						os.remove(path_rptp)
						os.remove(path_notes)
						os.remove(path_settings)
						os.remove(path_commands)
						imgui.CloseCurrentPopup()
						reload_script = true
						thisScript():reload()
					end
					imgui.End()
				end
				imgui.SameLine()
				if imgui.Button(fa.TRASH_CAN .. u8 " Óäàëåíèå ", imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * MONET_DPI_SCALE)) then
					imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8 ' Ïðåäóïðåæäåíèå ##delete')
				end
				if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8 ' Ïðåäóïðåæäåíèå ##delete', _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
					imgui.CenterText(u8 'Âû äåéñòâèòåëüíî õîòèòå óäàëèòü Prison Helper?')
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Íåò, îòìåíèòü', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
						imgui.CloseCurrentPopup()
					end
					imgui.SameLine()
					if imgui.Button(fa.TRASH_CAN .. u8 ' Äà, ÿ õî÷ó óäàëèòü', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
						sampAddChatMessage('[Prison Helper] {ffffff}Õåëïåð ïîëíîñòþ óäàë¸í èç âàøåãî óñòðîéñòâà!',
							message_color)
						sampShowDialog(999999, message_color_hex .. "Prison Helper",
							"Ìíå î÷åíü æàëü ÷òî âû óäàëèëè Prison Helper èç ñâîåãî óñòðîéñòâà.\nÅñëè óäàëåíèå ñâÿçàíî ñ íåãàòèâíûì îïûòîì èñïîëüçîâàíèÿ, è âû ñòàëêèâàëèñü ñ áàãàìè èëè ïðîáëåìàìè, òî\nñîîáùèòå ìíå ÷òî èìåííî çàñòàâèëî âàñ óäàëèòü õåëïåð íà íàøåì Discord ñåðâåðå èëè íà ôîðóìå BlastHack\n\nDiscord: https://discord.com/invite/qBPEYjfNhv\nBlastHack: https://www.blast.hk/threads/195388/\n\nÅñëè ÷òî, âû ìîæåòå çàíîâî ñêà÷àòü è óñòàíîâèòü õåëïåð â ëþáîé ìîìåíò :)",
							"Çàêðûòü", '', 0)
						reload_script = true
						play_error_sound()
						os.remove(path_helper)
						os.remove(path_settings)
						os.remove(path_commands)
						os.remove(path_rptp)
						os.remove(path_notes)
						thisScript():unload()
					end
					imgui.End()
				end
				imgui.EndChild()
				imgui.EndTabItem()
			end
			imgui.EndTabBar()
		end
		imgui.End()
	end
)

imgui.OnFrame(
	function() return DeportamentWindow[0] end,
	function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.WALKIE_TALKIE .. u8 " Ðàöèÿ äåïàðòàìåíòà", DeportamentWindow,
			imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize +
			imgui.WindowFlags.NoMove)
		imgui.BeginChild('##2', imgui.ImVec2(589 * MONET_DPI_SCALE, 160 * MONET_DPI_SCALE), true)
		imgui.Columns(3)
		imgui.CenterColumnText(u8('Âàø òåã:'))
		imgui.PushItemWidth(215 * MONET_DPI_SCALE)
		if imgui.InputText('##input_dep_tag1', input_dep_tag1, 256) then
			settings.deportament.dep_tag1 = u8:decode(ffi.string(input_dep_tag1))
			save_settings()
		end
		if imgui.CenterColumnButton(u8('Âûáðàòü òåã##1')) then
			imgui.OpenPopup(fa.TAG .. u8 ' Òåãè îðãàíèçàöèé##1')
		end
		if imgui.BeginPopupModal(fa.TAG .. u8 ' Òåãè îðãàíèçàöèé##1', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
			if imgui.BeginTabBar('TabTags') then
				if imgui.BeginTabItem(fa.BARS .. u8 ' Ñòàíäàðòíûå òåãè (ru) ') then
					local line_started = false
					for i, tag in ipairs(settings.deportament.dep_tags) do
						if tag ~= 'skip' then
							if line_started then
								imgui.SameLine()
							else
								line_started = true
							end
							if imgui.Button(' ' .. u8(tag) .. ' ##' .. i) then
								input_dep_tag1 = imgui.new.char[256](u8(tag))
								settings.deportament.dep_tag1 = u8:decode(ffi.string(input_dep_tag1))
								save_settings()
								imgui.CloseCurrentPopup()
							end
						else
							line_started = false
						end
					end
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Çàêðûòü', imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * MONET_DPI_SCALE)) then
						imgui.CloseCurrentPopup()
					end
					imgui.EndTabItem()
				end
				if imgui.BeginTabItem(fa.BARS .. u8 ' Ñòàíäàðòíûå òåãè (en) ') then
					local line_started = false
					for i, tag in ipairs(settings.deportament.dep_tags_en) do
						if tag ~= 'skip' then
							if line_started then
								imgui.SameLine()
							else
								line_started = true
							end
							if imgui.Button(' ' .. u8(tag) .. ' ##' .. i) then
								input_dep_tag1 = imgui.new.char[256](u8(tag))
								settings.deportament.dep_tag1 = u8:decode(ffi.string(input_dep_tag1))
								save_settings()
								imgui.CloseCurrentPopup()
							end
						else
							line_started = false
						end
					end
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Çàêðûòü', imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * MONET_DPI_SCALE)) then
						imgui.CloseCurrentPopup()
					end
					imgui.EndTabItem()
				end
				if imgui.BeginTabItem(fa.BARS .. u8 ' Âàøè êàñòîìíûå òåãè ') then
					local line_started = false
					for i, tag in ipairs(settings.deportament.dep_tags_custom) do
						if tag ~= 'skip' then
							if line_started then
								imgui.SameLine()
							else
								line_started = true
							end
							if imgui.Button(' ' .. u8(tag) .. ' ##' .. i) then
								input_dep_tag1 = imgui.new.char[256](u8(tag))
								settings.deportament.dep_tag1 = u8:decode(ffi.string(input_dep_tag1))
								save_settings()
								imgui.CloseCurrentPopup()
							end
						else
							line_started = false
						end
					end
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_PLUS .. u8 ' Äîáàâèòü òåã', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * MONET_DPI_SCALE)) then
						imgui.OpenPopup(fa.TAG .. u8 ' Äîáàâëåíèå íîâîãî òåãà##1')
					end
					if imgui.BeginPopupModal(fa.TAG .. u8 ' Äîáàâëåíèå íîâîãî òåãà##1', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
						imgui.PushItemWidth(215 * MONET_DPI_SCALE)
						imgui.InputText('##input_dep_new_tag', input_dep_new_tag, 256)
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Îòìåíà', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * MONET_DPI_SCALE)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8 ' Ñîõðàíèòü', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * MONET_DPI_SCALE)) then
							table.insert(settings.deportament.dep_tags_custom, u8:decode(ffi.string(input_dep_new_tag)))
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.SameLine()
					if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Çàêðûòü', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * MONET_DPI_SCALE)) then
						imgui.CloseCurrentPopup()
					end
					imgui.EndTabItem()
				end
				imgui.EndTabBar()
			end
			imgui.End()
		end
		imgui.SetColumnWidth(-1, 230 * MONET_DPI_SCALE)
		imgui.NextColumn()
		imgui.CenterColumnText(u8('×àñòîòà ðàöèè:'))
		imgui.PushItemWidth(140 * MONET_DPI_SCALE)
		if imgui.InputText('##input_dep_fm', input_dep_fm, 256) then
			settings.deportament.dep_fm = u8:decode(ffi.string(input_dep_fm))
			save_settings()
		end
		if imgui.CenterColumnButton(u8('Âûáðàòü ÷àñòîòó##1')) then
			imgui.OpenPopup(fa.WALKIE_TALKIE .. u8 ' ×àñòîòà ðàöèè /d')
		end
		if imgui.BeginPopupModal(fa.WALKIE_TALKIE .. u8 ' ×àñòîòà ðàöèè /d', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
			for i, tag in ipairs(settings.deportament.dep_fms) do
				imgui.SameLine()
				if imgui.Button(' ' .. u8(tag) .. ' ##' .. i) then
					input_dep_fm = imgui.new.char[256](u8(tag))
					settings.deportament.dep_fm = u8:decode(ffi.string(input_dep_fm))
					save_settings()
					imgui.CloseCurrentPopup()
				end
			end
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Çàêðûòü', imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * MONET_DPI_SCALE)) then
				imgui.CloseCurrentPopup()
			end
			imgui.End()
		end
		imgui.SetColumnWidth(-1, 150 * MONET_DPI_SCALE)
		imgui.NextColumn()
		imgui.CenterColumnText(u8('Òåã, ê êîìó âû îáðàùàåòåñü:'))
		imgui.PushItemWidth(195 * MONET_DPI_SCALE)
		if imgui.InputText('##input_dep_tag2', input_dep_tag2, 256) then
			settings.deportament.dep_tag2 = u8:decode(ffi.string(input_dep_tag2))
			save_settings()
		end
		if imgui.CenterColumnButton(u8('Âûáðàòü òåã##2')) then
			imgui.OpenPopup(fa.TAG .. u8 ' Òåãè îðãàíèçàöèé##2')
		end
		if imgui.BeginPopupModal(fa.TAG .. u8 ' Òåãè îðãàíèçàöèé##2', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
			if imgui.BeginTabBar('TabTags') then
				if imgui.BeginTabItem(fa.BARS .. u8 ' Ñòàíäàðòíûå òåãè (ru) ') then
					local line_started = false
					for i, tag in ipairs(settings.deportament.dep_tags) do
						if tag ~= 'skip' then
							if line_started then
								imgui.SameLine()
							else
								line_started = true
							end
							if imgui.Button(' ' .. u8(tag) .. ' ##' .. i) then
								input_dep_tag2 = imgui.new.char[256](u8(tag))
								settings.deportament.dep_tag2 = u8:decode(ffi.string(input_dep_tag2))
								save_settings()
								imgui.CloseCurrentPopup()
							end
						else
							line_started = false
						end
					end
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Çàêðûòü', imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * MONET_DPI_SCALE)) then
						imgui.CloseCurrentPopup()
					end
					imgui.EndTabItem()
				end
				if imgui.BeginTabItem(fa.BARS .. u8 ' Ñòàíäàðòíûå òåãè (en) ') then
					local line_started = false
					for i, tag in ipairs(settings.deportament.dep_tags_en) do
						if tag ~= 'skip' then
							if line_started then
								imgui.SameLine()
							else
								line_started = true
							end
							if imgui.Button(' ' .. u8(tag) .. ' ##' .. i) then
								input_dep_tag2 = imgui.new.char[256](u8(tag))
								settings.deportament.dep_tag2 = u8:decode(ffi.string(input_dep_tag2))
								save_settings()
								imgui.CloseCurrentPopup()
							end
						else
							line_started = false
						end
					end
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Çàêðûòü', imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * MONET_DPI_SCALE)) then
						imgui.CloseCurrentPopup()
					end
					imgui.EndTabItem()
				end
				if imgui.BeginTabItem(fa.BARS .. u8 ' Âàøè êàñòîìíûå òåãè ') then
					local line_started = false
					for i, tag in ipairs(settings.deportament.dep_tags_custom) do
						if tag ~= 'skip' then
							if line_started then
								imgui.SameLine()
							else
								line_started = true
							end
							if imgui.Button(' ' .. u8(tag) .. ' ##' .. i) then
								input_dep_tag2 = imgui.new.char[256](u8(tag))
								settings.deportament.dep_tag2 = u8:decode(ffi.string(input_dep_tag2))
								save_settings()
								imgui.CloseCurrentPopup()
							end
						else
							line_started = false
						end
					end
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_PLUS .. u8 ' Äîáàâèòü òåã', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * MONET_DPI_SCALE)) then
						imgui.OpenPopup(fa.TAG .. u8 ' Äîáàâëåíèå íîâîãî òåãà##2')
					end
					if imgui.BeginPopupModal(fa.TAG .. u8 ' Äîáàâëåíèå íîâîãî òåãà##2', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoResize) then
						imgui.PushItemWidth(215 * MONET_DPI_SCALE)
						imgui.InputText('##input_dep_new_tag', input_dep_new_tag, 256)
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Îòìåíà', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * MONET_DPI_SCALE)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8 ' Ñîõðàíèòü', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * MONET_DPI_SCALE)) then
							table.insert(settings.deportament.dep_tags_custom, u8:decode(ffi.string(input_dep_new_tag)))
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.SameLine()
					if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Çàêðûòü', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * MONET_DPI_SCALE)) then
						imgui.CloseCurrentPopup()
					end
					imgui.EndTabItem()
				end
				imgui.EndTabBar()
			end
			imgui.End()
		end
		imgui.SetColumnWidth(-1, 235 * MONET_DPI_SCALE)
		imgui.Columns(1)
		imgui.Separator()
		imgui.CenterText(u8('Òåêñò:'))
		imgui.PushItemWidth(490 * MONET_DPI_SCALE)
		imgui.InputText(u8 '##dep_input_text', input_dep_text, 256)
		imgui.SameLine()
		if imgui.Button(u8 ' Îòïðàâèòü ') then
			sampSendChat('/d ' ..
				u8:decode(ffi.string(input_dep_tag1)) ..
				' ' ..
				u8:decode(ffi.string(input_dep_fm)) ..
				' ' .. u8:decode(ffi.string(input_dep_tag2)) .. ' ' .. u8:decode(ffi.string(input_dep_text)))
		end
		imgui.Separator()
		imgui.CenterText(u8 'Ïðåäïðîñìîòð: /d ' ..
			u8(u8:decode(ffi.string(input_dep_tag1))) ..
			' ' ..
			u8(u8:decode(ffi.string(input_dep_fm))) ..
			' ' .. u8(u8:decode(ffi.string(input_dep_tag2))) .. ' ' .. u8(u8:decode(ffi.string(input_dep_text))))
		imgui.EndChild()
		imgui.End()
	end
)

imgui.OnFrame(
	function() return BinderWindow[0] end,
	function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(600 * MONET_DPI_SCALE, 425 * MONET_DPI_SCALE), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.PEN_TO_SQUARE .. u8 ' Ðåäàêòèðîâàíèå êîìàíäû /' .. change_cmd, BinderWindow,
			imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoResize)
		if imgui.BeginChild('##binder_edit', imgui.ImVec2(589 * MONET_DPI_SCALE, 361 * MONET_DPI_SCALE), true) then
			imgui.CenterText(fa.FILE_LINES .. u8 ' Îïèñàíèå êîìàíäû:')
			imgui.PushItemWidth(579 * MONET_DPI_SCALE)
			imgui.InputText("##input_description", input_description, 256)
			imgui.Separator()
			imgui.CenterText(fa.TERMINAL .. u8 ' Êîìàíäà äëÿ èñïîëüçîâàíèÿ â ÷àòå (áåç /):')
			imgui.PushItemWidth(579 * MONET_DPI_SCALE)
			imgui.InputText("##input_cmd", input_cmd, 256)
			imgui.Separator()
			imgui.CenterText(fa.CODE .. u8 ' Àðãóìåíòû êîòîðûå ïðèíèìàåò êîìàíäà:')
			imgui.Combo(u8 '', ComboTags, ImItems, #item_list)
			imgui.Separator()
			imgui.CenterText(fa.FILE_WORD .. u8 ' Òåêñòîâûé áèíä êîìàíäû:')
			imgui.InputTextMultiline("##text_multiple", input_text, 8192,
				imgui.ImVec2(579 * MONET_DPI_SCALE, 173 * MONET_DPI_SCALE))
			imgui.EndChild()
		end
		if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Îòìåíà', imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
			BinderWindow[0] = false
		end
		imgui.SameLine()
		if imgui.Button(fa.CLOCK .. u8 ' Çàäåðæêà', imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
			imgui.OpenPopup(fa.CLOCK .. u8 ' Çàäåðæêà (â ñåêóíäàõ) ')
		end
		if imgui.BeginPopupModal(fa.CLOCK .. u8 ' Çàäåðæêà (â ñåêóíäàõ) ', _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
			imgui.PushItemWidth(200 * MONET_DPI_SCALE)
			imgui.SliderFloat(u8 '##waiting', waiting_slider, 0.3, 600)
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Îòìåíà', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
				waiting_slider = imgui.new.float(tonumber(change_waiting))
				imgui.CloseCurrentPopup()
			end
			imgui.SameLine()
		end
		imgui.SameLine()
		if imgui.Button(fa.TAGS .. u8 ' Òýãè (1)', imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
			imgui.OpenPopup(fa.TAGS .. u8 ' Îñíîâíûå òýãè äëÿ èñïîëüçîâàíèÿ â áèíäåðå')
		end
		if imgui.BeginPopupModal(fa.TAGS .. u8 ' Îñíîâíûå òýãè äëÿ èñïîëüçîâàíèÿ â áèíäåðå', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove) then
			imgui.Text(u8(binder_tags_text))
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Çàêðûòü', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
				imgui.CloseCurrentPopup()
			end
			imgui.End()
		end
		imgui.SameLine()
		if imgui.Button(fa.TAGS .. u8 ' Òýãè (2)', imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
			imgui.OpenPopup(fa.TAGS .. u8 ' Äîïîëíèòåëüíûå òýãè äëÿ âçàèìîäåéñòâèÿ ñ êîäîì')
		end
		if imgui.BeginPopupModal(fa.TAGS .. u8 ' Äîïîëíèòåëüíûå òýãè äëÿ âçàèìîäåéñòâèÿ ñ êîäîì', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove) then
			imgui.CenterText(u8 'Èñïîëüçîâàòü î÷åíü àêóðàòíî, èíà÷å ìîæåòå ÷òî-òî ñëîìàòü!')
			imgui.Separator()
			imgui.Text(u8(binder_tags_text2))
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Çàêðûòü', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
				imgui.CloseCurrentPopup()
			end
			imgui.End()
		end
		imgui.SameLine()
		if imgui.Button(fa.FLOPPY_DISK .. u8 ' Ñîõðàíèòü', imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
			if ffi.string(input_cmd):find('%W') or ffi.string(input_cmd) == '' or ffi.string(input_description) == '' or ffi.string(input_text) == '' then
				imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8 ' Îøèáêà ñîõðàíåíèÿ êîìàíäû!')
			else
				local new_arg = ''
				if ComboTags[0] == 0 then
					new_arg = ''
				elseif ComboTags[0] == 1 then
					new_arg = '{arg}'
				elseif ComboTags[0] == 2 then
					new_arg = '{arg_id}'
				elseif ComboTags[0] == 3 then
					new_arg = '{arg_id} {arg2}'
				elseif ComboTags[0] == 4 then
					new_arg = '{arg_id} {arg2} {arg3}'
				elseif ComboTags[0] == 5 then
					new_arg = '{arg_id} {arg2} {arg3} {arg4}'
				end
				local new_waiting = waiting_slider[0]
				local new_description = u8:decode(ffi.string(input_description))
				local new_command = u8:decode(ffi.string(input_cmd))
				local new_text = u8:decode(ffi.string(input_text)):gsub('\n', '&')
				local temp_array = {}

				-- Ïðîâåðÿåì çíà÷åíèå binder_create_command_9_10
				if binder_create_command_9_10 then
					-- print("òåñò 1: binder_create_command_9_10 TRUE")
					temp_array = commands.commands_manage
					binder_create_command_9_10 = false -- Ñáðàñûâàåì ôëàã
				elseif binder_create_command_5_8 then
					-- print("òåñò 2: binder_create_command_5_8 TRUE")
					temp_array = commands.commands_senior_staff
					binder_create_command_5_8 = false -- Ñáðàñûâàåì ôëàã
				else
					-- Åñëè îáà ôëàãà ëîæíû, óñòàíàâëèâàåì temp_array â commands.commands
					-- print("òåñò 3: binder_create_command_9_10 FALSE, temp_array = commands.commands")
					temp_array = commands.commands
				end

				for _, command in ipairs(temp_array) do
					-- print("Command:", command.cmd, "Description:", command.description, "Text:", command.text)
					if command.cmd == change_cmd and command.description == change_description and command.arg == change_arg and command.text:gsub('&', '\n') == change_text then
						command.cmd = new_command
						command.arg = new_arg
						command.description = new_description
						command.text = new_text
						command.waiting = new_waiting
						save_commands()
						if command.arg == '' then
							sampAddChatMessage(
								'[Prison Helper] {ffffff}Êîìàíäà ' ..
								message_color_hex .. '/' .. new_command .. ' {ffffff}óñïåøíî ñîõðàíåíà!', message_color)
						elseif command.arg == '{arg}' then
							sampAddChatMessage(
								'[Prison Helper] {ffffff}Êîìàíäà ' ..
								message_color_hex .. '/' .. new_command .. ' [àðãóìåíò] {ffffff}óñïåøíî ñîõðàíåíà!',
								message_color)
						elseif command.arg == '{arg_id}' then
							sampAddChatMessage(
								'[Prison Helper] {ffffff}Êîìàíäà ' ..
								message_color_hex .. '/' .. new_command .. ' [ID èãðîêà] {ffffff}óñïåøíî ñîõðàíåíà!',
								message_color)
						elseif command.arg == '{arg_id} {arg2}' then
							sampAddChatMessage(
								'[Prison Helper] {ffffff}Êîìàíäà ' ..
								message_color_hex ..
								'/' .. new_command .. ' [ID èãðîêà] [àðãóìåíò] {ffffff}óñïåøíî ñîõðàíåíà!', message_color)
						elseif command.arg == '{arg_id} {arg2} {arg3}' then
							sampAddChatMessage(
								'[Prison Helper] {ffffff}Êîìàíäà ' ..
								message_color_hex ..
								'/' .. new_command .. ' [ID èãðîêà] [àðãóìåíò] [àðãóìåíò] {ffffff}óñïåøíî ñîõðàíåíà!',
								message_color)
						elseif command.arg == '{arg_id} {arg2} {arg3} {arg4}' then
							sampAddChatMessage(
								'[Prison Helper] {ffffff}Êîìàíäà ' ..
								message_color_hex ..
								'/' ..
								new_command .. ' [ID èãðîêà] [àðãóìåíò] [àðãóìåíò] [àðãóìåíò] {ffffff}óñïåøíî ñîõðàíåíà!',
								message_color)
						end
						sampUnregisterChatCommand(change_cmd)
						register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
						break
					end
				end
				BinderWindow[0] = false
			end
		end
		if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8 ' Îøèáêà ñîõðàíåíèÿ êîìàíäû!', _, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove) then
			if ffi.string(input_cmd):find('%W') then
				imgui.BulletText(u8 " Â êîìàíäå ìîæíî èñïîëüçîâàòü òîëüêî àíãë. áóêâû è/èëè öèôðû!")
			elseif ffi.string(input_cmd) == '' then
				imgui.BulletText(u8 " Êîìàíäà íå ìîæåò áûòü ïóñòàÿ!")
			end
			if ffi.string(input_description) == '' then
				imgui.BulletText(u8 " Îïèñàíèå êîìàíäû íå ìîæåò áûòü ïóñòîå!")
			end
			if ffi.string(input_text) == '' then
				imgui.BulletText(u8 " Áèíä êîìàíäû íå ìîæåò áûòü ïóñòîé!")
			end
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Çàêðûòü', imgui.ImVec2(300 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
				imgui.CloseCurrentPopup()
			end
			imgui.End()
		end
		imgui.End()
	end
)

imgui.OnFrame(
	function() return MembersWindow[0] end,
	function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))

		if tonumber(#members) >= 16 then
			sizeYY = 413
		else
			sizeYY = 24.5 * (tonumber(#members) + 1)
		end
		imgui.SetNextWindowSize(imgui.ImVec2(600 * MONET_DPI_SCALE, sizeYY * MONET_DPI_SCALE), imgui.Cond.FirstUseEver)

		imgui.Begin(fa.BUILDING_SHIELD .. " " .. u8(members_fraction) .. " - " .. #members .. u8 ' ñîòðóäíèêîâ îíëàéí',
			MembersWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove)
		for i, v in ipairs(members) do
			imgui.Columns(3)
			if v.working then
				imgui_RGBA = imgui.ImVec4(1, 1, 1, 1) -- white
			else
				imgui_RGBA = imgui.ImVec4(1, 0.231, 0.231, 1) -- red
			end
			if tonumber(v.afk) > 0 and tonumber(v.afk) < 60 then
				imgui.CenterColumnColorText(imgui_RGBA, u8(v.nick) .. ' [' .. v.id .. '] [AFK ' .. v.afk .. 's]')
			elseif tonumber(v.afk) >= 60 then
				imgui.CenterColumnColorText(imgui_RGBA,
					u8(v.nick) .. ' [' .. v.id .. '] [AFK ' .. math.floor(tonumber(v.afk) / 60) .. 'm]')
			else
				imgui.CenterColumnColorText(imgui_RGBA, u8(v.nick) .. ' [' .. v.id .. ']')
			end
			if imgui.IsItemClicked() and tonumber(settings.player_info.fraction_rank_number) >= 9 then
				show_leader_fast_menu(v.id)
				MembersWindow[0] = false
			end
			imgui.SetColumnWidth(-1, 300 * MONET_DPI_SCALE)
			imgui.NextColumn()
			imgui.CenterColumnText(u8(v.rank) .. ' (' .. u8(v.rank_number) .. ')')
			imgui.SetColumnWidth(-1, 230 * MONET_DPI_SCALE)
			imgui.NextColumn()
			imgui.CenterColumnText(u8(v.warns .. '/3'))
			imgui.SetColumnWidth(-1, 75 * MONET_DPI_SCALE)
			imgui.Columns(1)
			imgui.Separator()
		end
		imgui.End()
	end
)

imgui.OnFrame(
	function() return NoteWindow[0] end,
	function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.FILE_PEN .. ' ' .. show_note_name, NoteWindow,
			imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove)
		imgui.Text(show_note_text:gsub('&', '\n'))
		imgui.Separator()
		if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Çàêðûòü', imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * MONET_DPI_SCALE)) then
			NoteWindow[0] = false
		end
		imgui.End()
	end
)

imgui.OnFrame(
	function() return FastMenu[0] end,
	function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.USER .. ' ' .. sampGetPlayerNickname(player_id) .. ' [' .. player_id .. ']##FastMenu', FastMenu,
			imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove)
		for _, command in ipairs(commands.commands) do
			if command.enable and command.arg == '{arg_id}' and not command.text:find('/cure') and not command.text:find('/unstuff') then
				if imgui.Button(u8(command.description), imgui.ImVec2(290 * MONET_DPI_SCALE, 30 * MONET_DPI_SCALE)) then
					sampProcessChatInput("/" .. command.cmd .. " " .. player_id)
					FastMenu[0] = false
				end
			end
		end
		imgui.End()
	end
)

imgui.OnFrame(
	function() return LeaderFastMenu[0] end,
	function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.USER .. ' ' .. sampGetPlayerNickname(player_id) .. ' [' .. player_id .. ']##LeaderFastMenu',
			LeaderFastMenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove)
		for _, command in ipairs(commands.commands_manage) do
			if command.enable and command.arg == '{arg_id}' then
				if imgui.Button(u8(command.description), imgui.ImVec2(290 * MONET_DPI_SCALE, 30 * MONET_DPI_SCALE)) then
					sampProcessChatInput("/" .. command.cmd .. " " .. player_id)
					LeaderFastMenu[0] = false
				end
			end
		end
		if not isMonetLoader() then
			if imgui.Button(u8 "Âûäàòü âûãîâîð", imgui.ImVec2(290 * MONET_DPI_SCALE, 30 * MONET_DPI_SCALE)) then
				sampSetChatInputEnabled(true)
				sampSetChatInputText('/vig ' .. player_id .. ' ')
				LeaderFastMenu[0] = false
			end
			if imgui.Button(u8 "Óâîëèòü èç îðãàíèçàöèè", imgui.ImVec2(290 * MONET_DPI_SCALE, 30 * MONET_DPI_SCALE)) then
				sampSetChatInputEnabled(true)
				sampSetChatInputText('/uval ' .. player_id .. ' ')
				LeaderFastMenu[0] = false
			end
		end
		imgui.End()
	end
)

imgui.OnFrame(
	function() return GiveRankMenu[0] end,
	function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.BUILDING_SHIELD .. " Prison Helper##rank", GiveRankMenu,
			imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar +
			imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove)
		imgui.CenterText(u8 'Âûáåðèòå ðàíã äëÿ ' .. sampGetPlayerNickname(player_id) .. ':')
		imgui.PushItemWidth(250 * MONET_DPI_SCALE)
		imgui.SliderInt('', giverank, 1, 9)
		imgui.Separator()
		if imgui.Button(fa.USER_NURSE .. u8 " Âûäàòü ðàíã", imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
			local command_find = false
			for _, command in ipairs(commands.commands_manage) do
				if command.enable and command.text:find('/giverank {arg_id}') then
					command_find = true
					local modifiedText = command.text
					local wait_tag = false
					local arg_id = player_id
					modifiedText = modifiedText:gsub('%{get_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg_id) or "")
					modifiedText = modifiedText:gsub('%{get_rp_nick%(%{arg_id%}%)%}',
						sampGetPlayerNickname(arg_id):gsub('_', ' ') or "")
					modifiedText = modifiedText:gsub('%{get_ru_nick%(%{arg_id%}%)%}',
						TranslateNick(sampGetPlayerNickname(arg_id)) or "")
					modifiedText = modifiedText:gsub('%{arg_id%}', arg_id or "")
					lua_thread.create(function()
						isActiveCommand = true
						if isMonetLoader() and settings.general.mobile_stop_button then
							sampAddChatMessage(
								'[Prison Helper] {ffffff}×òîáû îñòàíîâèòü îòûãðîâêó êîìàíäû èñïîëüçóéòå ' ..
								message_color_hex .. '/stop {ffffff}èëè íàæìèòå êíîïêó âíèçó ýêðàíà', message_color)
							CommandStopWindow[0] = true
						elseif not isMonetLoader() and hotkey_no_errors and settings.general.bind_command_stop and settings.general.use_binds then
							sampAddChatMessage(
								'[Prison Helper] {ffffff}×òîáû îñòàíîâèòü îòûãðîâêó êîìàíäû èñïîëüçóéòå ' ..
								message_color_hex ..
								'/stop {ffffff}èëè íàæìèòå ' ..
								message_color_hex .. getNameKeysFrom(settings.general.bind_command_stop), message_color)
						else
							sampAddChatMessage(
								'[Prison Helper] {ffffff}×òîáû îñòàíîâèòü îòûãðîâêó êîìàíäû èñïîëüçóéòå ' ..
								message_color_hex .. '/stop', message_color)
						end
						local lines = {}
						for line in string.gmatch(modifiedText, "[^&]+") do
							table.insert(lines, line)
						end
						for _, line in ipairs(lines) do
							if command_stop then
								command_stop = false
								isActiveCommand = false
								if isMonetLoader() and settings.general.mobile_stop_button then
									CommandStopWindow[0] = false
								end
								sampAddChatMessage(
									'[Prison Helper] {ffffff}Îòûãðîâêà êîìàíäû /' ..
									command.cmd .. " óñïåøíî îñòàíîâëåíà!",
									message_color)
								return
							end
							if wait_tag then
								for tag, replacement in pairs(tagReplacements) do
									if line:find("{" .. tag .. "}") then
										local success, result = pcall(string.gsub, line, "{" .. tag .. "}", replacement())
										if success then
											line = result
										end
									end
								end
								sampSendChat(line)
								if debug_mode then
									sampAddChatMessage(
										'[Prison Helper DEBUG] Îòïðàâëÿþ ñîîáùåíèå: ' .. line, message_color)
								end
								wait(tonumber(command.waiting) * 1000)
							end
							if not wait_tag then
								if line == '{show_rank_menu}' then
									wait_tag = true
								end
							end
						end
						isActiveCommand = false
						if isMonetLoader() and settings.general.mobile_stop_button then
							CommandStopWindow[0] = false
						end
					end)
				end
			end
			if not command_find then
				sampAddChatMessage('[Prison Helper] {ffffff}Áèíä äëÿ èçìåíåíèÿ ðàíãà îòñóòñòâóåò ëèáî îòêëþ÷¸í!',
					message_color)
				sampAddChatMessage('[Prison Helper] {ffffff}Ïîïðîáóéòå ñáðîñèòü íàñòðîéêè õåëïåðà!', message_color)
				sampSendChat('/giverank ' .. player_id .. " " .. giverank[0])
			end
			GiveRankMenu[0] = false
		end
		imgui.End()
	end
)

imgui.OnFrame(
	function() return CommandStopWindow[0] end,
	function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY - 50 * MONET_DPI_SCALE), imgui.Cond.FirstUseEver,
			imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.BUILDING_SHIELD .. " Prison Helper##CommandStopWindow", _,
			imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar +
			imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove)
		if isMonetLoader() and isActiveCommand then
			if imgui.Button(fa.CIRCLE_STOP .. u8 ' Îñòàíîâèòü îòûãðîâêó ') then
				command_stop = true
				CommandStopWindow[0] = false
			end
		else
			CommandStopWindow[0] = false
		end
		imgui.End()
	end
)

imgui.OnFrame(
	function() return CommandPauseWindow[0] end,
	function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY - 50 * MONET_DPI_SCALE), imgui.Cond.FirstUseEver,
			imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.BUILDING_SHIELD .. " Prison Helper##CommandPauseWindow", _,
			imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar +
			imgui.WindowFlags.AlwaysAutoResize)
		if command_pause then
			if imgui.Button(fa.CIRCLE_ARROW_RIGHT .. u8 ' Ïðîäîëæèòü ', imgui.ImVec2(150 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
				command_pause = false
				CommandPauseWindow[0] = false
			end
			imgui.SameLine()
			if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Ïîëíûé STOP ', imgui.ImVec2(150 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
				command_stop = true
				command_pause = false
				CommandPauseWindow[0] = false
			end
		else
			CommandPauseWindow[0] = false
		end
		imgui.End()
	end
)

imgui.OnFrame(
	function() return FastMenuPlayers[0] end,
	function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.BUILDING_SHIELD .. u8 " Âûáåðèòå èãðîêà##fast_menu_players", FastMenuPlayers,
			imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize +
			imgui.WindowFlags.NoMove)
		if tonumber(#get_players()) == 0 then
			show_fast_menu(get_players()[1])
			FastMenuPlayers[0] = false
		elseif tonumber(#get_players()) >= 1 then
			for _, playerId in ipairs(get_players()) do
				local id = tonumber(playerId)
				if imgui.Button(sampGetPlayerNickname(id), imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
					if tonumber(#get_players()) ~= 0 then show_fast_menu(id) end
					FastMenuPlayers[0] = false
				end
			end
		end
		imgui.End()
	end
)

imgui.OnFrame(
	function() return FastMenuButton[0] end,
	function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 8.5, sizeY / 2.3), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.HOSPITAL .. " Prison Helper##fast_menu_button", FastMenuButton,
			imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar +
			imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoMove)
		if imgui.Button(fa.IMAGE_PORTRAIT .. u8 ' Âçàèìîäåéñòâèå ') then
			if tonumber(#get_players()) == 1 then
				show_fast_menu(get_players()[1])
				FastMenuButton[0] = false
			elseif tonumber(#get_players()) > 1 then
				FastMenuPlayers[0] = true
				FastMenuButton[0] = false
			end
		end
		imgui.End()
	end
)

imgui.OnFrame(
	function() return InformationWindow[0] end,
	function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 8, sizeY / 1.7), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(225 * MONET_DPI_SCALE, 113 * MONET_DPI_SCALE), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.BUILDING_SHIELD .. u8 " Prison Helper##info_menu", _,
			imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
		if not isMonetLoader() and not sampIsChatInputActive() then player.HideCursor = true else player.HideCursor = false end
		imgui.Text(fa.CITY .. u8(' Ãîðîä: ') .. u8(tagReplacements.get_city()))
		imgui.Text(fa.MAP_LOCATION_DOT .. u8(' Ðàéîí: ') .. u8(tagReplacements.get_area()))
		imgui.Text(fa.LOCATION_CROSSHAIRS .. u8(' Êâàäðàò: ') .. u8(tagReplacements.get_square()))
		imgui.Separator()
		imgui.Text(fa.CLOCK .. u8(' Òåêóùåå âðåìÿ: ') .. u8(tagReplacements.get_time()))
		imgui.End()
	end
)

imgui.OnFrame(
	function() return JobInformationWindow[0] end,
	function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 8, sizeY / 1.7), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(225 * MONET_DPI_SCALE, 113 * MONET_DPI_SCALE), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.BUILDING_SHIELD .. u8 " Prison Helper##info_menu", _,
			imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
		if not isMonetLoader() and not sampIsChatInputActive() then player.HideCursor = true else player.HideCursor = false end
		imgui.Text(fa.CITY .. u8(' Ìàòåðèàëû: ') .. tostring(settings.player_organization.materials))
		imgui.Text(fa.TRUCK ..
			u8(' Ïîñòàâêè â ÌÞ: ') .. tostring(settings.player_organization.postavki_materials))
		imgui.Text(fa.CAR ..
			u8(' Ïîñòàâêè â ÌÎ(ÒÑÐ): ') .. tostring(settings.player_organization.postavki_kargobob))
		imgui.Separator()
		imgui.Text(fa.CLOCK .. u8(' Òåêóùåå âðåìÿ: ') .. u8(tagReplacements.get_time()))
		imgui.End()
	end
)

imgui.OnFrame(
	function() return UpdateWindow[0] end,
	function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.CIRCLE_INFO .. u8 " Îïîâåùåíèå##need_update_helper", _,
			imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove)
		imgui.CenterText(u8 'Ó âàñ ñåé÷àñ óñòàíîâëåíà âåðñèÿ õåëïåðà ' .. u8(tostring(thisScript().version)) .. ".")
		imgui.CenterText(u8 'Â áàçå äàííûõ íàéäåíà âåðñèÿ õåëïåðà - ' .. u8(updateVer) .. ".")
		imgui.CenterText(u8 'Ðåêîìåíäóåòñÿ îáíîâèòüñÿ, äàáû èìåòü âåñü àêòóàëüíûé ôóíêöèîíàë!')
		imgui.Separator()
		imgui.CenterText(u8('×òî íîâîãî â âåðñèè ') .. u8(updateVer) .. ':')
		imgui.Text(updateInfoText)
		imgui.Separator()
		if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Íå îáíîâëÿòü ', imgui.ImVec2(250 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
			UpdateWindow[0] = false
		end
		imgui.SameLine()
		if imgui.Button(fa.DOWNLOAD .. u8 ' Çàãðóçèòü íîâóþ âåðñèþ', imgui.ImVec2(250 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
			download_helper = true
			downloadFileFromUrlToPath(updateUrl, path_helper)
			UpdateWindow[0] = false
		end
		imgui.End()
	end
)

imgui.OnFrame(
	function() return SobesMenu[0] end,
	function(player)
		if player_id ~= nil and isParamSampID(player_id) then
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.Begin(
				fa.PERSON_CIRCLE_CHECK .. u8 ' Ïðîâåäåíèå ñîáåñåäîâàíèÿ èãðîêó ' .. sampGetPlayerNickname(player_id),
				SobesMenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags
				.AlwaysAutoResize + imgui.WindowFlags.NoMove)
			if imgui.BeginChild('sobes1', imgui.ImVec2(240 * MONET_DPI_SCALE, 182 * MONET_DPI_SCALE), true) then
				imgui.CenterColumnText(fa.BOOKMARK .. u8 " Îñíîâíîå")
				imgui.Separator()
				if imgui.Button(fa.PLAY .. u8 " Íà÷àòü ñîáåñåäîâàíèå", imgui.ImVec2(-1, 25 * MONET_DPI_SCALE)) then
					lua_thread.create(function()
						sampSendChat("Çäðàâñòâóéòå, ÿ " ..
							settings.player_info.name_surname ..
							" - " .. settings.player_info.fraction_rank .. ' ' .. settings.player_info.fraction_tag)
						wait(2000)
						sampSendChat("Âû ïðèøëè ê íàì íà ñîáåñåäîâàíèå?")
					end)
				end
				if imgui.Button(fa.PASSPORT .. u8 " Ïîïðîñèòü äîêóìåíòû", imgui.ImVec2(-1, 25 * MONET_DPI_SCALE)) then
					lua_thread.create(function()
						sampSendChat("Õîðîøî, ïðåäîñòàâüòå ìíå âñå âàøè äîêóìåíòû äëÿ ïðîâåðêè.")
						wait(2000)
						sampSendChat("Ìíå íóæåí âàø Ïàñïîðò, Ìåä.êàðòà è Ëèöåíçèè.")
						wait(2000)
						sampSendChat("/n " ..
							sampGetPlayerNickname(player_id) ..
							", èñïîëüçóéòå /showpass [ID] , /showmc [ID] , /showlic [ID]")
						wait(2000)
						sampSendChat("/n Îáÿçàòåëüíî ñ RP îòûãðîâêàìè!")
					end)
				end
				if imgui.Button(fa.USER .. u8 " Ðàññêàæèòå î ñåáå", imgui.ImVec2(-1, 25 * MONET_DPI_SCALE)) then
					sampSendChat("Íåìíîãî ðàññêàæèòå î ñåáå.")
				end

				if imgui.Button(fa.CHECK .. u8 " Ñîáåñåäîâàíèå ïðîéäåíî", imgui.ImVec2(-1, 25 * MONET_DPI_SCALE)) then
					sampSendChat("/todo Ïîçäðàâëÿþ! Âû óñïåøíî ïðîøëè ñîáåñåäîâàíèå!*óëûáàÿñü")
				end
				if imgui.Button(fa.USER_PLUS .. u8 " Ïðèãëàñèòü â îðãàíèçàöèþ", imgui.ImVec2(-1, 25 * MONET_DPI_SCALE)) then
					find_and_use_command('/invite {arg_id}', player_id)
					SobesMenu[0] = false
				end
				imgui.EndChild()
			end
			imgui.SameLine()
			if imgui.BeginChild('sobes2', imgui.ImVec2(240 * MONET_DPI_SCALE, 182 * MONET_DPI_SCALE), true) then
				imgui.CenterColumnText(fa.BOOKMARK .. u8 " Äîïîëíèòåëüíî")
				imgui.Separator()
				if imgui.Button(fa.GLOBE .. u8 " Íàëè÷èå ñïåö.ðàöèè Discord", imgui.ImVec2(-1, 25 * MONET_DPI_SCALE)) then
					sampSendChat("Èìååòñÿ ëè ó Âàñ ñïåö. ðàöèÿ Discord?")
				end
				if imgui.Button(fa.CIRCLE_QUESTION .. u8 " Íàëè÷èå îïûòà ðàáîòû", imgui.ImVec2(-1, 25 * MONET_DPI_SCALE)) then
					sampSendChat("Èìååòñÿ ëè ó Âàñ îïûò ðàáîòû â íàøåé ñôåðå?")
				end
				if imgui.Button(fa.CIRCLE_QUESTION .. u8 " Ïî÷åìó èìåííî ìû?", imgui.ImVec2(-1, 25 * MONET_DPI_SCALE)) then
					sampSendChat("Ñêàæèòå ïî÷åìó Âû âûáðàëè èìåííî íàñ?")
				end
				if imgui.Button(fa.CIRCLE_QUESTION .. u8 " ×òî òàêîå àäåêâàòíîñòü?", imgui.ImVec2(-1, 25 * MONET_DPI_SCALE)) then
					sampSendChat("Ñêàæèòå ÷òî ïî âàøåìó çíà÷èò \"Àäåêâàòíîñòü\"?")
				end
				if imgui.Button(fa.CIRCLE_QUESTION .. u8 " ×òî òàêîå ÄÌ?", imgui.ImVec2(-1, 25 * MONET_DPI_SCALE)) then
					sampSendChat("Ñêàæèòå êàê âû äóìàåòå, ÷òî òàêîå \"ÄÌ\"?")
				end
				imgui.EndChild()
			end
			imgui.SameLine()
			if imgui.BeginChild('sobes3', imgui.ImVec2(150 * MONET_DPI_SCALE, -1), true) then
				imgui.CenterColumnText(fa.CIRCLE_XMARK .. u8 " Îòêàçû")
				imgui.Separator()
				if imgui.Selectable(u8 "Íåòó ïàñïîðòà") then
					lua_thread.create(function()
						SobesMenu[0] = false
						sampSendChat("/todo Ê ñîæàëåíèþ, âû íàì íå ïîäõîäèòå*ñ ðàçî÷àðîâàíèåì íà ëèöå")
						wait(2000)
						sampSendChat("Ó âàñ íåòó ïàñïîðòà.")
						wait(2000)
						sampSendChat("Ïîëó÷èòå ïàñïîðò â ïàñïîðòíîì ñòîëå íà 1 ýòàæå Ìýðèè.")
					end)
				end
				if imgui.Selectable(u8 "Íåòó ìåä.êàðòû") then
					lua_thread.create(function()
						SobesMenu[0] = false
						sampSendChat("/todo Ê ñîæàëåíèþ, âû íàì íå ïîäõîäèòå*ñ ðàçî÷àðîâàíèåì íà ëèöå")
						wait(2000)
						sampSendChat("Ó âàñ íåòó ìåä.êàðòû, ïîëó÷èòå å¸ â ëþáîé áîëüíèöå.")
					end)
				end
				if imgui.Selectable(u8 "Íåòó âîåííîãî áèëåòà") then
					lua_thread.create(function()
						SobesMenu[0] = false
						sampSendChat("/todo Ê ñîæàëåíèþ, âû íàì íå ïîäõîäèòå*ñ ðàçî÷àðîâàíèåì íà ëèöå")
						wait(2000)
						sampSendChat("Ó âàñ íåòó âîåííîãî áèëåòà èç àðìèè!")
						wait(2000)
						sampSendChat("/n Ïîëó÷èòü åãî ìîæíî îòñëóæèâ â àðìèè ëèáî êóïèòü â /donate ")
					end)
				end

				if imgui.Selectable(u8 "Íåòó æèëüÿ") then
					lua_thread.create(function()
						SobesMenu[0] = false
						sampSendChat("/todo Ê ñîæàëåíèþ, âû íàì íå ïîäõîäèòå*ñ ðàçî÷àðîâàíèåì íà ëèöå")
						wait(2000)
						sampSendChat(
							"Ó âàñ íåòó æèëüÿ. Àðåíäóéòå ñåáå îòåëü ëèáî ïîäñåëèòåñü â äîì, çàòåì ïðèõîäèòå ê íàì!")
					end)
				end
				if imgui.Selectable(u8 "Çàêîíîïîñëóøíîñòü") then
					lua_thread.create(function()
						SobesMenu[0] = false
						sampSendChat("/todo Ê ñîæàëåíèþ, âû íàì íå ïîäõîäèòå*ñ ðàçî÷àðîâàíèåì íà ëèöå")
						wait(2000)
						sampSendChat("Ó âàñ ïëîõàÿ çàêîíîïîñëóøíîñòü.")
						wait(2000)
						sampSendChat("/n Íåîáõîäèìî èìåòü ìèíèìóì 35 çàêîíîïîñëóøíîñòè!")
					end)
				end
				if imgui.Selectable(u8 "Íàðêîçàâèñèìîñòü") then
					lua_thread.create(function()
						SobesMenu[0] = false
						sampSendChat("/todo Ê ñîæàëåíèþ, âû íàì íå ïîäõîäèòå*ñ ðàçî÷àðîâàíèåì íà ëèöå")
						wait(2000)
						sampSendChat("Âû íàðêîçàâèñèìûé, ñíà÷àëî âàì íåîáõîäèìî âûëå÷èòüñÿ â áîëüíèöå!")
					end)
				end

				if imgui.Selectable(u8 "Àêòèâíàÿ ïîâåñòêà") then
					lua_thread.create(function()
						SobesMenu[0] = false
						sampSendChat("/todo Ê ñîæàëåíèþ, âû íàì íå ïîäõîäèòå*ñ ðàçî÷àðîâàíèåì íà ëèöå")
						wait(2000)
						sampSendChat("Ó âàñ åñòü ïîâåñòêà, âû íå ìîæåòå óñòðîèòüñÿ ê íàì!")
						wait(2000)
						sampSendChat("Âû ìîæåòå óñòðîèòüñÿ â ÌÎ, ëèáî â áîëüíèöå ïðîéäèòå îáñëåäîâàíèå")
					end)
				end
				if imgui.Selectable(u8 "Ïðîô.íåïðèãîäíîñòü") then
					lua_thread.create(function()
						SobesMenu[0] = false
						sampSendChat("/todo Ê ñîæàëåíèþ, âû íàì íå ïîäõîäèòå*ñ ðàçî÷àðîâàíèåì íà ëèöå")
						wait(2000)
						sampSendChat("Âû íå ïîäõîäèòå äëÿ íàøåé ðàáîòû ïî ïðîôåññèîíàëüíûì êà÷åñòâàì.")
					end)
				end
			end
			imgui.EndChild()
		else
			sampAddChatMessage('[Prison Helper] {ffffff}Ïðîçèîøëà îøèáêà, ID èãðîêà íåäåéñòâèòåëåí!', message_color)
			SobesMenu[0] = false
		end
	end
)

imgui.OnFrame(
	function() return SumMenuWindow[0] end,
	function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(600 * MONET_DPI_SCALE, 413 * MONET_DPI_SCALE), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.STAR .. u8 " Ðåãëàìåíò ïîâûøåíèÿ ñðîêà##sum_menu", SumMenuWindow,
			imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove)
		if smart_rptp ~= nil and isParamSampID(player_id) then
			imgui.SetWindowFontScale(1.4)
			imgui.Text(fa.MAGNIFYING_GLASS .. u8 ' Ïîèñê:')
			imgui.SetWindowFontScale(1.0)
			imgui.SameLine()
			imgui.PushItemWidth(467 * MONET_DPI_SCALE)
			imgui.InputText(u8 '##input_sum', input_sum, 128)
			imgui.SameLine()
			if imgui.Button(fa.GEAR) then
				imgui.OpenPopup(fa.STAR .. u8(' Íàñòðîéêà âûäà÷è ïîâûøåíèÿ ñðîêà'))
			end
			if imgui.BeginPopupModal(fa.STAR .. u8(' Íàñòðîéêà âûäà÷è ïîâûøåíèÿ ñðîêà'), _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
				if imgui.Checkbox(u8 ' Çàïðàøèâàòü âûäà÷ó ïîâûøåíèÿ ñðîêà â /r (åñëè âàø ðàíã íåäîñòàòî÷åí)', checkbox_sum) then
					settings.general.use_form_su = checkbox_sum[0]
					save_settings()
				end
				if imgui.Button(fa.CIRCLE_XMARK .. u8(' Çàêðûòü'), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * MONET_DPI_SCALE)) then
					imgui.CloseCurrentPopup()
				end
				imgui.EndPopup()
			end
			imgui.Separator()
			if u8:decode(ffi.string(input_sum)) == '' then
				for _, chapter in ipairs(smart_rptp) do
					if imgui.CollapsingHeader(u8(chapter.name)) then
						if chapter.item then
							for _, item in ipairs(chapter.item) do
								local popup_id = fa.TRIANGLE_EXCLAMATION ..
									u8 ' Ïåðåïðîâåðüòå äàííûå ïåðåä âûäà÷åé ïîâûøåíèÿ##' ..
									item.text .. item.lvl .. item.reason
								-- imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(1.00, 1.00, 1.00, 0.65))
								if imgui.Button(u8(item.text) .. '##' .. item.text .. item.lvl .. item.reason, imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * MONET_DPI_SCALE)) then
									imgui.OpenPopup(popup_id)
								end
								-- imgui.PopStyleColor()
								if imgui.BeginPopupModal(popup_id, nil, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
									imgui.Text(fa.USER ..
										u8 ' Èãðîê: ' .. u8(sampGetPlayerNickname(player_id)) .. ' [' .. player_id .. ']')
									imgui.Text(fa.STAR .. u8 ' Êîëè÷åñòâî çâ¸çä: ' .. item.lvl)
									imgui.Text(fa.COMMENT .. u8 ' Ïðè÷èíà ïîâûøåíèÿ ñðîêà: ' .. u8(item.reason))
									imgui.Separator()
									if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Îòìåíà', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
										imgui.CloseCurrentPopup()
									end
									imgui.SameLine()
									if imgui.Button(fa.STAR .. u8 ' Âûäàòü ïîâûøåíèå ñðîêà', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
										SumMenuWindow[0] = false
										if settings.general.use_form_su then
											find_and_use_command('Ïðîøó îáüÿâèòü â ðîçûñê %{arg2%} ñòåïåíè äåëî N',
												player_id .. ' ' .. item.lvl .. ' ' .. item.reason)
										else
											find_and_use_command('/punish {arg_id} {arg2} 2 {arg3}',
												player_id .. ' ' .. item.lvl .. ' ' .. item.reason)
										end
										imgui.CloseCurrentPopup()
									end
									imgui.EndPopup()
								end
							end
						end
					end
				end
			else
				local input_sum_decoded = u8:decode(ffi.string(input_sum))
				for _, chapter in ipairs(smart_rptp) do
					if chapter.name:rupper():find(input_sum_decoded:rupper()) then
						if imgui.CollapsingHeader(u8(chapter.name)) then
							if chapter.item then
								for _, item in ipairs(chapter.item) do
									local popup_id = fa.TRIANGLE_EXCLAMATION ..
										u8 ' Ïåðåïðîâåðüòå äàííûå ïåðåä âûäà÷åé ðîçûñêà##' ..
										item.text .. item.lvl .. item.reason
									if imgui.Button(u8(item.text) .. '##' .. item.text .. item.lvl .. item.reason, imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * MONET_DPI_SCALE)) then
										imgui.OpenPopup(popup_id)
									end
									if imgui.BeginPopupModal(popup_id, nil, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
										imgui.Text(fa.USER ..
											u8 ' Èãðîê: ' ..
											u8(sampGetPlayerNickname(player_id)) .. ' [' .. player_id .. ']')
										imgui.Text(fa.STAR .. u8 ' Êîëè÷åñòâî çâ¸çä: ' .. item.lvl)
										imgui.Text(fa.COMMENT .. u8 ' Ïðè÷èíà ïîâûøåíèÿ ñðîêà: ' .. u8(item.reason))
										imgui.Separator()
										if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Îòìåíà', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
											imgui.CloseCurrentPopup()
										end
										imgui.SameLine()
										if imgui.Button(fa.STAR .. u8 ' Âûäàòü ïîâûøåíèå ñðîêà', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
											SumMenuWindow[0] = false
											if settings.general.use_form_su then
												find_and_use_command(
													'Ïðîøó îáüÿâèòü â ðîçûñê %{arg2%} ñòåïåíè äåëî N%(%{arg_id%}%)%. Ïðè÷èíà%: %{arg3%}',
													player_id .. ' ' .. item.lvl .. ' ' .. item.reason)
											else
												find_and_use_command('/punish {arg_id} {arg2} 2 {arg3}',
													player_id .. ' ' .. item.lvl .. ' ' .. item.reason)
											end
											imgui.CloseCurrentPopup()
										end
										imgui.EndPopup()
									end
								end
							end
						end
					end
				end
			end
		else
			sampAddChatMessage(
				'[Prison Helper] {ffffff}Ïðîèçîøëà îøèáêà óìíîãî ïîâûøåíèÿ ñðîêà (íåòó äàííûõ ëèáî èãðîê îôíóëñÿ)!',
				message_color)
			SumMenuWindow[0] = false
		end
		imgui.End()
	end
)

function imgui.CenterText(text)
	local width = imgui.GetWindowWidth()
	local calc = imgui.CalcTextSize(text)
	imgui.SetCursorPosX(width / 2 - calc.x / 2)
	imgui.Text(text)
end

function imgui.CenterTextDisabled(text)
	local width = imgui.GetWindowWidth()
	local calc = imgui.CalcTextSize(text)
	imgui.SetCursorPosX(width / 2 - calc.x / 2)
	imgui.TextDisabled(text)
end

function imgui.CenterColumnText(text)
	imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
	imgui.Text(text)
end

function imgui.CenterColumnTextDisabled(text)
	imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
	imgui.TextDisabled(text)
end

function imgui.CenterColumnColorText(imgui_RGBA, text)
	imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
	imgui.TextColored(imgui_RGBA, text)
end

function imgui.CenterButton(text)
	local width = imgui.GetWindowWidth()
	local calc = imgui.CalcTextSize(text)
	imgui.SetCursorPosX(width / 2 - calc.x / 2)
	if imgui.Button(text) then
		return true
	else
		return false
	end
end

function imgui.CenterColumnButton(text)
	if text:find('(.+)##(.+)') then
		local text1, text2 = text:match('(.+)##(.+)')
		imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text1).x / 2)
	else
		imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
	end
	if imgui.Button(text) then
		return true
	else
		return false
	end
end

function imgui.CenterColumnSmallButton(text)
	if text:find('(.+)##(.+)') then
		local text1, text2 = text:match('(.+)##(.+)')
		imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text1).x / 2)
	else
		imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
	end
	if imgui.SmallButton(text) then
		return true
	else
		return false
	end
end

function imgui.GetMiddleButtonX(count)
	local width = imgui.GetWindowContentRegionWidth()
	local space = imgui.GetStyle().ItemSpacing.x
	return count == 1 and width or width / count - ((space * (count - 1)) / count)
end

function apply_dark_theme()
	imgui.SwitchContext()
	imgui.GetStyle().WindowPadding                           = imgui.ImVec2(5 * MONET_DPI_SCALE, 5 * MONET_DPI_SCALE)
	imgui.GetStyle().FramePadding                            = imgui.ImVec2(5 * MONET_DPI_SCALE, 5 * MONET_DPI_SCALE)
	imgui.GetStyle().ItemSpacing                             = imgui.ImVec2(5 * MONET_DPI_SCALE, 5 * MONET_DPI_SCALE)
	imgui.GetStyle().ItemInnerSpacing                        = imgui.ImVec2(2 * MONET_DPI_SCALE, 2 * MONET_DPI_SCALE)
	imgui.GetStyle().TouchExtraPadding                       = imgui.ImVec2(0, 0)
	imgui.GetStyle().IndentSpacing                           = 0
	imgui.GetStyle().ScrollbarSize                           = 10 * MONET_DPI_SCALE
	imgui.GetStyle().GrabMinSize                             = 10 * MONET_DPI_SCALE
	imgui.GetStyle().WindowBorderSize                        = 1 * MONET_DPI_SCALE
	imgui.GetStyle().ChildBorderSize                         = 1 * MONET_DPI_SCALE
	imgui.GetStyle().PopupBorderSize                         = 1 * MONET_DPI_SCALE
	imgui.GetStyle().FrameBorderSize                         = 1 * MONET_DPI_SCALE
	imgui.GetStyle().TabBorderSize                           = 1 * MONET_DPI_SCALE
	imgui.GetStyle().WindowRounding                          = 8 * MONET_DPI_SCALE
	imgui.GetStyle().ChildRounding                           = 8 * MONET_DPI_SCALE
	imgui.GetStyle().FrameRounding                           = 8 * MONET_DPI_SCALE
	imgui.GetStyle().PopupRounding                           = 8 * MONET_DPI_SCALE
	imgui.GetStyle().ScrollbarRounding                       = 8 * MONET_DPI_SCALE
	imgui.GetStyle().GrabRounding                            = 8 * MONET_DPI_SCALE
	imgui.GetStyle().TabRounding                             = 8 * MONET_DPI_SCALE
	imgui.GetStyle().WindowTitleAlign                        = imgui.ImVec2(0.5, 0.5)
	imgui.GetStyle().ButtonTextAlign                         = imgui.ImVec2(0.5, 0.5)
	imgui.GetStyle().SelectableTextAlign                     = imgui.ImVec2(0.5, 0.5)
	imgui.GetStyle().Colors[imgui.Col.Text]                  = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TextDisabled]          = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
	imgui.GetStyle().Colors[imgui.Col.WindowBg]              = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ChildBg]               = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
	imgui.GetStyle().Colors[imgui.Col.PopupBg]               = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
	imgui.GetStyle().Colors[imgui.Col.Border]                = imgui.ImVec4(0.25, 0.25, 0.26, 0.54)
	imgui.GetStyle().Colors[imgui.Col.BorderShadow]          = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
	imgui.GetStyle().Colors[imgui.Col.FrameBg]               = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]        = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
	imgui.GetStyle().Colors[imgui.Col.FrameBgActive]         = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TitleBg]               = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TitleBgActive]         = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]      = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.MenuBarBg]             = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]           = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]         = imgui.ImVec4(0.00, 0.00, 0.00, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]  = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]   = imgui.ImVec4(0.51, 0.51, 0.51, 1.00)
	imgui.GetStyle().Colors[imgui.Col.CheckMark]             = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
	imgui.GetStyle().Colors[imgui.Col.SliderGrab]            = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
	imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]      = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
	imgui.GetStyle().Colors[imgui.Col.Button]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ButtonHovered]         = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ButtonActive]          = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
	imgui.GetStyle().Colors[imgui.Col.Header]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.HeaderHovered]         = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
	imgui.GetStyle().Colors[imgui.Col.HeaderActive]          = imgui.ImVec4(0.47, 0.47, 0.47, 1.00)
	imgui.GetStyle().Colors[imgui.Col.Separator]             = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]      = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.SeparatorActive]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ResizeGrip]            = imgui.ImVec4(1.00, 1.00, 1.00, 0.25)
	imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]     = imgui.ImVec4(1.00, 1.00, 1.00, 0.67)
	imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]      = imgui.ImVec4(1.00, 1.00, 1.00, 0.95)
	imgui.GetStyle().Colors[imgui.Col.Tab]                   = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TabHovered]            = imgui.ImVec4(0.28, 0.28, 0.28, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TabActive]             = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TabUnfocused]          = imgui.ImVec4(0.07, 0.10, 0.15, 0.97)
	imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]    = imgui.ImVec4(0.14, 0.26, 0.42, 1.00)
	imgui.GetStyle().Colors[imgui.Col.PlotLines]             = imgui.ImVec4(0.61, 0.61, 0.61, 1.00)
	imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]      = imgui.ImVec4(1.00, 0.43, 0.35, 1.00)
	imgui.GetStyle().Colors[imgui.Col.PlotHistogram]         = imgui.ImVec4(0.90, 0.70, 0.00, 1.00)
	imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]  = imgui.ImVec4(1.00, 0.60, 0.00, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]        = imgui.ImVec4(1.00, 0.00, 0.00, 0.35)
	imgui.GetStyle().Colors[imgui.Col.DragDropTarget]        = imgui.ImVec4(1.00, 1.00, 0.00, 0.90)
	imgui.GetStyle().Colors[imgui.Col.NavHighlight]          = imgui.ImVec4(0.26, 0.59, 0.98, 1.00)
	imgui.GetStyle().Colors[imgui.Col.NavWindowingHighlight] = imgui.ImVec4(1.00, 1.00, 1.00, 0.70)
	imgui.GetStyle().Colors[imgui.Col.NavWindowingDimBg]     = imgui.ImVec4(0.80, 0.80, 0.80, 0.20)
	imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg]      = imgui.ImVec4(0.12, 0.12, 0.12, 0.95)
end

function apply_moonmonet_theme()
	local generated_color = moon_monet.buildColors(settings.general.moonmonet_theme_color, 1.0, true)
	imgui.SwitchContext()
	imgui.GetStyle().WindowPadding = imgui.ImVec2(5 * MONET_DPI_SCALE, 5 * MONET_DPI_SCALE)
	imgui.GetStyle().FramePadding = imgui.ImVec2(5 * MONET_DPI_SCALE, 5 * MONET_DPI_SCALE)
	imgui.GetStyle().ItemSpacing = imgui.ImVec2(5 * MONET_DPI_SCALE, 5 * MONET_DPI_SCALE)
	imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2 * MONET_DPI_SCALE, 2 * MONET_DPI_SCALE)
	imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
	imgui.GetStyle().IndentSpacing = 0
	imgui.GetStyle().ScrollbarSize = 10 * MONET_DPI_SCALE
	imgui.GetStyle().GrabMinSize = 10 * MONET_DPI_SCALE
	imgui.GetStyle().WindowBorderSize = 1 * MONET_DPI_SCALE
	imgui.GetStyle().ChildBorderSize = 1 * MONET_DPI_SCALE
	imgui.GetStyle().PopupBorderSize = 1 * MONET_DPI_SCALE
	imgui.GetStyle().FrameBorderSize = 1 * MONET_DPI_SCALE
	imgui.GetStyle().TabBorderSize = 1 * MONET_DPI_SCALE
	imgui.GetStyle().WindowRounding = 8 * MONET_DPI_SCALE
	imgui.GetStyle().ChildRounding = 8 * MONET_DPI_SCALE
	imgui.GetStyle().FrameRounding = 8 * MONET_DPI_SCALE
	imgui.GetStyle().PopupRounding = 8 * MONET_DPI_SCALE
	imgui.GetStyle().ScrollbarRounding = 8 * MONET_DPI_SCALE
	imgui.GetStyle().GrabRounding = 8 * MONET_DPI_SCALE
	imgui.GetStyle().TabRounding = 8 * MONET_DPI_SCALE
	imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
	imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
	imgui.GetStyle().SelectableTextAlign = imgui.ImVec2(0.5, 0.5)
	imgui.GetStyle().Colors[imgui.Col.Text] = ColorAccentsAdapter(generated_color.accent2.color_50):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TextDisabled] = ColorAccentsAdapter(generated_color.neutral1.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.WindowBg] = ColorAccentsAdapter(generated_color.accent2.color_900):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ChildBg] = ColorAccentsAdapter(generated_color.accent2.color_800):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.PopupBg] = ColorAccentsAdapter(generated_color.accent2.color_700):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.Border] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0xcc)
		:as_vec4()
	imgui.GetStyle().Colors[imgui.Col.Separator] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0xcc)
		:as_vec4()
	imgui.GetStyle().Colors[imgui.Col.BorderShadow] = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
	imgui.GetStyle().Colors[imgui.Col.FrameBg] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0x60)
		:as_vec4()
	imgui.GetStyle().Colors[imgui.Col.FrameBgHovered] = ColorAccentsAdapter(generated_color.accent1.color_600)
		:apply_alpha(0x70):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.FrameBgActive] = ColorAccentsAdapter(generated_color.accent1.color_600)
		:apply_alpha(0x50):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TitleBg] = ColorAccentsAdapter(generated_color.accent2.color_700):apply_alpha(0xcc)
		:as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed] = ColorAccentsAdapter(generated_color.accent2.color_700)
		:apply_alpha(0x7f):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TitleBgActive] = ColorAccentsAdapter(generated_color.accent2.color_700):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.MenuBarBg] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0x91)
		:as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ScrollbarBg] = imgui.ImVec4(0, 0, 0, 0)
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab] = ColorAccentsAdapter(generated_color.accent1.color_600)
		:apply_alpha(0x85):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered] = ColorAccentsAdapter(generated_color.accent1.color_600)
		:as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive] = ColorAccentsAdapter(generated_color.accent1.color_600)
		:apply_alpha(0xb3):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.CheckMark] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xcc)
		:as_vec4()
	imgui.GetStyle().Colors[imgui.Col.SliderGrab] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xcc)
		:as_vec4()
	imgui.GetStyle().Colors[imgui.Col.SliderGrabActive] = ColorAccentsAdapter(generated_color.accent1.color_600)
		:apply_alpha(0x80):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.Button] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xcc)
		:as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ButtonHovered] = ColorAccentsAdapter(generated_color.accent1.color_200)
		:apply_alpha(0xb3):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ButtonActive] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xb3)
		:as_vec4()
	imgui.GetStyle().Colors[imgui.Col.Tab] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xcc)
		:as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TabActive] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0xb3)
		:as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TabHovered] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0xb3)
		:as_vec4()
	imgui.GetStyle().Colors[imgui.Col.Header] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xcc)
		:as_vec4()
	imgui.GetStyle().Colors[imgui.Col.HeaderHovered] = ColorAccentsAdapter(generated_color.accent1.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.HeaderActive] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xb3)
		:as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ResizeGrip] = ColorAccentsAdapter(generated_color.accent2.color_700):apply_alpha(0xcc)
		:as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered] = ColorAccentsAdapter(generated_color.accent2.color_700)
		:as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ResizeGripActive] = ColorAccentsAdapter(generated_color.accent2.color_700)
		:apply_alpha(0xb3):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.PlotLines] = ColorAccentsAdapter(generated_color.accent2.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered] = ColorAccentsAdapter(generated_color.accent1.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.PlotHistogram] = ColorAccentsAdapter(generated_color.accent2.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered] = ColorAccentsAdapter(generated_color.accent1.color_600)
		:as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TextSelectedBg] = ColorAccentsAdapter(generated_color.accent1.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg] = ColorAccentsAdapter(generated_color.accent1.color_200)
		:apply_alpha(0x99):as_vec4()
end

function argbToHexWithoutAlpha(alpha, red, green, blue)
	return string.format("%02X%02X%02X", red, green, blue)
end

function rgba_to_argb(rgba_color)
	-- Ïîëó÷àåì êîìïîíåíòû öâåòà
	local r = bit32.band(bit32.rshift(rgba_color, 24), 0xFF)
	local g = bit32.band(bit32.rshift(rgba_color, 16), 0xFF)
	local b = bit32.band(bit32.rshift(rgba_color, 8), 0xFF)
	local a = bit32.band(rgba_color, 0xFF)

	-- Ñîáèðàåì ARGB öâåò
	local argb_color = bit32.bor(bit32.lshift(a, 24), bit32.lshift(r, 16), bit32.lshift(g, 8), b)

	return argb_color
end

function join_argb(a, r, g, b)
	local argb = b
	argb = bit.bor(argb, bit.lshift(g, 8))
	argb = bit.bor(argb, bit.lshift(r, 16))
	argb = bit.bor(argb, bit.lshift(a, 24))
	return argb
end

function explode_argb(argb)
	local a = bit.band(bit.rshift(argb, 24), 0xFF)
	local r = bit.band(bit.rshift(argb, 16), 0xFF)
	local g = bit.band(bit.rshift(argb, 8), 0xFF)
	local b = bit.band(argb, 0xFF)
	return a, r, g, b
end

function rgba_to_hex(rgba)
	local r = bit.rshift(rgba, 24) % 256
	local g = bit.rshift(rgba, 16) % 256
	local b = bit.rshift(rgba, 8) % 256
	local a = rgba % 256
	return string.format("%02X%02X%02X", r, g, b)
end

function ARGBtoRGB(color)
	return bit.band(color, 0xFFFFFF)
end

function ColorAccentsAdapter(color)
	local a, r, g, b = explode_argb(color)
	local ret = { a = a, r = r, g = g, b = b }
	function ret:apply_alpha(alpha)
		self.a = alpha
		return self
	end

	function ret:as_u32()
		return join_argb(self.a, self.b, self.g, self.r)
	end

	function ret:as_vec4()
		return imgui.ImVec4(self.r / 255, self.g / 255, self.b / 255, self.a / 255)
	end

	function ret:as_argb()
		return join_argb(self.a, self.r, self.g, self.b)
	end

	function ret:as_rgba()
		return join_argb(self.r, self.g, self.b, self.a)
	end

	function ret:as_chat()
		return string.format("%06X", ARGBtoRGB(join_argb(self.a, self.r, self.g, self.b)))
	end

	return ret
end

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(0) end

	welcome_message()
	initialize_commands()
	if settings.player_info.name_surname == '' or settings.player_info.fraction == 'Íåèçâåñòíî' then
		sampAddChatMessage('[Justice Helper] {ffffff}Ïûòàþñü ïîëó÷èòü âàø /stats ïîñêîëüêó îñòóñòâóþò äàííûå ïðî âàñ!',
			message_color)
		check_stats = true
		sampSendChat('/stats')
	end
	if settings.general.use_info_menu then
		InformationWindow[0] = true
	end
	if settings.player_organization.use_infojob_menu then
		JobInformationWindow[0] = true
	end
	if settings.general.mobile_meg_button and isMonetLoader() then
		MegafonWindow[0] = true
	end

	local result, check = pcall(check_update)
	if not result then
		sampAddChatMessage('[Justice Helper] {ffffff}Ïðîèçîøëà îøèáêà ïðè ïîïûòêå ïðîâåðèòü íàëè÷èå îáíîâëåíèé!',
			message_color)
	end



	while true do
		wait(0)

		if isMonetLoader() then
			if settings.general.mobile_fastmenu_button then
				if tonumber(#get_players()) > 0 and not FastMenu[0] and not FastMenuPlayers[0] then
					FastMenuButton[0] = true
				else
					FastMenuButton[0] = false
				end
			end
		end

		if nowGun ~= getCurrentCharWeapon(PLAYER_PED) and settings.general.rp_gun then
			oldGun = nowGun
			nowGun = getCurrentCharWeapon(PLAYER_PED)
			if oldGun == 0 then
				sampSendChat("/me " .. gunOn[nowGun] .. " " .. weapons.get_name(nowGun) .. " " .. gunPartOn[nowGun])
			elseif nowGun == 0 then
				sampSendChat("/me " .. gunOff[oldGun] .. " " .. weapons.get_name(oldGun) .. " " .. gunPartOff[oldGun])
			else
				sampSendChat("/me " ..
					gunOff[oldGun] ..
					" " ..
					weapons.get_name(oldGun) ..
					" " ..
					gunPartOff[oldGun] ..
					", ïîñëå ÷åãî " .. gunOn[nowGun] .. " " .. weapons.get_name(nowGun) .. " " .. gunPartOn[nowGun])
			end
		end

		if ((os.date("%M", os.time()) == "55" and os.date("%S", os.time()) == "00") or (os.date("%M", os.time()) == "25" and os.date("%S", os.time()) == "00")) and settings.general.auto_notify_payday and getARZServerNumber() ~= '200' then
			sampAddChatMessage(
				'[Justice Helper] {ffffff}×åðåç 5 ìèíóò áóäåò PAYDAY. Íàäåíüòå ôîðìó ÷òîáû íå ïðîïóñòèòü çàðïëàòó!',
				message_color)
			wait(1000)
		end
	end
end

function onScriptTerminate(script, game_quit)
	if script == thisScript() and not game_quit and not reload_script then
		sampAddChatMessage('[Prison Helper] {ffffff}Ïðîèçîøëà íåèçâåñòíàÿ îøèáêà, õåëïåð ïðèîñòàíîâèë ñâîþ ðàáîòó!',
			message_color)
		if not isMonetLoader() then
			sampAddChatMessage(
				'[Prison Helper] {ffffff}Èñïîëüçóéòå ' ..
				message_color_hex .. 'CTRL {ffffff}+ ' .. message_color_hex .. 'R {ffffff}÷òîáû ïåðåçàïóñòèòü õåëïåð.',
				message_color)
		end
		setInfraredVision(false)
		setNightVision(false)
		play_error_sound()
	end
end
