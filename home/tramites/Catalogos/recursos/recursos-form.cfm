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
<cfif isdefined("url.id_recurso") and Len("url.id_recurso") gt 0 >
	<cfset form.id_recurso = url.id_recurso >
</cfif>

<cfquery name="rsTipoRecurso" datasource="#session.tramites.dsn#">
	select 
		id_tiporecurso
		, Codigo_Recurso
		, Nombre_Recurso
	from TPTipoRecurso 
	order by Nombre_Recurso
</cfquery>

<cfquery name="rsSucursales" datasource="#session.tramites.dsn#">
	Select id_sucursal
		, codigo_sucursal
		, nombre_sucursal
	from TPSucursal 
	where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
	order by nombre_sucursal
</cfquery>

<cfif isdefined("Form.id_recurso") AND Len(Trim(Form.id_recurso)) GT 0 and isdefined("Form.id_inst") AND Len(Trim(Form.id_inst)) GT 0 >
	<cfset modo="CAMBIO">
	<cfquery name="rsDatos" datasource="#session.tramites.dsn#">
		Select 
			 id_recurso
			, r.id_sucursal
			, r.id_direccion
			, r.id_tiporecurso
			, codigo_recurso
			, nombre_recurso
			, r.vigente_desde
			, r.vigente_hasta
		
			, ('(' || rtrim(codigo_recurso) || ')- ' || nombre_recurso) as sucursal
			, ('(' || rtrim(Codigo_Recurso) || ')- ' || Nombre_Recurso) as tipoRecurso
			, r.ts_rversion
		
		from TPRecurso r
			inner join TPTipoRecurso tr
				on tr.id_tiporecurso=r.id_tiporecurso
		
			inner join TPSucursal s
				on s.id_sucursal=r.id_sucursal
		
			inner join TPInstitucion i
				on i.id_inst=s.id_inst
					and i.id_inst=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
		where id_recurso=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_recurso#">
	</cfquery>
</cfif>



