<cfif isdefined("url.login") and Len(Trim(url.login)) and isdefined("url.sufijo")>

	<!--- Verificar existencia de Login --->
	<cfinvoke component="saci.comp.ISBlogin" method="Existe" returnvariable="ExisteLogin">
		<cfinvokeargument name="LGlogin" value="#url.login#">
		<cfif isdefined("url.loginid") and Len(Trim(url.loginid))>
			<cfinvokeargument name="LGnumero" value="#url.loginid#">
		</cfif>
	</cfinvoke>
		
			
	<cfoutput>
	
		<script language="javascript" type="text/javascript">
			if (window.parent != null) {
			
			<cfif ExisteLogin>							   
				if (window.parent.set_indicadores#url.sufijo#)  window.parent.set_indicadores#url.sufijo#(2);
				if (window.parent.doConlisChgLogin#url.sufijo#) window.parent.doConlisChgLogin#url.sufijo#();
				if (window.parent.o) {
				 							window.parent.o('img_login_ok#url.sufijo#').style.display = 'none';
											window.parent.o('img_login_mal#url.sufijo#').style.display = '';
									}
			<cfelse>
				if (window.parent.set_indicadores#url.sufijo#) window.parent.set_indicadores#url.sufijo#(1);
				if (window.parent.o) {
					window.parent.o('img_login_ok#url.sufijo#').style.display = '';
					window.parent.o('img_login_mal#url.sufijo#').style.display = 'none';
				}
	
			</cfif>
			}
		</script>
	</cfoutput>
	
</cfif>