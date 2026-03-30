<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
		<cfset Generar = t.Translate('BTN_Generar','Generar')>
        <cfset Regresar = t.Translate('BTN_Regresar','Regresar')>

<cfif not isdefined('form.formato') and isdefined('url.formato')>
	<cfset form.formato = url.formato>
<cfelse>
	<cfset url.formato = form.formato>
</cfif>

<cfif isdefined("url.Formato") and len(trim(url.Formato)) and form.formato EQ "excel">

	<cfinclude template="DocumentosNoAplicados-frame.cfm">

<cfelseif isdefined("url.Formato") and len(trim(url.Formato))>

<cfset checkParametros="">
	<cfoutput>
		<form name="form1" method="post">
		 <table border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td><strong><cf_translate key = LB_Formato>Visualizar en formato</cf_translate>:</strong></td>
				<td>
					<select name="formato">
						<option value="flashpaper" <cfif form.formato EQ "FlashPaper">selected</cfif> >FLASHPAPER</option>
						<option value="pdf" <cfif form.formato EQ "pdf">selected</cfif> >PDF</option>
						<option value="excel" <cfif form.formato EQ "excel">selected</cfif> >Excel</option>
					</select>
				</td>
				<td><input name="visualiza" type="submit" value="#Generar#"></td>
				<td><input name="Regresar" type="button" value="#Regresar#" onclick="funcRegresar()"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			</table>	
			<input type="hidden" name="EdocumentoI" value="#url.EdocumentoI#">
			<input type="hidden" name="EdocumentoF" value="#url.EdocumentoF#">
			<input type="hidden" name="loteini" value="#url.loteini#">
			<input type="hidden" name="periodoini" value="#url.periodoini#">
			<input type="hidden" name="mesini" value="#url.mesini#">
			<input type="hidden" name="fechaIni" value="#url.fechaIni#">
			<input type="hidden" name="lotefin" value="#url.lotefin#">
			<input type="hidden" name="periodofin" value="#url.periodofin#">
			<input type="hidden" name="mesfin" value="#url.mesfin#">
			<input type="hidden" name="fechaFin" value="#url.fechaFin#">
			<input type="hidden" name="Usuario" value="#url.Usuario#">
			<input type="hidden" name="ordenamiento" value="#url.ordenamiento#">
			<input type="hidden" name="origen" value="#url.origen#">
			<input type="hidden" name="txtref" value="#url.txtref#">
			<input type="hidden" name="txtdoc" value="#url.txtdoc#">
			
		</form>
	
		<cfset LvarAction = "ListaDocumentosEnProceso.cfm" >

		<script language="javascript" type="text/javascript">
			function funcRegresar(){
				document.form1.action="<cfoutput>#LvarAction#</cfoutput>";
				document.form1.submit();
			}
		</script>

		<cfset LvarComponente = "DocumentosNoAplicados-frame.cfm">
		<div id="tmp" style="text-align:center;"><cf_translate key=LB_Espere>Por favor espere</cf_translate>.... <br/><cf_translate key=LB_Proceso>El proceso puede tardar varios minutos</cf_translate>...</div>
		<cfset LvarSrc = "#LvarComponente#?EdocumentoI=#url.EdocumentoI#&EdocumentoF=#url.EdocumentoF#&loteini=#url.loteini#&periodoini=#url.periodoini#&mesini=#url.mesini#&fechaIni=#url.fechaIni#&lotefin=#url.lotefin#&periodofin=#url.periodofin#&mesfin=#url.mesfin#&fechaFin=#url.fechaFin#&Usuario=#url.Usuario#&ordenamiento=#url.ordenamiento#&origen=#url.origen#&txtref=#url.txtref#&txtdoc=#url.txtdoc#&formato=#form.formato#">
		
		<iframe id="framedocproc" frameborder="0" width="100%" height="85%" src="#LvarSrc##checkParametros#"></iframe>
		
		<script>
			setTimeout("document.getElementById('tmp').style.display='none'",5000);//5 seg
		</script>
	</cfoutput>
</cfif>