<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	function validar(f){
		f.obj.EDvid.disabled = false;
		return true;
	}

	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_EquipoDivisionPersona"
Default="Equipo Divisi&oacute;n Persona"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="LB_EquipoDivisionPersona"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="CMB_Seleccionar"
Default="Seleccionar"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="CMB_Seleccionar"/>

<!--- Consultas --->
<cfif modo neq 'ALTA'>
	<!--- Form --->
	 <cfquery name="rsForm" datasource="#session.DSN#">
		select EDPid, Ecodigo,TPid, EDPdesde, EDPhasta, EDPnumero, DEid, EDvid, EDPposicion, EDPnumero, ts_rversion
		from EquipoDivPersona
		where EDPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDPid#">
	</cfquery>
</cfif>

	
	<cfoutput>
	<cf_templateheader title="#LB_EquipoDivisionPersona#">
		<table width="100%" cellpadding="1" cellspacing="0">
			<tr>
				<td valign="top">	
					<cf_web_portlet_start border="true" titulo="#LB_EquipoDivisionPersona#"> 
					<form name="form1" method="post" action="eqdivper-sql.cfm" onSubmit="return validar(this);">
							<table width="75%" align="center" cellpadding="2">
							<tr><td>&nbsp;</td></tr>
								<tr>
									<td align="right" width="35%"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_EquipoDivision">Equipo División</cf_translate>:</strong></td>
									<td> <cf_equipodivision> </td>
								<tr>
									<td align="right" width="35%"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Persona">Persona</cf_translate>:</strong></td>
		<td nowrap>
			<cf_EDpersonas>
		</td> 
								</tr>
								<tr>
								<td align="right"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_RoldelaPersona">Rol de la Persona</cf_translate>:</strong></td>
								<td><cf_RolPersonas></td> 
								<tr>
								<td align="right"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Posicion">Posici&oacute;n</cf_translate>:</strong></td> 
							<td><input type="text" name="EDPposicion" tabindex="1" value="<cfif modo eq 'CAMBIO'>#rsForm.EDPposicion# </cfif>" size="20" maxlength="60" onFocus="javascript:this.select();"></td>
								<tr>
								<tr>
								<td align="right"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_NumerodeCamiseta">Numero de Camiseta</cf_translate>:</strong></td> 
							<td><input type="text" name="EDPnumero" tabindex="1" value="<cfif modo eq 'CAMBIO'>#rsForm.EDPnumero#</cfif>"
								 size="20" maxlength="60" onFocus="javascript:this.select();" ></td>
								<input type="hidden" name="EDPid" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.EDPid#</cfoutput></cfif>"><cfset ts = "">	
		<cfif modo neq "ALTA">
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
		</cfif>
		<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>">
								<tr>
									<td align="right"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_FechadeEntrada">Fecha de Entrada</cf_translate>:</strong></td>
									<td><cfif modo eq "CAMBIO">
						<cf_sifcalendario form="form1" name="EDPdesde" value="#LSDateFormat(rsForm.EDPdesde,'DD/MM/YYYY')#">
					<cfelse>
						<cf_sifcalendario name="EDPdesde">
					</cfif></td>
								</tr>
								<tr>
									<td align="right"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_FechadeSalida">Fecha de Salida</cf_translate>:</strong></td>
									<td><cfif modo eq "CAMBIO">
						<cf_sifcalendario form="form1" name="EDPhasta" value="#LSDateFormat(rsForm.EDPhasta,'DD/MM/YYYY')#">
					<cfelse>
						<cf_sifcalendario name="EDPhasta">
					</cfif></td>
								</tr>
								<tr>
									<td align="right"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_EquipoalquePertenece">Equipo al que Pertenece</cf_translate>:</strong></td>
								  <td>
		<cf_equipo>
		  </td>
		  </tr>
		  <tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center">
				<cfset tabindex="1">
				<cfinclude template="/rh/portlets/pBotones.cfm">
			</td>
		</tr>
								
							</table>
						</form>
					
					
				</td>	
			</tr>
		</table>	</cfoutput>
		<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EquipoDivision"
	Default="Equipo División"
	XmlFile="/rh/ExpDeportivo/generales.xml"
	returnvariable="MSG_EquipoDivision"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Persona"
	Default="Persona"
	XmlFile="/rh/ExpDeportivo/generales.xml"
	returnvariable="MSG_Persona"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_RoldelaPersona"
	Default="Rol de la Persona"
	XmlFile="/rh/ExpDeportivo/generales.xml"
	returnvariable="MSG_RoldelaPersona"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_FechadeEntrada"
	Default="Fecha de Entrada"
	XmlFile="/rh/ExpDeportivo/generales.xml"
	returnvariable="MSG_FechadeEntrada"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_FechadeSalida"
	Default="Fecha de Salida"
	XmlFile="/rh/ExpDeportivo/generales.xml"
	returnvariable="MSG_FechadeSalida"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EquipoalquePertenece"
	Default="Equipo al que Pertenece"
	XmlFile="/rh/ExpDeportivo/generales.xml"
	returnvariable="MSG_EquipoalquePertenece"/>

<script language="JavaScript1.2" type="text/javascript">
	<cfif modo NEQ 'ALTA'>
		document.form1.EDvid.focus();
	<cfelse>
		document.form1.Ecodigo.focus();
	</cfif>

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	<cfoutput>
		objForm.EDvid.required = true;
		objForm.EDvid.description="#MSG_EquipoDivision#";
		objForm.DEnombre.required = true;
		objForm.DEnombre.description="#MSG_Persona#";
		objForm.TPid.required = true;
		objForm.TPid.description="#MSG_RoldelaPersona#";
		objForm.EDPdesde.required = true;
		objForm.EDPdesde.description="#MSG_FechadeEntrada#";
		objForm.EDPhasta.required = true;
		objForm.EDPhasta.description="#MSG_FechadeSalida#";
		objForm.Ecodigo.required = true;
		objForm.Ecodigo.description="#MSG_EquipoalquePertenece#";
	</cfoutput>

	function deshabilitarValidacion(){
		objForm.EDvid.required = false;
		objForm.DEnombre.required = false;
		objForm.TPid.required = false;
		objForm.EDPdesde.required = false;
		objForm.EDPhasta.required = false;
		objForm.Ecodigo.required = false;
	}
	
</script>

					
	
	
	<cf_web_portlet_end> 	
		
			
	<cf_templatefooter>
	
							
