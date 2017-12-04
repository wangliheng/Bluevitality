#### RPM生成要素
```txt
1. 生成rpm所用文件列表或源代码   
2. 根据文件列表或源码生成rpm规范 -> 即spec  
3. 根据spec文件加工源码/文件的工具rpmbuild
```

#### 准备
```bash
[root@localhost ~]# yum -y install rpmdevtools pcre-devel       #包含rpmbuild，rpmdev-newspec，rpmdev-setuptree
[root@localhost ~]# rpmdev-setuptree                            #生成~/rpmbuild及子目录
[root@localhost ~]# tree rpmbuild
rpmbuild
├── BUILD
├── RPMS
├── SOURCES
├── SPECS
└── SRPMS

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
