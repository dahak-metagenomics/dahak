def container_image_is_external(biocontainers, app):
    """
    Return a boolean: is this container going to be run
    using an external URL (quay.io/biocontainers),
    or is it going to use a local, named Docker image?
    """
    d = biocontainers[app]
    if (('use_local' in d) and (d['use_local'] is True)):
        # This container does not use an external url
        return False
    else:
        # This container uses a quay.io url
        return True


def container_image_name(biocontainers, app):
    """
    Get the name of a container image for app,
    using params dictionary biocontainers.

    Verification:
    - Check that the user provides 'local' if 'use_local' is True
    - Check that the user provides both 'quayurl' and 'version'
    """
    if container_image_is_external(biocontainers,app):
        try:
            qurl  = biocontainers[k]['quayurl']
            qvers = biocontainers[k]['version']
            quayurls.append(qurl + ":" + qvers)
            return quayurls
        except KeyError:
            err = "Error: quay.io URL for %s biocontainer "%(k)
            err += "could not be determined"
            raise Exception(err)

    else:
        try:
            return biocontainers[app]['local']
        except KeyError:
            err = "Error: the parameters provided specify a local "
            err += "container image should be used for %s, but none "%(app)
            err += "was specified using the 'local' key."
            raise Exception(err)

