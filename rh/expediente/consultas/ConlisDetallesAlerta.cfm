<cf_templatecss>


<cfif  not isdefined("Session.cache_empresarial")>
	<cfset Session.cache_empresarial = 0>
</cfif>
<cfif  not isdefined("Session.Params.ModoDespliegue")>
	<cfset Session.Params.ModoDespliegue = 1>
</cfif>


<cfif isdefined("Url.DLlinea") and not isdefined("Form.DLlinea")>
	<cfset Form.DLlinea = Url.DLlinea>
</cfif>
<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfset Form.DEid = Url.DEid>
</cfif>

<!--- Averiguar si hay que utilizar la tabla salarial --->
<cfquery name="rsTipoTabla" datasource="#Session.DSN#">
	select CSusatabla
	from ComponentesSalariales
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and CSsalariobase = 1
</cfquery>
<cfif rsTipoTabla.recordCount GT 0>
	<cfset usaEstructuraSalarial = rsTipoTabla.CSusatabla>
<cfelse>
	<cfset usaEstructuraSalarial = 0>
</cfif>

<cfif isdefined("Session.Ecodigo") AND isdefined("Form.DLlinea") AND Len(Trim(Form.DLlinea)) GT 0>
	<cfquery name="rsRHTespecial" datasource="#Session.DSN#">
		select c.RHTespecial,c.RHTcomportam 
		FROM DLaboralesEmpleado a
		inner join RHTipoAccion c
		on a.RHTid = c.RHTid
		WHERE a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DLlinea#">
		 <cfif Session.cache_empresarial EQ 0>
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		</cfif>
	</cfquery>
	<cfset 	 RHTespecial = rsRHTespecial.RHTespecial>
	<cfset 	 RHTcomportam = rsRHTespecial.RHTcomportam>
	<cfif RHTespecial eq  0>
	<!--- ********************************************************************************************* --->
	<!---                                 Acciones de tipo normal                                       --->
	<!--- ********************************************************************************************* --->
		<cfquery name="rsAccion" datasource="#Session.DSN#">
			SELECT 	a.DLlinea, 
					a.DLfechaaplic,
					a.DLfvigencia, 
					a.DLffin,
					a.DLsalario, 
					a.DLobs, 
					a.DLporcplaza, 
					a.DLporcplazaant as PorcPlazaAnterior,
					a.DLporcsal, 
					a.DLporcsalant as PorcSalarioAnterior,
					rtrim(c.RHTcodigo) as RHTcodigo, 
					c.RHTdesc, 
					b.Tdescripcion, 
					e.RHPid, 
					{fn concat({fn concat(rtrim( coalesce(pp.RHPPcodigo, e.RHPcodigo) ) , ' - ' )},  coalesce(pp.RHPPdescripcion, e.RHPdescripcion) )}  as RHPdescripcion, 
					coalesce(ltrim(rtrim(f.RHPcodigoext)),ltrim(rtrim(f.RHPcodigo))) as RHPcodigo, 
					f.RHPdescpuesto, 
					g.Descripcion as RegVacaciones, 
					h.Odescripcion, 
					i.Ddescripcion, 
					{fn concat({fn concat(rtrim(j.RHJcodigo) , ' - ' )},  j.RHJdescripcion )} as Jornada,
					a.RHCPlinea,
					s.RHTTid, rtrim(s.RHTTcodigo) as RHTTcodigo, s.RHTTdescripcion, 
					t.RHCid, rtrim(t.RHCcodigo) as RHCcodigo, t.RHCdescripcion, 
					u.RHMPPid, rtrim(u.RHMPPcodigo) as RHMPPcodigo, u.RHMPPdescripcion,
					a.Tcodigoant<!-----Como no existe un RHCPlinea anterior, se usa el Tcodigo ant, 
																					para que en los empleados que solo tienen la primera accion de 
																					nombramiento no aparezca la tabla/puesto/categoria de la accion de 
																					nombramiento aplicada------>
	
			FROM DLaboralesEmpleado a
			
			inner join RHTipoAccion c
			on a.RHTid = c.RHTid
			
			inner join TiposNomina b
			on a.Tcodigo = b.Tcodigo
			and a.Ecodigo = b.Ecodigo
			
			inner join RHPlazas e
			on a.RHPid = e.RHPid
			
			left outer join RHPlazaPresupuestaria pp
			on pp.RHPPid=e.RHPPid
			
			inner join RHPuestos f
			on a.Ecodigo = f.Ecodigo
			and a.RHPcodigo = f.RHPcodigo
			
			inner join RegimenVacaciones g
			on a.RVid = g.RVid
			
			inner join Oficinas h
			on a.Ocodigo = h.Ocodigo
			and a.Ecodigo = h.Ecodigo
	
			inner join Departamentos i
			on a.Dcodigo = i.Dcodigo
			and a.Ecodigo = i.Ecodigo
	
			inner join RHJornadas j
			on a.RHJid = j.RHJid
			and a.Ecodigo = j.Ecodigo
	
			left outer join RHCategoriasPuesto r
				on r.RHCPlinea = a.RHCPlinea
			left outer join RHTTablaSalarial s
				on s.RHTTid = r.RHTTid
			left outer join RHCategoria t
				on t.RHCid = r.RHCid
			left outer join RHMaestroPuestoP u
				on u.RHMPPid = r.RHMPPid
	
			WHERE a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DLlinea#">
			 <cfif Session.cache_empresarial EQ 0> 
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			</cfif> 
		</cfquery>
		
		<cfquery name="rsAccion2" datasource="#Session.DSN#">
			SELECT b2.Tdescripcion as NominaAnterior,
				   case when e2.RHPid is not null then {fn concat({fn concat(rtrim(coalesce(pp.RHPPcodigo, e2.RHPcodigo)) , ' - ' )},  coalesce(pp.RHPPdescripcion, e2.RHPdescripcion) )}  else '' end as PlazaAnterior,
				   case when f2.RHPcodigo is not null then {fn concat({fn concat(rtrim(coalesce(f2.RHPcodigoext,f2.RHPcodigo)) , ' - ' )},  f2.RHPdescpuesto )}  else '' end as PuestoAnterior,
				   g2.Descripcion as RegVacacionesAnterior, 
				   h2.Odescripcion as OficinaAnterior, 
				   i2.Ddescripcion as DeptoAnterior,
				   case when j2.RHJid is not null then {fn concat({fn concat(rtrim(j2.RHJcodigo) , ' - ' )},  j2.RHJdescripcion )}  else '' end as JornadaAnterior			   
	
			FROM DLaboralesEmpleado a
	
			left outer join TiposNomina b2
			on a.Tcodigoant = b2.Tcodigo
			and a.Ecodigoant = b2.Ecodigo
	
			left outer join RHPlazas e2
			on a.RHPidant = e2.RHPid
	
			left outer join RHPlazaPresupuestaria pp
			on pp.RHPPid=e2.RHPPid
			
			left outer join RHPuestos f2
			on a.Ecodigoant = f2.Ecodigo
			and a.RHPcodigoant = f2.RHPcodigo
	
			left outer join RegimenVacaciones g2
			on a.RVidant = g2.RVid
			
			left outer join Oficinas h2
			on a.Ocodigoant = h2.Ocodigo
			and a.Ecodigoant = h2.Ecodigo
	
			left outer join Departamentos i2
			on a.Dcodigoant = i2.Dcodigo
			and a.Ecodigoant = i2.Ecodigo
	
			left outer join RHJornadas j2
			on a.RHJidant = j2.RHJid
			and a.Ecodigoant = j2.Ecodigo
	
			WHERE a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DLlinea#">
			 <cfif Session.cache_empresarial EQ 0> 
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			 </cfif>
		</cfquery>
	
		<cfif rsAccion.recordCount GT 0>
			<!--- Conceptos de Pago --->
			<cfquery name="rsConceptosPago" datasource="#Session.DSN#">
				select {fn concat({fn concat(rtrim(b.CIcodigo) , ' - ' )},  b.CIdescripcion )}  as Concepto, 
					   a.DDCimporte as Importe, 
					   a.DDCcant as Cantidad, 
					   a.DDCres as Resultado
				from DDConceptosEmpleado a
				
				inner join CIncidentes b
				on a.CIid = b.CIid
				
				where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.DLlinea#">
			</cfquery>
	
			<cfquery name="rsDetalleAccion" datasource="#Session.DSN#">
				select a.CSid,
					   b.CScodigo, 
					   a.DDLtabla, 
					   b.CSdescripcion,
					   a.DDLunidad, 
					   a.DDLmontobase, 
					   a.DDLmontores,
					   coalesce(a.DDLunidadant,0.00) as UnidadAnterior, 
					   coalesce(a.DDLmontobaseant,0.00) as MontoBaseAnterior, 
					   coalesce(a.DDLmontoresant,0.00) as MontoResultadoAnterior,
					   a.CIid
	
				from DDLaboralesEmpleado a
				
				inner join ComponentesSalariales b
				on a.CSid = b.CSid
	
				where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.DLlinea#">
				
				order by b.CScodigo, b.CSdescripcion
			</cfquery>
	
			<cfif rsDetalleAccion.recordCount GT 0>
				<cfquery name="rsSumDetalleAccion" dbtype="query">
					select sum(DDLmontores) as Total, 
						   sum(MontoResultadoAnterior) as TotalAnterior 
					from rsDetalleAccion
					where CIid is null
				</cfquery>
			</cfif>
		</cfif>
	
	<cfelseif RHTespecial eq  1 > 
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Positiva"
		Default="Positiva"
		returnvariable="vPositiva"/>
	
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Negativa"
		Default="Negativa"
		returnvariable="vNegativa"/>
	
			<cfquery name="rsAccion" datasource="#Session.DSN#">
			SELECT 	a.DLlinea, 
					a.DLfechaaplic,
					a.DLfvigencia, 
					a.DLffin,
					a.DLsalario, 
					a.DLobs, 
					a.DLporcplaza, 
					a.DLporcplazaant as PorcPlazaAnterior,
					a.DLporcsal, 
					a.DLporcsalant as PorcSalarioAnterior,
					rtrim(c.RHTcodigo) as RHTcodigo, 
					c.RHTdesc, 
					a.RHCPlinea,
					a.Tcodigoant,
					case when a.RHAtipo=1 then '#vPositiva#' when a.RHAtipo=2 then '#vNegativa#' end RHAtipo,
					a.RHAdescripcion,
					a.EVfantig
	
			FROM DLaboralesEmpleado a
			inner join RHTipoAccion c
			on a.RHTid = c.RHTid
	
			WHERE a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DLlinea#">
			<!--- <cfif Session.cache_empresarial EQ 0> --->
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			<!--- </cfif> --->
		</cfquery>

	
	
	
	
	
	<!--- ********************************************************************************************* --->
	<!---                                 Acciones de tipo especial                                     --->
	<!--- ********************************************************************************************* --->
	</cfif>
