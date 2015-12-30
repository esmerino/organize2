module MovementsHelper
  def table_color(movement)
    return :info if movement.chargeable_type == 'Card'
    return :success if movement.paid?
    :warning
  end
end
