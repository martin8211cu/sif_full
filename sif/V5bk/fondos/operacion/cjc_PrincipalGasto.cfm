
<!---***************************************************** --->
<!---**es necesario agregar estos templatearea ** --->
<!---***************************************************** --->
<cfset session.sitio.template = "/plantillas/V5/Plantilla.cfm">
<cf_template template="#session.sitio.template#">
<!---***************************************************** --->
<cf_templatearea name="title">
	Pantalla Unica
</cf_templatearea>
<!---***************************************************** --->
<cf_templatearea name="left" >
	<!--- <cfinclude template="../Menu.cfm"> --->
</cf_templatearea>
<cf_templatearea name="body">

<cfif isdefined("url.RESPOSTEO")>
		<cfif LSIsNumeric(url.RESPOSTEO)>
			<script language="JavaScript">
				var NAP 		= "<cfoutput>#url.RESPOSTEO#</cfoutput>";
				var formato   	=  "left=100,top=200,scrollbars=yes,resizable=yes,width=700,height=275"
				var direccion 	= "/cfmx/sif/V5/Utiles/cjc_ErrorNap.cfm?NAP="+NAP
  				open(direccion,"",formato);
			</script>
		<cfelse>
			<script language="JavaScript">
			Resultado = "<cfoutput>#url.RESPOSTEO#</cfoutput>"
			 alert(Resultado)
			</script> 		
		</cfif>
</cfif>
<cfparam name="url.CJX19REL" default="0">
<cfparam name="form.CJX19REL" default="#url.CJX19REL#">
<cfset url.CJX19REL = form.CJX19REL>
<cfif not isdefined("Form.CJX19REL") and not isdefined("url.CJX19REL")>
	<cfset Form.CJX19REL = "0">
<cfelse>
	<cfif isdefined("Form.CJX19REL") and not isdefined("url.CJX19REL")>
		<cfset Form.CJX19REL = "#Form.CJX19REL#">
	<cfelseif not isdefined("Form.CJX19REL") and isdefined("url.CJX19REL")>
		<cfset Form.CJX19REL = "#url.CJX19REL#">
	<cfelseif isdefined("Form.CJX19REL") and isdefined("url.CJX19REL")>
		<cfset Form.CJX19REL = "#Form.CJX19REL#">
	</cfif>	
</cfif>

<cfparam name="url.CJX20NUM" default="0">
<cfparam name="form.CJX20NUM" default="#url.CJX20NUM#">
<cfset url.CJX20NUM = form.CJX20NUM>

<cfparam name="url.CJX21LIN" default="0">
<cfparam name="form.CJX21LIN" default="#url.CJX21LIN#">
<cfset url.CJX21LIN = form.CJX21LIN>

<cfset Gastos    = "../operacion/cjc_PrincipalGasto.cfm?modo=ALTA&CJX19REL=#Form.CJX19REL#">
<cfset Anticipos = "../operacion/cjc_PrincipalAnticipos.cfm?modo=ALTA&CJX19REL=#Form.CJX19REL#">
<cfset Posteo = "../operacion/cjc_PrincipalPosteo.cfm?modo=ALTA&CJX19REL=#Form.CJX19REL#">
<cfset Consulta  = "../operacion/cjc_PrincipalConsulta.cfm?modo=ALTA&CJX19REL=#Form.CJX19REL#">

<!---**************************************** --->
<!---**es necesario agrega este portlets   ** --->
<!---**************************************** --->
<cfinclude template="../../portlets/MenuGastos.cfm">
<link href="/cfmx/sif/V5/css/estilos.css" rel="stylesheet" type="text/css">
<SCRIPT LANGUAGE='Javascript'  src="../../js/utilies.js"></SCRIPT>
<SCRIPT LANGUAGE='Javascript'  src="../../../js/qForms/qforms.js"></SCRIPT>
<!--- *********************** --->
<!---** AREA DE PINTADO    ** --->
<!---************************ --->
<form action="cjc_SqlPrincipalGasto.cfm" method="post" name="form1" 
	  onSubmit="javascript:return finalizar();"
	  onKeyPress="javascript:return fnEnterToDefault(event, this);">
