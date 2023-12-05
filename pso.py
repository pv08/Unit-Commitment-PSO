import numpy as np
import matplotlib.pyplot as plt
from tqdm import tqdm
from data import Data


class Particle:
    def __init__(self, num_units):
        self.position = np.random.uniform(0, 1, num_units)
        self.velocity = np.random.uniform(0, 1, num_units)
        self.best_position = np.copy(self.position)
        self.fitness = float('inf')
        self.hourly_cost_history = []


class PSO(Data):
    def __init__(self, num_particles=150, max_iter=200, w=.5, c1=1.5, c2=1.5):
        super(PSO, self).__init__()
        self.num_particles = num_particles
        self.max_iter = max_iter
        self.w = w
        self.c1 = c1
        self.c2 = c2


    def objective_function(self, solution, demand, reserve):

        cost = 0
        for ger_, ger_data in enumerate(self.generations):
            solgeneration = solution[ger_]
            cost += ger_data['a'] + (ger_data['b'] * solgeneration) + (ger_data['c'] * (solgeneration ** 2))
            #constraint de demanda
            if solgeneration < ger_data['Pmin']:
                penalty_min_capacity = (ger_data['Pmin'] - solgeneration) * ger_data['Pmin']
                cost += penalty_min_capacity

            if solgeneration > ger_data['Pmax']:
                penalty_max_capacity = (solgeneration - ger_data['Pmax']) * ger_data['Pmax']
                cost += penalty_max_capacity

        demand_penalty = abs(sum(solution) - demand) * 10
        cost += demand_penalty

        # Penalidade por não atendimento à reserva
        reserve_penalty = max(0, demand + reserve - sum(solution)) * 10
        cost += reserve_penalty
        return cost


    def update_velocity(self, particle, global_best_position, w, c1, c2):
        r1, r2 = np.random.rand(len(particle.position)), np.random.rand(len(particle.position))
        inertia_term = w * particle.velocity
        cognitive_term = c1 * r1 * (particle.best_position - particle.position)
        social_term = c2 * r2 * (global_best_position - particle.position)
        particle.velocity = inertia_term + cognitive_term + social_term


    def update_position(self, particle):
        particle.position += particle.velocity

    def opt(self, demand, reserve):
        num_units = len(self.generations)
        particles = [Particle(num_units) for _ in range(self.num_particles)]
        global_best_particle = min(particles, key=lambda p: p.fitness)
        convergence = []
        generator_config = []
        for _ in tqdm(range(self.max_iter), total=self.max_iter):
            for particle in particles:
                fitness = self.objective_function(particle.position, demand, reserve)
                if fitness < particle.fitness:
                    particle.fitness = fitness
                    particle.best_position = np.copy(particle.position)

                if fitness < global_best_particle.fitness:
                    global_best_particle = particle

            for particle in particles:
                self.update_velocity(particle, global_best_particle.best_position, self.w, self.c1, self.c2)
                self.update_position(particle)
            self.w = max(0.4, self.w - 0.1)
            convergence.append(global_best_particle.fitness)
            generator_config.append(global_best_particle.best_position)
        print(sum(global_best_particle.best_position))
        return global_best_particle.best_position, global_best_particle.fitness
