# start_stop_server
HTTP server to start/stop/cleanup browsers

## Requirement

Write a script which accepts HTTP calls to Start, stop and cleanup browsers. Each of the operations should be different methods. Proxy setttings should be configurable. It should also take url as optional parameter. It should be done in ruby.


## API Description

```bash
POST /browsers
```
Launches a browser instance with given browser type & optional proxy/url configs.

data required:
```bash
1) browser_type
```
type of browser to be launched. firefox/chrome
```bash
2) url (optional )
```
URL to point-to post launch
```bash
3) proxy_server & proxy_port ( optional)
```
Proxy server settings.

```bash
DELETE /browsers
```

Stops gracefully the launched browser instance


```bash
PUT /browsers
```
data required:

```bash
operation: cleanup
```

Cleans up the cookies from the last session.

## Running the server

```bash
rackup -p <port>
```
## Plugging into launchd

```bash
cp ./startstopserver.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/startstopserver.list
```
