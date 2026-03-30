<cfsetting requesttimeout="3600">
<cfif isdefined('url.imprimir')>
	<cfif isdefined('url.Pidincio') and not isdefined('form.Pidincio')>
		<cfset form.Pidincio = url.Pidincio>
	</cfif>
	<cfif isdefined('url.Pidfinal') and not isdefined('form.Pidfinal')>
		<cfset form.Pidfinal = url.Pidfinal>
	</cfif>
	<cfif isdefined('url.BTidinicio') and not isdefined('form.BTidinicio')>
		<cfset form.BTidinicio = url.BTidinicio>
	</cfif>
	<cfif isdefined('url.BTidfinal') and not isdefined('form.BTidfinal')>
		<cfset form.BTidfinal = url.BTidfinal>
	</cfif>
	<cfif isdefined('url.Fechadesde') and not isdefined('form.Fechadesde')>
		<cfset form.Fechadesde = url.Fechadesde>
	</cfif>
	<cfif isdefined('url.Fechahasta') and not isdefined('form.Fechahasta')>
		<cfset form.Fechahasta = url.Fechahasta>
	</cfif>
	<cfif isdefined('url.documento') and not isdefined('form.documento')>
		<cfset form.documento = url.documento>
	</cfif>
</cfif>
<cfsavecontent variable="myQuery">
		<cfoutput>
			select p.Pid as Pid,
				 p.Pdescripcion as Peaje,
				 pa.PAfecha as dia,
				 btr.BTdescripcion as  tipo_transaccion,
				 pa.PAdocumento as documento,
				 pa.PAdescripcion as descripcion,
				 pa.PAmonto as monto, 
				 m.Mnombre as moneda
				 				 
				 from PAjustes pa
				 inner join BTransacciones btr
				 on btr.BTid = pa.BTid 
				 <cfif form.BTidinicio gt form.BTidfinal >
				       and btr.BTid between #form.BTidfinal# and #form.BTidinicio#
				 <cfelse> 
					   and btr.BTid between #form.BTidinicio# and #form.BTidfinal#
				</cfif>
	
				 inner join Peaje p
				 on pa.Pid= p.Pid
				 <cfif form.Pidincio gt form.Pidfinal >
				       and p.Pid between #form.Pidfinal# and #form.Pidincio#
				 <cfelse> 
					   and p.Pid between #form.Pidincio# and #form.Pidfinal#
				</cfif>
				 inner join Monedas m
				 on pa.Mcodigo= m.Mcodigo

			where btr.Ecodigo = #session.ecodigo#

			<cfif (isdefined("form.Fechadesde") and len(trim(form.Fechadesde)) gt 0)
				and (isdefined("form.Fechahasta") and len(trim(form.Fechahasta)) gt 0)>
					and pa.PAfecha between <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.Fechadesde)#">
					and <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.Fechahasta)#">  
			</cfif>
			<cfif (isdefined("form.documento") and len(trim(form.documento)) gt 0)>
					and pa.PAdocumento like '%#form.documento#%'	
			</cfif>
					
			union all

			select p.Pid as Pid,
				p.Pdescripcion as Peaje, 
				pet.PETfecha as dia, 
				btr.BTdescripcion as  tipo_transaccion,
				dep.PDTDdocumento as documento,
				dep.PDTDdescripcion as descripcion,
				dep.PDTDmonto as monto,
				m.Mnombre as moneda 

				from PETransacciones pet
				
				inner join PDTDeposito dep
				on pet.PETid = dep.PETid
			
				inner join BTransacciones btr
				 on btr.BTid = dep.BTid
				 <cfif form.BTidinicio gt form.BTidfinal >
				       and btr.BTid between #form.BTidfinal# and #form.BTidinicio#
				 <cfelse> 
					   and btr.BTid between #form.BTidinicio# and #form.BTidfinal#
				</cfif>
				
				inner join Peaje p
				 on pet.Pid= p.Pid 
				 <cfif form.Pidincio gt form.Pidfinal >
				       and p.Pid between #form.Pidfinal# and #form.Pidincio#
				 <cfelse> 
					   and p.Pid between #form.Pidincio# and #form.Pidfinal#
				</cfif>
				
				inner join Monedas m 
				on dep.Mcodigo= m.Mcodigo
			
			where btr.Ecodigo = #session.ecodigo#
			  and pet.PETestado = 2 
			   

			<cfif (isdefined("form.Fechadesde") and len(trim(form.Fechadesde)) gt 0)
				and (isdefined("form.Fechahasta") and len(trim(form.Fechahasta)) gt 0)>
					and pet.PETfecha between <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.Fechadesde)#">
					and <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.Fechahasta)#">  
			</cfif>
			<cfif (isdefined("form.documento") and len(trim(form.documento)) gt 0)>
					and dep.PDTDdocumento like '%#form.documento#%'	
			</cfif>
			order by Pid, dia
	</cfoutput>
</cfsavecontent>

