var gulp = require('gulp');
var pug = require('gulp-pug');
var concat = require('gulp-concat');
var sass = require('gulp-sass');
var minifyCSS = require('gulp-csso');
var sourcemaps = require('gulp-sourcemaps');

// gulp.task('html', function(){
//   return gulp.src('app/views/*.html.erb')
//     .pipe(pug())
//     .pipe(gulp.dest('build/html'))
// });

gulp.task('css', function(){
  return gulp.src('app/assets/*.scss')
    .pipe(sass())
    .pipe(minifyCSS())
    .pipe(gulp.dest('build/css'))
});

gulp.task('js', function(){
  return gulp.src('app/assets/javascript/*.js')
    .pipe(sourcemaps.init())
    .pipe(concat('app.min.js'))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('build/js'))
});

gulp.task('default', ['css', 'js' ]);