{pkgs, ...}:
{

    security.polkit.enable = true;
    # systemd = {
    #     user.services.polkit-kde-authentication-agent-1 = {
    #         description = "Agent for authentication";
    #         wantedBy = ["graphical-session.target"];
    #         wants = ["niri.service"];
    #         after = ["graphical-session.target"];
    #         environment = {
    #             QT_QPA_PLATFORM = "xcb";
    #         };
    #         serviceConfig = {
    #             Type = "simple";
    #             ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
    #             Restart = "on-failure";
    #             RestartSec = 1;
    #             TimeoutStopSec = 10;
    #         };
    #     };
    # };
}
