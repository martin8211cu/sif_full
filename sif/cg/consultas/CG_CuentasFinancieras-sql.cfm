<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Generar" Default="Generar" returnvariable="BTN_Generar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Regresar" Default="Regresar" returnvariable="BTN_Regresar"/>
<cfif not isdefined('form.formato') and isdefined('url.formato')>
	<cfset form.formato = url.formato>
<cfelse>
	<cfset url.formato = form.formato>
</cfif>

<cfif isdefined("url.Formato") and len(trim(url.Formato))>

<cfset checkParametros="">
	<cfoutput>
		<form name="form1" method="post">
		 <table border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td><strong><cf_translate key = LB_Formato>Visualizar en formato</cf_translate>:</strong></td>
				<td>
					<select name="formato">
						<option value="FlashPaper" <cfif form.formato EQ "FlashPaper">selected</cfif> >FLASHPAPER</option>
						<option value="pdf" <cfif form.formato EQ "pdf">selected</cfif> >PDF</option>
						<option value="excel" <cfif form.formato EQ "excel">selected</cfif> >Excel</option>
					</select>
				</td>
				<td><input name="visualiza" type="submit" value="#BTN_Generar#"></td>
				<td><input name="Regresar" type="button" value="#BTN_Regresar#" onclick="funcRegresar()"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			</table>
			<input type="hidden" name="fechaini" value="#url.fechaini#">
			<input type="hidden" name="fechafin" value="#url.fechafin#">
			<input type="hidden" name="Submit" value="#url.Submit#">
		</form>
	
		
		<cfset LvarAction = "CG_CuentasFinancieras.cfm" >

		<script language="javascript" type="text/javascript">
			function funcRegresar(){
				document.form1.action="<cfoutput>#LvarAction#</cfoutput>";
				document.form1.submit();
			}
		</script>

		<cfset LvarComponente = "CG_CuentasFinancieras-sql-frame.cfm">
		<div id="tmp" style="text-align:center;"><cf_translate key=LB_Espere>Por favor espere</cf_translate>.... <br/><cf_translate key = LB_Proceso>El proceso puede tardar varios minutos</cf_translate>...</div>
		<cfset LvarSrc = "#LvarComponente#?formato=#form.formato#&fechaini=#url.fechaini#&fechafin=#url.fechafin#&Submit=#url.Submit#">
		<iframe id="framedocproc" frameborder="0" width="100%" height="85%" src="#LvarSrc#"></iframe>
		<script>
			setTimeout("document.getElementById('tmp').style.display='none'",5000);//7 seg
		</script>
	</cfoutput>
</cfif>