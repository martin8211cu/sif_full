<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td style="text-align:justify">
			#mensArr[11]#
		</td>
  	</tr>
  	<tr>
	<td>
		<cf_web_portlet_start tipo="Box">
			<cfif LoginBloqueado>
				<table  class="cfmenu_menu" width="100%" cellpadding="2" cellspacing="0" border="0">
					<tr><td align="center"><label style="color:##660000">#mensArr[5]#</label></td></tr>
				</table>
			<cfelse>
				<table  class="cfmenu_menu" width="100%" cellpadding="2" cellspacing="0" border="0">
					<tr>
						<td align="right" width="30%"><label><cf_traducir key="sobre">Sobre</cf_traducir></label></td>
						<td>
							<!---<cf_sobre
								form = "#Attributes.form#"
								agente = ""
								sufijo = ""
								responsable = "0"
								mostrarNoAsignados = "true"
								Ecodigo = "#Attributes.Ecodigo#"
								Conexion = "#Attributes.conexion#"
								size="18"
							>--->
							<cf_campoNumerico 
								name="Snumero#Attributes.sufijo#" 
								decimales="-1" 
								size="20" 
								maxlength="10"
							>
						</td>
					</tr>
				</cfif>
			</table>
		<cf_web_portlet_end> 		
	</td></tr>
	<cfif isdefined("Attributes.mens") and len(trim(Attributes.mens))>
		<cfif Attributes.mens EQ 12 or Attributes.mens EQ 13 or Attributes.mens EQ 17 or Attributes.mens EQ 18 or Attributes.mens EQ 19>
		<cfset msgExtra = "">
		<cfif Attributes.mens EQ 19>
					
			<cfinvoke component="saci.comp.ISBparametros" method="Get" returnvariable="VendedorGenerico"
			Pcodigo="222" />
			<cfquery name="rsAgenteGenerico" datasource="#session.dsn#">
				select a.AGid
				from ISBagente a
				  inner join ISBvendedor b
					on a.AGid = b.AGid
				Where b.Vid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#VendedorGenerico#">
			</cfquery>
			
			<cfif rsAgenteGenerico.RecordCount gt 0>
				<cfset msgExtra = " (#rsAgenteGenerico.AGid#)">
			</cfif>
		</cfif>
		<tr><td colspan="2" align="center">
			<label style="color:##660000">#mensArr[Attributes.mens]##msgExtra#</label>
		</td></tr>
		</cfif>
  	</cfif>
</table>
</cfoutput>