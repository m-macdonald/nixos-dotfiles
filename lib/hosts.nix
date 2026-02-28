{inputs, ...}:
let
  self = inputs.self;
  hostsDir = "${self}/hosts";
in {
  hostPath = hostname: relativePath: "${hostsDir}/${hostname}/${relativePath}";
}
