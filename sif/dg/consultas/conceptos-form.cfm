<cfif isdefined("url.DGCcodigo") and not isdefined("form.DGCcodigo") >
	<cfset form.DGCcodigo = url.DGCcodigo >
</cfif>
<cfif isdefined("url.DGCcodigo2") and not isdefined("form.DGCcodigo2") >
	<cfset form.DGCcodigo2 = url.DGCcodigo2 >
</cfif>
<cfif isdefined("url.DGtipo") and not isdefined("form.DGtipo") >
	<cfset form.DGtipo = url.DGtipo >
</cfif>
<cfif isdefined("url.Comportamiento") and not isdefined("form.Comportamiento") >
	<cfset form.Comportamiento = url.Comportamiento >
</cfif>
<cfif isdefined("url.referencia") and not isdefined("form.referencia") >
	<cfset form.referencia = url.referencia >
</cfif>

<cfif form.DGCcodigo gt form.DGCcodigo2>
	<cfset tmp = form.DGCcodigo >
	<cfset form.DGCcodigo = form.DGCcodigo2 >
	<cfset form.DGCcodigo2 = tmp >	
</cfif>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="data" datasource="#session.DSN#">
	select  a.DGCid, 
			a.DGCcodigo #_Cat# ' - ' #_Cat#a.DGdescripcion as codigo, 
			a.CEcodigo, 
			case a.DGtipo when 'I' then 'Ingreso' else 'Gasto' end as DGtipo, 
			case a.Comportamiento when 'O' then 'Objeto de Gasto' else 'Producto' end as Comportamiento, 
			case a.referencia when 10 then 'Ventas' 
							  when 20 then 'Costo de Ventas' 
							  when 30 then 'Otros Ingresos de Operaci&oacute;n' 
							  when 40 then 'Gastos Directos' 
							  when 41 then 'Gastos Indirectos' 
							  when 50 then 'Otros Gastos Deducibles' 
							  when 60 then 'Asignaci&oacute;n Gastos Administrativos' 
							  when 70 then 'Otros Ingresos No Gravables' 
							  when 80 then 'Otros Gastos No Deducibles' 
							  when 90 then 'Impuestos' 							  
			end as referencia
			
	from DGConceptosER a	
	where 1 = 1 

	<cfif isdefined("form.DGCcodigo") and len(trim(form.DGCcodigo)) and isdefined("form.DGCcodigo2") and len(trim(form.DGCcodigo2))>
		and a.DGCcodigo between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGCcodigo#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGCcodigo2#">
	<cfelseif isdefined("form.DGCcodigo") and len(trim(form.DGCcodigo))>
		and a.DGCcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGCcodigo#">
	<cfelseif isdefined("form.DGCcodigo2") and len(trim(form.DGCcodigo2))>
		and a.DGCcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGCcodigo2#">
	</cfif>	
	
	<cfif isdefined("form.DGtipo") and len(trim(form.DGtipo))>
		and a.DGtipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGtipo#">
	</cfif>	
	
	<cfif isdefined("form.Comportamiento") and len(trim(form.Comportamiento))>
		and a.Comportamiento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Comportamiento#">
	</cfif>	
	
	<cfif isdefined("form.referencia") and len(trim(form.referencia))>
		and a.referencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.referencia#">
	</cfif>		

</cfquery>

<cf_templatecss>

<cfoutput>
<br>
<table width="100%" cellpadding="0" cellspacing="0" align="center">
	<tr><td align="center" ><span class="titulox"><strong><font size="2">#session.Enombre#</font></strong></span></td></tr>
	<tr><td align="center"><strong>Listado de Conceptos de Estado de Resultados</strong></td></tr>
</table>
<br>
</cfoutput>

<table width="98%" align="center" cellpadding="2" cellspacing="0">
	<tr>
		<td bgcolor="#CCCCCC" colspan="2"><strong>Concepto</strong></td>
		<td bgcolor="#CCCCCC"><strong>Tipo</strong></td>
		<td bgcolor="#CCCCCC"><strong>Comportamiento</strong></td>
		<td bgcolor="#CCCCCC"><strong>Referencia</strong></td>
	</tr>
	
	<cfoutput query="data">
		<tr bgcolor="##F3F3F3">
			<td colspan="2">#data.codigo#</td>
			<td>#data.DGtipo#</td>
			<td>#data.Comportamiento#</td>
			<td>#data.referencia#</td>		
		</tr>
		
		<cfquery name="data_cuentas" datasource="#session.DSN#">
			select 
				  a.DGCid as concepto, 
				   a.Cmayor as cuenta, 
				   ((
				   	select min(b.Cdescripcion) 
				   	from Empresas e
					   inner join CtasMayor b 
					   		on b.Ecodigo = e.Ecodigo
					 where e.cliente_empresarial = #session.CEcodigo#
					 and b.Cmayor = a.Cmayor
					)) as descripcion
			from DGCuentasConcepto a
			where a.DGCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.DGCid#" >
			order by a.Cmayor
		</cfquery>

		<cfif data_cuentas.recordcount gt 0>
			<tr>
				<td colspan="5">
						<tr>
							<td colspan="4" bgcolor="##C8c8c8" class="tituloListas" style="border-bottom: 1px solid ##B8B8B8;">Cuentas asociadas</td>
						</tr>
						<cfloop query="data_cuentas">
							<tr>
								<tr>
									<td></td>
									<td colspan="4">#trim(data_cuentas.cuenta)# - #data_cuentas.descripcion#</td>
								</tr>
							</tr>
						</cfloop>
					</table>
				</td>
			</tr>
			<TR><TD colspan="5" style="border-bottom:1px solid ##B8B8B8; ">&nbsp;</TD></TR>
			<TR><TD>&nbsp;</TD></TR>			
		<cfelse>
			<tr>
				<td colspan="5">
						<tr>
							<td colspan="4" bgcolor="##C8c8c8" class="tituloListas" style="border-bottom: 1px solid ##B8B8B8;">Cuentas asociadas</td>
						</tr>
							<tr>
								<tr>
									<td></td>
									<td colspan="4"><i>No hay cuentas asociadas al concepto</i></td>
								</tr>
							</tr>
					</table>
				</td>
			</tr>
			<TR><TD colspan="5" style="border-bottom:1px solid ##B8B8B8; ">&nbsp;</TD></TR>
			<TR><TD>&nbsp;</TD></TR>
		</cfif>
		
	</cfoutput>
	<cfif data.recordcount eq 0>
		<TR><TD>&nbsp;</TD></TR>
		<TR><TD colspan="5" align="center">--- No se encontraron registros ---</TD></TR>
		<TR><TD>&nbsp;</TD></TR>	
	<cfelse>
		<TR><TD>&nbsp;</TD></TR>
		<TR><TD colspan="5" align="center">--- Fin del reporte ---</TD></TR>
		<TR><TD>&nbsp;</TD></TR>	
	</cfif>
</table>