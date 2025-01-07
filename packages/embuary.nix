{ lib, rel, buildKodiAddon, fetchzip, addonUpdateScript }:
buildKodiAddon rec {
	pname = "embuary";
	namespace = "skin.embuary-matrix";
	version = "19.0.1";
	
	src = fetchzip {
    		url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}.zip";
		sha256 = "";
	};

	passthru = {
		pythonPath = "resources/lib";
		updateScript = addonUpdateScript {	
			attrpath = "kodi.packages.embuary";
		};
	};
}
