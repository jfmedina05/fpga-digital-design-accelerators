from math import sin, cos, atan2, pi

class FastFlowerDrawer:
    def __init__(self):
        pass
       
    def place_in_list(self, point_list: list, a: int, theta: float, x_c: float, y_c: float):
        p = self.compute_point(a, theta, x_c, y_c)
        point_list.append(p)
        return point_list

    def compute_point(self, a: int, theta: float, x_c: float, y_c: float):
        r = (a * cos(5 * (theta))) + (a * 1.3)
        x, y = self.polar_to_cartesian(r, theta, x_c, y_c)
        return (x, y)
    
    def polar_to_cartesian(self, r: float, theta: float, x_c: float, y_c: float):
        x = r * cos(theta) + x_c
        y = r * sin(theta) + y_c
        return (x, y)

    def draw_one_flower(self, a: int, x_c: float = 0, y_c: float = 0):
        theta = 0
        points = []
        while theta <= 2*pi:
            points = self.place_in_list(points,  a, theta, x_c, y_c)
            theta += (2 * pi) / 2500
        points.sort(key=lambda p: atan2(p[0]-x_c, p[1]-y_c))
        return points

    def draw_many_flower(self, inputs: list):
        flower_list = []
        for x, y, r in inputs:
            flower = self.draw_one_flower(a=r, x_c=x, y_c=y)
            flower_list.append(flower)
        return flower_list
