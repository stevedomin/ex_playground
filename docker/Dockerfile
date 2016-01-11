FROM stevedomin/elixir:1.2.0
MAINTAINER Steve Domin <steve@stevedomin.com>

RUN useradd -ms /bin/bash elixir
USER elixir
ENV HOME /home/elixir
WORKDIR /home/elixir

ENTRYPOINT ["elixir", "-e"]
