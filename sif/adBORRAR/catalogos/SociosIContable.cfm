<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>

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

<cfif modo neq 'ALTA' or isdefined("form.SNcodigo")>
<cfset modo='CAMBIO'>		
	<cfquery datasource="#session.DSN#" name="rsForm1">
		select a.SNcuentacxc as Ccuenta, b.Cdescripcion, b.Cformato
		from SNegocios a, CContables b
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNcodigo#" >
		  and a.SNcuentacxc=b.Ccuenta
	</cfquery>
	
	<cfquery datasource="#session.DSN#" name="rsForm2">
		select a.SNcuentacxp as Ccuenta, b.Cdescripcion, b.Cformato
		from SNegocios a, CContables b
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNcodigo#" >		  
		  and a.SNcuentacxp=b.Ccuenta
	</cfquery>
	
	<!--- <cfquery name="rsListaPrecios" datasource="#Session.DSN#">
		select 
			b.LPid, 
			b.LPdescripcion,
			a.SNcodigo, 
			a.ts_rversion
		from EListaPrecios b
			left outer join SNegocios a
				on a.Ecodigo = b.Ecodigo
				and a.LPid = b.LPid
				and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by b.LPdescripcion
	</cfquery>	 
<cfelse>
	 <cfquery name="rsListaPrecios" datasource="#Session.DSN#">
		select 
			b.LPid, 
			b.LPdescripcion,
			null as SNcodigo
		from EListaPrecios b
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by b.LPdescripcion
	</cfquery>	 --->
</cfif> <!--- modo cambio --->


<script language="JavaScript" type="text/JavaScript">
<!--
 
// ========================================================================================================
var valor = ""

function valido(origen){
	for(var i=0; i<origen.length-1; i++){
		if ( origen.charAt(i)=='-' && i != 3 ){
			return false;
		}
	}
	return true;
}

function anterior(obj, e, d){
	valor = obj.value;
}
function SNtiposocio_change(){
	document.form3.SNtiposocio_check.value = 
		(document.form3.SNtiposocioP.checked?'P':'')+
		(document.form3.SNtiposocioC.checked?'C':'');
}
function SNtiposocio_click(tipo){
	/* Muestra u oculta las cuentas contables */
	var LvarVer = eval("document.form3.SNtiposocio" + tipo + ".checked") ? "" : "none";
	document.getElementById("tdCx"+tipo+"1a").style.display = LvarVer;
	document.getElementById("tdCx"+tipo+"1b").style.display = LvarVer;
	document.getElementById("tdCx"+tipo+"1").style.display = LvarVer;
	document.getElementById("tdCx"+tipo+"2").style.display = LvarVer;
	document.getElementById("tdCx"+tipo+"3").style.display = LvarVer;
}

//-->
</script>

<script language="JavaScript" type="text/JavaScript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function validarSociosIContable(form){
	socios_validateForm(form,'SNnumero', '', 'R', 'SNidentificacion','','R','SNnombre','','R','SNemail','','NisEmail',
		'SNvencompras','','RisNum','SNvenventas','','RisNum','SNFecha','','R','SNtiposocio_check','','R');
	return document.MM_returnValue;
}	
//-->
</script>

