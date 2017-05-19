# Rose-Hulman-Bon-Appetit-Rating-System
CSSE333 Final Project for Rose-Hulman

## Usage:

### Building the Project
psql -U postgres -d BoneApp -a -f CreateSchema.sql

### Running the web-page in the development stages
The version of python that we are using is 2.7.12.  But any version of python 2 should work.

If you are on a windows machine, go to 0-InstallDependencies.sh copy and paste the line into terminal

To launch the page:
We are using webscraping to inport all the foods from bon appetit. In the middle of our project, bon appetite slightly changed the structure of their website so that the data we were expecting was misaligned. 

As such, we are using an older version of their website.
Example:
http://rose-hulman.cafebonappetit.com/cafe/2017-04-28/

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

