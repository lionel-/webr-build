function loadWebR(options){
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

    window.Module = {
        preRun: [function() { ENV = options.ENV }],
        postRun: [],
        arguments: options.Rargs,
        noExitRuntime: true,
        locateFile: function(path, prefix) {
            return(options.WEBR_URL + path);
        },
        print: function(text){
            options.stdout(text);
        },
        printErr: function(text) {
            if (arguments.length > 1) {
                text = Array.prototype.slice.call(arguments).join(' ');
            }
            options.stderr(text);
        },
        canvas: (function() {})(),
        setStatus: function(text) {
            if (!window.Module.setStatus.last) {
                window.Module.setStatus.last = { time: Date.now(), text: '' };
            }
            if (text === window.Module.setStatus.last.text) {
                return;
            }
        }
    };

    window.Module.setStatus('Downloading...');
    var script = document.createElement('script');
    script.setAttribute('src', options.WEBR_URL + 'R.bin.js');
    document.head.appendChild(script);

    return {
        runRAsync: async function(code){
            return(window.Module._run_R_from_JS(allocate(intArrayFromString(code), 0), code.length));
        }
    }
}
