# Description

Vault is a small persistent data storage library for [LÖVE](http://love2d.org/). It takes native Lua types, and stores them in a file, ready for retrieval.

Vault is licensed under the zlib/libpng license. See LICENSE.txt for the license itself.

# Usage

This little guide will show you how to use Vault. Before using Vault, you must set your game's identity using <code>[love.filesystem.setIndenity](http://love2d.org/wiki/love.filesystem.setIdentity)</code>.

## Specifying Files

There are two ways to specify a filename for Vault to use. You can set the default file by setting <code>Vault.file</code>, which is set to 'data' by default, or you can pass in the filename as the last argument to all the functions in the <code>Vault</code> module. Here's an example:

    Vault.file = 'foobar' -- the default file
    Vault.save() -- uses 'foobar'
    Vault.save('another-one') -- uses 'another-one'

## Saving Data

You can save data in a number of ways. One is to start setting things for your file using <code>Vault.set</code>. <code>Vault.set</code> takes two arguments (not included the optional filename), a key and a value. Your keys and your values can be any type, except for 'function', 'thread', and 'userdata'. Let's have a look at using <code>Vault.set</code>:

    Vault.set('somekey', 3)
    Vault.set('another', { foo = 3, bar = 4 })
    Vault.set('something', nil)
    Vault.set(3, false)
    
And to save the data:

    Vault.save()
    
An alternative way of calling <code>Vault.set</code> is by using this syntax:

    Vault['somekey'] = 3
    ...
    Vault[3] = false
    
There are two things to note about this. One is that you can't specify a specific file while doing this (you must use <code>Vault.file</code>), and two is that you can't use a key of anything belong to the <code>Vault</code> module. Here's a list of the string keys:

* fileData
* file
* load
* data
* get
* set
* save
* \__index
* \__newindex
* \_getTableString
* \_getString

Another way to save data is to specify the data all in one go, by using a table, which is passed to <code>Vault.save</code>:

    Vault.save({ somekey = 3, another = { foo = 3, bar = 4 }, something = nil, [3] = false })
    
## Loading Data

The easiest way to get all the data is by using <code>Vault.data</code>:

    Vault.data() -- { somekey = 3, ... }
    
Be warned however, this does cache data. If you want to force a reload, you can use <code>Vault.load</code>.

If you just want to get a specific key, you can use <code>Vault.get</code>, like this:

    Vault.get('somekey') -- 3
    Vault.get('another') -- { foo = 3, bar = 4 }
    
If the data hasn't been already loaded, <code>Vault.get</code> will do it automatically.

Similar to <code>Vault.set</code>, an alternate way to call <code>Vault.get</code> is by using this syntax:

    Vault['somekey'] -- 3

Take note that the same limitations apply as with the <code>Vault[key] = v</code> syntax.

## Conclusion

Well that's it. Remember that you can pass a file name at the end of any function to override <code>Vault.file</code>.

Enjoy!