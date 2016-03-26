module FactoryGirlHelper

  def check_unique(klass, field)
    res = nil
    while (true)
      res = yield
      break if (klass.where("#{field.to_s} = ?", res).count == 0)
    end
    res
  end

end
