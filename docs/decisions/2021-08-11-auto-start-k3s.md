# Auto-installing iso image for k3s

### Context and Problem Statement

Need to reduce the cost of using k3s by self igniting k3s.

### Describe the feature / enhancement and how it helps to overcome the problem or limitation

Generate an iso that can be used to self-ignite a working V-Sekai cluster system.

### Describe how your proposal will work, with code, pseudo-code, mock-ups, and/or diagrams

#### Plan
Automate this process into a iso.

* Install the OS in the machine hard disk, reboot
* Install the required RPM package for K3S to be installable, reboot
* Install K3S

#### Design for one node

1. Wipe out system.
1. run-k3s-prereq-installer: This service will run a script that installs the package necessary for K3S to be installed.
1. run-k3s-installer: This service will run the K3S install script.

#### Generate k3s iso image

1. Fetch iso
2. Replace ssh key 
3. Design a jsonnet for yaml.
4. You need to take the contents of a ign file named k3s-autoinstall.ign, and place them inside the coreos-autoinstall.fcc file inline inside the storage.files array, in the object with path /home/core/k3s-autoinstall.ign.
5. Create the coreos-autoinstall.ign file from the fcc file created on step 3.
6. Embed the coreos-autoinstall.ign ignition file inside the ISO image.
7. The iso name may vary.

#### Github Actions

Create github actions to upload an artifact


### If this enhancement will not be used often, can it be worked around with a few lines of script?

K3s and operating systems are not a few lines of script.

### Positive Consequences

_No response_

### Negative Consequences

_No response_

### Is there a reason why this should be core and done by us?

Need a system for testing.

### References

* https://www.murillodigital.com/tech_talk/k3s_in_coreos/

### Derivative License

Copyright (c) 2020-2021 V-Sekai contributors.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
