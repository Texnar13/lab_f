module UsersHelper
  require "erb"
  include ERB::Util



  def formatStringDateToText(sDate)
    date = DateTime.parse(sDate);
    return date.strftime("%F %H:%M");
  end


  def myEscapeHTML(s)
    if(s == nil)then
      s = ""
    end
    return s.gsub(/&/, '*')
      .gsub(/\n/, '\\n')
      .gsub(/"/, '\"')
      .gsub("'", "\\\\\'")#\\'
  end


  def myTextToHTMLText(s)
    if(s == nil)then
      s = ""
    end
    return ("<p>" + s.gsub(/&/, '*')
     .gsub(/</, '&lt;')
     .gsub(/>/, '&gt;')
     .gsub(/\n/, '</p><p>')
     .gsub(/"/, '"')
     .gsub(/'/, "\'") + "</p>").html_safe
  end

end
