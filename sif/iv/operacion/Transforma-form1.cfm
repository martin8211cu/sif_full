<cfquery name="rsTransforma" datasource="#Session.DSN#">
	select ETid 
	from ETransformacion 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and ETfechaProc is null
</cfquery>
<script language="javascript" type="text/javascript">
	function goNext(f) {
		if (f.ETid.value != "") {
			f.submit();
		} else {
			alert('Debe de realizar la carga del archivo de transformación  antes de continuar');
		}
	}
	function refrescar(f) {
			document.form1.action='Transforma.cfm';
			document.form1.submit();

	}
<!---	function cf_ImportarCompleto()
	{
		document.form1.submit();
	}--->
</script>
<link href="../css/iv.css">
<!--- <cfif isdefined("Form.ETid")>
	<cfdump var="#Form.ETid#">
</cfif> --->


<form name="form1" method="post" action="Transforma-form2.cfm">
	<table width="90%" border="0" cellspacing="0" cellpadding="2" align="center">
		<tr>
			<td width="1%" align="left"><img src="../imagenes/num1.GIF" border="0"></td>
			<td align="left" nowrap>
				<strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">Importar Archivo de Producci&oacute;n:</strong>
			</td>
			<td align="right"><cf_sifayuda name="imAyuda" imagen="3" Tip="true" url="/cfmx/sif/Utiles/sifayudahelp.cfm"></td>
		    <td width="1%" rowspan="4" valign="top">
		  	<cfinclude template="MenuPasos.cfm">
		  </td>
		</tr>
		<tr>
			<td colspan="3" class="tituloListas" nowrap>
				Seleccione el archivo que deseea Importar
			</td>
		</tr>
		<tr>
			<td>
				<cfoutput>
					<input type="hidden" name="ETid" value="<cfif isdefined("rsTransforma") and len(trim("rsTransforma.ETid")) neq 0>#rsTransforma.ETid#</cfif>">
				</cfoutput>
			</td>
			<td>
				<cfif rsTransforma.recordCount EQ 0>
					<cf_sifimportar eicodigo="ORDPROD" mode="in" />
				<cfelse>
					<strong>Actualmente ya existen datos de producci&oacute;n importados</strong>
				</cfif>
			</td>
			<td valign="middle" align="left">
            	<cfif rsTransforma.recordCount EQ 0>
                	<input  type="button" name="Refrescar" value="Refrescar" onClick="javascript: refrescar(this.form);">
                <cfelse>
					<input  type="button" name="Siguiente2" value="Siguiente >>" onClick="javascript: goNext(this.form);">
                </cfif>
			</td>
		</tr>
		<tr>
			<td colspan="3" align="center" valign="top">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="4" align="center" valign="top">&nbsp;</td>
		</tr>
	</table>
</form>
	
	
	
