require! {
  fs
  child_process
  gulp
  'gulp-livescript'
  'gulp-header'
  'gulp-uglify'
  'gulp-rename'
  'gulp-bump'
  'gulp-exec'
  'gulp-conventional-changelog'
  'gulp-jade'
  'gulp-concat'
  'gulp-livereload'
  'tiny-lr'
  connect
  'connect-livereload'
}

/*
 * dev subtasks
 */
gulp.task 'dev:html' ->
  return gulp.src 'gh-pages/index.jade'
    .pipe gulp-jade pretty: true
    .pipe gulp.dest 'static'
    .pipe gulp-livereload(livereload)

gulp.task 'dev:css' ->
  return gulp.src 'gh-pages/application.scss'
    .pipe gulp-exec('compass compile --force')
    .pipe gulp.dest 'static'
    .pipe gulp-livereload(livereload)

gulp.task 'dev:ls' ->
  return gulp.src 'gh-pages/application.ls'
    .pipe gulp-livescript!
    .pipe gulp.dest 'tmp'

gulp.task 'dev:js' <[ dev:ls ]> ->
  return gulp.src <[
    bower_components/angular/angular.min.js
    bower_components/angular-ui-bootstrap-bower/ui-bootstrap-tpls.min.js
    tmp/application.js
  ]>
    .pipe gulp-concat 'application.js'
    .pipe gulp.dest 'static'  
    .pipe gulp-livereload(livereload)
/*
 * public subtasks
 */
gulp.task 'public:html' ->
  return gulp.src 'gh-pages/index.jade'
    .pipe gulp-jade!
    .pipe gulp.dest 'static'

gulp.task 'public:css' ->
  return gulp.src 'gh-pages/application.scss'
    .pipe gulp-exec('compass compile --output-style compressed --force')
    .pipe gulp.dest 'static'

gulp.task 'public:ls' ->
  return gulp.src 'gh-pages/application.ls'
    .pipe gulp-livescript!
    .pipe gulp-uglify!
    .pipe gulp.dest 'tmp'

gulp.task 'public:js' <[ public:ls ]> ->
  return gulp.src <[
    bower_components/angular/angular.min.js
    bower_components/angular-ui-bootstrap-bower/ui-bootstrap-tpls.min.js
    tmp/application.js
  ]>
    .pipe gulp-concat 'application.js'
    .pipe gulp.dest 'static'  
/*
 * for npm scripts
 */
# const server = connect!
# server.use connect-livereload!
# server.use connect.static './public'

const livereload = tiny-lr!

gulp.task 'dev' <[ dev:html dev:js dev:css ]> !->
  # server.listen 8000
  livereload.listen 35729

  gulp.watch 'gh-pages/**/*.jade' <[ dev:html ]>
  gulp.watch 'gh-pages/*.ls' <[ dev:js ]>
  gulp.watch 'gh-pages/**/*.scss' <[ dev:css ]>

  child_process.exec 'make run'

gulp.task 'release' <[ public:html public:js public:css ]>, !(cb) ->
  (err, dirpath) <-! temp.mkdir 'nuclear-data'
  gulp.src 'package.json'
    .pipe gulp-exec "cp -r public/* #{ dirpath }"
    .pipe gulp-exec 'git checkout master'
    .pipe gulp-exec 'git clean -f -d'
    .pipe gulp-exec 'git rm -rf .'
    .pipe gulp-exec "cp -r #{ path.join dirpath, '*' } ."
    .pipe gulp-exec "rm -rf #{ dirpath }"
    .pipe gulp-exec 'git add -A'
    .pipe gulp-exec "git commit -m 'chore(release): by gulpfile'"
    .pipe gulp-exec "git push origin master"
