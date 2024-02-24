package conwaygame;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;

public class GameOfLife {

	// Instance variables
	private static final boolean ALIVE = true;
	private static final boolean DEAD = false;

	private boolean[][] grid; // The board has the current generation of cells
	private int totalAliveCells; // Total number of alive cells in the grid (board)

	public GameOfLife() {
		grid = new boolean[5][5];
		totalAliveCells = 5;
		grid[1][1] = ALIVE;
		grid[1][3] = ALIVE;
		grid[2][2] = ALIVE;
		grid[3][2] = ALIVE;
		grid[3][3] = ALIVE;
	}

	public GameOfLife(String file) {

		StdIn.setFile(file);
		int rows = StdIn.readInt();
		int cols = StdIn.readInt();
		grid = new boolean[rows][cols];
		for (int i = 0; i < rows; i++) {
			for (int j = 0; j < cols; j++) {
				grid[i][j] = StdIn.readBoolean();
				if (grid[i][j] == ALIVE) {
					totalAliveCells++;
				}
			}
		}
	}

	public boolean[][] getGrid() {
		return grid;
	}

	public int getTotalAliveCells() {
		return totalAliveCells;
	}

	public boolean getCellState(int row, int col) {
		return grid[row][col]; // update this line, provided so that code compiles
	}

	public boolean isAlive() {
		for (int i = 0; i < grid.length; i++) {
			for (int j = 0; j < grid[0].length; j++) {
				if (grid[i][j] == ALIVE) {
					return true;
				}
			}
		}
		return false; // update this line, provided so that code compiles
	}

	/**
	 * Determines the number of alive cells around a given cell. Each cell has 8
	 * neighbor cells which are the cells that are horizontally, vertically, or
	 * diagonally adjacent.
	 */
	public int numOfAliveNeighbors(int row, int col) {
		int count = 0;

		if (row > 0 && grid[row - 1][col] == ALIVE) {
			count++;
		}
		if (row < grid.length - 1 && grid[row + 1][col] == ALIVE) {
			count++;
		}
		if (col > 0 && grid[row][col - 1] == ALIVE) {
			count++;
		}
		if (col < grid[0].length - 1 && grid[row][col + 1] == ALIVE) {
			count++;
		}
		if (row > 0 && col > 0 && grid[row - 1][col - 1] == ALIVE) {
			count++;

		}
		if (row > 0 && col < grid[0].length - 1 && grid[row - 1][col + 1] == ALIVE) {
			count++;
		}
		if (row < grid.length - 1 && col > 0 && grid[row + 1][col - 1] == ALIVE) {
			count++;
		}
		if (row < grid.length - 1 && col < grid[0].length - 1 && grid[row + 1][col + 1] == ALIVE) {
			count++;
		}
		return count; // update this line, provided so that code compiles
	}

	/**
	 * Creates a new grid with the next generation of the current grid using the
	 */
	public boolean[][] computeNewGrid() {
		boolean[][] newGrid = new boolean[grid.length][grid[0].length];

		for (int i = 0; i < grid.length; i++) {
			for (int j = 0; j < grid[0].length; j++) {
				int neighborCount = numOfAliveNeighbors(i, j);

				if (grid[i][j] == ALIVE && neighborCount == 0) {
					newGrid[i][j] = DEAD;
				} else if (grid[i][j] == DEAD && neighborCount == 3) {
					newGrid[i][j] = ALIVE;
				} else if (grid[i][j] == ALIVE && (neighborCount == 2 || neighborCount == 3)) {
					newGrid[i][j] = ALIVE;
				} else if (grid[i][j] == ALIVE && neighborCount >= 4) {
					newGrid[i][j] = DEAD;
				} else {
					newGrid[i][j] = DEAD;
				}
			}
		}

		return newGrid;// update this line, provided so that code compiles
	}

	/**
	 * Updates the current grid (the grid instance variable) with the grid denoting
	 * the next generation of cells computed by computeNewGrid().
	 * 
	 * Updates totalAliveCells instance variable
	 */
	public void nextGeneration() {
		grid = computeNewGrid();
	}

	/**
	 * Updates the current grid with the grid computed after multiple (n)
	 */
	public void nextGeneration(int n) {
		for (int i = 0; i < n; i++) {
			nextGeneration();
		}
	}

	/**
	 * Determines the number of separate cell communities in the grid
	 */
	public int numOfCommunities() {
		WeightedQuickUnionUF wqu = new WeightedQuickUnionUF(grid.length, grid[0].length);
		for (int i = 0; i < grid.length; i++) {
			for (int j = 0; j < grid[0].length; j++) {
				if (grid[i][j] == ALIVE) {
					ArrayList<Integer[]> aliveNeighbors = getAliveNeighbors(i, j);
					for (Integer[] n : aliveNeighbors) {
						wqu.union(i, j, n[0], n[1]);
					}
				}
			}
		}
		Set<Integer> roots = new HashSet<Integer>();
		for (int i = 0; i < grid.length; i++) {
			for (int j = 0; j < grid[0].length; j++) {
				if (grid[i][j] == ALIVE) {
					roots.add(wqu.find(i, j));
				}
			}
		}
		return roots.size();
	}

	private ArrayList<Integer[]> getAliveNeighbors(int row, int col) {
		ArrayList<Integer[]> neighbors = new ArrayList<Integer[]>();
		if (row > 0 && grid[row - 1][col] == ALIVE) {
			neighbors.add(new Integer[] { row - 1, col });
		}
		if (row < grid.length - 1 && grid[row + 1][col] == ALIVE) {
			neighbors.add(new Integer[] { row + 1, col });
		}
		if (col > 0 && grid[row][col - 1] == ALIVE) {
			neighbors.add(new Integer[] { row, col - 1 });
		}
		if (col < grid[0].length - 1 && grid[row][col + 1] == ALIVE) {
			neighbors.add(new Integer[] { row, col + 1 });
		}
		if (row > 0 && col > 0 && grid[row - 1][col - 1] == ALIVE) {
			neighbors.add(new Integer[] { row - 1, col - 1 });
		}
		if (row > 0 && col < grid[0].length - 1 && grid[row - 1][col + 1] == ALIVE) {
			neighbors.add(new Integer[] { row - 1, col + 1 });
		}
		if (row < grid.length - 1 && col > 0 && grid[row + 1][col - 1] == ALIVE) {
			neighbors.add(new Integer[] { row + 1, col - 1 });
		}
		if (row < grid.length - 1 && col < grid[0].length - 1 && grid[row + 1][col + 1] == ALIVE) {
			neighbors.add(new Integer[] { row + 1, col + 1 });
		}
		return neighbors;
	}

}
