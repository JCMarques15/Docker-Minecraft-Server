FROM centos:8
LABEL maintainer="João Marques <jcnmarques@protonmail.com>"

# Define some build arguments
ARG user=LinuxGSM
ARG uid=5000
ARG gid=5000

# Setup dependencies
RUN dnf install -y --allowerasing epel-release file nmap-ncat ncurses diffutils curl wget tar bzip2 gzip unzip python3 binutils bc jq tmux java-11-openjdk

# Setup user
RUN groupadd --gid ${gid} ${user}
RUN useradd --create-home --shell /bin/bash --uid ${uid} --gid ${gid} ${user}

# Change working directory and user
WORKDIR /home/${user}
USER ${user}

# Download and install LinuxGSM
RUN curl -L https://linuxgsm.sh --output linuxgsm.sh
RUN chmod +x linuxgsm.sh

# Install Dont Starve Together server
RUN ./linuxgsm.sh mcserver
RUN ./mcserver auto-install

# Copy entrypoint
COPY --chown=${user}:${user} build/entrypoint.sh ./entrypoint.sh
RUN chmod +x entrypoint.sh

# Start Server
HEALTHCHECK --interval=1m --timeout=30s --start-period=1m --retries=3 CMD [ "./mcserver", "monitor", "||", "exit", "1" ]
ENTRYPOINT [ "./entrypoint.sh" ]