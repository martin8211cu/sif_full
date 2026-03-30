<!--- Manejo de la navegación --->
<cfset _mostrarLista = isDefined("Form._Filtrar")>
<cfif isDefined('Url.ERNid') and not isDefined('Form.ERNid')>
	<cfset Form.ERNid = Url.ERNid>
	<cfset _mostrarLista = true>
</cfif>
<!--- Siempre Visible --->
<cfset _mostrarLista = true>
<cfif not isDefined('Form.ERNid')>
	<cflocation url="listaXNomina.cfm">
</cfif>
<cfset navegacion = "ERNid=" & Form.ERNid>
<cfset filtro = "">
<!--- Consultas --->
<!--- Encabezado de Registro de Nómina --->
<cfquery name="rsERNomina" datasource="#Session.DSN#">
select 	convert(varchar,ERN.ERNid) as ERNid, 
		ERN.ERNcapturado, 
		convert(varchar,ERNfcarga,103) as ERNfcarga, 
		Tdescripcion, 
		convert(varchar,isnull(CB.CBcc,ERN.CBcc)) as CBcc, 
		CBdescripcion, Mnombre, Msimbolo, Miso4217,
		convert(varchar,ERNfdeposito,103) as ERNfdeposito, 
		convert(varchar,ERNfinicio,103) as ERNfinicio, 
		convert(varchar,ERNffin,103) as ERNffin, 
		convert(varchar,ERNfechapago,103) as ERNfechapago, 
		ERNdescripcion, 
		(select isnull (sum (DRNliquido), 0)
	FROM DRNomina c WHERE c.ERNid = ERN.ERNid) as Importe
	from ERNomina ERN, TiposNomina T, Monedas M, CuentasBancos CB
	where ERN.Ecodigo = T.Ecodigo and ERN.Tcodigo = T.Tcodigo
    	and CB.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		and ERN.Mcodigo = M.Mcodigo
		and ERN.CBcc *= CB.CBcc
		and ERN.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and ERN.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
		and ERNestado = 9
</cfquery>
<cfquery name="rsRHParam" datasource="#Session.DSN#">
	select Pvalor as Pvalor100 from RHParametros where Pcodigo = 100 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<!--- Integridad: Protege integridad de datos en caso de pantalla cargada con cache. --->
<cfif rsERNomina.RecordCount lte 0>
	<cflocation url="listaXNomina.cfm">
</cfif>
<!--- Funciones de Javascript --->
<script language="JavaScript" type="text/javascript" src="../../../js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/javascript">
 	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	// funciones del form
	function mostrarLista() {
		var div_Lista = document.getElementById("div_Lista");
		var div_Mostrar = document.getElementById("div_Mostrar");
		var div_Ocultar = document.getElementById("div_Ocultar");
		div_Lista.style.display = '';
		div_Mostrar.style.display = 'none';
		div_Ocultar.style.display = '';
	}
	function ocultarLista() {
		var div_Lista = document.getElementById("div_Lista");
		var div_Mostrar = document.getElementById("div_Mostrar");
		var div_Ocultar = document.getElementById("div_Ocultar");
		div_Lista.style.display = 'none';
		div_Mostrar.style.display = '';
		div_Ocultar.style.display = 'none';
	}
	function funcEliminar() {
		var form = document.listaMNomina;
		var result = false;
		if (form.chk!=null) {
			if (form.chk.length){
				for (var i=0; i<form.chk.length; i++){
					if (form.chk[i].checked)
						result = true;
				}
			}
			else{
				if (form.chk.checked)
					result = true;
			}
		}
		if (result) {
			if (!confirm('¿Confirma que desea Eliminar los Registros Seleccionados?'))
				result = false;
			else {
				document.listaMNomina.ERNID.value = '<cfoutput>#Form.ERNid#</cfoutput>';
				document.listaMNomina.PVALOR100.value = '<cfoutput>#rsRHParam.Pvalor100#</cfoutput>';
			}
		}
		else
			alert('¡Seleccione el Registro que desea eliminar!');
		return result;
	}
	function funcModificar() {
		var result = false
		//if (confirm('¿Confirma que desea Actalizar los Registros Cambiados?')) {
			document.listaMNomina.ERNID.value = '<cfoutput>#Form.ERNid#</cfoutput>';
			result = true;
		//}
		return result;
	}
	function funcReintentar() {
		var result = false
		if (confirm('¿Confirma que desea Reintentar Pagar esta Nómina?')) {
			document.listaMNomina.ERNID.value = '<cfoutput>#Form.ERNid#</cfoutput>';
			result = true;
		}
		return result;
	}
