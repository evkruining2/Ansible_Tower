namespace: io.cloudslang.testing
operation:
  name: install_module
  python_action:
    use_jython: false
    script: "def execute():\n    import subprocess\n    import sys\n    # leave empty string if you don't need a proxy\n    # proxy = \"http://10.0.0.1:3128\"\n    proxy = \"\"\n    # comma separated list of package names\n    packages = \"numpy,pandas\"\n    for package in packages.split(\",\"):    \n        subprocess.run([sys.executable, \"-m\", \"pip\", \"--proxy\", proxy, \"install\", package])"
  results:
    - SUCCESS
