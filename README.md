# Conway's Game of Life — Java

Short Java implementation of Conway's Game of Life with a simple driver/visual layer.

Goals & features
- Run large-scale simulations where simple local rules produce rich, unexpected global patterns.
- Experiment with classic and novel patterns: load and evolve gliders, oscillators, spaceships, and chaotic configurations from text-based grids.
- Interactive visualization and analysis: a compact driver/visual layer lets you step, observe, and probe the dynamics to study long-term behavior.

Quick run
```powershell
cd "c:\<YOURPATH>\GameOfLife\src\conwaygame"
javac *.java
java Driver
```

Project structure
- `src/conwaygame/` — Java sources (Driver, Board, GameOfLife, helpers)
- `bin/` — compiled classes (optional)
- `grid*.txt` — example starting grids

Contributing
- If you make improvements (UI, performance, additional rules), keep code in `src/conwaygame/` and update this README with usage examples.
