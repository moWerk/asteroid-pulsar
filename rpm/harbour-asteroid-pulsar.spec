# xz, not zstd: rpm on SailfishOS 3.4 can not unpack zstd payloads
%define _binary_payload w6.xzdio

Name:       harbour-asteroid-pulsar
Summary:    Pulsar, a stroboscope
Version:    1.1.0
Release:    1
License:    GPLv3+
URL:        https://github.com/moWerk/asteroid-pulsar
Source0:    %{name}-%{version}.tar.bz2
BuildArch:  noarch
Requires:   sailfishsilica-qt5 >= 0.10.9
Requires:   libsailfishapp-launcher
Requires:   qt5-qtgraphicaleffects
Requires:   libkeepalive
Requires:   nemo-qml-plugin-systemsettings
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  desktop-file-utils
BuildRequires:  qt5-qttools-linguist

%description
Pulsar turns the screen into a stroboscope from 1 to 25 Hz, with an RPM
readout for mechanical work. Ported from AsteroidOS.

%prep
%setup -q -n %{name}-%{version}

%build
%qmake5
%make_build

%install
%qmake5_install
desktop-file-install --delete-original \
    --dir %{buildroot}%{_datadir}/applications \
    %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
