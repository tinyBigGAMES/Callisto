--[[---------------------------------------------------------------------------
    _      _   _
   (_) ___| |_| |   _   _  __ _ ™
   | |/ _ \ __| |  | | | |/ _` |
   | |  __/ |_| |__| |_| | (_| |
  _/ |\___|\__|_____\__,_|\__,_|
 |__/
  A best-in-class Lua scripting
       solution for Delphi

 Copyright © 2024-present tinyBigGAMES™ LLC
 All Rights Reserved.
-----------------------------------------------------------------------------]]

local mymath =  {}

function mymath.add(a,b)
   print(a+b)
end

function mymath.sub(a,b)
   print(a-b)
end

function mymath.mul(a,b)
   print(a*b)
end

function mymath.div(a,b)
   print(a/b)
end                    

function mymath.test()
  print('test')
end

function mymath.test2()
  print('test2')     
end

return mymath    