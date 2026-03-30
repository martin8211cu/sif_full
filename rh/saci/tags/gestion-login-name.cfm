
<cfquery datasource="#Attributes.Conexion#" name="rsLog">
	select 	LGnumero,LGlogin
	from 	ISBlogin 
	where 	LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idlogin#">
			and Habilitado =1
</cfquery>
<cfoutput>
<table width="100%" cellpadding="2" cellspacing="0" border="0">
	<tr>
		<td style="text-align:justify">
			Especificar el nuevo login, por el que desea remplazar el actual. 
		</td>
	</tr>
	
	<tr>
		<td>
			<cf_web_portlet_start tipo="box">
				<cfif LoginBloqueado>
					<table  class="cfmenu_menu" width="100%" cellpadding="2" cellspacing="0" border="0">
						<tr><td align="center"><label style="color:##660000">#mensArr[5]#</label></td></tr>
					</table>
				<cfelse>	
					<table  class="cfmenu_menu" width="100%" cellpadding="2" cellspacing="0" border="0">
						<tr>
							<td align="right"><label><cf_traducir key="actual">Actual&nbsp;</cf_traducir><label></td>
							<td>
								#rsLog.LGlogin#
								<input name="LGnumero#Attributes.sufijo#" type="hidden" value="#rsLog.LGnumero#"  tabindex="1"/>
								<input name="login#Attributes.sufijo#" type="hidden" value="#rsLog.LGlogin#"  tabindex="1"/>
							</td>
						<tr></tr>
							<td align="right"><label><cf_traducir key="nuevo">Nuevo&nbsp;</cf_traducir><label></td>
							<td>
								<cf_login
									idpersona = "#Attributes.idpersona#"
									loginid = ""
									value = ""
									form = "#Attributes.form#"
									sufijo = "2#Attributes.sufijo#"
									Ecodigo = "#Attributes.Ecodigo#"
									Conexion = "#Attributes.Conexion#">
							</td>
						</tr>
					</table>
				</cfif>
			<cf_web_portlet_end> 
		</td>
	</tr>
</table>
</cfoutput>