<cfset titulo = 'Exportar Clases'>
<cfquery name="SQL" datasource="#session.dsn#">
	select ACcodigodesc
	from AClasificacion
	where Ecodigo = #session.Ecodigo#
	<cfif isdefined ('form.ACcodigodesc')>
	and ACcodigodesc = <cfqueryparam value="#ACcodigodesc#" cfsqltype="cf_sql_varchar">
	</cfif>
</cfquery>
<cfquery name="rs3100" datasource="#session.dsn#">
	select Pvalor from Parametros where Ecodigo = #session.Ecodigo# and Pcodigo = 3100
</cfquery>
<cfif rs3100.RecordCount GT 0 and rs3100.Pvalor EQ 1>
	<cfset importador = 'CLASEXPOEXT'>
<cfelse>
	<cfset importador = 'CLASEXPO'>
</cfif>

<cfquery name="rsEncabezadoC" datasource="#session.DSN#">
	select 
		*
	from AClasificacion
		where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	<cfif isdefined ('form.ACcodigodesc')>
		and ACcodigodesc = <cfqueryparam value="#Form.ACcodigodesc#" cfsqltype="cf_sql_varchar">
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
		<td>&nbsp;&nbsp;&nbsp;&nbsp;<strong>Depreciable:</strong>&nbsp;
			<cfswitch expression="#rsEncabezadoC.ACdepreciable#">
				<cfcase value="S">
					Aplica
				</cfcase>
				<cfcase value="N">
					No Aplica
				</cfcase> 
			</cfswitch>
		</td>
	</tr>
	
		<tr>
		<td>&nbsp;&nbsp;&nbsp;&nbsp;<strong>Revalúa:</strong>&nbsp;
			<cfswitch expression="#rsEncabezadoC.ACrevalua#">
				<cfcase value="S">
					Aplica
				</cfcase>
				<cfcase value="N">
					No Aplica
				</cfcase> 
			</cfswitch>
		</td>
	</tr>
	
	<tr>
		<td>
			<strong><cfoutput>&nbsp; &nbsp; &nbsp;Superavit</strong>#rsEncabezadoC.ACcsuperavit#</cfoutput>
		</td>
	</tr>
	
	<tr>
		<td>
			<strong><cfoutput>&nbsp; &nbsp; &nbsp;Adquisición</strong>#rsEncabezadoC.ACcadq#</cfoutput>
		</td>
	</tr>
	<tr>
		<td>
			<strong><cfoutput>&nbsp; &nbsp; &nbsp;Depreciación Acumulada</strong>#rsEncabezadoC.ACcdepacum#</cfoutput>
		</td>
	</tr>
	<tr>
		<td>
			<strong><cfoutput>&nbsp; &nbsp; &nbsp;Revaluación</strong>#rsEncabezadoC.ACcrevaluacion#</cfoutput>
		</td>
	</tr>
	<tr>
		<td>
			<strong><cfoutput>&nbsp; &nbsp; &nbsp;Complemento Depreciación</strong>#rsEncabezadoC.ACgastodep#</cfoutput>
		</td>
	</tr>
	
		<tr>
		<td>&nbsp;&nbsp;&nbsp;&nbsp;<strong>Tipo:</strong>&nbsp;
			<cfswitch expression="#rsEncabezadoC.ACtipo#">
				<cfcase value="M">
					Monto
				</cfcase>
				<cfcase value="P">
					Porcentaje
				</cfcase> 
			</cfswitch>
		</td>
	</tr>
	<tr>
		<td>
			<strong><cfoutput>&nbsp; &nbsp; &nbsp;Complemento Revaluación</strong>#rsEncabezadoC.ACgastorev#</cfoutput>
		</td>
	</tr>
	
		<tr>
		<td>
			<strong><cfoutput>&nbsp; &nbsp; &nbsp;Valor Recidual</strong>#rsEncabezadoC.ACvalorres#</cfoutput>
		</td>
	</tr>
	
		<tr>
		<td>
			<strong><cfoutput>&nbsp; &nbsp; &nbsp;Cuenta</strong>#rsEncabezadoC.cuentac#</cfoutput>
		</td>
	</tr>
		<tr>
		<td>
			<strong><cfoutput>&nbsp; &nbsp; &nbsp;Complemento Gasto Retiro</strong>#rsEncabezadoC.ACgastoret#</cfoutput>
		</td>
	</tr>
		<tr>
		<td>
			<strong><cfoutput>&nbsp; &nbsp; &nbsp;Complemento Ingreso Retiro</strong>#rsEncabezadoC.ACingresoret#</cfoutput>
		</td>
	</tr>
	<tr>
		<td>
			<strong><cfoutput>&nbsp; &nbsp; &nbsp;ACcdepacumrev</strong>#rsEncabezadoC.ACcdepacumrev#</cfoutput>
		</td>
	</tr>
	<cfif importador EQ 'CLASEXPOEXT'>
		<tr>
			<td>
				<strong>&nbsp; &nbsp; &nbsp;ACNegarMej</strong>
				<cfswitch expression="#rsEncabezadoC.ACNegarMej#">
					<cfcase value="1">
						NO permite mejoras o adiciones
					</cfcase>
					<cfcase value="0">
						SI permite mejoras o adiciones
					</cfcase>
				</cfswitch>
			</td>
		</tr>	
	</cfif>
	<tr>
		<td align="center" style="padding-left: 15px " valign="top">
			<cf_sifimportar EIcodigo="#importador#" mode="out">
			<cfif isdefined ('form.ACcodigo')>
				<cf_sifimportarparam name="ACcodigo" value="#form.ACcodigo#">
			</cfif>
			<cfif rs3100.RecordCount GT 0 and rs3100.Pvalor EQ 1>
				<cf_sifimportarparam name="ACNegarMej" value="1">
			</cfif>
			</cf_sifimportar>
		</td>
	</tr>
	<tr><td colspan="3" align="center">&nbsp;</td></tr>
</table>
