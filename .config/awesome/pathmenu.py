#!/usr/bin/env python
import os

path = '/home/isis/'
filetosave = open('/home/isis/.config/awesome/myplacesmenu.lua', 'w')

def test_file_type(file_end):
        if file_end == 'iso':
               return 'wodim'
        elif file_end == 'txt':
               return 'emacs -nw'
        elif file_end == 'bak':
               return 'emacs -nw'
        elif file_end == "backup":
               return 'emacs -nw'
        elif file_end == "gz" or file_end == "xz" or file_end == "zip" or file_end == "z":
               return 'mc'
        elif file_end == "mp3" or file_end == "flac" or file_end == "wav" or file_end == "wma":
               return 'mocp'
        elif file_end == 'mp4' or file_end == 'mpeg' or file_end == 'webm' or file_end == 'avi' or file_end == 'ogg' or file_end == 'ogv' or file_end == 'mkv':
               return 'mocp'
        elif file_end == 'xml' or file_end == 'html' or file_end == 'htm' or file_end == 'xhtml':
               return 'firefox'
        elif file_end == 'py' or file_end == 'cpp' or file_end == 'c' or file_end == 'sh':
               return 'emacs -nw'
        elif file_end == 'out' or file_end == 'class' or file_end == 'pyo':
               return 'urxvt -c'
        elif file_end == 'jpg' or file_end == 'png' or file_end == 'gif':
               return 'feh'
        else: return 'emacs -nw'
        
        

def recursion(path, count):
        likels = os.listdir(path)
        newstuff = 'myplacesmenu[%d] = {\n' % (count)
        output = ''
        count = count * 100
        othercount = count
        type_of_file = ''
        depth_into_string = 0
        for directories in likels:
                if os.path.isdir(path + directories) and not (directories[0] == '.'):
                        newstuff = newstuff + '{[====[' + directories[:12] + ']====], myplacesmenu[%d]},\n' % (count)
                        count = count + 1
                elif not (directories[0] == '.'):
                        depth_into_string = 0
                        type_of_file = ''
                        for character in reversed(directories):
                               if character == '.':
                                     type_of_file = directories[-depth_into_string:]
                                     break
                               elif depth_into_string >= 6:
                                     break
                               depth_into_string = depth_into_string + 1
                        newstuff = newstuff + '{[====[' + directories[:12] + ']====], [====[' + test_file_type(type_of_file) + " '" + path + directories + "']====] },\n"
        newstuff = newstuff + "{'open here', " "'mc ' .. [====['" + path  + "']====]}\n }\n\n"
        

#recursive call to search directories inside current path
        count = othercount
        for directories in likels:
                if os.path.isdir(path + directories) and not (directories[0] == '.'):
                        newstuff = recursion(path + directories + '/', count) + newstuff
                        count = count + 1
        return newstuff
#call to run program 
#also specifies starting directory
                  
filetosave.write('module("myplacesmenu")\n\nmyplacesmenu = {}\n' + recursion(path, 1) + '\npassed = myplacesmenu[1]\nfunction myplacesmenu() return passed end')
