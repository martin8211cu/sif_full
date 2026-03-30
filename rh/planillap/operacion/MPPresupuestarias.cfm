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
<script type="text/javascript" language="javascript1.2">
	function funcValida(){
		var vrs_verifica = <cfoutput>#rsVerificaCalculo.CalculoEscenario#</cfoutput>;
		if (vrs_verifica == 0){
			if(confirm('¿Esta seguro que desea importar las solicitudes de plaza?')){
				document.formSolicitudPlaza.action = 'SP-PPresupuestarias-sql.cfm';
				//document.formSolicitudPlaza.submit();
				return true;
				//document.formSolicitudPlaza.submit();
			}
			return false;
		}
		else{
			if(confirm('Ya se ha calculado el escenario.  ¿Esta seguro que desea importar las plazas solicitadas y perder los datos?')){
				document.formSolicitudPlaza.action = 'SP-PPresupuestarias-sql.cfm';
				return true;
				//document.formSolicitudPlaza.submit();
			}
			return false			
		}
	}
</script>
<form name="formSolicitudPlaza" method="post" action="">
	<input type="hidden" name="RHEid" 	value="<cfif isdefined("form.RHEid") and len(trim(form.RHEid))>#form.RHEid#</cfif>">
	<input type="hidden" name="RHEfdesde" 	value="<cfif isdefined("form.RHEfdesde") and len(trim(form.RHEfdesde))>#form.RHEfdesde#<cfelseif isdefined("rsEscenario") and rsEscenario.recordCount NEQ 0>#rsEscenario.RHEfdesde#</cfif>">
	<input type="hidden" name="RHEfhasta" 	value="<cfif isdefined("form.RHEfhasta") and len(trim(form.RHEfhasta))>#form.RHEfhasta#<cfelseif isdefined("rsEscenario") and rsEscenario.recordCount NEQ 0>#rsEscenario.RHEfhasta#</cfif>">
	<input type="hidden" name="RHSAidEliminar" 	value="">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center" >  
	  <tr>
		<td width="40%" class="tituloListas" >
			<strong style="color:##003366; font-family:'Times New Roman', Times, serif; font-size:13pt; font-variant:small-caps; font-weight:bolder;">Plazas Presupuestadas</strong></td>
		<td colspan="3" class="tituloListas">
			<table width="65%" cellpadding="0" cellspacing="0" align="right"><tr>
			<td width="33%" align="center">
				<cf_botones names="Modificar" values="Modificar">
			</td>
		</tr></table></td>
	  </tr>
	  <tr><td class="tituloListas" colspan="4">&nbsp;</td></tr>
	  <tr>
		<td valign="top" colspan="4">
			<fieldset>
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr><td>
				<cf_dbfunction name="concat" args="e.RHTTcodigo,' - ',e.RHTTdescripcion" returnvariable="Lvar_TablaSal">
	<cf_dbfunction name="to_char" args="d.RHSAid" returnvariable="Lvar_RHSAid">
	<cf_dbfunction name="concat" args="'<img border=''0'' onClick=''javascript: funcEliminar('	|#preservesinglequotes(Lvar_RHSAid)#|');'' src=''/cfmx/rh/imagenes/Borrar01_S.gif''>'" returnvariable="Lvar_img" delimiters="|">
			<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">

				<cfinvoke 
					component="rh.Componentes.pListas" 
					method="pListaRH"
					returnvariable="rsLista"
					columnas="	d.RHSAid,
								a.RHSPid,								
								d.fdesdeplaza,
								case d.fhastaplaza 	when '61000101' then 'Indefinido'
													else convert(varchar,d.fhastaplaza,103)
								end as fhastaplaza,
								a.RHSPconsecutivo,
								coalesce(b.RHPdescpuesto,c.RHMPPdescripcion) as RHPdescpuesto,
								c.RHMPPcodigo,
								c.RHMPPdescripcion,
								#Lvar_TablaSal# as TablaSalarial,
								#preservesinglequotes(Lvar_img)# as eliminar"					
					tabla="RHSituacionActual d
							inner join RHSolicitudPlaza a
								on a.RHSPid = d.RHSPid
								and a.Ecodigo = d.Ecodigo 
						
								left outer join RHPuestos b
									on a.RHPcodigo = b.RHPcodigo
									and a.Ecodigo = b.Ecodigo
						
								left outer join RHMaestroPuestoP c
									on a.RHMPPid = c.RHMPPid
									and a.Ecodigo = c.Ecodigo
								
								left outer join RHTTablaSalarial e
									on a.RHTTid = e.RHTTid
									and a.Ecodigo = e.Ecodigo"
					keys="RHSAid"
					filtro="d.Ecodigo=#Session.Ecodigo# 
							and d.RHEid = #form.RHEid#
							and d.RHSPid is not null"
					mostrar_filtro="true"
					filtrar_automatico="true"
					etiquetas="No.Solicitud,Tabla Salarial, Puesto Solicitado, Fecha inicial, Fecha final,&nbsp;"
					desplegar="RHSPconsecutivo,TablaSalarial, RHPdescpuesto, fdesdeplaza, fhastaplaza,eliminar"
					filtrar_por="a.RHSPconsecutivo,
								e.RHTTcodigo#LvarCNCT#' - '#LvarCNCT#e.RHTTdescripcion,
								b.RHPdescpuesto,
								a.RHSPfdesde,
								a.RHSPfhasta,
								''"
					align="left,left,left,left,left,left"					
					formatos="S,S,S,D,S,G"
					ira=""					
					maxrows="10"
					checkboxes="n"
					showemptylistmsg="true"
					formname="formSolicitudPlaza"
					showLink="false"
					incluyeform="false"
					funcion="window.parent.funcMuestraComponentes"
					fparams="RHSAid"	
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