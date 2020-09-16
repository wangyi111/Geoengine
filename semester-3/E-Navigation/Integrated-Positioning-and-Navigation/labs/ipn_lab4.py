import numpy as np
import math
import matplotlib.pyplot as plt
from scipy import linalg

## Task2  ###############################################
print('** Task2 ***************')

def v_blh2ecef(lat,lon,h,vn,ve,vd):
    a=6378137
    e2=6.69437999014e-3
    M=a*(1-e2)/(1-e2*math.sin(lat)*math.sin(lat))**(1.5)
    N=a/(1-e2*math.sin(lat)*math.sin(lat))**(0.5)

    dlat=vn/(M+h)
    dlon=ve/((N+h)*math.cos(lat))
    dh=-vd

    dx1=-dlat*(M+h)*math.sin(lat)*math.cos(lon)-dlon*(N+h)*math.cos(lat)*math.sin(lon)+dh*math.cos(lat)*math.cos(lon)
    dx2=-dlat*(M+h)*math.sin(lat)*math.sin(lon)+dlon*(N+h)*math.cos(lat)*math.cos(lon)+dh*math.cos(lat)*math.sin(lon)
    dx3=dlat*(M+h)*math.cos(lat)+dh*math.sin(lat)

    return np.array([[dx1],[dx2],[dx3]])

def coriolis(ve):
    wE=2*math.pi/86400
    Omega=np.array([[0,-wE,0],[wE,0,0],[0,0,0]])
    return 2*Omega@ve
    




vn=1100/3.6

lat1=0
v1=v_blh2ecef(lat1,0,9200,vn,0,0)

a1=coriolis(v1)

lat2=39/180*math.pi
v2=v_blh2ecef(lat2,0,9200,vn,0,0)
a2=coriolis(v2)


print(a1,a2)


## Task3 ###################################
print('** Task3 ***************')

def dcm2quat(C):
    q0=1/2*(C[0,0]+C[1,1]+C[2,2]+1)**(0.5)
    #print(q0.shape)
    q1=(C[1,2]-C[2,1])/(4*q0)
    #print(q1.shape)
    q2=(C[2,0]-C[0,2])/(4*q0)
    q3=(C[0,1]-C[1,0])/(4*q0)
    return np.transpose(np.array([q0,q1,q2,q3]))


def dcm2euler(C):
    alfa=math.atan(C[1,2]/C[2,2])
    beta=math.asin(-C[0,2])
    gama=math.atan(C[0,1]/C[0,0])

    return np.array([alfa,beta,gama])

def quat2dcm(q):
    q0=q[0]
    q1=q[1]
    q2=q[2]
    q3=q[3]
    C=np.array([[q0**2+q1**2-q2**2-q3**2,2*(q1*q2+q3*q0)        ,2*(q1*q3-q2*q0)         ],
                [2*(q1*q2-q3*q0)        ,q0**2-q1**2+q2**2-q3**2,2*(q2*q3+q1*q0)         ],
                [2*(q1*q3+q2*q0)        ,2*(q2*q3-q1*q0)        ,q0**2-q1**2-q2**2+q3**2 ]])

    return C


# dcm from p to e
Cpe=np.array([[-0.90680,0.41785,-0.05585],[-0.34785,-0.66680,0.65908],[0.23815,0.61708,0.75000]])
# derivative of quaternions

wip=np.array([0.08,0.02,-0.02])
wie=np.array([0.05,0.02,0.01])

omega_m=np.array([[0,             wip[0]-wie[0],wip[1]-wie[1],wip[2]-wie[2]],
                   [-wip[0]+wie[0],0            ,wip[2]-wie[2],-wip[1]+wie[1]],
                   [-wip[1]+wie[1],-wip[2]+wie[2],0           ,wip[0]-wie[0]],
                   [-wip[2]+wie[2],wip[1]-wie[1],-wip[0]+wie[0],0          ]])

q=dcm2quat(Cpe)
euler=np.zeros((3,200))
q_s=np.zeros((4,200))

dt=1
Phi=linalg.expm(1/2*omega_m*dt)
for i in range(200):
    
    #dq=1/2*omega_m@q
    #q=dq+q              
    
    q=Phi@q

    C=quat2dcm(q)                 
    euler_i=dcm2euler(C)        
    euler[:,i]=np.transpose(euler_i)
    q_s[:,i]=q 

plt.figure(1)
plt.subplot(2,1,1)
t=range(200)+np.ones(200)
plt.plot(t,euler[0,:],label='alfa')
plt.plot(t,euler[1,:],label='beta')
plt.plot(t,euler[2,:],label='gama')
plt.legend()
#plt.show()

#plt.figure(2)
plt.subplot(2,1,2)
plt.plot(t,q_s[0,:],label='q0')
plt.plot(t,q_s[1,:],label='q1')
plt.plot(t,q_s[2,:],label='q2')
plt.plot(t,q_s[3,:],label='q3')
plt.legend()
plt.show()



    






