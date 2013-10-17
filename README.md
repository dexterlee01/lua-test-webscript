lua-aws
=======

### lua AWS REST API binding



## Concept
it heavily inspired by [aws-sdk-js](https://raw.github.com/aws/aws-sdk-js/),
which main good point is define all AWS sevices by JS data structure. and library read these data and 
building API code on the fly. so AWS JS SDK is:
- less code to maintain
- in almost case, only need to update service definition (from aws-sdk-js :D) to follow the new version or change of the service API.

also aws-sdk-js seems to be well designed, 
so I decide to copy its architecture, without copying callback storm of aws-sdk-js (only vexing point of it)



## Current Status

now it just Proof of Concept.
only some API of EC2 tested. almost EC2 API is not tested and even entry does not exist most of AWS services.
but I think almost code service-indepenent and well modularized, so it not so hard support other services
if signers and requests are fully implemented.

I currently developing network game which application code is entirely written in lua, and this binding will be used for it,
after that, more services will be support and library itself will be more stable. but now, I don't have enough time to complete this project.



## External libs
- [dkjson](http://dkolf.de/src/dkjson-lua.fsl/home) to decode/encode JSON
- [SLAXML](https://github.com/Phrogz/SLAXML) currently not used, but will be used for encoding
- [sha2](http://lua-users.org/wiki/SecureHashAlgorithm) to generate SHA-256 hash
- [hmac](https://github.com/bjc/prosody/blob/master/util/hmac.lua) to implement Hmac_SHA256 routine
- [base64](http://lua-users.org/wiki/BaseSixtyFour) for base64 encoder

and more code snippets help me to build authentication routines. thanks!


## Installing

now there is no rockspec so please copy them directory like /usr/local/share/lua/5.1/ manually.




## Usage

see test/ec2.lua

```lua
local AWS = require ('aws')
AWS = AWS.new({
	accessKeyId = os.getenv('AWS_ACCESS_KEY'),
	secretAccessKey = os.getenv('AWS_SECRET_KEY')
	-- if you write your own http engin
	http_engine = your_http_engine
})

local res,err = AWS.EC2:api():describeInstances()
```

where http_engine is callable object of lua which input and output is like following:
```lua
-- input
local req = {
	path = endpoint:path(),
	headers = {"header-name" = "header-value", ...},
	params = {}, -- internal use
	body = "body data",
	host = endpoint:host(),
	port = endpoint:port(),
	protocol = endpoint:protocol(),
	method = string
}

-- output
local resp = {
	status = number,
	headers = {"header-name" = "header-value", ...},
	body = string,
}

-- calling http_engine
resp = http_engine(req)
```

or you just install luasocket, lua-aws detect it autometically and use socket.http to access AWS.



you can get multiple version
```lua
local res,err = AWS.EC2:api_by_version('2013-02-01'):describeInstances()
```



## License

if it will be more solid, This SDK will be distributed under the
[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0).

```no-highlight
Copyright 2013. Takehiro Iyatomi (iyatomi@gmail.com). All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
