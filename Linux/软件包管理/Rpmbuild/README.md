#### 备忘
```txt
制作RPM包时不可以使用管理员的身份进行!

RPM生成要素
  1. 生成rpm所需要的文件列表或源代码   
  2. 根据文件列表或源码生成rpm规范 -> 即"spec"文件内描述
  3. 根据spec文件加工源码/文件的工具rpmbuild

xxx.src.rpm
  带有src后缀的rpm不是编译好的二进制程序
  其内部包含了源程序代码与SPEC文件!...
  需要使用rpmbuild命令将其编译为适合当前平台的rpm包之后再进行Install
```

#### 准备
```bash
[root@localhost ~]# yum -y install rpmdevtools pcre-devel       #包含rpmbuild，rpmdev-newspec，rpmdev-setuptree
[root@localhost ~]# cat ~/.rpmmacros                            #宏文件，此处指定RPM包制作的车间目录：'%_topdir'
%_topdir %(echo $HOME)/rpmbuild
[root@localhost ~]# rpmdev-setuptree                            #生成~/rpmbuild及子目录
[root@localhost ~]# tree rpmbuild                               #RPM包的制作车间（遵循一定的目录结构规范）
rpmbuild
├── BUILD                                         #解压后的文件所在（创建RPM时将自动在此目录执行某些操作）
├── RPMS                                          #存放制作完成后的二进制包（含以各平台命名的子目录及对应包）
├── SOURCES                                       #原材料位置，如源码包，文档...
├── SPECS                                         #存放管理rpm制作过程的描述文件（含宏及各阶段的定义和脚本等...）
└── SRPMS                                         #存放制作完成后的src格式rpm包（如：xxx.src.rpm，其没有平台依赖）

5 directories, 0 files
[root@localhost ~]# cd rpmbuild/SPECS/
[root@localhost SPECS]# rpmdev-newspec -o Name-version.spec     #生成默认的SPEC模板
Name-version.spec created; type minimal, rpm version >= 4.11.
[root@localhost SPECS]# cat Name-version.spec 
Name:           Name-version
Version:        
Release:        1%{?dist}
Summary:        

License:        
URL:            
Source0:        

BuildRequires:  
Requires:       

%description


%prep
%setup -q


%build
%configure
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
%make_install


%files
%doc



%changelog
```

#### 软件包所属类别
```txt
Amusements/Games （娱乐/游戏）
Amusements/Graphics（娱乐/图形）
Applications/Archiving （应用/文档）
Applications/Communications（应用/通讯）
Applications/Databases （应用/数据库）
Applications/Editors （应用/编辑器）
Applications/Emulators （应用/仿真器）
Applications/Engineering （应用/工程）
Applications/File （应用/文件）
Applications/Internet （应用/因特网）
Applications/Multimedia（应用/多媒体）
Applications/Productivity （应用/产品）
Applications/Publishing（应用/印刷）
Applications/System（应用/系统）
Applications/Text （应用/文本）
Development/Debuggers （开发/调试器）
Development/Languages （开发/语言）
Development/Libraries （开发/函数库）
Development/System （开发/系统）
Development/Tools （开发/工具）
Documentation （文档）
System Environment/Base（系统环境/基础）
System Environment/Daemons （系统环境/守护）
System Environment/Kernel （系统环境/内核）
System Environment/Libraries （系统环境/函数库）
System Environment/Shells （系统环境/接口）
User Interface/Desktops（用户界面/桌面）
User Interface/X （用户界面/X窗口）
User Interface/X Hardware Support （用户界面/X硬件支持）
```
