from setuptools import setup, find_packages

setup(
    name="cloudia",
    version="0.1.0",
    packages=find_packages(),
    install_requires=[
        'boto3',
        'botocore',
        'netaddr',
        'pyjq',
        'python-dateutil',
        'pyyaml',
        'jinja2',
        'parliament',
        'matplotlib',
        'pandas',
        'seaborn',
        'policyuniverse',
        'requests',
        's3transfer',
        'toml',
        'urllib3',
    ],
    scripts=['cloudia.py'],
#    entry_points={
#        'console_scripts': [
#            'cloudia = cloudia:main',
#        ],
#    },
)
