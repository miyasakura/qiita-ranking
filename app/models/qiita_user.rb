class QiitaUser < ActiveRecord::Base
  # see: http://grosser.it/2009/09/09/activerecord-find_each_with_order-find_each-with-order/
  # limit, offset 形式なので効率は良くない
  def self.find_each_with_order(options={})
    page = 1
    limit = options[:limit] || 1000

    while
      offset = (page-1) * limit
      batch = limit(limit).offset(offset)
      page += 1

      batch.each{|x| yield x }

      break if batch.size < limit
    end
  end

end
