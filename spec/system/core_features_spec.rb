# frozen_string_literal: true

RSpec.describe "Core features" do
  before do
    upload_theme_or_component

    theme = Theme.find_by!(name: "Troypoint Patron Membership")
    theme.update_setting(
      :exempt_groups,
      Group::AUTO_GROUPS[:trust_level_0].to_s,
    )
  end

  it_behaves_like "having working core features"
end