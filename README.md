# Base Image Definitions for Veewee

OpenStack image building automation with [veewee](https://github.com/jedi4ever/veewee).

We will be using the kvm plugin for veewee, so you'll need libvirt installed on the build box.

You'll then need to [install rvm and veewee](https://github.com/jedi4ever/veewee/blob/master/doc/installation.md#installing-veewee-with-rvm)

Then run the following commands:
```bash
cd veewee
sed -i 's/kvm/none/' .bundle/config
bundle install
git clone https://github.com/rsoprivatecloud/veewee-definitions definitions
```

Then you can build images with:
```bash
bundle exec veewee kvm build <definition name>
```

Where `<definition name>` corresponds to a directory in definitions/, e.g., centos-6.3-cloud-init

NB: If you are running veewee in a VM without support for nested kvm, you'll have to use the slower qemu emulation with the following:
```bash
bundle exec veewee kvm build --use-emulation <definition name>
```

By default on an Ubuntu system, the images will be output to `/var/lib/libvirt/images/<definition name>.qcow2`

Magical rainbow unicorns of mystery.
