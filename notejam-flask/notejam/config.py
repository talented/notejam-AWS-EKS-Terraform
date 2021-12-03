import os
basedir = os.path.abspath(os.path.dirname(__file__))

class Config(object):
    DEBUG = False
    TESTING = False
    SECRET_KEY = 'notejam-flask-secret-key'
    WTF_CSRF_ENABLED = True
    CSRF_SESSION_KEY = 'notejam-flask-secret-key'
    # SQLALCHEMY_DATABASE_URI = 'sqlite:///' + os.path.join(basedir, 'notejam.db')
    SQLALCHEMY_DATABASE_URI = os.getenv("DATABASE_URL", "sqlite://")
    SQLALCHEMY_TRACK_MODIFICATIONS = False

class ProductionConfig(Config):
    DEBUG = False


class DevelopmentConfig(Config):
    DEVELOPMENT = True
    DEBUG = True


class TestingConfig(Config):
    TESTING = True
    WTF_CSRF_ENABLED = False
