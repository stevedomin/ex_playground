defmodule ExPlayground.LayoutView do
  use ExPlayground.Web, :view

  def ga_tracking_id do
    Application.get_env(:ex_playground, :ga_tracking_id)
  end
end
