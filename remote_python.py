import geopandas
import time
import argparse

# script to test deployment of python land use model and reporting

print("imported geopandas")
print(time.asctime())

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description='Integrated Land Use production arg parser')
    parser.add_argument('-cfs', nargs='+', help='list co_fips (cf) ', required=True)
    parser.add_argument('-bsize', help='batch size', required=True)

    args = parser.parse_args()
    cflist = list(args.cfs)
    bsize = int(args.bsize)
    outputlog = r'/home/azureuser/azData/outputlog.txt'

    for cf in cflist:
        print(cf)
        with open(outputlog, 'w') as f:
            f.write(f'{cf} ran something')

    if bsize > 10000:
        print(f'batch size = {bsize}, thats too large')
        status = "fail"
        with open(outputlog, 'w') as f:
            f.write(f'{cf} - script failed')

        exit()
    else:
        print(f"batch size is {bsize}, good!")
    
        status = "complete"
        with open(outputlog, 'w') as f:
            f.write(f'{cf} {status}')