<cfelse>
	<cfset RHTespecial = 0>
	<cfif not isdefined('Form.DLlinea') or Len(Trim(Form.DLlinea)) EQ 0>
		La acccion de personal es de tipo especial, y debe visualizarse como una anotacion en el expediente.
		<cfabort>
	</cfif>
</cfif>
<script type="text/javascript">
	function printURL (url) {
	  if (window.print && window.frames && window.frames.printerIframe) {
		var html = '';
		html += '<html>';
		html += '<body onload="parent.printFrame(window.frames.urlToPrint);">';
		html += '<iframe name="urlToPrint" src="' + url + '"><\/iframe>';
		html += '<\/body><\/html>';
		var ifd = window.frames.printerIframe.document;
		ifd.open();
		ifd.write(html);
		ifd.close();
	  }
	  else {
				var win = window.open('', 'printerWindow', 'width=600,height=300,resizable,scrollbars,toolbar,menubar');
				var html = '';
				html += '<html>';
				html += '<frameset rows="100%, *" ' 
					 +  'onload="opener.printFrame(window.urlToPrint);">';
				html += '<frame name="urlToPrint" src="' + url + '" \/>';
				html += '<frame src="about:blank" \/>';
				html += '<\/frameset><\/html>';
				win.document.open();
				win.document.write(html);
				win.document.close();
	  }
	}
	
	function printFrame (frame) {
	  if (frame.print) {
		frame.focus();
		frame.print();
		frame.src = "about:blank"
	  }
	}
