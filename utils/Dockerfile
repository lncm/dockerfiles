FROM python:3
MAINTAINER nolim1t <hello@nolim1t.co>

RUN mkdir /scripts
WORKDIR /scripts
COPY rpcauth.py ./
RUN chmod 755 /scripts/rpcauth.py

CMD ["python", "/scripts/rpcauth.py", "$USERNAME"]