<style type="text/css">
	.cuadro{
		border: 1px solid #999999;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
</style>

<cf_templatecss>
<!--- <script language="JavaScript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script> --->

<body>

<form action="SociosIContable-sql.cfm" method="post" name="form3" onSubmit="return validarSociosIContable(this);">
<cfoutput>

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td valign="top"><table width="100%"  border="0" cellspacing="0" cellpadding="2">
      <tr>
        
      </tr>
	  <cfset LvarChecked = modo is "ALTA" or ListFind('A,P', rsSocios.SNtiposocio)>
      <tr>
        <td colspan="2"><span class="subTitulo tituloListas">
          <input type="checkbox" name="SNtiposocioP" id="SNtiposocioP" onClick="SNtiposocio_click('P')" onChange="SNtiposocio_change()" value="1" <cfif LvarChecked> checked </cfif> >
          <label for="SNtiposocioP" style="width:90% ">Este&nbsp;Socio&nbsp;es&nbsp;Proveedor&nbsp;de&nbsp;#session.Enombre#</label>
		  <input type="hidden" name="SNtiposocio_check" value="X" alt="Seleccionar si el Socio es Cliente o Proveedor">
        </span></td>
      </tr>
      <tr>
        <td colspan="2" id="tdCxP1a" <cfif NOT LvarChecked>style="display:none;"</cfif>><strong>Concepto Pago a Terceros por omisión:&nbsp;</strong></td>
      </tr>
      <tr>
        <td colspan="2" id="tdCxP1b" <cfif NOT LvarChecked>style="display:none;"</cfif>>
					<cfif modo NEQ 'ALTA'>
						<cf_cboTESRPTCid query="#rsSocios#">
					<cfelse>
						<cf_cboTESRPTCid>
					</cfif>
		</td>
      </tr>
      <tr>
        <td colspan="2" id="tdCxP1" <cfif NOT LvarChecked>style="display:none;"</cfif>><strong>Cuenta&nbsp;predeterminada&nbsp;para&nbsp;Cuentas&nbsp;por&nbsp;Pagar:&nbsp;</strong></td>
      </tr>
      <tr>
        <td colspan="2" id="tdCxP2" <cfif NOT LvarChecked>style="display:none;"</cfif>>
			<cfif modo NEQ 'ALTA' and rsForm2.RecordCount gt 0 >
				<cf_cuentas conexion="#session.DSN#" conlis="S" frame="frame2" auxiliares="N" movimiento="S" form="form3" ccuenta="SNcuentacxp" cdescripcion="DSNcuentacxp" cformato="FSNcuentacxp" query="#rsForm2#">
			<cfelse>
				<cf_cuentas conexion="#session.DSN#" conlis="S" frame="frame2" auxiliares="N" movimiento="S" form="form3" ccuenta="SNcuentacxp" cdescripcion="DSNcuentacxp" cformato="FSNcuentacxp">
			</cfif>
		</td>
      </tr>
      <tr>
        <td id="tdCxP3" <cfif NOT LvarChecked>style="display:none;"</cfif>>
			<cfset LvarCxC = false>
			<cfinclude template="SocioCuentas.cfm">
		</td>
      </tr>	  
      <tr nowrap style="border-bottom:3px solid ##CCCCCC;"><td colspan="2" style="border-bottom:3px solid ##CCCCCC;">&nbsp;</td></tr>
      <tr nowrap><td colspan="2">&nbsp;</td></tr>
	  <cfset LvarChecked = modo is "ALTA" or ListFind('A,C', rsSocios.SNtiposocio)>
      <tr>
        <td colspan="2" nowrap><span class="subTitulo tituloListas">
          <input type="checkbox" name="SNtiposocioC" id="SNtiposocioC" onClick="SNtiposocio_click('C')" onChange="SNtiposocio_change()" value="1" <cfif LvarChecked> checked </cfif> >
          <label style="width:90% " for="SNtiposocioC">Este&nbsp;Socio&nbsp;es&nbsp;Cliente&nbsp;de&nbsp;#session.Enombre# </label>
        </span></td>
      </tr>
      <tr>
        <td colspan="2" id="tdCxC1a" <cfif NOT LvarChecked>style="display:none;"</cfif>><strong>Concepto Cobro a Terceros por omisión:&nbsp;</strong></td>
      </tr>
      <tr>
        <td colspan="2" id="tdCxC1b" <cfif NOT LvarChecked>style="display:none;"</cfif>>
					<cfif modo NEQ 'ALTA'>
						<cf_cboTESRPTCid query="#rsSocios#" name="TESRPTCidCxC" cxc="true" cxp="no">
					<cfelse>
						<cf_cboTESRPTCid name="TESRPTCidCxC" cxc="true" cxp="no">
					</cfif>
		</td>
      </tr>
      <tr>
        <td colspan="2" id="tdCxC1" <cfif NOT LvarChecked>style="display:none;"</cfif>><strong>Cuenta&nbsp;predeterminada&nbsp;para&nbsp;Cuentas&nbsp;por&nbsp;Cobrar:</strong>&nbsp;</td>
      </tr>
      <tr>
        <td colspan="2" id="tdCxC2" <cfif NOT LvarChecked>style="display:none;"</cfif>>
			<cfif modo NEQ 'ALTA' and rsForm1.RecordCount gt 0 >
				<cf_cuentas conexion="#session.DSN#" conlis="S" frame="frame1" auxiliares="N" movimiento="S" form="form3" ccuenta="SNcuentacxc" cdescripcion="DSNcuentacxc" cformato="FSNcuentacxc" query="#rsForm1#">
			<cfelse>
				<cf_cuentas conexion="#session.DSN#" conlis="S" frame="frame1" auxiliares="N" movimiento="S" form="form3" ccuenta="SNcuentacxc" cdescripcion="DSNcuentacxc" cformato="FSNcuentacxc">
			</cfif>
		</td>
      </tr>
      <tr>
        <td id="tdCxC3" <cfif NOT LvarChecked>style="display:none;"</cfif>>
			<cfset LvarCxC = true>
			<cfinclude template="SocioCuentas.cfm">
		</td>
      </tr>	  
    </table></td>
    <td  width="50%" valign="top">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td colspan="2"><strong>Complemento Financiero para Compras/Ventas con Servicios:</strong></td>
		</tr>
		
		<tr>
			<td colspan="2">
				<input type="text" name="cuentac" size="12" maxlength="100" value="<cfif modo NEQ 'ALTA'>#rsSocios.cuentac#</cfif>" alt="Complemento para Compras/Ventas con Servicios">
			</td>	  
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="2">
				<fieldset style="border:1px solid ##CCCCCC; text-align:center">
					<legend><strong>Complementos Financieros por Origen de Transacción:</strong></legend>
					<BR>
					<cf_sifcomplementofinanciero action='display'
							tabla="SNegocios"
							form = "form3"
							llave="#form.SNcodigo#"
					>	
			</td>
		</tr>
    </table></td>
  </tr>
  <tr>
	<td colspan="2">&nbsp;</td>
  </tr>  
  <tr align="center">
    <td colspan="2">

			<!--- funcActivarUsuario ya está definido en SociosICrediticia --->
			<cf_botones names="Cambio" values="Modificar">	
			<!--- <cf_botones names="Cambio,ActivarUsuario" values="Modificar,Activar como Usuario">	 --->
		<cfif modo neq "ALTA">
      		<cfset ts = "">
      		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsSocios.ts_rversion#" returnvariable="ts">
      		</cfinvoke>
      		<input type="hidden" name="ts_rversion" value="#ts#">
    	</cfif>
		<input type="hidden" name="SNcodigo" value="<cfif modo NEQ "ALTA">#rsSocios.SNcodigo#</cfif>">
		<input type="hidden" name="IContable" value="IContable">
	</td>
    </tr>
  <tr>
    <td colspan="2" valign="top">&nbsp;</td>
    </tr>
</table>

</form>
</cfoutput>
<cfelse>
	<table align="center">
		<tr>
			<td>Primero&nbsp;debe&nbsp;ingresar&nbsp;los&nbsp;<strong>Datos&nbsp;Generales</strong>&nbsp;del&nbsp;Socio&nbsp;de&nbsp;Negocios</td>
		</tr>
	</table>
</cfif>
