defmodule ExAdsWeb.ChangesetView do
  use ExAdsWeb, :view

  def render("error.json", %{changeset: changeset}) do
    %{errors: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)}
  end
end
