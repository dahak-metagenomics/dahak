def container_image_is_external(biocontainers, app):
    """
    Return a boolean: is this container going to be run
    using an external URL (quay.io/biocontainers),
    or is it going to use a local, named Docker image?
    """
    try:
        d = biocontainers[app]
        if (('use_local' in d) and (d['use_local'] is True)):
            # This container does not use an external url
            return False
        else:
            # This container uses a quay.io url
            return True

    except KeyError:
        # This is where things get complicated.
        # Snakemake maintains separation between
        # parameter validation and knowing what rules
        # we are actually running.
        # 
        # This makes it impossible to validate parameters
        # except to do it entirely in the dark about what 
        # we're going to be doing..
        # 
        # Solution? 
        # Ditch parameter validation.
        # Hope the user knows waht they're doing. 
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
            qurl  = biocontainers[app]['quayurl']
            qvers = biocontainers[app]['version']
            return qurl + ":" + qvers
        except KeyError:
            #err = "Error: quay.io URL for %s biocontainer "%(app)
            #err += "could not be determined"
            #raise Exception(err)
            ## let it ride
            return ""

    else:
        try:
            return biocontainers[app]['local']
        except KeyError:
            #err = "Error: the parameters provided specify a local "
            #err += "container image should be used for %s, but none "%(app)
            #err += "was specified using the 'local' key."
            #raise Exception(err)
            ## let it ride
            return ""

