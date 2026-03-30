<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="MSG_DeseaRealizarLaModificacion" Default="Desea realizar la modificación?" returnvariable="MSG_DeseaRealizarLaModificacion" component="sif.Componentes.Translate" method="Translate"/>	

<!--- FIN VARIABLES DE TRADUCCION --->

<cfparam name="url.RHEid" default="0">
<cfparam name="url.RHEfdesde" default="">
<cfparam name="url.RHEfdesde" default="">

<cfif isdefined("url.RHEid") and len(trim(url.RHEid)) and not isdefined("form.RHEid")>
	<cfset form.RHEid = url.RHEid>
</cfif>
<cfif isdefined("url.RHEfdesde") and len(trim(url.RHEfdesde)) and not isdefined("form.RHEfdesde")>
	<cfset form.RHEfdesde = url.RHEfdesde>
</cfif>
<cfif isdefined("url.RHEfhasta") and len(trim(url.RHEfhasta)) and not isdefined("form.RHEfhasta")>
	<cfset form.RHEfhasta = url.RHEfhasta>
</cfif>
<cfif isdefined('url.modo') and LEN(TRIM(url.modo)) and not isdefined('form.modo')>
	<cfset form.modo = url.modo>
</cfif>
<cfparam name="form.modo" default="CAMBIO">
<cfquery name="rsVerificaCalculo" datasource="#session.DSN#">
	select coalesce(count(1),0) as CalculoEscenario
		from RHFormulacion
		where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and exists(select 1 from RHSituacionActual
						where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
							and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
</cfquery>						 
<!----Fechas del escenario---->
<cfif isdefined("form.RHEid") and len(trim(form.RHEid))>
	<cfquery name="rsEscenario" datasource="#session.DSN#">
		select RHEfdesde, RHEfhasta 
		from RHEscenarios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
	</cfquery>
</cfif>
<cfoutput>
<cf_templatecss>

<form name="formOtrasPartidas" method="post" action="MEOtrasPartidas-sql.cfm">
	<input type="hidden" name="RHEid" 	value="<cfif isdefined("form.RHEid") and len(trim(form.RHEid))>#form.RHEid#</cfif>">
	<input type="hidden" name="RHEfdesde" 	value="<cfif isdefined("form.RHEfdesde") and len(trim(form.RHEfdesde))>#form.RHEfdesde#<cfelseif isdefined("rsEscenario") and rsEscenario.recordCount NEQ 0>#rsEscenario.RHEfdesde#</cfif>">
	<input type="hidden" name="RHEfhasta" 	value="<cfif isdefined("form.RHEfhasta") and len(trim(form.RHEfhasta))>#form.RHEfhasta#<cfelseif isdefined("rsEscenario") and rsEscenario.recordCount NEQ 0>#rsEscenario.RHEfhasta#</cfif>">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center" >  
	  <tr class="tituloListas" >
		<td width="40%" ><strong style="color:##003366; font-family:'Times New Roman', Times, serif; font-size:13pt; font-variant:small-caps; font-weight:bolder;">Modificaci&oacute;n Otras Partidas</strong></td>
		<td colspan="2" align="right">
						<input type="submit" name="Modificar" value="Modificar" onclick="javascript: return(confirm('<cfoutput>#MSG_DeseaRealizarLaModificacion#</cfoutput>'));" />&nbsp;
					</td>
	  </tr>
	  <tr><td class="tituloListas" colspan="4">&nbsp;</td></tr>
	  <tr>
		<td valign="top" colspan="4">
			<fieldset>
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td>
						<cfquery name="rsOtrasPartidas" datasource="#session.DSN#">
							select RHOPFid,CPdescripcion,CPformato,coalesce(RHOPFmonto,0) as Presupuestado,coalesce(RHOPFgastado,0.00) as Gastado,
									coalesce(RHOPFdisponible,0.00) as Disponible,coalesce(RHOPFreserva,0.00) as Reserva,coalesce(RHOPFrefuerzo,0.00) as Refuerzo,
									coalesce(RHOPFmodificacion,0.00) as Modificacion
							from RHOPFormulacion a
							inner join RHOtrasPartidas b
								on b.RHOPid = a.RHOPid
							inner join RHPOtrasPartidas c
								on c.Ecodigo = b.Ecodigo
								and c.RHPOPid = b.RHPOPid
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							  and a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
						</cfquery>
						<table cellpadding="0" cellpadding="0" align="center">
							<tr>
								<td width="25%"><cf_translate key="LB_Componentes">Componente</cf_translate></td>
								<td><cf_translate key="LB_MontoPresupuestado">Presupuestado</cf_translate></td>
								<td><cf_translate key="LB_MontoGastado">Gastado</cf_translate></td>
								<td><cf_translate key="LB_MontoReseva">Reservado</cf_translate></td>
								<td><cf_translate key="LB_MontoModificado">Modificaci&oacute;n</cf_translate></td>
								<td><cf_translate key="LB_Refuerzo">Refuerzo</cf_translate></td>
								<td><cf_translate key="LB_MontoDisponible">Disponible</cf_translate></td>
							</tr>
							<cfloop query="rsOtrasPartidas">
								<tr>
									<td width="25%">#CPdescripcion#-#CPformato#</td>
									<td align="right"><cf_inputNumber name="Presupuestado#RHOPFid#" id="Presupuestado#RHOPFid#" value="#Presupuestado#" decimales="2" modificable="false" tabindex="2"></td>
									<td align="right"><cf_inputNumber name="Gastado#RHOPFid#" id="Gastado#RHOPFid#" value="#Gastado#" decimales="2" modificable="false" tabindex="2"></td>
									<td align="right"><cf_inputNumber name="Reserva#RHOPFid#" id="Reserva#RHOPFid#" value="#Reserva#" decimales="2" modificable="false" tabindex="2"></td>
									<td align="right"><cf_inputNumber name="Modificacion#RHOPFid#" id="Modificacion#RHOPFid#" value="#Modificacion#" decimales="2" modificable="true" tabindex="2"  onblur="SumaMontos(#RHOPFid#)"></td>
									<td align="right"><cf_inputNumber name="Refuerzo#RHOPFid#" id="Refuerzo#RHOPFid#" value="#Refuerzo#" decimales="2" modificable="true" tabindex="2"onblur="SumaMontos(#RHOPFid#)"></td>
									<td align="right"><cf_inputNumber name="Disponible#RHOPFid#" id="Disponible#RHOPFid#" value="#Disponible#" decimales="2" modificable="false" tabindex="2"></td>
								</tr>
							</cfloop>
						</table>
					</td>
				</tr>						
			</table>	
			</fieldset>	
		</td>
	  </tr>
	  <tr><td>&nbsp;</td></tr>
	</table>
</form>
</cfoutput>

<script type="text/javascript" language="javascript1.2">
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	function SumaMontos(id){
		var Presupuestado = document.getElementById('Presupuestado'+id);
		var Gastado = document.getElementById('Gastado'+id);
		var Reserva = document.getElementById('Reserva'+id);
		var Modificacion = document.getElementById('Modificacion'+id);
		var Refuerzo = document.getElementById('Refuerzo'+id);
		var Disponible = document.getElementById('Disponible'+id);
		var monto;
		monto = (Number(qf(Presupuestado.value)) + Number(qf(Modificacion.value)) + Number(qf(Refuerzo.value))) - (Number(qf(Gastado.value))+Number(qf(Reserva.value))); 
		Disponible.value = fm(monto,2);
	}


</script>