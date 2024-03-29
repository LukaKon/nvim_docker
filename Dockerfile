# Docker file for base Neovim image.

# Debian image as base
FROM debian:latest

# Set the locale
RUN apt-get update && apt-get -y install locales

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
    
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# Set timezone
ENV TZ="Europe/Warsaw"

# Expose some ports to host by default.
EXPOSE 8080 8081 8082 8083 8084 8085

# Define which Neovim COC extensions should be installed.
#ARG COC='coc-css cocEurope/Warsaweslint coc-html coc-json coc-sh coc-sql coc-tsserver coc-java coc-java-debug coc-xml coc-yaml'

# Lazygit variables
ARG LG='lazygit'
ARG LG_GITHUB='https://github.com/jesseduffield/lazygit/releases/download/v0.29/lazygit_0.29_Linux_x86_64.tar.gz'
ARG LG_ARCHIVE='lazygit.tar.gz'

# Update repositories and install software:
# 1. curl.
# 2. fzf for fast file search.
# 3. ripgrep for fast text occurrence search.
# 4. tree for files tree visualization.
# 5. Git.
# 6. Lazygit for Git visualization.
# 7. xclip for clipboard handling.
# 8. Python 3.
# 9. pip for Python.
# 10. NodeJS.
# 11. npm for NodeJS.
# 12. tzdata to set default container timezone.
# 13. Everything needed to install Neovim from source.
RUN apt-get -y install curl fzf ripgrep tree git xclip python3 python3-pip nodejs npm tzdata ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip openjdk-11-jdk watchman

# Cooperate Neovim with Python 3.
RUN pip3 install pynvim pyright

# Cooperate NodeJS with Neovim.
RUN npm i -g neovim typescript typescript-language-server

# Install Neovim from source.
RUN mkdir -p /root/TMP
RUN cd /root/TMP && git clone https://github.com/neovim/neovim
RUN cd /root/TMP/neovim && git checkout stable && make -j4 && make install
RUN rm -rf /root/TMP

# Create directory for Neovim spell check dictionaries.
RUN mkdir -p /root/.local/share/nvim/site/spell

# Copy Neovim dictionaries.
COPY ./spell/ /root/.local/share/nvim/site/spell/

# Create directory for Neovim configuration files.
RUN mkdir -p /root/.config/nvim

# Install Node.js debugger adapter.
#RUN cd /root/.config/nvim/plugins/vimspector && python3 install_gadget.py --force-enable-node

# Install Lazygit from binary
RUN mkdir -p /root/TMP && cd /root/TMP && curl -L -o $LG_ARCHIVE $LG_GITHUB
RUN cd /root/TMP && tar xzvf $LG_ARCHIVE && mv $LG /usr/bin/
RUN rm -rf /root/TMP

# Bash aliases
COPY ./home/ /root/

# Create directory for projects (there should be mounted from host).
RUN mkdir -p /root/workspace
#COPY ./app /root/workspace

# Set default location after container startup.
WORKDIR /root/workspace

# Avoid container exit.
CMD ["tail", "-f", "/dev/null"]
