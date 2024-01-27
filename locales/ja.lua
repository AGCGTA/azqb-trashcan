local Translations = {
    success = {
        deleted = 'ゴミ箱を空にしました'
    },
    interaction = {
        opentrash = 'ゴミ箱を開く',
        clear = 'ゴミ箱を空にする',
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
