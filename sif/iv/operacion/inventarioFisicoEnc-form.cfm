<!--- Datos del Encabezado --->
<cfquery name="dataEncabezado" datasource="#session.DSN#">
	select Aid, 
		   EFdescripcion, 
		   EFfecha,
		   ts_rversion
	from EFisico
	where EFid = <cfif modo neq 'ALTA'><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EFid#"><cfelse>0</cfif>
</cfquery>

<cfset vId = 0 >
<cfif len(trim(dataEncabezado.Aid)) >
	<cfset vId = dataEncabezado.Aid  >
</cfif>

<cfset vFecha = LSDateFormat(now(), 'dd/mm/yyyy')>
<cfif len(trim(dataEncabezado.EFfecha)) >
	<cfset vFecha = LSDateFormat(dataEncabezado.EFfecha, 'dd/mm/yyyy')  >
</cfif>

<!-- 2. Combo Almacen -->
<cfquery datasource="#session.DSN#" name="rsAlmacen">
	select A.Aid, A.Bdescripcion
	from Almacen A
    	inner join AResponsables R
           on R.Aid = A.Aid
           and A.Ecodigo =  R.Ecodigo
	where A.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" > 
     and R.Usucodigo = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_integer" > 
	order by Bdescripcion
</cfquery>

<cfoutput>
<table width="98%" align="center" cellpadding="2" cellspacing="0">
	<tr>
		<td width="1%"><strong>Almac&eacute;n:</strong>&nbsp;</td>
		<td>
			<cfif modo neq 'ALTA'>
				<input type="hidden" name="Aid" value="#dataEncabezado.Aid#"  tabindex="-1"/>
				<cfquery name="rsAlmacen" datasource="#session.DSN#">
					select Almcodigo, Bdescripcion
					from Almacen
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataEncabezado.Aid#">
				</cfquery>
				#trim(rsAlmacen.Almcodigo)# - #rsAlmacen.Bdescripcion#
			<cfelse>
				<cfif rsAlmacen.recordcount eq 0>
                	<script>
							alert("El usuario no tiene Almacenes asociados, debe de ir al Catalogo y asociarle el Almacén.")
					</script>
                <cfelse>
				<select name="Aid" tabindex="1">
					<cfloop query="rsAlmacen">					
						<option value="#rsAlmacen.Aid#">#rsAlmacen.Bdescripcion#</option>
					</cfloop>						
				</select>
                </cfif>
			</cfif>
		</td>
		
		<td width="1%"><strong>Descripci&oacute;n:</strong>&nbsp;</td>
		<td><input type="text" name="EFdescripcion" size="40" maxlength="80"  tabindex="1" value="<cfif modo neq 'ALTA'>#dataEncabezado.EFdescripcion#</cfif>"></td>
		<td width="1%"><strong>Fecha:</strong>&nbsp;</td>
		<td><cf_sifcalendario name="EFfecha" value="#vFecha#"  tabindex="1" ></td>
	</tr>
</table> 

<!--- timestamp encabezado --->
<cfset ts = "">	
<cfif modo neq "ALTA">
	<cfinvoke 
		component="sif/Componentes/DButils" 
		method="toTimeStamp" 
		arTimeStamp="#dataEncabezado.ts_rversion#" 
		returnvariable="ts">
	</cfinvoke>
	<input type="hidden" name="ts_rversion" value="#ts#"  tabindex="-1">
</cfif>

</cfoutput>