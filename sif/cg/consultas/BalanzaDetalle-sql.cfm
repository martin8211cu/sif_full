<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Formato" default="Visualizar en formato" 
returnvariable="LB_Formato" xmlfile="BalanzaDetalle-sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PorFavor" default="Por favor espere" 
returnvariable="LB_PorFavor" xmlfile="BalanzaDetalle-sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Proceso" default="El proceso puede tardar varios minutos" 
returnvariable="LB_Proceso" xmlfile="BalanzaDetalle-sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Generar" default="Generar" 
returnvariable="BTN_Generar" xmlfile="BalanzaDetalle-sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Regresar" default="Regresar" 
returnvariable="BTN_Regresar" xmlfile="BalanzaDetalle-sql.xml"/>

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
				<td><strong>#LB_Formato#:</strong></td>
				<td>
					<select name="formato">
						<option value="FlashPaper" <cfif ucase(form.formato) EQ "FlashPaper">selected</cfif> >FLASHPAPER</option>
						<option value="pdf" <cfif ucase(form.formato) EQ "pdf">selected</cfif> >PDF</option>
						<option value="bightml" <cfif ucase(form.formato) EQ "bightml">selected</cfif> >HTML</option>
						<option value="ExcelColumnar" <cfif ucase(form.formato) EQ "ExcelColumnar">selected</cfif> >Excel Columnar</option>
					</select>
				</td>
				<td><input name="visualiza" type="submit" value="#BTN_Generar#"></td>
				<td><input name="Regresar" type="button" value="#BTN_Regresar#" onclick="funcRegresar()"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		 </table>
		 
		 <input type="hidden" name="periodo1" value="#url.periodo1#">
		 <input type="hidden" name="mes1" value="#url.mes1#">
		 <input type="hidden" name="Cmayor_Ccuenta1" value="#url.Cmayor_Ccuenta1#">
		 <input type="hidden" name="Cformato1" value="#url.Cformato1#">
		 <input type="hidden" name="Cdescripcion1" value="#url.Cdescripcion1#">
		 <input type="hidden" name="Ccuenta1" value="#url.Ccuenta1#">
		 <input type="hidden" name="CFcuenta_Ccuenta1" value="#url.CFcuenta_Ccuenta1#">
		 <input type="hidden" name="Cmayor_Ccuenta1_id" value="#url.Cmayor_Ccuenta1_id#">
		 <input type="hidden" name="Cmayor_Ccuenta1_mask" value="#url.Cmayor_Ccuenta1_mask#">
		 <input type="hidden" name="periodo2" value="#url.periodo2#">
		 <input type="hidden" name="mes2" value="#url.mes2#">
		 <input type="hidden" name="Cmayor_Ccuenta2" value="#url.Cmayor_Ccuenta2#">
		 <input type="hidden" name="Cformato2" value="#url.Cformato2#">
		 <input type="hidden" name="Cdescripcion2" value="#url.Cdescripcion2#">
		 <input type="hidden" name="Ccuenta2" value="#url.Ccuenta2#">
		 <input type="hidden" name="CFcuenta_Ccuenta2" value="#url.CFcuenta_Ccuenta2#">
		 <input type="hidden" name="Cmayor_Ccuenta2_id" value="#url.Cmayor_Ccuenta2_id#">
		 <input type="hidden" name="Cmayor_Ccuenta2_mask" value="#url.Cmayor_Ccuenta2_mask#">
		 <input type="hidden" name="fechaini" value="#url.fechaini#">
		 <input type="hidden" name="fechafin" value="#url.fechafin#">
		 <input type="hidden" name="mcodigoopt" value="#url.mcodigoopt#">
		 <input type="hidden" name="Mcodigo" value="#url.Mcodigo#">
		<cfif IsDefined("url.chkMontoOrigen")>
			<input type="hidden" name="chkMontoOrigen" value="#url.chkMontoOrigen#">
			<cfset checkParametros=checkParametros&"#url.chkMontoOrigen#">
		</cfif>
		 <input type="hidden" name="Ocodigo" value="#url.Ocodigo#">
		 <input type="hidden" name="ordenamiento" value="#url.ordenamiento#">
		<cfif IsDefined("url.chkTotalFecha")>
			<input type="hidden" name="chkTotalFecha" value="#url.chkTotalFecha#">
			<cfset checkParametros=checkParametros&"#url.chkTotalFecha#">
		</cfif>
		<cfif IsDefined("url.CHKMesCierre")>
			<input type="hidden" name="CHKMesCierre" value="#url.CHKMesCierre#">
			<cfset checkParametros=checkParametros&"#url.CHKMesCierre#">
		</cfif>
		 <input type="hidden" name="btnGenerar2" value="#url.btnGenerar2#">

		 
		<cfset LvarAction = "BalanzaDetalle.cfm" >

		<script language="javascript" type="text/javascript">
			function funcRegresar(){
				document.form1.action="<cfoutput>#LvarAction#</cfoutput>";
				document.form1.submit();
			}
		</script>

		<cfset LvarComponente = "BalanzaDetalle-sql-frame.cfm">
		<div id="tmp" style="text-align:center;"><cfoutput>#LB_PorFavor#.... <br/>#LB_Proceso#...</cfoutput></div>
		<cfset LvarSrc = "#LvarComponente#?formato=#form.formato#&periodo1=#url.periodo1#&mes1=#url.mes1#&Cmayor_Ccuenta1=#url.Cmayor_Ccuenta1#&Cformato1=#url.Cformato1#&Cdescripcion1=#url.Cdescripcion1#&Ccuenta1=#url.Ccuenta1#&CFcuenta_Ccuenta1=#url.CFcuenta_Ccuenta1#&Cmayor_Ccuenta1_id=#url.Cmayor_Ccuenta1_id#&Cmayor_Ccuenta1_mask=#url.Cmayor_Ccuenta1_mask#&periodo2=#url.periodo2#&mes2=#url.mes2#&Cmayor_Ccuenta2=#url.Cmayor_Ccuenta2#&Cformato2=#url.Cformato2#&Cdescripcion2=#url.Cdescripcion2#&=Ccuenta2#url.Ccuenta2#&CFcuenta_Ccuenta2=#url.CFcuenta_Ccuenta2#&Cmayor_Ccuenta2_id=#url.Cmayor_Ccuenta2_id#&Cmayor_Ccuenta2_mask=#url.Cmayor_Ccuenta2_mask#&fechaini=#url.fechaini#&fechafin=#url.fechafin#&mcodigoopt=#url.mcodigoopt#&Mcodigo=#url.Mcodigo#&Ocodigo=#url.Ocodigo#&btnGenerar2=#url.btnGenerar2#&ordenamiento=#url.ordenamiento#">
		
		<iframe id="frBalCompR2" frameborder="0" width="100%" height="85%" src="#LvarSrc##checkParametros#"></iframe>
		<script>
			setTimeout("document.getElementById('tmp').style.display='none'",7000);//7 seg
		</script>
	</cfoutput>
</cfif>