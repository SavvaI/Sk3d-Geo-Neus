SK3D_DIR=$1
NEUS_DATA_DIR=$2
SCENE=$3

SK3D_SCENE_DIR=$SK3D_DIR/dataset/$SCENE
mkdir $NEUS_DATA_DIR/$SCENE
cp -r $SK3D_SCENE_DIR/tis_right/rgb/undistorted/ambient@best $NEUS_DATA_DIR/$SCENE/image
cp -r $SK3D_SCENE_DIR/tis_right/rgb/undistorted/ambient@best $NEUS_DATA_DIR/$SCENE/mask
cp $SK3D_DIR/addons/dataset/$SCENE/idr_input/cameras.npz $NEUS_DATA_DIR/$SCENE/cameras.npz
cp $SK3D_DIR/addons/dataset/$SCENE/idr_input/cameras.npz $NEUS_DATA_DIR/$SCENE/cameras_sphere.npz
cp $SK3D_DIR/dataset/$SCENE/tis_right/mvsnet_input/pair.txt $NEUS_DATA_DIR/$SCENE/pair.txt
cp $SK3D_DIR/dataset/$SCENE/stl/reconstruction/cleaned.ply $NEUS_DATA_DIR/$SCENE/pc.ply
 
python neus2geoneus.py $NEUS_DATA_DIR/$SCENE/  