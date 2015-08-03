rm bin/infinitydrive

# -race
cd src ; go build -o ../bin/infinitydrive ; cd ..
echo "compiled, running..."

echo "clear db"
rm -rf db/*

 # -fuse.debug
GOMAXPROCS=4 ./bin/infinitydrive
