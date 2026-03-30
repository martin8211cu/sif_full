ллллллллллллллллллллллллллллллллл
К                               К
К  version: soEditor Lite 2.5   К
К  released: Dec.02.2002        К
К  Љ 2002 SiteObjects, Inc.     К
К                               К
К  http://www.siteobjects.com/  К
К                               К
ллллллллллллллллллллллллллллллллл


QUICK INSTALLATION NOTES
=-=-=-=-=-=-=-=-=-=-=-=-=
Є Extract this package into the root of your web server or into the root of the 
  web site that you wish to install soEditor in.

Є If you plan to call soEditor as a custom tag then you must copy soeditor_lite.cfm 
  into a custom tag directory.
  (e.g. <cf_soeditor_lite
          field="fieldName"
          form="formName"
          scriptpath="/siteobjects/soeditor/pro/">)
  
Є Alternatively you can call soeditor_lite.cfm via cfmodule
  (e.g. <cfmodule 
          template="/siteobjects/soeditor/lite/soeditor_lite.cfm"
          field="fieldName"
          form="formName"
          scriptpath="/siteobjects/soeditor/lite/">)

Є To test your installation, open IE and access the example applications at:
  http://{www.yoursite.com}/siteobjects/soeditor/lite/examples/index.cfm
          
Є If you extract the package into an alternative directory, you must change the 
  templatepath and scriptpath variables in examples/Application.cfm to point to the 
  new location in order for the examples to work correctly.

Є Apache Users You will need to add the following line to your httpd.conf file "AddType
  text/x-component .htc" without quotes, make sure to restart the Apache daemon. 
  
Є Online help documentation is also available at:
  http://{www.yoursite.com}/siteobjects/soeditor/lite/docs/cf/index.html
=-=-=-=-=-=-=-=-=-=-=-=-=


SUPPORT
=-=-=-=-=-=-=-=-=-=-=-=-=
Є http://www.siteobjects.com/pages/support.cfm
