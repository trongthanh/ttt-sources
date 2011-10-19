PATH=/home/thanh/flex_sdk/bin:$PATH
SRC=../src
OUT=../bin

mxmlc $SRC/Demo.as -load-config+=build_config.xml -o $OUT/main.swf

echo "Completed. Press ENTER to continue..."
read cont
