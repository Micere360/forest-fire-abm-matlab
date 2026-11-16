# forest-fire-abm-matlab
MATLAB agent-based simulation of forest fire spread with wind effects and live visualization.
# Forest Fire Spread: Agent-Based Model (MATLAB)

An agent-based model where each tree is an autonomous agent with a position,
a flammability factor and a state (Healthy, Burning, Burnt). The simulation
includes wind speed and direction to study asymmetric fire spread, peak burning
metrics and forest conservation strategies.

## Team
- Addah: Agent & Grid Architect (TreeAgent, grid initialisation, ignition)
- Aluel: Dynamics & Wind Engineer
- Ilhan: Visualization & Data Specialist
- Mirriam: Validation & Report Lead

## Files
- `TreeAgent.m`: tree agent class
- `initForest.m`: creates the forest grid
- `igniteFire.m`: sets the initial fire sources
- `ForestFireABM.m`: main simulation script

## Course
MTH 1060 Capstone Project 2, Department of Data Science & Analytics, USIU-Africa.
