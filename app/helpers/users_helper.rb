module UsersHelper
  require "erb"
  include ERB::Util

  def myEscapeHTML(s)
   s.gsub(/&/, '*')
     .gsub(/\n/, '\\n')
     .gsub(/"/, '\"')
     .gsub(/'/, "\\'")
  end
    #.gsub(/</, '*')
    #.gsub(/>/, '*')

  def myTextToHTMLText(s)
   ("<p>" + s.gsub(/&/, '*')
     .gsub(/</, '&lt;')
     .gsub(/>/, '&gt;')
     .gsub(/\n/, '</p><p>')
     .gsub(/"/, '"')
     .gsub(/'/, "\'") + "</p>").html_safe
  end

   #html_escape(s)
end
