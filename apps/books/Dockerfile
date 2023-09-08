FROM python:3.11

WORKDIR /app

COPY requirements.txt requirements.txt
COPY entrypoint.sh /entrypoint.sh

RUN pip install -r requirements.txt \
    && chmod +x /entrypoint.sh

COPY . .

ENTRYPOINT ["/entrypoint.sh"]
