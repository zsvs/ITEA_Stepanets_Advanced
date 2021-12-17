import json
import requests as rs
import os
from translate import Translator
import re

class WeatherAPI:
    __Payload = None
    __Headers = None
    URL = "https://api.openweathermap.org/data/2.5/weather"
    __Answer = None

    def __init__(self):
        self.__Headers = {
                            "Content-type": "application/json",
                            "Accept": "*/*",
                            "User-Agent" : "Python_Client",
                            "Content-Encoding": "utf-8"
                        }
    def SetCity(self, City):
        """
        Setting up HTTP payload.
        Mandatory attribute <Data>, preferred to be a dict()
        """
        Payload = {'q': City, 'appid': os.getenv("OPENWEATHER_API_KEY")}
        self.__Payload = Payload

    def CallAPI(self):
        """
        Make API call to api.openweathermap.org
        """
        if self.__Payload:
            self.__Answer = rs.get(self.URL, params = self.__Payload, headers = self.__Headers)
            print("API call successful")
        else:
            print("No payload in HTTP request")
            raise Exception("Payload must be setted")

    def GetAnswer(self):
        """
        Returns HTTP code of response
        """
        return json.loads(self.__Answer.content)

NewWeatherAPI = WeatherAPI()
translator= Translator(to_lang="russian")
TG_API_URL = "https://api.telegram.org/bot{0}/".format(os.getenv("TG_API_KEY"))


def send_message(chat_id, text):
    url = TG_API_URL + "sendMessage?text={}&chat_id={}".format(text, chat_id)
    rs.get(url)

def lambda_handler(event, context):
    message = json.loads(event['body'])
    chat_id = message['message']['chat']['id']
    reply = message['message']['text']
    if reply.upper() == "ПОГОДА":
        send_message(chat_id, "Доброго времени суток, введите, пожалуйста, город. Используйте английский язык.")
    elif reply.upper() == "/HELP":
        send_message(chat_id, "Напишите: Погода")
    elif re.match("[A-Z][a-z]", reply):
        try:
            NewWeatherAPI.SetCity(reply)
            NewWeatherAPI.CallAPI()
            Result = NewWeatherAPI.GetAnswer()
            print(Result["cod"]) #! Debug info
            send_message(chat_id, " Погода в {0}: {1}\nТемература: {2}°C\nВлажность: {3}%\nСкорость ветра: {4} м/с\nВидимость: {5}м".format(reply, translator.translate(Result["weather"][0]["description"]), round(float(Result["main"]["temp"]) - 273.15), Result["main"]["humidity"], Result["wind"]["speed"], Result["visibility"]))
        except KeyError: #! In case of API response is empty
            send_message(chat_id, "Нету такого города! Попробуйте ввести другое название.")
    else:
        send_message(chat_id, "Такой команды нету. Напишите /help.")
    return {
        'statusCode': 200
    }
#https://api.telegram.org/bot5032241555:AAHxEAhvuZKeimwjjJNLYCuRTSzU0ttAmqI/setWebHook?url=https://1dguojpd5c.execute-api.eu-west-1.amazonaws.com/default/PyTgWeatherBot