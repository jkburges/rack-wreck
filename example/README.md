Run the example:

```
$ bundle exec ruby myapp.rb
[2018-03-19 16:41:48] INFO  WEBrick 1.3.1
[2018-03-19 16:41:48] INFO  ruby 2.3.1 (2016-04-26) [x86_64-darwin16]
== Sinatra (v2.0.1) has taken the stage on 4567 for development with backup from WEBrick
[2018-03-19 16:41:48] INFO  WEBrick::HTTPServer#start: pid=91417 port=4567
```

Make some requests:

```bash
$ while (true);
    curl -s -w "%{http_code} \n\n" http://localhost:4567/;
    do sleep 0.5;
  done;
```

```bash
$ while (true); do
    curl -s http://localhost:4567/wow >> results;
    curl -s http://localhost:4567/much >> results;
  done;
```