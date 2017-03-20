import yaml

def test_yaml():
    obj = yaml.load(open('apps.yaml', 'r'))
    assert obj != None
