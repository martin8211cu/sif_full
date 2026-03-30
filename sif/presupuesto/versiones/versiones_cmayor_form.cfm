
<!--- MODO --->
<cfset modocambiodet = isdefined("form.Cmayor") and len(form.Cmayor) and form.Cmayor>
<!--- CONSULTAS --->
<cfif modocambiodet>

	<!--- Consulta Cuenta de Mayor --->
	<cfquery name="qry_cvm" datasource="#session.dsn#">
		select a.Ecodigo, a.CVid, a.Cmayor, a.Ctipo, a.CPVidOri, a.PCEMidOri, 
		coalesce(a.PCEMidNueva,a.PCEMidOri) as PCEMid, 
		a.Cmascara, a.CVMtipoControl, 
		a.CVMcalculoControl, 
		a.ts_rversion, 
		b.Cdescripcion, 
		b.Cmascara
		from CVMayor a
			inner join CtasMayor b
			on b.Cmayor = a.Cmayor
			and b.Ecodigo = a.Ecodigo
		where a.Ecodigo = #session.ecodigo#
		and a.CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
		and a.Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#">
	</cfquery>
	<cfif isdefined("qry_cvm") and len(trim(qry_cvm.PCEMid)) eq 0>
		<cf_errorCode	code = "50553" msg = "La Cuenta de Mayor no esta definida, por favor ingresarla en el catalogo.">
	</cfif>
	
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#qry_cvm.ts_rversion#" returnvariable="tsdet"/>
	<cfquery name="qry_cvp" datasource="#session.dsn#">
		select count(1) as cantidad
		  from CVPresupuesto
		 where Ecodigo = #session.ecodigo#
		   and CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
		   and Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#">
		   
	</cfquery>

	<!--- <cfdump var="#qry_cvm#">
	<cfdump var="#qry_cv#">
	<cfabort> --->
	<cfquery name="qry_pcm" datasource="#session.dsn#">
 	<cfif qry_cv.CVtipo EQ 2 and len(trim(qry_cvm.PCEMid)) NEQ 0>
		select 
			PCEMid,
			PCEMdesc,
			PCEMformatoP
		from PCEMascaras m
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		  and PCEMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_cvm.PCEMid#">
	UNION
	<cfelseif len(trim(qry_cvm.PCEMid)) NEQ 0>
		select 
			PCEMid,
			PCEMdesc,
			PCEMformatoP
		from PCEMascaras m
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		  and PCEMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_cvm.PCEMid#">
	UNION
	</cfif> 
	 
		select 
			PCEMid,
			PCEMdesc,
			PCEMformatoP
		from PCEMascaras m
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		<cfif len(trim(qry_cvm.PCEMid)) NEQ 0>
		    and PCEMformatoC like '#qry_cvm.Cmascara#%'
			
		<cfelseif qry_cvp.cantidad GT 0>
			and PCEMid = #qry_cvm.PCEMid#
			
		<cfelse>
			<!--- Solo se permiten Mascaras compatibles: --->
			<!--- Que tenga por lo menos un Nivel de Presupuesto --->
			and (exists	(
							select 1 from PCNivelMascara n
							 where n.PCEMid = m.PCEMid
							   and n.PCNpresupuesto = 1
						)
				 OR PCEMid = #qry_cvm.PCEMid#
				 )
			<!--- Que no falte un Nivel de Contabilidad existente en el original --->
			and not exists	(
							select 1 from PCNivelMascara o
							 where o.PCEMid = #qry_cvm.PCEMid#
							   and o.PCNcontabilidad = 1
							   and not exists (
												select 1 from PCNivelMascara n
												 where n.PCEMid = m.PCEMid
												   and n.PCNcontabilidad = 1
												   and n.PCNid = o.PCNid
												   and n.PCNlongitud = o.PCNlongitud
												   and (	n.PCEcatid IS NOT NULL AND o.PCEcatid IS NOT NULL
														OR	n.PCEcatid IS NULL AND o.PCEcatid IS NULL
														)
												   and coalesce (n.PCEcatid, n.PCNdep) = coalesce (o.PCEcatid, o.PCNdep)
									   			)
						)
			<!--- Que no exista un nuevo Nivel de Contabilidad dentro de los niveles existentes en el original --->
			and not exists	(
							select 1 from PCNivelMascara n
							 where n.PCEMid = m.PCEMid
							   and n.PCNcontabilidad = 1
							   and n.PCNid <= (
												select max(o.PCNid) from PCNivelMascara o
												 where o.PCEMid = #qry_cvm.PCEMid#
												   and o.PCNcontabilidad = 1
											   )
							   and not exists (
												select 1 from PCNivelMascara o
												 where o.PCEMid = #qry_cvm.PCEMid#
												   and o.PCNcontabilidad = 1
												   and n.PCNid = o.PCNid
												   and n.PCNlongitud = o.PCNlongitud
												   and (	n.PCEcatid IS NOT NULL AND o.PCEcatid IS NOT NULL
														OR	n.PCEcatid IS NULL AND o.PCEcatid IS NULL
														)
												   and coalesce (n.PCEcatid, n.PCNdep) = coalesce (o.PCEcatid, o.PCNdep)
									   			)
						)
					
		</cfif>
	</cfquery>
	<!--- FORM --->
	<!--- Manenimiento de CVMayor : CVid, Cmayor, CVMtipoControl, CVMcalculoControl --->
	<form action="versiones_sql.cfm" method="post" name="form2">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="2" bgcolor="#EBEBEB" class="titulolistas" align="center"><cfoutput>#qry_cvm.Cmayor# - #qry_cvm.Cdescripcion#</cfoutput>
				</td>
			</tr>
			<tr>
				<td nowrap valign="top" align="right"><label for="CVMtipoControl"><strong>Tipo Control Default&nbsp;:&nbsp;</strong></label>
				</td>
				<td nowrap>
					<select name="CVMtipoControl" accesskey="1" tabindex="1" id="CVMtipoControl">
					  <option value="0" <cfif (isDefined("qry_cvm.CVMtipoControl") AND 0 EQ qry_cvm.CVMtipoControl)>selected</cfif>>Abierto</option>
					  <option value="1" <cfif (isDefined("qry_cvm.CVMtipoControl") AND 1 EQ qry_cvm.CVMtipoControl)>selected</cfif>>Restringido</option>
					  <option value="2" <cfif (isDefined("qry_cvm.CVMtipoControl") AND 2 EQ qry_cvm.CVMtipoControl)>selected</cfif>>Restrictivo</option>
					</select>
				</td>
			</tr>
			<tr>
				<td nowrap valign="top" align="right"><label for="select"><strong>M&eacute;todo Calculo Default&nbsp;:&nbsp;</strong></label>
				</td>
				<td nowrap>
				  <select name="CVMcalculoControl" accesskey="2" tabindex="2" id="CVMcalculoControl">
				    <option value="1" <cfif (isDefined("qry_cvm.CVMcalculoControl") AND 1 EQ qry_cvm.CVMcalculoControl)>selected</cfif>>Mensual</option>
				    <option value="2" <cfif (isDefined("qry_cvm.CVMcalculoControl") AND 2 EQ qry_cvm.CVMcalculoControl)>selected</cfif>>Acumulado</option>
				    <option value="3" <cfif (isDefined("qry_cvm.CVMcalculoControl") AND 3 EQ qry_cvm.CVMcalculoControl)>selected</cfif>>Total</option>
			    </select>
				</td>
			</tr>
			<tr>
				<td nowrap valign="top" align="right"><label for="select"><strong>M&aacute;scara&nbsp;:&nbsp;</strong></label>
				</td>
				<td nowrap>
					<select name="PCEMidNueva" accesskey="3" tabindex="3" id="PCEMidNueva" onChange="javascript:changeCmascara(this.value);">
						<cfoutput query="qry_pcm">
							<option value="#qry_pcm.PCEMid#" <cfif (isdefined("qry_cvm.PCEMid") AND len(qry_cvm.PCEMid) AND qry_cvm.PCEMid eq qry_pcm.PCEMid)>selected</cfif>>#qry_pcm.PCEMdesc#</option>
						</cfoutput>
					</select>
				</td>
			</tr>
			<tr>
				<td nowrap colspan="2" align="center">
					<input class="cajasinbordeb" type="text" name="Cmascara" accesskey="-1" tabindex="-1" id="CVdescripcion" size="40" maxlength="40" value="<cfif isdefined("qry_cv.Cmascara")><cfoutput>#qry_cv.Cmascara#</cfoutput></cfif>">
				</td>
			</tr>
			<tr><td nowrap>&nbsp;</td></tr>
			<tr>
				<td nowrap valign="middle" colspan="2">
						<cf_botones values="Modificar" names="CambioDet" tabindex = "4">
				
				  <input name="CVid" type="hidden" id="CVid" value="<cfoutput>#qry_cvm.CVid#</cfoutput>">
				  <input name="Cmayor" type="hidden" id="Cmayor" value="<cfoutput>#qry_cvm.Cmayor#</cfoutput>">
			  	<input name="ts_rversiondet" type="hidden" id="ts_rversiondet" value="<cfoutput>#tsdet#</cfoutput>">
					<input name="pagenum2" type="hidden" id="pagenum2" value="<cfif isdefined("form.pagenum2")><cfoutput>#form.pagenum2#</cfoutput><cfelse>1</cfif>">
					<input type="hidden" name="CPPid" value="<cfoutput>#qry_cv.CPPid#</cfoutput>">
					<input name="PCEMidOri" type="hidden" id="PCEMidOri" value="<cfoutput>#qry_cvm.PCEMidOri#</cfoutput>">
				</td>
			</tr>
		</table>
	</form>
	<script language="javascript" type="text/javascript">
		<!--//
		function changeCmascara(pcemid){
		var lpcemid = pcemid!=null?pcemid:document.form2.PCEMidNueva.value;
		<cfoutput query="qry_pcm">
			if (lpcemid==#qry_pcm.PCEMid#)
				document.form2.Cmascara.value='#qry_pcm.PCEMformatoP#';
		</cfoutput>
		}
		changeCmascara();
		//-->
	</script>
<cfelse>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td bgcolor="#EBEBEB" class="titulolistas" align="center">Seleccione un ítem</td>
			</tr>
			<tr>
				<td class="Ayuda" style="border-color:#C1C1C1; border-width:thin">
				<blockquote>
				<br>
				<strong>Cuentas de Mayor&nbsp;:&nbsp;</strong><br>
				<p>
					En esta sección se permite realizar las siguientes acciones:
					<ol>
					<li><strong>Realizar modificaciones&nbsp;:&nbsp; </strong>seleccione el ítem deseado.</li>
					<li><strong>Consultar control de presupuesto&nbsp;:&nbsp; </strong>haga click sobre el ícono <span style="color:#0000FF">azul</span>, que se encuentra a la izquierda de la lista.</li>
					</ol>
				</p>
				</blockquote>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>
</cfif>
<cfif modocambiodet>
	<script language="javascript" type="text/javascript">
		//instancias de qforms
		objForm2 = new qForm("form2");
		
		objForm2.PCEMidNueva.required = true;	
		objForm2.PCEMidNueva.description = "Máscara";
		
		function funcListoDet(){
			deshabilitarValidacion();
		}
		
		function funcCambioDet(){
			habilitarValidacion();
		}	
		
		function habilitarValidacion(){
			objForm2.PCEMidNueva.required = true;
		}		
		
		function deshabilitarValidacion(){
			objForm2.PCEMidNueva.required = false;
		}	
	</script>
</cfif>



