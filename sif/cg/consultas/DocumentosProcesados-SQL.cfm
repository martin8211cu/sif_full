<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Regresar" Default="Regresar"
returnvariable="BTN_Regresar" xmlfile = "/sif/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Generar" Default="Generar"
returnvariable="BTN_Generar" xmlfile = "/sif/generales.xml"/>

<cfif not isdefined('form.formato') and isdefined('url.formato')>
	<cfset form.formato = url.formato>
<cfelse>
	<cfset url.formato = form.formato>
</cfif>

<cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato  EQ 'tab' or url.formato EQ 'HTML' >
	<cfinclude template="DocumentosProcesados-frameSQL.cfm">
<cfelseif isdefined("url.Formato") and len(trim(url.Formato))>

<cfset checkParametros="">
	<cfoutput>
		<form name="form1" method="post">
		 <table border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td><strong><cf_translate key=LB_Formato>Visualizar en formato</cf_translate>:</strong></td>
				<td>
					<select name="formato">
						<option value="flashpaper" <cfif ucase(form.formato) EQ "FLASHPAPER">selected</cfif> >FLASHPAPER</option>
						<option value="pdf" <cfif ucase(form.formato) EQ "PDF">selected</cfif> >PDF</option>
						<option value="HTML" <cfif ucase(form.formato) EQ "HTML">selected</cfif> >HTML</option>
					</select>
				</td>
				<td><input name="visualiza" type="submit" value="#BTN_Generar#"></td>
				<td><input name="Regresar" type="button" value="#BTN_Regresar#" onclick="funcRegresar()"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			</table>
				<input type="hidden" name="loteini" value="#url.loteini#">
				<input type="hidden" name="EdocumentoI" value="#url.EdocumentoI#">
				<input type="hidden" name="periodoini" value="#url.periodoini#">
				<input type="hidden" name="mesini" value="#url.mesini#">
				<input type="hidden" name="fechaIni" value="#url.fechaIni#">
				<input type="hidden" name="fechaFin" value="#url.fechaFin#">
				<input type="hidden" name="lotefin" value="#url.lotefin#">
				<input type="hidden" name="EdocumentoF" value="#url.EdocumentoF#">
				<input type="hidden" name="periodofin" value="#url.periodofin#">
				<input type="hidden" name="mesfin" value="#url.mesfin#">
				<input type="hidden" name="Usuario" value="#url.Usuario#">
				<cfif  IsDefined("url.chkCorteDocumento")>
					<input type="hidden" name="chkCorteDocumento" value="#url.chkCorteDocumento#">
					<cfset checkParametros=checkParametros&"&chkCorteDocumento=#url.chkCorteDocumento#">
				</cfif>
				<input type="hidden" name="firmaAutorizada" value="#url.firmaAutorizada#">
				<input type="hidden" name="ordenamiento" value="#url.ordenamiento#">
				<cfif  IsDefined("url.actulizarp")>
					<input type="hidden" name="actulizarp" value="#url.actulizarp#">
					<cfset checkParametros=checkParametros&"&actulizarp=#url.actulizarp#">
				</cfif>
				<input type="hidden" name="txtref" value="#url.txtref#">
				<input type="hidden" name="txtdoc" value="#url.txtdoc#">
				<cfif  IsDefined("url.intercompany")>
					<input type="hidden" name="intercompany" value="#url.intercompany#">
					<cfset checkParametros=checkParametros&"&intercompany=#url.intercompany#">
				</cfif>
				<cfif  IsDefined("url.excluirAnulados")>
					<input type="hidden" name="excluirAnulados" value="#url.excluirAnulados#">
					<cfset checkParametros=checkParametros&"&excluirAnulados=#url.excluirAnulados#">
				</cfif>
				<input type="hidden" name="hayAutoP" value="#url.hayAutoP#">

		</form>

		<cfif not isdefined('form.Formato')>
			<cfset form.formato = 'HTML'>
		</cfif>
		<cfset LvarAction = "DocumentosProcesados.cfm" >

		<script language="javascript" type="text/javascript">
			function funcRegresar(){
				document.form1.action="<cfoutput>#LvarAction#</cfoutput>";
				document.form1.submit();
			}
		</script>

		<cfset LvarComponente = "DocumentosProcesados-frameSQL.cfm">
		<div id="tmp" style="text-align:center;"><cf_translate key=LB_Espere>Por favor espere</cf_translate>.... <br/><cf_translate key=LB_Proceso>El proceso puede tardar varios minutos</cf_translate>...</div>
		<cfset LvarSrc = "#LvarComponente#?formato=#form.formato#&loteini=#url.loteini#&EdocumentoI=#url.EdocumentoI#&periodoini=#url.periodoini#&mesini=#url.mesini#&fechaIni=#url.fechaIni#&fechaFin=#url.fechaFin#&lotefin=#url.lotefin#&EdocumentoF=#url.EdocumentoF#&periodofin=#url.periodofin#&mesfin=#url.mesfin#&Usuario=#url.Usuario#&ordenamiento=#url.ordenamiento#&firmaAutorizada=#url.firmaAutorizada#&txtref=#url.txtref#&txtdoc=#url.txtdoc#&hayAutoP=#url.hayAutoP#">
		<iframe id="framedocproc" frameborder="0" width="100%"
		height="85%" src="#LvarSrc##checkParametros#"></iframe>
		<script>
			setTimeout("document.getElementById('tmp').style.display='none'",5000);//7 seg
		</script>
	</cfoutput>
</cfif>