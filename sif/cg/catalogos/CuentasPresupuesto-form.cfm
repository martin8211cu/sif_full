<cfif isdefined("Form.CPcuenta") and Len(Trim(Form.CPcuenta))>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>

<!--- Para cuando viene de la nueva lista de Cuentas de Mayor para agregar directamente subcuentas sin pasar por el mantenimiento de Cuentas de Mayor --->
<cfif modo EQ "CAMBIO" and isdefined("Session.Ecodigo") and isdefined("Form.Cmayor") and Len(Trim(Form.Cmayor))>
	<cfquery name="rsCuentaPresupuesto" datasource="#Session.DSN#">
		select cp.CPcuenta, cp.Ecodigo, cp.Cmayor, cp.CPdescripcion, coalesce(cp.CPdescripcionF, cp.CPdescripcion) as CPdescripcionF, 
			   cp.CPformato, cp.CPpadre, cp.CPmovimiento, cp.ts_rversion, cm.ts_rversion as tsVersionPadre,
			   coalesce(cp2.CPdescripcionF, cp2.CPdescripcion) as DescripcionPadre
		from CPresupuesto cp

			inner join CtasMayor cm
			on cp.Cmayor = cm.Cmayor
			and cp.Ecodigo = cm.Ecodigo

			left outer join CPresupuesto cp2
			on cp.Ecodigo = cp2.Ecodigo
			and cp.CPpadre = cp2.CPcuenta
			
		where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and cp.Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
		and cp.CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPcuenta#">
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
			if (document.form1.CPdescripcionF.value == ""){			
				alert ("Debe digitar la descripción");
				document.form1.CPdescripcionF.select();
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
	<form method="post" name="form1" action="CuentasPresupuesto-sql.cfm">
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
			  <input name="CPpadreLabel" type="text" readonly value="#rsCuentaPresupuesto.DescripcionPadre#" size="32" onfocus="javascript:this.select();" >
			  <input type="hidden" name="CPpadre" value="#rsCuentaPresupuesto.CPpadre#" size="32" readonly>
		  </td>
		</tr>
		<tr> 
		  <td>&nbsp;</td>
		  <td align="left" nowrap>Formato:&nbsp;</td>
		  <td>
			  <input name="CPformato" type="text" size="32" value="#trim(rsCuentaPresupuesto.CPformato)#" readonly onfocus="javascript:this.select();" >
		  </td>
		</tr>
		<tr> 
		  <td>&nbsp;</td>
		  <td align="left" nowrap>Descripci&oacute;n:&nbsp;</td>
		  <td>
			<input type="text" name="CPdescripcionF" value="#rsCuentaPresupuesto.CPdescripcionF#" size="32" onfocus="javascript:this.select();" >
			<input type="hidden" name="CPdescripcion" value="#rsCuentaPresupuesto.CPdescripcion#">
		  </td>
		</tr>
		<tr> 
		  <td> 
			  <cfset ts = ""> 
			  <cfset tsPadre = ""> 	  
			  <cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsCuentaPresupuesto.ts_rversion#" returnvariable="ts"></cfinvoke>
			  <cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsCuentaPresupuesto.tsVersionPadre#" returnvariable="tsPadre"></cfinvoke>		  
		  </td>
		  <td>&nbsp;</td>
		  <td>
			<input type="hidden" name="Cmayor" value="#Form.Cmayor#" size="32"> 
			<input type="hidden" name="CPmovimiento" value="" size="32"> 
			<input type="hidden" name="CPcuenta" value="#Form.CPcuenta#" size="32"> 
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
	  	<cfinclude template="CuentasPresupuesto-Inactivas.cfm">
	  </td>
	</tr>
	</table>
	
	</cfoutput>

<!--- No viene el código de Cuenta Mayor --->
<cfelse>

</cfif>
