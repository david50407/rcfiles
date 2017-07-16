#!/usr/bin/env python
# -*- coding: utf-8 -*-

import argparse
import os
import sys

def warn(msg):
    print '[powerline-shell-clearly] ', msg

class Powerline:
    symbols = {
        'compatible': {
            'lock': 'RO',
            'network': 'SSH',
            'separator': u'\u25B6',
            'separator_thin': u'\u276F'
        },
        'clearly': {
            'lock': u'\uE0A2',
            'network': u'\uE0A2',
            'separator': u'>',
            'separator_thin': u'\uE0B1'
        },
        'flat': {
            'lock': '',
            'network': '',
            'separator': '',
            'separator_thin': ''
        },
    }

    color_templates = {
        'bash': '\\[\\e%s\\]',
        'zsh': '%%{%s%%}',
        'bare': '%s',
    }

    def __init__(self, args, cwd):
        self.args = args
        self.cwd = cwd
        mode, shell = args.mode, args.shell
        self.color_template = self.color_templates[shell]
        self.reset = self.color_template % '[0m'
        self.lock = Powerline.symbols[mode]['lock']
        self.network = Powerline.symbols[mode]['network']
        self.separator = Powerline.symbols[mode]['separator']
        self.separator_thin = Powerline.symbols[mode]['separator_thin']
        self.segments = []

    def color(self, prefix, code):
        return self.color_template % ('[%s;5;%sm' % (prefix, code))

    def fgcolor(self, code):
        return self.color('38', code)

    def bgcolor(self, code):
        return self.color('48', code)

    def append(self, content, fg, separator_fg=None, separator=None):
        self.segments.append((content, fg, separator_fg or fg,
            separator or self.separator))

    def draw(self):
        return (''.join(self.draw_segment(i) for i in range(len(self.segments)))
                + self.reset).encode('utf-8')

    def draw_segment(self, idx):
        segment = self.segments[idx]
        next_segment = self.segments[idx + 1] if idx < len(self.segments)-1 else None

        return ''.join((
            self.fgcolor(segment[1]),
            segment[0],
            self.fgcolor(segment[2]),
            segment[3]))

def get_valid_cwd():
    """ We check if the current working directory is valid or not. Typically
        happens when you checkout a different branch on git that doesn't have
        this directory.
        We return the original cwd because the shell still considers that to be
        the working directory, so returning our guess will confuse people
    """
    try:
        cwd = os.getcwd()
    except:
        cwd = os.getenv('PWD')  # This is where the OS thinks we are
        parts = cwd.split(os.sep)
        up = cwd
        while parts and not os.path.exists(up):
            parts.pop()
            up = os.sep.join(parts)
        try:
            os.chdir(up)
        except:
            warn("Your current directory is invalid.")
            sys.exit(1)
        warn("Your current directory is invalid. Lowest valid directory: " + up)
    return cwd


if __name__ == "__main__":
    arg_parser = argparse.ArgumentParser()
    arg_parser.add_argument('--cwd-only', action='store_true',
            help='Only show the current directory')
    arg_parser.add_argument('--cwd-max-depth', action='store', type=int,
            default=5, help='Maximum number of directories to show in path')
    arg_parser.add_argument('--colorize-hostname', action='store_true',
            help='Colorize the hostname based on a hash of itself.')
    arg_parser.add_argument('--mode', action='store', default='clearly',
            help='The characters used to make separators between segments',
            choices=['patched', 'compatible', 'flat'])
    arg_parser.add_argument('--shell', action='store', default='bash',
            help='Set this to your shell type', choices=['bash', 'zsh', 'bare'])
    arg_parser.add_argument('prev_error', nargs='?', type=int, default=0,
            help='Error code returned by the last command')
    args = arg_parser.parse_args()

    powerline = Powerline(args, get_valid_cwd())


