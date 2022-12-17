from rest_framework.versioning import AcceptHeaderVersioning

class AcceptHeaderVersioningWithParameters(AcceptHeaderVersioning):
  default_version = '1.1.2'
  allowed_versions = ['1.1.3', '1.1.2']
