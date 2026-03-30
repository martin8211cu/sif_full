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
<cfif isdefined("Form.RHTOid") and Len(Trim(Form.RHTOid))>
	<cfset modo = "CAMBIO">
</cfif>
<!--- Consultas --->
<cfif modo NEQ "ALTA">
	<!--- Form --->
	<cfquery name="rsForm" datasource="#session.DSN#">
		select RHTOid, RHTOcodigo,RHTOdescripcion,ts_rversion
		from RHTipoObjetivo
		where RHTOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTOid#">
		and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	</cfquery>
</cfif>



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
<cfoutput>	
	<form action="SQLTiposObjetivos.cfm"  method="post" name="form1" >
		<table width="100%" border="0" cellspacing="1" cellpadding="1">
			<tr>
				<td colspan="2" class="tituloAlterno" align="center">
					<cfif modo NEQ 'ALTA'>
						<cf_translate key="LB_ModificacionDelTipoDeObjetivo">Modificaci&oacute;n del Tipo de Objetivo</cf_translate>
					<cfelse>
						<cf_translate key="LB_NuevoTipoDeObjetivo">Nuevo Tipo de Objetivo</cf_translate>
					</cfif>
				</td>
			</tr>
			<tr>
				<td width="31%" align="right">
					<cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate>:
				</td>
				<td width="69%">
					<input type="text" name="RHTOcodigo" <cfif modo NEQ 'ALTA'> readonly </cfif>  
					size="11" maxlength="10" tabindex="1"
					value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.RHTOcodigo#</cfoutput></cfif>" 
					onfocus="javascript:this.select();">
					<input type="hidden" name="RHTOid" value="<cfif modo NEQ 'ALTA'>#rsForm.RHTOid#</cfif>" >
				</td>
			</tr>
			<tr>
				<td align="right" nowrap>
					<cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:
				</td>
				<td>
					<input type="text" name="RHTOdescripcion" size="80" maxlength="80" tabindex="1"
					value="<cfif modo NEQ 'ALTA'>#rsForm.RHTOdescripcion#</cfif>" onFocus="javascript:this.select();" >
				</td>
			</tr>
			</tr>
				<td colspan="2" class="formButtons">
					<cfif isdefined("rsForm") and rsForm.RecordCount>
						<cf_botones modo='CAMBIO'>
					<cfelse>
						<cf_botones modo='ALTA'>
					</cfif>
				</td>
			</tr>			
		</table> 
		<cfset ts = "">
		<cfif isdefined("rsForm") and rsForm.RecordCount>
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#rsForm.ts_rversion#" returnvariable="ts">
			</cfinvoke>
		</cfif>
		<input type="hidden" name="ts_rversion" value="#ts#">
	</form>
	<cf_qforms>
	<script type="text/javascript">
		objForm.RHTOcodigo.required        = true;
		objForm.RHTOcodigo.description     = "#LB_Codigo#";	
		objForm.RHTOdescripcion.required   = true;
		objForm.RHTOdescripcion.description="#LB_Descripcion#";	
		function habilitarValidacion(){
			objForm.RHTOcodigo.required     = true;
			objForm.RHTOdescripcion.required= true;
		}
		function deshabilitarValidacion(){
			objForm.RHTOcodigo.required     = false;
			objForm.RHTOdescripcion.required= false;
		}		
	</script>
</cfoutput>