class DefaultColor:
    """
    This class should have the default colors for every segment.
    Please test every new segment with this theme first.
    """
    USERNAME_FG = 22
    USERNAME_BG = 148
    USERNAME_ROOT_FG = 15
    USERNAME_ROOT_BG = 124

    HOSTNAME_FG = 88
    HOSTNAME_BG = 208

    ROOT_FG = 124
    PATH_FG = 31
    CWD_FG = 33
    PATH_SEPARATOR_FG = 31  # blueish
    SEPARATOR_FG = 244

    READONLY_BG = 124
    READONLY_FG = 254

    SSH_BG = 166 # medium orange
    SSH_FG = 254

    REPO_CLEAN_FG = 148  # a light green color
    REPO_DIRTY_FG = 161  # pink/red

    JOBS_FG = 39
    JOBS_BG = 238

    CMD_PASSED_FG = 15
    CMD_FAILED_FG = 204

    SVN_CHANGES_BG = 148
    SVN_CHANGES_FG = 22  # dark green

    VIRTUAL_ENV_FG = 53

    RVM_ENV_FG   = 160
    CRENV_ENV_FG = 39
    NVM_ENV_FG   = 148

class Color(DefaultColor):
    """
    This subclass is required when the user chooses to use 'default' theme.
    Because the segments require a 'Color' class for every theme.
    """
    pass

import os

def add_virtual_env_segment():
    env = os.getenv('VIRTUAL_ENV')
    if env is None:
        return

    env_name = os.path.basename(env)
    fg = Color.VIRTUAL_ENV_FG
    powerline.append(' %s ' % env_name, fg)

add_virtual_env_segment()



def add_username_segment():
    import os
    if powerline.args.shell == 'bash':
        user_prompt = ' \\u '
    elif powerline.args.shell == 'zsh':
        user_prompt = ' %n '
    else:
        user_prompt = ' %s ' % os.getenv('USER')

    if os.getenv('USER') == 'root':
        fgcolor = Color.USERNAME_ROOT_FG
    else:
        fgcolor = Color.USERNAME_FG

    #if os.getenv('USER') != os.getenv('LOGNAME'):
    powerline.append(user_prompt, fgcolor)

#add_username_segment()


def add_hostname_segment():
    if powerline.args.colorize_hostname:
        from lib.color_compliment import stringToHashToColorAndOpposite
        from lib.colortrans import rgb2short
        from socket import gethostname
        hostname = gethostname()
        FG, BG = stringToHashToColorAndOpposite(hostname)
        FG, BG = (rgb2short(*color) for color in [FG, BG])
        host_prompt = ' %s' % hostname.split('.')[0]

        powerline.append(host_prompt, FG)
    else:
        if powerline.args.shell == 'bash':
            host_prompt = ' \\h '
        elif powerline.args.shell == 'zsh':
            host_prompt = ' %m '
        else:
            import socket
            host_prompt = ' %s ' % socket.gethostname().split('.')[0]

        powerline.append(host_prompt, Color.HOSTNAME_FG)


#add_hostname_segment()

import os

def add_ssh_segment():
    if os.getenv('SSH_CLIENT'):
        powerline.append(' %s ' % powerline.network, Color.SSH_FG)

#add_ssh_segment()

import os

def get_short_path(cwd):
    home = os.getenv('HOME')
    names = cwd.split(os.sep)
    if names[0] == '': names = names[1:]
    path = ''
    for i in range(len(names) - 1):
        path += os.sep + names[i]
        if os.path.samefile(path, home):
            return names[i+1:]
    path += os.sep + names[len(names) - 1]
    if os.path.samefile(path, home):
        return ['~']
    if names[0] != '~':
        names = ['/'] + names
    return names

def add_cwd_segment():
    cwd = powerline.cwd or os.getenv('PWD')
    names = get_short_path(cwd.decode('utf-8'))

    max_depth = powerline.args.cwd_max_depth
    if len(names) > max_depth:
        names = names[:2] + [u'\u2026'] + names[2 - max_depth:]

    if names[0] != '/' and names[0] != '~':
        powerline.append('', Color.SEPARATOR_FG, Color.SEPARATOR_FG, ' ')

    if not powerline.args.cwd_only:
        for n in names[:-1]:
            if n == '/':
                powerline.append('', Color.ROOT_FG,
                    Color.ROOT_FG, '/')
            else:
                powerline.append('%s' % n, Color.PATH_FG,
                    Color.PATH_SEPARATOR_FG, '/')

    if names[-1] == '/':
        powerline.append('', Color.ROOT_FG, Color.ROOT_FG, '/')
    else:
        powerline.append('%s ' % names[-1], Color.CWD_FG)

