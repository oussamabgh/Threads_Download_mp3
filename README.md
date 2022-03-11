# downloadmp3

 threads (Asynchronous Task) in this case dowloading a mp3 fron a http link and pay it on the application

## Getting Started

Suppose the user presses the button: the code
of the HTTP part will be executed, which will make a request
network for the required data.


This will directly give us a Future object. So the
processor and the main thread does not get stuck on
this task. We return to our interface (in case of
click) and from time to time we execute the http part.

 Once the future is available, it will be treated as a
interaction event (run then or catchError())
