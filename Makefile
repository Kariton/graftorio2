#factorio/bin/x64/factorio --graphics-quality low --video-memory-usage low --load-game factoriofast/saves/_autosave2.zip --threads 4
#/Applications/Factorio.app/Contents/MacOS/factorio --graphics-quality low --video-memory-usage low --threads 4

VERSION=$$(git describe --abbrev=0 --tags)

release:
	mkdir -p pkg && \
		rm -f ./pkg/*.zip && \
		git archive --prefix=graftorio-ng/ -o pkg/graftorio-ng_$(VERSION).zip HEAD

install-darwin:
	cd ../ && zip --exclude="*.git*" --exclude="*pkg*" -r graftorio-ng/graftorio-ng_$(VERSION).zip graftorio-ng && \
		mv graftorio-ng/graftorio-ng_$(VERSION).zip ~/Library/Application\ Support/factorio/mods/

install-linux:
	cd ../ && zip --exclude="*.git*" --exclude="*pkg*" -r graftorio-ng/graftorio-ng_$(VERSION).zip graftorio-ng && \
		cp graftorio-ng/graftorio-ng_$(VERSION).zip ~/bin/factorio/mods/

clean:
	rm -rf ./data/prometheus && rm -rf ./data/grafana

docker:
	docker-compose up
