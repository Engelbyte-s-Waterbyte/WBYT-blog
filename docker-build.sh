cd ./backend
rm backend
env GOOS=linux GOARCH=arm64 go build
cd ..

cd ./website
flutter build web
cd ..

docker build . -t waterbyte-website