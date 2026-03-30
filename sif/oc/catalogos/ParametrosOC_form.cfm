<!--- Obtiene los datos de la tabla de Parámetros según el pcodigo --->
<cffunction name="fnLeeParametro" returntype="string">
	<cfargument name="Pcodigo"		type="numeric"	required="true">	
	<cfargument name="Pdescripcion"	type="string"	required="true">	
	<cfargument name="Pdefault"		type="string"	required="false">	
	<cfset var rsSQL = "">
	<cfquery name="rsSQL" datasource="#Session.DSN#">
		select Pvalor
		  from Parametros
		 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">  
		   and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>
	<cfif rsSQL.Pvalor NEQ "">
		<cfreturn rsSQL.Pvalor>
	<cfelseif isdefined("Arguments.Pdefault")>
		<cfreturn Arguments.Pdefault>
	<cfelse>
		<cf_errorCode	code = "50436"
						msg  = "No se ha definido el Parámetro @errorDat_1@ - @errorDat_2@"
						errorDat_1="#Pcodigo#"
						errorDat_2="#Pdescripcion#"
		>
	</cfif>
</cffunction>

<cfset LvarPeriodoAux 		= fnLeeParametro(50,"Período de Auxiliares")>
<cfset LvarMesAux 			= fnLeeParametro(60,"Mes de Auxiliares")>
<cfset LvarCVPendiente		= fnLeeParametro(490,"Mantener Costo de Ventas Pendiente","0")>
<cfset LvarMcodigoValuacion	= fnLeeParametro(441,"Moneda de Valuación de Inventarios","")>
<cfset LvarPrcOCnegativos	= fnLeeParametro(442,"Porcentaje permitido para Existencias Negativas de Tránsito (0-9%)","1")>
<cfset LvarPrcOCcierre		= fnLeeParametro(443,"Porcentaje permitido de sobrantes para Cierre de Transportes (0-99%)","5")>
<cfset LvarSNid				= fnLeeParametro(444,"Socio de Negocios default (propia Empresa) para Movs Origenes diferentes a CxP","")>
<cfset LvarCFcuentaReversar	= fnLeeParametro(980,"Cuenta Financiera de balance para reversión de estimación","")>


<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select Mcodigo, Mnombre from Monedas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsMonedaEmpresa" datasource="#Session.DSN#">
	select Mcodigo from Empresas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<script language="JavaScript" type="text/JavaScript">
<!--
function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_validateForm() { //v4.0
  var i,p,q,nm,test,num,min,max,errors='',args=MM_validateForm.arguments;
  for (i=0; i<(args.length-2); i+=3) { test=args[i+2]; val=MM_findObj(args[i]);
    if (val) { if (val.alt!="") nm=val.alt; else nm=val.name; if ((val=val.value)!="") {
      if (test.indexOf('isEmail')!=-1) { p=val.indexOf('@');
        if (p<1 || p==(val.length-1)) errors+='- '+nm+' no es una dirección de correo electrónica válida.\n';
      } else if (test!='R') { num = parseFloat(val);
        if (isNaN(val)) errors+='- '+nm+' debe ser numérico.\n';
        if (test.indexOf('inRange') != -1) { p=test.indexOf(':');
          min=test.substring(8,p); max=test.substring(p+1);
          if (num<min || max<num) errors+='- '+nm+' debe ser un número entre '+min+' y '+max+'.\n';
    } } } else if (test.charAt(0) == 'R') errors += '- '+nm+' es requerido.\n'; }
  } if (errors) alert('Se presentaron los siguientes errores:\n\n'+errors);
  document.MM_returnValue = (errors == '');
}
//-->
</script>

