<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>

<!--- Definición del modo --->
<cfset modo="ALTA">
<cfif isdefined("Form.SNCDid") and len(trim("Form.SNCDid")) NEQ 0 and Form.SNCDid GT 0>
    <cfset modo="CAMBIO">
</cfif>

<!--- Para cuando viene de la nueva lista de Cuentas de Mayor para agregar directamente subcuentas sin pasar por el mantenimiento de Cuentas de Mayor --->
<cfif isdefined("form.modo2")>
	<cfset modo = form.modo2>
</cfif>

<cfif isdefined("Session.Ecodigo") and isdefined("Form.SNCDid") and LEN(TRIM(Form.SNCDid))>
	<cfquery name="rsValores" datasource="#Session.DSN#">
		select *
		from SNClasificacionD
		where SNCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNCDid#">
		  and SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNCEid#">				
	</cfquery>
</cfif>
<cfquery name="rsConsultaCorp" datasource="asp">
	select *
	from CuentaEmpresarial
	where Ecorporativa is not null
	  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#" >
</cfquery>
<cfquery name="rsSNClasifDes" datasource="#Session.DSN#">
	select SNCEcodigo, SNCEdescripcion 
	from SNClasificacionE
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#"> 
	<cfif isdefined('session.Ecodigo') and 
				  isdefined('session.Ecodigocorp') and
				  session.Ecodigo NEQ session.Ecodigocorp and
				  rsConsultaCorp.RecordCount GT 0>
	 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfif>
	  and SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNCEid#">
</cfquery>

<!--- registros existentes --->
<cfquery name="rsVal" datasource="#session.DSN#">
	select rtrim(SNCDvalor) as SNCDvalor
	from SNClasificacionD
	<cfif modo neq 'ALTA' >	
	where SNCDid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNCDid#">
	</cfif>
</cfquery>


<form method="post" name="form1" action="SQLSNValoresClasificacion.cfm<cfif isdefined('url.desde') and Trim(url.desde) eq 'rh'>?desde=rh</cfif>">
<cfoutput>  
	<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
	<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">	

	<table width="100%" align="center" cellspacing="0" cellpadding="2">
    	<tr valign="middle" class="tituloAlterno"> 
      		<td nowrap colspan="2" align="center"><strong>Clasificaci&oacute;n&nbsp;#trim(rsSNClasifDes.SNCEcodigo)# - #rsSNClasifDes.SNCEdescripcion#</strong></td>
    	</tr>
    	<tr valign="middle"> 
      		<td nowrap align="right">Valor:&nbsp;</td>
      		<td>
				<input type="text" tabindex="1" name="SNCDvalor" size="15" maxlength="15" 
					value="<cfif modo NEQ "ALTA">#rsValores.SNCDvalor#</cfif>" onfocus="javascript:this.select();">
			</td>
		</tr>
		<tr valign="middle"> 
		  <td nowrap align="right">Descripción:&nbsp;</td>
		  <td><input type="text"  tabindex="1" name="SNCDdescripcion" value="<cfif modo NEQ "ALTA">#rsValores.SNCDdescripcion#</cfif>" size="32" maxlength="80" onfocus="javascript:this.select();"></td>
		</tr>
    	<tr> 
      		<td align="right" valign="middle">Cat&aacute;logo Contable:&nbsp;</td>
			<td>
				<cfquery name="rsCatCuentaD" datasource="#session.DSN#">
					select *
					from PCDCatalogo
					where PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCEcatid#"null="#LEN(form.PCEcatid) EQ 0#">
				</cfquery>
				<select name="PCDcatid"  tabindex="1">
					<cfloop query="rsCatCuentaD"> 
						<option value="#rsCatCuentaD.PCDcatid#" 
							<cfif (isDefined("rsValores.PCDcatid") AND rsValores.PCDcatid EQ rsCatCuentaD.PCDcatid)>selected</cfif>>#rsCatCuentaD.PCDdescripcion#</option>
					</cfloop>
				</select>
			</td>
		</tr>
		<tr> 
			<td nowrap></td>
			<td align="left">
				<input name="SNCDactivo" id="SNCDactivo" type="checkbox"  tabindex="1"
					value="<cfif modo NEQ "ALTA">#rsValores.SNCDactivo#<cfelse></cfif>"
					<cfif modo NEQ "ALTA" and rsValores.SNCDactivo EQ 1>checked</cfif>>
					<label for="SNCDactivo" style="font-style:normal; font-variant:normal; font-weight:normal">Activo</label>
			</td>
		</tr>
    	<tr valign="baseline"> 
		  	<td colspan="2" align="center" nowrap>
				<cfset masbotones = "Clasif">
				<cfset masbotonesv = "Clasificación de Socios">
				<input name="SNCDid" type="hidden"  tabindex="-1" value="<cfif modo NEQ "ALTA"><cfoutput>#rsValores.SNCDid#</cfoutput></cfif>">
			  	<input name="SNCEid" type="hidden"  tabindex="-1" value="<cfoutput>#Form.SNCEid#</cfoutput>">
			  	<input name="PCEcatid" type="hidden"  tabindex="-1" value="<cfoutput>#Form.PCEcatid#</cfoutput>">
			  	<cfset ts = "">
			  	<cfif modo NEQ "ALTA">
					<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsValores.ts_rversion#" returnvariable="ts">
					</cfinvoke>
			  	</cfif>
			  	<input  tabindex="-1" type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>">
				<cfset tabindex = 2 >
				<cf_botones modo="#modo#" include="#masbotones#" includevalues="#masbotonesv#" tabindex="1">
			</td>
    	</tr>
    	<tr><td>&nbsp;</td></tr>
  	</table>
</cfoutput>
</form>
<cf_qforms>
<SCRIPT LANGUAGE="JavaScript">

	objForm.SNCDvalor.required = true;
	objForm.SNCDvalor.description="Valor";
	objForm.SNCDdescripcion.required = true;
	objForm.SNCDdescripcion.description="Descripción";				
	
	function deshabilitarValidacion(){
		objForm.SNCDvalor.required = false;
		objForm.SNCDdescripcion.required = false;		
	}
	
	function deshabilitarValidacion(){
		objForm.SNCDdescripcion.required = false;
	}

	function funcClasif() {
		location.href='SNClasificaciones.cfm?SNCEid=<cfoutput>#Form.SNCEid#</cfoutput>';
		return false;
	}
	
	function codigos(obj){
		if (obj.value != "") {
			var dato    = obj.value;
			var temp    = new String();
	
			<cfloop query="rsVal">
				temp = '<cfoutput>#rsVal.SNCDvalor#</cfoutput>';
				if (dato == temp){
					alert('El Código de Cuenta Cliente ya existe.');
					obj.value = "";
					obj.focus();
					return false;
				}
			</cfloop>
		}	
		return true;
	}
	document.form1.SNCDvalor.focus();
</SCRIPT>