</script>

<table width="75%" border="0" cellspacing="3" cellpadding="0" align="center" style="margin-left: 10px; margin-right: 10px;">
  <tr> 
    <td nowrap colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td nowrap colspan="4" align="center" bgcolor="#E2E2E2" class="subTitulo">ENCABEZADO 
      DEL REGISTRO DE LA NOMINA</td>
  </tr>
  <cfoutput> 
      <tr> 
        <td nowrap colspan="1" class="fileLabel">N&uacute;mero:</td>
        <td nowrap>&nbsp;#rsERNomina.ERNid#</td>
        <td nowrap colspan="1" class="fileLabel">Descripci&oacute;n:</td>
        <td nowrap>&nbsp;#rsERNomina.ERNdescripcion#</td>
      </tr>
      <tr> 
        <td nowrap class="fileLabel">Tipo N&oacute;mina:</td>
        <td nowrap>&nbsp;#rsERNomina.Tdescripcion#</td>
        <td nowrap class="fileLabel">Cuenta Cliente:</td>
        <td nowrap>&nbsp;(#rsERNomina.CBcc#) #rsERNomina.CBdescripcion#</td>
      </tr>
      <tr> 
        <td nowrap class="fileLabel">Fecha Creaci&oacute;n:</td>
        <td nowrap>&nbsp;#LSDateFormat(rsERNomina.ERNfcarga,"dd/mmm/yyyy")#</td>
        <td nowrap class="fileLabel">Fecha Dep&oacute;sito:</td>
        <td nowrap>&nbsp;#LSDateFormat(rsERNomina.ERNfdeposito,"dd/mmm/yyyy")#</td>
      </tr>
      <tr> 
        <td nowrap class="fileLabel">Fecha Inicio Pago:</td>
        <td nowrap>&nbsp;#LSDateFormat(rsERNomina.ERNfinicio,"dd/mmm/yyyy")#</td>
        <td nowrap class="fileLabel">Fecha Final Pago:</td>
        <td nowrap>&nbsp;#LSDateFormat(rsERNomina.ERNffin,"dd/mmm/yyyy")#</td>
      </tr>
      <tr> 
        <td nowrap class="fileLabel">Importe Total:</td>
        <td nowrap>&nbsp;#rsERNomina.Msimbolo# #LsCurrencyFormat(rsERNomina.Importe,"none")# (#rsERNomina.Miso4217#)</td>
        <td nowrap class="fileLabel">Moneda:</td>
        <td nowrap>&nbsp;#rsERNomina.Mnombre#</td>
      </tr>
      <tr> 
        <td nowrap colspan="4">&nbsp;</td>
      </tr>
  </cfoutput> 
  <tr> 
    <td nowrap colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td nowrap align="center" bgcolor="#E2E2E2" class="subTitulo" colspan="4"> 
      <div id="div_Mostrar" style="display:;"> <a href="javascript: mostrarLista();"> 
        Mostrar Detalle&nbsp;&nbsp;&nbsp; <img src="../../imagenes/abajo.gif" border="0" alt="Mostrar Lista del detalle del Registro de la Nómina"> 
        &nbsp;&nbsp;&nbsp; LISTA DEL DETALLE DEL REGISTRO DE LA NOMINA &nbsp;&nbsp;&nbsp; 
        <img src="../../imagenes/abajo.gif" border="0" alt="Mostrar Lista del detalle del Registro de la Nómina"> 
        &nbsp;&nbsp;&nbsp;Mostrar Detalle </a> </div>
      <div id="div_Ocultar" style="display:none;"> <a href="javascript: ocultarLista();"> 
        Ocultar Detalle&nbsp;&nbsp;&nbsp; <img src="../../imagenes/arriba.gif" border="0" alt="Ocultar Lista del detalle del Registro de la Nómina"> 
        &nbsp;&nbsp;&nbsp; LISTA DEL DETALLE DEL REGISTRO DE LA NOMINA &nbsp;&nbsp;&nbsp; 
        <img src="../../imagenes/arriba.gif" border="0" alt="Ocultar Lista del detalle del Registro de la Nómina"> 
        &nbsp;&nbsp;&nbsp;Ocultar Detalle </a> </div></td>
  </tr>
  <tr> 
    <td nowrap colspan="4" align="center">
	  <div id="div_Lista" style="display:none;"> 
	  	<cfset permitirReintentar = true>
		<cfset permitirModificar = true>
		<cfif rsRHParam.RecordCount gt 0 and len(trim(rsRHParam.Pvalor100)) gt 0 >
			<cfset permitirEliminar = true>
			<cfset Pvalor100 = rsRHParam.Pvalor100>
		<cfelse>
			<cfset permitirEliminar = false>
		</cfif>        
		<cfinclude template="listaMNomina.cfm">
      </div>
      <cfif _mostrarLista>
      	<script language="JavaScript" type="text/javascript">
			mostrarLista();
		</script>
      </cfif> 
	</td>
  </tr>
  <tr> 
    <td nowrap colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td nowrap colspan="4"> <table width="100%" border="0" align="center" cellpadding="2" cellspacing="2" class="ayuda">
        <tr> 
          <td width="7%" nowrap><img src="../../imagenes/Alto.gif" width="48" height="48"></td>
          <td width="93%" nowrap class="fileLabel">
		  		&nbsp;Las Personas en la Lista fueron Rechazadas en el proceso de Pago. Realice los cambios necesarios para que la N&oacute;mina pueda pagarse completamente.<br>
				&nbsp;Nota: Cuando reintente, se le asignar&aacute; un nuevo n&uacute;mero a esta N&oacute;mina.
            </td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td nowrap colspan="4">&nbsp;</td>
  </tr>
</table>

<!--- Consulta los Números de Línea de los Detalles de la Nómina para definir las validaciones a los objetos Pintados de la Lista --->
<cfquery name="rsDRNomina" datasource="#Session.DSN#">
select DRNlinea
from DRNomina
where ERNid = #Form.ERNid# order by DRNapellido1,DRNapellido2,DRNnombre,DRIdentificacion,DRNperiodo
</cfquery>

<!--- Define el Incio y la Cantidad de Registros a los que se les va a poner la Validación para solo validar los objetos Pintados en la Pantalla	--->
<cfif isDefined("MaxRows")>
	<cfset MaxRows_lista = MaxRows>
<cfelse>
	<cfset MaxRows_lista = 20>
</cfif>
<cfif isdefined("Form.Pagina") and Form.Pagina NEQ "">
	<cfparam name="PageNum_lista" default="#Form.Pagina#">
<cfelse>
	<cfparam name="PageNum_lista" default="1">
</cfif>
<cfset StartRow_lista=Min((PageNum_lista-1)*MaxRows_lista+1,Max(rsDRNomina.RecordCount,1))>

<!--- Define las Validaciones --->
<script language="JavaScript" type="text/javascript">
	//Validaciones del Encabezado Registro de Nomina
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("listaMNomina");
	//Validaciones del Detalle
	<cfif permitirModificar>
		<cfoutput query="rsDRNomina" startrow="#StartRow_lista#" maxrows="#MaxRows_lista#">
		<!---<cfoutput query="rsDRNomina"> --->		
			if (document.listaMNomina.CBcc#DRNlinea#) {
			objForm.CBcc#DRNlinea#.required = true;
			objForm.CBcc#DRNlinea#.description = "Cuenta Cliente Linea #DRNlinea#.";		
			objForm.CBcc#DRNlinea#.validateNumeric("El valor para " + objForm.CBcc#DRNlinea#.description + " debe ser numérico.");
			objForm.CBcc#DRNlinea#.validate = true;
			}
		</cfoutput>
	</cfif>
</script>