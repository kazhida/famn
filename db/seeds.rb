# -*- encoding: utf-8 -*-

[
  {
      login_name: 'admin',
      display_name: '管理者'
  },
  {
      login_name: 'visitor',
      display_name: '['
  },
  {
    login_name: 'sakamot0',
    display_name: '坂本'
  },
  {
    login_name: 'it0',
    display_name: '伊藤'
  },
  {
    login_name: 'hida',
    display_name: '樋田'
  }
].each do |f|
  Family.create(
    login_name: f[:login_name],
    display_name: f[:display_name]
  )
end

[
  {
      login_name: 'root',
      display_name: '代表',
      password: ENV['FAMN_ROOT_PASSWORD'],
      mail_address: 'hirohumi@example.com',
      family: Family.find_by_login_name('admin'),
      aruji:  true
  },
  {
      login_name: 'guest',
      display_name: 'ゲスト]',
      password: 'have_fun',
      mail_address: 'hirohumi@example.com',
      family: Family.find_by_login_name('visitor'),
      aruji:  true
  },
  {
      login_name: 'guest1',
      display_name: 'ゲスト] (1)',
      password: 'have_fun',
      mail_address: 'hirohumi@example.com',
      family: Family.find_by_login_name('visitor'),
      aruji:  true
  },
  {
      login_name: 'guest2',
      display_name: 'ゲスト] (2)',
      password: 'have_fun',
      mail_address: 'hirohumi@example.com',
      family: Family.find_by_login_name('visitor'),
      aruji:  true
  },
  {
      login_name: 'guest3',
      display_name: 'ゲスト] (3)',
      password: 'have_fun',
      mail_address: 'hirohumi@example.com',
      family: Family.find_by_login_name('visitor'),
      aruji:  true
  },
  {
      login_name: 'guest4',
      display_name: 'ゲスト] (4)',
      password: 'have_fun',
      mail_address: 'hirohumi@example.com',
      family: Family.find_by_login_name('visitor'),
      aruji:  true
  },
  {
    login_name: 'hirohumi',
    display_name: '博文',
    password: 'foobar',
    mail_address: 'hirohumi@example.com',
    family: Family.find_by_login_name('it0'),
    aruji:  true
  },
  {
    login_name: 'hideaki',
    display_name: '英明',
    password: 'foobar',
    mail_address: 'hideaki@example.com',
    family: Family.find_by_login_name('it0'),
    aruji:  false
  },
  {
    login_name: 'ryuichi',
    display_name: '龍一',
    password: 'foobar',
    mail_address: 'ryuichi@example.com',
    family: Family.find_by_login_name('sakamot0'),
    aruji:  false
  },
  {
    login_name: 'ryoma',
    display_name: '龍馬',
    password: 'foobar',
    mail_address: 'ryoma@example.com',
    family: Family.find_by_login_name('sakamot0'),
    aruji:  false
  },
  {
    login_name: 'otome',
    display_name: '乙女',
    password: 'foobar',
    mail_address: 'otome@example.com',
    family: Family.find_by_login_name('sakamot0'),
    aruji:  true
  },
  {
    login_name: 'ryoma',
    display_name: '亮馬',
    password: 'foobar',
    mail_address: 'ryoma@example.com',
    family: Family.find_by_login_name('it0'),
    aruji:  false
  },
  {
      login_name: 'kyu',
      display_name: '九',
      password: 'foobar',
      mail_address: 'ryoma@example.com',
      family: Family.find_by_login_name('sakamot0'),
      aruji:  false
  },
  {
    login_name: 'kazuyuki',
    display_name: '一幸',
    password: 'foobar',
    mail_address: 'kazhida@abplus.com',
    family: Family.find_by_login_name('hida'),
    aruji:  true
  }
].each do |u|
  User.create(
      login_name: u[:login_name],
      display_name: u[:display_name],
      password: u[:password],
      mail_address: u[:mail_address],
      family: u[:family],
      aruji:  u[:aruji]
  )
end

[
  {
    message:  'hi.',
    user: User.user_by_names('it0', 'hirohumi'),
    posted_on: Date::new(2012, 01, 01)
  },
  {
    message:  'ho.',
    user: User.user_by_names('it0', 'hirohumi'),
    posted_on: Date::new(2012, 12, 12)
  },
  {
    message:  '仁しぇんしぇい。',
    user: User.user_by_names('sakamot0', 'ryoma'),
    posted_on: Date::new(2012, 01, 01)
  },
  {
    message:  '大変がぜよ。',
    user: User.user_by_names('sakamot0', 'ryoma'),
    posted_on: Date::new(2012, 02, 02)
  },
  {
    message:  '日本の夜明けぜよ。',
    user: User.user_by_names('sakamot0', 'ryoma'),
    posted_on: Date::new(2012, 11, 11)
  },
  {
    message:  'ぼけ',
    user: User.user_by_names('sakamot0', 'otome'),
    posted_on: Date::new(2012, 03, 03)
  },
  {
      message:  '@sakamot0 ぼけ',
      user: User.user_by_names('it0', 'ryoma'),
      posted_on: Date::new(2012, 03, 04)
  }
].each do |e|
  Entry.create(
      message:  e[:message],
      user: e[:user],
      family: e[:family],
      posted_on: e[:posted_on]
  )
end

(1..31).each do |i|
  Entry.create(
      message:  "#{i}日ぜよ。",
      user:     User.user_by_names('sakamot0', 'ryoma'),
      posted_on: Date::new(2012, 12, i)
  )
end

(1..12).each do |i|
  Entry.create(
      message:  "#{i}月9日です。",
      user:     User.user_by_names('sakamot0', 'kyu'),
      posted_on: Date::new(2012, i, 9)
  )
end