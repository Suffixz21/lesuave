var gulp = require('gulp');
var pug = require('gulp-pug');
var concat = require('gulp-concat');
var sass = require('gulp-sass');
var minifyCSS = require('gulp-csso');
var sourcemaps = require('gulp-sourcemaps');
var browserSync = require('browser-sync').create();

// gulp.task('html', function(){
//   return gulp.src('app/views/*.html.erb')
//     .pipe(pug())
//     .pipe(gulp.dest('build/html'))
// });

gulp.task('browser-sync', function() {
  browserSync.init({
      proxy: "localhost:3000"
  });
});

// Static Server + watching scss/html files
gulp.task('serve', ['sass', 'javascript'], function() {

  browserSync.init({
      server: "./app"
  });

  gulp.watch("app/scss/*.scss", ['sass']);
  gulp.watch("app/*.html").on('change', browserSync.reload);
});


gulp.task('sass', function(){
  return gulp.src('app/assets/*.scss')
    .pipe(sass())
    .pipe(minifyCSS())
    .pipe(gulp.dest('build/css'))
    .pipe(browserSync.stream());
});

gulp.task('javascript', function(){
  return gulp.src('app/assets/javascript/*.js')
    .pipe(sourcemaps.init())
    .pipe(concat('app.min.js'))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('build/js'))
    .pipe(browserSync.stream());
});

gulp.task('default', ['serve']);