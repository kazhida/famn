# -*- encoding: utf-8 -*-

[
  {
    login_name: 'sakamoto',
    display_name: '坂本'
  },
  {
    login_name: 'ito',
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
    login_name: 'hirohumi',
    display_name: '博文',
    password: 'foobar',
    mail_address: 'hirohumi@example.com',
    family: Family.find_by_login_name('ito'),
    aruji:  true
  },
  {
    login_name: 'hideaki',
    display_name: '英明',
    password: 'foobar',
    mail_address: 'hideaki@example.com',
    family: Family.find_by_login_name('ito'),
    aruji:  false
  },
  {
    login_name: 'ryuichi',
    display_name: '龍一',
    password: 'foobar',
    mail_address: 'ryuichi@example.com',
    family: Family.find_by_login_name('sakamoto'),
    aruji:  false
  },
  {
    login_name: 'ryoma',
    display_name: '龍馬',
    password: 'foobar',
    mail_address: 'ryoma@example.com',
    family: Family.find_by_login_name('sakamoto'),
    aruji:  false
  },
  {
    login_name: 'otome',
    display_name: '乙女',
    password: 'foobar',
    mail_address: 'otome@example.com',
    family: Family.find_by_login_name('sakamoto'),
    aruji:  true
  },
  {
    login_name: 'ryoma',
    display_name: '亮馬',
    password: 'foobar',
    mail_address: 'ryoma@example.com',
    family: Family.find_by_login_name('ito'),
    aruji:  false
  },
  {
    login_name: 'kazuyuki',
    display_name: '一幸',
    password: 'foobar',
    mail_address: 'kazhida@abplus.com',
    family: Family.find_by_login_name('ito'),
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
    user: User.find_by_login_name('hirohumi'),
    family: Family.find_by_login_name('ito'),
    posted_on: Date::new(2012, 01, 01)
  },
  {
    message:  'ho.',
    user: User.find_by_login_name('hirohumi'),
    family: Family.find_by_login_name('ito'),
    posted_on: Date::new(2012, 12, 12)
  },
  {
    message:  '仁しぇんしぇい。',
    user: User.find_by_login_name('ryoma'),
    family: Family.find_by_login_name('sakamoto'),
    posted_on: Date::new(2012, 01, 01)
  },
  {
    message:  '大変がぜよ。',
    user: User.find_by_login_name('ryoma'),
    family: Family.find_by_login_name('sakamoto'),
    posted_on: Date::new(2012, 02, 02)
  },
  {
    message:  '日本の夜明けぜよ。',
    user: User.find_by_login_name('ryoma'),
    family: Family.find_by_login_name('sakamoto'),
    posted_on: Date::new(2012, 11, 11)
  },
  {
    message:  'ぼけ',
    user: User.find_by_login_name('otome'),
    family: Family.find_by_login_name('sakamoto'),
    posted_on: Date::new(2012, 03, 03)
  }
].each do |e|
  Entry.create(
      message:  e[:message],
      user: e[:user],
      family: e[:family],
      posted_on: e[:posted_on]
  )
end
