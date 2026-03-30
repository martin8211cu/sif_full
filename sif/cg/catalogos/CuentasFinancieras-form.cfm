<cfif isdefined("Form.CFcuenta") and Len(Trim(Form.CFcuenta))>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>

<!--- Para cuando viene de la nueva lista de Cuentas de Mayor para agregar directamente subcuentas sin pasar por el mantenimiento de Cuentas de Mayor --->
<cfif modo EQ "CAMBIO" and isdefined("Session.Ecodigo") and isdefined("Form.Cmayor") and Len(Trim(Form.Cmayor))>
	<cfquery name="rsCuentaFinanciera" datasource="#Session.DSN#">
		select cf.CFcuenta, cf.Ecodigo, cf.Cmayor, cf.CFdescripcion, coalesce(cf.CFdescripcionF, cf.CFdescripcion) as CFdescripcionF, 
			   cf.CFformato, cf.CFpadre, cf.CFmovimiento, cf.ts_rversion, cm.ts_rversion as tsVersionPadre,
			   coalesce(cf2.CFdescripcionF, cf2.CFdescripcion) as DescripcionPadre
		from CFinanciera cf

			inner join CtasMayor cm
			on cf.Cmayor = cm.Cmayor
			and cf.Ecodigo = cm.Ecodigo

			left outer join CFinanciera cf2
			on cf.Ecodigo = cf2.Ecodigo
			and cf.CFpadre = cf2.CFcuenta
			
		where cf.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and cf.Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
		and cf.CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFcuenta#">
	</cfquery>

	<cfset array = ListToArray("#Form.formato#", "-")>
	<cfset sizeArray = ArrayLen(array)>
	<cfset NombresObjetos = "UNO,DOS,TRES,CUATRO,CINCO,SEIS,SIETE,OCHO,NUEVE,DIEZ,ONCE,DOCE,TRECE,CATORCE">
	<cfset arrNombres = ListToArray(NombresObjetos, ",")>
	<cfset cantNombres = ArrayLen(arrNombres)>
	
	<SCRIPT SRC="../../js/qForms/qforms.js"></SCRIPT>
	<SCRIPT LANGUAGE="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
	</SCRIPT>
	
	<script language="JavaScript1.2">
	
		function valida() {		
			if (document.form1.CFdescripcionF.value == ""){			
				alert ("Debe digitar la descripción");
				document.form1.CFdescripcionF.select();
				return false;
			}
			return true;
		}
		
		function CuentasM() {
			document.form1.action='CuentasMayor.cfm';
			document.form1.modo.value = "CAMBIO";
			document.form1.submit();
			return false;
		}
	</script>
	
	<cfoutput>
	<script language="JavaScript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
	<form method="post" name="form1" action="CuentasFinancieras-sql.cfm">
	 <cfif isdefined("url.PageNum_Lista") and not isdefined("url.PageNum")>
		<input name="Pagina" type="hidden" value="#url.PageNum_Lista#">
	 <cfelseif isdefined("form.Pagenum")>
		<input name="Pagina" type="hidden" value="#form.PageNum#">
	 <cfelseif isdefined("form.Pagina")>
		<input name="Pagina" type="hidden" value="#form.Pagina#">
	 </cfif>
	 
	 <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr> 
		  <td width="25%">&nbsp;</td>
		  <td width="14%" align="left" nowrap>Cuenta Padre:&nbsp;</td>
		  <td width="64%">
			  <input name="CFpadreLabel" type="text" readonly value="#rsCuentaFinanciera.DescripcionPadre#" size="32" onfocus="javascript:this.select();" >
			  <input type="hidden" name="CFpadre" value="#rsCuentaFinanciera.CFpadre#" size="32" readonly>
		  </td>
		</tr>
		<tr> 
		  <td>&nbsp;</td>
		  <td align="left" nowrap>Formato:&nbsp;</td>
		  <td>
			  <input name="CFformato" type="text" size="32" value="#trim(rsCuentaFinanciera.CFformato)#" readonly onfocus="javascript:this.select();" >
		  </td>
		</tr>
		<tr> 
		  <td>&nbsp;</td>
		  <td align="left" nowrap>Descripci&oacute;n:&nbsp;</td>
		  <td>
			<input type="text" name="CFdescripcionF" value="#rsCuentaFinanciera.CFdescripcionF#" size="32" onfocus="javascript:this.select();" >
			<input type="hidden" name="CFdescripcion" value="#rsCuentaFinanciera.CFdescripcion#">
		  </td>
		</tr>
		<tr> 
		  <td> 
			  <cfset ts = ""> 
			  <cfset tsPadre = ""> 	  
			  <cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsCuentaFinanciera.ts_rversion#" returnvariable="ts"></cfinvoke>
			  <cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsCuentaFinanciera.tsVersionPadre#" returnvariable="tsPadre"></cfinvoke>		  
		  </td>
		  <td>&nbsp;</td>
		  <td>
			<input type="hidden" name="Cmayor" value="#Form.Cmayor#" size="32"> 
			<input type="hidden" name="CFmovimiento" value="" size="32"> 
			<input type="hidden" name="CFcuenta" value="#Form.CFcuenta#" size="32"> 
			<input type="hidden" name="formato" value="#Form.formato#">
			<input type="hidden" name="modo" value="">
			<input type="hidden" name="ts_rversion" value="#ts#">
			<input type="hidden" name="ts_rversPadre" value="#tsPadre#">
		  </td>		
		</tr>
		<tr> 
		  <td>&nbsp;</td>
		  <td colspan="2" align="center" nowrap>
				<input type="submit" name="Cambio" value="Modificar" onclick="javascript: return valida();" >
				<input name="CuentasMayor" type="button" value="Cuentas Mayor" onClick="CuentasM();">
		  </td>
		</tr>
	
	  </table>
	</form>
	
	<!--- Mantenimiento de cuentas inactivas --->	
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	  <td>&nbsp;</td>
	  <td colspan="2" align="center" nowrap>
	  	<cfinclude template="CuentasFinancieras-Inactivas.cfm">
	  </td>
	</tr>
	</table>
	
	</cfoutput>

<!--- No viene el código de Cuenta Mayor --->
<cfelse>

</cfif>
