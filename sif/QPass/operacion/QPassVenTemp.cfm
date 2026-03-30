<cfset application.HSBCWSAddress = 'http://svrdes04/SolicitudSConsultasWS'>

<cfif isdefined("url.QPvtaTagid") and len(trim(url.QPvtaTagid)) and not isdefined("form.QPvtaTagid")>
	<cfset form.QPvtaTagid = url.QPvtaTagid>
</cfif>

<cfquery name="rsTiposCliente" datasource="#session.dsn#">
	select QPtipoCteid, QPtipoCteCod, QPtipoCteMas, QPtipoCteDes
	from QPtipoCliente
	where Ecodigo = #session.Ecodigo#
	order by  QPtipoCteCod, QPtipoCteDes
</cfquery>
<cf_templateheader title="SIF - Quick Pass">
	<cf_web_portlet_start border="true" titulo="Venta Quick Pass" >
		<script language="JavaScript" src="/cfmx/sif/js/MaskApi/masks.js"></script>
		
	<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="100%" valign="top">
				<cfinclude template="QPassVenTemp_form.cfm"> 
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
	function funcFiltrar(){
			document.form2.action='QPassVenTemp.cfm';
			document.form2.submit;
	}
	<cfif modo EQ "ALTA">
		<cfoutput>cambiarMascara(#rsTiposCliente.QPtipoCteid#);</cfoutput>
	</cfif>
	var oQPcteTelefono = new Mask("####-####", "string");
	oQPcteTelefono.attach(document.form1.QPcteTelefono1, oQPcteTelefono, "string");
	oQPcteTelefono.attach(document.form1.QPcteTelefono2, oQPcteTelefono, "string");
</script>