<cfoutput>
<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td align="right">
				<table width="10%" align="right" border="0" height="25px">
					<tr><td>Usuario:</td><td>#session.Usulogin#</td></tr>
					<tr><td>Fecha:</td><td>#LSDateFormat(now(), 'dd/mm/yyyy')#</td></tr>
				</table>
			</td>
		</tr>
	
	<tr><td align="center"><span class="titulox"><strong><font size="2">#session.Enombre#</font></strong></span></td></tr>
	<tr><td align="center"><strong>Reporte de Dep&oacute;sitos y Ajustes por peaje</strong></td></tr>
		</td>
	
	<cfif (isdefined("form.Pidincio") and len(trim(form.Pidincio)) gt 0)>
		<cfquery name="rsP" datasource="#session.DSN#">
			select Pdescripcion
			from Peaje
			where Pid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Pidincio#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	<tr><td align="center"><strong>Peaje Desde : </strong>#rsP.Pdescripcion#
	</cfif>
	<cfif (isdefined("form.Pidfinal") and len(trim(form.Pidfinal)) gt 0)>
		<cfquery name="rsPf" datasource="#session.DSN#">
			select Pdescripcion
			from Peaje
			where Pid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Pidfinal#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	<strong> Hasta : </strong>#rsPf.Pdescripcion#</td></tr>
	</cfif>
	<cfif (isdefined("form.BTidinicio") and len(trim(form.BTidinicio)) gt 0)>
		<cfquery name="rsBT" datasource="#session.DSN#">
			select BTdescripcion
			from BTransacciones
			where BTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BTidinicio#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	<tr><td align="center"><strong>Tipo de transacción  Desde : </strong>#rsBT.BTdescripcion#
	</cfif>
	<cfif (isdefined("form.BTidfinal") and len(trim(form.BTidfinal)) gt 0)>
		<cfquery name="rsBTf" datasource="#session.DSN#">
			select BTdescripcion
			from BTransacciones
			where BTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BTidfinal#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	<strong> Hasta : </strong>#rsBTf.BTdescripcion#</td></tr>
	</cfif>
	
	<cfif (isdefined("form.Fechadesde") and len(trim(form.Fechadesde)) gt 0)
		and not (isdefined("form.Fechahasta") and len(trim(form.Fechahasta)) gt 0)>
			<tr><td align="center"><strong>Desde : </strong>#LSDateFormat(form.Fechadesde,'DD/MM/YYYY')#</td></tr>
	<cfelseif not(isdefined("form.Fechadesde") and len(trim(form.Fechadesde)) gt 0)
		and (isdefined("form.Fechahasta") and len(trim(form.Fechahasta)) gt 0)>
			<tr><td align="center"><strong>Hasta : </strong>#LSDateFormat(form.Fechahasta,'DD/MM/YYYY')#</td></tr>
	<cfelseif (isdefined("form.Fechadesde") and len(trim(form.Fechadesde)) gt 0)
		and (isdefined("form.Fechahasta") and len(trim(form.Fechahasta)) gt 0)>
			<tr><td align="center"><strong>Desde : </strong>#LSDateFormat(form.Fechadesde,'DD/MM/YYYY')#<strong> Hasta :</strong>#LSDateFormat(form.Fechahasta,'DD/MM/YYYY')#</td></tr>
	</cfif>
</table>
<br />
</cfoutput>
<table width="100%" border="0" cellpadding="2" cellspacing="0">
	
<cftry>
	<cf_jdbcquery_open name="data" datasource="#session.DSN#">
		<cfoutput>#myquery#</cfoutput>
	</cf_jdbcquery_open>
	
	<cfset registros = 0 >
	<cfset totalPeaje = 0 >
	<cfset totalGeneral = 0 >
	
	<cfoutput query="data" group="Peaje">
		<cfset registros = registros + 1 >
		<tr><td>&nbsp;</td></tr>
		<tr><td class="tituloListas" colspan="20">#trim(Peaje)#</td></tr>
		 <tr style="padding:10px;">
			<td style="padding:3px;font-size:9px" bgcolor="CCCCCC" nowrap="nowrap">Fecha</td>
			<td style="padding:3px;font-size:9px" bgcolor="CCCCCC" nowrap="nowrap">Tipo</td>
			<td style="padding:3px;font-size:9px" bgcolor="CCCCCC" nowrap="nowrap">Documento</td>		
			<td style="padding:3px;font-size:9px" bgcolor="CCCCCC" nowrap="nowrap">Descripci&oacute;n</td>
			<td style="padding:3px;font-size:9px" bgcolor="CCCCCC" nowrap="nowrap">Monto</td>
			<td style="padding:3px;font-size:9px" bgcolor="CCCCCC" nowrap="nowrap">Moneda</td>
		</tr>
		<cfoutput>
			<tr>
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#LSDateFormat(dia,'dd/mm/yyyy')#</td>
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#tipo_transaccion#</td>
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#documento#</td>
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#descripcion#</td>
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#LSNumberFormat(monto, ',9.00')#</td>
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#moneda#</td>
			</tr>	
			<cfset totalPeaje =  totalPeaje + monto>		
		</cfoutput>
		<tr>
		     <td nowrap="nowrap"><strong>Total peaje &nbsp;#LSNumberFormat(totalPeaje, ',9.00')#</strong>
			 </td>
		</tr>
    	<cfset totalGeneral = totalGeneral + totalPeaje >
		<cfset totalPeaje = 0 >
	</cfoutput>
		<cfcatch type="any">
			<cf_jdbcquery_close>
			<cfrethrow>
		</cfcatch>
</cftry>
	<cf_jdbcquery_close>
	
	<cfif registros gt 0 >
	<cfoutput>
	<tr><td>&nbsp;</td></tr>
	<tr>
	     <td nowrap="nowrap"><strong>Total General &nbsp;#LSNumberFormat(totalGeneral,',9.00')#</strong></td>
	</tr>
	</cfoutput>
	<cfelse>
		<tr><td colspan="30" align="center">--- No se encontraron registros ---</td></tr>
	</cfif>
	<tr><td>&nbsp;</td></tr>
	<tr><td colspan="30" align="center">--- Fin del Reporte ---</td></tr>
	<tr><td>&nbsp;</td></tr>	
</table>

