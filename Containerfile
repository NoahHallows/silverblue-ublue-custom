ARG FEDORA_MAJOR_VERSION=40

FROM quay.io/fedora-ostree-desktops/silverblue:${FEDORA_MAJOR_VERSION}
# See https://pagure.io/releng/issue/11047 for final location

COPY etc /etc

COPY ublue-firstboot /usr/bin
RUN wget https://copr.fedorainfracloud.org/coprs/calcastor/gnome-patched/repo/fedora-$(rpm -E %fedora)/calcastor-gnome-patched-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_calcastor-gnome-patched.repo
RUN rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:calcastor:gnome-patched mutter

RUN rpm-ostree install distrobox gnome-tweaks gstreamer1-plugin-openh264 mozilla-openh264 htop btop vim powertop tlp ufw akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-cuda && \
    sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    systemctl enable flatpak-automatic.timer && \
    #git clone https://github.com/NoahHallows/silverblue-ublue-custom.git
    #cp silverblue-ublue-custom/config-files/tlp.conf /etc/tlp.conf && \
    #cp silverblue-ublue-custom/config-files/before.rules >> /etc/ufw/before.rules && \
    #systemctl enable tlp && \
    #systemctl enable ufw && \
    #ufw enable && \
    ostree container commit
