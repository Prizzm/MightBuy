ActiveAdmin.register_page "Dashboard" do
  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Products Added" do
          h2 Product.all.count
        end
      end

      column do
        panel "Recent Beta Signups" do
          table_for BetaSignup.recent(5) do
            column "Email" do |item|
              item.email
            end
            column "At" do |item|
              item.created_at
            end
          end
        end
      end

      column do
        panel "Users Added" do
          h2 User.all.count
        end
      end
    end
  end
end