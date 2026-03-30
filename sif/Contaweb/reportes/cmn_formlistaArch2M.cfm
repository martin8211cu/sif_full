
<cfquery datasource="#session.Conta.dsn#"  name="sql" >	
	select  idarchivo,nombrearc,
	(case when status = 'E'  then 'En proceso'  when status= 'P' then 'Pendiente' when status= 'L' then 'Listo' when status= 'B' then 'Bajado'  end) status,
	convert(varchar(10), fechasolic,103) fechasolic,
	(case when origen = 'R'  then 'Rango'  when origen= 'L' then 'Lista'  else 'Error'  end) origenDES,origen,
	(case when tpoarch = 1  then 'Saldos acumulados'  when tpoarch= 2 then 'Saldos del periodo' when tpoarch= 3  then 'Movimientos del mes' when tpoarch= 4  then 'Movimientos asiento del mes'  when tpoarch= 5  then 'Movimientos asiento consecutivo del mes' end) tpoarch,
	periodo,
	replicate('0', (2 - datalength(convert(varchar,mesini,1)))) + convert(varchar,mesini,1) meses, 
	(case 
		when horaejecuta < 12  then 
		  	replicate('0', (2 - datalength(convert(varchar,horaejecuta,1)))) +convert(varchar,horaejecuta,1)+':'+replicate('0', (2 - datalength(convert(varchar,minejecuta,1))))+convert(varchar,minejecuta,1)+   ' AM'
		 else 
			replicate('0', (2 - datalength(convert(varchar,horaejecuta-12,1)))) +convert(varchar,horaejecuta-12,1)+':'+replicate('0', (2 - datalength(convert(varchar,minejecuta,1))))+convert(varchar,minejecuta,1)+   ' PM'
	end) Hora,
	listsegmento,
	listcuenta
	from  tbl_archivoscf
	where 
	<!--- usuario = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(url.USUARIO)#"> and --->
	status   = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(url.status)#">
	and BorrarArch = <cfqueryparam cfsqltype="cf_sql_varchar"  value="S"> 
	order by idarchivo desc
</cfquery>
<cfoutput>
<link href="/cfmx/sif/fondos/css/sif.css" rel="stylesheet" type="text/css">

	<table width="100%" border="0">
		<tr>
			<td  align="center"></td>
<!--- 			<td  bgcolor="##CCCCCC" colspan="2" align="center"></td>
 --->			<td  bgcolor="##CCCCCC" colspan="2" align="center"><strong>Solicitud</strong></td>
			<td  bgcolor="##CCCCCC" colspan="6" align="center"><strong>Parámetros</strong></td>

		</tr>	
		<tr>
			<td  align="center"></td>
			<!--- <td  bgcolor="##CCCCCC" align="left"><strong>Archivo</strong></td>
			<td  bgcolor="##CCCCCC" align="left"><strong>Status</strong></td> --->
			<td  bgcolor="##CCCCCC" align="center"><strong>Fecha</strong></td>
			<td  bgcolor="##CCCCCC" align="center"><strong>hora</strong></td>
			<td  bgcolor="##CCCCCC" align="center"><strong>Tipo</strong></td>
			<!--- <td  bgcolor="##CCCCCC" align="center"><strong>Origen</strong></td> --->
			<td  bgcolor="##CCCCCC" align="center"><strong>Periodo</strong></td>
			<td  bgcolor="##CCCCCC" align="center"><strong>Mes</strong></td>
			<td  bgcolor="##CCCCCC" align="center"><strong>Segmentos</strong></td>
			<td  bgcolor="##CCCCCC" align="center"><strong>Cuenta</strong></td>

		</tr>
	
	<cfset tempfile_TXT = "#GetTempDirectory()#">
	<cfif sql.recordcount gt 0>
		<cfset yourFile = sql.nombrearc>
		<cfloop query="sql">
		<tr>
			<cfset yourFile = tempfile_TXT&sql.nombrearc>
			<cfif FileExists(yourFile)>
				<!--- <td ><a   href="*" onClick="BJ_ARCH('#sql.nombrearc#')">** #sql.nombrearc#</a></td> --->
				<td  width="1%" align="center"> <img src="imagenes/Cfinclude.gif" onClick="BJ_ARCH('#sql.nombrearc#','#sql.idarchivo#')"></td>
			<cfelse>
				<td width="1%" align="center"> <img src="imagenes/RepeatedRegion.gif" width="22" height="29" ></td>
			</cfif>
<!--- 				<td  align="left" >#sql.nombrearc#</td>
				<td  align="left">#sql.status#</td>
 --->				<td  align="center">#sql.fechasolic#</td>
				<td  align="center">#sql.Hora#</td>
				<td  align="left">#sql.tpoarch#</td> 
				<!--- <td  align="center">#sql.origenDES#</td> --->
				<td  align="center">#sql.periodo#</td>
				<td  align="center">#sql.meses#</td>
				<td  align="left">#replace(sql.listsegmento,"'","","All")#</td> 
				<cfif sql.origen eq "L">
					<cfset CUENTAS = "">
					<cfset LISTACUENTAS = ListToarray(sql.listcuenta)>
					<cfset cantCuentas = ArrayLen(LISTACUENTAS)>
					<cfloop index="i" from="1" to="#cantCuentas#">
						<cfset arreglo = listtoarray(LISTACUENTAS[i],"¶")>	
						<cfset CUENTAS = CUENTAS  & arreglo[1]>
						<cfif i neq cantCuentas>
							<cfset CUENTAS = CUENTAS  & ','>
						</cfif>
					</cfloop>
				<cfelse>
					<cfset CUENTAS = sql.listcuenta>
				</cfif>
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
	var formato   =  "left=320,top=300,scrollbars=yes,resizable=yes,width=1,height=1"
	open("/cfmx/sif/Contaweb/reportes/cmn_bajarArchivoM.cfm"+PARAMS,"",formato);
	window.setInterval("location.reload()",2000);

}
</script>
