<cfif not isdefined('form.formatos') and isdefined('url.formatos')>
	<cfset form.formatos = url.formatos>
<cfelse>
	<cfset url.formatos = form.formatos>
</cfif>

<cfif isdefined("url.Formatos") and len(trim(url.Formatos))>
<cfset checkParametros="">
	<cfoutput>
		<form name="form1" method="post">
		 <table border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td><strong>Visualizar en formato:</strong></td>
				<td>
					<select name="formatos">
						<option value="FlashPaper" <cfif form.formatos EQ "FlashPaper">selected</cfif> >FLASHPAPER</option>
						<option value="pdf" <cfif form.formatos EQ "pdf">selected</cfif> >PDF</option>
						<option value="Excel" <cfif form.formatos EQ "Excel">selected</cfif> >Excel</option>
						<option value="tab" <cfif form.formatos EQ "tab">selected</cfif> >Excel tabular</option>
					</select>
				</td>
				<td><input name="visualiza" type="submit" value="Generar"></td>
				<td><input name="Regresar" type="button" value="Regresar" onclick="funcRegresar()"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			</table>
			<input type="hidden" name="EcodigoOri" value="#url.EcodigoOri#">
			<input type="hidden" name="EcodigoDest" value="#url.EcodigoDest#">
			<input type="hidden" name="FechaDOri" value="#url.FechaDOri#">
			<input type="hidden" name="FechaHOri" value="#url.FechaHOri#">
			<input type="hidden" name="FechaDDest" value="#url.FechaDDest#">
			<input type="hidden" name="FechaHDest" value="#url.FechaHDest#">
			<input type="hidden" name="TipoAsiento" value="#url.TipoAsiento#">
			<input type="hidden" name="botonSel" value="#url.botonSel#">
			<input type="hidden" name="btnGenerar" value="#url.btnGenerar#">
		</form>
		<cfset LvarAction = "ImpresionDocIntercompany.cfm" >

		<script language="javascript" type="text/javascript">
			function funcRegresar(){
				document.form1.action="<cfoutput>#LvarAction#</cfoutput>";
				document.form1.submit();
			}
		</script>

		<cfset LvarComponente = "ImpresionDocIntercompany_Rep-frame.cfm">
		<div id="tmp" style="text-align:center;">Por favor espere.... <br/>El proceso puede tardar varios minutos...</div>
		<cfset LvarSrc = "#LvarComponente#?formatos=#form.formatos#&EcodigoOri=#url.EcodigoOri#&EcodigoDest=#url.EcodigoDest#&FechaDOri=#url.FechaDOri#&FechaHOri=#url.FechaHOri#&FechaDDest=#url.FechaDDest#&FechaHDest=#url.FechaHDest#&TipoAsiento=#url.TipoAsiento#&botonSel=#url.botonSel#&btnGenerar=#url.btnGenerar#">
		<iframe id="framedocproc" frameborder="0" width="100%" height="85%" src="#LvarSrc#"></iframe>
		<script>
			setTimeout("document.getElementById('tmp').style.display='none'",3000);//7 seg
		</script>
	</cfoutput>
</cfif>