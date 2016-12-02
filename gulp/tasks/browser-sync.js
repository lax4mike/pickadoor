/**
 * This is a special task, do not include this in your build.tasks configuration.
 * This is handled in quench.js by passing browserSync: true
 * in the build config to quench.build().
 */
var gulp           = require("gulp"),
    quench         = require("../quench.js"),
    path           = require("path"),
    browserSync    = require("browser-sync").create();


module.exports = function(config, env){

    // if not using proxy, use this as the server root
    var serverRoot = path.resolve(config.root, "..");

    // browserSync settings
    var settings = {
        port: config.local.browserSyncPort || 3000,
        open: false, // or  "external"
        notify: false,
        ghostMode: false,
        server: path.resolve(config.dest),
        files: [
           config.dest + "/**",
           // prevent browser sync from reloading twice when the regular file (eg. index.js)
           // and the map file (eg. index.js.map) are generated
           "!**/*.map"
       ]
    };


    /* start browser sync if we have the "watch" option */
    gulp.task("browser-sync", function(){

        if (config.watch === true){
            quench.logYellow("watching", "browser-sync:", JSON.stringify(settings.files, null, 2));
            browserSync.init(settings);
        }

    });
};
