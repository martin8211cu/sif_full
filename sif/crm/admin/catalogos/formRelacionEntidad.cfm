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
<cfif modo neq 'ALTA' and isdefined('form.CRMREid') and form.CRMREid NEQ ''>
	<!--- Form --->
	<cfquery name="rsForm" datasource="#session.DSN#">
		Select 	convert(varchar,re.CRMTRid) as CRMTRid,
				convert(varchar,re.CRMREid) as CRMREid,
				convert(varchar,re.CRMEid1) as CRMEid1,
				e1.CRMEnombre as nombre_1,e1.CRMEapellido1 as apellido1_1,e1.CRMEapellido2 as apellido2_1,
				convert(varchar,re.CRMEid2) as CRMEid2,
				e2.CRMEnombre as nombre_2,e2.CRMEapellido1 as apellido1_2,e2.CRMEapellido2 as apellido2_2,
				convert(varchar,CRMREfechaini,103) as CRMREfechaini,
				convert(varchar,CRMREfechafin,103) as CRMREfechafin,
				CRMTRdescripcion,
				re.ts_rversion
		from CRMRelacionEntidad re,
			CRMEntidad e1,
			CRMEntidad e2,
			CRMTipoRelacion tr
		where re.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and re.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			and CRMREid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRMREid#">
			and re.Ecodigo=e1.Ecodigo
			and re.CEcodigo=e1.CEcodigo
			and re.CRMEid1=e1.CRMEid
			and re.CRMEid2=e2.CRMEid
			and e1.Ecodigo=e2.Ecodigo
			and e1.CEcodigo=e2.CEcodigo
			and e2.Ecodigo=tr.Ecodigo
			and e2.CEcodigo=tr.CEcodigo
			and re.CRMTRid=tr.CRMTRid
	</cfquery>
</cfif>

<form name="formRelacionEntidad" method="post" action="SQLrelacionEntidad.cfm" onSubmit="return validar(this);">
	<cfoutput>

	<cfif modo NEQ 'ALTA'>
		<cfset ts = "">	
		<cfif modo neq "ALTA">
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
	  </cfif>
		<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'>#ts#</cfif>">	
		<input type="hidden" name="CRMREid" value="<cfif modo NEQ 'ALTA'>#rsForm.CRMREid#</cfif>">			
	</cfif>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td class="tituloAlterno" colspan="2">
			<cfif modo NEQ 'ALTA'>
				Modificaci&oacute;n de Relaci&oacute;nes por Entidad
			<cfelse>
				Nueva Relaci&oacute;nes por Entidad
			</cfif>
		</td>
      </tr>	
	  <tr>
	    <td>&nbsp;</td>
      </tr>	  

	  <tr>
		<td>Entidad 1:</td>
	    <td>
			<cfif modo NEQ 'ALTA'>
				<cfquery name="rsEnt_1" dbtype="query">
					select CRMEid1 as CRMEid,nombre_1 as CRMEnombre,apellido1_1 as CRMEapellido1,apellido2_1 as CRMEapellido2
					from rsForm				
				</cfquery>
				<cfif isdefined('rsEnt_1') and rsEnt_1.recordCount GT 0>
					<cf_crmEntidad 
						CRMEid="CRMEid1" 
						CRMnombre="CRMnombre1" 
						Conexion="#session.DSN#" 
						form="formRelacionEntidad"
						size="35"
						query="#rsEnt_1#">				
				</cfif>
			<cfelse>
				<cf_crmEntidad 
					CRMEid="CRMEid1" 
					CRMnombre="CRMnombre1" 
					Conexion="#session.DSN#" 
					form="formRelacionEntidad"
					size="35">			
			</cfif>
		</td>
      </tr>

	  <tr>
		  <td>Tipo de relaci&oacute;n:&nbsp;</td>
	      <td><select name="CRMTRid" id="CRMTRid">
            <cfloop query="rsTiposRElaciones">
              <option value="#rsTiposRelaciones.CRMTRid#" <cfif modo NEQ 'ALTA' and rsForm.CRMTRid EQ rsTiposRelaciones.CRMTRid> selected</cfif>>#rsTiposRelaciones.CRMTRdescripcion#</option>
            </cfloop>
          </select></td>
	  </tr>

	  <tr>
	    <td> Entidad 2:</td>
	    <td>
			<cfif modo NEQ 'ALTA'>
				<cfquery name="rsEnt_2" dbtype="query">
					select CRMEid2 as CRMEid,nombre_2 as CRMEnombre,apellido1_2 as CRMEapellido1,apellido2_2 as CRMEapellido2
					from rsForm				
				</cfquery>
				<cfif isdefined('rsEnt_2') and rsEnt_2.recordCount GT 0>
					<cf_crmEntidad 
						CRMEid="CRMEid2" 
						CRMnombre="CRMnombre2" 
						Conexion="#session.DSN#" 
						form="formRelacionEntidad"
						size="35"
						query="#rsEnt_2#">				
				</cfif>
			<cfelse>
				<cf_crmEntidad 
					CRMEid="CRMEid2" 
					CRMnombre="CRMnombre2" 
					Conexion="#session.DSN#" 
					form="formRelacionEntidad"
					size="35">		
			</cfif>		
		</td>
	  </tr>

	  <tr>
		<td>Fecha de Inicio:</td>
	    <td>
			<cfif modo NEQ "ALTA">
				<cf_sifcalendario form="formRelacionEntidad" name="CRMREfechaini" value="#rsForm.CRMREfechaini#">
			<cfelse>
				<cf_sifcalendario form="formRelacionEntidad" name="CRMREfechaini">
			</cfif>		
		</td>
      </tr>

	  <tr>
	    <td>Fecha Final:</td>
	    <td>
			<cfif modo NEQ "ALTA">
				<cf_sifcalendario form="formRelacionEntidad" name="CRMREfechafin" value="#rsForm.CRMREfechafin#">
			<cfelse>
				<cf_sifcalendario form="formRelacionEntidad" name="CRMREfechafin">
			</cfif>		
		</td>
	  </tr>

	  <tr>
	    <td align="center" colspan="2"><cfinclude template="../../portlets/pBotones.cfm"></td>
      </tr>
	  </table>
  </cfoutput>
</form>


<!--- Javascript --->
<SCRIPT SRC="../../../js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	function validar(f){
		if (f.obj.CRMEid1.value == f.obj.CRMEid2.value){
			alert('Error, las entidades deben ser distintas');
			return false;
		}
		
		return true;
	}
	
	function habilitarValidacion(){
		objForm.CRMEid1.required = true;
		objForm.CRMEid2.required = true;
		objForm.CRMTRid.required = true;
		objForm.CRMREfechaini.required = true;
		objForm.CRMREfechafin.required = true;
	}
	
	function deshabilitarValidacion(){
		objForm.CRMEid1.required = false;
		objForm.CRMEid2.required = false;
		objForm.CRMTRid.required = false;
		objForm.CRMREfechaini.required = false;
		objForm.CRMREfechafin.required = false;
	}	
	
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formRelacionEntidad");

	objForm.CRMEid1.required = true;
	objForm.CRMEid1.description="Entidad 1";
	objForm.CRMEid2.required = true;
	objForm.CRMEid2.description="Entidad 2";	
	objForm.CRMTRid.required = true;
	objForm.CRMTRid.description="Tipo de Relación";
	objForm.CRMREfechaini.required = true;
	objForm.CRMREfechaini.description="Fecha de inicio";
	objForm.CRMREfechafin.required = true;
	objForm.CRMREfechafin.description="Fecha final";
</script>