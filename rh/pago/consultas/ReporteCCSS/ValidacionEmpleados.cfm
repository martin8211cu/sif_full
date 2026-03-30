<cf_templatecss>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Simbologia"
	Default="Simbolog&iacute;a"
	returnvariable="LB_Simbologia"/>

<cfquery name="rsParametros" datasource="#session.dsn#">
	select nt.NTIdescripcion,de.DEidentificacion,
	{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )} as nombre,
	coalesce(de.DESeguroSocial,de.DEdato3) as DESeguroSocial
	from DatosEmpleado de
	inner join NTipoIdentificacion nt
		on de.NTIcodigo = nt.NTIcodigo
	inner join 	LineaTiempo lt
		on lt.Ecodigo = de.Ecodigo 
		and lt.DEid  = de.DEid
		and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> between lt.LTdesde and lt.LThasta 
	where de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	and coalesce(de.DESeguroSocial,de.DEdato3) is null
	
	order by de.DEnombre,de.DEapellido1,de.DEapellido2
</cfquery>
<cfoutput>
	<div align="center" style=" width:560px; height:358px; overflow:auto; display:block; padding: 10 10 10 10;">
	<table width="100%" border="0" cellspacing="1" cellpadding="1">
		<tr bgcolor="##CCCCCC">
			<td colspan="2" width="12%">
				<b><cf_translate  key="LB_Identificacion">Identificaci&oacute;n</cf_translate></b>
			</td>
			<td   width="60%">
				<b><cf_translate  key="LB_Empleado">Empleado</cf_translate></b>
			</td>
			<td width="5%">&nbsp;
			</td>
		</tr>
		<cfloop query="rsParametros">
			<cfset LvarListaNon = (rsParametros.CurrentRow MOD 2)>
            <cfset LvarClassName = IIf(LvarListaNon, DE('listaNon'), DE('listaPar'))>
			<tr class="#LvarClassName#" onmouseover="this.className='#LvarClassName#Sel';" onmouseout="this.className='#LvarClassName#';"> 
				<td>
					#trim(rsParametros.NTIdescripcion)#
			   </td>
				<td width="13%">
					#trim(rsParametros.DEidentificacion)#
				</td>
				<td>
					#trim(rsParametros.nombre)#
				</td>
				<td align="center">
					<cfif len(trim(rsParametros.DESeguroSocial)) eq 0>
						<img border="0" src="/cfmx/rh/imagenes/w-close.gif">
					<cfelseif  len(trim(rsParametros.DESeguroSocial)) gt 3>
						<img border="0" src="/cfmx/rh/imagenes/stop.gif" >
					</cfif>
				</td>
			</tr>
		</cfloop>
	</table>
	</div>
	<fieldset><legend>#LB_Simbologia#</legend>
		<table width="100%" border="0" cellspacing="1" cellpadding="1">
			<tr >
				<td valign="top">
					<img border="0" src="/cfmx/rh/imagenes/w-close.gif">
				</td>
				<td valign="top">
					<cf_translate  key="LB_simbolo1">Los empleados que se muestran en la lista no tienen definido el <b>n&uacute;mero seguro social</b> </cf_translate>
				</td>
			</tr>
		</table>
	</fieldset>	
</cfoutput>
