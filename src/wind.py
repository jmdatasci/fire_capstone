import numpy as np


def bearing(a, b):
    """
    Calculate the bearing angle from point b to point a with respect to true north

    Inputs: Geopy Point Objects a and b
    Output: Bearing Angle in Degrees 0-360
    """

    pa_lat = a["lat"]
    pa_lon = a["lon"]
    pb_lat = b["lat"]
    pb_lon = b["lon"]

    if pb_lon > pa_lon:
        d_x = -np.cos(pa_lat) * np.sin(pa_lon - pb_lon)
    else:
        d_x = np.cos(pa_lat) * np.sin(pa_lon - pb_lon)

    if pb_lat > pb_lon:
        d_y = -np.cos(pb_lat) * np.sin(pa_lat) - np.sin(pb_lat) * np.cos(
            pa_lat
        ) * np.cos(pa_lon - pb_lon)
    else:
        d_y = np.cos(pb_lat) * np.sin(pa_lat) - np.sin(pb_lat) * np.cos(
            pa_lat
        ) * np.cos(pa_lon - pb_lon)

    bearing_ba = np.arctan2(d_x, d_y) * (180 / np.pi) % 360

    return bearing_ba


def hav_dist(a, b):
    """
    Calculate the Haversine distance between two points of lat,lon
     using great circle distance approximation

    Inputs: geopy Point Objects a and b
    Output: distance in miles
    """
    r = 6378.1
    pa_lat = a["lat"]
    pa_lon = a["lon"]
    pb_lat = b["lat"]
    pb_lon = b["lon"]

    s_lat = np.sin((np.deg2rad(pb_lat - pa_lat)) / 2) ** 2
    s_lon = np.sin((np.deg2rad(pb_lon - pa_lon)) / 2) ** 2
    c_lat = np.cos(np.deg2rad(pb_lat)) * np.cos(np.deg2rad(pa_lat))
    tot = s_lat + s_lon * c_lat
    dist = 2 * r * np.arcsin(np.sqrt(tot)) * 0.621371

    return dist


def wind_direction(u, v):
    """
    Calculate direction of wind in degrees as bearing angle from true North

    Input: Wind Vectors u and V
    Output: Wind direction angle in degrees 0-360
    """

    wind_dir = np.arctan2(u, v) * (180 / np.pi) % 360
    return wind_dir


def interaction(bearing_direction, wind_dir):
    """
    Calculate interaction term of wind and bearing based on difference
    of angles.

    Input: Bearing Angle 0-360 degrees, Wind Direction 0-360 degrees
    Output: Interaction term 0.5-1
    """
    angle_diff = np.max([bearing_direction, wind_dir]) - np.min(
        [bearing_direction, wind_dir]
    )

    if angle_diff > 180:
        upwind_effect = angle_diff / 360
    else:
        upwind_effect = 1 - angle_diff / 360
    return upwind_effect


def wind_speed(u, v):
    """
    Calculate speed of wind based on u and v component vectors
    Inputs: u and v wind component vectors
    Output: speed in m/s
    """
    wspd = np.sqrt(u**2 + v**2)
    return wspd