add_cwd_segment()

import os

def add_read_only_segment():
    cwd = powerline.cwd or os.getenv('PWD')

    if not os.access(cwd, os.W_OK):
        powerline.append(' %s ' % powerline.lock, Color.READONLY_FG)

add_read_only_segment()

import re
import subprocess

def get_git_status():
    has_pending_commits = True
    has_untracked_files = False
    origin_position = ""
    output = subprocess.Popen(['git', 'status', '--ignore-submodules'],
            env={"LANG": "C", "HOME": os.getenv("HOME")}, stdout=subprocess.PIPE).communicate()[0]
    for line in output.split('\n'):
        origin_status = re.findall(
            r"Your branch is (ahead|behind).*?(\d+) comm", line)
        if origin_status:
            origin_position = " %d" % int(origin_status[0][1])
            if origin_status[0][0] == 'behind':
                origin_position += 'v' # u'\u2193'
            if origin_status[0][0] == 'ahead':
                origin_position += '^' # u'\u2191'

        if line.find('nothing to commit') >= 0:
            has_pending_commits = False
        if line.find('Untracked files') >= 0:
            has_untracked_files = True
    return has_pending_commits, has_untracked_files, origin_position

def add_git_segment():
    # See http://git-blame.blogspot.com/2013/06/checking-current-branch-programatically.html
    p = subprocess.Popen(['git', 'symbolic-ref', '-q', 'HEAD'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out, err = p.communicate()

    if 'Not a git repo' in err:
        return

    if out:
        branch = out[len('refs/heads/'):].rstrip()
    else:
        branch = '(Detached)'

    has_pending_commits, has_untracked_files, origin_position = get_git_status()
    branch += origin_position
    if has_untracked_files:
        branch += ' +'

    fg = Color.REPO_CLEAN_FG
    if has_pending_commits:
        fg = Color.REPO_DIRTY_FG

    powerline.append(' %s ' % branch, fg, fg)

try:
    add_git_segment()
except OSError:
    pass
except subprocess.CalledProcessError:
    pass


import os
import subprocess

def get_hg_status():
    has_modified_files = False
    has_untracked_files = False
    has_missing_files = False
    output = subprocess.Popen(['hg', 'status'],
            stdout=subprocess.PIPE).communicate()[0]
    for line in output.split('\n'):
        if line == '':
            continue
        elif line[0] == '?':
            has_untracked_files = True
        elif line[0] == '!':
            has_missing_files = True
        else:
            has_modified_files = True
    return has_modified_files, has_untracked_files, has_missing_files

def add_hg_segment():
    branch = os.popen('hg branch 2> /dev/null').read().rstrip()
    if len(branch) == 0:
        return False
    fg = Color.REPO_CLEAN_FG
    has_modified_files, has_untracked_files, has_missing_files = get_hg_status()
    if has_modified_files or has_untracked_files or has_missing_files:
        fg = Color.REPO_DIRTY_FG
        extra = ''
        if has_untracked_files:
            extra += '+'
        if has_missing_files:
            extra += '!'
        branch += (' ' + extra if extra != '' else '')
    return powerline.append(' %s ' % branch, fg)

add_hg_segment()

import subprocess

def add_svn_segment():
    is_svn = subprocess.Popen(['svn', 'status'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    is_svn_output = is_svn.communicate()[1].strip()
    if len(is_svn_output) != 0:
        return

    #"svn status | grep -c "^[ACDIMRX\\!\\~]"
    p1 = subprocess.Popen(['svn', 'status'], stdout=subprocess.PIPE,
            stderr=subprocess.PIPE)
    p2 = subprocess.Popen(['grep', '-c', '^[ACDIMR\\!\\~]'],
            stdin=p1.stdout, stdout=subprocess.PIPE)
    output = p2.communicate()[0].strip()
    if len(output) > 0 and int(output) > 0:
        changes = output.strip()
        powerline.append(' %s ' % changes, Color.SVN_CHANGES_FG)

try:
    add_svn_segment()
except OSError:
    pass
except subprocess.CalledProcessError:
    pass


import os
import subprocess

def get_fossil_status():
    has_modified_files = False
    has_untracked_files = False
    has_missing_files = False
    output = os.popen('fossil changes 2>/dev/null').read().strip()
    has_untracked_files = True if os.popen("fossil extras 2>/dev/null").read().strip() else False
    has_missing_files = 'MISSING' in output
    has_modified_files = 'EDITED' in output

    return has_modified_files, has_untracked_files, has_missing_files

def add_fossil_segment():
    subprocess.Popen(['fossil'], stdout=subprocess.PIPE).communicate()[0]
    branch = ''.join([i.replace('*','').strip() for i in os.popen("fossil branch 2> /dev/null").read().strip().split("\n") if i.startswith('*')])
    if len(branch) == 0:
        return

    fg = Color.REPO_CLEAN_FG
    has_modified_files, has_untracked_files, has_missing_files = get_fossil_status()
    if has_modified_files or has_untracked_files or has_missing_files:
        fg = Color.REPO_DIRTY_FG
        extra = ''
        if has_untracked_files:
            extra += '+'
        if has_missing_files:
            extra += '!'
        branch += (' ' + extra if extra != '' else '')
    powerline.append(' %s ' % branch, fg)

try:
    add_fossil_segment()
except OSError:
    pass
except subprocess.CalledProcessError:
    pass


import os
import re
import subprocess

def add_jobs_segment():
    pppid = subprocess.Popen(['ps', '-p', str(os.getppid()), '-oppid='], stdout=subprocess.PIPE).communicate()[0].strip()
    output = subprocess.Popen(['ps', '-a', '-o', 'ppid'], stdout=subprocess.PIPE).communicate()[0]
    num_jobs = len(re.findall(str(pppid), output)) - 1

    if num_jobs > 0:
        powerline.append(' %d ' % num_jobs, Color.JOBS_FG)

add_jobs_segment()

import os
import subprocess

def add_rvm_segment():
    ruby_v = subprocess.Popen(['ruby', '-v'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    ruby_version = ruby_v.communicate()[0].strip()
    gemdir = os.environ['GEM_HOME'] + '@'
    if len(ruby_version) > 0:
        output = ruby_version.split(' ')[1]
        if len(gemdir) > 0:
            gemset_name = gemdir.split('@')[1]
            if len(gemset_name) > 0:
                output += "@" + gemset_name
        powerline.append(' %s ' % output, Color.RVM_ENV_FG)

try:
    add_rvm_segment()
except OSError:
    pass
except subprocess.CalledProcessError:
    pass

def add_crenv_segment():
    crystal_current = subprocess.Popen(['crenv', 'version'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    output = crystal_current.communicate()[0].strip()
    if len(output) > 0:
        output = output.split(' ')[0]
        powerline.append(' %s ' % output, Color.CRENV_ENV_FG)

try:
    add_crenv_segment()
except OSError:
    pass
except subprocess.CalledProcessError:
    pass

def add_nvm_segment():
    node_current = subprocess.Popen(['node', '-v'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    output = node_current.communicate()[0].strip()
    if len(output) > 0:
        output = output.split('v')[1]
        powerline.append(' %s ' % output, Color.NVM_ENV_FG)

try:
    add_nvm_segment()
except OSError:
    pass
except subprocess.CalledProcessError:
    pass

def add_root_indicator_segment():
    root_indicators = {
        'bash': ' \\$ ',
        'zsh': ' \\$ ',
        'bare': ' $ ',
    }
    fg = Color.CMD_PASSED_FG
    if powerline.args.prev_error != 0:
        fg = Color.CMD_FAILED_FG
    powerline.append(root_indicators[powerline.args.shell], 15, fg)

add_root_indicator_segment()


sys.stdout.write(powerline.draw() + ' ')
