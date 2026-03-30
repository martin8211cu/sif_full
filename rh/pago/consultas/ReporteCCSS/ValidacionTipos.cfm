<cf_templatecss>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Simbologia"
	Default="Simbolog&iacute;a"
	returnvariable="LB_Simbologia"/>	

<cfquery name="rsParametros" datasource="#session.dsn#">
	select RHTcomportam,RHTcodigo,RHTdesc,RHTdatoinforme,case RHTcomportam when 4 then '<cf_translate  key="LB_Permiso">Permiso</cf_translate>' when 5 then '<cf_translate  key="LB_Incapacidad">Incapacidad</cf_translate>' end as comportamiento
	from RHTipoAccion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and RHTcomportam in (4,5)
	order by RHTcomportam ,RHTcodigo	
</cfquery>

<cfoutput>
	<div align="center" style=" width:560px; height:258px; overflow:auto; display:block; padding: 10 10 10 10;">
	<table width="100%" border="0" cellspacing="1" cellpadding="1">
		<tr bgcolor="##CCCCCC">
			<td width="10%">
				<b><cf_translate  key="LB_Comportamiento">Comportamiento</cf_translate></b>
			</td>
			<td  colspan="2" width="60%">
				<b><cf_translate  key="LB_Tipo_DE_Accion_de_personal">Tipo de Acci&oacute;n de personal</cf_translate></b>
			</td>
			<td width="25%">
				<b><cf_translate  key="LB_Dato_CCSS ">Dato CCSS</cf_translate></b>
			</td>
			<td width="5%">&nbsp;
			</td>
		</tr>
		<cfloop query="rsParametros">
			<cfset LvarListaNon = (rsParametros.CurrentRow MOD 2)>
            <cfset LvarClassName = IIf(LvarListaNon, DE('listaNon'), DE('listaPar'))>
			<tr class="#LvarClassName#" onmouseover="this.className='#LvarClassName#Sel';" onmouseout="this.className='#LvarClassName#';"> 
				<td width="10%">
					#trim(rsParametros.comportamiento)#
			   </td>
				<td>
					#trim(rsParametros.RHTcodigo)#
				</td>
				<td>
					#trim(rsParametros.RHTdesc)#
				</td>
				<td>
					#rsParametros.RHTdatoinforme#
				</td>
				<td align="center">
					<cfif len(trim(rsParametros.RHTdatoinforme)) eq 0>
						<img border="0" src="/cfmx/rh/imagenes/w-close.gif">
					<cfelseif  len(trim(rsParametros.RHTdatoinforme)) gt 0 and  rsParametros.RHTcomportam  eq 5 and  ListValueCount('INS,SEM,MAT', trim(rsParametros.RHTdatoinforme)) eq 0 >
					  <img border="0" src="/cfmx/rh/imagenes/stop4.gif">
					<cfelseif  len(trim(rsParametros.RHTdatoinforme)) gt 0 and  rsParametros.RHTcomportam  eq 4 and  ListValueCount('C,S', trim(rsParametros.RHTdatoinforme)) eq 0 >
					  <img border="0" src="/cfmx/rh/imagenes/stop3.gif">
					<cfelse>
						<img border="0" src="/cfmx/rh/imagenes/stop2.gif" >
					</cfif>
				</td>
			</tr>
		</cfloop>
	</table>
	</div>
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
					<img border="0" src="/cfmx/rh/imagenes/stop4.gif">
				</td>
				<td>
					<cf_translate  key="LB_simbolo4">El dato del CCSS para una incapacidad son &quot;INS,SEM,MAT&quot; y en may&uacute;scula</cf_translate>
				</td>
			</tr>
			<tr>
				<td>
				<img border="0" src="/cfmx/rh/imagenes/stop3.gif"		
				</td>
				<td>
					<cf_translate  key="LB_simbolo4">El dato del CCSS para un permiso son &quot;C,S&quot; y en may&uacute;scula</cf_translate>
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
