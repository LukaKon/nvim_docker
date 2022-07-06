# Neovim runs in docker

Genaral purpose is to test neovim configuration.
Config from this repo is actually in lua.


Check the references:
Dockerfile borrowed from [TheLoneKing](https://github.com/TheLoneKing) and neovim configuration from [c@m](https://github.com/ChristianChiarulli)

1. Enter to the cloned folder
2. Put your neovim configuration to 'config'.
3. To build docker image run:
```
docker build -t nvim:latest
```
4. Create and run container. Attach volumes `-v` (repleace absolute path to your directory):
  - with nvim configuration **(must be)**
  - with your code to edit
```
docker container run -it \
  -v /home/lk/dev/nvim_docker/config:/root/.config/nvim \
  -v /home/lk/dev:/root/workspace \
  --name nvim \
  nvim:latest \
  bash
```
5. Enter to container:
```
  docker container exec -it nvim bash
```
6. Enter `nvim` command. The plugins will install, exit from neovim `:q`. Enter again and check the result:) 
