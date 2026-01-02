-- White Noise - Interaction System (Shared)
-- Система взаимодействий для игроков

wn.Interactions = wn.Interactions or {}

-- Категории взаимодействий
wn.Interactions.Categories = {
	["gestures"] = {
		name = "Жесты",
		icon = "icon16/emoticon_smile.png"
	},
	["phrases"] = {
		name = "Фразы",
		icon = "icon16/comment.png"
	},
	["actions"] = {
		name = "Действия",
		icon = "icon16/cog.png"
	},
	["emotes"] = {
		name = "Эмоции",
		icon = "icon16/emoticon_happy.png"
	}
}

-- Жесты
wn.Interactions.Gestures = {
	["wave"] = {
		name = "Помахать",
		description = "Помахать рукой",
		category = "gestures",
		animation = ACT_GMOD_GESTURE_WAVE,
		sound = nil
	},
	["salute"] = {
		name = "Салют",
		description = "Отдать честь",
		category = "gestures",
		animation = ACT_GMOD_GESTURE_SALUTE,
		sound = nil
	},
	["bow"] = {
		name = "Поклон",
		description = "Поклониться",
		category = "gestures",
		animation = ACT_GMOD_GESTURE_BOW,
		sound = nil
	},
	["becon"] = {
		name = "Подозвать",
		description = "Подозвать кого-то",
		category = "gestures",
		animation = ACT_GMOD_GESTURE_BECON,
		sound = nil
	},
	["agree"] = {
		name = "Согласие",
		description = "Кивнуть в знак согласия",
		category = "gestures",
		animation = ACT_GMOD_GESTURE_AGREE,
		sound = nil
	},
	["disagree"] = {
		name = "Несогласие",
		description = "Покачать головой",
		category = "gestures",
		animation = ACT_GMOD_GESTURE_DISAGREE,
		sound = nil
	},
	["point"] = {
		name = "Указать",
		description = "Указать пальцем",
		category = "gestures",
		animation = ACT_GMOD_GESTURE_POINT,
		sound = nil
	}
}

-- Фразы (крики)
wn.Interactions.Phrases = {
	["help"] = {
		name = "Помогите!",
		description = "Крикнуть о помощи",
		category = "phrases",
		text = "Помогите!",
		sound = "vo/npc/male01/help01.wav"
	},
	["stop"] = {
		name = "Стой!",
		description = "Крикнуть 'Стой!'",
		category = "phrases",
		text = "Стой!",
		sound = "vo/npc/male01/stop02.wav"
	},
	["follow"] = {
		name = "Иди за мной!",
		description = "Попросить следовать",
		category = "phrases",
		text = "Иди за мной!",
		sound = "vo/npc/male01/overhere01.wav"
	},
	["yes"] = {
		name = "Да!",
		description = "Согласиться",
		category = "phrases",
		text = "Да!",
		sound = "vo/npc/male01/yeah02.wav"
	},
	["no"] = {
		name = "Нет!",
		description = "Отказать",
		category = "phrases",
		text = "Нет!",
		sound = "vo/npc/male01/no02.wav"
	},
	["thanks"] = {
		name = "Спасибо!",
		description = "Поблагодарить",
		category = "phrases",
		text = "Спасибо!",
		sound = "vo/npc/male01/thanks02.wav"
	},
	["sorry"] = {
		name = "Извини",
		description = "Извиниться",
		category = "phrases",
		text = "Извини",
		sound = "vo/npc/male01/sorry02.wav"
	},
	["watch_out"] = {
		name = "Осторожно!",
		description = "Предупредить об опасности",
		category = "phrases",
		text = "Осторожно!",
		sound = "vo/npc/male01/watchout.wav"
	},
	["behind_you"] = {
		name = "Сзади!",
		description = "Предупредить о враге сзади",
		category = "phrases",
		text = "Сзади!",
		sound = "vo/npc/male01/behindyou01.wav"
	},
	["nice_shot"] = {
		name = "Хороший выстрел!",
		description = "Похвалить за выстрел",
		category = "phrases",
		text = "Хороший выстрел!",
		sound = "vo/npc/male01/nice.wav"
	}
}

-- Действия
wn.Interactions.Actions = {
	["drop_weapon"] = {
		name = "Выбросить оружие",
		description = "Выбросить текущее оружие",
		category = "actions",
		icon = "icon16/gun.png"
	},
	["drop_all"] = {
		name = "Выбросить всё",
		description = "Выбросить всё оружие",
		category = "actions",
		icon = "icon16/package.png"
	},
	["surrender"] = {
		name = "Сдаться",
		description = "Поднять руки вверх",
		category = "actions",
		icon = "icon16/hand.png"
	},
	["fake_ragdoll"] = {
		name = "Фейк рагдолл",
		description = "Создать фейк рагдолл (ложное тело). Нажмите снова, чтобы встать",
		category = "actions",
		icon = "icon16/user_delete.png"
	},
	["sit"] = {
		name = "Сесть",
		description = "Присесть на корточки",
		category = "actions",
		icon = "icon16/user.png"
	},
	["lay"] = {
		name = "Лечь",
		description = "Лечь на землю",
		category = "actions",
		icon = "icon16/user_suit.png"
	}
}

-- Эмоции
wn.Interactions.Emotes = {
	["laugh"] = {
		name = "Смех",
		description = "Посмеяться",
		category = "emotes",
		animation = ACT_GMOD_TAUNT_LAUGH,
		sound = "vo/npc/male01/laugh01.wav"
	},
	["cry"] = {
		name = "Плач",
		description = "Заплакать",
		category = "emotes",
		animation = ACT_GMOD_TAUNT_MUSCLE,
		sound = "vo/npc/male01/startle01.wav"
	},
	["dance"] = {
		name = "Танец",
		description = "Потанцевать",
		category = "emotes",
		animation = ACT_GMOD_TAUNT_DANCE,
		sound = nil
	},
	["cheer"] = {
		name = "Радость",
		description = "Показать радость",
		category = "emotes",
		animation = ACT_GMOD_TAUNT_CHEER,
		sound = "vo/npc/male01/yeah02.wav"
	}
}
