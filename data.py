class Data:
    def __init__(self):
        self.generations = [
            {'name': 'UTE1', 'a': 1000, 'b': 16.19, 'c': 48e-5, 'Pmax': 455, 'Pmin': 150},
            {'name': 'UTE2', 'a': 970, 'b': 17.26, 'c': 31e-5, 'Pmax': 455, 'Pmin': 150},
            {'name': 'UTE3', 'a': 700, 'b': 16.6, 'c': 2e-3, 'Pmax': 130, 'Pmin': 20},
            {'name': 'UTE4', 'a': 680, 'b': 16.5, 'c': 211e-5, 'Pmax': 130, 'Pmin': 20}
        ]
        self.num_units = len(self.generations)
        self.loads = [
            {'hour': 1, 'demand': 450, 'reserve': 45},
            {'hour': 2, 'demand': 530, 'reserve': 53},
            {'hour': 3, 'demand': 600, 'reserve': 60},
            {'hour': 4, 'demand': 540, 'reserve': 54},
            {'hour': 5, 'demand': 400, 'reserve': 40},
            {'hour': 6, 'demand': 280, 'reserve': 28},
            {'hour': 7, 'demand': 290, 'reserve': 29},
            {'hour': 8, 'demand': 500, 'reserve': 50},
        ]