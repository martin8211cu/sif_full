<cf_templatecss>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Simbologia"
	Default="Simbolog&iacute;a"
	returnvariable="LB_Simbologia"/>

<cfquery name="rsParametros" datasource="#session.dsn#">
	select coalesce(a.RHPcodigoext,a.RHPcodigo) as RHPcodigo,a.RHPdescpuesto 
	from RHPuestos a
	inner join RHPlazas b
		on  b.RHPpuesto  = a.RHPcodigo
		and b.Ecodigo = a.Ecodigo 
		and b.RHPactiva = 1
	inner join 	LineaTiempo c
		on c.Ecodigo = b.Ecodigo 
		and c.RHPid  = b.RHPid
		and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> between c.LTdesde and c.LThasta 
	where a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	and a.RHOcodigo is null
	and a.RHPactivo  = 1	

	order by coalesce(RHPcodigoext,a.RHPcodigo)
</cfquery>
<cfoutput>
	<div align="center" style=" width:560px; height:358px; overflow:auto; display:block; padding: 10 10 10 10;">
	<table width="100%" border="0" cellspacing="1" cellpadding="1">
		<tr bgcolor="##CCCCCC">
			<td  width="10%">
				<b><cf_translate  key="LB_Codigo">C&oacute;digo</cf_translate></b>
			</td>
			<td   width="85%">
				<b><cf_translate  key="LB_Puesto">Puesto</cf_translate></b>
			</td>
			<td width="5%">&nbsp;
			</td>
		</tr>
		<cfloop query="rsParametros">
			<cfset LvarListaNon = (rsParametros.CurrentRow MOD 2)>
            <cfset LvarClassName = IIf(LvarListaNon, DE('listaNon'), DE('listaPar'))>
			<tr class="#LvarClassName#" onmouseover="this.className='#LvarClassName#Sel';" onmouseout="this.className='#LvarClassName#';"> 
				<td>
					#trim(rsParametros.RHPcodigo)#
			   </td>
				<td>
					#trim(rsParametros.RHPdescpuesto)#
				</td>
				<td align="center">
					<img border="0" src="/cfmx/rh/imagenes/w-close.gif">
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
					<cf_translate  key="LB_simbolo1">Los puestos que se muestran en la lista no tienen definida la <b> ocupaci&oacute;n  ( Hom&oacute;logo de la caja )</b>, la cual es necesaria para la generaci&oacute;n del archivo</cf_translate>
				</td>
			</tr>

		</table>
	</fieldset>	
</cfoutput>