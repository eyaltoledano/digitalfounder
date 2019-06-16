Could make a nested dropdown for each version

<div class="navbar-dropdown">
  <div class="nested navbar-item dropdown">
    <div class="dropdown-trigger">
      <div aria-haspopup="true" aria-controls="dropdown-menu">
        <%= product.name %>
        <span class="icon is-small">
          <i class="fas fa-angle-down" aria-hidden="true"></i>
        </span>
      </div>
    </div>
    <div class="dropdown-menu" id="dropdown-menu" role="menu">
      <div class="dropdown-content">
        <% !if product.versions.empty? %>
          <% product.versions.each do |version| %>
          <a href="/<%=product.slug%>/<%=version.version_number%>" class="dropdown-item">
            <%= "#{version.name} (#{version.version_number})" %>
          </a>
          <% end %>
        <% end %>
      </div>
    </div>
  </div>
</div>
