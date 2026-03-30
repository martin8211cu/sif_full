<script language="JavaScript1.2" >
	function VerWeb(){
		<cfoutput>
			window.open('/minisitio/#Session.Scodigo#/f#Session.Scodigo#.html', 'PáginaWeb');		
		</cfoutput>
	}
</script>
<cfif isdefined("Session.Scodigo")>
	<cfoutput>
	<!-- Soluciones Integrales S.A., Rodolfo Jimenez Jara, 28/08/2003 , San José Costa Rica 
	consultas chm1967@yahoo.com -->
	<table class="area" width="100%" cellspacing="0" cellpadding="0" border="0">
		<tr>
			<td><font color="##009900" size="2"><strong><a href="javascript: VerWeb();">Ir a P&aacute;gina Web</a></strong></font></td>
		</tr>
	</table>
	</cfoutput>
</cfif>
