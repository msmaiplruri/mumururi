# -*- coding: utf-8; -*-
# mumururi.rb : myself
#
# Copyright (C) 2015 by msmaiplruri
# You can redistribute it and/or modify it under GPL2 or any later version.
#

# html5
def doctype
	%Q[<!DOCTYPE html>]
end

def jquery_tag; "" end

def script_tag; "" end

# 最新
# 追記
# 編集
# を非表示
def navi_item( link, label, rel = nil )
    unless /^(edit)$/ =~ @mode then
        if label == h(navi_latest) then return "" end
    end
    if label == h(navi_update) then return "" end
    if label == h(navi_edit) then return "" end
	result = %Q[<span class="adminmenu"><a href="#{link}"]
	result << %Q[ rel="#{rel}"] if rel
	result << %Q[>#{label}</a></span>\n]
end

# 前提: edit_today.rb
# 日にも編集リンクをつける
def edit_today_link( date, title )
	unless /^(preview)$/ =~ @mode
		edit_today_init
		caption = @conf['edit_today.caption']
		unless @cgi.mobile_agent?
			<<-HTML
			#{title}\n<span class="edit-today">
			<a href="#{@update}?edit=true;#{date.strftime( 'year=%Y;month=%m;day=%d' )}" title="#{edit_today_edit_label( date )}" rel="nofollow">#{caption}</a>
			</span>
			HTML
		else
			title
		end
	else
		title
	end
end

# Local Variables:
# mode: ruby
# indent-tabs-mode: t
# tab-width: 4
# ruby-indent-level: 4
# End:
