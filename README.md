# OpenLedger Node Installer
*Disclaimer: The author of this guide, which is exclusively informational material, does not bear any responsibility for the actions of readers. There are no fraudulent or spam links in the guide. All materials were obtained from official sources, links to which can be found at the end of each guide. This post is copyrighted by OnTopAirdrop.*
![image](https://github.com/user-attachments/assets/eed66713-aeba-4374-b718-4c0656d5c75e)
Automatic OpenLedger Node installer for Ubuntu/Debian systems.

## Requirements
- Ubuntu/Debian-based system
- Minimum 2GB RAM
- Root access
### [OpenLedger](https://testnet.openledger.xyz/?referral_code=hhrjuxxose). 


OpenLedger is a data blockchain designed for AI, offering a decentralized trust infrastructure to create specialized language models (SLMs). By leveraging “Datanets” to collect and curate data, OpenLedger facilitates the development of these models, which are then utilized by AI agents, chatbots, copilots, and various other applications.

OpenLedger implements in its testnet the ability to install nodes for almost all devices. The project has attracted $8,000,000 in investments from Polychain Capital, HashKey Capital, etc. EigenLayer and 0G Labs are also partners. 


## [OpenLedger Testnet](https://testnet.openledger.xyz/?referral_code=hhrjuxxose). An overview of [all nodes](https://testnet.openledger.xyz/app-store).

![image](https://github.com/user-attachments/assets/de3a7591-e135-4a85-ad1d-56a1755e888b)

In the [OpenLedger testnet](https://testnet.openledger.xyz/?referral_code=hhrjuxxose), you can set up nodes like this:

- [Windows Node](https://cdn.openledger.xyz/openledger-node-1.0.0-windows.zip)
- [Ubuntu 24.04+ Node](https://cdn.openledger.xyz/openledger-node-1.0.0-linux.zip)
- [Android Node](https://cdn.openledger.xyz/OpenLedger_Android_Node_v0.1.1.apk)
- [Web Browser Node](https://chromewebstore.google.com/detail/openledger-node/ekbbplmjjgoobhdlffmgeokalelnmjjc)

Let's break down the installation for Ubuntu in detail. 
### Quick install

```bash
wget -O - https://github.com/nongdancryptos/OpenLedger-Node/raw/refs/heads/main/openledger.sh | sudo bash
```

### Manual install
## Step 1 - Register [here](https://testnet.openledger.xyz/?referral_code=hhrjuxxose) 

## [OpenLedger Node for Ubuntu](https://testnet.openledger.xyz/?referral_code=hhrjuxxose). Overview and installation.

![image](https://github.com/user-attachments/assets/037a12fd-7f2c-4a55-984f-60760e50ca73)


To fully run the node, we need Ubuntu 24.04 with 1CPU/1RAM/10GB specs. Since the node is implemented in a container using a graphical application, we need to install Docker and a graphical renderer (if it is missing).

Docker installation:

```
sudo apt remove docker docker-engine docker.io containerd runc
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo docker --version
```

Install the necessary package

```
sudo apt update
sudo apt install -y libgtk-3-0 libnotify4 libnss3 libxss1 libxtst6 xdg-utils libatspi2.0-0 libsecret-1-0 
apt install unzip
apt install screen
```
```
apt-get install libgtk2.0-0t64 libgtk-3-0t64 libgbm1 libgbm-dev libnotify-dev libnss3 libxss1 libasound2t64 libxtst6 xauth xvfb
sudo apt-get install desktop-file-utils
```

Download the zip and install it

```
wget https://cdn.openledger.xyz/openledger-node-1.0.0-linux.zip
unzip openledger-node-1.0.0-linux.zip
sudo dpkg -i openledger-node-1.0.0.deb
```

Let's complete the installation with the command:

```
sudo apt-get install -f
sudo dpkg --configure -a
```
Restart the session

Next, create a screen in which the node will work

```
screen -S ol
```

Next, let's go to the launch (If you encounter errors in the first step, skip them).  

```
openledger-node
```

```
openledger-node --no-sandbox
```

### If everything is correct, you will see a window where you need to log in 
![image](https://github.com/user-attachments/assets/ba3c05a7-b066-4c87-87a3-5788e03ce806)
### Click "Setup Node" Button and next: 
![ol-1_1](https://github.com/user-attachments/assets/79f306d9-1c11-411b-8d61-210783499738)


![ol-1](https://github.com/user-attachments/assets/66a504dd-5122-41f6-85f3-3899405a106b)
### Press the connect button. 


![ol-2](https://github.com/user-attachments/assets/cf661d8e-1627-4ffa-8512-cea927b687fb)



### Go to the [OpenLedger Dashboard](https://testnet.openledger.xyz/dashboard) and check the node connection

![ol-3](https://github.com/user-attachments/assets/d6ac4bd7-b2df-46bd-89e5-63974d0b3be3)


## Some problems and solutions:

Starting a node can cause SSH connection to break. If the OpenLedger dashboard has lost connection to the node after 5 minutes. You need to reconnect: 

```
screen -r ol
```
Next, run Node app:

```
openledger-node --no-sandbox
```
In the window that launches, click Disconnect, then Connect Again . After a while, check the stability of the connection in the Dashboard.
## Changing machine-id

The change is necessary if you have started 2 nodes, but the dashboard only displays 1
There is a conflict of identical machine-id

## The current machine-id can be viewed with the command:
```bash
cat /etc/machine-id
```

# Delete the old machine-id
```bash
sudo rm /etc/machine-id
sudo rm /var/lib/dbus/machine-id
```
# Create a new machine-id
```bash
sudo systemd-machine-id-setup
```
# Reboot
```bash
sudo reboot
```
# After reboot, start the node with screen:
```bash
screen -S openledger
openledger-node --no-sandbox
```

Managing screen session:
- Disconnect from session (node ​​will continue to work): `Ctrl + A`, then `D`
- Connect to session: `screen -r openledger`
- List sessions: `screen -ls`
- Kill session: `screen -X -S openledger quit`

Or use prepared script:
```bash
start-openledger
```

## Connect to node

1. Windows:
- Connect via Remote Desktop Connection (RDP)
- Host: IP address of your server
- Username/Password: your Ubuntu credentials

2. Mac:
- Install Microsoft Remote Desktop client
- Add a new connection with the IP address of the server
- Use Ubuntu credentials

## Updates

To update the node:
```bash
wget https://cdn.openledger.xyz/openledger-node-latest.zip
unzip openledger-node-latest.zip
sudo dpkg -i openledger-node*.deb
```

## Troubleshooting

### Error accessing Docker
```bash
sudo usermod -aG docker $USER
newgrp docker
```

### Problems with XRDP
```bash
sudo systemctl restart xrdp
```

### Errors installing packages
```bash
sudo apt --fix-broken install
sudo dpkg --configure -a
```

### Screen session issues
```bash
# Recover lost session
screen -d -r openledger

# If screen is not installed
sudo apt install screen
```

### If you have encountered any other errors, you can ask questions in our [Telegram Channel](https://t.me/ontopairdrop), under the post about OpenLedger 


## Goodluck

![image](https://github.com/nongdancryptos/image/blob/main/ontop-logo.png)

Telegram: https://t.me/OnTopAirdropGroup

GitHub: https://github.com/NongDanCryptos

Chanel: https://t.me/OnTopAirdrop

Twitter: https://x.com/OnTopAirdrop
