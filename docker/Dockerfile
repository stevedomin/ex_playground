FROM stevedomin/elixir:1.3.1
MAINTAINER Steve Domin <steve@stevedomin.com>

RUN useradd -ms /bin/bash elixir
USER elixir
ENV HOME /home/elixir
WORKDIR /home/elixir

ENTRYPOINT ["elixir", "-e"]
