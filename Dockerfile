FROM droboports/compiler
MAINTAINER ryanstout@gmail.com

USER root


## -- Build Golang 1.5 beta --
# # Install Go 1.4 for bootstrap
RUN mkdir /goroot1.4 && curl https://storage.googleapis.com/golang/go1.4.linux-amd64.tar.gz | tar xvzf - -C /goroot1.4 --strip-components=1
# RUN mkdir /gopath

# Build 1.4
ENV GOROOT /goroot1.4
ENV GOPATH /gopath
ENV PATH $GOROOT/bin/:$GOPATH/bin/:$PATH

RUN cd /goroot1.4/src ; ./all.bash
ENV GOROOT_BOOTSTRAP /goroot1.4

# Install from git
RUN git clone https://github.com/golang/go.git /goroot
# RUN cd /goroot ; git checkout cc8f544
## -- / Build Golang 1.5 beta --



## -- Build Golang 1.4 --
# RUN mkdir /goroot && curl https://storage.googleapis.com/golang/go1.4.linux-amd64.tar.gz | tar xvzf - -C /goroot --strip-components=1
## -- /Build Golang 1.4 --


ENV GOROOT /goroot
ENV GOPATH /gopath
ENV PATH $GOROOT/bin/:$GOPATH/bin/:$PATH

RUN apt-get install ruby vim -y

# RUN ruby -e "txt = File.open('/goroot/src/runtime/mem_linux.c', 'r:UTF-8', &:read).split(\"\n\") ;  txt.insert(157, \"        runtime\u{B7}printf(\\\"VAL: %d, %d\\\", p, v);\") ; File.open('/goroot/src/runtime/mem_linux.c', 'w:UTF-8') {|f| f.write(txt.join(\"\n\")) }"
# RUN ruby -e "txt = File.open('/goroot/src/runtime/mem_linux.c', 'r:UTF-8', &:read).split(\"\n\") ; txt[156] =  \"    p = runtime\u{B7}mmap(v, n, PROT_READ|PROT_WRITE, MAP_ANON|MAP_PRIVATE, -1, 0);\" ; File.open('/goroot/src/runtime/mem_linux.c', 'w:UTF-8') {|f| f.write(txt.join(\"\n\")) }"
# RUN ruby -e "IO.binwrite('/goroot/src/runtime/arch1_arm.go', File.binread('/goroot/src/runtime/arch1_arm.go').gsub('65536*goos_nacl + 4096*(1-goos_nacl)', '16384'))"

RUN ruby -e "IO.binwrite('/goroot/src/syscall/syscall_linux_arm.go', File.binread('/goroot/src/syscall/syscall_linux_arm.go').gsub('func Getpagesize() int { return 4096 }', 'func Getpagesize() int { return 16384 }'))"
RUN ruby -e "IO.binwrite('/goroot/src/syscall/syscall_linux_arm.go', File.binread('/goroot/src/syscall/syscall_linux_arm.go').gsub('page := uintptr(offset / 4096)', 'page := uintptr(offset / 16384)'))"
RUN ruby -e "IO.binwrite('/goroot/src/syscall/syscall_linux_arm.go', File.binread('/goroot/src/syscall/syscall_linux_arm.go').gsub('if offset != int64(page)*4096 {', 'if offset != int64(page)*16384 {'))"
RUN ruby -e "IO.binwrite('/goroot/src/runtime/arch1_arm.go', File.binread('/goroot/src/runtime/arch1_arm.go').gsub('_PhysPageSize  = 65536*goos_nacl + 4096*(1-goos_nacl)', '_PhysPageSize = 16384'))"

ENV DOCKER_CROSSPLATFORMS linux/386 linux/amd64 linux/arm windows/386 windows/amd64
RUN cd /goroot/src && bash -xc 'for platform in $DOCKER_CROSSPLATFORMS; do GOOS=${platform%/*} GOARCH=${platform##*/} GOARM=7 ./make.bash --no-clean 2>&1; done'

# # Build Go cross compiler libraries
RUN export GOPATH=/golang ; go get github.com/syndtr/goleveldb/leveldb

# # RUN cd /goroot/src ; ./all.bash
