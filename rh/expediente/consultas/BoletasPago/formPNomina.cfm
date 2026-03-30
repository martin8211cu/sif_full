<!---=============== IMPLEMENTACION DEL FORMATO DE ENVIO DE LA BOLETA =======================--->
<cfset tipo = 10> 
<!---  Por default tendra valor 10 para que use la boleta estándar (carta)--->
<!--- busca el tipo de boleta de pago definido en parametros generales de RH --->
<cfquery name="RSParametro" datasource="#session.DSN#">
	select ltrim(rtrim(Pvalor)) as tipo  
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo = 720				
</cfquery>
<cfif isdefined("RSParametro") and len(trim(RSParametro.tipo))>
	<cfset tipo = RSParametro.tipo>
</cfif> 
<cfswitch expression="#tipo#"> 
	<cfcase value="10"> 
		<cfset Ruta.pago 		= '/cfmx/rh/expediente/consultas/BoletasPago/EnviarEmails.cfm'>
	</cfcase> 
	<cfcase value="20">
		<cfset Ruta.pago        = '/cfmx/rh/expediente/consultas/BoletasPago/EnviarEmailsDosTercios.cfm'>
	</cfcase>
	<cfcase value="30">
		<cfset Ruta.pago        = '/cfmx/rh/expediente/consultas/BoletasPago/EnviarEmailsDosTercios.cfm'>
	</cfcase>
	<cfdefaultcase> 
		<cfset Ruta.pago        = '/cfmx/rh/expediente/consultas/BoletasPago/EnviarEmails.cfm'>
	</cfdefaultcase> 
</cfswitch> 
<!---========================================================================================--->

<!--- Parámetros de la lista de la lista de detalles de la Nómina --->
<cfset irA = "SQLPNomina.cfm">
<cfset showlink = "false">
<cfset filtro = "">
<cfset navegacion = "">

<!--- Manejo de la navegación de la lista de detalles de la Nómina --->
<cfif isDefined('Url.ERNid') and not isDefined('Form.ERNid')>
	<cfset Form.ERNid = Url.ERNid>
</cfif>
<cfif not isDefined('Form.ERNid')>
	<cflocation url="listaPNomina.cfm">
</cfif>
<cfset navegacion = "ERNid=" & Form.ERNid>
<cfif isDefined("Url.HDRNestado") and not isDefined("Form.HDRNestado")>
	<cfset Form.HDRNestado = Url.HDRNestado>
</cfif>
<cfif isdefined("Form.HDRNestado") and Len(Trim(Form.HDRNestado)) NEQ 0 and (Trim(Form.HDRNestado) NEQ 0)>
	<cfset filtro = filtro & " and a.DRNestado = " & Trim(Form.HDRNestado)>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "HDRNestado=" & Form.HDRNestado>
</cfif>

<!--- Consultas --->
<!--- 1. Pendientes: Consulta los detalles de la nómina con estado pendiente. --->
<cfquery name="rsPendientes" datasource="#Session.DSN#">
	select 1 as dato
	from HDRNomina 
	where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
</cfquery>

<!--- JavaScript --->
<script language="JavaScript1.2" type="text/javascript">
	
	function funcEnviarEmails() {
		var width = 450;
		var height = 200;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		<cfoutput>
		//var nuevo = window.open('EnviarEmails.cfm?ERNid=#Form.ERNid#','ListaEmpleados','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
			var nuevo = window.open('#Ruta.pago#?ERNid=#Form.ERNid#','ListaEmpleados','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
		</cfoutput>
		nuevo.focus();
	}
</script>

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="65%" valign="top">
		<!--- Columna 1 --->
		<cfquery name="RStitulo" datasource="#session.DSN#">
			SELECT HERNdescripcion  FROM HERNomina
			WHERE ERNid = #Form.ERNid#
		</cfquery>
		
		<table border="0" cellspacing="0" cellpadding="0" width="95%" align="center">
		  <tr>
		  	<td><b><cfoutput>#RStitulo.HERNdescripcion#</cfoutput></b>
			</td>
		  </tr>
		  <tr>
		  	<td>&nbsp;
			</td>
		  </tr>
		  <tr>
			<td>
				<table width="100%"  border="0" cellspacing="2" cellpadding="0">
				  <tr>
				  	<td valign="baseline" width="1%">
						<form action="PNomina.cfm" method="post"  name="formSel" style="margin:0;">
							<input type="hidden" name="ERNid" value="<cfoutput>#Form.ERNid#</cfoutput>">
						</form>
					</td>
					<td valign="baseline" align="left" nowrap>
						&nbsp;
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Enviar"
						Default="Enviar"
						returnvariable="BTN_Enviar"/>
						<input type="button" style="width:80px;" onClick="javascript:funcEnviarEmails();" value="<cfoutput>#BTN_Enviar#</cfoutput>">&nbsp;<cf_translate  key="LB_EnviarBoletasDePagoPorCorreo">Enviar Boletas de Pago por Correo</cf_translate>
					</td>
				  </tr>
				</table>
				<br>
			</td>
		  </tr>
		  <tr>
			<td>
				 <cfinclude template="filtroDNomina.cfm">
				<cfinclude template="listaDNomina.cfm">
			</td>
		  </tr>
		  <tr>
			<td align="center">
				<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Regresar"
						Default="Regresar"
						returnvariable="BTN_Regresar"/>
						<input type="button" style="width:80px;" onClick="javascript: history.back();" value="<cfoutput>#BTN_Regresar#</cfoutput>"> 
			</td>
		  </tr>
		</table>
	</td>
  </tr>
</table>