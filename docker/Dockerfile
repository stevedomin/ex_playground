FROM stevedomin/elixir:1.0.3
MAINTAINER Steve Domin <steve@stevedomin.com>

RUN apt-get update && apt-get install -y python

COPY run-code.py /

CMD ["python", "run-code.py"]
