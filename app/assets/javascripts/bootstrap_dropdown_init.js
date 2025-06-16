// Bootstrap 5 Dropdown initialization and event handling
// This file ensures proper dropdown functionality after migration to Bootstrap 5

document.addEventListener('DOMContentLoaded', function() {
  
  // Initialize all Bootstrap 5 dropdowns
  var dropdownElementList = [].slice.call(document.querySelectorAll('[data-bs-toggle="dropdown"]'));
  var dropdownList = dropdownElementList.map(function (dropdownToggleEl) {
    return new bootstrap.Dropdown(dropdownToggleEl);
  });

  // For mega menu dropdowns with hover functionality on desktop
  if (window.innerWidth >= 768 && !('ontouchstart' in window)) {
    var megaMenuItems = document.querySelectorAll('.main-navigation .navbar-nav > li.dropdown');
    
    megaMenuItems.forEach(function(item) {
      var dropdownToggle = item.querySelector('[data-bs-toggle="dropdown"]');
      var dropdownInstance = bootstrap.Dropdown.getInstance(dropdownToggle);
      
      if (!dropdownInstance) {
        dropdownInstance = new bootstrap.Dropdown(dropdownToggle);
      }
      
      // Show dropdown on hover
      item.addEventListener('mouseenter', function() {
        if (!this.querySelector('.dropdown-menu').classList.contains('show')) {
          dropdownInstance.show();
        }
      });
      
      // Hide dropdown on mouse leave with delay
      item.addEventListener('mouseleave', function() {
        setTimeout(function() {
          if (dropdownInstance._element.closest('li:hover') === null) {
            dropdownInstance.hide();
          }
        }, 100);
      });
    });
  }

  // Handle mega menu for mobile devices (click to toggle)
  if (window.innerWidth < 768 || 'ontouchstart' in window) {
    var mobileDropdownToggles = document.querySelectorAll('.main-navigation [data-bs-toggle="dropdown"]');
    
    mobileDropdownToggles.forEach(function(toggle) {
      toggle.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        
        var parentLi = this.closest('li');
        var isOpen = parentLi.classList.contains('show');
        
        // Close all other dropdowns
        document.querySelectorAll('.main-navigation .dropdown').forEach(function(dropdown) {
          dropdown.classList.remove('show');
          var menu = dropdown.querySelector('.dropdown-menu');
          if (menu) menu.classList.remove('show');
        });
        
        // Toggle current dropdown
        if (!isOpen) {
          parentLi.classList.add('show');
          var menu = parentLi.querySelector('.dropdown-menu');
          if (menu) menu.classList.add('show');
        }
      });
    });
  }

  // Prevent dropdown from closing when clicking inside dropdown menu
  document.querySelectorAll('.dropdown-menu').forEach(function(menu) {
    menu.addEventListener('click', function(e) {
      e.stopPropagation();
    });
  });

  // Handle window resize to reinitialize behavior
  window.addEventListener('resize', function() {
    // Re-initialize dropdown behavior based on new window size
    setTimeout(function() {
      location.reload(); // Simple approach - reload page on resize
    }, 300);
  });

});