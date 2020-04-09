# prep the ubuntu machine

```
sudo apt-get install bison byacc flex wget gfortran make
```

# download the install_BOXMOX bash script

```
cp /mnt/c/Users/pt_gr/Downloads/install_BOXMOX.bash ~/
```

# execute

```
chmod +x install_BOXMOX.bash
./install_BOXMOX.bash
```

# add installed files to PATH

```
export KPP_HOME=/home/$USER/boxmox
export PATH=$KPP_HOME/bin:$KPP_HOME/boxmox/bin:$PATH
```

# prepare a mechanism for use

```
cd boxmox/boxmox/bin/
./prepare_BOXMOX_mechanism MOZART_4
```

# prepare a new model for use

```
./new_BOXMOX_experiment_from_example pbl_diurnal_cycle
cd pbl_diurnal_cycle/
./MOZART_4.exe
```
