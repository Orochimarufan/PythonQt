# -*- coding: utf-8 -*-
""" provide completions for modules 'import',

copied code with some modifications from IPython!"""

# -----------------------------------------------------------------------------
# Imports
# -----------------------------------------------------------------------------
from __future__ import print_function

# Stdlib imports
import inspect
import os
import re
import sys
from time import time
from zipimport import zipimporter


# -----------------------------------------------------------------------------
# Globals and constants
# -----------------------------------------------------------------------------

# Time in seconds after which the rootmodules will be stored in (nonpermanent) cache
TIMEOUT_STORAGE = 2

# Time in seconds after which we give up
TIMEOUT_GIVEUP = 20

# Regular expression for the python import statement
import_re = re.compile(r'.*(\.so|\.py[cod]?)$')

# global cache
cache = dict()


def module_list(path):
    """
    Return the list containing the names of the modules available in the given
    folder.
    """
    # sys.path has the cwd as an empty string, but isdir/listdir need it as '.'
    if path == '':
        path = '.'

    if os.path.isdir(path):
        folder_list = os.listdir(path)
    elif path.endswith('.egg'):
        try:
            folder_list = [f for f in zipimporter(path)._files]
        except:
            folder_list = []
    else:
        folder_list = []

    if not folder_list:
        return []

    # A few local constants to be used in loops below
    isfile = os.path.isfile
    pjoin = os.path.join
    basename = os.path.basename

    def is_importable_file(path):
        """Returns True if the provided path is a valid importable module"""
        name, extension = os.path.splitext(path)
        return import_re.match(path)  # and py3compat.isidentifier(name)

    # Now find actual path matches for packages or modules
    folder_list = [p for p in folder_list
                   if isfile(pjoin(path, p, '__init__.py'))
                   or is_importable_file(p)]

    return [basename(p).split('.')[0] for p in folder_list]


def get_root_modules():
    """
    Returns a list containing the names of all the modules available in the
    folders of the pythonpath.
    """
    global cache

    if 'rootmodules' in cache:
        return cache['rootmodules']

    t = time()
    store = False
    modules = list(sys.builtin_module_names)
    for path in sys.path:
        modules += module_list(path)
        if time() - t >= TIMEOUT_STORAGE and not store:
            store = True
            print("\nCaching the list of root modules, please wait!")
            print("(This will only be done once.)\n")
            sys.stdout.flush()
        if time() - t > TIMEOUT_GIVEUP:
            print("This is taking too long, we give up.\n")
            cache['rootmodules'] = []
            return []

    modules = set(modules)
    if '__init__' in modules:
        modules.remove('__init__')
    modules = list(modules)
    if store:
        cache['rootmodules'] = modules
    return modules


def is_importable(module, attr, only_modules):
    if only_modules:
        return inspect.ismodule(getattr(module, attr))
    else:
        return not(attr[:2] == '__' and attr[-2:] == '__')


def try_import(mod, only_modules=False):
    try:
        m = __import__(mod)
    except:
        return []
    mods = mod.split('.')
    for module in mods[1:]:
        m = getattr(m, module)

    m_is_init = hasattr(m, '__file__') and '__init__' in m.__file__

    completions = []
    if (not hasattr(m, '__file__')) or (not only_modules) or m_is_init:
        completions.extend([attr for attr in dir(m) if
                            is_importable(m, attr, only_modules)])

    completions.extend(getattr(m, '__all__', []))
    if m_is_init:
        completions.extend(module_list(os.path.dirname(m.__file__)))
    completions = set(completions)
    if '__init__' in completions:
        completions.remove('__init__')
    return list(completions)


def module_completion(line):
    """
    Returns a list containing the completion possibilities for an import line.

    The line looks like this :
    'import xml.d'
    'from xml.dom import'
    """

    words = line.split(' ')
    nwords = len(words)

    # from whatever <tab> -> 'import '
    if nwords == 3 and words[0] == 'from':
        return ['import ']

    # 'from xy<tab>' or 'import xy<tab>'
    if nwords < 3 and (words[0] in ['import', 'from']):
        if nwords == 1:
            return get_root_modules()
        mod = words[1].split('.')
        if len(mod) < 2:
            return get_root_modules()
        completion_list = try_import('.'.join(mod[:-1]), True)
        return ['.'.join(mod[:-1] + [el]) for el in completion_list]

    # 'from xyz import abc<tab>'
    if nwords >= 3 and words[0] == 'from':
        mod = words[1]
        return try_import(mod)
