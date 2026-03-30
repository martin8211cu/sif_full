<cfinclude template="DepositosElectronicos-rep.cfm">

<cfset hilera =''>
<cfset linea = 1>
                         
<cfif isdefined('rsReporte') and rsReporte.RecordCount GT 0>
	<cfloop query="rsReporte">
    	<cfif linea GT 1>
			<cfset hilera = hilera & '#chr(13)##chr(10)#'>
		</cfif>                            
        <cfset hilera = hilera & '#ID#'& RepeatString("0",10-len(trim(ID)))>
        <cfset hilera = hilera & '#nombreTxt#' & RepeatString("0",32-len(trim(nombreTxt)))>
       	<cfset hilera = hilera & '#CuentaTxt#' & RepeatString(" ",12-len(trim(CuentaTxt)))>
        <cfset hilera = hilera & '#LSNumberFormat(SELiquido,'none')#' & RepeatString(" ",21-len(trim(LSNumberFormat(SELiquido,'none'))))>
        <cfset hilera = hilera & '#Descripcion#' & RepeatString(" ",25-len(trim(Descripcion)))>
                                 
        <!----Reemplazar caracteres no validos----->
		<cfset hilera = REReplaceNoCase(hilera,'Á','A',"all")>
		<cfset hilera = REReplaceNoCase(hilera,'É','E',"all")>
		<cfset hilera = REReplaceNoCase(hilera,'Í','I',"all")>
		<cfset hilera = REReplaceNoCase(hilera,'Ó','O',"all")>
		<cfset hilera = REReplaceNoCase(hilera,'Ú','U',"all")>
		<cfset hilera = REReplaceNoCase(hilera,'Ñ','N',"all")>
		<cfset hilera = REReplaceNoCase(hilera,'Ü','U',"all")>
		<cfset hilera = Ucase(hilera)>
        <cfset linea=linea+1>
    </cfloop>
    <cfset linea = linea-1>
                            
 <cfset archivo = "#year(now())##month(now())##day(now())# #hour(now())##minute(now())##second(now())#">
 <cfset txtfile = GetTempFile(getTempDirectory(), 'Depositos')>	
 <cffile action="write" nameconflict="overwrite" file="#txtfile#" output ="#hilera#" charset="utf-8">
 <cfheader name="Content-Disposition" value="attachment;filename=Depositos#archivo#.txt">
 <cfcontent file="#txtfile#" type="text/plain" deletefile="yes">
</cfif>

<!---<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#resultado#" charset="utf-8">
		<cfheader name="Content-Disposition" value="attachment;filename=DepositosElectronicos.txt">
		<cfcontent file="#txtfile#" type="text/plain" deletefile="yes">--->