
# Changelog

### 9/15/2021
**Huge metroidvania update!**
Reworked the import system to now import every level as its own scene and creating a main scene with logic for loading and unloading levels.

Check the how to use for more information!

### 8/19/2021
- Added ability to automatically create light occluder to tiles in Godot by attaching custom data to the tile in LDtk.

Check the **Creating Light Occluders** section in this document for more information. 

### 5/29/2021
- Added option to import entities layer as YSort

### 3/15/2021
- Added option to import custom entities
- Added option to import metadata
- Added option to import collisions

### 1/4/2021:
- Updated for new version of LDtk.
- Changed import style: instead of making a new scene you can just open the ldtk file.

### 11/24/2020:
- removed import files.

### 11/22/2020:
- The Importer is now an addon/plugin.
- Added basic import options for Entities.

### 11/13/2020:
- Added basic functionality for autolayers and intgrid layers.

Can now create tilemaps from autolayers and intgrid layers with tilesets.  Intgrid layers without tilesets are ignored currently.

### 11/12/2020:
- Currently this script has very basic functionality.  Only Tile Layers are currently working.
