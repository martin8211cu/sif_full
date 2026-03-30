<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>
<script type="text/javascript" language="javascript1.2" src="../../js/utilesMonto.js"></script>

<cf_dbfunction name="OP_concat" returnvariable="CAT">

<cfset rsdata.CPPFid_padre = "">
<cfoutput>
	<cfset modo='ALTA'>
	<cfif isdefined("form.CPPFid") and len(trim(form.CPPFid))>
		<cfset modo = 'CAMBIO'> 
	</cfif>
	<cfif modo NEQ 'ALTA'>
		<cfquery name = "rsdata" datasource="#session.DSN#">
			select 	CPPFid_padre, CPPFid, CPPFcodigo, CPPFdescripcion, CPPFporCF, CPPFconSubproyectos, ts_rversion,
					CPPFconFinanciamiento,
					(select rtrim(CPPFcodigo) #CAT# ' - ' #CAT# CPPFdescripcion from CPproyectosFinanciados where CPPFid = a.CPPFid_padre) as Padre
			  from CPproyectosFinanciados a
			 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value = "#session.ecodigo#" >
			   and CPPFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPFid#">
		</cfquery>
	</cfif>
	<form name="form1" method="post" action="ProyectosFinanciamiento_sql.cfm">
		<cfif modo NEQ 'ALTA'>
			<input type = "hidden" name="CPPFid" value="#rsdata.CPPFid#">
		</cfif>	
		<table width="98%" border="0" cellpadding="0" cellspacing="2%">			
			<cfif rsdata.CPPFid_padre NEQ "">
				<tr>
					<td width="24%" align="right" nowrap><strong>PROYECTO: </strong> </td>	
					<td colspan="3">
						<strong>#rsdata.Padre#</strong>
					</td>	
				</tr>
			</cfif>
			<tr>
				<td width="24%" align="right" nowrap><strong>Código: </strong> </td>	
			  	<td colspan="3">
					<input name="CPPFcodigo" type="text" size="10" maxlength="10" value="<cfif modo neq 'ALTA'>#rsdata.CPPFcodigo#</cfif>" alt="Codigo"> 	
			    </td>	
			</tr>
            <tr>
				<td width="24%" align="right" nowrap><strong>Descripción: </strong> </td>	
				<td colspan="5">
					<input name="CPPFdescripcion" type="text" size="50" maxlength="80" value="<cfif modo neq 'ALTA'>#rsdata.CPPFdescripcion#</cfif>">
				</td>	
			</tr>
			<cfif rsdata.CPPFid_padre NEQ "">
				<tr>
					<td  align="right" nowrap>
					</td>		
					<td>					
						<input type="checkbox" name="CPPFconFinanciamiento" value="1" <cfif modo neq 'ALTA' and rsdata.CPPFconFinanciamiento EQ 1> checked </cfif>>
						<strong>Requiere Financiamiento</strong>
					</td>	
				</tr>
			<cfelse>
				<tr>
					<td  align="right" nowrap>
					</td>		
					<td>
						<input type="hidden" name="CPPFconFinanciamiento" value="1">
						<cfset rsdata.CPPFconFinanciamiento = 1>
						<input type="checkbox" name="CPPFporCF" value="1" <cfif modo neq 'ALTA' and rsdata.CPPFporCF EQ 1> checked </cfif>>
						<strong>Por Centro Funcional</strong>
					</td>	
				</tr>
				<tr>
					<td  align="right" nowrap>
					</td>		
					<td>					
						<input type="checkbox" name="CPPFconSubproyectos" value="1" <cfif modo neq 'ALTA' and rsdata.CPPFconSubproyectos EQ 1> checked </cfif>>
						<strong>Con Subproyectos</strong>
					</td>	
				</tr>
			</cfif>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="6" align="center">
					<cfinclude template="../../portlets/pBotones.cfm">
					<cfif rsdata.CPPFid_padre NEQ "">
						<input type="button" value="Regresar Proyecto" onclick="location.href='ProyectosFinanciamiento.cfm?CPPFid=#rsdata.CPPFid_padre#'" />
					</cfif>
				</td>	
		   </tr>
           <tr><td>&nbsp;</td></tr>
	</table>
	<cfif modo NEQ "ALTA">
		<cfset ts = "">
		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp= "#rsdata.ts_rversion#" returnvariable="ts">
		</cfinvoke>
           <input type="hidden" name = "ts_rversion" value ="#ts#">
		<strong>Periodo de Presupuesto:&nbsp;</strong>
		<cfif isdefined("url.CPPid")><cfset form.CPPid = url.CPPid></cfif>
		<cf_cboCPPid onchange="location.href='ProyectosFinanciamiento.cfm?CPPFid=#form.CPPFid#&CPPid='+ this.value;" session="true">
	</cfif>
</form> 
<script language="JavaScript1.2" type="text/javascript">					
	qFormAPI.errorColor = "##FFFFCC";
	objForm = new qForm("form1");
	
	// Funcion para validar que el porcentaje digitado no sea mayor a100
	function _mayor(){	
		if ( new Number(qf(this.value)) > 100 ){
			this.error = 'El campo no puede ser mayor a 100';
			this.value = '';
		}
	}
	
	// Validaciones para los campos de % no sean mayores a 100 		
	_addValidator("ismayor", _mayor);
	
	//Validaciones de los campos requeridos	
	objForm.CPPFcodigo.required = true;
	objForm.CPPFcodigo.description="Codigo";
	
	objForm.CPPFdescripcion.required = true;
	objForm.CPPFdescripcion.description="Descripción";
									
	function deshabilitarValidacion(){
		objForm.CPPFcodigo.required = false;
		objForm.CPPFdescripcion.required = false;
	}
</script>
</cfoutput>

<cfif modo NEQ 'ALTA'>
	<cfparam name="url.tab" default="1">
	<cf_tabs>
		<cf_tab text="Cuentas" selected="#url.tab EQ 1#">
			<cfinclude template="ProyectosFinanciamiento_tab1.cfm">
		</cf_tab>
		<cfif rsData.CPPFporCF EQ 1>
			<cf_tab text="Centros Funcionales" selected="#url.tab EQ 2#">
				<cfinclude template="ProyectosFinanciamiento_tab2.cfm">
			</cf_tab>
		</cfif>
		<cfif rsData.CPPFconSubproyectos EQ 1>
			<cf_tab text="Subproyectos" selected="#url.tab EQ 3#">
				<cfinclude template="ProyectosFinanciamiento_tab3.cfm">
			</cf_tab>
		</cfif>
	</cf_tabs>
</cfif>