#### create vmlinuz
```txt
vmlinuz的建立有2种方式：

    一，编译内核时通过"make zImage"创建，然后通过下面代码产生： 
        cp /usr/src/linux-2.4/arch/i386/linux/boot/zImage /boot/vmlinuz
        zImage适用于小内核的情况，它的存在是为了向后的兼容性
        
    二，内核编译时通过命令make bzImage创建，然后通过下面代码产生： 
        cp /usr/src/linux-2.4/arch/i386/linux/boot/bzImage /boot/vmlinuz 
        bzImage是压缩的内核映像，注意bzImage不是bzip2压缩的，名字中的bz易误解，bz表示"big zImage"

Notice 1 
    zImage（vmlinuz）和bzImage（vmlinuz）都是用gzip压缩的。
    它们不仅是一个压缩文件，而且在这两个文件的开头部分内嵌有gzip解压缩代码。所以不能用gunzip 或 gzip –dc解包vmlinuz。
    
Notice 2 
    内核文件中包含一个微型的gzip用于解压缩内核并引导它。
    两者的不同之处在于，老的zImage解压缩内核到低端内存（第一个640K）
    bzImage解压缩内核到高端内存（1M以上）
    如果内核比较小则可采用zImage或bzImage之一，两种方式引导的系统运行时是相同的。大的内核只能采用bzImage
    
Notice 3 
    vmlinux是未压缩的内核，vmlinuz是vmlinux的压缩文件。 
    例如：vmlinux-2.4.20-8是未压缩内核，vmlinuz-2.4.20-8是vmlinux-2.4.20-8的压缩文件。
```
