<cfquery name="rsOrden" datasource="sdc">
	select MSMorden, MSMpath, convert(varchar,MSMmenu) as MSMmenu, replicate('&nbsp;', MSMprofundidad * 3) + MSMtexto as MSMtexto, MSPcodigo
	from MSMenu
	where Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Scodigo#">
	order by MSMpath
</cfquery>

<cfoutput>
<table width="100%" cellpadding="0" cellspacing="1">  
	<tr>
		<td width="35%" align="right">Nombre:&nbsp;</td>
		<td><input type="text" name="MSMtexto" size="30" maxlength="30" value="<cfif modo neq 'ALTA'>#trim(rsForm.MSMtexto)#</cfif>" onfocus="javascript: reset_color(this); this.select();"  ></td>
	</tr>
	<tr>
		<td align="right">Orden:&nbsp;</td>
		<td>
			<select name="MSMorden" onFocus="javascript:reset_color(this);">
				<cfloop query="rsOrden">
					<option value="#rsOrden.MSMorden#" <cfif modo neq 'ALTA' and rsForm.MSMorden eq rsOrden.MSMorden >selected</cfif> >#rsOrden.MSMtexto#</option>
				</cfloop>
			</select> 
		</td>
	</tr>
	<tr>
		<td align="right">Estilo/Link:&nbsp;</td>
		<td>
			<select name="MSMestilo" onChange="javascript:seleccion(this.value);">
				<option value="E" <cfif modo neq 'ALTA' and len(trim(rsForm.MSMlink)) gt 0 >selected</cfif> >Estilo</option>
				<option value="L" <cfif modo neq 'ALTA' and len(trim(rsForm.MSMlink)) eq 0 >selected</cfif> >Link</option>
			</select> 
		</td>
	</tr>
	
	<!--- link--->
	<tr id="link" style="display:none" >
		<td align="right">Link:&nbsp;</td>
		<td><input type="text" name="MSMlink" maxlength="255" size="60" value="<cfif modo neq 'ALTA'>#trim(rsForm.MSMlink)#</cfif>" onfocus="javascript:this.select();" ></td>
	</tr>
	
</table>
</cfoutput>