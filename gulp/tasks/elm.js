var gulp        = require("gulp"),
    quench      = require("../quench.js"),
    elm         = require("gulp-elm"),
    notify      = require("gulp-notify"),
    rename      = require("gulp-rename"),
    debug       = require("gulp-debug");

module.exports = function elmTask(config, env){

    // css settings
    var elmConfig = {
        src: [
            config.root + "/elm/Main.elm"
        ],
        dest: config.dest + "/js/",

        watch: config.root + "/**/*.elm",

        filename: "main.js",

        elm: {
            debug: !env.production() ? true : false,
            warn: false // notify will do this
        }
    };

    quench.registerWatcher("elm", elmConfig.watch);



    gulp.task("elm", function(){

        // don't use drano for elm, because it already prints the error
        // but we still want the notification
        var elmStream = elm.make(elmConfig.elm)
        .on("error", function(error){
            notify.onError({
                title: "<%= error.plugin %>",
                message: "Error in elm",
                sound: "Pop"
                // Bottle, Funk, Hero, Morse, Pop
                // Basso, Blow, Bottle, Frog, Funk, Glass, Hero, Morse, Ping, Pop, Purr, Sosumi, Submarine, Tink
            })(error);
        });

        return gulp.src(elmConfig.src)
            .pipe(elmStream) // << above drano
            .pipe(quench.drano())
            .pipe(rename(elmConfig.filename))
            .pipe(rename({
                suffix: "-generated"
            }))
            .pipe(gulp.dest(elmConfig.dest))
            .pipe(debug({title: "elm"}));
    });
};
