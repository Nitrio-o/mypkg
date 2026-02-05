import os
from glob import glob
from setuptools import setup

package_name = 'sysinfo_pub'

setup(
    name=package_name,
    version='0.1.0',
    packages=['sysinfo_pub'],
    data_files=[
        ('share/ament_index/resource_index/packages',
            ['resource/' + package_name]),
        ('share/' + package_name, ['package.xml']),
        (os.path.join('share', package_name), glob('launch/*.launch.py')),
    ],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='abe',
    maintainer_email='s21c1007qn@s.chibakoudai.jp',
    description='Publish system information as ROS 2 messages.',
    license='BSD-3-Clause',
    tests_require=['pytest'],
    entry_points={
        'console_scripts': [
            'sysinfo_pub = sysinfo_pub.sysinfo_pub:main',
            'sysinfo_sub = sysinfo_pub.sysinfo_sub:main',
        ],
    },
)

