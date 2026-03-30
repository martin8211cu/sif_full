<cfset modo = 'ALTA'>
<cfif isdefined("form.ECidreb") and len(trim(form.ECidreb))>
	<cfset modo = 'CAMBIO'>
	<cfquery name="data" datasource="#session.DSN#">
		select ECid, ECidreb, Ecodigo, BMUsucodigo, RHCRporc_emp, RHCRporc_pat
		from RHCargasRebajar
		where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
		  and ECidreb = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECidreb#">
	</cfquery>
</cfif>	

<cfquery name="datacarga" datasource="#session.DSN#">
	select ECcodigo, ECdescripcion, ECprioridad
	from ECargas
	where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Carga"
		Default="Carga Obrero Patronal"
		returnvariable="LB_Carga"/>

		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Cargas_A_Rebajar"
		Default="Carga por rebajar"
		returnvariable="LB_Codigo_Excepcion"/>

		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_PorcentajeEmpleado"
		Default="Porcentaje Empleado"
		returnvariable="LB_PorcentajeEmpleado"/>	
		
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_PorcentajePatrono"
		Default="Porcentaje Patrono"
		returnvariable="LB_PorcentajePatrono"/>	
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Codigo"
			Default="C&oacute;digo"
			XmlFile="/rh/generales.xml"
			returnvariable="LB_Codigo"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Descripcion"
			Default="Descripci&oacute;n"
			XmlFile="/rh/generales.xml"
			returnvariable="LB_Descripcion"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_NoSeEncontraronCargasObreroPatronales"
			Default="No se encontraron Cargas Obrero Patronales"
			returnvariable="MSG_NoSeEncontraronCargasObreroPatronales"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ListaDeCargasObreroPatronales"
			Default="Lista de Cargas Obrero Patronales"
			returnvariable="MSG_ListaDeCargasObreroPatronales"/>

<cfoutput>
<form name="form1" method="post" action="cargas-excepcion-sql.cfm" style="margin:0;">
	<input type="hidden" name="ECid" value="#form.ECid#" />
	<table width="85%" align="center" cellpadding="3" cellspacing="0">
		<tr>
			<td width="1%" nowrap="nowrap" align="right"><strong>#LB_Carga#</strong>:</td>
			<td>#trim(datacarga.ECcodigo)# - #datacarga.ECdescripcion#</td>
		</tr>
		<tr>
			<td width="1%" nowrap="nowrap" align="right"><strong>#LB_Codigo_Excepcion#</strong>:</td>
			<td>
				<cfif modo eq 'ALTA'>
					<cf_conlis
						campos="ECidreb,ECcodigo,ECdescripcion"
						desplegables="N,S,S"
						modificables="N,S,N"
						size="0,10,25"
						title="#MSG_ListaDeCargasObreroPatronales#"
						tabla="ECargas a"
						columnas="a.ECid as ECidreb,a.ECcodigo,a.ECdescripcion"
						filtro="	a.Ecodigo=#SESSION.ECODIGO# 
									and a.ECprioridad < #datacarga.ECprioridad# 
									and not exists ( select 1
													 from RHCargasRebajar
													 where ECidreb=a.ECid
													 and ECid=#form.ECid# )
									order by a.ECcodigo"
						desplegar="ECcodigo,ECdescripcion"
						filtrar_por="ECcodigo, ECdescripcion"
						etiquetas="#LB_Codigo#, #LB_Descripcion#"
						formatos="S,S"
						align="left,left"
						asignar="ECidreb, ECcodigo, ECdescripcion"
						asignarformatos="S, S, S"
						showEmptyListMsg="true"
						EmptyListMsg="-- #MSG_NoSeEncontraronCargasObreroPatronales# --"
						tabindex="1">
				<cfelse>
					<cfquery name="datacargareb" datasource="#session.DSN#">
						select ECcodigo, ECdescripcion, ECprioridad
						from ECargas
						where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECidreb#">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfquery>
					#trim(datacargareb.ECcodigo)# - #datacargareb.ECdescripcion#
					<input type="hidden" name="ECidreb" value="#form.ECidreb#" />
				</cfif>
			</td>
		</tr>
	
		<cfset pctEmpl = 100.00 >
		<cfif isdefined("data.RHCRporc_emp") and len(trim(data.RHCRporc_emp))>
			<cfset pctEmpl = data.RHCRporc_emp >
		</cfif>
		<tr>
			<td width="1%" nowrap="nowrap" align="right"><strong>#LB_PorcentajeEmpleado#</strong>:</td>
			<td><cf_monto name="RHCRporc_emp" size="6" value="#pctEmpl#"></td>
		</tr>
		<cfset pctPatr = 100.00 >
		<cfif isdefined("data.RHCRporc_pat") and len(trim(data.RHCRporc_pat))>
			<cfset pctPatr = data.RHCRporc_pat >
		</cfif>
		<tr>
			<td width="1%" nowrap="nowrap" align="right"><strong>#LB_PorcentajePatrono#</strong>:</td>
			<td><cf_monto name="RHCRporc_pat"  size="6" value="#pctPatr#"></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		
		<tr><td colspan="2"><cf_botones modo="#modo#" include="Regresar"></td></tr>	
		
	</table>
</form>

<cf_qforms>
<script language="javascript1.2" type="text/javascript">
	objForm.ECidreb.required = true;
	objForm.ECidreb.description = '#LB_Codigo_Excepcion#';

	objForm.RHCRporc_emp.required = true;
	objForm.RHCRporc_emp.description = '#LB_PorcentajeEmpleado#';

	objForm.RHCRporc_pat.required = true;
	objForm.RHCRporc_pat.description = '#LB_PorcentajePatrono#';

	function funcRegresar(){
		deshabilitarValidacion();
		document.form1.action = 'CargasOP.cfm';
	}
	
	function deshabilitarValidacion(){
		objForm.ECidreb.required = false;
		objForm.RHCRporc_emp.required = false;
		objForm.RHCRporc_pat.required = false;
	}


</script>



</cfoutput>