</script>		
<SCRIPT src="/cfmx/rh/js/utilesMonto.js"></SCRIPT>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">

	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	function Lista() {
		history.back();
	}
	
	function imprimeAcciones(){
		printURL('/cfmx/rh/expediente/consultas/frame-detalleAcciones-all-print.cfm?DLlinea=<cfoutput>#Form.DLlinea#</cfoutput>&imprimir=true&DEid=<cfoutput>#Form.DEid#</cfoutput>');
	}
	
	//-->
</SCRIPT>
<cfoutput>
<cfif  RHTespecial eq  0>
	<!--- ********************************************************************************************* --->
	<!---                                 Acciones de tipo normal                                       --->
	<!--- ********************************************************************************************* --->
		<table width="100%" border="0" cellspacing="0" cellpadding="2" align="center">
		  <tr>
			<td align="right" nowrap class="fileLabel"><cf_translate key="TipoDeAccion">Tipo de Acci&oacute;n</cf_translate>:</td>
			<td nowrap> 
				#rsAccion.RHTcodigo# - #rsAccion.RHTdesc#
			</td>
			<td align="right" nowrap class="fileLabel"><cf_translate key="FechaAplicacion">Fecha Aplicaci&oacute;n</cf_translate>:</td>
			<td nowrap>
				#LSDateFormat(rsAccion.DLfechaaplic,'dd/mm/yyyy')#
			</td>
		  </tr>
		  <tr> 
			<td align="right" nowrap class="fileLabel"><cf_translate key="FechaVigencia">Fecha Vigencia</cf_translate>:</td>
			<td nowrap>
				#LSDateFormat(rsAccion.DLfvigencia,'dd/mm/yyyy')#
			</td>
			<td align="right" nowrap class="fileLabel"><cf_translate key="FechaVencimiento">Fecha Vencimiento</cf_translate>:</td>
			<td nowrap>
				<cfif len(trim(rsAccion.DLffin)) >#LSDateFormat(rsAccion.DLffin,'dd/mm/yyyy')#<cfelse><cf_translate key="indefinido">INDEFINIDO</cf_translate></cfif>
			</td>
		  </tr>
		  <tr> 
			<td width="10%" align="right" nowrap class="fileLabel"><cf_translate key="Observaciones">Observaciones</cf_translate>:</td>
			<td colspan="3" nowrap>
				#rsAccion.DLobs#
			</td>
		  </tr>
		  <tr>
			<td colspan="4">
			<table width="100%" border="0" cellspacing="0" cellpadding="2">
			  <tr>
				<td width="50%" valign="top">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
					  <tr>
						<td class="#Session.Preferences.Skin#_thcenter" colspan="2"><div align="center"><cf_translate key="SituacionAnterior">Situaci&oacute;n Anterior</cf_translate></div></td>
					  </tr>
	
					  <tr>
						<td height="25" class="fileLabel" nowrap><cf_translate key="Plaza">Plaza</cf_translate></td>
						<td height="25" nowrap>#rsAccion2.PlazaAnterior#</td>
					  </tr>
					  <tr>
						<td height="25" class="fileLabel" nowrap><cf_translate key="Oficina" XmlFile="/rh/generales.xml">Oficina</cf_translate></td>
						<td height="25" nowrap>#rsAccion2.OficinaAnterior#</td>
					  </tr>
					  <tr>
						<td height="25" class="fileLabel" nowrap><cf_translate key="Departamento">Departamento</cf_translate></td>
						<td height="25" nowrap>#rsAccion2.DeptoAnterior#</td>
					  </tr>
					  <cfif usaEstructuraSalarial EQ 1>
							<cfif len(trim(rsAccion.Tcodigoant))>
								<cf_rhcategoriapuesto form="form1" query="#rsAccion#" tablaReadonly="true" categoriaReadonly="true" puestoReadonly="true" incluyeTabla="false" incluyeHiddens="false">							
							<cfelse>
								<cf_rhcategoriapuesto form="form1" tablaReadonly="true" categoriaReadonly="true" puestoReadonly="true" incluyeTabla="false" incluyeHiddens="false">
							</cfif>
						</cfif>
					  <tr>
						<td height="25" class="fileLabel" nowrap><cf_translate key="Puesto_RH">Puesto RH</cf_translate></td>
						<td height="25" nowrap>#rsAccion2.PuestoAnterior#</td>
					  </tr>
					  <tr>
						<td height="25" class="fileLabel" nowrap><cf_translate key="Jornada">Jornada</cf_translate></td>
						<td height="25" nowrap>#rsAccion2.JornadaAnterior#</td>
					  </tr>
					  <tr>
						<td height="25" class="fileLabel" nowrap><cf_translate key="PorcentajeDePlaza">Porcentaje de Plaza</cf_translate></td>
						<td height="25" nowrap><cfif rsAccion.PorcPlazaAnterior NEQ "">#LSCurrencyFormat(rsAccion.PorcPlazaAnterior,'none')# %<cfelse>0.00 %</cfif></td>
						</tr>
					  <tr>
						<td height="25" class="fileLabel" nowrap><cf_translate key="PorcentajeDeSalarioFijo">Porcentaje de Salario Fijo</cf_translate></td>
						<td height="25" nowrap><cfif rsAccion.PorcSalarioAnterior NEQ "">#LSCurrencyFormat(rsAccion.PorcSalarioAnterior,'none')# %<cfelse>0.00 %</cfif></td>
						</tr>
	
	
					  <tr>
						<td height="25" class="fileLabel" nowrap><cf_translate key="TipoDeNomina">Tipo de N&oacute;mina</cf_translate></td>
						<td height="25" nowrap>#rsAccion2.NominaAnterior#</td>
					  </tr>
					  <tr>
						<td height="25" class="fileLabel" nowrap><cf_translate key="RegimenDeVacaciones">R&eacute;gimen de Vacaciones</cf_translate></td>
						<td height="25" nowrap>#rsAccion2.RegVacacionesAnterior#</td>
					  </tr>
					</table>
				</td>
				<td width="50%" valign="top">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
					  <tr>
						<td class="#Session.Preferences.Skin#_thcenter" colspan="2"><div align="center"><cf_translate key="SituacionActual">Situaci&oacute;n Actual</cf_translate></div></td>
					  </tr>
	
					  <tr>
						<td class="fileLabel" height="25" nowrap><cf_translate key="Plaza">Plaza</cf_translate></td>
						<td height="25" nowrap>#rsAccion.RHPdescripcion#</td>
						</tr>
					  <tr>
						<td class="fileLabel" height="25" nowrap><cf_translate key="Oficina" XmlFile="/rh/generales.xml">Oficina</cf_translate></td>
						<td height="25" nowrap>#rsAccion.Odescripcion# </td>
					  </tr>
					  <tr>
						<td class="fileLabel" height="25" nowrap><cf_translate key="Departamento">Departamento</cf_translate></td>
						<td height="25" nowrap>#rsAccion.Ddescripcion#</td>
					  </tr>
						<cfif usaEstructuraSalarial EQ 1>
							<cf_rhcategoriapuesto form="form1" query="#rsAccion#" tablaReadonly="true" categoriaReadonly="true" puestoReadonly="true" incluyeTabla="false" incluyeHiddens="false">
						</cfif>
					  <tr>
						<td class="fileLabel" height="25" nowrap><cf_translate key="Puesto_RH">Puesto RH</cf_translate></td>
						<td height="25" nowrap>#rsAccion.RHPcodigo# - #rsAccion.RHPdescpuesto# </td>
					  </tr>
					  <tr>
						<td class="fileLabel" height="25" nowrap><cf_translate key="Jornada">Jornada</cf_translate></td>
						<td height="25" nowrap>#rsAccion.Jornada#</td>
						</tr>
	
					  <tr>
						<td class="fileLabel" height="25" nowrap><cf_translate key="PorcentajeDePlaza">Porcentaje de Plaza</cf_translate></td>
						<td height="25" nowrap><cfif rsAccion.DLporcplaza NEQ "">#LSCurrencyFormat(rsAccion.DLporcplaza,'none')# %<cfelse>0.00 %</cfif></td>
						</tr>
					  <tr>
						<td class="fileLabel" height="25" nowrap><cf_translate key="PorcentajeDeSalarioFijo">Porcentaje de Salario Fijo</cf_translate></td>
						<td height="25" nowrap><cfif rsAccion.DLporcsal NEQ "">#LSCurrencyFormat(rsAccion.DLporcsal,'none')# %<cfelse>0.00 %</cfif></td>
						</tr>
	
					  <tr>
						<td class="fileLabel" height="25" nowrap><cf_translate key="TipoDeNomina">Tipo de N&oacute;mina</cf_translate></td>
						<td height="25" nowrap>#rsAccion.Tdescripcion#</td>
					  </tr>
					  <tr>
						<td class="fileLabel" height="25" nowrap><cf_translate key="RegimenDeVacaciones">R&eacute;gimen de Vacaciones</cf_translate></td>
						<td height="25" nowrap>#rsAccion.RegVacaciones# </td>
					  </tr>
	
						
					</table>
				</td>
			  </tr>
			  <tr>
				<td valign="top">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
					  <cfif isdefined("rsDetalleAccion") and rsDetalleAccion.recordCount GT 0>
						  <tr>
							<td class="#Session.Preferences.Skin#_thcenter" colspan="4"><div align="center"><cf_translate key="ComponentesAnteriores">Componentes Anteriores</cf_translate></div></td>
						  </tr>
						  <tr>
							<td class="tituloListas" colspan="2" nowrap><cf_translate key="SalarioTotalAnterior">Salario Total Anterior</cf_translate>: </td>
							<td class="tituloListas" align="right" nowrap>#LSCurrencyFormat(rsSumDetalleAccion.TotalAnterior,'none')#</td>
						  </tr>
						  <tr>
							<td class="tituloListas" nowrap><cf_translate key="Componente">Componente</cf_translate></td>
							<td class="tituloListas" align="right" nowrap><cf_translate key="Unidad">Unidades</cf_translate></td>
							<td class="tituloListas" align="right" nowrap><cf_translate key="MontoBase">Monto Base</cf_translate></td>
							<td class="tituloListas" align="right" nowrap><cf_translate key="Monto">Monto</cf_translate></td>
						  </tr>
					  <cfloop query="rsDetalleAccion">
						  <cfif Len(Trim(rsDetalleAccion.CIid))>
							<cfset color = ' style="color: ##FF0000;"'>
						  <cfelse>
							<cfset color = ''>
						  </cfif>
						  <tr>
							<td height="25" class="fileLabel"#color# nowrap>#rsDetalleAccion.CSdescripcion#</td>
							<td height="25" align="right"#color# nowrap>#LSNumberFormat(rsDetalleAccion.UnidadAnterior,',9.000000')#</td>
							<td height="25" align="right"#color# nowrap>#LSNumberFormat(rsDetalleAccion.MontoBaseAnterior,',9.000000')#</td>
							<td height="25" align="right"#color# nowrap>#LSCurrencyFormat(rsDetalleAccion.MontoBaseAnterior,'none')#</td>
						  </tr>
					  </cfloop>
					  </cfif>
					</table>
				</td>
				<td valign="top">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
					  <cfif isdefined("rsDetalleAccion") and rsDetalleAccion.recordCount GT 0>
						  <tr>
							<td class="#Session.Preferences.Skin#_thcenter" colspan="4"><div align="center"><cf_translate key="ComponentesActuales">Componentes Actuales</cf_translate></div></td>
						  </tr>
						  <tr>
							<td class="tituloListas" colspan="2" nowrap><cf_translate key="SalarioTotal">Salario Total</cf_translate>: </td>
							<td class="tituloListas" align="right" nowrap>#LSCurrencyFormat(rsSumDetalleAccion.Total,'none')#</td>
						  </tr>
						  <tr>
							<td class="tituloListas" nowrap><cf_translate key="Componente">Componente</cf_translate></td>
							<td class="tituloListas" align="right" nowrap><cf_translate key="Unidad">Unidades</cf_translate></td>
							<td class="tituloListas" align="right" nowrap><cf_translate key="MontoBase">Monto Base</cf_translate></td>
							<td class="tituloListas" align="right" nowrap><cf_translate key="Monto">Monto</cf_translate></td>
						  </tr>
					  <cfloop query="rsDetalleAccion">
						  <cfif Len(Trim(rsDetalleAccion.CIid))>
							<cfset color = ' style="color: ##FF0000;"'>
						  <cfelse>
							<cfset color = ''>
						  </cfif>
						  <tr>
							<td class="fileLabel" height="25"#color# nowrap>#rsDetalleAccion.CSdescripcion#</td>						
							<td height="25" align="right"#color# nowrap>#LSNumberFormat(rsDetalleAccion.DDLunidad,',9.000000')#</td>
							<td height="25" align="right"#color# nowrap>#LSNumberFormat(rsDetalleAccion.DDLmontobase,',9.000000')#</td>
							<td height="25" align="right"#color# nowrap>
								#LSCurrencyFormat(rsDetalleAccion.DDLmontores,'none')#
							</td>
						  </tr>
					  </cfloop>
					  </cfif>
					</table>
				</td>
			  </tr>
			</table>
			</td>
		  </tr>
		  <tr>
			<td colspan="4" align="center" style="color: ##FF0000 ">
				<cf_translate  key="MSG_LosComponentesQueAparecenEnColorRojoSePaganEnFormaIncidente">Los componentes que aparecen en color rojo se pagan en forma incidente.</cf_translate>
			</td>
		  </tr>
		  <cfif isdefined("rsConceptosPago") and rsConceptosPago.recordCount GT 0>
			  <tr>
				<td colspan="4">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
				  <tr>
					<td class="#Session.Preferences.Skin#_thcenter" colspan="4"><div align="center"><cf_translate key="ConceptosPago">Conceptos de Pago</cf_translate></div></td>
				  </tr>
				  <tr>
					<td class="tituloListas" nowrap><cf_translate key="Concepto">Concepto</cf_translate></td>
					<td class="tituloListas" align="right" nowrap><cf_translate key="Importe">Importe</cf_translate></td>
					<td class="tituloListas" align="right" nowrap><cf_translate key="Cantidad">Cantidad</cf_translate></td>
					<td class="tituloListas" align="right" nowrap><cf_translate key="Resultado">Resultado</cf_translate></td>
				  </tr>
				  <cfloop query="rsConceptosPago">
					  <tr>
						<td nowrap>#rsConceptosPago.Concepto#</td>
						<td align="right" nowrap>#LSCurrencyFormat(rsConceptosPago.Importe, 'none')#</td>
						<td align="right" nowrap>#LSCurrencyFormat(rsConceptosPago.Cantidad, 'none')#</td>
						<td align="right" nowrap>#LSCurrencyFormat(rsConceptosPago.Resultado, 'none')#</td>
					  </tr>
				  </cfloop>
				</table>
				</td>
			  </tr>
		  </cfif>
		  <cfif not isdefined('url.imprimir')>
			  <tr> 
				<td colspan="4" align="center">
				
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Regresar"
					Default="Regresar"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Regresar"/>
					
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Imprimir"
					Default="Imprimir"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Imprimir"/>
				
	
	
	
				
					<input type="button" name="Regresar" value="#BTN_Regresar#" tabindex="1" onClick="javascript:Lista();">
					<input type="button" name="imprimir" value="#BTN_Imprimir#" tabindex="1" onClick="javascript:imprimeAcciones();">
				</td>
			  </tr>
		  </cfif>
		</table>