<cfoutput>
<form action="ParametrosOC_sql.cfm" method="post" name="form1" onSubmit="return valida();">
	<table width="85%" border="0" cellpadding="0" cellspacing="0" align="center">
		<tr>
			<td nowrap>
				Período de Auxiliares:
			</td>
			<td nowrap>
				<select disabled>
					<option>
					<cfif LvarMesAux EQ 1>
						Enero
					<cfelseif LvarMesAux EQ 2>
						Febrero
					<cfelseif LvarMesAux EQ 3>
						Marzo
					<cfelseif LvarMesAux EQ 4>
						Abril
					<cfelseif LvarMesAux EQ 5>
						Mayo
					<cfelseif LvarMesAux EQ 6>
						Junio
					<cfelseif LvarMesAux EQ 7>
						Julio
					<cfelseif LvarMesAux EQ 8>
						Agosto
					<cfelseif LvarMesAux EQ 9>
						Setiembre
					<cfelseif LvarMesAux EQ 10>
						Octubre
					<cfelseif LvarMesAux EQ 11>
						Noviembre
					<cfelseif LvarMesAux EQ 12>
						Diciembre
					</cfif>
						- #LvarPeriodoAux#
					</option>
				</select>
				
			</td>
		</tr>
		<tr>
			<!--- 441. Moneda de Valuación de Inventarios --->	
			<cfquery name="rsMonedas" datasource="#Session.DSN#">
				select Mcodigo, Mnombre from Monedas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			
			<cfquery name="rsMonedaEmpresa" datasource="#Session.DSN#">
				select Mcodigo from Empresas 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>

			<cfif LvarMcodigoValuacion NEQ "">
				<cfset hayLvarMcodigoValuacion = true>
			<cfelse>	
				<cfset hayLvarMcodigoValuacion = false>
				<cfset LvarMcodigoValuacion = rsMonedaEmpresa.Mcodigo>
			</cfif>
			<td nowrap>
				Moneda Valuación Inventarios y Tránsito:   
			</td>
			<td nowrap>
				<select name="McodigoValuacion" <cfif hayLvarMcodigoValuacion> disabled </cfif>>
					<cfloop query="rsMonedas">
						<option value="#rsMonedas.Mcodigo#" <cfif rsMonedas.Mcodigo EQ LvarMcodigoValuacion> selected </cfif>>#rsMonedas.Mnombre#</option>
					</cfloop>
				</select>
			</td>
		</tr>
		<tr>
			<td nowrap>
				Mantener Costo de Ventas pendiente
			</td>
			<td nowrap>
				<input type="checkbox" name="CVpendiente" value="1" <cfif LvarCVPendiente EQ "1">checked</cfif>>
			</td>
		</tr>
		<tr>
			<td nowrap>
				Cuenta financiera de balance para reversión de estimación:
			</td>
			<td nowrap>
			<cfquery name="rsCuentaEstimacion" datasource="#Session.DSN#">
				select CFdescripcion, CFcuenta, CFformato, Ccuenta
				from CFinanciera
				where CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCFcuentaReversar#" null="#Len(Trim(LvarCFcuentaReversar)) EQ 0#" >
			</cfquery>

			<cfif rsCuentaEstimacion.CFcuenta NEQ ''>
				<cf_cuentas conexion="#Session.DSN#" conlis="S" auxiliares="N" movimiento="S" form="form1" frame="frame1" descwidth="50" Ccuenta="CCuentaEstimacion" Cformato="FCEstimacion" Cmayor="MCEstimacion" query="#rsCuentaEstimacion#">
			<cfelse>
				<cf_cuentas conexion="#Session.DSN#" conlis="S" auxiliares="N" movimiento="S" form="form1" frame="frame1" descwidth="50" Ccuenta="CCuentaEstimacion" Cformato="FCEstimacion" Cmayor="MCEstimacion">
			</cfif> 
			</td>
		</tr>
		<tr>
			<td nowrap>
				Socio de Negocios default (propia Empresa) para movimientos orígenes diferentes a CxP:&nbsp;
			</td>
			<td nowrap>
				<cfset valuesArraySN = ArrayNew(1)>
				<cfif len(trim(LvarSNid))>
					<cfquery datasource="#Session.DSN#" name="rsSN">
						select SNid,SNcodigo,SNidentificacion,SNnombre
						from SNegocios
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and   SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarSNid#">
					</cfquery>
					<cfset ArrayAppend(valuesArraySN, rsSN.SNid)>
					<cfset ArrayAppend(valuesArraySN, rsSN.SNcodigo)>
					<cfset ArrayAppend(valuesArraySN, rsSN.SNidentificacion)>
					<cfset ArrayAppend(valuesArraySN, rsSN.SNnombre)>
				</cfif>	
				<cf_conlis
				Campos="SNid,SNcodigo,SNidentificacion,SNnombre"
				valuesArray="#valuesArraySN#"
				Desplegables="N,N,S,S"
				Modificables="N,N,S,N"
				Size="0,0,30,60"
				tabindex="5"
				Title="Lista de Socios de Negocio"
				Tabla="SNegocios"
				Columnas="SNid,SNcodigo,SNidentificacion,SNnombre"
				Filtro=" Ecodigo = #Session.Ecodigo#  order by SNnombre "
				Desplegar="SNidentificacion,SNcodigo,SNnombre"
				Etiquetas="Identificaci&oacute;n,Codigo,Nombre"
				filtrar_por="SNidentificacion,SNcodigo,SNnombre"
				Formatos="S,S,S"
				Align="left,left,left"
				form="form1"
				Asignar="SNid,SNcodigo,SNidentificacion,SNnombre"
				Asignarformatos="S,S,S,S"/>
			</td>
		</tr>
		<tr>
			<td nowrap>
				Porcentaje maximo permitido para Existencias Negativas de Tránsito (0-9%):
			</td>
			<td nowrap>
				<cf_inputNumber name="PrcOCnegativos"	value="#LvarPrcOCnegativos#"	enteros="1" decimales="0" negativos="false" comas="false" default="1">%
			</td>
		</tr>
		<tr>
			<td nowrap>
				Porcentaje maximo permitido de sobrantes para Cierre de Transportes (0-99%):
				&nbsp;&nbsp;&nbsp;
			</td>
			<td nowrap>
				<cf_inputNumber name="PrcOCcierre"		value="#LvarPrcOCcierre#" 		enteros="2" decimales="0" negativos="false" comas="false" default="5">%
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">&nbsp;
				
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<input type="submit" name="btnAceptar" value="Aceptar" />
			</td>
		</tr>
	</table>

</form>
</cfoutput>

<script language="JavaScript1.2">
	function valida() {
		if (document.form1.CVpendiente.checked)
			if (document.form1.CCuentaEstimacion.value == "")
			{
				alert("La cuenta de estimación es obligatoria cuando el Costo de Ventas queda pendiente");
				return false;
			}
		if (document.form1.SNid.value == "")
		{
			alert("El Socio de Negocios default (propia empresa) es obligatorio");
			return false;
		}
		if (document.form1.PrcOCnegativos.value == "")
		{
			alert("El maximo Porcentaje permitido para Existencias Negativas es obligatorio");
			return false;
		}
		if (document.form1.PrcOCnegativos.value == "")
		{
			alert("El maximo Porcentaje permitido de sobrantes para Cierre es obligatorio");
			return false;
		}
		return true;
	}
</script>

