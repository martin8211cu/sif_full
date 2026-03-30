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

<cfif isDefined("session.Ecodigo") and isDefined("Form.RHPcodigopr") and len(trim(#Form.RHPcodigopr#)) NEQ 0>
	<cf_translatedata name="get" tabla="RHPruebas" col="RHPdescripcionpr" returnvariable="LvarRHPdescripcionpr">
	<cf_dbfunction name="spart" args="#LvarRHPdescripcionpr#°1°55" delimiters="°" returnvariable="LvarRHPdescripcionpr">
	<cfquery name="rsRHPruebas" datasource="#Session.DSN#" >
		Select RHPcodigopr, #LvarRHPdescripcionpr# as RHPdescripcionpr,  ts_rversion
        from RHPruebas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHPcodigopr = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigopr#" >		  
		order by RHPdescripcionpr asc
	</cfquery>
</cfif>

<form action="Pruebas-SQL.cfm" method="post" name="form">
	<cfoutput>
	<table width="67%" height="75%" align="center" cellpadding="0" cellspacing="0">
		<tr><td colspan="5">&nbsp;</td></tr>
		<tr>
			<td width="13%" align="right" nowrap>&nbsp;</td> 
			<td width="16%" align="right" nowrap><strong>#LB_Codigo#:&nbsp;</strong></td>
			<td width="16%"> 
				<input name="RHPcodigopr" type="text"  onFocus="this.select();"  onkeypress="return validar(event)"
				value="<cfif modo neq "ALTA" ><cfoutput>#trim(rsRHPruebas.RHPcodigopr)#</cfoutput></cfif>" size="10" maxlength="5">
			</td>
			<td width="15%" align="right" nowrap>&nbsp;</td>
			<td width="40%">&nbsp;</td>
		</tr>
		<tr>
			<td align="right" nowrap>&nbsp;</td>
			<td align="right" nowrap><strong>#LB_Descripcion#:&nbsp;</strong></td>
			<td colspan="3">
				<input name="RHPdescripcionpr" type="text"  size="60" maxlength="80" onFocus="this.select();"
				value="<cfif modo neq "ALTA"><cfoutput>#trim(rsRHPruebas.RHPdescripcionpr)#</cfoutput></cfif>" >
			</td>
		</tr>
	</table>
	<br>
	
	<cf_botones modo=#modo# regresarMenu="True">
	<cfset ts = "">
	<cfif modo NEQ "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsRHPruebas.ts_rversion#"/>
		</cfinvoke>
	</cfif>  
	<input type="hidden" name="LastOne" id="LastOne" value="ListaNon">
	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>" size="32">
	<input type="hidden" name="ORHPcodigopr"value="<cfif modo neq "ALTA">#rsRHPruebas.RHPcodigopr#</cfif>" size="32">
	</cfoutput>
</form>

<cf_qforms form="form">
<script language="javascript" type="text/javascript">
	<!--//
	<cfoutput>
	objForm.RHPcodigopr.required = true;
	objForm.RHPcodigopr.description="#LB_Codigo#";
	objForm.RHPdescripcionpr.required = true;
	objForm.RHPdescripcionpr.description="#LB_Descripcion#";
	
	function habilitarValidacion(){
		objForm.required("RHPcodigopr,RHPdescripcionpr");		
	}
	
	function deshabilitarValidacion(){
		objForm.required("RHPcodigopr,RHPdescripcionpr",false);
	}
	</cfoutput>	
	function validar(e) {
			tecla = (document.all)?e.keyCode:e.which;
			if (tecla==8) return true;
			patron = /\w/;
			te = String.fromCharCode(tecla);
			return patron.test(te); 
		} 


		/*function mis_datos(){
		var key=document.form.keyCode;
		alert(key);
			if (key < 48 || key > 57){
			window.event.keyCode=0;
		}
		}*/

	//-->
</script>	