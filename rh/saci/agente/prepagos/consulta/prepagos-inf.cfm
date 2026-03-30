<form action="prepagos.cfm" method="post" name="form1" id="form1" style="margin:0">
	<input name="btnRegresar" type="button" value="Regresar" onClick="javascript: regresar();">
</form>


<script language="javascript" type="text/javascript">
	function regresar(){
		var params = "";
	}
</script>

<cfset params="">
<cfif not isdefined('form.Nuevo') and not isdefined('form.Baja') >
	<cfif isdefined('form.Ucodigo') and form.Ucodigo NEQ ''>
		<cfset params= params&'&Ucodigo='&form.Ucodigo>	
	</cfif>
</cfif>

<cfif isdefined('form.filtro_Ucodigo') and form.filtro_Ucodigo NEQ ''>
	<cfset params= params&'&filtro_Ucodigo='&form.filtro_Ucodigo>	
	<cfset params= params&'&hfiltro_Ucodigo='&form.filtro_Ucodigo>		
</cfif>
<cfif isdefined('form.filtro_Udescripcion') and form.filtro_Udescripcion NEQ ''>
	<cfset params= params&'&filtro_Udescripcion='&form.filtro_Udescripcion>	
	<cfset params= params&'&hfiltro_Udescripcion='&form.filtro_Udescripcion>		
</cfif>
<cfif isdefined('form.filtro_Uequivalencia') and form.filtro_Uequivalencia NEQ ''>
	<cfset params= params&'&filtro_Uequivalencia='&form.filtro_Uequivalencia>	
	<cfset params= params&'&hfiltro_Uequivalencia='&form.filtro_Uequivalencia>		
</cfif>

<cflocation url="prepagos.cfm?Pagina=#Form.Pagina#&Empresa=#session.Ecodigo##params#">