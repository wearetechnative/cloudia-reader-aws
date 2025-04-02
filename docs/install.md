# Installation on Linux or macOS
Requirements:
- python 3 (3.7.0rc1 is known to work), `pip`, and `virtualenv`
- You will also need `jq` (https://stedolan.github.io/jq/) and the library `pyjq` (https://github.com/doloopwhile/pyjq), which require some additional tools installed that will be shown.

On macOS:

```
# clone the repo
git clone https://github.com/wearetechnative/cloudia.git
# Install pre-reqs for pyjq
brew install autoconf automake awscli freetype jq libtool python3
cd cloudia/
python3 -m venv ./venv && source venv/bin/activate
pip install --prefer-binary -r requirements.txt
```

On Linux:
```
# clone the repo
git clone https://github.com/duo-labs/cloudia.git
# (AWS Linux, Centos, Fedora, RedHat etc.):
# sudo yum install autoconf automake libtool python3-devel.x86_64 python3-tkinter python-pip jq awscli
# (Debian, Ubuntu etc.):
# You may additionally need "build-essential"
sudo apt-get install autoconf automake libtool python3.7-dev python3-tk jq awscli
cd cloudia/
python3 -m venv ./venv && source venv/bin/activate
pip install -r requirements.txt
```