<table width="100%" border="0" >
	<tr>
		<td width="35%"  valign="top">
			<cfinclude template="cjc_formPrincipalGasto.cfm">
		</td>
		<td width="65%" valign="top" >
			<cfinclude template="cjc_formPrincipalGastoDet.cfm">
		</td>
  	</tr>
	<tr><td colspan="2" align="center"> 
		<input type="hidden" name="botonSel" value="">
		<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
		<cfparam  name="modo" default="ALTA">
		<cfparam  name="mododet" default="ALTA">
		<cfif modo EQ "ALTA">
			<cfif url.CJX19REL NEQ "0">
				<input name='CARGA' type='button' value='Carga Aut.' onClick='Llenado_Auto();'>
			</cfif>	
			<input type="submit" name="AltaNueva" value="Agregar y Nueva Factura" onClick="javascript: this.form.botonSel.value = this.name; validar();">
			<input type="submit" name="Alta" value="Agregar y Misma Factura" onClick="javascript: this.form.botonSel.value = this.name; validar();">
			<input type="submit" name="limpiar" value="limpiar" onClick="javascript: this.form.botonSel.value = this.name; novalidar();">			
		<cfelse>	
			<cfif mododet EQ "ALTA">
				<input type="submit" name="Altadet" value="Agregar Linea" onClick="javascript: this.form.botonSel.value = this.name; validar();">
				<input type="submit" name="Cambio" value="Modificar Factura" onClick="javascript: if(this.form.mododet != 'CAMBIO') novalidardet(); this.form.botonSel.value = this.name; validar(); novalidardet();">
			<cfelse>			
				<input type="submit" name="Cambiodet" value="Modificar" onClick="javascript: this.form.botonSel.value = this.name; validar();">
				<input type="submit" name="Bajadet" value="Eliminar Linea" onclick="javascript: novalidar();this.form.botonSel.value = this.name; if ( confirm('¿Desea Eliminar el Registro?') ){ novalidar(); return true; }else{ return false;}">
				<input type="submit" name="Nuevodet" value="Nueva Linea" onClick="javascript: this.form.botonSel.value = this.name; novalidar();">
			</cfif>
			<input type="submit" name="Baja" value="Eliminar Factura" onclick="javascript: novalidar();this.form.botonSel.value = this.name; if ( confirm('¿Desea Eliminar el Registro?') ){ novalidar(); return true; }else{ return false;}">
			<input type="submit" name="Nuevo" value="Nueva Factura" onClick="javascript: novalidar();this.form.botonSel.value = this.name; novalidar();">
		</cfif>

		<input type="submit" name="Posteo" value="Aplicar" onclick="javascript: novalidar() ; this.form.botonSel.value = this.name; if ( confirm('¿Desea Postear la relación?') ){ return true; }else{ return false;}; novalidar();">
		<input type="submit" name="BajaR" value="Eliminar Relación" onclick="javascript: novalidar() ;this.form.botonSel.value = this.name; if ( confirm('¿Desea Eliminar la relación?') ){return true; }else{ return false;}; novalidar();">
	</td></tr>
</table>
</form>

<table width="100%" border="0" >
	<tr>
		<td width="50%"  valign="top">
			<!---<cfif form.CJX19REL neq '0'> --->
				<cfset navegacion = "&CJX19REL=#form.CJX19REL#" > 	
				<cfinvoke 
					component="sif.fondos.Componentes.pListas"
					method="pLista"
					returnvariable="pListaRet">
					<cfinvokeargument name="conexion" value="#session.Fondos.dsn#"/>
					<cfinvokeargument name="tabla" value="CJX020,PLM001"/>
					<cfinvokeargument name="columnas" value="CJX19REL,CJX20NUM,CJX20TIP,CJX20NUF,EMPCED,CJX20TOT"/>
					<cfinvokeargument name="desplegar" value="CJX20NUM,CJX20TIP,CJX20NUF,EMPCED,CJX20TOT"/>
					<cfinvokeargument name="etiquetas" value="Núm.,Tipo,No.Doc.,Empleado,Monto"/>
					<cfinvokeargument name="formatos" value="S,S,S,S,M"/>
					<cfinvokeargument name="filtro" value=" CJX020.EMPCOD = PLM001.EMPCOD and CJX19REL =#Form.CJX19REL#"/>
					<cfinvokeargument name="align" value="right,left,left,left,right"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="MaxRows" value="10"/>
					<cfinvokeargument name="checkboxes" value="N"/>
					<cfinvokeargument name="keys" value="CJX19REL,CJX20NUM"/>
					<cfinvokeargument name="irA" value="cjc_PrincipalGasto.cfm"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
				</cfinvoke>		
			<!---</cfif> --->
		</td>
		<td width="50%" valign="top" >
				<cfinclude template="listaDet.cfm">
		</td>
  	</tr>
 </table>
<!---***************************************************** --->
<cfinclude template="cjc_PrincipalGastoJs.cfm">
</cf_templatearea>
</cf_template>
