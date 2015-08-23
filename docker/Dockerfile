FROM stevedomin/elixir:1.0.5
MAINTAINER Steve Domin <steve@stevedomin.com>

RUN apt-get update && apt-get install -y python

RUN useradd -ms /bin/bash elixir
USER elixir
ENV HOME /home/elixir
WORKDIR /home/elixir

ENTRYPOINT ["elixir", "-e"]
