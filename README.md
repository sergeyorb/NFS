# Домашнее задание - NFS
<ol>
  <li>Подготовка стенда</li>
  <li>Настроить сервер NFS</li>
  <li>Настроить клиент NFS</li>
  <li>Создать автоматизированный Vagrantfile</li>
</ol>

# 1.Подготовка стенда

<ul>
Для создания VM использовал Vagrantfile 
  Была созданы 2 VM 
<p># -*- mode: ruby -*-
<p># vi: set ft=ruby :
<p>Vagrant.configure(2) do |config|
  <p>config.vm.box = "centos/7"
  <p>config.vm.box_version = "2004.01"
  <p>config.vm.provider "virtualbox" do |v|
  <p>v.memory = 256
  <p>v.cpus = 1
<p>end
  <p>config.vm.define "nfss" do |nfss|
  <p>nfss.vm.network "private_network", ip: "192.168.50.10",
  <p>virtualbox__intnet: "net1"
  <p>nfss.vm.hostname = "nfss"
<p>end
  <p>config.vm.define "nfsc" do |nfsc|
  <p>nfsc.vm.network "private_network", ip: "192.168.50.11",
  <p>virtualbox__intnet: "net1"
  <p>nfsc.vm.hostname = "nfsc"
<p>end
<p>end
</ul>

# 2.Настроить сервер NFS
<ul>
  <li>Подключился к серверу vagrant ssh nfss</li>
  <li>Доустановил утилиты команлой</li>
    yum install nfs-utils
  <li>Включил firewall и проверил его работу</li>
    <p>systemctl enable firewalld --now
    <p>systemctl status firewalld
  <li>Разрешил в firewall доступ к сервисам NFS</li>
    <p>firewall-cmd --add-service="nfs3" \
      <p>--add-service="rpc-bind" \
      <p>--add-service="mountd" \
      <p>--permanent
    <p>firewall-cmd --reload
  <li>Включил сервер NFS командой</li>
    systemctl enable nfs --now
  <li>Проверил прослушивание портов 2049/udp, 2049/tcp, 20048/udp, 20048/tcp, 111/udp, 111/tcp </li>
    ss -tnplu
  <li>Создал и настроил дирректорию</li>
    <p>mkdir -p /srv/share/upload
    <p>chown -R nfsnobody:nfsnobody /srv/share
    <p>chmod 0777 /srv/share/upload
  <li>Создал в файле __/etc/exports__ структуру</li>
    <p>cat << EOF > /etc/exports
    <p>/srv/share 192.168.50.11/32(rw,sync,root_squash)
    <p>EOF
  <li>Экспортировал ранее созданную директорию</li>
    exportfs -r  
  <li>Проверил экспортированную директорию командой</li>
    exportfs -s
  <li>Проверил рабоспособность сервера</li>    
</ul>

# 3.Настроить клиент NFS
<ul>
  <li>Подключился к серверу vagrant ssh nfsс</li>
  <li>Доустановил утилиты команлой</li>
    yum install nfs-utils
  <li>Включил firewall и проверил его работу</li>
    <p>systemctl enable firewalld --now
    <p>systemctl status firewalld
  <li>Добавил в __/etc/fstab__ строку</li>
      echo "192.168.50.10:/srv/share/ /mnt nfs vers=3,proto=udp,noauto,xsystemd.automount 0 0" >> /etc/fstab
  <li>Выполнил команду(правда не понял зачем)</li>
      <p>systemctl daemon-reload
      <p>systemctl restart remote-fs.target
  <li>Проверил рабоспособность клиента</li>
</ul>

# 4.Создать автоматизированный Vagrantfile
<ul>
  Откорректировал Vagrantfile добавив строки запуска bash скрипта.
  Сами файлы скриптов были добавлены в папку с проектом. 
  nfss.vm.provision "shell", path: "nfss_script.sh"
  nfsc.vm.provision "shell", path: "nfsc_script.sh"
</ul>
