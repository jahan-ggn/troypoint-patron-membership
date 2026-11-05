# frozen_string_literal: true

RSpec.describe "Core features", system: true do
  fab!(:patron_group) { Fabricate(:group) }

  before do
    patron_group.add(active_user)

    upload_theme_or_component

    theme = Theme.find_by!(name: "Troypoint Patron Membership")
    theme.update_setting(:exempt_groups, patron_group.id.to_s)
    theme.save!
  end

  it_behaves_like "having working core features"
end
