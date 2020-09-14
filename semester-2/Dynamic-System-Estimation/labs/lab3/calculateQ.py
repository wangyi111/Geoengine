import numpy as np
import scipy.linalg as sl


def calculate_PhiandQ(f, g, w, dt):
    a = np.vstack([np.hstack([-f, g@w@g.transpose()]), np.hstack([np.zeros(f.shape), f.transpose()])]) * dt
    b = sl.expm(a)
    b02 = np.hsplit(b, [f.shape[1], f.shape[1] + f.shape[0]])[1]
    b2 = np.vsplit(b02, [f.shape[0], f.shape[0] + f.shape[1]])
    phi = b2[1].transpose()
    return [phi, phi @ b2[0]]
