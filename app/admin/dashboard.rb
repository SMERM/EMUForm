ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do
      column do
        panel "Recent Works submitted" do
          ul do
            Work.all.order('id desc').limit(5).map do |work|
              a = work.authors.uniq.first
              li link_to(work.title, author_work_path(a, work))
            end
          end
        end
      end

      column do
        panel "Roles" do
          ul do
            Role.all.order('description').map do |role|
              li link_to(role.description, role_path(role))
            end
          end
        end
      end
    end
  end # content
end
