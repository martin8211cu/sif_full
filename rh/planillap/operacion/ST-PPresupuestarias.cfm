<cfsetting requesttimeout="8400">
<cfif isdefined("url.RHEid") and len(trim(url.RHEid)) and not isdefined("form.RHEid")>
	<cfset form.RHEid = url.RHEid>
</cfif>
<cfif isdefined("url.RHEfdesde") and len(trim(url.RHEfdesde)) and not isdefined("form.RHEfdesde")>
	<cfset form.RHEfdesde = url.RHEfdesde>
</cfif>
<cfif isdefined("url.RHEfhasta") and len(trim(url.RHEfhasta)) and not isdefined("form.RHEfhasta")>
	<cfset form.RHEfhasta = url.RHEfhasta>
</cfif>

<!---Verificar si ya se calculo el escenario----->
<cfquery name="rsVerificaCalculo" datasource="#session.DSN#">
	select coalesce(count(1),0) as CalculoEscenario
	from RHFormulacion
	where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and exists(select 1 from RHPlazasEscenario 
					where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">) 
</cfquery>
<cfoutput>
<script type="text/javascript" language="javascript1.2">
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	function funcComponentesMasivos(){
		/*Valores de prs_origen = 	tablas (TAB:tablas salariales)
									sitactual (TAB:Situacion actual)
									psolicitadas(TAB:Plazas Solicitadas)*/
		var params ="?RHEid="+document.formPresupuestaria.RHEid.value+'&prs_origen=sitactual';
		popUpWindow("/cfmx/rh/planillap/operacion/PopUp-ComponentesMasivo.cfm"+params,200,180,650,400);				
	}
	function funcRegresa(prn_RHSAid){	
		window.parent.document.forms['form2'].nosubmit = true;
		window.parent.document.location.href = "TrabajarEscenario.cfm?tab=2"+"&RHEid="+document.formPresupuestaria.RHEid.value+"&RHSAid="+prn_RHSAid;
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
	<input type="hidden" name="RHEfdesde" 	value="<cfif isdefined("form.RHEfdesde") and len(trim(form.RHEfdesde))>#form.RHEfdesde#<cfelseif isdefined("rsEscenario") and rsEscenario.recordCount NEQ 0>#rsEscenario.RHEfdesde#</cfif>">
	<input type="hidden" name="RHEfhasta" 	value="<cfif isdefined("form.RHEfhasta") and len(trim(form.RHEfhasta))>#form.RHEfhasta#<cfelseif isdefined("rsEscenario") and rsEscenario.recordCount NEQ 0>#rsEscenario.RHEfhasta#</cfif>">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center" >  
	  <tr>
		<td width="704" class="tituloListas" >
			<strong style="color:##003366; font-family:'Times New Roman', Times, serif; font-size:13pt; font-variant:small-caps; font-weight:bolder;">Plazas Presupuestarias</strong>		
		</td>					
	  </tr>
	  <tr><td class="tituloListas" colspan="3">&nbsp;</td></tr>
	  <tr>
		<td valign="top" colspan="3">
			<fieldset>
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr><td>	
				<cf_dbfunction name="concat" args="ltrim(rtrim(z.RHPPcodigo)),' - ',ltrim(rtrim(z.RHPPdescripcion))" returnvariable="Lvar_PlazaP">
				<cf_dbfunction name="concat" args="ltrim(rtrim(t.RHPcodigo)),' - ',ltrim(rtrim(t.RHPdescripcion))" returnvariable="Lvar_PlazaRH">
				<cf_dbfunction name="concat" args="ltrim(rtrim(f.DEnombre)),' ',ltrim(rtrim(f.DEapellido1)),' ',ltrim(rtrim(f.DEapellido2))" returnvariable="Lvar_Empleado">
				<cf_dbfunction name="concat" args="ltrim(rtrim(b.RHPcodigo)),' - ',ltrim(rtrim(b.RHPdescpuesto))" returnvariable="Lvar_PuestoRH">
				<cfinvoke 
					component="rh.Componentes.pListas" 
					method="pListaRH"
					returnvariable="rsLista"
					columnas="	distinct a.RHPPid,
								a.RHPEid,
								a.RHPEfinicioplaza,								
								case a.RHPEffinplaza 	when '61000101' then 'Indefinidos'
														else convert(varchar,a.RHPEffinplaza,103)
								end as RHPEffinplaza,
								#Lvar_PlazaP# as PlazaPresupuestaria, 				
								#Lvar_PlazaRH# as PlazaRH,
								#Lvar_Empleado# as Empleado,
								#Lvar_PuestoRH# as PuestoRH,
								f.DEid"
					tabla="RHPlazasEscenario a						
							inner join RHPlazaPresupuestaria z
								on a.RHPPid = z.RHPPid
							
								inner join RHPlazas t
									on z.RHPPid = t.RHPPid
									and t.RHPactiva = 1

									inner join RHPuestos b
										on t.RHPpuesto = b.RHPcodigo
										and t.Ecodigo = b.Ecodigo
						
							inner join RHLineaTiempoPlaza g
								on a.RHPPid = g.RHPPid
								and g.RHMPestadoplaza = 'A'
								
							inner join DatosEmpleado f
								on a.DEid = f.DEid"
					keys="RHPEid,DEid"
					filtro="a.Ecodigo=#Session.Ecodigo# 
							and a.RHEid = #form.RHEid#
							and a.RHPPid is not null
                            order by #Lvar_PlazaRH#,a.RHPEfinicioplaza,RHPEffinplaza "
					mostrar_filtro="true"
					filtrar_automatico="true"
					etiquetas="Plaza, Puesto, Fecha inicial, Fecha final, Plaza ocupada por"
					desplegar="PlazaRH, PuestoRH, RHPEfinicioplaza, RHPEffinplaza, Empleado"
					filtrar_por="#Lvar_PlazaP#,
								#Lvar_PlazaRH#,
								a.RHPEfinicioplaza,
								a.RHPEffinplaza,
								#Lvar_Empleado#"
					align="left,left,left,left,left"					
					formatos="S,S,D,S,S"
					ira=""
					funcion="window.parent.funcMuestraComponentes"
					fparams="RHPEid, DEid"
					maxrows="10"
					showemptylistmsg="true"
					formname="formPresupuestaria"
					incluyeform="false"
					navegacion="RHEid=#form.RHEid#"
					debug="N"
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