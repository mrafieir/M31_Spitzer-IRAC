# based on analyze.py by Pauline Barmby 
from astropy.table import Table, Column, vstack
import numpy as np
from astropy import units as u
from astropy.coordinates import SkyCoord, Distance, Angle

# J Sick's mod
def correct_rgc(glx_ctr=SkyCoord('00h42m44.33s +41d16m07.5s'),
        glx_PA=Angle('37d42m54s'),
        glx_incl=Angle('77.5d'),
        glx_dist=Distance(783, unit=u.kpc),
        deproject=True):
    """Computes (deprojected) galactocentric distance.

    Inspired by: http://idl-moustakas.googlecode.com/svn-history/
        r560/trunk/impro/hiiregions/im_hiiregion_deproject.pro

    Parameters
    ----------
    coord : :class:`astropy.coordinates.ICRS`
        Coordinate of points to compute galactocentric distance for.
        Can be either a single coordinate, or array of coordinates.
    glx_ctr : :class:`astropy.coordinates.ICRS`
        Galaxy center.
    glx_PA : :class:`astropy.coordinates.Angle`
        Position angle of galaxy disk.
    glx_incl : :class:`astropy.coordinates.Angle`
        Inclination angle of the galaxy disk.
    glx_dist : :class:`astropy.coordinates.Distance`
        Distance to galaxy.
    deproject: correct for inclination? 

    Returns
    -------
    (if correcting for inclination): obj_dist : class:`astropy.coordinates.Distance`
        Galactocentric distance(s) for coordinate point(s).
    (otherwise)
    major, minor : class:`astropy.coordinates.Angle`
        projected Galactocentric distance(s) for coordinate point(s).
    """
    # read the catalog
    catab = Table.read('/Users/seatoskyhw/Projects/project_80032/cmpltnss/left-right', format='ascii.no_header')
    ra, dec = catab['col1'], catab['col2']
    coord = SkyCoord(ra=ra*u.degree, dec = dec*u.degree)

    # distance from coord to glx centre
    sky_radius = glx_ctr.separation(coord)
    avg_dec = 0.5 * (glx_ctr.dec + coord.dec).radian
    x = (glx_ctr.ra - coord.ra) * np.cos(avg_dec)
    y = glx_ctr.dec - coord.dec
    # azimuthal angle from coord to glx  -- not completely happy with this
    phi = glx_PA - Angle('90d') \
            + Angle(np.arctan(y.arcsec / x.arcsec), unit=u.rad)

    # convert to coordinates in rotated frame, where y-axis is galaxy major
    # ax; have to convert to arcmin b/c can't do sqrt(x^2+y^2) when x and y
    # are angles
    xp = (sky_radius * np.cos(phi.radian)).arcmin
    yp = (sky_radius * np.sin(phi.radian)).arcmin

    # de-project
    if deproject:
        ypp = yp / np.cos(glx_incl.radian)
        obj_radius = np.sqrt(xp ** 2 + ypp ** 2)  # in arcmin
        obj_dist = Distance(Angle(obj_radius, unit=u.arcmin).radian * glx_dist,
            unit=glx_dist.unit)

        # Computing PA in disk (unused)
        obj_phi = Angle(np.arctan(ypp / xp), unit=u.rad)
        # TODO Zero out very small angles, i.e.
        # if np.abs(Angle(xp, unit=u.arcmin)) < Angle(1e-5, unit=u.rad):
        #     obj_phi = Angle(0.0)

        return obj_radius #obj_dist

    else:
        return (xp, yp)
