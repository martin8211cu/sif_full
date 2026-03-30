<!--- 
	Creado por Gustavo Fonseca H.
		Motivo: Nueva consulta para exportación a Excel del módulo de Activos Fijos.
		Fecha:16-5-2006.
 --->

<cfsavecontent variable="myQuery">
	<cfoutput>
		select 
			(select e.Edescripcion 
					from Empresas e
					where e.Ecodigo = b.Ecodigo
				)as Nombre_Compania,
		
			a.TAmes, 
			b.Aplaca as Placa, 
			b.Aserie as Serie,
			b.Adescripcion as Descripcion, 
			a.TAmontolocadq as MontoAdquisicion,
			
			(select eo.EOnumero  
							from AFResponsables af   
								 inner join EOrdenCM eo
								 on eo.EOidorden = af.EOidorden 
							where af.Aid =  b.Aid
								  and af.Ecodigo =  b.Ecodigo
								  and getdate() between af.AFRfini and af.AFRffin    
								  and b.Astatus =0
                      	)as Numero_Orden_Compra,
                      
             (select sn.SNnombre  
            		from AFResponsables af                    
                		 inner join EOrdenCM eo
                		 on eo.EOidorden = af.EOidorden
                  inner join SNegocios sn
                   	     on sn.SNcodigo = eo.SNcodigo
                         and sn.Ecodigo = b.Ecodigo 
                 
                where af.Aid =  b.Aid
                and af.Ecodigo =  b.Ecodigo
                and getdate() between af.AFRfini and af.AFRffin    
                and b.Astatus =0
				 
                      	) as Proveedor,
					  
		
			(select cf.CFdescripcion
				from CFuncional cf
				where cf.CFid = a.CFid) as CentroF,
			
			(select aa. AFCdescripcion
					from AFClasificaciones aa
					where aa.Ecodigo = b.Ecodigo
						and aa.AFCcodigo = b.AFCcodigo) as Tipo,
			(select  min(d.DEnombre)
				from AFResponsables afr
					inner join DatosEmpleado d
						on d.DEid = afr.DEid
				where afr.Aid = a.Aid
					and afr.Ecodigo = b.Ecodigo
					and <cf_dbfunction name="now"> between afr.AFRfini and afr.AFRffin
					) as Usuario_Responsable
		
		from TransaccionesActivos a
			inner join Activos b
				on b.Ecodigo = a.Ecodigo
				and b.Aid = a.Aid
				and b.Astatus = 0	
		where a.IDtrans = 1 <!--- Adquisiciones --->
			and a.Ecodigo = #session.Ecodigo#
			and a.TAperiodo = #url.periodoInicial#
			and a.TAmes
			between #url.mesInicial# and #url.mesFinal#
		order by 1,2
	</cfoutput>
</cfsavecontent>


<table width="100%" cellpadding="2" cellspacing="0">
	<tr style="padding:10px;">
		<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap"><strong>Nombre Compañ&iacute;a</strong></td>
		<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap"><strong>Placa</strong></td>
		<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap"><strong>Serie</strong></td>
		<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap"><strong>Descripci&oacute;n</strong></td>		
		<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap"><strong>Monto de Adquisici&oacute;n</strong></td>
		<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap"><strong>N&uacute;mero Orden Compra</strong></td>
		<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap"><strong>Proveedor</strong></td>
		<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap"><strong>Centro Funcional</strong></td>
		<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap"><strong>Tipo de Activo</strong></td>
		<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap"><strong>Usuario Responsable</strong></td>
		
	</tr>

<cftry>
	<!--- <cfset registros = 0 > --->
	<cfflush interval="16000">
	<cf_jdbcquery_open name="data" datasource="#session.DSN#">
	<cfoutput>#myquery#</cfoutput>
	</cf_jdbcquery_open>
	
	<cfoutput query="data">
			<tr>
				<td nowrap="nowrap">#Nombre_Compania#</td>
				<td>#Placa#</td>
				<td>#Serie#</td>
				<td>#Descripcion#</td>
				<td>#MontoAdquisicion#</td>
				<td>#Numero_Orden_Compra#</td>
				<td>#Proveedor#</td>
				<td>#CentroF#</td>
				<td>#Tipo#</td>
				<td>#Usuario_Responsable#</td>
			</tr>
	</cfoutput>
	
<cfcatch type="any">
	<cf_jdbcquery_close>
	<cfrethrow>
</cfcatch>
</cftry>
	<cf_jdbcquery_close>
	
	<!--- <cfif registros EQ 0 >
		<tr><td colspan="9" align="center">--- No se encontraron registros ---</td></tr>
	</cfif> --->
</table>	

