FROM debian:stable

ARG STEAM_USER=anonymous

RUN apt update && apt install -y lib32gcc-s1 curl

RUN useradd -ms /bin/bash steam
USER steam

RUN mkdir -p /home/steam/steamcmd && cd /home/steam/steamcmd && curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
ENV PATH="/home/steam/steamcmd:${PATH}"

# Bug: 	HLDS (appid 90) currently requires multiple runs of the app_update command before all the required files are successfully installed. Simply run app_update 90 validate multiple times until no more updates take place.
# This or just install all dependencies manually, however to install HL (70) and CS (10), credentials to actual account that has them is required
RUN mkdir -p /home/steam/hlds
RUN --mount=type=secret,id=steam_password,uid=1000 \
    steamcmd.sh \
    +force_install_dir /home/steam/hlds \
    +login $STEAM_USER $(cat /run/secrets/steam_password) \
    +app_update 70 validate \ 
    +app_update 10 validate \ 
    +app_update 90 validate +quit 
RUN echo "10" > /home/steam/hlds/steam_appid.txt
RUN mkdir -p /home/steam/.steam && ln -s /home/steam/steamcmd/linux32 /home/steam/.steam/sdk32
ADD --chown=steam:steam run_server.sh /home/steam/hlds/run_server.sh
RUN chmod +x /home/steam/hlds/run_server.sh

WORKDIR /home/steam/hlds
EXPOSE 27015/udp 27015/tcp
VOLUME /home/steam/hlds/cstrike

ENTRYPOINT ["/home/steam/hlds/run_server.sh"]
