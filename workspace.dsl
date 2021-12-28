workspace {
    model {
        pitopUser = person "pi-top User"
        pitopOSDeveloper = person "pi-topOS Developer"

        peripherals = softwareSystem "pi-top [4] Peripherals"

        pitop = softwareSystem "pi-top [4]" {
            access = group "Access" {
                furtherLinkServer = container "Further Link Server"
                sshServer = container "SSH Server"
                vncServer = container "VNC Server"
                desktop = container "Desktop (local)"
            }

            recovery = container "Recovery"

            pitopHardwareSupport = group "pi-top Hardware Support" {
                displayPort = container "DisplayPort"
                touchscreen = container "Touchscreen"
                pitop4Miniscreen = container "pi-top [4] Miniscreen"
                firmwareUpdater = container "Firmware Updater"
                pitopd = container "pi-topd (Primary Hardware System Daemon)"
                pitopPythonSDK = container "pi-top Python SDK"
            }

            config = group "Config" {
                networkModifications = container "Network Modifications"
                systemModifications = container "System Modifications"
                wifiAP = container "Wi-Fi AP"
            }

            helpers = group "Helpers" {
                corePackages = container "pi-topOS Core Packages"
                pitopOSAptSource = container "pi-topOS Apt Source"
                i2ctoolsextra = container "i2c-tools-extra"
            }

            services = group "Services" {
                furtherLink = container "Further Link"
                webPortal = container "Web Portal (Web Server)"
            }

            upstreamPackages = group "Upstream Packaging" {
                onnxruntime = container "onnxruntime"
                pythonsonic = container "python-sonic"
            }

            furtherLink -> furtherLinkServer "Manages"

            desktopUi = group "Desktop UI" {
                webRenderer = container "Web Renderer"
                bootsplash = container "Bootsplash"
                uiModifications = container "UI Modifications"
                startMenuQuitOptions = container "Start Menu Quit Options"
                iconTheme = container "Icon Theme"
                notifySendNg = container "Desktop Notification System (notify-send-ng)"
            }

            hub = container "pi-top [4] Hub"
        }

        backendServer = softwareSystem "API Server (api.pi-top.com)" {
            webApi = container "Web API"
        }

        aptServer = softwareSystem "APT Server"

        gitHubCI = softwareSystem "GitHub CI"

        further = softwareSystem "Further (further.pi-top.com)"

        webPortal -> firmwareUpdater "Uses"

        firmwareUpdater -> i2ctoolsextra "Uses"
        firmwareUpdater -> hub "Updates Firmware" "I2C"
        firmwareUpdater -> peripherals "Updates Firmware" "I2C"

        pitopUser -> sshServer "Connects" "SSH"
        pitopUser -> vncServer "Connects" "VNC"
        vncServer -> desktop "Shows"
        pitopUser -> webPortal "Connects" "HTTP"
        pitopUser -> desktop "Uses"
        desktop -> bootsplash "Uses"
        desktop -> uiModifications "Uses"
        desktop -> startMenuQuitOptions "Uses"
        desktop -> iconTheme "Uses"
        pitopUser -> further "Uses"
        further -> furtherLink "Connects" "HTTP"

        pitopOSDeveloper -> gitHubCI "Pushes Code"
        gitHubCI -> aptServer "Publishes Software"
        gitHubCI -> pitop "Creates OS"

        webPortal -> webApi "Determines update logic based"
        webPortal -> webApi "Registers device serial and email"
        webPortal -> aptServer "Gets software updates"

        pitopd -> pitopPythonSDK "Uses"
        pitop4Miniscreen -> pitopPythonSDK "Uses"
        furtherLink -> pitopPythonSDK "Uses"
        firmwareUpdater -> pitopPythonSDK "Uses"
    }

    views {
        theme default
    }
}
