import json
import requests as rs
import os

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
