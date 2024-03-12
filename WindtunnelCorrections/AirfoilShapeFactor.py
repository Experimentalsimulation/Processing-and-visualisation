import numpy as np

import numpy as np
import matplotlib.pyplot as plt

def calculate_tc_ratio(x_coords, y_coords):

    # Calculate thickness
    print(len(y_coords)%2)
    half = int(len(y_coords)/2)
    surface1 = y_coords[0:half]
    surface2 = y_coords[half+1:]
    option1 = surface1 - surface2
    option2 = surface2 - surface1
    thickness = list(map(max, option1, option2))
    print(thickness)
    # Calculate t/c ratio
    t_c_ratio = max(thickness)
    return t_c_ratio

def plot_airfoil(x_coords, y_coords):
    plt.figure(figsize=(10, 5))
    plt.plot(x_coords, y_coords, label='Airfoil')
    plt.xlabel('X')
    plt.ylabel('Y')
    plt.title('Airfoil Plot')
    plt.axis('equal')
    plt.grid()
    plt.legend()
    plt.show()

def read_airfoil_from_file(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    # Parse the data
    coords = np.array([[float(val) for val in line.split()] for line in lines])

    # Extract x and y coordinates
    x_coords = coords[:, 0]
    y_coords = coords[:, 1]

    return x_coords, y_coords

def main():
    # file_path = 'CoordinatesDU96-150.txt'  # Change this to your file path
    file_path = 'NACA642-015.txt'  # Change this to your file path
    x_coords, y_coords = read_airfoil_from_file(file_path)

    # Calculate t/c ratio
    t_c_ratio = calculate_tc_ratio(x_coords, y_coords)
    print("Thickness-to-chord ratio (t/c):", t_c_ratio)

    # Plot the airfoil
    plot_airfoil(x_coords, y_coords)

if __name__ == "__main__":
    main()


