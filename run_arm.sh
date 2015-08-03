# Build the arm file
 # -ldflags \"-R 65536\"
 # -ldflags \"-R 16384\"

docker run -it --rm -v `pwd`:/gopath/infinitydrive -w /gopath/infinitydrive -e GOARCH=arm -e GOARM=7 ryanstout/example1 /bin/bash -c "export GOPATH=/golang ; cd src ; go build -ldflags \"-R 16384\" -v -o ../bin/infinitydrive-arm"

# Copy it into place
ssh root@10.0.1.22 -C "rm -rf /mnt/DroboFS/Shares/Public/infinitydrive-arm"
ssh root@10.0.1.22 -C "rm -rf /mnt/DroboFS/Shares/Public/db"
ssh root@10.0.1.22 -C "rm -rf /mnt/DroboFS/Shares/Public/drive ; mkdir /mnt/DroboFS/Shares/Public/drive"
rm -f /Volumes/Public/infinitydrive-arm
cp bin/infinitydrive-arm /Volumes/Public/

echo "Running Drive..."
ssh root@10.0.1.22 -C "cd /mnt/DroboFS/Shares/Public ; ./infinitydrive-arm"