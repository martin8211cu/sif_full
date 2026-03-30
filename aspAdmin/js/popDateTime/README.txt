==============|=====================================================    

TagName:        <cf_popDateTime> v1.0

Author:		      Josh Trefethen / josh@exciteworks.com 
Created:	      Friday, January 11, 2002
Last updated:	  Monday, January 14, 2002 
Notes:					This custom tag generates a formfield and popup window
                allowing users to pick a date and/or time by clicking 
                on and easy to navigate calendar.  This tag supports
                european and american date formats.
                 
                This custom tag uses javascript developed by Denis Gritcyuk
                of www.softcomplex.com...for more information on the 
                javascript used in this tag, please visit his site.
                
                Please note that the javascript referenced above has
                been modified to be used dynamically in this tag.

Variables:      - Required Fields -
                
                formName   - the name of the form the field belongs to
                
                - All variables below are optional -                      
                
                fieldName  - the name of the form field to assign
                             to the date field generated
                             default is set to "date" 
                fieldValue - initial value of the field generated    
                             default is set to null   
                time       - display time?  
                             default is "no"
                euro       - display in euro format? 
                             default is "no"      
                scriptPath - path to folder containing required 
                             javascripts and images (this path 
                             is relative to the calling script) 
                             default is set to "popDateTime/"   

USAGE:          there is only one required field, but you may need to
                specify more depending on your usage. Simply unzip the
                the files and use the tag as shown in the example below:
                
                <cf_popDateTime formName="myForm"
                                fieldName="myDate"
                                time="no"
                                euro="yes"
                                scriptPath="../../popDateTime/"> 
                                
                Make sure that the popDateTime directory is unzipped 
                onto your webvolume (usually C:\Inetpub\wwwroot in IIS)
                so that the tag can access the images and scripts as
                needed. 
                                                
==============|=====================================================