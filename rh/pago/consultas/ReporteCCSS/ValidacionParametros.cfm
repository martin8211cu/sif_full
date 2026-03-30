<cf_templatecss>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Simbologia"
	Default="Simbolog&iacute;a"
	returnvariable="LB_Simbologia"/>	

<cfquery name="rsParametros" datasource="#session.dsn#">
	select Pcodigo,Pdescripcion,Pvalor from RHParametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	and Pcodigo in (300,410)
</cfquery>
<cfoutput>
	<table width="100%" border="0" cellspacing="1" cellpadding="1">
		<tr bgcolor="##CCCCCC">
			<td width="70%">
				<b><cf_translate  key="LB_Parametro">Par&aacute;metro</cf_translate></b>
			</td>
			<td width="25%">
				<b><cf_translate  key="LB_Valor">Valor</cf_translate></b>
			</td>
			<td width="5%">&nbsp;
			</td>
		</tr>
		<cfloop query="rsParametros">
			<cfset LvarListaNon = (rsParametros.CurrentRow MOD 2)>
            <cfset LvarClassName = IIf(LvarListaNon, DE('listaNon'), DE('listaPar'))>
			<tr class="#LvarClassName#" onmouseover="this.className='#LvarClassName#Sel';" onmouseout="this.className='#LvarClassName#';"> 
				<td>
					#rsParametros.Pdescripcion#
				</td>
				<td>
					#rsParametros.Pvalor#
				</td>
				<td align="center"s>
					<cfif rsParametros.Pcodigo eq 300>
						<cfif len(trim(rsParametros.Pvalor)) eq 0>
							<img border="0" src="/cfmx/rh/imagenes/w-close.gif">
						<cfelseif  len(trim(rsParametros.Pvalor)) gt 18>
							<img border="0" src="/cfmx/rh/imagenes/stop.gif" >
						<cfelseif  len(trim(rsParametros.Pvalor)) lt 18>
							<img border="0" src="/cfmx/rh/imagenes/stop.gif" >
						<cfelse>
							<img border="0" src="/cfmx/rh/imagenes/stop2.gif" >
						</cfif>
					<cfelseif  rsParametros.Pcodigo eq 410>
						<cfif len(trim(rsParametros.Pvalor)) eq 0>
							<img border="0" src="/cfmx/rh/imagenes/w-close.gif" >
						<cfelseif  len(trim(rsParametros.Pvalor)) gt 4>
							<img border="0" src="/cfmx/rh/imagenes/stop.gif" >
						<cfelseif  len(trim(rsParametros.Pvalor)) lt 4>
							<img border="0" src="/cfmx/rh/imagenes/stop.gif" >
						<cfelse>
							<img border="0" src="/cfmx/rh/imagenes/stop2.gif" >
						</cfif>
					</cfif>
				</td>
			</tr>
		</cfloop>
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>	
		<tr>
			<td colspan="3">
				<fieldset><legend>#LB_Simbologia#</legend>
					<table width="100%" border="0" cellspacing="1" cellpadding="1">
						<tr >
							<td>
								<img border="0" src="/cfmx/rh/imagenes/w-close.gif">
							</td>
							<td>
								<cf_translate  key="LB_simbolo1">Sin definir</cf_translate>
							</td>
						</tr>	
						<tr>
							<td>
								<img border="0" src="/cfmx/rh/imagenes/stop.gif">
							</td>
							<td>
								<cf_translate  key="LB_simbolo2">La longitud para el n&uacute;mero patronal debe ser de 18 digitos</cf_translate>
							</td>
						</tr>
						<tr>
							<td>
								<img border="0" src="/cfmx/rh/imagenes/stop.gif">
							</td>
							<td>
								<cf_translate  key="LB_simbolo3">La longitud para la sucursal adscrita CCSS debe ser de 4 digitos</cf_translate>
							</td>
						</tr>
						<tr>
							<td>
								<img border="0" src="/cfmx/rh/imagenes/stop2.gif">
							</td>
							<td>
								<cf_translate  key="LB_simbolo4">Dato Correcto</cf_translate>
							</td>
						</tr>
					</table>
				</fieldset>
			</td>
		</tr>
	</table>
	
</cfoutput>
