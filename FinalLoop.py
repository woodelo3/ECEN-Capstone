import mysql.connector
import requests
from datetime import datetime, timedelta
import xml.etree.ElementTree as ET
mydb = mysql.connector.connect(
  host="sql5.freemysqlhosting.net",
  user="sql5486851",
  password="AV2VWZlUk5",
  database="sql5486851"
)

mycursor = mydb.cursor()
mycursor.execute("SELECT TF FROM UserWateringDays")
myresult = mycursor.fetchall()
days = []
divisor = 0
for x in myresult:
    if x[0] == "1":
        days.append(1)
        divisor+=1
    else:
        days.append(0)
#this should be incremented by count
today = datetime.today()
begin = today.strftime("%d/%m/%Y")
yesterday = today - timedelta(1)
strYesterday = str(yesterday)
strYesterday = strYesterday[:10]


strToday = str(today)
strToday = strToday[:10]
isMonday = (datetime(today.year, today.month, today.day).weekday())
print(isMonday)
#Find out if monday, if monday, run weekly predictive model & calculate how much watering
if isMonday == 0:
    '''
    url4 = "http://api.openweathermap.org/data/2.5/forecast?q=Houston&cnt=40&appid=b655486d628d222495cca8a28ed5e6f7&mode=xml"
    url3 = "http://api.openweathermap.org/data/2.5/forecast?q=Houston&cnt=40&appid=b655486d628d222495cca8a28ed5e6f7"
    # apiKey = "b655486d628d222495cca8a28ed5e6f7"
    url = "http://api.openweathermap.org/data/2.5/weather?lat=30.6187&lon=30.6187&appid=b655486d628d222495cca8a28ed5e6f7"
    url2 = "http://api.openweathermap.org/data/2.5/weather?lat=30.6187&lon=30.6187&appid=b655486d628d222495cca8a28ed5e6f7&mode=xml"
    response = requests.get(url)
    response2 = requests.get(url2)
    response3 = requests.get(url3)
    response4 = requests.get(url4)
    data = response3.json()
    string = response4.content
    root = ET.fromstring(string)
    rain = ""
    rainArr = []
    total_rain = 0
    for child in root:
        for child in child:
            for child in child:
                if child.tag == "precipitation":
                    tempStr = str(child.attrib)
                    if "value" in (tempStr):
                        num = ""
                        for x in tempStr[48:52]:
                            if x != "'":
                                num += x
                        num = float(num)
                        print(num)
                        rainArr.append(num)
                        total_rain += num
                    else:
                        rainArr.append(0)
    cumulative = 0
    list = data["list"]
    for x in range(40):
        data = list[x]
        date = data["dt_txt"]
        time = date[11::]
        date = date[0:10]
        main = data["main"]
        currentTempMin = main["temp_min"]
        currentTempMax = main["temp_max"]
        rain = rainArr[x]
        currentTemp = ((((currentTempMax + currentTempMin) / 2) - 273.15) * 9 / 5 + 32)
        currentPressure = main["pressure"]
        currentHumidity = main["humidity"]
        # rain = second
        sql = "INSERT INTO ForcastData (Date, Pressure, Rain, Humidity, Temperature) VALUES (%s, %s, %s, %s, %s)"
        mycursor = mydb.cursor()
        val = (date, time, currentPressure, rain, currentHumidity, currentTemp)
        mycursor.execute(sql, val)
        mydb.commit()
    '''
    url = "http://api.openweathermap.org/data/2.5/onecall?lat=30.6280&lon=-96.3344&exclude=hourly,current,alerts,minutely&appid=b655486d628d222495cca8a28ed5e6f7"
    # apiKey = "b655486d628d222495cca8a28ed5e6f7"
    response = requests.get(url)
    data = response.json()
    # print(data)
    daily = (data["daily"])
    dailyRain = 0
    dailyH = 0
    dailyT = 0
    dailyP = 0
    for x in range(7):
        date = today + timedelta(x)
        date = str(date)
        date = date[:10]
        humidity = daily[x]["humidity"]
        try:
            rain = daily[x]["rain"]
        except:
            rain = 0
        temperature = daily[x]["feels_like"]["day"]
        pressure = daily[x]["pressure"]
        temperature = int(temperature)
        temperature = 1.8 * (temperature - 273) + 32
        dailyRain =float(rain)
        dailyH =float(humidity)
        dailyT =float(temperature)
        dailyP =float(pressure)
        sql = "INSERT INTO ForcastData (Date, Pressure, Rain, Humidity, Temperature) VALUES (%s, %s, %s, %s, %s)"
        mycursor = mydb.cursor()
        val = (date, pressure, rain, humidity, temperature)
        mycursor.execute(sql, val)
        mydb.commit()
        #use this forcast data to derive predictive watering model
        #weekly irregation in mm
        predictedIrrigation = (25+(5*(dailyT/70)) - 5 * dailyH/100)/7 - dailyRain
        val = (date, predictedIrrigation)
        sql = "INSERT INTO PredictedIrrigation (Date, mm) VALUES (%s, %s)"
        mycursor.execute(sql, val)
        mydb.commit()



yesterdayDate = "'" + strYesterday + "'"
mycursor.execute("SELECT * FROM ForcastData WHERE Date =" + yesterdayDate)
myresult = mycursor.fetchall()
forcastRain = int(myresult[0][2])

todayDate = "'" + strToday + "'"
mycursor.execute("SELECT * FROM SensorData WHERE Date =" + strYesterday)
myresult = mycursor.fetchall()
actualRain = 0
for x in myresult:
    if x[2] == "3":
        actualRain += int(x[5])

carryover = predictedIrrigation-actualRain
print("carryover rain is", carryover)
#take today's values


humidity = 0
temperature = 0
cnt = 0
mycursor.execute("SELECT * FROM SensorData WHERE Date =" + todayDate)
myresult = mycursor.fetchall()
for x in myresult:
    if x[2] !="3":
        temperature+= float(x[3])
        humidity+= float(x[4])
        cnt+=1
humidity = humidity/cnt
temperature = temperature/cnt
irrigation = (25 + (5 * (temperature / 70)) - 5 * humidity / 100) /7
irrigation = irrigation-rain
print(irrigation)

mycursor.execute("SELECT * FROM Rollover WHERE Date =" + yesterdayDate)
myresult = mycursor.fetchall()
for x in myresult:
    temp = float(x[1])
temp += temp+carryover
mycursor.execute("SELECT * FROM PredictedIrrigation WHERE Date = " + todayDate)
myresult = mycursor.fetchall()
for x in myresult:
    estimated = float(x[1])

print("today's predictive irrigation is", estimated)
print("today's sensor irrigation is", irrigation)

finalIrrigation = (estimated*2 + irrigation)/3
finalIrrigation += carryover

print(days)
if days[isMonday] == 1:
    sql = "INSERT INTO Final (mm) VALUES (%s)"
    val = (str(finalIrrigation),)
    #resets if final is changed
    finalIrrigation = 0

sql = "INSERT INTO Rollover (Date, mm) VALUES (%s, %s)"
val = (strToday, finalIrrigation )
mycursor.execute(sql, val)
mydb.commit()
print("What is submitted into Rollover is ", finalIrrigation)



