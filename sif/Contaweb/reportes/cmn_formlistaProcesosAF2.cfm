<!--- 
Tipo de Proceso
1.Plantas y Centrales
2.Inmovilizados
3.Relaciones 
--->

<cfquery datasource="#session.Conta.dsn#"  name="sql" >	
	select  id, (case when tipo_proceso = 1 then 'Dep. Plantas y Centrales' 
					 when tipo_proceso = 2 then 'Dep. Inmovilizados'
					 when tipo_proceso = 3 then 'Apl. Relaciones'
				end) Proceso,
				(case when estado = 'E' then 'En proceso'  
					  when estado = 'P' then 'Pendiente' 
					  when estado = 'L' then 'Listo'
					  when estado = 'C' then 'Error'
				end) status,
	convert(varchar(10), fecha,103) fechasolic,	horageneracion,	Detalle	
	from  tbl_transaccionescf
	where usuario = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(url.USUARIO)#">
	and  estado   = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(url.status)#">
	order by id desc
</cfquery>
<cfoutput>
	<table width="100%" border="0">
		<tr>
			<td  align="center" width="5%"></td>
			<td  bgcolor="##CCCCCC" colspan="3" align="center"><strong>Tarea</strong></td>
			<td  bgcolor="##CCCCCC" colspan="6" align="center"><strong>Parámetros</strong></td>

		</tr>	
		<tr>
			<td  align="center"></td>
			<td  bgcolor="##CCCCCC" align="center" width="5%"><strong>Num.</strong></td>
			<td  bgcolor="##CCCCCC" align="center"><strong>Fecha</strong></td>
			<td  bgcolor="##CCCCCC" align="center"><strong>hora</strong></td>
			<td  bgcolor="##CCCCCC" align="center"><strong>Tipo Proceso</strong></td>
			<td  bgcolor="##CCCCCC" align="center"><strong>Detalle</strong></td>
		</tr>
		
		
		<cfif sql.recordcount gt 0>
		    
			<cfloop query="sql">
				<tr>	<!--- 								
					<cfif trim(sql.status) eq "Listo" and trim(sql.Proceso) neq "Apl. Relaciones">
						<td align="center">
						<a href="##">
						<img border="0" src="imagenes/Cfinclude.gif" onClick="BJ_ARCH('<nombrearchivo>','#sql.id#')">
						</a>
						</td>
					<cfelse> --->
						<td align="center"> <img src="imagenes/RepeatedRegion.gif" ></td>
					<!--- </cfif> --->
					<cfif trim(sql.status) eq "Listo" and trim(sql.Proceso) neq "Apl. Relaciones">
						<td  align="center">#sql.id#</td>
					<cfelse>
						<td  align="center">#sql.id#</td>
					</cfif>
					<td  align="center">#sql.fechasolic#</td>
					<td  align="center">#TimeFormat(sql.horageneracion,"hh:mm:ss")#</td>
					<td  align="center">#sql.Proceso#</td>
					<td  align="center">#sql.Detalle#</td>					
				</tr>
			</cfloop>
			
		</cfif>
	</table>
</cfoutput>

<script>window.setInterval("location.reload()",15000);</script>