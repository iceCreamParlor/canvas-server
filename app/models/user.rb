class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  enum user_type: ["normal", "admin"]


  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :omniauthable

  mount_uploader :image, ImageUploader
  has_many :paintings
  has_many :magazines
  has_many :auctions
  has_many :likes
  has_many :follows, class_name:  "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :followed, class_name:  "Follow", foreign_key: "followed_id", dependent: :destroy

  # 보낸 메세지, 받은 메세지 구성하는 부분
  has_many :sent_messages, class_name: "Message", foreign_key: "sender_id"
  has_many :arrived_messages, class_name: "Message", foreign_key: "receiver_id"

  before_destroy :destroy_posts

  def user_categories
    Category.where(id: self.paintings.pluck(:category_id).uniq)
  end

  def follow_members
    User.where(id: self.followed.pluck(:follower_id))
  end

  def following_members
    User.where(id: self.follows.pluck(:followed_id))
  end

  def is_following(user)
    follow = Follow.where(follower_id: self.id, followed_id: user.id)
    if follow.present?
      return true
    end
    return false
  end

  # Get all matches
  def messages
    self.arrived_messages + self.sent_messages
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # user와 identity가 nil이 아니라면 받는다

    identity = Identity.find_for_oauth(auth)
    user = signed_in_resource ? signed_in_resource : identity.user

    # user가 nil이라면 새로 만든다.

    if user.nil?

      # 이미 있는 이메일인지 확인한다.

      email = auth.info.email
      user = User.where(:email => email).first

      unless self.where(email: auth.info.email).exists?
        # 없다면 새로운 데이터를 생성한다.

        if user.nil?
          # 카카오는 email을 제공하지 않음

          if auth.provider == "kakao"
            # provider(회사)별로 데이터를 제공해주는 hash의 이름이 다릅니다.

            # 각각의 omnaiuth별로 auth hash가 어떤 경로로, 어떤 이름으로 제공되는지 확인하고 설정해주세요.

            user = User.new(
              # profile_img: auth.info.image,
              # 이 부분은 AWS S3와 연동할 때 프로필 이미지를 저장하기 위해 필요한 부분입니다.

              # remote_profile_img_url: auth.info.image.gsub('http://','https://'),
              email: "kakaoUser@#{auth.uid}.com",
              remote_image_url: auth.info.image,
              nickname: auth.info.name,
              password: Devise.friendly_token[0,20]
            )
          elsif auth.provider == "google_oauth2" 
            
            user = User.new(
              email: auth.info.email,
              remote_image_url: auth.info.image,
              nickname: auth.info.name,
              password: Devise.friendly_token[0,20]
            )
          else
            
            user = User.new(
              email: auth.info.email,
              # profile_img: auth.info.image,
              # remote_profile_img_url: auth.info.image.gsub('http://','https://'),
              password: Devise.friendly_token[0,20]
            )
          end
          # SNS 로그인한 경우, 이메일 인증을 하지 않게 함
          user.confirm
          user.save!
        end
      end
    end

    if identity.user != user
      identity.user = user
      identity.save!
    end
    user

  end

  # email이 없어도 가입이 되도록 설정

  def email_required?
    false
  end

  def destroy_posts
    identity = Identity.find_by(user_id: self.id)
    if identity.present?
      identity.destroy
    end
    if self.paintings.present?
      self.paintings.destroy_all
    end
    if self.messages.present?
      self.arrived_messages.destroy_all
      self.sent_messages.destroy_all
    end
  end

end
