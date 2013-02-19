class PraiseObserver < ActiveRecord::Observer

  def after_commit(record)
    puts record.content
    record.report_updated

  end

end
