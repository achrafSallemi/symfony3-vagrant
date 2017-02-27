/*jslint node: true */
"use strict";

const jshint = require('gulp-jshint');
var gulp = require('gulp');

gulp.task('lint', function() {
    return gulp.src('web/js/*.js')
        .pipe(jshint())
        .pipe(jshint.reporter('default'))
        ;
});

gulp.task('default', ['lint']);