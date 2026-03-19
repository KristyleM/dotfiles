from __future__ import (absolute_import, division, print_function)

import os
import subprocess

from ranger.api.commands import Command


class fzf_select(Command):
    """:fzf_select
    用 fzf 模糊搜索文件，选中后跳转到该文件。
    """
    def execute(self):
        fzf = self.fm.execute_command(
            "find -L . \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' "
            "-o -fstype 'devtmpfs' \\) -prune "
            "-o -print 2>/dev/null | sed 1d | cut -b3- | fzf +m",
            universal_newlines=True, stdout=subprocess.PIPE)
        stdout, _ = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)


class fzf_cd(Command):
    """:fzf_cd
    用 fzf 模糊搜索目录并 cd 进去。
    """
    def execute(self):
        fzf = self.fm.execute_command(
            "find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' "
            "-o -fstype 'devfs' -o -fstype 'devtmpfs' \\) -prune "
            "-o -type d -print 2>/dev/null | sed 1d | cut -b3- | fzf +m",
            universal_newlines=True, stdout=subprocess.PIPE)
        stdout, _ = fzf.communicate()
        if fzf.returncode == 0:
            fzf_dir = os.path.abspath(stdout.rstrip('\n'))
            self.fm.cd(fzf_dir)


class mkcd(Command):
    """:mkcd <dirname>
    创建目录并进入。
    """
    def execute(self):
        dirname = self.rest(1)
        if not dirname:
            self.fm.notify("Usage: mkcd <dirname>", bad=True)
            return
        dirname = os.path.expanduser(dirname)
        if not os.path.lexists(dirname):
            os.makedirs(dirname)
        self.fm.cd(dirname)
