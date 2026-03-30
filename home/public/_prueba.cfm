<cfset request.tdata =  createobject("component","commons.Componentes.TraduccionData")>
<cf_dump vaR="#request.tdata.getTablas(javaCast("null", ""),'minisif')#"/>