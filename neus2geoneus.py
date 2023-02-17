import sys, os, trimesh
import numpy as np 
import random

def rescale_pc(pc_path, cameras_path):
    pc = np.array(trimesh.load(pc_path).vertices)
    cameras = np.load(cameras_path)
    scale_camera = cameras['scale_mat_0']
    scaled_sparse_pc = np.linalg.inv(scale_camera) @ np.concatenate([np.array(pc), np.ones([np.array(pc).shape[0], 1])], axis=1).T
    return scaled_sparse_pc.T[:, :3]

def reformat_pair(path):
    pair = open(path).read().split("\n")
    pairs = ""
    for i in range(int(pair[0])):
    #     print(pair[1 + 2*i])
    #     print(pair[2 + 2*i])
        pairs = pairs + "%04d.png " % int(pair[1 + 2*i])
        split_str = pair[2 + 2*i].split(" ")
        for j in range(int(split_str[0])):
            pairs = pairs + "%04d.png " % int(split_str[2*j + 1])
        pairs = pairs + "\n" 
    return pairs

def get_view_ids(pc, num_pts=10000, num_views=100):
    assert pc.shape[1] == 3
    pc_size = pc.shape[0]
    view_id = [np.random.choice(pc_size, size=num_pts, replace=False) for i in range(num_views)]
    return view_id

def neus2geoneus(path):
    pc_path = os.path.join(path, "pc.ply")
    cameras_path = os.path.join(path, "cameras.npz")
    pair_path = os.path.join(path, "pair.txt")
    num_images = len(os.listdir(os.path.join(path, "images")))
    
    normalized_pc = rescale_pc(pc_path, cameras_path)
    normalized_pc_ply = trimesh.Trimesh(vertices=normalized_pc)
    
    pairs = reformat_pair(pair_path)
    view_id = get_view_ids(np.array(trimesh.load(pc_path).vertices), num_views=num_images)
    
    os.makedirs(os.path.join(path, "sfm_pts"), exist_ok=True)
    
    np.save(open(os.path.join(path, "sfm_pts/view_id.npy"), "wb"), np.array(view_id, dtype=np.int32))
    np.save(open(os.path.join(path, "sfm_pts/points.npy"), "wb"), normalized_pc.astype(np.float32))
    
    with open(os.path.join(path, "sfm_pts/points.ply"), "wb") as f:
        f.write(trimesh.exchange.ply.export_ply(normalized_pc_ply))
    
    with open(os.path.join(path, "pairs.txt"), "w") as f:
        f.write(pairs)
        
neus2geoneus(sys.argv[1])