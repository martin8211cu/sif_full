<cfquery name="rsAccion" datasource="#session.DSN#">
	select 	a.RHPcodigo,
			a.Ecodigo as Empresa,
			a.Tcodigo as TipoNomina,
			a.RVid as RegimenVacaciones,	
			a.Ocodigo as Oficina,
			a.Dcodigo as Depto,
			a.RHPid as Plaza,
			a.RHPcodigo as Puesto,
			a.RHAporcsal as PorcSalarioFijo,
			a.RHJid as Jornada,
			a.DEid	
	from RHAcciones a
	where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAlinea#">
</cfquery>

<cfquery name="rsActual" datasource="#session.DSN#">
	select 	Ecodigo as Empresa,
			Tcodigo as TipoNomina,
			RVid as RegimenVacaciones,
			Ocodigo as Oficina,
			Dcodigo as Depto,
			RHPid as Plaza,
			RHPcodigo as Puesto,
			LTporcsal as PorcSalarioFijo,
			RHJid as Jornada
			
	from LineaTiempo a
	where <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.DLfvigencia)#"> between a.LTdesde and a.LThasta
		and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
</cfquery>


<cfquery name="rsTipoAccion" datasource="#session.DSN#">
	select 	b.RHTid, b.RHTcodigo,
			b.RHTcempresa as CEmpresa,
			b.RHTctiponomina as CTiponomina,
			b.RHTcregimenv as CRegimenvacaciones,
			b.RHTcoficina as COficina,
			b.RHTcdepto as CDepto,
			b.RHTcplaza as CPlaza,
			b.RHTcpuesto as CPuesto,
			b.RHTcsalariofijo as CSalariofijo,
			b.RHTcjornada as CJornada
	from RHTipoAccion b
	where RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTid#">
</cfquery>

<!----==================== TRADUCCION ====================---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Empresa"
	Default="Empresa"	
	returnvariable="LB_Empresa"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Tipo_Nomina"
	Default="Tipo Nómina"	
	returnvariable="LB_Tipo_Nomina"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Regimen_de_vacaciones"
	Default="Régimen de vacaciones"	
	returnvariable="LB_Regimen_de_vacaciones"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Oficina"
	Default="Oficina"	
	returnvariable="LB_Oficina"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Departamento"
	Default="Departamento"	
	returnvariable="LB_Departamento"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Plaza"
	Default="Plaza"	
	returnvariable="LB_Plaza"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Puesto"
	Default="Puesto"	
	returnvariable="LB_Puesto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Porc_Salario_fijo"
	Default="% Salario fijo"	
	returnvariable="LB_Porc_Salario_fijo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Jornada"
	Default="Jornada"	
	returnvariable="LB_Jornada"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_La_accion_no_se_puede_aplicar_porque_los_siguientes_valores_no_son_modificables"
	Default="La acci&oacute;n no se puede aplicar porque los siguientes valores no son modificables:"	
	returnvariable="MSG_Error"/>


<cfset va_errores = ''>

<cfif rsTipoAccion.RecordCount NEQ 0 and rsAccion.RecordCount NEQ 0 and rsActual.RecordCount NEQ 0>
	<!----NO Cambiar Empresa---->
	<cfif rsTipoAccion.CEmpresa EQ 0>
		<cfif trim(rsActual.Empresa) NEQ trim(rsAccion.Empresa)>
			<cfset va_errores = ListAppend(va_errores, '#LB_Empresa#')>
		</cfif>
	</cfif>
	<!----NO Cambiar Tipo nomina---->
	<cfif rsTipoAccion.CTiponomina EQ 0>
		<cfif trim(rsActual.TipoNomina) NEQ trim(rsAccion.TipoNomina)>
			<cfset va_errores = ListAppend(va_errores, '#LB_Tipo_Nomina#')>
		</cfif>
	</cfif> 
	<!----NO Cambiar Regimen de vacaciones---->
	<cfif rsTipoAccion.CRegimenvacaciones EQ 0>
		<cfif trim(rsActual.RegimenVacaciones) NEQ trim(rsAccion.RegimenVacaciones)>
			<cfset va_errores = ListAppend(va_errores, '#LB_Regimen_de_vacaciones#')>
		</cfif>
	</cfif>
	<!----NO Cambiar Oficina---->
	<cfif rsTipoAccion.COficina EQ 0>
		<cfif trim(rsActual.Oficina) NEQ trim(rsAccion.Oficina)>
			<cfset va_errores = ListAppend(va_errores, '#LB_Oficina#')>
		</cfif>
	</cfif>
	<!----NO Cambiar Depto---->
	<cfif rsTipoAccion.CDepto EQ 0>
		<cfif trim(rsActual.Depto) NEQ trim(rsAccion.Depto)>
			<cfset va_errores = ListAppend(va_errores, '#LB_Departamento#')>
		</cfif>
	</cfif>
	<!----NO Cambiar Plaza---->
	<cfif rsTipoAccion.CPlaza EQ 0>
		<cfif trim(rsActual.Plaza) NEQ trim(rsAccion.Plaza)>
			<cfset va_errores = ListAppend(va_errores, '#LB_Plaza#')>
		</cfif>
	</cfif>
	<!----NO Cambiar Puesto---->
	<cfif rsTipoAccion.CPuesto EQ 0>
		<cfif trim(rsActual.Puesto) NEQ trim(rsAccion.Puesto)>
			<cfset va_errores = ListAppend(va_errores, '#LB_Puesto#')>
		</cfif>
	</cfif>	
	<!----NO Cambiar  % Salario fijo---->
	
	<!--- 
	<cfif rsTipoAccion.CSalariofijo EQ 0>
		<cfif trim(rsActual.PorcSalarioFijo) NEQ trim(rsAccion.PorcSalarioFijo)>
			<cfset va_errores = ListAppend(va_errores, '#LB_Porc_Salario_fijo#')>
		</cfif>
	</cfif>
	 --->
	
	<!----NO Cambiar Jornada ---->
	<cfif rsTipoAccion.CJornada EQ 0>
		<cfif trim(rsActual.Jornada) NEQ trim(rsAccion.Jornada)>
			<cfset va_errores = ListAppend(va_errores, '#LB_Jornada#')>
		</cfif>
	</cfif>
</cfif>

<cfif len(trim(va_errores))>
	<cf_throw message="#MSG_Error# #va_errores#." errorCode="1095">
<cfelse>
	<!---- ================ Se actualiza el puesto de la plaza de RH (RHPlazas) ================----->			
   <cfif isdefined("form.RHPid") and len(trim(form.RHPid)) and isdefined("rsAccion") and len(trim(rsAccion.RHPcodigo))>
	   <cfquery name="UpdatePuesto" datasource="#session.DSN#">
			<!----Update de plaza RH ----->
			update RHPlazas
				set RHPpuesto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAccion.RHPcodigo#">
			where RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPid#">   				
	   </cfquery>
   </cfif>
</cfif>