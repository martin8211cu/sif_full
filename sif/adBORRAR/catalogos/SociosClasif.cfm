<cfquery datasource="#session.dsn#" name="clases">
	select e.SNCEid, e.SNCEcorporativo, 
		e.SNCEcodigo, e.SNCEdescripcion, e.PCCEobligatorio,
		d.SNCDid , d.SNCDvalor, d.SNCDdescripcion, 
		case when e.Ecodigo is null then 0 else 1 end as local,
		case when sn.SNCDid is null then 0 else 1 end as existe
	from SNClasificacionE e
		join SNClasificacionD d
			on d.SNCEid = e.SNCEid
		left join SNClasificacionSN sn
			on sn.SNCDid = d.SNCDid
			and sn.SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocios.SNid#">
	where e.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and ( e.Ecodigo is null or e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
	  and e.PCCEactivo = 1
	order by local, e.SNCEcodigo, e.SNCEdescripcion, e.SNCEid, 
		d.SNCDdescripcion 
</cfquery>

<form action="SociosClasif-sql.cfm" method="post" style="margin:0 " name="formClax">
	<cfoutput>
	<input type="hidden" name="SNid" value="#HTMLEditFormat(rsSocios.SNid)#">
	<input type="hidden" name="SNcodigo" value="#HTMLEditFormat(rsSocios.SNcodigo)#"></cfoutput>
	<table align="center">
	<cfoutput query="clases" group="local">
	<tr><td colspan="4" class="tituloListas">
	<cfif local>Clasificaciones locales<cfelse>Clasificaciones corporativas</cfif>
	</td></tr>
	<cfoutput group="SNCEid">
	<tr>
	  <td width="73">&nbsp;</td>
	  <td width="247">#HTMLEditFormat(SNCEdescripcion)#</td>
	
	<td width="55">&nbsp;</td>
	<td width="311">
		<select name="clax" style="width:200px;" <cfif SNCEcorporativo And  session.Ecodigo neq session.Ecodigocorp and Len(session.Ecodigocorp)>disabled</cfif>>
			
			<cfif PCCEobligatorio EQ 0>
				<option value="">-Ninguno-</option>
			<cfelse>
				<option value="">- Debe Escoger uno -</option>	
			</cfif>
			<cfoutput>
				<cfif existe or SNCEcorporativo EQ 0 or session.Ecodigo eq session.Ecodigocorp or not Len(session.Ecodigocorp ) >
					<option value="#HTMLEditFormat(SNCDid)#" <cfif existe>selected</cfif>>#HTMLEditFormat(SNCDdescripcion)#</option>
				</cfif>
			</cfoutput>
		</select>
	</td>
	</tr>
	</cfoutput>
	</cfoutput>
	<cfif clases.RecordCount EQ 0>
	<tr><td colspan="4">&nbsp;</td></tr>
	<tr><td colspan="4">&nbsp;</td></tr>
	<tr><td colspan="4" align="center" style="font-size:18px;"><a href="SNClasificaciones.cfm">No hay clasificaciones definidas.<br>Haga clic aqu&iacute; para definirlas.</a></td></tr>
	<tr><td colspan="4">&nbsp;</td></tr>
	<tr><td colspan="4">&nbsp;</td></tr>
	<cfelse>
	<tr><td colspan="4">&nbsp;</td></tr>
	<tr><td colspan="4">
				<cf_botones names="Cambio" values="Modificar">
	</td></tr>
	</cfif>
	</table>
</form>