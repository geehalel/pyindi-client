
"""Setup file for packaging pyindi-client"""

from os.path import join, dirname, abspath

try:
    from distutils.command.build import build
    from setuptools.command.install import install
    from setuptools import setup, Extension
except:
    from distutils.command.build import build
    from distutils.command.install import install
    from distutils import setup, Extension

###

VERSION = '0.1.0'
root_dir = abspath(dirname(__file__))

pyindi_module = Extension('_PyIndi',
                          sources=['indiclientpython.i'],
                          language='c++',
                          extra_objects = ['/usr/lib/libindiclient.a']
)

# Be sure to run build_ext in order to run swig prior to install/build
# see http://stackoverflow.com/questions/12491328/python-distutils-not-include-the-swig-generated-module
class CustomBuild(build):
    def run(self):
        self.run_command('build_ext')
        build.run(self)

class CustomInstall(install):
    def run(self):
        self.run_command('build_ext')
        self.do_egg_install()
        
readme = open(join(root_dir, 'README.rst'))
setup(version=VERSION,
      name='pyindi-client',
      author="geehalel",
      author_email="geehalel@gmail.com",
      url="https:https://sourceforge.net/p/pyindi-client/code/pip/pyindi-client",
      license='GNU General Public License v3 or later (GPLv3+)',
      description="""Third party Python API for INDI client""",
      long_description=readme.read(),
      keywords=["libindi"],
      cmdclass={'build': CustomBuild, 'install': CustomInstall},
      ext_modules=[pyindi_module],
      py_modules=["PyIndi"],
      classifiers=[
          "Programming Language :: Python",
          "Programming Language :: Python :: 2",
          "Programming Language :: Python :: 3",
          "Development Status :: 2 - Pre-Alpha",
          "Environment :: Other Environment",
          "Intended Audience :: Developers",
          "License :: OSI Approved :: GNU General Public License v3 or later (GPLv3+)",
          "Operating System ::Unix",
          "Topic :: Software Development :: Libraries :: Python Modules",
          "Topic :: Scientific/Engineering :: Astronomy"
          ],
      )
readme.close()
