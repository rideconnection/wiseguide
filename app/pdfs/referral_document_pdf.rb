class ReferralDocumentPdf < Prawn::Document
  def initialize(referral_document)
    super(:top_margin => 70)
    @refdoc = referral_document
    font "Helvetica", :size => 12
    title
    resources
    timestamp
  end
  
  def title
    text "Referral Document for #{@refdoc.customer.name}", :size => 30
    text "Case Opened #{@refdoc.kase.open_date.strftime("%e-%b-%4Y")}", :size => 20, :inline_format => true
  end
  
  def resources
    @refdoc.referral_document_resources.each do |resource|
      move_down 40
      resource_details(resource)
    end
  end
  
  def resource_details(resource)
    # My Resource
    # | Phone:         | 555-555-5555                                        |
    # | Email:         | some1@resource.gov                                  |
    # | URL:           | http://t.co/qwer                                    |
    # | Address:       | 123 My Way, Sunnville, WA 12345                     |
    # | Hours:         | Sunday 9 - 5                                        |
    # |                | Monday 8 - 8                                        |
    # | Resource Note: | This is the note that never ends. Yes, it goes on   |
    # |                | and on my friends. Some people started writing it   |
    # |                | not knowing what it was, and they'll continue       |
    # |                | writing it forever just because this is the note    |
    # |                | that never ends...                                  |
    # | Referral Note  | Blah blah blah blah blah blah blah blah blah blah   |
    # |                | blah blah blah blah blah blah blah blah blah...     |
    text "#{resource.resource.name}", :size => 16, :style => :bold
    table [
      ["<b>Phone:</b>",         "#{resource.resource.phone_number}"], 
      ["<b>Email:</b>",         "<link href=\"mailto:#{resource.resource.email}\">#{resource.resource.email}</link>"], 
      ["<b>URL:</b>",           "<link href=\"#{resource.resource.url}\">#{resource.resource.url}</link>"], 
      ["<b>Address:</b>",       "#{resource.resource.address}"], 
      ["<b>Hours:</b>",         "#{resource.resource.hours}"], 
      ["<b>Resource Note:</b>", "#{resource.resource.notes}"], 
      ["<b>Referral Note:</b>", "#{resource.note}"]
    ], :column_widths => [100, 400], :cell_style => { :border_width => 0, :inline_format => true, :padding => [4, 4, 4, 0] }
  end

  def timestamp
    move_down 40
    stroke_horizontal_rule
    move_down 10
    text "Referral document opened at #{@refdoc.created_at.strftime("%e-%b-%4Y %r")}", :size => 10
    text "Referral document generated at #{Time.current.strftime("%e-%b-%4Y %r")}", :size => 10
  end
end
