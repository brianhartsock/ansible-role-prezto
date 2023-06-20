def test_prezto_exists(host):
    assert host.file('/root/.zprezto').exists


def test_prezto_directory(host):
    assert host.file('/root/.zprezto').is_directory


def test_zlogin_link(host):
    assert host.file('/root/.zlogin').linked_to == \
            '/root/.zprezto/runcoms/zlogin'


def test_zlogout_link(host):
    assert host.file('/root/.zlogout').linked_to == \
            '/root/.zprezto/runcoms/zlogout'


def test_zpreztorc_link(host):
    assert host.file('/root/.zpreztorc').linked_to == \
            '/root/.zprezto/runcoms/zpreztorc'


def test_zprofile_link(host):
    assert host.file('/root/.zprofile').linked_to == \
            '/root/.zprezto/runcoms/zprofile'


def test_zshenv_link(host):
    assert host.file('/root/.zshenv').linked_to == \
            '/root/.zprezto/runcoms/zshenv'


def test_zshrc_link(host):
    assert host.file('/root/.zshrc').linked_to == \
            '/root/.zprezto/runcoms/zshrc'