<cfelseif isdefined("RHTespecial") and RHTespecial eq  1>
		<table width="100%" border="0" cellspacing="0" cellpadding="2" align="center">
		  <tr>
			<td align="right" nowrap class="fileLabel"><cf_translate key="TipoDeAccion">Tipo de Acci&oacute;n</cf_translate>:</td>
			<td nowrap> 
				#rsAccion.RHTcodigo# - #rsAccion.RHTdesc#
			</td>
			<td align="right" nowrap class="fileLabel"><cf_translate key="FechaAplicacion">Fecha Aplicaci&oacute;n</cf_translate>:</td>
			<td nowrap>
				#LSDateFormat(rsAccion.DLfechaaplic,'dd/mm/yyyy')#
			</td>
		  </tr>
		  <tr> 
			<td align="right" nowrap class="fileLabel"><cf_translate key="FechaVigencia">Fecha Vigencia</cf_translate>:</td>
			<td nowrap>
				#LSDateFormat(rsAccion.DLfvigencia,'dd/mm/yyyy')#
			</td>
			<td align="right" nowrap class="fileLabel"><cf_translate key="FechaVencimiento">Fecha Vencimiento</cf_translate>:</td>
			<td nowrap>
				<cfif len(trim(rsAccion.DLffin)) >#LSDateFormat(rsAccion.DLffin,'dd/mm/yyyy')#<cfelse><cf_translate key="indefinido">INDEFINIDO</cf_translate></cfif>
			</td>
		  </tr>
		  <tr> 
			<td width="10%" align="right" nowrap class="fileLabel"><cf_translate key="Observaciones">Observaciones</cf_translate>:</td>
			<td colspan="3" nowrap>
				#rsAccion.DLobs#
			</td>
		  </tr>
		  <tr> 
			<td colspan="4" nowrap>
				<fieldset>
					<table width="100%" border="0">
							<cfif RHTcomportam eq  10>
								<tr>
									<td width="10%" align="left" nowrap class="fileLabel"><cf_translate key="Fecha">Fecha</cf_translate>:</td>
									<td>#LSDateFormat(rsAccion.DLfvigencia,'dd/mm/yyyy')#</td>
								</tr>
								<tr>
									<td width="10%" align="left" nowrap class="fileLabel"><cf_translate key="Tipo">Tipo</cf_translate>:</td>
									<td>#rsAccion.RHAtipo#</td>
								</tr>
								<tr>
									<td width="10%" align="left" nowrap class="fileLabel"><cf_translate key="Texto">Texto</cf_translate>:</td>
									<td>#rsAccion.RHAdescripcion#</td>
								</tr>
							<cfelseif RHTcomportam eq  11>
								<tr>
									<td width="10%" align="left" nowrap class="fileLabel"><cf_translate key="FechaDeAntiguedad">Fecha de Antigüedad</cf_translate>:</td>
									<td>#LSDateFormat(rsAccion.EVfantig,'dd/mm/yyyy')#</td>
								</tr>
							</cfif>
						
						
						
					</table>
				</fieldset>
			</td>
		  </tr>

		  <cfif not isdefined('url.imprimir')>
			  <tr> 
				<td colspan="4" align="center">
				
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Regresar"
					Default="Regresar"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Regresar"/>
					
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Imprimir"
					Default="Imprimir"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Imprimir"/>
					<input type="button" name="Regresar" value="#BTN_Regresar#" tabindex="1" onClick="javascript:Lista();">
					<input type="button" name="imprimir" value="#BTN_Imprimir#" tabindex="1" onClick="javascript:imprimeAcciones();">
				</td>
			  </tr>
		  </cfif>
		</table>
</cfif>
</cfoutput>

