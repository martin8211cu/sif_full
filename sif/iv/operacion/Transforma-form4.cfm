<cf_templateheader title="  Inventarios">
	
		

	<link type="text/css" rel="stylesheet"  href="../css/iv.css">
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!-- modo para el detalle -->
<cfif isdefined("form.DTlinea")>
	<cfset modoDet="CAMBIO">
<cfelse>
	<cfif not isdefined("form.DTlinea")>
		<cfset modoDet="ALTA">
	<cfelseif form.modoDet EQ "CAMBIO">
		<cfset modoDet="CAMBIO">
	<cfelse>
		<cfset modoDet="ALTA">
	</cfif>
</cfif>

<cfquery name="rsTransforma" datasource="#Session.DSN#">
	select ETid 
	from ETransformacion 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and ETfechaProc is null
</cfquery>

<cfif isdefined("rsTransforma") and len(trim(rsTransforma.ETid)) NEQ 0> 
	<cfset form.ETid = rsTransforma.ETid>
	<cfset modo="CAMBIO">
	<cfset modoDet="ALTA">
</cfif>

<script language="javascript" type="text/javascript">
	
	function goPrevious(f) {
		location.href = "/cfmx/sif/iv/operacion/Transforma-form3.cfm";
		
	}

	function goConcil(f) {
		location.href =  "/cfmx/sif/iv/operacion/GastosProduccion.cfm";
	}

	function goNext(f) {
		location.href =  "/cfmx/sif/iv/operacion/Transforma-form5.cfm";
	}

</script>
		
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Transformación de Productos">
	<cfinclude template="/sif/portlets/pNavegacion.cfm"> 
	<table width="90%" border="0" cellspacing="1" cellpadding="1"  align="center">
		 <tr>
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					 <tr>
						<td width="1%" align="left"><img src="../imagenes/num4.GIF" border="0"></td>
						<td align="left"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">Captura de Gastos de Producci&oacute;n:</strong></td>
						<td align="right"><cf_sifayuda name="imAyuda" imagen="3" Tip="true" url="/cfmx/sif/Utiles/sifayudahelp.cfm"></td>
					  </tr>
					   <tr>
							<td colspan="3" class="tituloListas" nowrap>
								Ingrese los gastos de producci&oacute;n de los conceptos solicitados seg&uacute;n corresponda aquí:
							</td>
						</tr>
				</table>
			</td>
		</tr>
	  <tr>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
		<td>
			<cfinclude template="GastosProduccion-form.cfm">
		</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
		<td>
			<input type="hidden" name="ETid_" value="<cfoutput>#Form.ETid#</cfoutput>">
		</td>
	  </tr>
	</table>
   <cf_web_portlet_end>
	<cf_templatefooter>