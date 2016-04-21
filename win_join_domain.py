#!/usr/bin/python
# -*- coding: utf-8 -*-

# Copyright 2015, Citrix Systems, Inc <nicolas.landais@citrix.com>
#
# This file is part of Ansible
#
# Ansible is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ansible is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ansible.  If not, see <http://www.gnu.org/licenses/>.

# this is a windows documentation stub.  actual code lives in the .ps1
# file of the same name

DOCUMENTATION = '''
---
module: win_join_domain
version_added: "2.1"
short_description: "Add or remove computer from Active Directory domain"
description:
  - This module will add or remove a computer from an Active Directory Domain using a PoSh cmdlet available with PoSh 5.0+
options:
  name:
    description: Name of the computer to un/join to the domain.
    required: false
    default: localhost ($ENV:COMPUTERNAME)
    aliases: []
  domain:
    description: Name of the AD domain.
    required: true
    default: null
    aliases: []
  user: 
    description: Name of the user account to use to login to the domain.
    required: true
    default: null
    aliases: []
  password:
    description:
      - AD Domain password associated 
    required: true
    default: null
    aliases: []
  reboot:
    description:
      - Indicates whether a reboot is desired after a domain join
      required: false
      default: false  
  state:
    description:
      - Flag to select whether to join or unjoin the AD domain
    required: false
    choices:
      - present
      - absent
    default: present
    aliases: []
author: "Nicolas Landais (@nlandais)"
'''

EXAMPLES = '''
  # Add machine to the domain
  win_join_domain:
    domain: "domain.local"
    user: "domain\user"
    password: "qwert123#"
    reboot: true

  # Remove machine from the domain
  win_join_domain:
    domain: "domain.local"
    user: "domain\\user"
    password: "qwert123#"
    state: absent
'''


