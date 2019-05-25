compile:
	coffee -b -c public/javascripts/gyatv.coffee
push:
	git push git@github.com:masui/GyaTV.git
	git push pitecan.com:/home/masui/git/GyaTV.git

local:
	ruby gyatv.rb -p 3000
