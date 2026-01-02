--[[-------------------------------------------------------------------------
	White Noise - IGS Items Configuration
	Добавьте здесь все предметы для White Noise
	
	ВАЖНО: Оружия НЕ должны быть в IGS донат панели!
	Оружия доступны только через отдельный магазин оружия (wn_weaponshop)
---------------------------------------------------------------------------]]

--[[-------------------------------------------------------------------------
	Донат ранги
---------------------------------------------------------------------------]]
IGS("Donator", "wn_donator")
	:SetPrice(5)
	:SetTerm(30)
	:SetDescription("Базовые привилегии донатора White Noise")
	:SetCategory("Ранги")
	:SetNetworked(true)
	:SetOnActivate(function(pl)
		pl:SetNWString("WN_DonationRank", "donator")
		IGS.Notify(pl, "Вы получили ранг Donator!")
	end)

IGS("VIP", "wn_vip")
	:SetPrice(15)
	:SetTerm(30)
	:SetDescription("VIP привилегии с кастомными моделями")
	:SetCategory("Ранги")
	:SetNetworked(true)
	:SetOnActivate(function(pl)
		pl:SetNWString("WN_DonationRank", "vip")
		IGS.Notify(pl, "Вы получили ранг VIP!")
	end)

IGS("Premium", "wn_premium")
	:SetPrice(30)
	:SetTerm(30)
	:SetDescription("Премиум привилегии с бонусом опыта")
	:SetCategory("Ранги")
	:SetNetworked(true)
	:SetOnActivate(function(pl)
		pl:SetNWString("WN_DonationRank", "premium")
		IGS.Notify(pl, "Вы получили ранг Premium!")
	end)

IGS("Sponsor", "wn_sponsor")
	:SetPrice(50)
	:SetTerm(30)
	:SetDescription("Полные привилегии спонсора")
	:SetCategory("Ранги")
	:SetNetworked(true)
	:SetOnActivate(function(pl)
		pl:SetNWString("WN_DonationRank", "sponsor")
		IGS.Notify(pl, "Вы получили ранг Sponsor!")
	end)

--[[-------------------------------------------------------------------------
	Косметика - Головные уборы
---------------------------------------------------------------------------]]
IGS("Beret", "wn_hat_beret")
	:SetPrice(50)
	:SetTerm(30)
	:SetDescription("Классический военный берет")
	:SetCategory("Косметика - Головные уборы")
	:SetStackable()
	:SetNetworked(true)
	:SetOnActivate(function(pl)
		pl:SetNWString("WN_Cosmetic_wn_hat_beret", "1")
		IGS.Notify(pl, "Берет экипирован!")
	end)

IGS("Baseball Cap", "wn_hat_cap")
	:SetPrice(40)
	:SetTerm(30)
	:SetDescription("Стильная бейсболка")
	:SetCategory("Косметика - Головные уборы")
	:SetStackable()
	:SetNetworked(true)
	:SetOnActivate(function(pl)
		pl:SetNWString("WN_Cosmetic_wn_hat_cap", "1")
		IGS.Notify(pl, "Бейсболка экипирована!")
	end)

IGS("Combat Helmet", "wn_hat_helmet")
	:SetPrice(100)
	:SetTerm(30)
	:SetDescription("Тактический боевой шлем")
	:SetCategory("Косметика - Головные уборы")
	:SetStackable()
	:SetNetworked(true)
	:SetOnActivate(function(pl)
		pl:SetNWString("WN_Cosmetic_wn_hat_helmet", "1")
		IGS.Notify(pl, "Шлем экипирован!")
	end)

--[[-------------------------------------------------------------------------
	Косметика - Маски
---------------------------------------------------------------------------]]
IGS("Balaclava", "wn_mask_balaclava")
	:SetPrice(60)
	:SetTerm(30)
	:SetDescription("Тактическая маска-балаклава")
	:SetCategory("Косметика - Маски")
	:SetStackable()
	:SetNetworked(true)
	:SetOnActivate(function(pl)
		pl:SetNWString("WN_Cosmetic_wn_mask_balaclava", "1")
		IGS.Notify(pl, "Балаклава экипирована!")
	end)

IGS("Gas Mask", "wn_mask_gas")
	:SetPrice(80)
	:SetTerm(30)
	:SetDescription("Защитная противогазовая маска")
	:SetCategory("Косметика - Маски")
	:SetStackable()
	:SetNetworked(true)
	:SetOnActivate(function(pl)
		pl:SetNWString("WN_Cosmetic_wn_mask_gas", "1")
		IGS.Notify(pl, "Противогаз экипирован!")
	end)

--[[-------------------------------------------------------------------------
	Косметика - Рюкзаки
---------------------------------------------------------------------------]]
IGS("Tactical Backpack", "wn_backpack_tactical")
	:SetPrice(120)
	:SetTerm(30)
	:SetDescription("Военный тактический рюкзак")
	:SetCategory("Косметика - Рюкзаки")
	:SetStackable()
	:SetNetworked(true)
	:SetOnActivate(function(pl)
		pl:SetNWString("WN_Cosmetic_wn_backpack_tactical", "1")
		IGS.Notify(pl, "Рюкзак экипирован!")
	end)

--[[-------------------------------------------------------------------------
	Косметика - Следы (Trails)
---------------------------------------------------------------------------]]
IGS("White Trail", "wn_trail_white")
	:SetPrice(30)
	:SetTerm(30)
	:SetDescription("Элегантный белый след из частиц")
	:SetCategory("Косметика - Следы")
	:SetStackable()
	:SetNetworked(true)
	:SetOnActivate(function(pl)
		pl:SetNWString("WN_Cosmetic_wn_trail_white", "1")
		IGS.Notify(pl, "Белый след активирован!")
	end)

IGS("Glow Trail", "wn_trail_glow")
	:SetPrice(50)
	:SetTerm(30)
	:SetDescription("Светящийся след из частиц")
	:SetCategory("Косметика - Следы")
	:SetStackable()
	:SetNetworked(true)
	:SetOnActivate(function(pl)
		pl:SetNWString("WN_Cosmetic_wn_trail_glow", "1")
		IGS.Notify(pl, "Светящийся след активирован!")
	end)

--[[-------------------------------------------------------------------------
	Косметика - Эффекты
---------------------------------------------------------------------------]]
IGS("Aura Effect", "wn_effect_aura")
	:SetPrice(100)
	:SetTerm(30)
	:SetDescription("Мистическая аура вокруг игрока")
	:SetCategory("Косметика - Эффекты")
	:SetStackable()
	:SetNetworked(true)
	:SetOnActivate(function(pl)
		pl:SetNWString("WN_Cosmetic_wn_effect_aura", "1")
		IGS.Notify(pl, "Эффект ауры активирован!")
	end)

IGS("Sparkles", "wn_effect_sparkles")
	:SetPrice(80)
	:SetTerm(30)
	:SetDescription("Искрящийся эффект частиц")
	:SetCategory("Косметика - Эффекты")
	:SetStackable()
	:SetNetworked(true)
	:SetOnActivate(function(pl)
		pl:SetNWString("WN_Cosmetic_wn_effect_sparkles", "1")
		IGS.Notify(pl, "Эффект искр активирован!")
	end)

--[[-------------------------------------------------------------------------
	Косметика - Теги в нике
---------------------------------------------------------------------------]]
IGS("VIP Tag", "wn_tag_vip")
	:SetPrice(200)
	:SetPerma()
	:SetDescription("Тег [VIP] в нике")
	:SetCategory("Косметика - Теги")
	:SetStackable()
	:SetNetworked(true)
	:SetOnActivate(function(pl)
		pl:SetNWString("WN_Cosmetic_wn_tag_vip", "1")
		IGS.Notify(pl, "VIP тег активирован!")
	end)

IGS("Donator Tag", "wn_tag_donator")
	:SetPrice(150)
	:SetPerma()
	:SetDescription("Тег [DONATOR] в нике")
	:SetCategory("Косметика - Теги")
	:SetStackable()
	:SetNetworked(true)
	:SetOnActivate(function(pl)
		pl:SetNWString("WN_Cosmetic_wn_tag_donator", "1")
		IGS.Notify(pl, "Тег донатора активирован!")
	end)

--[[-------------------------------------------------------------------------
	ПРИМЕЧАНИЕ:
	
	Оружия НЕ должны быть в IGS донат панели!
	Оружия доступны только через отдельный магазин оружия:
	- Команда: wn_weaponshop или !weaponshop
	- Оружия покупаются через отдельную систему (не IGS)
	- Или через админ команды для тестирования
---------------------------------------------------------------------------]]