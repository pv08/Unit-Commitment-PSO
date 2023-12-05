from argparse import ArgumentParser
from pso import PSO
from data import Data
def main():
    parser = ArgumentParser()
    parser.add_argument('--max_iter', type=int, default=100)
    parser.add_argument('--n_particles', type=int, default=30)
    parser.add_argument('--w', type=float, default=.5)
    parser.add_argument('--c1', type=float, default=1.5)
    parser.add_argument('--c2', type=float, default=1.5)
    data = Data()
    for load in data.loads:
        config, cost = PSO().opt(demand=load['demand'], reserve=load['reserve'])


if __name__ == "__main__":
    main()