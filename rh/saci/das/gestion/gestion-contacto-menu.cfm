
<!--- Mostrar Contactos --->
<cfquery datasource="#session.DSN#" name="rsContactos">
	select 	a.Pquien, a.CTid, a.CCtipo,b.Pid
	from  	ISBcontactoCta a
			inner join ISBpersona b
			on b.Pquien = a.Pquien
	where 	a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
</cfquery>

<cfoutput>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="left" titulo="Contactos" tipo="box">
		<script language="javascript" type="text/javascript">
			function goPage3(f, pqc) {
				if (f.cue.value == '' && pqc != '1') {
					alert('Debe seleccionar una cuenta antes de continuar');
				} else {
					f.pqc.value = pqc;
					f.submit();
				}
			}
		</script>
		
		<form name="formContactoOpt" action="#CurrentPage#" method="get" style="margin: 0;">
			<cfinclude template="gestion-hiddens.cfm">
			<table border="0" cellpadding="2" cellspacing="0" width="100%">
			  
				<!--- 1 --->
				<cfloop query="rsContactos">  
					  <tr>
						<td width="1%" align="right">
						  <cfif Form.pqc EQ  rsContactos.Pquien>
							<img src="/cfmx/saci/images/addressGo.gif" border="0">
						  <cfelse>
							&nbsp;
						  </cfif>
						</td>
						<td  nowrap>
							<a href="javascript: goPage3(document.formContactoOpt,#rsContactos.Pquien#);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
								<cfif Form.pqc EQ rsContactos.Pquien><strong></cfif>#rsContactos.Pid#<cfif Form.pqc EQ  rsContactos.Pquien></strong></cfif>
							</a>
						</td>
					  </tr>
				</cfloop>
	
			</table>
		</form>
	<cf_web_portlet_end>  
</cfoutput>
