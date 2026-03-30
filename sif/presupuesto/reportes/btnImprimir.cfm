<cfparam name="Attributes.Name" 		default="" 	 	type="string">
<cfparam name="Attributes.TipoPagina" 	default="" 	 	type="string"> 
<cfparam name="Attributes.Refrescar" 	default="false"	type="boolean">


<cftry>
	<cfparam name="session.rptRnd" default="#int(rand()*10000)#">
	<cflock timeout="1" name="#Attributes.Name#_#session.rptRnd#" throwontimeout="yes">
		<td>&nbsp;</td>
		<td>
			<input type="submit" name="btnImprimir" id="btnImprimir" value="Imprimir" title="Generar el Reporte en la pantalla con Cortes de Página" onClick="sbPonerCancelar();">
			&nbsp;&nbsp;&nbsp;&nbsp;
			<cfif Attributes.Refrescar>
			<input type="submit" name="btnRefrescar" id="btnRefrescar" value="Refrescar" title="Refrescar Monto de Formulaciones Aprobadas y Tipos de Cambio, y luego Imprimir" onClick="sbPonerCancelar();">
			&nbsp;&nbsp;&nbsp;&nbsp;
			</cfif>
			<input type="submit" name="btnDownload" id="btnDownload" value="Download" title="Generar el Reporte en Excel sin Cortes de Página" onClick="sbPonerCancelar();">
			<input type="submit" name="btnCancelar" id="btnCancelar" value="Cancelar Reporte en proceso" style="display:none;" onclick="if(window.fnbtnCancelar)fnbtnCancelar();">
			<script language="javascript">
				function sbPonerCancelar ()
				{
					var f = document.getElementById("btnImprimir").form;
					f.btnImprimir.style.display = "none";
				<cfif Attributes.Refrescar>
					f.btnRefrescar.style.display = "none";
				</cfif>
					f.btnDownload.style.display = "none";
					f.btnCancelar.style.display = "";
					document.body.onFocus = sbPonerCancelar;
					return true;
				}
			</script>
		</td>
		<td colspan="3">
			<cfoutput>
			Imprimir en tipo de página: <strong style="color:##3366CC" id=tagTipoPagina>#Attributes.TipoPagina#</strong>
			</cfoutput>
		</td>
	</cflock>
<cfcatch type="lock">
		<td>&nbsp;</td>
		<td>
			<input type="submit" name="btnCancelar" id="btnCancelar" value="Cancelar Reporte en proceso">
		</td>
		<td colspan="3">&nbsp;</td>
</cfcatch>
</cftry>