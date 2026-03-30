
<cfparam name="url.plazo"   type="numeric">
<cfparam name="url.interes" type="numeric">
<cfparam name="url.tipo"    default="m">

<cfoutput>

<cfinclude template="refinanciar.cfm">

<cfquery datasource="#session.dsn#" name="pagos_pendientes">
	select Ecodigo,Pcodigo,CCTcodigo,PPnumero,DPmonto
	from DPagos dp
	where dp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and dp.Doc_CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.CCTcodigo#">
	  and dp.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Ddocumento#">
</cfquery>
<cfif pagos_pendientes.RecordCount>
	<table width="80%" align="center" border="0" cellspacing="0" cellpadding="0" style="margin:0 ">
	<tr>
		<td style="color:red"><br><strong>Advertencia:</strong>
			Hay <cfif pagos_pendientes.RecordCount is 1>un pago <cfelse> #pagos_pendientes.RecordCount# pagos </cfif>
			para este documento que a&uacute;n no ha sido aplicado. &nbsp;
			No podr&aacute; cambiar el plan de pagos mientras haya pagos en proceso.&nbsp;
		</td>
	</tr>
	</table>
</cfif>

<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
	query="#calculo#"
	desplegar="PPnumero,img,fecha,principal,intereses,total,saldofinal"
	etiquetas="N&uacute;m,&nbsp;,Fecha,Principal,Intereses,Cuota,Saldo"
	formatos="S,S,D,M,M,M,M"
	align="right,left,left,right,right,right,right"
	checkboxes="N"
	checkedcol="pagado"
	funcion="void(0)"
	MaxRows="0"
	totales="total" keys="PPnumero"
	showLink="false"
	tabindex="4">
</cfinvoke>

<cfif pagos_pendientes.RecordCount is 0>
	<center>
	<form name="form1" action="index4_aplicar.cfm" method="post" style="margin:0">
		<input type="hidden" name="CCTcodigo" value="#HTMLEditFormat(Trim(url.CCTcodigo))#" tabindex="-1">
		<input type="hidden" name="Ddocumento" value="#HTMLEditFormat(Trim(url.Ddocumento))#" tabindex="-1">
		<input type="hidden" name="plazo" value="#HTMLEditFormat(url.plazo)#" tabindex="-1">
		<input type="hidden" name="interes" value="#HTMLEditFormat(url.interes)#" tabindex="-1">
		<input type="hidden" name="mora" value="#HTMLEditFormat(url.mora)#" tabindex="-1">
		<input type="hidden" name="tipo" value="#HTMLEditFormat(url.tipo)#" tabindex="-1">
		<input type="hidden" name="pago_inicial" value="#HTMLEditFormat(url.pago_inicial)#" tabindex="-1">
		<input type="hidden" name="primerfecha" value="#HTMLEditFormat(url.primerfecha)#" tabindex="-1">
		<cfif isdefined('params')><input name="params" type="hidden" value="#params#" tabindex="-1"></cfif>
		<cf_botones values="Aceptar Plan de Pagos,Regresar" names="AceptarPlaP,Regresar" tabindex="1" >
	</form>
	</center>
</cfif><br>
<script language="javascript" type="text/javascript">
	function funcRegresar(){
		location.href = 'index2_revisar.cfm?CCTcodigo=#url.CCTcodigo#&Ddocumento=#url.Ddocumento#&#params#';
		return false;
	}
</script>

</cfoutput>