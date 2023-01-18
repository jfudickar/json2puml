call prepare_docker_dir.cmd
call build_docker.cmd
"c:\Program Files (x86)\Inno Setup 6\Compil32.exe" /cc json2pumlsetup.iss
