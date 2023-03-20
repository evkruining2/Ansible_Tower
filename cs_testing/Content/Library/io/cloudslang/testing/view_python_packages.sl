namespace: io.cloudslang.testing
operation:
  name: view_python_packages
  python_action:
    use_jython: false
    script: |-
      def execute():
          import subprocess
          import sys
          out =  subprocess.run([sys.executable, "-m", "pip", "freeze"], capture_output=True)
          return {"installed_modules": out.stdout.decode()}
  outputs:
    - installed_modules: '${installed_modules}'
  results:
    - SUCCESS
