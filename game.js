
var Module;

if (typeof Module === 'undefined') Module = eval('(function() { try { return Module || {} } catch(e) { return {} } })()');

if (!Module.expectedDataFileDownloads) {
  Module.expectedDataFileDownloads = 0;
  Module.finishedDataFileDownloads = 0;
}
Module.expectedDataFileDownloads++;
(function() {
 var loadPackage = function(metadata) {

    var PACKAGE_PATH;
    if (typeof window === 'object') {
      PACKAGE_PATH = window['encodeURIComponent'](window.location.pathname.toString().substring(0, window.location.pathname.toString().lastIndexOf('/')) + '/');
    } else if (typeof location !== 'undefined') {
      // worker
      PACKAGE_PATH = encodeURIComponent(location.pathname.toString().substring(0, location.pathname.toString().lastIndexOf('/')) + '/');
    } else {
      throw 'using preloaded data can only be done on a web page or in a web worker';
    }
    var PACKAGE_NAME = 'game.data';
    var REMOTE_PACKAGE_BASE = 'game.data';
    if (typeof Module['locateFilePackage'] === 'function' && !Module['locateFile']) {
      Module['locateFile'] = Module['locateFilePackage'];
      Module.printErr('warning: you defined Module.locateFilePackage, that has been renamed to Module.locateFile (using your locateFilePackage for now)');
    }
    var REMOTE_PACKAGE_NAME = typeof Module['locateFile'] === 'function' ?
                              Module['locateFile'](REMOTE_PACKAGE_BASE) :
                              ((Module['filePackagePrefixURL'] || '') + REMOTE_PACKAGE_BASE);
  
    var REMOTE_PACKAGE_SIZE = metadata.remote_package_size;
    var PACKAGE_UUID = metadata.package_uuid;
  
    function fetchRemotePackage(packageName, packageSize, callback, errback) {
      var xhr = new XMLHttpRequest();
      xhr.open('GET', packageName, true);
      xhr.responseType = 'arraybuffer';
      xhr.onprogress = function(event) {
        var url = packageName;
        var size = packageSize;
        if (event.total) size = event.total;
        if (event.loaded) {
          if (!xhr.addedTotal) {
            xhr.addedTotal = true;
            if (!Module.dataFileDownloads) Module.dataFileDownloads = {};
            Module.dataFileDownloads[url] = {
              loaded: event.loaded,
              total: size
            };
          } else {
            Module.dataFileDownloads[url].loaded = event.loaded;
          }
          var total = 0;
          var loaded = 0;
          var num = 0;
          for (var download in Module.dataFileDownloads) {
          var data = Module.dataFileDownloads[download];
            total += data.total;
            loaded += data.loaded;
            num++;
          }
          total = Math.ceil(total * Module.expectedDataFileDownloads/num);
          if (Module['setStatus']) Module['setStatus']('Downloading data... (' + loaded + '/' + total + ')');
        } else if (!Module.dataFileDownloads) {
          if (Module['setStatus']) Module['setStatus']('Downloading data...');
        }
      };
      xhr.onload = function(event) {
        var packageData = xhr.response;
        callback(packageData);
      };
      xhr.send(null);
    };

    function handleError(error) {
      console.error('package error:', error);
    };
  
      var fetched = null, fetchedCallback = null;
      fetchRemotePackage(REMOTE_PACKAGE_NAME, REMOTE_PACKAGE_SIZE, function(data) {
        if (fetchedCallback) {
          fetchedCallback(data);
          fetchedCallback = null;
        } else {
          fetched = data;
        }
      }, handleError);
    
  function runWithFS() {

    function assert(check, msg) {
      if (!check) throw msg + new Error().stack;
    }
Module['FS_createPath']('/', 'assets', true, true);
Module['FS_createPath']('/', 'examples', true, true);

    function DataRequest(start, end, crunched, audio) {
      this.start = start;
      this.end = end;
      this.crunched = crunched;
      this.audio = audio;
    }
    DataRequest.prototype = {
      requests: {},
      open: function(mode, name) {
        this.name = name;
        this.requests[name] = this;
        Module['addRunDependency']('fp ' + this.name);
      },
      send: function() {},
      onload: function() {
        var byteArray = this.byteArray.subarray(this.start, this.end);

          this.finish(byteArray);

      },
      finish: function(byteArray) {
        var that = this;

        Module['FS_createDataFile'](this.name, null, byteArray, true, true, true); // canOwn this data in the filesystem, it is a slide into the heap that will never change
        Module['removeRunDependency']('fp ' + that.name);

        this.requests[this.name] = null;
      },
    };

        var files = metadata.files;
        for (i = 0; i < files.length; ++i) {
          new DataRequest(files[i].start, files[i].end, files[i].crunched, files[i].audio).open('GET', files[i].filename);
        }

  
    function processPackageData(arrayBuffer) {
      Module.finishedDataFileDownloads++;
      assert(arrayBuffer, 'Loading data file failed.');
      assert(arrayBuffer instanceof ArrayBuffer, 'bad input to processPackageData');
      var byteArray = new Uint8Array(arrayBuffer);
      var curr;
      
        // copy the entire loaded file into a spot in the heap. Files will refer to slices in that. They cannot be freed though
        // (we may be allocating before malloc is ready, during startup).
        if (Module['SPLIT_MEMORY']) Module.printErr('warning: you should run the file packager with --no-heap-copy when SPLIT_MEMORY is used, otherwise copying into the heap may fail due to the splitting');
        var ptr = Module['getMemory'](byteArray.length);
        Module['HEAPU8'].set(byteArray, ptr);
        DataRequest.prototype.byteArray = Module['HEAPU8'].subarray(ptr, ptr+byteArray.length);
  
          var files = metadata.files;
          for (i = 0; i < files.length; ++i) {
            DataRequest.prototype.requests[files[i].filename].onload();
          }
              Module['removeRunDependency']('datafile_game.data');

    };
    Module['addRunDependency']('datafile_game.data');
  
    if (!Module.preloadResults) Module.preloadResults = {};
  
      Module.preloadResults[PACKAGE_NAME] = {fromCache: false};
      if (fetched) {
        processPackageData(fetched);
        fetched = null;
      } else {
        fetchedCallback = processPackageData;
      }
    
  }
  if (Module['calledRun']) {
    runWithFS();
  } else {
    if (!Module['preRun']) Module['preRun'] = [];
    Module["preRun"].push(runWithFS); // FS is not initialized yet, wait for it
  }

 }
 loadPackage({"files": [{"audio": 0, "start": 0, "crunched": 0, "end": 3797, "filename": "/animation.lua"}, {"audio": 0, "start": 3797, "crunched": 0, "end": 3928, "filename": "/conf.lua"}, {"audio": 0, "start": 3928, "crunched": 0, "end": 19676, "filename": "/lexer.lua"}, {"audio": 0, "start": 19676, "crunched": 0, "end": 24890, "filename": "/list.lua"}, {"audio": 0, "start": 24890, "crunched": 0, "end": 29429, "filename": "/main.lua"}, {"audio": 0, "start": 29429, "crunched": 0, "end": 32147, "filename": "/movements.lua"}, {"audio": 0, "start": 32147, "crunched": 0, "end": 32658, "filename": "/README.md"}, {"audio": 0, "start": 32658, "crunched": 0, "end": 33954, "filename": "/viewcode.lua"}, {"audio": 0, "start": 33954, "crunched": 0, "end": 34856, "filename": "/assets/anim-boogie.png"}, {"audio": 0, "start": 34856, "crunched": 0, "end": 50516, "filename": "/assets/Grundschrift-Normal.otf"}, {"audio": 1, "start": 50516, "crunched": 0, "end": 610575, "filename": "/assets/HA-1112-M1LBuchon_flyby.ogg"}, {"audio": 0, "start": 610575, "crunched": 0, "end": 614734, "filename": "/assets/love-ball.png"}, {"audio": 0, "start": 614734, "crunched": 0, "end": 623929, "filename": "/assets/love-big-ball.png"}, {"audio": 0, "start": 623929, "crunched": 0, "end": 625211, "filename": "/assets/love-cursor.png"}, {"audio": 0, "start": 625211, "crunched": 0, "end": 699894, "filename": "/assets/love_osx_inner.svg"}, {"audio": 0, "start": 699894, "crunched": 0, "end": 714478, "filename": "/assets/Minimal5x7.ttf"}, {"audio": 0, "start": 714478, "crunched": 0, "end": 714785, "filename": "/examples/001_loading_image.lua"}, {"audio": 0, "start": 714785, "crunched": 0, "end": 715242, "filename": "/examples/002_mouse_getpos.lua"}, {"audio": 0, "start": 715242, "crunched": 0, "end": 715648, "filename": "/examples/004_mouse_setpos.lua"}, {"audio": 0, "start": 715648, "crunched": 0, "end": 716205, "filename": "/examples/005_mouse_button.lua"}, {"audio": 0, "start": 716205, "crunched": 0, "end": 716669, "filename": "/examples/006_cursor_visibility.lua"}, {"audio": 0, "start": 716669, "crunched": 0, "end": 716896, "filename": "/examples/007_sleeping.lua"}, {"audio": 0, "start": 716896, "crunched": 0, "end": 717283, "filename": "/examples/008_fps_delta.lua"}, {"audio": 0, "start": 717283, "crunched": 0, "end": 717728, "filename": "/examples/009_timing.lua"}, {"audio": 0, "start": 717728, "crunched": 0, "end": 718113, "filename": "/examples/010_key_down.lua"}, {"audio": 0, "start": 718113, "crunched": 0, "end": 719254, "filename": "/examples/011_animation.lua"}, {"audio": 0, "start": 719254, "crunched": 0, "end": 719477, "filename": "/examples/012_cursor_change.lua"}, {"audio": 0, "start": 719477, "crunched": 0, "end": 719828, "filename": "/examples/013_cursor_image.lua"}, {"audio": 0, "start": 719828, "crunched": 0, "end": 720334, "filename": "/examples/014_keyboard_move.lua"}, {"audio": 0, "start": 720334, "crunched": 0, "end": 720661, "filename": "/examples/015_image_rotation.lua"}, {"audio": 0, "start": 720661, "crunched": 0, "end": 721092, "filename": "/examples/016_image_rot_scale.lua"}, {"audio": 0, "start": 721092, "crunched": 0, "end": 722312, "filename": "/examples/017_font_truetype.lua"}, {"audio": 0, "start": 722312, "crunched": 0, "end": 724332, "filename": "/examples/018_physics_fire_at.lua"}, {"audio": 0, "start": 724332, "crunched": 0, "end": 725437, "filename": "/examples/019_physics_move_objs_.lua"}, {"audio": 0, "start": 725437, "crunched": 0, "end": 725848, "filename": "/examples/051_callbacks_basic.lua"}, {"audio": 0, "start": 725848, "crunched": 0, "end": 727544, "filename": "/examples/052_callbacks_mouse.lua"}, {"audio": 0, "start": 727544, "crunched": 0, "end": 728252, "filename": "/examples/053_callbacks_keyboard.lua"}, {"audio": 0, "start": 728252, "crunched": 0, "end": 729946, "filename": "/examples/100_physics_mini.lua"}, {"audio": 0, "start": 729946, "crunched": 0, "end": 732269, "filename": "/examples/101_physics_mini_callbacks.lua"}, {"audio": 0, "start": 732269, "crunched": 0, "end": 737513, "filename": "/examples/102_physics_adv.lua"}, {"audio": 0, "start": 737513, "crunched": 0, "end": 738327, "filename": "/examples/103_filesystem_lines.lua"}, {"audio": 0, "start": 738327, "crunched": 0, "end": 738971, "filename": "/examples/104_display_modes.lua"}, {"audio": 0, "start": 738971, "crunched": 0, "end": 739899, "filename": "/examples/video_test.lua"}, {"audio": 0, "start": 739899, "crunched": 0, "end": 740314, "filename": "/examples/zzz_filler.lua"}], "remote_package_size": 740314, "package_uuid": "9247530f-3c4d-4438-91bb-2627e857db62"});

})();
