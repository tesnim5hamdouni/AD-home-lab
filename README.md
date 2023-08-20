# AD-home-lab
This is my first introduction to Active Directory. The goal of this lab is to create a Domain Controller VM which will house the AD services along win10 clients. The DC will have 2 NIC, one connected to the internet (VBox's NAT), the other to the internal network which will host our clients.


## on the Domain controller:
#### 2  NICs  :
- NAT connected to the internet, IP assigned automatically from VB DHCP server 
- Internal : static IP address configured manually, DNS will also be handled by the server once AD is installed.
configuration: 
https://www.arrowmail.co.uk/wp-content/uploads/2022/02/LAN-IP-Addresses.pdf
IP : 192.168.5.1
subnet mask: 255.255.255.0
DNS : 127.0.0.1

![1 NICs](https://github.com/tesnim5hamdouni/AD-home-lab/assets/121170828/53e1aa6e-87a4-4631-b5c8-4c68a40a8dc8)


#### Server manager:
https://infrasos.com/how-to-setup-active-directory-on-windows-server-2022/

Add roles and features, in order : 
  - AD Domain Services
  - Routing and Remote Access
  -  DHCP

1. AD Domain services:
in server roles, make sure to select AD Domain Services AD DS - (stores and secures users, computers and other network devices information, facilitates resource sharing...)

once installation is done, we need to promote the server to domain controller and create the forest root domain 

#
##### Windows PowerShell script for AD DS Deployment
#

Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainName "thisismydomain.com" `
-DomainNetbiosName "THISISMYDOMAIN" `
-ForestMode "WinThreshold" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true


Once the domain controller is set (one eternity later!), we can customize our Admin account in AD Users and Computers : in the newly created domain, add a new Organisational Unit "ADMINS and create a new user in it 
this new amdin/user account can be used to sign in to our domain
![AD Users and Computers - add new user to Domain Admins](https://github.com/tesnim5hamdouni/AD-home-lab/assets/121170828/c30d229b-60c2-454c-ac57-94e8a80f95f5)

![AD Users and computers - New Admin user](https://github.com/tesnim5hamdouni/AD-home-lab/assets/121170828/d339e24f-9b89-46a7-bb96-477a044e0386)

#### install RAS/NAT (Remote Access Server / Network Address Translation)

this should allow our client to stay on the internal network all while being able to access the internet through the DC

this is done in add roles and feautres where we pick Remote Acess in the server roles (don't forget to select routing, that will automatically add "DirectAccess and VPN (RAS) to the mix)

once the installation is complete, in Tools > Routing and Remote Access, we configure our local DC by choosing the NAT interface we've already set up in VirtualBox
![3 Routing and remote access - NAT configured](https://github.com/tesnim5hamdouni/AD-home-lab/assets/121170828/59383584-5cc6-4120-b04b-136f3dbd6b8d)

to allow the win client to have an ip address and connect to the internet, we add the DHCP server role to our Domain Controller. then in Tools > DHCP we setup the scope:

192.168.5.100-200
![4 DHCP configuration](https://github.com/tesnim5hamdouni/AD-home-lab/assets/121170828/7b24150c-75e9-4740-913b-c21937d1e00b)

