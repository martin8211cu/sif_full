<cfset modo = 'ALTA'>
<cfif  isdefined("form.CMATid") and len(trim(form.CMATid)) or isdefined("url.CMATid") and len(trim(url.CMATid))>
	<cfif isdefined("form.CMATid") and len(trim(form.CMATid))>
		<cfset form.CMATid = #form.CMATid#>
    <cfelse>
    	<cfset form.CMATid = #url.CMATid#>    
	</cfif>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery name="data" datasource="sifpublica">
		select 
        			CMATid, 
        			CMATcodigo, 
                    CMATdescripcion, 
                    COALESCE(ETA_R,0) as ETA_R,
                    COALESCE(ETA_A,0) as ETA_A,
                    COALESCE(CMATFDO,0) as CMATFDO,
					COALESCE(ETS,0) as ETS,
                    ts_rversion
		from CMActividadTracking
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CMATid=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CMATid#">
	</cfquery>
</cfif>

<cffunction name="ValidaCamposObligatorios" returntype="numeric">
	<cfargument name="Campo" required="yes" type="string">
	<cfargument name="CMATid" required="no" type="numeric">
	
    <cfquery name="validaCampos" datasource="sifpublica">
		select CMATid
		from CMActividadTracking
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        	and #Arguments.Campo# = 1
			<cfif isdefined("Arguments.CMATid") and Arguments.CMATid neq "">
					and CMATid = #Arguments.CMATid#
			</cfif>
	</cfquery>
	<cfset LvarContador = 0>
    <cfif validaCampos.recordcount gt 0>
	    <cfset LvarContador = 1>
    </cfif>
    <cfreturn LvarContador>
</cffunction>

<cffunction name="ValidaCamposObligatorios2" returntype="numeric">
	<cfargument name="Campo" required="yes" type="string">
	<cfargument name="CMATid" required="no" type="numeric">
	
    <cfquery name="validaCampos" datasource="sifpublica">
		select CMATid
		from CMActividadTracking
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        	and #Arguments.Campo# = 1
			<cfif isdefined("Arguments.CMATid") and Arguments.CMATid neq "">
					and CMATid != #Arguments.CMATid#
			</cfif>
	</cfquery>
	<cfset LvarContador = 0>
    <cfif validaCampos.recordcount gt 0>
	    <cfset LvarContador = 1>
    </cfif>
    <cfreturn LvarContador>
</cffunction>
    
<cfquery name="rsCodigos" datasource="sifpublica">
    select CMATcodigo
    from CMActividadTracking
    where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<script language="javascript1.2" type="text/javascript">
	lvarValidar = true;
	function fnValidar(){
		if(!lvarValidar)
			return true;
		error = "";
		if ( fnTrim(document.form1.CMATcodigo.value) == '' )
			error = error + ' - El campo Código es requerido.\n '
				
		if ( fnTrim(document.form1.CMATdescripcion.value) == '' )
			error = error + ' - El campo Descripción es requerido.\n '

		if (fnTrim(error) != ""){
			alert("'Se presentaron los siguientes errores:\n'"+error);
			return false;
		}
		return true;
	}
</script>

