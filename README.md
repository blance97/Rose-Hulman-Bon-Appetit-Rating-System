# Rose-Hulman-Bon-Appetit-Rating-System
CSSE333 Final Project for Rose-Hulman

## Usage:

### Building the Project
psql -U postgres -d BoneApp -a -f CreateSchema.sql

### Running the web-page in the development stages
To launch the page:
<pre><code>
python main.py dev.conf http://rose-hulman.cafebonappetit.com/
</code><


The dev.conf file is set up in your system as:
<pre><code>
[Development]
	databaseName = [databaseName] 
	user = [username]
	password = [password]
	host = 127.0.0.1 
	port = 5432
</code></pre>

