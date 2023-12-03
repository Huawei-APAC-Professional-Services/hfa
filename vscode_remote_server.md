# Configure VS Code
This article guides you to configure VS Code to connect to remote Linux server.

## Install Remote Development Kit
1. In VS Code, Select `Mange` icon on the lower left corner then Select `Extensions`
![Install dev kit](./images/vscode/001-install-remote-dev-kit-01.png)  

2. In the VS Code marketplace, search `Remote Development` and install the extension if it's not installed
![Install dev kit](./images/vscode/001-install-remote-dev-kit-02.png)

## Connect to remote server

1. In VS Code, on the left pannel, Select the `Remote Explorer` icon
![Configure Remote Host](./images/vscode/002-configure-remote-dev-kit-01.png) 

2. In VS Code, Select `Remotes(Tunnels/SSH)` from `REMOTE EXPLORER` and Select `+` on the `SSH` tab
![Configure Remote Host](./images/vscode/003-add-remote-server-01.png)

3. VS Code will prompt you to provide the login information as the following picture shows
![Configure Remote Host](./images/vscode/003-add-remote-server-02.png)

> [!NOTE]
> Please use the user name and server information provided by facilitator

4. After the server information is provided, you need to select one of the SSH configuration file to keep the server information
![Configure Remote Host](./images/vscode/003-add-remote-server-03.png)

5. After you chose the configruation file, you will be prompted on the lower right corner of VS Code, Select `Connect` to connect to remote server.
![Configure Remote Host](./images/vscode/003-add-remote-server-04.png)

6. On the new window, you will encounter several prompts, provide necessary information to finish the setup as following picture shows
![Configure Remote Host](./images/vscode/003-add-remote-server-05.png)

![Configure Remote Host](./images/vscode/003-add-remote-server-06.png)

![Configure Remote Host](./images/vscode/003-add-remote-server-07.png)

8. After the setup is done, you should be able to open a new terminal and execute command on remote server as following picture show

![Configure Remote Host](./images/vscode/003-add-remote-server-08.png)

