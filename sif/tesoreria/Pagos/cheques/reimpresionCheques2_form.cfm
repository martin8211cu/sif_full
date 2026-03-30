<cf_web_portlet_start _start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	<cfset LvarDatosChequesDet = true>
	<cfinclude template="datosCheques.cfm">
	<table width="100%" align="center">
		<tr>
			<td class="formButtons" align="center" colspan="4">
				<cfset session.Reimpresion2 = getTickCount()>
				<form name="form1" method="post" action="impresionCheques_sql.cfm?Reimpresion=1&Reimpresion2=<cfoutput>#session.Reimpresion2#</cfoutput>">
					<cfquery name="rsCB" datasource="#session.dsn#">
						select Ecodigo
						  from CuentasBancos 
						 where CBid = #form.CBid#
                         	and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">		
					</cfquery>
					<cfquery name="rsLibros" datasource="#session.dsn#">
						select MLconciliado
						  from MLibros 
						 where MLdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESCFDnumFormulario#">
						   and BTid	= (select BTid from BTransacciones where Ecodigo=#rsCB.Ecodigo# and BTcodigo = 'PC')
						   and CBid = #form.CBid#
					</cfquery>
					<cfif rsLibros.MLconciliado EQ "S">
						<font color="#FF0000">
						<cfoutput>
						No se puede reimprimir el Cheque #form.TESCFDnumformulario# porque ya está Conciliado en Libros Bancarios
						</cfoutput>
						</font>
					<cfelse>
						<cf_botones tabindex="1" 
						include="btnCrear,ListaCheques" 
						includevalues="Reimprimir, Lista de Cheques"
						exclude="Cambio,Baja,Nuevo,Alta,Limpiar"
						>
						<cfoutput>
						<input type="hidden" name="TESCFDnumFormulario" value="#form.TESCFDnumFormulario#" tabindex="-1">
						<input type="hidden" name="TESMPcodigo" value="#form.TESMPcodigo#" tabindex="-1">
						<input type="hidden" name="CBid" value="#form.CBid#" tabindex="-1">
						</cfoutput>
					</cfif>
				</form>
			</td>
		</tr>
	</table>
	<cfinclude template="datosChequesDet.cfm">
<cf_web_portlet_start _end>
<script language="javascript" type="text/javascript">
	function funcListaCheques(){
		location.href='reimpresionCheques2.cfm';
	}
</script>
