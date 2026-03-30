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
<cfif modo neq 'ALTA' and isdefined('form.CRMTRid') and form.CRMTRid NEQ '' and isdefined('form.CRMTEid1') and form.CRMTEid1 NEQ '' and isdefined('form.CRMTEid2') and form.CRMTEid2 NEQ ''>
	<!--- Form --->
	<cfquery name="rsForm" datasource="#session.DSN#">
		select 	convert(varchar,rp.CRMTRid) as codCRMTRid,
				convert(varchar,CRMTEid1) as CRMTEid1,
				convert(varchar,CRMTEid2) as CRMTEid2,	
				te1.CRMTEdesc,
				CRMRPdescripcion1,
				te2.CRMTEdesc,
				CRMRPdescripcion2,
				rp.CRMTRid,
				rp.ts_rversion			
		from CRMRelacionesPermitidas rp,
			CRMTipoRelacion tr,
			CRMTipoEntidad te1,
			CRMTipoEntidad te2
		where 	rp.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and rp.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
				and rp.CRMTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRMTRid#">
				and CRMTEid1 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRMTEid1#">
				and CRMTEid2 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRMTEid2#">
				and rp.Ecodigo=tr.Ecodigo
				and rp.CEcodigo=tr.CEcodigo
				and rp.CRMTRid=tr.CRMTRid
				and tr.Ecodigo=te1.Ecodigo
				and tr.CEcodigo=te1.CEcodigo
				and rp.CRMTEid1=te1.CRMTEid
				and rp.CRMTEid2=te2.CRMTEid
	</cfquery>
</cfif>

<form name="formRelacionesPermitidas" method="post" action="SQLrelacionesPermit.cfm" onSubmit="return validar(this);">
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
	</cfif>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td class="tituloAlterno" colspan="2">
			<cfif modo NEQ 'ALTA'>
				Modificaci&oacute;n de Relaci&oacute;n Permitida
			<cfelse>
				Nueva Relaci&oacute;n Permitida
			</cfif>
		</td>
      </tr>	

	  <tr>
		<td nowrap>Tipo de Entidad 1:&nbsp;</td>
	    <td>
			<select name="CRMTEid1" id="CRMTEid1" <cfif modo NEQ "ALTA"> disabled</cfif>>
				<cfloop query="rsTiposEntidad">
					<option value="#rsTiposEntidad.CRMTEid#" <cfif modo NEQ "ALTA" and rsTiposEntidad.CRMTEid EQ rsForm.CRMTEid1> selected</cfif>>#rsTiposEntidad.CRMTEdesc#</option>
				</cfloop>
            </select>
		</td>
      </tr>

	  <tr>
	    <td nowrap>Descripci&oacute;n de relaci&oacute;n 1:&nbsp;</td>
	    <td><input name="CRMRPdescripcion1" alt="La descripci&oacute; de la relaci&oacute;n de la entidad 1 con la entidad 2" type="text" id="CRMRPdescripcion1" size="45" maxlength="60" onfocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#Trim(rsForm.CRMRPdescripcion1)#</cfif>"></td>
      </tr>

	  <tr>
	    <td>Tipo de relaci&oacute;n:&nbsp;</td>
	    <td><select name="CRMTRid" id="CRMTRid" <cfif modo NEQ "ALTA"> disabled</cfif>>
          <cfloop query="rsTiposRElaciones">
            <option value="#rsTiposRelaciones.CRMTRid#" <cfif modo NEQ 'ALTA' and rsForm.CRMTRid EQ rsTiposRelaciones.CRMTRid> selected</cfif>>#rsTiposRelaciones.CRMTRdescripcion#</option>
          </cfloop>
        </select></td>
	    <td>&nbsp;</td>
      </tr>

	  <tr>
	    <td nowrap>Tipo de Entidad 2:&nbsp;</td>
	    <td>
			<select name="CRMTEid2" id="CRMTEid2" <cfif modo NEQ "ALTA"> disabled</cfif>>
				<cfloop query="rsTiposEntidad">
					<option value="#rsTiposEntidad.CRMTEid#" <cfif modo NEQ "ALTA" and rsTiposEntidad.CRMTEid EQ rsForm.CRMTEid2> selected</cfif>>#rsTiposEntidad.CRMTEdesc#</option>
				</cfloop>
            </select>		
		</td>
      </tr>

	  <tr>
	    <td nowrap>Descripci&oacute;n de relaci&oacute;n 2:&nbsp;</td>
	    <td><input name="CRMRPdescripcion2" alt="La descripci&oacute; de la relaci&oacute;n de la entidad 2 con la entidad 1" onfocus="javascript:this.select();" type="text" id="CRMRPdescripcion2" size="45" maxlength="60"  value="<cfif modo neq 'ALTA'>#Trim(rsForm.CRMRPdescripcion2)#</cfif>"></td>
      </tr>
	  <tr>
	    <td>&nbsp;</td>
      </tr>	  	  	  	  	  	  
	  <tr>
	    <td align="center" colspan="2"><cfinclude template="../../portlets/pBotones.cfm"></td>
      </tr>
	  </table>
  </cfoutput>
</form>


<!--- Javascript --->
<!--- <script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script> --->
<SCRIPT SRC="../../../js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	function validar(f){
		/*if (f.obj.CRMTEid1.value == f.obj.CRMTEid2.value){
			alert('Error, los tipos de entidades debes ser distintos');
			return false;
		}*/
		
		f.obj.CRMTEid1.disabled = false;
		f.obj.CRMTEid2.disabled = false;
		f.obj.CRMTRid.disabled = false;
		
		return true;
	}
	
	function habilitarValidacion(){
		objForm.CRMTEid1.required = true;
		objForm.CRMTEid2.required = true;
		objForm.CRMTRid.required = true;	
	}
	
	function deshabilitarValidacion(){
		objForm.CRMTEid1.required = false;
		objForm.CRMTEid2.required = false;
		objForm.CRMTRid.required = false;	
	}	
	
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formRelacionesPermitidas");

	objForm.CRMTEid1.required = true;
	objForm.CRMTEid1.description="Código del Tipo de Entidad 1";
	objForm.CRMTEid2.required = true;
	objForm.CRMTEid2.description="Código del Tipo de Entidad 2";
	objForm.CRMTRid.required = true;
	objForm.CRMTRid.description="Código del Tipo de Relación";
</script>