<cfoutput>
<form name="form1" method="post" action="trackingActividad-sql.cfm"  style="margin:0;">
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td align="right">C&oacute;digo:&nbsp;</td>
			<td colspan="2">
				<input type="text" name="CMATcodigo" <cfif modo neq 'ALTA'>readonly</cfif> value="<cfif modo neq 'ALTA'>#data.CMATcodigo#</cfif>" tabindex="1" <cfif modo eq 'ALTA'>onBlur="javascript:fnValidaCodigo(this.value);"</cfif>>
			</td>
		</tr>
		
		<tr>	
			<td align="right">Descripcip&oacute;n:&nbsp;</td>
			<td colspan="2"><input type="text" size="60" name="CMATdescripcion" tabindex="1" maxlength="100" onFocus="this.select()" value="<cfif modo neq 'ALTA'>#data.CMATdescripcion#</cfif>" ></td>
		</tr>
		<tr>
        	<td>&nbsp;</td>
        	<td width="5%" align="left">
            <fieldset style="text-align:left">
                <legend>Actividad Asociada:</legend>
				<!--- ETA real --->
                  <input type="radio" name="ActividadAsociada" value="1" onClick="javascript: unselect(this)" 
				  <cfif  modo eq 'ALTA' and ValidaCamposObligatorios('ETA_R') gt 0>
						disabled="true"
					<cfelseif modo neq 'ALTA' and ValidaCamposObligatorios2('ETA_R',#data.CMATid#) gt 0>
						disabled="true"	
					<cfelseif modo neq 'ALTA' and ValidaCamposObligatorios('ETA_R',#data.CMATid#) gt 0>
						checked="true"
					</cfif>
					/>
                  <strong>ETA_R:</strong>&nbsp;Fecha Real de arribo del Embarque<br />
                  <!--- ETA_Actualizado --->
                  <input type="radio" name="ActividadAsociada" value="2" onClick="javascript: unselect(this)"
					<cfif modo eq 'ALTA' and ValidaCamposObligatorios('ETA_A') gt 0>
						disabled="true"
					<cfelseif modo neq 'ALTA' and ValidaCamposObligatorios2('ETA_A',#data.CMATid#) gt 0>
						disabled="true"
					<cfelseif modo neq 'ALTA' and ValidaCamposObligatorios('ETA_A',#data.CMATid#) gt 0>
						checked="true"	
					</cfif>
					/>
					<strong>ETA_A:</strong>&nbsp;ETA Actualizado<br />
					<!--- ETS--->
                  <input type="radio" name="ActividadAsociada" value="3" onClick="javascript: unselect(this)"
					<cfif modo eq 'ALTA' and ValidaCamposObligatorios('ETS') gt 0>
						disabled="true"
					<cfelseif modo neq 'ALTA' and ValidaCamposObligatorios2('ETS',#data.CMATid#) gt 0>
						disabled="true"
					<cfelseif modo neq 'ALTA' and ValidaCamposObligatorios('ETS',#data.CMATid#) gt 0>
						checked="true"		
				  </cfif>
					/>
					<strong>ETS:</strong>&nbsp;Salida del puerto Origen<br />
                <!--- CMATFDO --->
                  <input type="radio" name="ActividadAsociada" value="4" onClick="javascript: unselect(this)"
				  <cfif  modo eq 'ALTA' and ValidaCamposObligatorios('CMATFDO') gt 0>
						disabled="true"
				<cfelseif modo neq 'ALTA' and ValidaCamposObligatorios2('CMATFDO',#data.CMATid#) gt 0>
						disabled="true"			
				<cfelseif modo neq 'ALTA' and ValidaCamposObligatorios('CMATFDO',#data.CMATid#) gt 0>
						checked="true"			
				  </cfif>
				  />
                  <strong>DO:</strong>&nbsp;Fecha de Env&iacute;o de los Documentos<br />
            </fieldset>
            </td>
        </tr>
		<tr>
			<td colspan="4" align="center"><cf_botones modo="#modo#"></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
        <input type="hidden" name="ETAR" 		value="0" />
        <input type="hidden" name="ETA_A_" 	value="0" />
        <input type="hidden" name="CMATFDO_" value="0" />
		<input type="hidden" name="ETS_" 		value="0" />
	</table>
	<cfif modo neq "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
		</cfinvoke>
		<input type="hidden" name="timestamp" value="#ts#">
        <input type="hidden" name="CMATid" value="#data.CMATid#">
	</cfif>
</form>
</cfoutput>
<script language="javascript1.2" type="text/javascript">

	function fnTrim(s){
		return s.replace(/^\s+|\s+$/g, "");	
	}
	function fnValidaCodigo(codigo){
		<cfloop query="rsCodigos">
			if (fnTrim(codigo) == '<cfoutput>#trim(rsCodigos.CMATcodigo)#</cfoutput>') {
				alert('El Código de Estado ya existe');
				document.form1.CMATcodigo.value = '';
				document.form1.CMATcodigo.focus();
				return false;
			}
		</cfloop>
		return true;
	}
	
	function deshabilitarValidacion(){
		lvarValidar = false;
	}
	var estado=false;
	//Funcion para desSeleccionar un radio que ya estaba seleccionado, para habilitar la posibilidad de desmarcarlo
	function unselect(r){ r.checked = estado === false? true:false; estado = r.checked;}
</script>
