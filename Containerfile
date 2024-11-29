ARG FEDORA_MAJOR_VERSION=41

FROM quay.io/fedora-ostree-desktops/silverblue:${FEDORA_MAJOR_VERSION}
# See https://pagure.io/releng/issue/11047 for final location

COPY etc /etc

COPY ublue-firstboot /usr/bin
#RUN wget https://copr.fedorainfracloud.org/coprs/calcastor/gnome-patched/repo/fedora-$(rpm -E %fedora)/calcastor-gnome-patched-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_calcastor-gnome-patched.repo
#RUN rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:calcastor:gnome-patched mutter

RUN rpm-ostree install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
RUN rpm-ostree install distrobox just htop powertop fastfetch btop neovim figlet lolcat gparted nvtop gh cronie cronie-anacron dotnet-sdk-8.0 rpmdevtools vim-common
RUN curl https://copr.fedorainfracloud.org/coprs/lukenukem/asus-linux/repo/fedora-41/lukenukem-asus-linux-fedora-41.repo >> /etc/yum.repos.d/lukenukem-asus-linux-fedora-41.repo && rpm-ostree update
RUN rpm-ostree install asusctl supergfxctl asusctl-rog-gui
RUN sudo sh -c 'echo -e "[unityhub]\nname=Unity Hub\nbaseurl=https://hub.unity3d.com/linux/repos/rpm/stable\nenabled=1\ngpgcheck=1\ngpgkey=https://hub.unity3d.com/linux/repos/rpm/stable/repodata/repomd.xml.key\nrepo_gpgcheck=1" > /etc/yum.repos.d/unityhub.repo' && rpm-ostree update && rpm-ostree install unityhub
#RUN rpm-ostree install akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-cuda
#RUN firewall-cmd --set-target=DROP --zone=public --permanent && \
#    firewall-cmd --zone=nagios --remove-icmp-block={echo-request,echo-reply,timestamp-request,timestamp-reply} --permanent
RUN sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    systemctl enable flatpak-automatic.timer && \
    systemctl enable supergfxd.service && \
    ostree container commit
