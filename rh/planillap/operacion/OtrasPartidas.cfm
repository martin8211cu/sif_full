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

<form name="formOtrasPartidas" method="post" action="OtrasPartidas-sql.cfm">
	<input type="hidden" name="RHEid" 	value="<cfif isdefined("form.RHEid") and len(trim(form.RHEid))>#form.RHEid#</cfif>">
	<input type="hidden" name="RHEfdesde" 	value="<cfif isdefined("form.RHEfdesde") and len(trim(form.RHEfdesde))>#form.RHEfdesde#<cfelseif isdefined("rsEscenario") and rsEscenario.recordCount NEQ 0>#rsEscenario.RHEfdesde#</cfif>">
	<input type="hidden" name="RHEfhasta" 	value="<cfif isdefined("form.RHEfhasta") and len(trim(form.RHEfhasta))>#form.RHEfhasta#<cfelseif isdefined("rsEscenario") and rsEscenario.recordCount NEQ 0>#rsEscenario.RHEfhasta#</cfif>">
	<input type="hidden" name="RHOPidEliminar" 	value="">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center" >  
	  <tr>
		<td width="40%" class="tituloListas" >
			<strong style="color:##003366; font-family:'Times New Roman', Times, serif; font-size:13pt; font-variant:small-caps; font-weight:bolder;">Otras Partidas</strong></td>
		<td colspan="3" class="tituloListas"><table width="65%" cellpadding="0" cellspacing="0" align="right"><tr>
			<td align="center">
				<cfif modo NEQ 'ALTA'>
				<cf_botones names="Nuevo,Eliminar" values="Nuevo,Eliminar">
				<cfelse>
				<cf_botones names="Nuevo" values="Nuevo">
				</cfif>
			</td>
		</tr></table></td>
	  </tr>
	  <tr><td class="tituloListas" colspan="4">&nbsp;</td></tr>
	  <cfif form.modo NEQ 'ALTA'>
	  <tr>
		<td valign="top" colspan="4">
			<fieldset>
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr><td>
				<cf_dbfunction name="concat" args="e.RHTTcodigo,' - ',e.RHTTdescripcion" returnvariable="Lvar_TablaSal">
				<cf_dbfunction name="to_char" args="a.RHOPid" returnvariable="Lvar_RHOPid">
				<cf_dbfunction name="concat" args="'<img border=''0'' onClick=''javascript: funcEliminar('	|#preservesinglequotes(Lvar_RHOPid)#|');'' src=''/cfmx/rh/imagenes/Borrar01_S.gif''>'" returnvariable="Lvar_img" delimiters="|">
				
				<cfinvoke 
					component="rh.Componentes.pListas" 
					method="pListaRH"
					returnvariable="rsLista"
					columnas="RHOPid,CPdescripcion,CPformato"					
					tabla="RHOtrasPartidas a
							inner join RHPOtrasPartidas b
								on b.Ecodigo = a.Ecodigo
								and b.RHPOPid = a.RHPOPid"
					keys="RHOPid"
					filtro="a.Ecodigo=#Session.Ecodigo# 
							and a.RHEid = #form.RHEid#"
					mostrar_filtro="true"
					filtrar_automatico="true"
					etiquetas="Partidas,Cuenta"
					desplegar="CPdescripcion,CPformato"
					filtrar_por="CPdescripcion,CPformato"
					align="left,left"					
					formatos="S,S"
					ira=""					
					maxrows="10"
					checkboxes="s"
					showemptylistmsg="true"
					formname="formOtrasPartidas"
					showLink="true"
					funcion="window.parent.funcMuestraDetalles"
					fparams="RHOPid"
					incluyeform="false"
					navegacion="RHEid=#form.RHEid#"				
				/>	
				</td></tr>						
			</table>	
			</fieldset>	
		</td>
	  </tr>
	  <cfelse>
	  	<cfinclude template="OtrasPartidas-form.cfm">
	  </cfif>
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


	function funcEliminar(){
		if(confirm('¿Desea Eliminar el Registro?') ){
			document.formOtrasPartidas.action = 'OtrasPartidas-sql.cfm';
			document.formOtrasPartidas.submit();	
		}					
	}
	function funcEliminarMasivo(){
		var params ="?RHEid="+document.formOtrasPartidas.RHEid.value+'&prs_origen=psolicitadas';
		popUpWindow("/cfmx/rh/planillap/operacion/PopUp-EliminarSolicitudMasivo.cfm"+params,285,180,700,450);						
	}
	function funcNuevaPartida(){
		/*Valores de prs_origen = 	tablas (TAB:tablas salariales)
									sitactual (TAB:Situacion actual)
									psolicitadas(TAB:Plazas Solicitadas)*/
			document.formOtrasPartidas.action = 'OtrasPartidas-sql.cfm';
			document.formOtrasPartidas.submit();		
	}

</script>