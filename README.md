# buildroot_unitv2

## Flashing

### Flashing GCIS, IPL.bin, u-boot spl and ubi

```
sudo ./SNANDer -p mstarddc -c /dev/i2c-4:49 -e
sudo ./SNANDer -p mstarddc -c /dev/i2c-4:49 -w GCIS.bin -v
sudo ./SNANDer -p mstarddc -c /dev/i2c-4:49 -a 0x140000 -w IPL.bin -v
sudo ./SNANDer -p mstarddc -c /dev/i2c-4:49 -a 0x200000 -w outputs/unitv2-ipl -v
sudo ./SNANDer -p mstarddc -c /dev/i2c-4:49 -a 0xEC0000 -w outputs/unitv2-ubi.img -v
```


### Loading from the rescue image

On the host:

```
ip link set dev enx00e099313e0b up
ip a add 20.20.20.1/24 dev enx00e099313e0b
```
