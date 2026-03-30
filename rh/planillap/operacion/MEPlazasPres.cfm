<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfif isdefined("url.RHEid") and len(trim(url.RHEid)) and not isdefined("form.RHEid")>
	<cfset form.RHEid = url.RHEid>
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
<cfoutput>
<script type="text/javascript" language="javascript1.2">

	function funcBuscar(prn_RHSAid){	
		var params ="?RHSAid="+prn_RHSAid;
		window.parent.document.forms['form2'].nosubmit = true;
		popUpWindow("/cfmx/rh/planillap/operacion/PopUp-OcupacionPlazas.cfm"+params,200,180,600,300);				
	}

</script>
<cf_templatecss>
<!----Fechas del escenario--->
<cfif isdefined("form.RHEid") and len(trim(form.RHEid))>
	<cfquery name="rsEscenario" datasource="#session.DSN#">	
		select RHEfdesde, RHEfhasta from RHEscenarios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
	</cfquery>
</cfif>
<form name="formPresupuestaria" method="post" action="">
	<input type="hidden" name="RHEid" 	value="<cfif isdefined("form.RHEid") and len(trim(form.RHEid))>#form.RHEid#</cfif>">
	<input type="hidden" name="RHEfdesde" 	value="<cfif isdefined("rsEscenario") and rsEscenario.recordCount NEQ 0>#rsEscenario.RHEfdesde#</cfif>">
	<input type="hidden" name="RHEfhasta" 	value="<cfif isdefined("rsEscenario") and rsEscenario.recordCount NEQ 0>#rsEscenario.RHEfhasta#</cfif>">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center" >  
	  <tr class="tituloListas" >
		<td>
			<strong style="color:##003366; font-family:'Times New Roman', Times, serif; font-size:13pt; font-variant:small-caps; font-weight:bolder;">Plazas Presupuestadas</strong>		
		</td>		
	  </tr>
	  <tr><td class="tituloListas" colspan="3">&nbsp;</td></tr>
	  <tr>
		<td valign="top" colspan="3">
			<fieldset>
			<table width="100%" cellpadding="0" cellspacing="0" border="0">							
				<tr><td >
				<cfinvoke 
					component="rh.Componentes.pListas" 
					method="pListaRH"
					returnvariable="rsLista"
					columnas="	sta.RHFid,sta.RHEid,
								sta.RHSAid,
								pp.RHPPcodigo,
								pp.RHPPdescripcion,
								sta.fdesdeplaza,								
								case sta.fhastaplaza 	when '61000101' then 'Indefinido'
														else convert(varchar,sta.fhastaplaza,103)
								end as fhastaplaza,
								ltrim(rtrim(cf.CFcodigo))#LvarCNCT#' - '#LvarCNCT#ltrim(rtrim(cf.CFdescripcion)) as CFuncional,							
								ltrim(rtrim(mp.RHMPPcodigo))#LvarCNCT#' - '#LvarCNCT#ltrim(rtrim(mp.RHMPPdescripcion)) as PuestoPresupuestario,
								'<img border=''0'' title=''Plaza ocupada por'' onClick=''javascript: return funcBuscar('#LvarCNCT#convert(varchar,sta.RHSAid)#LvarCNCT#');'' src=''/cfmx/rh/imagenes/usuario04_T.gif''>' as Buscar"													
					tabla="RHFormulacion sta
							inner join RHPlazaPresupuestaria pp
								on pp.RHPPid = sta.RHPPid
								and pp.Ecodigo = sta.Ecodigo
							left outer join RHMaestroPuestoP mp
								on mp.RHMPPid = sta.RHMPPid
								and mp.Ecodigo = sta.Ecodigo								
							inner join CFuncional cf
								on cf.CFid = sta.CFidnuevo
								and cf.Ecodigo = sta.Ecodigo"
					keys="RHFid"
					filtro="sta.Ecodigo = #Session.Ecodigo# 
							and sta.RHEid = #form.RHEid#							
							and sta.RHPPid is not null
							order by  pp.RHPPcodigo, pp.RHPPdescripcion, mp.RHMPPcodigo, mp.RHMPPdescripcion"
					mostrar_filtro="true"
					filtrar_automatico="true"
					etiquetas="C&oacute;digo, Plaza, Puesto, Ctro Funcional, Fecha inicial, Fecha final, &nbsp;"
					desplegar="RHPPcodigo, RHPPdescripcion, PuestoPresupuestario, CFuncional, fdesdeplaza, fhastaplaza, Buscar"
					filtrar_por="RHPPcodigo, 
								RHPPdescripcion, 
								ltrim(rtrim(mp.RHMPPcodigo))#LvarCNCT#' - '#LvarCNCT# ltrim(rtrim(mp.RHMPPdescripcion)), 
								ltrim(rtrim(cf.CFcodigo))#LvarCNCT#' - '#LvarCNCT# ltrim(rtrim(cf.CFdescripcion)), 
								fdesdeplaza, 
								fhastaplaza,
								''"
					align="left,left,left,left,left,left,left"					
					formatos="S,S,S,S,D,S,G"
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