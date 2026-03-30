<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

<cfquery name="rsUser" datasource="#session.dsn#">
	Select  Usucodigo from Usuario
	where Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.USUARIO)#">
</cfquery>
<cfif rsUser.recordcount gt 0>
	<cfset USUARIO = rsUser.Usucodigo>
<cfelse>
	<cfset USUARIO = -1>
</cfif>

<cf_dbfunction name="to_char" args="MesIni"         returnvariable="LvarMesIni"        delimiters="~">
<cf_dbfunction name="to_char" args="MesFin"         returnvariable="LvarMesFin"        delimiters="~">
<cf_dbfunction name="to_char" args="HoraEjecuta"    returnvariable="LvarHoraEjecuta"   delimiters="~">
<cf_dbfunction name="to_char" args="MinEjecuta"     returnvariable="LvarMinEjecuta"    delimiters="~">
<cf_dbfunction name="to_char" args="HoraEjecuta-12" returnvariable="LvarHoraEjecuta12" delimiters="~">

<cf_dbfunction name="string_part" args="#LvarMesIni#;1;1"        returnvariable="LvarMesIniSP"        delimiters=";">
<cf_dbfunction name="string_part" args="#LvarMesFin#;1;1"        returnvariable="LvarMesFinSP"        delimiters=";">
<cf_dbfunction name="string_part" args="#LvarHoraEjecuta#;1;1"   returnvariable="LvarHoraEjecutaSP"   delimiters=";">
<cf_dbfunction name="string_part" args="#LvarMinEjecuta#;1;1"    returnvariable="LvarMinEjecutaSP"    delimiters=";">
<cf_dbfunction name="string_part" args="#LvarHoraEjecuta12#;1;1" returnvariable="LvarHoraEjecuta12SP" delimiters=";">

<cf_dbfunction name="length" args="#LvarMesIniSP#" 		  returnvariable="LenLvarMesIniSP" 	      delimiters=".">
<cf_dbfunction name="length" args="#LvarMesFinSP#" 	 	  returnvariable="LenLvarMesFinSP" 	      delimiters=".">
<cf_dbfunction name="length" args="#LvarHoraEjecutaSP#"   returnvariable="LenLvarHoraEjecutaSP"   delimiters=".">
<cf_dbfunction name="length" args="#LvarMinEjecutaSP#"    returnvariable="LenLvarMinEjecutaSP"    delimiters=".">
<cf_dbfunction name="length" args="#LvarHoraEjecuta12SP#" returnvariable="LenLvarHoraEjecuta12SP" delimiters=".">

<cf_dbfunction name="string_repeat" args="'0'?(2 - #LenLvarMesIniSP#)"          returnvariable="LvarMesIniRep" 		  delimiters="?">
<cf_dbfunction name="string_repeat" args="'0'?(2 - #LenLvarMesFinSP#)" 	    	returnvariable="LvarMesFinRep" 		  delimiters="?">
<cf_dbfunction name="string_repeat" args="'0'?(2 - #LenLvarHoraEjecutaSP#)" 	returnvariable="LvarHoraEjecutaRep"   delimiters="?">
<cf_dbfunction name="string_repeat" args="'0'?(2 - #LenLvarMinEjecutaSP#)"      returnvariable="LvarMinEjecutaRep"    delimiters="?" >
<cf_dbfunction name="string_repeat" args="'0'?(2 - #LenLvarHoraEjecuta12SP#)"   returnvariable="LvarHoraEjecuta12Rep" delimiters="?" >            
        
