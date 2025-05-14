all: install

install:
	@echo "install to ~/bin"
	mkdir -pv ~/bin
	@echo "copying file to ~/bin"
	install -m 0755 wrapper.sh ~/bin/ffmpeg