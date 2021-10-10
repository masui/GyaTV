compile:
	coffee -b -c public/javascripts/gyatv.coffee
push:
	git push git@github.com:masui/GyaTV.git
	git push pitecan.com:/home/masui/git/GyaTV.git

local:
	ruby gyatv.rb -p 3000

#
# Herokuコマンド
#
logs:
        heroku logs -t -a gyatv
restart:
        heroku restart -a gyatv
stop:
        heroku ps:scale web=0 -a gyatv
start:
        heroku ps:scale web=1 -a gyatv
