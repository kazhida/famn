# -*- encoding: utf-8 -*-

require 'bcrypt'

class User < ActiveRecord::Base
  belongs_to      :family
  has_many        :entries, :dependent => :destroy

  attr_accessible :login_name
  attr_accessible :display_name
  attr_accessible :family
  attr_accessible :password
  attr_accessible :password_confirmation
  attr_accessible :setting_password
  attr_accessible :mail_address
  attr_accessible :aruji
  attr_accessible :current_password
  attr_accessible :new_password
  attr_accessible :new_password_confirmation
  attr_accessible :verification_token
  attr_accessible :verified_at
  attr_accessible :face

  accepts_nested_attributes_for :family

  attr_reader     :password
  attr_accessor   :current_password
  attr_reader     :new_password
  attr_accessor   :new_password_confirmation
  attr_writer     :setting_password
  attr_writer     :changing_password

  def setting_password?;  @setting_password;    end
  def changing_password?; @changing_password;   end

  def password=(pw)
    @password = pw
    @setting_password = true
  end

  def new_password=(pw)
    @new_password = pw
    @changing_password = true
  end

  def family_name
    family.display_name
  end

  validates_presence_of :login_name

  validate do
    if not /^[0-9a-zA-Z_]+$/ =~ login_name
      # 英数字+_
      errors.add(:login_name, '%s must be number, alphabetic character or "_".' % login_name)
    elsif (not family.nil?) && already_used_name?(login_name, family.id)
      # 同じ家族でかぶっている
      errors.add(:login_name, '%s is already used at families.' % login_name)
    elsif already_used_name?(login_name)
      # どこかの家族名とかぶっている
      errors.add(:login_name, '%s is already used at users same family.' % login_name)
    elsif User.family_users(family_id).count >= 10
      # 同一家族では10人まで
      errors.add(:login_name, '%s\'s has already 10 users.' % login_name)
    end
  end

  validate do
    if changing_password? && (not authenticate(current_password))
      # パスワード変更時に現在のパスワードが違っている
      errors.add(:current_password, :invalid)
    end
  end

  validates_presence_of     :display_name
  validates_presence_of     :family
  validates_presence_of     :password_digest
  validates_presence_of     :mail_address
  validates :current_password,
            :new_password,  :presence => { :if => :changing_password? }
  validates :password,
            :new_password,  :length => {:minimum => 6, :allow_blank =>true}, :confirmation => true

  before_validation do
    if setting_password?
      self.password_digest = BCrypt::Password.create(password)
    end
  end

  before_create do
    self.auto_login_token = SecureRandom.hex
  end

  before_save do
    if changing_password?
      self.password_digest = BCrypt::Password.create(new_password)
    end
  end

  # パスワード認証
  def authenticate(password)
    BCrypt::Password.new(password_digest) == password
  end

  def self.authenticated_user(family_name, user_name, password)
    user = user_by_names(family_name, user_name)

    if user && user.authenticate(password)
      user
    else
      nil
    end
  end

  # 家族名、ユーザ名を使った検索
  def self.user_by_names(family_name, user_name)
    families = Family.where('login_name = ?', family_name)
    if families && families.first
      users = User.where('family_id = ? AND login_name = ?', families.first.id, user_name)
      if users
        users.first
      end
    end
  end

  # 家族を指定して、そのユーザを取り出すメソッド
  def self.family_users(family_id, except_id = nil)
    if except_id.nil?
      User.where('family_id = ?', family_id).order(:created_at)
    else
      User.where('family_id = ?', family_id).where('NOT id = ?', except_id).order(:created_at)
    end
  end

  # 使用されている名前ならtrue
  def already_used_name?(name, family_id = nil)
    if family_id
      user = User.find_by_login_name_and_family_id(name, family_id)
      (not user.nil?) && (user.id != self.id)
    else
      not Family.find_by_login_name(name).nil?
    end
  end

  # ユーザの作成
  def self.add_new_user(login_name, display_name, mail_address, aruji, family, password = nil)
    unless family.kind_of?(Family)
      # 家族が登録されていない場合は作る
      names = family
      family = Family.new
      family.attributes = {
        login_name:   names[:login_name],
        display_name: names[:display_name]
      }
      return nil    unless family.save
    end

    user = User.new
    user.attributes = {
        login_name:         login_name,
        display_name:       display_name,
        password:           password || SecureRandom.hex(4),
        setting_password:   true,
        mail_address:       mail_address,
        aruji:              aruji,
        family:             family,
        verification_token: SecureRandom.hex
    }
    user.save ? user : nil
  end

  # ユーザ登録時の認証
  # 認証できたらtrue
  def self.verify(id, token)
    user = find_by_id(id)
    if user.try(:verification_token) == token
      user.update_attributes(verified_at: DateTime.current, verification_token: nil)
    end
  end

  # 認証されているかどうか
  def verified?
    verification_token.nil?
  end

  # アカウントの変更
  def update_account_info(family_name, user_name, mail_address, face, current_password = nil, new_password = nil, confirmation = nil)

    transaction do
      unless family_name.nil? || family_name.empty?
        family = Family.find(family_id)
        family.attributes = {:display_name => family_name}
        family.save!
      end

      if new_password.nil? || new_password.empty?
        self.attributes = {
            :display_name => user_name,
            :mail_address => mail_address,
            :face         => face
        }
      else
        self.attributes = {
            :display_name => user_name,
            :mail_address => mail_address,
            :face         => face,
            :current_password => current_password,
            :new_password => new_password,
            :new_password_confirmation => confirmation
        }
        @changing_password = true
      end

      self.save!
    end
    true

  rescue => e
    false
  end

  def icon(look = nil)
    if look.nil?
      "face_#{face}.png"
    else
      "face_#{face}_#{look}.png"
    end
  end
end
