# Multi Ping

Ping some specified ip addresses at the same time .

I wrote this tool for a friend . He is a network engineer . He often opens a command windows and input ping the ip address one by one in seconds. This tool could simplify this process with a simple syntax.

![](readme.png)

## Usage

For example,

```
mping.exe 1.1.1.1-3
```

It could open three windows and ping 1.1.1.1 , 1.1.1.2 and 1.1.1.3 at the same time . 1-3 means a continuous interval.

```
mping.exe 1.1.{1,3,6,10}.254
```

It could open four windows and ping 1.1.1.254, 1.1.3.254, 1.1.6.254, 1.1.10.254 at the same time . The number in the `{}` is any network number you want to ping .

```
mping.exe 1.1.1.1 2.2.2.2
```

You can run this tool with multi ipv4 addresses .

```
mping.exe 1.1-3.{1,3,5,7}.1 2.2.2.2
```

Or you could combine above parameters any you want .

## Build
I have a  windows 8 x86_64 computer . I built the mping.exe on it .

If it cannot run on you computer , you can install ruby environment
 and install the `ocra` gem .

Enter this directory and run

```
ocra mping.rb
```

It will build a new mping.exe in the directory.
