import pytest
import sys
import os
import re
os.environ['SENTINEL_ENV'] = 'test'
os.environ['SENTINEL_CONFIG'] = os.path.normpath(os.path.join(os.path.dirname(__file__), '../test_sentinel.conf'))
sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'lib'))
sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..'))
import config

from Xchanged import XchangeDaemon
from Xchange_config import XchangeConfig


def test_Xchanged():
    config_text = XchangeConfig.slurp_config_file(config.Xchange_conf)
    network = 'mainnet'
    is_testnet = False
    genesis_hash = u'0x11dff3d3feab81bb973fa356781a7a2f42f8d431a4cb8b3eb3c094d1729135f1'
    for line in config_text.split("\n"):
        if line.startswith('testnet=1'):
            network = 'testnet'
            is_testnet = True
            genesis_hash = u'00000a384129e1401ebba7f117e554378642ba7e6fa8eb627f3e47a3a1631e74'

    creds = XchangeConfig.get_rpc_creds(config_text, network)
    Xchanged = XchangeDaemon(**creds)
    assert Xchanged.rpc_command is not None

    assert hasattr(Xchanged, 'rpc_connection')

    # Xchange testnet block 0 hash == 00000ecbba09ad38ab68c367923732bf8e6f1e9868127d842ceecd330af9c38f
    # test commands without arguments
    info = Xchanged.rpc_command('getinfo')
    info_keys = [
        'blocks',
        'connections',
        'difficulty',
        'errors',
        'protocolversion',
        'proxy',
        'testnet',
        'timeoffset',
        'version',
    ]
    for key in info_keys:
        assert key in info
    assert info['testnet'] is is_testnet

    # test commands with args
    assert Xchanged.rpc_command('getblockhash', 0) == genesis_hash
