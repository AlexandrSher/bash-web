# start

"Good day, everyone! Today, we are going to create simple web server using Bash and some utilities and commands.

Let's start by opening our terminal and typing in the command 'nc -lp 8080'. This command will start the server and listen on port 8080 for any incoming connections. Next, we can try sending a simple 'Hello' message to the server by typing 'echo Hello | nc -lp 8080'.

However, we can see that the response we get is not a proper HTTP response. So, we need to update our command to include the required headers. We can do this by typing 'echo "HTTP/1.1 200 OK\r\nContent-Length: 1\r\n\r\nHello" | nc -lp 8080'.

```
response='Hello'; length=$(echo $response | wc -c); echo "HTTP/1.1 200 OK\r\nContent-Length: $length\r\n\r\n$response" | nc -lp 8080
```
But typing this command every time we want to send a response is not efficient. So, we can create a script that automates this process for us.

```
while :;do response='Hello'; length=$(echo $response | wc -c); echo "HTTP/1.1 200 OK\r\nContent-Length: $length\r\n\r\n$response" | nc -lp 8080; done
```

# 1.sh

But typing this command every time we want to send a response is not efficient. So, we can create a script that automates this process for us. Here's an example script that handles incoming requests and sends appropriate responses:

Next one script uses a variable to store the port number, and it also includes a function to gracefully stop the server when a SIGINT signal is received.

It also includes a 'stop_server' function that is triggered by trap when a SIGINT signal is received, allowing us to gracefully stop the server.

In the 'while' loop, the script sends a response with a 'Hello' message to any incoming request it receives. It calculates the length of the response and sets the HTTP response code to 'HTTP/1.1 200 OK'. It then uses the 'echo' command with the '-e' option to interpret backslash escapes, which allows us to include the newline characters in the response.

This script is simple but effective for creating a basic web server. However, it lacks the ability to handle different URLs and send appropriate responses. For that, we can modify the script we created earlier to include more functionality.

# 2.sh

Lets move on with another script that improves on the previous scripts by allowing us to handle different URLs and send appropriate responses.

This script uses the 'handle_request' function to parse incoming requests and send appropriate responses. The function uses a 'while' loop to read each line of the incoming request and looks for the HTTP method and URL. It then sets the 'REQUEST' variable to the URL requested.

Next, the function sets the HTTP response code to 'HTTP/1.1 200 OK' and calculates the length of the response. It then sets the 'RESPONSE' variable to include the URL requested and sets the content type to 'text/plain'. Finally, it writes the response to a named pipe called 'response' that we create by mkfifo.

The 'while' loop listens for incoming requests on the specified port, reads from the 'response' named pipe, and calls the 'handle_request' function to send the appropriate response.

This script is much more versatile than the previous ones, as it allows us to handle different URLs and send appropriate responses. However, it still lacks the ability to handle more complex requests.

# 3.sh

"Finally, here's the last script that we'll be looking at in this demo. This script takes the previous script and adds the ability to execute shell commands based on the requested URL. For example, if the URL requested is '/date', the server will execute the 'date' command and return the output.

This script adds a conditional statement that checks if the requested URL is a valid command. If it is, the script executes the command using backticks and sets the 'output' variable to the command's output. It also sets the HTTP response code to 'HTTP/1.1 200 OK'. If the requested URL is not a valid command, the script sets the HTTP response code to 'HTTP/1.1 404 Not Found' and returns an error message.

Finally, the script calculates the length of the response and writes the response to the 'response' named pipe.

With this final script, we have a functional web server that can handle different URLs and execute shell commands.

# web.sh

Lets check complecated command like 'ls -la'.
Also best practice is add logging function.
Finnaly we have script with comments and good format.
Thank you for watching, and I hope you found this demo helpful!"