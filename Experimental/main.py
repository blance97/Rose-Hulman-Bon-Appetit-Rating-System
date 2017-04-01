import urllib2
import json
wiki = "http://rose-hulman.cafebonappetit.com/"

#Query the website and return the html to the variable 'page'
page = urllib2.urlopen(wiki)

#import the Beautiful soup functions to parse the data returned from the website
from bs4 import BeautifulSoup

#Parse the html in the 'page' variable, and store it in Beautiful Soup format
soup =  BeautifulSoup(page, "html.parser")

# soup.prettify()
f = open('myfile.json', 'w')
s = soup.find_all("script")
start = str(s[30]).find("Bamco.menu_items")
end = str(s[30]).find("Bamco.cor_icons")
foods = str(s[30])[start+19:end-6]
data = json.loads(foods)
f.write(foods)
f.close()  # you can omit in most cases as the destructor will call it
