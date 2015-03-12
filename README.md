Interesting stuff:

- [Nerten's scripts](https://gist.github.com/Nerten) - I pulled the plex and aria2c installers from here

- [razrichter's calibre upstart script](https://gist.github.com/razrichter/4157867) (unmodified)

- [something with gpio](https://gist.github.com/knutmithut/502342acd38a4ea00061) - I'm not using GPIO, but it looked vaguely interesting.

- [better aria2 daemon script](https://gist.github.com/jereksel/8217470)

- [info on getting plex up](https://gist.github.com/gubi/a555eb646d2f191476bf) - haven't done anything with this, plex is working fine.

- [Installing ROS](https://github.com/ethz-asl/odroid_ros/wiki)

- [Build a minimal Debian for the c1](https://github.com/tomuta/debian-mini-odroid-c1)

- [Scripts for odroid as a server](https://github.com/meveric/odroid-server) - meveric also has some other arm stuff



Mounting Samba shares:

  - Don't want to mount NTFS drive read only
  - Want to serve calibre library 24/7
  - Mount hard drive on router, use samba mount to serve files.

  - //192.168.0.1/volume9   /media/windowsshare     cifs    guest,uid=1000,iocharset=utf8,file_mode=0770,dir_mode=0770,sec=none,sfu,actimeo=30,cache=loose,noacl,noserverino        0       0
    - Probably some of these aren't needed.
    - //192.168.0.1/volume9 - location of the network share
    - /media/windowsshare - location to mount shared folder
    - cifs - filesystem time
    - guest - no passwords (I'm mounting from my router)
    - iocharset - allow utf8 filenames
    - file_mode - allow all users to read/write
    - sec=none - router has NO security
    - sfu 
      - Calibre doesn't doesn't tolerate having the database on a network share. Sucks to be you.
      - Fortunately, sfu lets you place the db locally, and symlink it on the drive
      - Remember to copy the database to the drive when you update it from your computer (you can probably automate this some way)
    - actimeo=30 - metadata cache time. Assume drive is only being used locally. More caching = better here, unless another computer is going to be accessing the files.
    - cache=loose - don't remember, too lazy to look it up
    - noacl - don't apply access control lists
    - don't use server inodes. Massive directories, like those in a large calibre directory, will fail to load fully. Calibre will not be able to detect your entire library. This is a Samba bug.
    - 0 0 - no fsck, no backup crap.
