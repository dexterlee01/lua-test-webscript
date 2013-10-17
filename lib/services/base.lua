local class = require ('class')
local API = require ('api')
local util = require ('util')

return class.AWS_Service {
	initialize = function (self, aws, service_name)
		self._service_name = service_name or self.class.name:gsub('^AWS_', '')
		self._aws = aws
		self._apis = self:build_apis()
	end,
	aws = function (self)
		return self._aws
	end,
	build_apis = function (self)
		local latest
		local apis = {}
		local service_name = self._service_name:lower()
		util.dir(('services/definitions/%s*'):format(service_name)):each(function (path)
			--print('defintion file:', path)
			local version
			path:gsub('[^%-]*%-([%w%-]*)%.js', function (s) 
				version = s 
				return s 
			end)
			assert(version, path .. ':invalid file name')
			local data = util.json.decode(util.get_json_part(path))
			apis[version] = API.new(self, data)
			if (not latest) or (latest <= version) then
				apis.latest = apis[version]
			end
		end)
		assert(apis.latest, service_name .. ':no api defined.')
		return apis
	end,
	api_latest = function (self)
		return self._apis.latest
	end,
	api_by_version = function (self, ver)
		return self._apis[ver]
	end,
	api = function (self)
		return self:api_latest()
	end,
}
