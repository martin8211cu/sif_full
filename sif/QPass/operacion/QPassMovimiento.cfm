<cfquery name="rsTiposCliente" datasource="#session.dsn#">
	select QPtipoCteid, QPtipoCteCod, QPtipoCteMas, QPtipoCteDes
	from QPtipoCliente
	where Ecodigo = #session.Ecodigo#
	order by QPtipoCteDes, QPtipoCteCod
</cfquery>
<cf_templateheader title="SIF - Quick Pass">
	<cf_web_portlet_start border="true" titulo="Movimientos Quick Pass" >
		<script language="JavaScript" src="/cfmx/sif/js/MaskApi/masks.js"></script>
		
	<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<cfinclude template="QPassMovimiento_form.cfm"> 
			</td>			
		</tr>
	</table>
	<br>
	<cf_web_portlet_end>
<cf_templatefooter>

<script language="JavaScript" type="text/javascript">
	var f = document.form1;
	var oCedulaMask = new Mask("", "string");
	function cambiarMascara(v) 
	{
		document.form1.CTEidentificacion.value = "";
		<cfoutput query="rsTiposCliente">
			if (v == '#rsTiposCliente.QPtipoCteid#')
			{
				oCedulaMask.mask = "#replace(rsTiposCliente.QPtipoCteMas,'X','##','ALL')#";
				document.form1.SNmask.value = oCedulaMask.mask;
				oCedulaMask.attach(document.form1.CTEidentificacion, oCedulaMask.mask, "string", "","","","funcCliente();");
			}
		</cfoutput>
	}
	try{
		document.form.QPcteid.focus();	
	}catch(e){
	}
	<cfif modo EQ "ALTA">
		<cfoutput>cambiarMascara(#rsTiposCliente.QPtipoCteid#);</cfoutput>
	</cfif>
</script>


