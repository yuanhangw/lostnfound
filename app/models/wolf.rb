class Wolf < ActiveRecord::Base
  attr_accessible :content, :reward 
  belongs_to :user
  has_many :smokes, :foreign_key => "wolf_id", :dependent => :destroy
  has_many :smokers, :through => :smokes, :source => :user
  has_many :shoots, :through => :smokes
  has_many :praises, :through => :shoots


  # validation is turned off to avoid a problem where double tab at the 
  # beginning of the textarea is considered :presence=false. 
  # validates :content, :presence => true, :length => { :maximum => 800 }
  validates :user_id, :presence => true

  default_scope :order => 'wolves.created_at DESC'




  def report_updated

       Messenger.send_message!('new_wolf', ">>>>>>>>>>>>>>>>WOLF UPDATED<<<<<<<<<<<<")
 
  end
  handle_asynchronously :report_updated, :run_at => Proc.new { 0.seconds.from_now }

end
