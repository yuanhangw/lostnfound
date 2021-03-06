class Praise < ActiveRecord::Base
  attr_accessible :user_id, :shoot_id, :content
  
  belongs_to :user, :class_name => "User"
  belongs_to :shoot, :class_name => "Shoot"
  has_one :smoke, :through => :shoot
  has_one :wolf, :through => :smoke

  validates :user_id, :presence => true
  validates :shoot_id, :presence => true
  #content validation commented out for the time being 
  #validates :content, :presence => true

  default_scope :order => 'praises.created_at DESC'


  def report_updated

       Messenger.send_message!('praise_updated', ">>>>>>>>>>>>>>>>PRAISE UPDATED<<<<<<<<<<<<")
 
  end
  handle_asynchronously :report_updated, :run_at => Proc.new { 60.seconds.from_now }

      

end
