
<cfif isdefined("url.CTTCid") and len(trim(url.CTTCid))>
	<cfset form.CTTCid = url.CTTCid> 
</cfif>
<cfif isdefined("url.CTTCdescripcion") and len(trim(url.CTTCdescripcion))>
	<cfset form.CTTCdescripcion = url.CTTCdescripcion> 
</cfif>
<cfif isdefined("url.Ecodigo") and len(trim(url.Ecodigo))>
	<cfset form.Ecodigo = url.Ecodigo> 
</cfif>
<cfif isdefined("url.CTfecha") and len(trim(url.CTfecha))>
	<cfset form.CTfecha = url.CTfecha> 
</cfif>	
<cfif isdefined("url.CTContid") and len(trim(url.CTContid))>
	<cfset form.CTContid = url.CTContid> 
</cfif>	
<cfif isdefined("url.CTCnumContrato") and len(trim(url.CTCnumContrato))>
	<cfset form.CTCnumContrato = url.CTCnumContrato> 
</cfif>	
<cfif isdefined("url.CTMcodigo") and len(trim(url.CTMcodigo))>
	<cfset form.CTMcodigo = url.CTMcodigo> 
</cfif>	
<cfif isdefined("url.modo") and len(trim(url.modo))>
	<cfset form.modo = url.modo> 
</cfif>	 
<cfif isdefined("url.CTCdescripcion") and len(trim(url.CTCdescripcion))>
	<cfset form.CTCdescripcion = url.CTCdescripcion> 
</cfif>	 
<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo))>
	<cfset form.SNcodigo = url.SNcodigo> 
</cfif>	 
<cfif isdefined("url.SNnombre") and len(trim(url.SNnombre))>
	<cfset form.SNnombre = url.SNnombre> 
</cfif>	 
<cfif isdefined("url.SNnumero") and len(trim(url.SNnumero))>
	<cfset form.SNnumero = url.SNnumero> 
</cfif>	 
<cfif isdefined("url.TipoImpresion") and len(trim(url.TipoImpresion))>
	<cfset form.TipoImpresion = url.TipoImpresion> 
</cfif>	
 
<!--- Si la tipo de transacción de la factura tiene asignado un formato de impresión genera el reporte PDF en pantalla  --->
<!--- *1* --->
<cfset bandImpresion = false>

<cfquery name="rsTipoContrato" datasource="#Session.DSN#">
	select a.Ecodigo,a.CTCnumContrato, a.CTTCid, a.CTCid, rtrim(b.FMT01COD) as formato,CTContid
	from CTContrato a
		 inner join CTTipoContrato b
			on a.Ecodigo = b.Ecodigo
			and a.CTTCid = b.CTTCid 
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTContid#">
</cfquery> 

<cfif rsTipoContrato.recordcount gt 0 and len(trim(rsTipoContrato.formato)) >
	<cfquery name="rsFormato" datasource="#session.DSN#">
		select FMT01tipfmt, FMT01cfccfm
		from FMT001
		where (Ecodigo is null or Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
		  and FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsTipoContrato.formato)#">
	</cfquery>


<!---	<cfdump var="#rsFormato#">--->
	<cfif trim(rsFormato.FMT01tipfmt) eq 1 >
		<cfset LvarArchivo = trim(rsFormato.FMT01cfccfm) >
		<cfinclude template="../../Utiles/validaUri.cfm">
		<cfset LvarOk = validarUrl( trim(rsFormato.FMT01cfccfm) ) >
		<cfif not LvarOK ><cf_errorCode	code = "50274"
		                  				msg  = "No existe el archivo indicado para el formato estático: @errorDat_1@"
		                  				errorDat_1="#LvarSPhomeuri#"
		                  ></cfif>
	</cfif> 
</cfif>

<cfif isdefined("LvarArchivo") > 	
	<cf_templateheader title="Contratos - Reimpresion de Contratos">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Contratos'>
			<cfinclude template="../../portlets/pNavegacion.cfm">

			<cfset parametros = "">
			<cfif isdefined("rsTipoContrato.CTCnumContrato") and len(trim(rsTipoContrato.CTCnumContrato))>
				<cfset parametros = parametros & "&CTCnumContrato=" & rsTipoContrato.CTCnumContrato & "&CTContid=" & rsTipoContrato.CTContid >
			</cfif>

			<cf_rhimprime datos="#LvarArchivo#" paramsuri="#parametros#"> 


			<cfinclude template="#LvarArchivo#">
			<DIV align="center"><input name="btnRegresar" class="btnNormal" type="button" value="Regresar" onClick="javascript:location.href='contrato-reimprimir.cfm'" >

                <input type="button"  class="btnNormal" value="Anotaciones y Documentos" name="Anotaciones" onclick="
                funcAnotaciones(<cfoutput>
                <cfif isdefined('form.CTContid') and len(trim(#form.CTContid#))>#form.CTContid#</cfif></cfoutput>);">

            
            
            </DIV>
            
            
			<br>
			
		<cf_web_portlet_end>
	<cf_templatefooter>
	<cfset bandImpresion = true>
<cfelse>
	<cfif rsTipoContrato.RecordCount GT 0>

		<cfinclude template= "/sif/reportes/#session.Ecodigo#_#rsTipoContrato.Formato#.cfm">
			
	<cfelse>
		<script>alert('No hay Formato de Impresión para este tipo de contrato!.');</script>
	</cfif>
	<cfset bandImpresion = true>		
</cfif>


<script language="JavaScript" type="text/javascript">
	function funcAnotaciones(CTContid) { 
	var Ecodigo = "<cfoutput>#rsTipoContrato.Ecodigo#</cfoutput>";
	var Consulta = 1;

	location.href = "../operacion/Contratos_frameAnotacion.cfm?CTContid="+CTContid+"&Ecodigo="+Ecodigo+"&Consulta="+Consulta;


		return false;
	}
</script>

