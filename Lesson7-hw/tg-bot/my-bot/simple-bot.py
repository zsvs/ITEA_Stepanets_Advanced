import requests as rs
import json
import telebot
import os
import re
from weather import NewWeatherAPI
from translate import Translator

bot = telebot.TeleBot(os.getenv("TG_API_KEY"))
translator= Translator(to_lang="russian")

@bot.message_handler(content_types=['text'])
def get_text_messages(message):
  if message.text.upper() == "ПОГОДА":
    bot.send_message(message.from_user.id, "Доброго времени суток, введите, пожалуйста, город. Используйте английский язык.")
  elif message.text.upper() == "/HELP":
    bot.send_message(message.from_user.id, "Напишите: Погода")
  elif re.match("[A-Z][a-z]", message.text):
    try:
      NewWeatherAPI.SetCity(message.text)
      NewWeatherAPI.CallAPI()
      Result = NewWeatherAPI.GetAnswer()
      print(Result["cod"]) #! Debug info
      bot.send_message(message.from_user.id, " Погода в {0}: {1}\nТемература: {2}°C\nВлажность: {3}%\nСкорость ветра: {4} м/с\nВидимость: {5}м".format(message.text, translator.translate(Result["weather"][0]["description"]), round(float(Result["main"]["temp"]) - 273.15), Result["main"]["humidity"], Result["wind"]["speed"], Result["visibility"]))
    except KeyError: #! In case of API response is empty
      bot.send_message(message.from_user.id, "Нету такого города! Попробуйте ввести другое название.")
  else:
    bot.send_message(message.from_user.id, "Такой команды нету. Напишите /help.")


bot.polling(none_stop=True, interval=0)
