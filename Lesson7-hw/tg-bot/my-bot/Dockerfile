FROM python:latest

WORKDIR /tg-weather-bot

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

ENV TG_API_KEY=None
ENV OPENWEATHER_API_KEY=None

COPY . .

CMD python3 simple-bot.py