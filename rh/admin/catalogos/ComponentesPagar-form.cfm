<!--- VARIABLES DE TRADUCCIONES --->
<cfinvoke key="LB_TITULOCONLIS" default="Lista de Componentes" returnvariable="LB_TITULOCONLIS" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_Codigo" default="C&oacute;digo" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_Descripcion" default="Descripci&oacute;n" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>			
<!--- FIN VARIABLES TRADUCCION --->
<!-- Establecimiento del modo -->
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

<!--- Consultas --->
<cfif modo neq 'ALTA'>
	<!--- Form --->
	<cfquery name="rsForm" datasource="#session.DSN#">
		select a.CSid,a.RHTid,CScodigo,CSdescripcion
			, a.ts_rversion
		from RHComponentesPagarA a
			inner join ComponentesSalariales b
				on b.Ecodigo = a.Ecodigo
				and b.CSid = a.CSid
		where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.RHTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTid#">
			and a.CSid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSid#">
	</cfquery>
</cfif>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>


<form name="form1" method="post" action="ComponentesPagar-SQL.cfm">
  <cfoutput>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td align="right" nowrap="nowrap"><strong><cf_translate XmlFile="/sif/rh/generales.xml" key="LB_USUARIO">Componente Salarial</cf_translate>:</strong>&nbsp;</td>
      <td>
		<cfif modo NEQ 'ALTA'>
			<input type="text"  class="cajasinbordeb" name="CScodigo" size="10" maxlength="10" value="#rsForm.CScodigo#">
			<input type="text"  class="cajasinbordeb" name="CSDescripcion" size="30" maxlength="60" value="#rsForm.CSdescripcion#">
			<input type="hidden" name="CSid" value="#rsForm.CSid#">
		<cfelse>
			<!--- Lista de Usuarios Autorizados --->
			<cfquery name="rsComponentes" datasource="#Session.DSN#">
				select distinct CSid
				from RHComponentesPagarA 
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and RHTid = <cfqueryparam value="#form.RHTid#" cfsqltype="cf_sql_numeric"> 
			</cfquery>
			<cfset filtroExtra = "">
			<cfif isdefined('rsComponentes') and rsComponentes.recordCount GT 0>
				<cfset filtroExtra = " and a.CSid not in (#ValueList(rsComponentes.CSid, ',')#)">		
			</cfif>
			<cf_conlis 
				campos="CSid,CScodigo,CSDescripcion"
				size="0,10,60"
				desplegables="N,S,S"
				modificables="N,N,N"
				title="#LB_TITULOCONLIS#"
				tabla="ComponentesSalariales"
				columnas="CSid,CScodigo,CSdescripcion"
				filtro="Ecodigo = #session.Ecodigo#
						and CSsalariobase = 0
						and CIid is not null
					  #filtroExtra#"
				filtrar_por="CScodigo,CSDescripcion"
				desplegar="CScodigo,CSDescripcion"
				etiquetas="#LB_Codigo#,#LB_Descripcion#"
				formatos="S,S"
				align="left,left"
				asignar="CSid,CScodigo,CSDescripcion"
				asignarFormatos="S,S,S"
				form="form1"
				showEmptyListMsg="true"
				EmptyListMsg=" --- No se encotraron usuarios --- "/>			
		</cfif>	  

  
	  </td>
    </tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr><td colspan="2" align="center">
		<cfset regresa = 'TipoAccion.cfm?RHTid=' & form.RHTid>
	
		<cfif modo neq "ALTA">
			<cf_botones modo="#modo#" exclude="Cambio" regresar="#regresa#">
		<cfelse>
			<cf_botones modo="#modo#" regresar="#regresa#">
		</cfif>
	</td></tr>
	<tr>
		<td colspan="2" align="center">&nbsp;</td>
	</tr>
	<cfset ts = "">	
	<cfif modo neq "ALTA">
		<cfinvoke 
			component="sif.Componentes.DButils"
			method="toTimeStamp"
			returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
		</cfinvoke>
	</cfif>
	<tr><td><input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>"></td></tr>
  </table>  
  </cfoutput>
  <input type="hidden" id="RHTid" name="RHtid" value="<cfif isdefined("form.RHTid") and len(trim(form.RHTid)) neq 0><cfoutput>#form.RHTid#</cfoutput></cfif>">
  <input type="hidden" id="RHTdesc" name="RHTdesc" value="<cfif isdefined("form.RHTdesc") and len(trim(form.RHTdesc)) neq 0><cfoutput>#form.RHTdesc#</cfoutput></cfif>">
</form>

<script language="JavaScript1.2" type="text/javascript">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_MESAJEERROR8"
	Default="Usuario"
	returnvariable="LB_MESAJEERROR8"/>
	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	objForm.CScodigo.required = true;
	objForm.CScodigo.description="<cfoutput>#LB_MESAJEERROR8#</cfoutput>";	

	function deshabilitarValidacion(){
		objForm.CScodigo.required = false;
	}
	function habilitarValidacion(){
		objForm.CScodigo.required = true;
	}	
	function limpiar() {
		objForm.reset();
	}
	
	function funcRegresar(id){
		document.location.href = 'TipoAccion.cfm?RHTid=' & id;
	}

</script> 
