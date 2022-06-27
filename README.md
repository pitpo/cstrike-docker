# Yet another Counter-Strike 1.6 server Dockerfile

You know the drill - **Counter-Strike server**, but with slightly different setup than the other ones. I wanted to make it customizable so that I can run two servers with different base mods but common files, so there are some volume shenanigans in place.
If you are somehow reading this right now, this is still a work in progress.

## How to build

Prepare a file with steam password and two factor code that you will be using. Good luck with 2FA expiry timing :)
Run:
> DOCKER_BUILDKIT=1 docker build -t cstrike . --build-arg --secret id=STEAM_CREDENTIALS,src=**/path/to/your/secret**
STEAM_CREDENTIALS file should look somewhat like this
> john johnspassword AB123

## How to run

If you just want to get it going, run the following:
> docker run -d --rm -p 27015:27015/tcp -p 27015:27015/udp --mount type=volume,source=cstrike-data,target=/home/steam/hlds/cstrike,volume-driver=local,volume-opt=type=none,volume-opt=o=bind,volume-opt=device=**/path/where/cstrike/will/be/mounted/locally** --name cstrike cstrike


## Configuring the server

You should have access to cstrike volume, just do whatever there, changes will be applied in container.
If you want to start from scratch, use a new volume.
It's also possible to ignore it and do some basic configurations using environmental variables. You'll still most likely want to manually adjust some AMX settings, throw in some maps, plugins directly to the volume.
But that's coming soon

**Remember to backup your server frequently :)**
