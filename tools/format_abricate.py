#!/usr/bin/env python

"""
Format results from abricate
"""

import argparse
import pandas as pd


def get_args():
    """Parse command line arguments"""
    parser = argparse.ArgumentParser(
        description="Format results from abricate", add_help=True
    )
    parser.add_argument("--abricate", type=str, help="Path to abricate output")
    args = parser.parse_args()
    return args


def modify_name(file_path: str):
    """
    Modify the name of the sequence to get the sample name
    """
    result = pd.read_csv(file_path)
    result["SEQUENCE"] = (
        result["SEQUENCE"]
        .str.replace("^S[0-9]+C", "", regex=True)
        .str.replace("_contig.*", "", regex=True)
    )
    result.to_csv(file_path, index=False)


if __name__ == "__main__":
    modify_name(get_args().abricate)
