<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 09 de junio del 2005
	Motivo:	Nueva opción para Módulo de Tesorería, 
			Consulta de cheques
----------->
<cf_web_portlet_start _start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	<cfset LvarDatosChequesDet = true>
	<cfinclude template="datosCheques.cfm">
	<table width="100%" align="center">
		<tr>
			<td class="formButtons" align="center" colspan="4">
				<form name="form1" method="post">
					<cf_botones tabindex="1" 
					include="ListaCheques" 
					includevalues="Lista de Cheques"
					exclude="Cambio,Baja,Nuevo,Alta,Limpiar"
					>
				</form>
			</td>
		</tr>
	</table>
	<cfinclude template="datosChequesDet.cfm">
<cf_web_portlet_start _end>
<script language="javascript" type="text/javascript">
	function funcListaCheques(){
		location.href='consultaCheques.cfm';
	}
</script>
