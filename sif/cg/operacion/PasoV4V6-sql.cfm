<cfsetting requesttimeout="#3600*24*10#">

<html>
<head>
<title>Paso V4 a V6 ...</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
.cajasinbordeb {
	border: 0px none;
	background-color: #FFFFFF;
}
</style>
<cf_templatecss>
</head>

<body marginheight="0" marginwidth="0">

	<cfif isdefined("Form.cantidad") and Len(Trim(Form.cantidad)) and Form.cantidad NEQ 0>
		<cfquery name="rsCuentasDespliegue" datasource="#Session.DSN#">
			select a.CFformato, a.ErrorCta
			from PasaV4V6CuentasD a
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and a.CFcuenta = -100
			and a.Ccuenta is null
		</cfquery>
	
		<cfoutput>
			<table width="100%"  border="0" cellspacing="0" cellpadding="2">
				<tr>
				<td colspan="2" align="center" class="tituloAlterno">Lista de Errores</td>
				</tr>
				<tr>
				<td align="right" width="20%" style="padding-right: 10px; "><strong>Cuenta</strong></td>
				<td style="padding-right: 10px; "><strong>Error</strong></td>
				</tr>
				<cfloop query="rsCuentasDespliegue">
				  <cfset cuenta = rsCuentasDespliegue.CFformato>
				  <cfset error = rsCuentasDespliegue.ErrorCta>
				  <tr>
					<td align="right" width="20%" style="padding-right: 10px; "><strong>#cuenta#</strong></td>
					<td style="padding-right: 10px; ">#HtmlEditFormat(error)#</td>
				  </tr>
				</cfloop>
			</table>
		</cfoutput>
		
	<cfelse>
		
		<cfquery name="rsCuentas" datasource="#Session.DSN#" maxrows="2000">
			select distinct a.Ecodigo, a.Ocodigo, a.CFformato
			from PasaV4V6CuentasD a
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and a.CFcuenta is null
			and a.Ccuenta is null
		</cfquery>
	
		<cfif rsCuentas.recordCount>
			<table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0">
			  <tr>
				<td>&nbsp;</td>
			  </tr>
			  <tr>
				<td>&nbsp;</td>
			  </tr>
			  <tr>
				<td>
				  <table width="100%" height="50%"  border="0" cellpadding="0" cellspacing="0">
					<tr>
					  <td id="td1" width="1%" height="21" bgcolor="#0099FF"></td>
					  <td id="td2" width="100%" height="21"></td>
					  <td width="1%" height="21" nowrap>&nbsp;&nbsp;<input type="text" name="txt1" id="txt1" value="1%" size="3" class="cajasinbordeb"></td>
					</tr>
				  </table>
			 	</td>
			  </tr>
			</table>
		
			<script language="javascript" type="text/javascript">
				function aumentarStatus(strValor){
					var td1 = document.getElementById("td1");
					var txt1 = document.getElementById("txt1");
					td1.width = strValor;
					txt1.value = strValor;
				}
				
				function resetStatus() {
					var td1 = document.getElementById("td1");
					var txt1 = document.getElementById("txt1");
					td1.width = '1%';
					txt1.value = '1%';
				}
			</script>
			
			<cfflush>
		
			<cfset cantidad = 0>
			<form action="#<cfoutput>#GetFileFromPath(GetTemplatePath())#</cfoutput>#" method="post" name="sql" style="margin: 0; ">
				<input type="hidden" name="cantidad" value="0">
				<cfloop query="rsCuentas">
				
					<cftransaction>
						<cfinvoke 
						 component="sif.Componentes.PC_GeneraCuentaFinanciera"
						 method="fnGeneraCuentaFinanciera"
						 returnvariable="LvarMSG">
							<cfinvokeargument name="Lprm_CFformato" value="#rsCuentas.CFformato#"/>
							<cfinvokeargument name="Lprm_Ocodigo" value="#rsCuentas.Ocodigo#"/>
							<cfinvokeargument name="Lprm_Ecodigo" value="#rsCuentas.Ecodigo#"/>
							<cfinvokeargument name="Lprm_fecha" value="#now()#"/>
							<cfinvokeargument name="Lprm_TransaccionActiva" value="yes"/>
						</cfinvoke>
						
						<cfif LvarMSG NEQ "NEW" AND LvarMSG NEQ "OLD">
							<cfset cantidad = cantidad + 1>
							<cfquery name="updCuentaError" datasource="#Session.DSN#">
								update PasaV4V6CuentasD set 
									CFcuenta = -100,
									Ccuenta = null,
									ErrorCta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarMSG#">
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentas.Ecodigo#">
								and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentas.Ocodigo#">
								and CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCuentas.CFformato#">
							</cfquery>
						<cfelse>
							<!--- Actualizar CFcuenta y Ccuenta en el detalle del asiento --->
							<cfquery name="updCuenta" datasource="#Session.DSN#">
								update PasaV4V6CuentasD set 
									CFcuenta = (
										select min(CFcuenta)
										from CFinanciera
										where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentas.Ecodigo#">
										and CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCuentas.CFformato#">
									),
									Ccuenta = (
										select min(Ccuenta)
										from CFinanciera
										where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentas.Ecodigo#">
										and CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCuentas.CFformato#">
									)
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentas.Ecodigo#">
								and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentas.Ocodigo#">
								and CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCuentas.CFformato#">
							</cfquery>
						</cfif>
				
					</cftransaction>

					<cfif CurrentRow mod 200 EQ 0>
						<cfoutput>
						<script language="javascript" type="text/javascript">
							aumentarStatus("#iif(Round(CurrentRow*100/RecordCount) gt 0,Round(CurrentRow*100/RecordCount),1)#%");
						</script>
						</cfoutput>
						<cfflush>
					</cfif>
					
				</cfloop>
			</form>
			
			<script language="JavaScript1.2" type="text/javascript">
				document.forms[0].cantidad.value = '<cfoutput>#cantidad#</cfoutput>'
				if (parseInt(document.forms[0].cantidad.value, 10) > 0) {
					var width = 600;
					var height = 500;
					var top = (screen.height - height) / 2;
					var left = (screen.width - width) / 2;
					resizeTo(width, height);
					moveTo(left, top);
					document.forms[0].submit();
				} else {
					window.close();
					if (window.opener.Listo) window.opener.Listo();
				}
			</script>
			
		<cfelse>
			<script language="JavaScript1.2" type="text/javascript">
				window.close();
				if (window.opener.NoData) window.opener.NoData();
			</script>
		</cfif>
		
	</cfif>

</body>
</html>
 