<cfquery datasource="#session.dsn#"  name="sql">	
	select  
        IDArchivo,
        NombreArchivo,
        case 
            when Status = 'E' then 'En proceso'  
            when Status = 'P' then 'Pendiente' 
            when Status = 'L' then 'Listo' 
            when Status = 'B' then 'Bajado'  
         end as status,
        <cf_dbfunction name='to_sdatedmy' args='FechaSolic'> as FechaSolic,
        case 
            when TpoRep = 1 then 'Una Cuenta' 
            when TpoRep = 2 then 'Rango'  
            when TpoRep = 3 then 'Lista'  
            else 'Error'  
         end as origenDES,
         TpoRep,
        case 
            when TpoImpresion = 1 then 'Saldos acumulados'  
            when TpoImpresion = 2 then 'Saldos del periodo' 
            when TpoImpresion = 3 then 'Movimientos del mes' 
            when TpoImpresion = 4 then 'Movimientos asiento del mes'  
            when TpoImpresion = 5 then 'Movimientos asiento consecutivo del mes' 
         end as TpoImpresion,
        Periodo,
			#preservesinglequotes(LvarMesIniRep)# #_Cat# 
			 #preservesinglequotes(LvarMesIni)# #_Cat# '-' #_Cat# 
			  #preservesinglequotes(LvarMesFinRep)# #_Cat# 
			   #preservesinglequotes(LvarMesFin)# as meses,
		(case 
			when HoraEjecuta < 12  then 
                #preservesinglequotes(LvarHoraEjecutaRep)# #_Cat# 
				 #preservesinglequotes(LvarHoraEjecuta)# #_Cat# ':'#_Cat# 
				  #preservesinglequotes(LvarMinEjecutaRep)# #_Cat# 
				   #preservesinglequotes(LvarMinEjecuta)# #_Cat#' AM'
			 else 
                #preservesinglequotes(LvarHoraEjecuta12Rep)# #_Cat# 
				 #preservesinglequotes(LvarHoraEjecuta12)# #_Cat# ':' #_Cat# 
				  #preservesinglequotes(LvarMinEjecutaRep)# #_Cat# 
				   #preservesinglequotes(LvarMinEjecuta)# #_Cat#' PM'
		end) as Hora,
        ListaCuenta
    from  tbl_archivoscf
    where Usuario = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#USUARIO#">
     and  Status  = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(url.status)#"> 
    order by IDArchivo  desc
</cfquery>
<cfoutput>
<iframe id="FRAMECJNEGRA" name="FRAMECJNEGRA" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" src="" style="visibility:hidden"></iframe>

	<table width="100%" border="0">
		<tr>
			<td  align="center"></td>
			<td  bgcolor="##CCCCCC" colspan="2" align="center"><strong>Solicitud</strong></td>
			<td  bgcolor="##CCCCCC" colspan="6" align="center"><strong>Parámetros</strong></td>

		</tr>	
		<tr>
			<td  align="center"></td>
			<td  bgcolor="##CCCCCC" align="center"><strong>Fecha</strong></td>
			<td  bgcolor="##CCCCCC" align="center"><strong>hora</strong></td>
			<td  bgcolor="##CCCCCC" align="center"><strong>Tipo</strong></td>
			<td  bgcolor="##CCCCCC" align="center"><strong>Origen</strong></td>
			<td  bgcolor="##CCCCCC" align="center"><strong>Periodo</strong></td>
			<td  bgcolor="##CCCCCC" align="center"><strong>Meses</strong></td>
			<td  bgcolor="##CCCCCC" align="center"><strong>Cuentas</strong></td>

		</tr>
	<cfset tempfile_TXT = "#GetTempDirectory()#">
	<cfif sql.recordcount gt 0>
		<cfset yourFile = sql.NombreArchivo>
		<cfloop query="sql">
		<tr>
			<cfset yourFile = tempfile_TXT&sql.NombreArchivo&".txt">
			<cfif FileExists(yourFile)>
				<td  width="1%" align="center"> <img src="/cfmx/sif/imagenes/Cfinclude.gif" onClick="BJ_ARCH('#sql.NombreArchivo#','#sql.idarchivo#')"></td>
			<cfelse>
				<td width="1%" align="center"> <img src="/cfmx/sif/imagenes/RepeatedRegion.gif" width="22" height="29" ></td>
			</cfif>
				<td  align="center">#sql.FechaSolic#</td>
				<td  align="center">#sql.Hora#</td>
				<td  align="center">#sql.TpoImpresion#</td>
				<td  align="left">#sql.origenDES#</td>
				<td  align="center">#sql.periodo#</td>
				<td  align="center">#sql.meses#</td>
				<cfset CUENTAS = "">
				<cfset LISTACUENTAS = ListToarray(sql.ListaCuenta)>
				<cfset cantCuentas = ArrayLen(LISTACUENTAS)>
				<cfloop index="i" from="1" to="#cantCuentas#">
					<cfset arreglo = listtoarray(LISTACUENTAS[i],"|")>	
					<cfset CUENTAS = CUENTAS  & arreglo[1]>
					<cfif i neq cantCuentas>
						<cfset CUENTAS = CUENTAS  & ','>
					</cfif>
				</cfloop>

				<td  align="left">#CUENTAS#</td>		
						
			</tr>
		</cfloop>
	</cfif>
	</table>
</cfoutput>

<script language="javascript" type="text/javascript">
	window.setInterval("location.reload()",15000);
	function BJ_ARCH(archivo,llave) {
		var PARAMS = "?ARCHIVO="+archivo+"&LLAVE="+llave;
		var frame = document.getElementById("FRAMECJNEGRA");
		frame.src = "cg_bajarArchivo.cfm"+PARAMS;
		window.setInterval("location.reload()",2000);
	}
</script>