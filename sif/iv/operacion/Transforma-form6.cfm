<cf_templateheader title="  Inventarios">
	
		
	<link type="text/css" rel="stylesheet"  href="../css/iv.css">
	
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

	<cfquery name="rsForm" datasource="#Session.DSN#">
		select 
		<cf_dbfunction name="to_char" args="ETid"> as ETid, 
		<cf_dbfunction name="to_char" args="ETdocumento"> as ETdocumento, 
		ETfecha, 
		ETfechaProc,  
		ETobservacion, 
		<cf_dbfunction name="to_char" args="Usucodigo"> as Usucodigo, 
		Ulocalizacion, 
		coalesce(ETcostoProd, 0.00) as ETcostoProd, 
		ts_rversion 
			from ETransformacion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETid#">
	</cfquery>

	<script language="javascript" type="text/javascript">
		
		function goPrevious(f) {
			location.href =  "/cfmx/sif/iv/operacion/Transforma-form5.cfm";
		}
	
		function goNext(f) {
			location.href =  "/cfmx/sif/iv/operacion/Transforma-form7.cfm";
		}
	
		function goReporte(f) {
			location.href =  "/cfmx/sif/iv/consultas/transfProducto-SQL.cfm?ETid=<cfoutput>#form.ETid#</cfoutput>";
		}	
	</script>

	<form name="form1" method="post" style="margin: 0;" action="SQLCalcular.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Transformación de Productos">
		<cfinclude template="/sif/portlets/pNavegacion.cfm"> 
		<table width="90%" border="0" cellspacing="1" cellpadding="1" align="center">
		 <tr>
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					 <tr>
						<td width="1%" align="left">
							<img src="../imagenes/num6.GIF" border="0">
						</td>
						<td align="left">
							<strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">C&aacute;lculo de Costos de Producci&oacute;n:</strong>
						</td>
						<td align="right">
							<cf_sifayuda name="imAyuda" imagen="3" Tip="true" url="/cfmx/sif/Utiles/sifayudahelp.cfm">
						</td>
					  </tr>
					  <tr>
						<td colspan="3" class="tituloListas" nowrap>
							Oprimar el bot&oacute;n de 'Calcular' para calcular los costos de producci&oacute;n
						</td>
					  </tr>
				</table>
			</td>
		  </tr>
		  <tr>
		  	<td>
			
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Encabezado">
				<cfoutput>
					<input name="ETid" type="hidden" value="#rsForm.ETid#">
					<table width="100%" border="0" cellpadding="1" cellspacing="1" dwcopytype="CopyTableRow">
					  <tr>
						<td><div align="right"><strong>Documento:</strong></div></td>
						<td>
							#Trim(rsForm.ETdocumento)#
						</td>
						<td><div align="right"><strong>Fecha:</strong></div></td>
						<td>&nbsp;
							#LSDateFormat(rsForm.ETfecha, 'DD/MM/YYYY')#
						</td>
						<td nowrap><div align="right"><strong>Gastos:</strong></div></td>
						<td> 
							#LSNumberFormat(rsForm.ETcostoProd,',9.00')#
						</td>
					  </tr>
					  <tr>
						<td valign="top"><div align="right"><strong>Observaci&oacute;n:</strong></div></td>
						<td colspan="5">
						  #rsForm.ETobservacion#
						</td>
					  </tr>
					</table>
				</cfoutput>
			<cf_web_portlet_end>

			</td>
		  </tr>
		  <tr>
			<td align="center">
				<input  type="button" name="Anterior" value="<< Anterior" onClick="javascript: goPrevious(this.form);">
				<input  type="submit" name="btnCalcular" value="Calcular">
				<input  type="button" name="btnRepTransProd" value="Rep. Transform. Productos" onClick="javascript: goReporte(this.form);">
				<input  type="button" name="Siguiente" value="Siguiente >>"  onClick="javascript: goNext(this.form);">
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
	</form>
	
	<cf_templatefooter>