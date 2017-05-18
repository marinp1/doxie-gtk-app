rm -rf build/*
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ../
make
./com.github.marinp1.gtk-doxie-app