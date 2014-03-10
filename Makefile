all:
	@if [ ! -d ~/.rvm ]; then echo "Installing RVM..."; \curl -sSL https://get.rvm.io | bash -s stable --ruby=2.0.0; source ~/.bashrc; fi
	@bash --login -c rake
