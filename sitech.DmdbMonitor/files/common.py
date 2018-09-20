#!/usr/bin/env python
# coding: utf-8
# author: mooker
# date: 201807

class MonitorInfo(object):

    def __init__(self, name, description, label, labelvalue, value):
        self.name = name
        self.description = description
        self.label = label
        self.labelvalue = labelvalue
        self.value = value

    def printInfo(self):
        data = "# HELP %s %s\n# TYPE %s str\n%s{%s=\"%s\"} %s\n"\
               %(self.name, self.description, self.name, self.name, self.label, self.labelvalue, self.value)
        return data
