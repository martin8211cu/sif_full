<cfset titulo = 'Exportar Categorías'>
<cfquery name="SQL" datasource="#session.dsn#">
	select ACcodigo
	from ACategoria 
	where Ecodigo = #session.Ecodigo#
	<cfif isdefined ('form.ACcodigo')>
	and ACcodigo = <cfqueryparam value="#ACcodigo#" cfsqltype="cf_sql_integer">
	</cfif>
</cfquery>

<cfquery name="rsEncabezadoC" datasource="#session.DSN#">
	select 
		ACcodigo, 
		ACcodigodesc, 
		ACdescripcion, 
		ACvutil, 
		ACcatvutil, 
		ACmetododep, 
		ACmascara, 
		cuentac,
		BMUsucodigo
	from ACategoria 
		where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	<cfif isdefined ('form.ACcodigo')>
		and ACcodigo = <cfqueryparam value="#Form.ACcodigo#" cfsqltype="cf_sql_integer">
		</cfif>
</cfquery>


<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td colspan="3" align="left" valign="top">
			<strong> &nbsp; &nbsp; &nbsp;Código: <cfoutput>#rsEncabezadoC.ACcodigo#</cfoutput></strong>
		</td>
	</tr>
	<tr><td>&nbsp; &nbsp;</td></tr>
	<tr>
		<td>
			<strong><cfoutput>&nbsp; &nbsp; &nbsp;Descripción del Código</strong>#rsEncabezadoC.ACcodigodesc#</cfoutput>
		</td>
	</tr>
	<tr>
		<td>
			<strong><cfoutput>&nbsp; &nbsp; &nbsp;Descripción</strong>#rsEncabezadoC.ACdescripcion#</cfoutput>
		</td>
	</tr>
	
		<tr>
		<td>
			<strong><cfoutput>&nbsp; &nbsp; &nbsp;Vida Útil</strong>#rsEncabezadoC.ACvutil#</cfoutput>
		</td>
	</tr>
	
		<tr>
		<td>
			<strong><cfoutput>&nbsp; &nbsp; &nbsp;Asigna Vida Útil a Clasificación</strong>#rsEncabezadoC.ACvutil#</cfoutput>
		</td>
	</tr>
	
	<tr>
		<td>&nbsp;&nbsp;&nbsp;&nbsp;<strong>Método de Depreciación:</strong>&nbsp;
			<cfswitch expression="#rsEncabezadoC.ACmetododep#">
				<cfcase value="1">
					Línea Recta
				</cfcase>
				<cfcase value="2">
					Suma de Dígitos
				</cfcase> 
			</cfswitch>
		</td>
	</tr>
	<tr>
		<td>
			<strong><cfoutput>&nbsp; &nbsp; &nbsp;Máscara</strong>#rsEncabezadoC.ACmascara#</cfoutput>
		</td>
	</tr>
	
		<tr>
		<td>
			<strong><cfoutput>&nbsp; &nbsp; &nbsp;Cuenta</strong>#rsEncabezadoC.cuentac#</cfoutput>
		</td>
	</tr>
	
		<tr>
		<td>
			<strong><cfoutput>&nbsp; &nbsp; &nbsp;BMUsucodigo</strong>#rsEncabezadoC.BMUsucodigo#</cfoutput>
		</td>
	</tr>
	<tr>
		<td align="center" style="padding-left: 15px " valign="top">
			<cf_sifimportar EIcodigo="CATEXPO" mode="out">
			<cfif isdefined ('form.ACcodigo')>
				<cf_sifimportarparam name="ACcodigo" value="#form.ACcodigo#">
			</cfif>
			</cf_sifimportar>
			
		</td>
	</tr>
	<tr><td colspan="3" align="center">&nbsp;</td></tr>
</table>
