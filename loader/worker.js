var re = /^___terminal::/;

var reqProps = {
    readyState: 4,
    status: 200
};
var reqCounter = 0;
const reqTargets = new Map();

// XHR proxy that handle methods from fetch in C
XMLHttpRequest = (function(xhr) {
  return function() {
    var url;
    var enc = new TextEncoder('utf-8');
    return new Proxy(new xhr(), {
        get: function(target, name) {
            if (url && ['response', 'responseText', 'status', 'readyState'].indexOf(name) != -1) {
                if (name == 'response') {
                    var response = enc.encode(reqProps.responseText);
                    return response;
                }
                return reqProps[name];
            } else if (name == 'open') {
                return function(method, open_url) {
                    if (open_url.match(re)) {
                        url = open_url;
                    } else {
                        return target[name].apply(target, arguments);
                    }
                };
            } else if (name == 'send') {
                return function(data) {
                    var id = ++reqCounter;
                    if (url) {
                        var payload = url.split('::');
                        if (payload[1] == 'read') {
                            reqTargets.set(id, target);
                            var text = payload.length > 2 ? payload[2] : '';
                            var data = { text: text, id: id };
                            postMessage({ event: 'read', data: data });
                        }
                    } else {
                        return target[name].apply(target, arguments);
                    }
                };
            }
            return target[name];
        },
        set: function(target, name, value) {
            target[name] = value;
        }
    });
  };
})(self.XMLHttpRequest);

function loadWebR(options) {
    if (options.packages === undefined) options.packages = [];
    if (options.Rargs === undefined) options.Rargs = ['-q'];
    if (options.WEBR_URL === undefined) options.WEBR_URL = "@@BASE_URL@@";
    if (options.PKG_URL === undefined) options.PKG_URL = "https://cdn.jsdelivr.net/gh/georgestagg/webr-ports/dist/";
    if (options.ENV === undefined) options.ENV = {
        "R_NSIZE"      : "1000000",
        "R_VSIZE"      : "64M",
        "R_HOME"       : "/usr/lib/R",
        "R_ENABLE_JIT" : "0",
    }

    self.Module = {
        preRun: [function() { ENV = options.ENV }],
        postRun: [],
        arguments: options.Rargs,
        noExitRuntime: true,
        locateFile: function(path, prefix) {
            return(options.WEBR_URL + path);
        },
        print: function(text){
            postMessage({ event: 'stdout', data: text })
        },
        printErr: function(text) {
            if (arguments.length > 1) {
                text = Array.prototype.slice.call(arguments).join(' ');
            }
            postMessage({ event: 'stderr', data: text })
        },
        canvas: (function() {})(),
        setStatus: function(text) {
            if (!self.Module.setStatus.last) {
                self.Module.setStatus.last = { time: Date.now(), text: '' };
            }
            if (text === self.Module.setStatus.last.text) {
                return;
            }
        }
    };

    self.Module.setStatus('Downloading...');
    importScripts(options.WEBR_URL + 'R.bin.js');
}

runRAsync = async function(code) {
    var arr = allocate(intArrayFromString(code), 0);
    return(self.Module._run_R_from_JS(arr, code.length));
}

onmessage = function(msg) {
    var event = msg.data.event;
    var data = msg.data.data;

    switch (event) {
    case 'init':
        loadWebR(data);
        break;

    case 'run':
        Module._run_R_from_JS(allocate(intArrayFromString(data), 0),
                              data.length);
        break;

    case 'input':
        var text = data.text;
        var data = data.data;
        reqProps.responseText = text;
        reqTargets.get(data.id).onload();
        reqTargets.delete(data.id);
        break;

    default:
        console.log('Undefined event in Web Worker');
        break;
    }
}
