<cf_templatecss>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Simbologia"
	Default="Simbolog&iacute;a"
	returnvariable="LB_Simbologia"/>	

<cfquery name="rsParametros" datasource="#session.dsn#">
	select Oficodigo,Odescripcion ,Onumpatronal,Oadscrita,
	case Onumpatinactivo 
		when 0 then '<cf_translate  key="LB_Permiso">Activa</cf_translate>' 
	end as Onumpatinactivo 
	
	from Oficinas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	 and ( (Onumpatronal is not null and Onumpatronal != ' ')  or  (Oadscrita is not null and Oadscrita != ' ') )
	 and Onumpatinactivo = 0
	order by Oficodigo
</cfquery>
<cfoutput>
	<div align="center" style=" width:560px; height:290px; overflow:auto; display:block; padding: 10 10 10 10;">
	<table width="100%" border="0" cellspacing="1" cellpadding="1">
		<tr bgcolor="##CCCCCC">
			<td   valign="bottom" colspan="2" width="40%">
				<b><cf_translate  key="LB_Oficina">Oficina</cf_translate></b>
			</td>
			<td valign="bottom" width="20%">
				<b><cf_translate  key="LB_Numero_Patronal">No. Patronal</cf_translate></b>
			</td>
			<td valign="bottom" width="20%" align="center">
				<b><cf_translate  key="LB_Sucursal_de_la_CCSS_Adscrita">Sucursal de la CCSS Adscrita</cf_translate></b>
			</td>
			<td valign="bottom" width="15%" align="center">
				<b><cf_translate  key="LB_Estado">Estado</cf_translate></b>
			</td>

			<td width="5%">&nbsp;
			</td>
		</tr>
		<cfloop query="rsParametros">
			<cfset LvarListaNon = (rsParametros.CurrentRow MOD 2)>
            <cfset LvarClassName = IIf(LvarListaNon, DE('listaNon'), DE('listaPar'))>
			<tr class="#LvarClassName#" onmouseover="this.className='#LvarClassName#Sel';" onmouseout="this.className='#LvarClassName#';"> 
				<td width="5%">
					#trim(rsParametros.Oficodigo)#
			   </td>
				<td>
					#trim(rsParametros.Odescripcion)#
				</td>
				<td>
					#trim(rsParametros.Onumpatronal)#
				</td>
				<td>
					#trim(rsParametros.Oadscrita)# 
				</td>
				<td align="center">
					#trim(rsParametros.Onumpatinactivo)# 
				</td>
				<td align="center">
					<cfif len(trim(rsParametros.Onumpatronal)) eq 0 or len(trim(rsParametros.Oadscrita)) eq 0>
						<img border="0" src="/cfmx/rh/imagenes/w-close.gif">
					<cfelseif  len(trim(rsParametros.Onumpatronal)) gt 18>
						<img border="0" src="/cfmx/rh/imagenes/stop.gif" >
					<cfelseif  len(trim(rsParametros.Onumpatronal)) lt 18>
						<img border="0" src="/cfmx/rh/imagenes/stop3.gif" >	
					<cfelseif len(trim(rsParametros.Onumpatronal)) eq 18 or len(trim(rsParametros.Oadscrita)) gt 0>
						<img border="0" src="/cfmx/rh/imagenes/stop2.gif" >
					</cfif>
				</td>
			</tr>
		</cfloop>
	</table>
	
	</div>
	<BR>
	<fieldset><legend>#LB_Simbologia#</legend>
		<table width="100%" border="0" cellspacing="1" cellpadding="1">
			<tr >
				<td>
					<img border="0" src="/cfmx/rh/imagenes/w-close.gif">
				</td>
				<td>
					<cf_translate  key="LB_simbolo1">El n&uacute;mero Patronal o Sucursal de la CCSS Adscrita sin definir</cf_translate>
				</td>
			</tr>	
			<tr>
			<tr>
				<td>
					<img border="0" src="/cfmx/rh/imagenes/stop.gif">
				</td>
				<td>
					<cf_translate  key="LB_simbolo2">El n&uacute;mero patronal es mayor a 18 caracteres</cf_translate>
				</td>
			</tr>
			<tr>
				<td>
					<img border="0" src="/cfmx/rh/imagenes/stop3.gif">
				</td>
				<td>
					<cf_translate  key="LB_simbolo3">El n&uacute;mero patronal es menor a 18 caracteres</cf_translate>
				</td>
			</tr>			
			<tr>
				<td>
					<img border="0" src="/cfmx/rh/imagenes/stop2.gif">
				</td>
				<td>
					<cf_translate  key="LB_simbolo10">Dato Correcto</cf_translate>
				</td>
			</tr>
		</table>
	</fieldset>
	
</cfoutput>