<cfoutput>
	<form method="post" name="formRecurso" action="recursos/recursos-sql.cfm">
	  <table align="center" width="100%" cellpadding="2" cellspacing="0">
        <tr valign="baseline">
          <td width="14%" align="right" nowrap><strong>C&oacute;digo:</strong></td>
          <td width="86%">
            <input type="text" name="codigo_recurso" 
				value="<cfif modo NEQ "ALTA">#rsDatos.codigo_recurso#</cfif>" 
				size="10" maxlength="10" onfocus="javascript:this.select();" >
          </td>
        </tr>
        <tr valign="baseline">
          <td nowrap align="right"><strong>Descripci&oacute;n:</strong></td>
          <td>
            <input type="text" name="nombre_recurso" 
				value="<cfif modo NEQ "ALTA">#rsDatos.nombre_recurso#</cfif>" 
				size="60" maxlength="100" onfocus="javascript:this.select();" >
          </td>
        </tr>
        <tr valign="baseline">
          <td nowrap align="right"><strong>Sucursal:</strong></td>
          <td>
		  	<select name="id_sucursal" id="id_sucursal">
				<cfif isdefined('rsSucursales') and rsSucursales.recordCount GT 0>				
					<cfloop query="rsSucursales">
						<option value="#rsSucursales.id_sucursal#" <cfif modo NEQ "ALTA" and rsDatos.id_sucursal EQ rsSucursales.id_sucursal> selected</cfif>>(#rsSucursales.codigo_sucursal#) #rsSucursales.nombre_sucursal#</option>
					</cfloop>
				</cfif>
            </select>				  
		  </td>
        </tr>
        <tr valign="baseline">
          <td nowrap align="right"><strong>Tipo de Recurso :</strong></td>
          <td>
		  	<select name="id_tiporecurso" id="id_tiporecurso">
				<cfif isdefined('rsTipoRecurso') and rsTipoRecurso.recordCount GT 0>				
					<cfloop query="rsTipoRecurso">
						<option value="#rsTipoRecurso.id_tiporecurso#" <cfif modo NEQ "ALTA" and rsDatos.id_tiporecurso EQ rsTipoRecurso.id_tiporecurso> selected</cfif>>(#rsTipoRecurso.Codigo_Recurso#) #rsTipoRecurso.Nombre_Recurso#</option>
					</cfloop>
				</cfif>
            </select>
          </td>
        </tr>
        <tr valign="baseline">
          <td nowrap align="right"><strong>Vigente desde :</strong></td>
          <td>
            <cfif modo NEQ 'ALTA'>
              <cf_sifcalendario form="formRecurso" name="vigente_desde" value="#LSDateFormat(rsDatos.vigente_desde,'dd/mm/yyyy')#" tabindex="1">
              <cfelse>
              <cf_sifcalendario form="formRecurso" name="vigente_desde" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1">
            </cfif>
          </td>
        </tr>
        <tr valign="baseline">
          <td nowrap align="right"><strong>Vigente hasta :</strong></td>
          <td>
            <cfif modo NEQ 'ALTA'>
              <cf_sifcalendario form="formRecurso" name="vigente_hasta" value="#LSDateFormat(rsDatos.vigente_hasta,'dd/mm/yyyy')#" tabindex="1">
              <cfelse>
              <cf_sifcalendario form="formRecurso" name="vigente_hasta" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1">
            </cfif>
          </td>
        </tr>
        <tr valign="baseline">
          <td  colspan="2" class="subTitulo" align="left"><font size="1" color="black"><strong>Direcci&oacute;n </strong></font></td>
        </tr>
        <tr valign="baseline">
          <td nowrap colspan="2"  align="left">
            <cfif modo NEQ "ALTA" and Len(trim(rsDatos.id_direccion)) >
				<input type="hidden" name="id_direccion" value="#rsDatos.id_direccion#">	
              	<cf_tr_direccion action="input" key="#rsDatos.id_direccion#" title="">
            <cfelse>
              	<cf_tr_direccion action="input"  title="">
            </cfif>
          </td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr valign="baseline">
          <td colspan="2" align="center" nowrap>
			<cf_botones modo="#modo#" sufijo="_Rec" include="btnLista" includevalues="Lista de Recursos">
          </td>
        </tr>
        <tr valign="baseline">
          <cfset ts = "">
          <cfif modo NEQ "ALTA">
            <cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsDatos.ts_rversion#" returnvariable="ts"> </cfinvoke>
          </cfif>
          <input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>">
          <input type="hidden" name="id_recurso" value="<cfif modo NEQ "ALTA">#rsDatos.id_recurso#</cfif>">
          <input type="hidden" name="id_inst" value="#Form.id_inst#">
        </tr>
      </table>
	</form>
</cfoutput>
<SCRIPT LANGUAGE="JavaScript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formRecurso");
	
	function _isFechas(){
		var valorINICIO=0;
		var valorFIN=0;
		var INICIO = document.formRecurso.vigente_desde.value;
		var FIN = this.value;
		
		INICIO = INICIO.substring(6,10) + INICIO.substring(3,5) + INICIO.substring(0,2)
		FIN = FIN.substring(6,10) + FIN.substring(3,5) + FIN.substring(0,2)
		valorINICIO = parseInt(INICIO)
		valorFIN = parseInt(FIN)

		if (valorINICIO > valorFIN)
			this.error="Error, la fecha de inicio de vigencia (" + document.formRecurso.vigente_desde.value + ") no debe ser mayor que la fecha final de vigencia (" + this.value + ")";
	}	
	
	_addValidator("isFechas", _isFechas);		
	
	objForm.codigo_recurso.required = true;
	objForm.codigo_recurso.description="Código";				
	objForm.nombre_recurso.required = true;
	objForm.nombre_recurso.description="Descripción";		
	objForm.id_sucursal.required = true;
	objForm.id_sucursal.description="Sucursal";			
	objForm.id_tiporecurso.required = true;
	objForm.id_tiporecurso.description="Tipo de Recurso";			
	objForm.vigente_hasta.validateFechas();

	function deshabilitarValidacionSuc(){
		objForm.codigo_recurso.required = false;
		objForm.nombre_recurso.required = false;
		objForm.id_sucursal.required = false;
		objForm.id_tiporecurso.required = false;
	}
	function funcbtnLista_Rec(){
		deshabilitarValidacionSuc();
	}
</SCRIPT>

