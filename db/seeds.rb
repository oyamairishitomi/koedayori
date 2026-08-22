    # This file should ensure the existence of records required to run the application in every environment (production,
    # development, test). The code here should be idempotent so that it can be executed at any point in every environment.
    # The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
    #
    # Example:
    #
    #   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
    #     MovieGenre.find_or_create_by!(name: genre_name)
    #   end

    [
      "今日見た夢",
      "今日の朝ごはん",
      "からだの調子",
      "最近のうれしかったこと",
      "印象に残っているテレビ",
      "今日の天気",
      "好きな季節の思い出",
      "昔よく行った場所",
      "若い頃の趣味",
      "今日食べたいもの",
      "最近読んだ本や新聞",
      "好きな音楽や歌",
      "子どもの頃の遊び",
      "思い出の旅先",
      "庭や近所の植物",
      "昔の思い出の写真",
      "今日会った人",
      "好きな食べ物",
      "最近眠れているか",
      "お気に入りの場所",
      "昔の仕事の話",
      "好きな季節の食べ物",
      "今日の体調で気になること",
      "思い出の歌",
      "家族への一言",
      "今日の散歩コース",
      "昔の旅行の思い出",
      "好きなテレビ番組",
      "今日の気分",
      "最近楽しかったこと"
    ].each do |theme|
      Theme.find_or_create_by!(title: theme)
    end
