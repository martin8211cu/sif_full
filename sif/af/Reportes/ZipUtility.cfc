<!--- --------------------------------------------------------------------------------------- ----
	
	Blog Entry:
	ColdFusion ZipUtility Component Can Now Write Directly To An Output Stream
	
	Code Snippet:
	2
	
	Author:
	Ben Nadel / Kinky Solutions
	
	Link:
	http://www.bennadel.com/index.cfm?event=blog.view&id=735
	
	Date Posted:
	May 29, 2007 at 9:43 PM
	
---- --------------------------------------------------------------------------------------- --->
    
    
    <cfcomponent
    output="false"
    hint="Handles the zipping of files.">
     
    <!---
    Set up an instance struct to hold instance-
    specific data values.
    --->
    <cfset VARIABLES.Instance = StructNew() />
     
    <!---
    This will hold the array of all target files to
    be included in the resultant zip file.
    --->
    <cfset VARIABLES.Instance.FileEntries = ArrayNew( 1 ) />
     
    <!---
    This will hold an array of byte structures. Each
    array entry will hold a byte array and a name
    of the designated file.
    --->
    <cfset VARIABLES.Instance.ByteEntries = ArrayNew( 1 ) />
     
     
    <cffunction
    name="Init"
    access="public"
    returntype="any"
    output="false"
    hint="Returns an initialized component instance.">
     
    <!--- Return This reference. --->
    <cfreturn THIS />
    </cffunction>
     
     
    <cffunction
    name="AddByteEntry"
    access="public"
    returntype="void"
    output="false"
    hint="Adds a byte array entry with the given name to the zip file ">
     
    <!--- Define arguments. --->
    <cfargument
    name="ByteArray"
    type="any"
    required="true"
    hint="The byte array data entry."
    />
     
    <cfargument
    name="Name"
    type="string"
    required="true"
    hint="The name of the file used to store the byte array."
    />
     
     
    <!---
    Store the arguments directly into the byte entries.
    As long as it can be referenced like a struct AND
    it already exists, no need to create a new struct.
    --->
    <cfset ArrayAppend(
    VARIABLES.Instance.ByteEntries,
    ARGUMENTS
    ) />
     
    <!--- Return out. --->
    <cfreturn />
    </cffunction>
     
     
    <cffunction
    name="AddFileEntry"
    access="public"
    returntype="void"
    output="false"
    hint="Adds one or more file paths to the resultan zip file.">
     
    <!--- Define arguments. --->
    <cfargument
    name="File"
    type="any"
    required="true"
    hint="File to be added. This can be a file or an array of files."
    />
     
     
    <!--- Define the local scope. --->
    <cfset var LOCAL = StructNew() />
     
    <!---
    For this method, we are going to allow the
    flexability of adding multiple files at once. The
    first argument can be a file path or an array of
    file paths. If the first argument is a string, then
    we will assume the entire arguments array might be
    more than one file.
    --->
    <cfif IsSimpleValue( ARGUMENTS.File )>
     
    <!---
    Since the first argument is a string, let's
    assume the person may have passed in more than
    one argument where each argument is a file path
    to be added.
    --->
    <cfloop
    item="LOCAL.File"
    collection="#ARGUMENTS#">
     
    <cfset ArrayAppend(
    VARIABLES.Instance.FileEntries,
    ARGUMENTS[ LOCAL.File ]
    ) />
     
    </cfloop>
     
    <cfelse>
     
    <!---
    Since the first argument is NOT a string, we
    are going to assume that it is an array of
    file paths. Therefore, add the entire array
    to the files list.
    --->
    <cfset VARIABLES.Instance.FileEntries.AddAll(
    ARGUMENTS.File
    ) />
     
    </cfif>
     
     
    <!--- Return out. --->
    <cfreturn />
    </cffunction>
     
     
    <cffunction
    name="AddTextEntry"
    access="public"
    returntype="void"
    output="false"
    hint="Adds a text entry with the given name to the zip file ">
     
    <!--- Define arguments. --->
    <cfargument
    name="Text"
    type="string"
    required="true"
    hint="The text data entry."
    />
     
    <cfargument
    name="Name"
    type="string"
    required="true"
    hint="The name of the file used to store the byte array."
    />
     
     
    <!---
    Grab the byte array from the text data entry
    and just hand it off to the byte entry.
    --->
    <cfset THIS.AddByteEntry(
    ByteArray = ARGUMENTS.Text.GetBytes(),
    Name = ARGUMENTS.Name
    ) />
     
    <!--- Return out. --->
    <cfreturn />
    </cffunction>
     
     
    <cffunction
    name="Compress"
    access="public"
    returntype="void"
    output="false"
    hint="Compresses the files and entries into the given file archive.">
     
    <!--- Define arguments. --->
    <cfargument
    name="File"
    type="any"
    required="true"
    hint="The file path of the destination archive file OR a output stream object."
    />
     
     
    <!--- Define the local scope. --->
    <cfset var LOCAL = StructNew() />
     
     
    <!---
    Create the zip output stream. This will wrap
    around an output stream that writes to our
    destination archive file. If, however, the user
    has passed in an output stream object, then
    we will write directly to the output stream.
     
    Check to see if the file is a string (file name),
    or if it is a complex object.
    --->
    <cfif IsSimpleValue( ARGUMENTS.File )>
     
    <!---
    Create the output stream to be a file output
    stream pointing at the given file name.
    --->
    <cfset LOCAL.OutputStream = CreateObject(
    "java",
    "java.io.FileOutputStream"
    ).Init(
     
    <!---
    Initialized the file IO object
    with the given file path of the
    target ZIP file.
    --->
    ARGUMENTS.File
     
    ) />
     
    <cfelse>
     
    <!---
    An output stream of some sort was passed into
    the compression method. Therefore, instead of
    creating a file output stream, will just use
    the passed in output stream.
    --->
    <cfset LOCAL.OutputStream = ARGUMENTS.File />
     
    </cfif>
     
     
    <!---
    ASSERT: At this point, we have either created an
    output stream using a target file or we have used
    the passed in output stream. Either way, we now
    have a (potentially) valid output stream around
    which we can wrap out Zip Output Stream.
    --->
     
     
    <!---
    Create the zip outpu stream and wrap it around
    our target output stream.
    --->
    <cfset LOCAL.ZipOutputStream = CreateObject(
    "java",
    "java.util.zip.ZipOutputStream"
    ).Init(
     
    <!--- Wrap Zip IO around output stream. --->
    LOCAL.OutputStream
     
    ) />
     
     
    <!---
    Create a buffer into which we will read file data
    and from which the Zip output stream will read its
    data. The easiest way to create a byte array buffer
    is just to build a large string and return it's
    byte array.
    --->
    <cfset LOCAL.Buffer = RepeatString( " ", 1024 ).GetBytes() />
     
     
    <!---
    We need to add both the file entries and the byte
    array entries. Let's start out with the files.
    --->
    <cfloop
    index="LOCAL.Index"
    from="1"
    to="#ArrayLen( VARIABLES.Instance.FileEntries )#"
    step="1">
     
    <!---
    Get a short hand to the file path that we are
    working with.
    --->
    <cfset LOCAL.FilePath = VARIABLES.Instance.FileEntries[ LOCAL.Index ] />
     
    <!---
    Create a new zip entry for this file. To
    keep things simple, we are going to store
    all the files by their file name alone (no
    nesting of directories).
    --->
    <cfset LOCAL.ZipEntry = CreateObject(
    "java",
    "java.util.zip.ZipEntry"
    ).Init(
    GetFileFromPath( LOCAL.FilePath )
    ) />
     
     
    <!---
    Tell the Zip output that we are going to start
    a new zip entry. This will close all previous
    entries and move the output to point to the new
    entry point.
    --->
    <cfset LOCAL.ZipOutputStream.PutNextEntry(
    LOCAL.ZipEntry
    ) />
     
     
    <!---
    Now that we have zip entry read to go, let's
    create a file input stream object that we can
    use to read the file data into a buffer.
    --->
    <cfset LOCAL.FileInputStream = CreateObject(
    "java",
    "java.io.FileInputStream"
    ).Init(
    LOCAL.FilePath
    ) />
     
    <!---
    Read from the file into the byte buffer. This
    will read as much as possible into the buffer
    and return the number of bytes that were read.
    --->
    <cfset LOCAL.BufferSize = LOCAL.FileInputStream.Read(
    LOCAL.Buffer
    ) />
     
     
    <!---
    Now, we want to keep writing the buffer data
    to the zip output stream until the file read
    returns a length less than 1 indicating that
    no data was read into the buffer.
    --->
    <cfloop condition="(LOCAL.BufferSize GT 0)">
     
    <!---
    Write the contents of the buffer to the
    zip output steam.
    --->
    <cfset LOCAL.ZipOutputStream.Write(
    LOCAL.Buffer,
    JavaCast( "int", 0 ),
    JavaCast( "int", LOCAL.BufferSize )
    ) />
     
    <!---
    Perform the next read of the file data
    into the buffer.
    --->
    <cfset LOCAL.BufferSize = LOCAL.FileInputStream.Read(
    LOCAL.Buffer
    ) />
     
    </cfloop>
     
     
    <!---
    Now that we have finished writing this file to
    the zip output as the given zip entry, we
    need to close both the zip entry and the file
    output stream. This will prevent the system from
    locking the resources.
    --->
    <cfset LOCAL.ZipOutputStream.CloseEntry() />
    <cfset LOCAL.FileInputStream.Close() />
     
    </cfloop>
     
     
    <!---
    Now that all the files have been added, we need
    to add the byte array entries.
    --->
    <cfloop
    index="LOCAL.Index"
    from="1"
    to="#ArrayLen( VARIABLES.Instance.ByteEntries )#"
    step="1">
     
    <!---
    Get a short hand to the byte entry that we are
    working with. This will contain both the byte
    array and the name of the resultant file.
    --->
    <cfset LOCAL.ByteEntry = VARIABLES.Instance.ByteEntries[ LOCAL.Index ] />
     
    <!---
    Create a new zip entry for this file. This entry
    will be stored in the top level directory at the
    given name.
    --->
    <cfset LOCAL.ZipEntry = CreateObject(
    "java",
    "java.util.zip.ZipEntry"
    ).Init(
    LOCAL.ByteEntry.Name
    ) />
     
     
    <!---
    Tell the Zip output that we are going to start
    a new zip entry. This will close all previous
    entries and move the output to point to the new
    entry point.
    --->
    <cfset LOCAL.ZipOutputStream.PutNextEntry(
    LOCAL.ZipEntry
    ) />
     
     
    <!---
    Write the contents of the byte array to the zip
    output steam. Since we have our entire byte
    array entry in memory, we don't have to deal
    with repeated reads.
    --->
    <cfset LOCAL.ZipOutputStream.Write(
    LOCAL.ByteEntry.ByteArray,
    JavaCast( "int", 0 ),
    JavaCast( "int", ArrayLen( LOCAL.ByteEntry.ByteArray ) )
    ) />
     
     
    <!---
    Now that we have finished writing this byte
    entry to the zip output as the given zip entry,
    we need to close the zip entry.
    --->
    <cfset LOCAL.ZipOutputStream.CloseEntry() />
     
    </cfloop>
     
     
    <!---
    We have now written all of our file and byte
    entries to the zip archive file. Close the zip
    output stream so that it can be used.
    --->
    <cfset LOCAL.ZipOutputStream.Close() />
     
     
    <!--- Return out. --->
    <cfreturn />
    </cffunction>
     
    </cfcomponent>