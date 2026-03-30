<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 02 de marzo del 2006
	Motivo: Se modifico para mejorar el formato de la pantalla.

	Creado por: Ana Villavicencio
	Fecha: 27 de febrero del 2006
	Motivo: Se creo para consulta de las clasificaciones del socio, en la consulta Analisis  de Saldos de Socios.
 --->

<cfquery datasource="#session.dsn#" name="clases">
	select e.SNCEid, e.SNCEcorporativo, 
			e.SNCEcodigo, e.SNCEdescripcion, e.PCCEobligatorio,
			d.SNCDid , d.SNCDvalor, d.SNCDdescripcion, 
			case when e.Ecodigo is null then 0 else 1 end as local,
			case when sn.SNCDid is null then 0 else 1 end as existe
	from SNClasificacionSN sn
	inner join SNClasificacionD d
	   on sn.SNCDid = d.SNCDid
	inner join SNClasificacionE e
	   on d.SNCEid = e.SNCEid
	where SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocios.SNid#">
	  and e.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and ( e.Ecodigo is null or e.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
	  and e.PCCEactivo = 1
	order by local, e.SNCEcodigo, e.SNCEdescripcion, e.SNCEid, 
		d.SNCDdescripcion 
</cfquery>

	<table width="65%" align="center" cellpadding="3" cellspacing="0">
		<tr><td colspan="4">&nbsp;</td></tr>
		<cfoutput query="clases" group="local">
			<tr>
				<td colspan="4" class="tituloListas">
					<cfif local>Clasificaciones locales<cfelse>Clasificaciones corporativas</cfif>
				</td>
			</tr>
			<cfset linea=0>
			<cfoutput group="SNCEid">
			<tr <cfif linea EQ 0>class="listaNon"<cfelse>class="listaPar"</cfif>>
			  	<td width="38%">#HTMLEditFormat(SNCEdescripcion)#:&nbsp;</td>
			  	<td width="62%">#HTMLEditFormat(SNCDdescripcion)#</td>
			</tr>
			<cfif linea EQ 0><cfset linea= 1><cfelse><cfset linea=0></cfif>
			</cfoutput>
		</cfoutput>
		<cfif clases.RecordCount EQ 0>
			<tr><td colspan="4">&nbsp;</td></tr>
			<tr><td colspan="4">&nbsp;</td></tr>
			<tr><td colspan="4" align="center" style="font-size:18px;"><a href="SNClasificaciones.cfm">No hay clasificaciones definidas.</a></td></tr>
			<tr><td colspan="4">&nbsp;</td></tr>
			<tr><td colspan="4">&nbsp;</td></tr>
		</cfif>
		<tr><td colspan="4">&nbsp;</td></tr>
		<tr> 
			<td colspan="4" align="center" valign="top" nowrap> 
				<cf_botones Regresar="#Regresa#" exclude="Alta,Baja,Cambio,Limpiar">
			</td>
		</tr>
	</table>
