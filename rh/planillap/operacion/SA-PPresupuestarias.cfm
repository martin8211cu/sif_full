<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfif isdefined("url.RHEid") and len(trim(url.RHEid)) and not isdefined("form.RHEid")>
	<cfset form.RHEid = url.RHEid>
</cfif>
<cfif isdefined("url.RHETEid") and len(trim(url.RHETEid)) and not isdefined("form.RHETEid")>
	<cfset form.RHETEid = url.RHETEid>
</cfif>

<!---Verificar si ya se calculo el escenario----->
<cfquery name="rsVerificaCalculo" datasource="#session.DSN#">
	select coalesce(count(1),0) as CalculoEscenario
	from RHFormulacion
	where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and exists(select 1 from RHSituacionActual
					where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">) 
</cfquery>
<!----Fechas del escenario--->
<cfif isdefined("form.RHEid") and len(trim(form.RHEid))>
	<cfquery name="rsEscenario" datasource="#session.DSN#">	
		select RHEfdesde, RHEfhasta from RHEscenarios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
	</cfquery>
</cfif>
<cfoutput>
<script type="text/javascript" language="javascript1.2">
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	function funcCMasivos(){
		/*Valores de prs_origen = 	tablas (TAB:tablas salariales)
									sitactual (TAB:Situacion actual)
									psolicitadas(TAB:Plazas Solicitadas)*/
		var params ="?RHEid="+document.formPresupuestaria.RHEid.value+'&prs_origen=sitactual';
		popUpWindow("/cfmx/rh/planillap/operacion/PopUp-ComponentesMasivo.cfm"+params,200,180,650,400);				
	}
	function funcImportar(){
		var vrs_verifica = <cfoutput>#rsVerificaCalculo.CalculoEscenario#</cfoutput>;
		if (vrs_verifica == 0){
			if(confirm('¿Esta seguro que desea importar la situación actual?')){
				document.formPresupuestaria.action = 'SA-PPresupuestarias-sql.cfm';
				return true;
			}
			return false;
		}
		else{
			if(confirm('Ya se ha calculado el escenario.  ¿Esta seguro que desea importar la situación actual y perder los datos?')){
				document.formPresupuestaria.action = 'SA-PPresupuestarias-sql.cfm';
				return true;
			}
			return false			
		}
	}
	function funcBuscar(prn_RHSAid){	
		var params ="?RHSAid="+prn_RHSAid;
		window.parent.document.forms['form2'].nosubmit = true;
		popUpWindow("/cfmx/rh/planillap/operacion/PopUp-OcupacionPlazas.cfm"+params,200,180,600,300);				
	}
	
	function fnEliminarSituacion(RHSAid) {
		window.parent.document.forms['form2'].nosubmit = "false";
		window.document.formPresupuestaria.nosubmit = "false";
		e = document.formEliminar;
		if (confirm('¿Desea Eliminar esta linea de la situación?')){
			param    = "?btnEliminar=true";
			e.action = "SA-PPresupuestarias-sql.cfm"+param;
			e.RHSAid.value = RHSAid;
			e.submit();
			return false;
		}
		else
			return false;
	}
	
	function funcImportarInd(){
		window.parent.document.forms['form2'].nosubmit = true;
		param = "?RHEid=#form.RHEid#";
		popUpWindow("/cfmx/rh/planillap/operacion/PopUp-ImportarIndividual.cfm"+param,100,180,800,400);		
	}
</script>
<cf_templatecss>
<form name="formEliminar" method="post" action="SA-PPresupuestarias-sql.cfm">
	<input type="hidden" name="RHEid" 	value="<cfif isdefined("form.RHEid") and len(trim(form.RHEid))>#form.RHEid#</cfif>">
	<input type="hidden" name="RHSAid" 	value="">
</form>
<form name="formPresupuestaria" method="post" action="">

	<input type="hidden" name="RHEid" 	value="<cfif isdefined("form.RHEid") and len(trim(form.RHEid))>#form.RHEid#</cfif>">
	<input type="hidden" name="RHETEid" 	value="<cfif isdefined("form.RHETEid") and len(trim(form.RHETEid))>#form.RHETEid#</cfif>">
	<input type="hidden" name="RHEfdesde" 	value="<cfif isdefined("rsEscenario") and rsEscenario.recordCount NEQ 0>#rsEscenario.RHEfdesde#</cfif>">
	<input type="hidden" name="RHEfhasta" 	value="<cfif isdefined("rsEscenario") and rsEscenario.recordCount NEQ 0>#rsEscenario.RHEfhasta#</cfif>">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center" >  
	  <tr class="tituloListas" >
		<td>
			<strong style="color:##003366; font-family:'Times New Roman', Times, serif; font-size:13pt; font-variant:small-caps; font-weight:bolder;">Plazas Presupuestarias</strong>		
		</td>		
		<td colspan="2" nowrap="nowrap" align="right">
			<cf_botones names="Importar,ImportarInd" values="Importar General,Importar Individual">
		</td>
	  </tr>
	  <tr><td class="tituloListas" colspan="3">&nbsp;</td></tr>
	  <tr>
		<td valign="top" colspan="3">
			<fieldset>
			<table width="100%" cellpadding="0" cellspacing="0" border="0">							
				<tr><td >
				<cf_dbfunction name="OP_concat" returnvariable="_Cat">
				<cf_dbfunction name="to_char" args="sta.RHSAid" returnvariable="V_RHSAid">
                <cf_dbfunction name="to_char" args="count(1)" returnvariable="V_count">
				<cfset lvarEliminar = '<input name="imageField" type="image" src="../../imagenes/Borrar01_S.gif" width="16" height="16" border="0" onclick="return fnEliminarSituacion(''#_Cat##V_RHSAid##_Cat#'');">'>
				<cfinvoke 
					component="rh.Componentes.pListas" 
					method="pListaRH"
					returnvariable="rsLista"
					columnas="	sta.RHEid,
								sta.RHSAid,
								pp.RHPPcodigo,
								pp.RHPPdescripcion,
								sta.fdesdeplaza,								
								case sta.fhastaplaza 	when '61000101' then 'Indefinido'
														else convert(varchar,sta.fhastaplaza,103)
								end as fhastaplaza,
								ltrim(rtrim(cf.CFcodigo))#LvarCNCT#' - '#LvarCNCT#ltrim(rtrim(cf.CFdescripcion)) as CFuncional,							
								ltrim(rtrim(mp.RHMPPcodigo))#LvarCNCT#' - '#LvarCNCT#ltrim(rtrim(mp.RHMPPdescripcion)) as PuestoPresupuestario,
								'<img border=''0'' title=''Plaza ocupada por ' #LvarCNCT# (select #V_count# from RHPlazasEscenario pe where pe.Ecodigo = sta.Ecodigo and pe.RHEid = sta.RHEid and pe.RHPPid = sta.RHPPid) #LvarCNCT# ' persona(s) '' onClick=''javascript: return funcBuscar('#LvarCNCT#convert(varchar,sta.RHSAid)#LvarCNCT#');'' src=''/cfmx/rh/imagenes/usuario04_T.gif''>' as Buscar
								,'#preservesinglequotes(lvarEliminar)#' as Eliminar"													
					tabla="RHSituacionActual sta
							inner join RHPlazaPresupuestaria pp
								on pp.RHPPid = sta.RHPPid
								and pp.Ecodigo = sta.Ecodigo
							left outer join RHMaestroPuestoP mp
								on mp.RHMPPid = sta.RHMPPid
								and mp.Ecodigo = sta.Ecodigo								
							inner join CFuncional cf
								on cf.CFid = sta.CFid
								and cf.Ecodigo = sta.Ecodigo"
					keys="RHSAid"
					filtro="sta.Ecodigo = #Session.Ecodigo# 
							and sta.RHEid = #form.RHEid#							
							and sta.RHPPid is not null
							order by  pp.RHPPcodigo, pp.RHPPdescripcion, mp.RHMPPcodigo, mp.RHMPPdescripcion"
					mostrar_filtro="true"
					filtrar_automatico="true"
					etiquetas="C&oacute;digo, Plaza, Puesto, Ctro Funcional, Fecha inicial, Fecha final, &nbsp;, &nbsp;"
					desplegar="RHPPcodigo, RHPPdescripcion, PuestoPresupuestario, CFuncional, fdesdeplaza, fhastaplaza, Buscar, Eliminar"
					filtrar_por="RHPPcodigo, 
								RHPPdescripcion, 
								ltrim(rtrim(mp.RHMPPcodigo))#LvarCNCT#' - '#LvarCNCT# ltrim(rtrim(mp.RHMPPdescripcion)), 
								ltrim(rtrim(cf.CFcodigo))#LvarCNCT#' - '#LvarCNCT# ltrim(rtrim(cf.CFdescripcion)), 
								fdesdeplaza, 
								fhastaplaza,
								'',
								''"
					align="left,left,left,left,left,left,left,left"					
					formatos="S,S,S,S,D,S,G,G"
					ira=""
					funcion="window.parent.funcMuestraComponentes"
					fparams="RHSAid"
					maxrows="10"
					showemptylistmsg="true"
					formname="formPresupuestaria"
					incluyeform="false"
					navegacion="RHEid=#form.RHEid#"
				/>	
				</td></tr>						
			</table>	
			</fieldset>	
		</td>
	  </tr>
	  <tr><td>&nbsp;</td></tr>
	</table>
</form>
</cfoutput>

