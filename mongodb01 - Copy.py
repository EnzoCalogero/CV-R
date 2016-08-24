# -*- coding: utf-8 -*-
"""
Created on Thu Jan 07 22:01:10 2016

@author: enzo7311
"""
from bottle import route, run, template

@route('/hello/<name>')
def index(name):
    return template('<b>Hello {{name}}</b>!', name=name)

run(host='localhost', port=8080)