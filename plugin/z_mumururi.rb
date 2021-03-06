# -*- coding: utf-8; -*-
# mumururi.rb : myself
#
# Copyright (C) 2015 by msmaiplruri
# You can redistribute it and/or modify it under GPL2 or any later version.
#

unless @mode =~ /(edit|preview|update|append|form)/ then
    def jquery_tag; "" end
    def script_tag; "" end
end

def default_ogp; "" end

def robot_control
    '<meta name="robots" content="noindex,nofollow,noarchive">'
end

#def navi_latest; "TOPに戻る" end

# 最新
# 追記
# 編集
# を非表示
=begin
def navi_item( link, label, rel = nil )
    unless /(^category)/ =~ @mode then
        if label == h(navi_latest) then return "" end
    end
    if label == h(navi_update) then return "" end
    if label == h(navi_edit) then return "" end
	result = %Q[<span class="adminmenu"><a href="#{link}"]
	result << %Q[ rel="#{rel}"] if rel
	result << %Q[>#{label}</a></span>\n]
end
=end

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

# ツッコミのメールアドレスを非表示
def comment_name_label; "名前" end
def comment_description; "" end

def comment_form_text
	unless @diary then
		@diary = @diaries[@date.strftime( '%Y%m%d' )]
		return '' unless @diary
	end

	r = ''
	unless @conf.hide_comment_form then
		r = <<-FORM
			<div class="form">
		FORM
		if @diary.count_comments( true ) >= @conf.comment_limit_per_day then
			r << <<-FORM
				<div class="caption"><a name="c">#{comment_limit_label}</a></div>
			FORM
		else
			r << <<-FORM
				<div class="caption"><a name="c">#{comment_description}</a></div>
				<form class="comment" name="comment-form" method="post" action="#{h @conf.index}"><div>
				<input type="hidden" name="date" value="#{ @date.strftime( '%Y%m%d' )}">
				<div class="field name">
					#{comment_name_label}
                    <br>
                    <input class="field" name="name" value="#{h( @conf.to_native(@cgi.cookies['tdiary'][0] || '' ))}">
				</div>
				<input class="field" name="mail" value="" type="hidden">
				<div class="textarea">
					#{comment_body_label}
                    <br>
                    <textarea name="body" cols="60" rows="5"></textarea>
				</div>
				<div class="button">
					<input type="submit" name="comment" value="#{h comment_submit_label}">
				</div>
				</div></form>
			FORM
		end
		r << <<-FORM
			</div>
		FORM
	end
    r
end

# 全文検索
# search-default.rb
def search_input_form( q )
    <<-HTML
        <form method="GET" action="#{@conf.index}"><div>
            <input name="q" value="#{h q}">
            <input type="submit" value="検索">
        </div></form>
    HTML
end

# 前提: category.rb ver 5.0.0
# gemで取得したtdiaryのcategory.rbに何故か無かったので追加
def category_list
    @categories.map do |c|
        %Q|<a href="#{h @index}?category=#{h c}">#{h c}</a>|
    end.join(" | \n")
end
@conf["category.header2"] = %Q[<p>Categories |\n<%= category_list %>\n</p>\n]

# Local Variables:
# mode: ruby
# indent-tabs-mode: t
# tab-width: 4
# ruby-indent-level: 4
# End:
