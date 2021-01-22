module TicketsHelper
  def toggle_watching_button(ticket)
    text = if ticket.watchers.include?(current_user)
      "Unwatch"
    else
      "Watch"
    end
    link_to text, watch_project_ticket_path(ticket.project, ticket),
      class: text.parameterize, method: :patch
  end
end
