import pandas as pd
import numpy as np

def get_instrument_multi(iter_1, iter_2):
    instrument_df = pd.DataFrame(
    columns=[
        "ZCTA",
        "fire_lat_lon",
        "instrument",
        "year_month",
        "bearing",
        "new_bearing",
        "dist",
        # "instrument_norm",
        # "fire_wspd",
        # "wspd_scaled",
        # "dist_scaled",
    ]
    )
    
    distance_df = fire_dist.iloc[iter_1:iter_2,:]
    bearing_df = fire_bear.iloc[iter_1:iter_2,:]
    
    dist_max = np.max(np.max(distance_df.iloc[:, 11:]))
    dist_min = 0
    wspd_max = np.max(distance_df["fire_wspd"])
    wspd_min = 0
    acres_max = np.max(distance_df["acres"])
    acres_min = np.min(distance_df["acres"])

    for ym in tqdm(distance_df.index):
        days_mo = distance_df["fire_days_in_mo"][ym]
        wspd = distance_df["fire_wspd"][ym]
        for zcta in distance_df.columns[11:]:
            distance = distance_df[zcta][ym]
            bearing = bearing_df[zcta][ym]
            instrument = days_mo * wspd * bearing / distance

#             dist_norm = (distance) / (dist_max)
#             wspd_norm = (wspd) / (wspd_max)
#             bear_norm = (bearing - 0.5) / (0.5)
#             instrument_norm = days_mo * wspd_norm * bear_norm / dist_norm

            instrument_df = instrument_df.append(
                {
                    "ZCTA": zcta,
                    "fire_lat_lon": distance_df["fire_lat_lon"][ym],
                    "instrument": instrument,
                    "year_month": distance_df["year_month"][ym],
                    "bearing": bearing,
                    "dist": distance,
                    "fire_wspd": wspd,
                    # "new_bearing": bear_norm,
                    # "wspd_scaled": wspd_norm,
                    # "dist_scaled": dist_norm,
                    # "instrument_norm": instrument_norm,
                },
                ignore_index=True,
            )
    pbar.update(1)
    print(f'process {iteration} complete')
    instrument_df.to_csv(in_instrument + f"multi-{iter_1}-{iter_2}.csv")
    return f'{iter_1}-{iter_2}'
