ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  tag = Nokogiri::HTML::DocumentFragment.parse(html_tag)
    .css('label, textarea, input, select').first

  case tag.node_name
  when 'label'
    tag.to_s.html_safe
  when 'textarea', 'input', 'select'
    tag[:class] = "#{tag[:class]} is-invalid"
    errors = Array(instance.error_message).to_sentence
    %(#{tag}<div class="invalid-feedback">#{errors}</div>).html_safe
  else
    ''
  end
end
