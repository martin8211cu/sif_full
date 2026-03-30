<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif modo NEQ "ALTA">
	<cfquery name="rsZonaCobro" datasource="#Session.DSN#">
		select *
		from ZonaCobroSNegocios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and ZCSNcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.ZCSNcodigo#" >		  
		order by ZCSNcodigo asc 
	</cfquery>
</cfif>

<cfquery name="rsCodigos" datasource="#session.DSN#">
	select ZCSNcodigo
	from ZonaCobroSNegocios
</cfquery>

<cf_templatecss>

<body>
<form action="SQLZonaCobro.cfm" method="post" name="form1">
	<table width="100%" align="center">
		<tr> 
			<td align="right" valign="middle" nowrap> C&oacute;digo:</td>
			<td> 
				<input  name="ZCSNcodigo" type="text" tabindex="1" 
				value="<cfif modo NEQ "ALTA"><cfoutput>#rsZonaCobro.ZCSNcodigo#</cfoutput></cfif>" size="4" 
				maxlength="4" alt="El campo Código de la Zona de Cobro">
				<div align="right"></div>
			</td>
		</tr>
		<tr> 
			<td align="right" valign="middle" nowrap>Descripci&oacute;n:</td>
			<td> 
				<input name="ZCSNdescripcion" type="text" tabindex="1" 
				value="<cfif modo NEQ "ALTA"><cfoutput>#rsZonaCobro.ZCSNdescripcion#</cfoutput></cfif>" size="50" 
				maxlength="80"  alt="El campo Descripción de la Zona de Cobro">
			</td>
		</tr>
		<tr> 
			<td align="right" valign="middle" nowrap>Cobrador Asociado:</td>
			<td> 
				<cfif modo neq 'ALTA'>
                	<cfinclude template="../../Utiles/sifConcat.cfm">
					<cfquery name="rsEmpleado" datasource="#session.DSN#">
						select a.DEid, a.NTIcodigo, a.DEidentificacion, 
							   a.DEapellido1 #_Cat# ' ' #_Cat# a.DEapellido2 #_Cat# ', ' #_Cat# a.DEnombre as NombreEmp
						from DatosEmpleado a, RolEmpleadoSNegocios b
						where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsZonaCobro.DEidCobrador#">
						  and a.Ecodigo = b.Ecodigo
					</cfquery>
					<cf_rhempleadoCxC rol=1 query=#rsEmpleado# size=30>
				<cfelse>
					<cf_rhempleadoCxC rol=1 size=30>
				</cfif>			
			</td>
		</tr>
		<tr><td colspan="2" nowrap>&nbsp;</td></tr>
		<tr> 
			<td colspan="2" align="center" nowrap> 
				<cfinclude template="../../portlets/pBotones.cfm">
			</td>
		</tr>
	</table>
	<cfset ts = "">
	<cfif modo NEQ "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsZonaCobro.ts_rversion#"/>
		</cfinvoke>
	</cfif>  
	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>" size="32">
	<input type="hidden" name="ZCSNid" value="<cfif modo neq "ALTA"><cfoutput>#rsZonaCobro.ZCSNid#</cfoutput></cfif>">
</form>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript">
<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}

	function __CodeExists(){
		<cfoutput query="rsCodigos">
			var valor = "#Trim(rsCodigos.ZCSNcodigo)#".toUpperCase( );
			if ( valor == trim(this.value.toUpperCase( ))
			<cfif modo neq "ALTA">
				&& "#Trim(rsZonaCobro.ZCSNcodigo)#".toUpperCase( ) != trim(this.value.toUpperCase( ))
			</cfif>
			) {
				this.error = "El código que intenta insertar ya existe";
			}
		</cfoutput>
	}
	_addValidator("isCodeExists", __CodeExists);

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.ZCSNcodigo.required = true;
	objForm.ZCSNcodigo.validateCodeExists();
	objForm.ZCSNcodigo.validate = true;
	objForm.ZCSNcodigo.description="Código de la Zona de Cobro";
	objForm.ZCSNdescripcion.required = true;
	objForm.ZCSNdescripcion.description="Descripción de la Zona de Cobro";
	objForm.DEidentificacion.required = true;
	objForm.DEidentificacion.description="Cobrador Asociado";
	
</script>