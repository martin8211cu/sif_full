<cfinvoke key="LB_Semanal" default="Semanal"	 returnvariable="LB_Semanal" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Bisemanal" default="Bisemanal"	 returnvariable="LB_Bisemanal" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Quincenal" default="Quincenal"	 returnvariable="LB_Quincenal" component="sif.Componentes.Translate" method="Translate"/>

<cfset Session.cache_empresarial = 0>
<cfif isdefined("Url.DLlinea") and not isdefined("Form.DLlinea")>
	<cfset Form.DLlinea = Url.DLlinea>
</cfif>
<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfset Form.DEid = Url.DEid>
</cfif>

<cfquery name="rsMostrarSalarioNominal" datasource="#session.DSN#">
	select coalesce(Pvalor,'0') as  Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and Pcodigo = 1040
</cfquery>

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
		select c.RHTespecial,c.RHTcomportam ,coalesce(c.RHTNoMuestraCS,0) as RHTNoMuestraCS, DLfvigencia,coalesce(DLffin,'61000101') as DLffin,DLreplicacion
		FROM DLaboralesEmpleado a
		inner join RHTipoAccion c
		on a.RHTid = c.RHTid
		WHERE a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DLlinea#">
	</cfquery>
	<cfset 	 RHTespecial = rsRHTespecial.RHTespecial>
	<cfset 	 RHTcomportam = rsRHTespecial.RHTcomportam>
	<cfset  RHTNoMuestraCS = rsRHTespecial.RHTNoMuestraCS>
    <cfset Lvar_Replicacion = rsRHTespecial.DLreplicacion>
	
	<!--- VERIFICA SI TIENE RECARGOS --->
	<cfquery name="rsRecargos" datasource="#session.DSN#">
		select 1
		from LineaTiempoR
		where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		  and (LTdesde between <cfqueryparam cfsqltype="cf_sql_date" value="#rsRHTespecial.DLfvigencia#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsRHTespecial.DLffin#"> 
        or LThasta between <cfqueryparam cfsqltype="cf_sql_date" value="#rsRHTespecial.DLfvigencia#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#rsRHTespecial.DLffin#">)
	</cfquery>
	<cfset Lvar_Recargos = 0>
	<cfif isdefined('rsRecargos') and rsRecargos.RecordCount>
	<cfset Lvar_Recargos = 1>
	</cfif>
	
	
	<cfif RHTespecial eq  0>
	<!--- ********************************************************************************************* --->
	<!---                                 Acciones de tipo normal                                       --->
	<!--- ********************************************************************************************* --->
		<cfquery name="rsAccion" datasource="#Session.DSN#">
			SELECT 	a.DLlinea, 
					a.DLfechaaplic,
					a.DLfvigencia, 
					coalesce(a.DLffin,'61000101') as DLffin,
					a.DEid,
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
					e.CFid,
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
					a.Tcodigo,
					a.RHTid,cf.CFdescripcion,
					a.Tcodigoant<!-----Como no existe un RHCPlinea anterior, se usa el Tcodigo ant, 
																					para que en los empleados que solo tienen la primera accion de 
																					nombramiento no aparezca la tabla/puesto/categoria de la accion de 
																					nombramiento aplicada------>
					,a.DLreplicacion
			FROM DLaboralesEmpleado a
			
			inner join RHTipoAccion c
			on a.RHTid = c.RHTid
			
			inner join TiposNomina b
			on a.Tcodigo = b.Tcodigo
			and a.Ecodigo = b.Ecodigo
			
			inner join RHPlazas e
				inner join CFuncional cf
				on cf.CFid=e.CFid
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
			<!--- <cfif Session.cache_empresarial EQ 0>
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			</cfif> --->
		</cfquery>
		
		<cfquery name="rsAccion2" datasource="#Session.DSN#">
			SELECT b2.Tdescripcion as NominaAnterior,
				   case when e2.RHPid is not null then {fn concat({fn concat(rtrim(coalesce(pp.RHPPcodigo, e2.RHPcodigo)) , ' - ' )},  coalesce(pp.RHPPdescripcion, e2.RHPdescripcion) )}  else '' end as PlazaAnterior,
				   case when f2.RHPcodigo is not null then {fn concat({fn concat(rtrim(coalesce(f2.RHPcodigoext,f2.RHPcodigo)) , ' - ' )},  f2.RHPdescpuesto )}  else '' end as PuestoAnterior,
				   g2.Descripcion as RegVacacionesAnterior, 
				   h2.Odescripcion as OficinaAnterior, 
				   i2.Ddescripcion as DeptoAnterior,
				   case when j2.RHJid is not null then {fn concat({fn concat(rtrim(j2.RHJcodigo) , ' - ' )},  j2.RHJdescripcion )}  else '' end as JornadaAnterior,
				   a.Tcodigoant	,c.CFdescripcion		   
	
			FROM DLaboralesEmpleado a
	
			left outer join TiposNomina b2
			on a.Tcodigoant = b2.Tcodigo
			and a.Ecodigoant = b2.Ecodigo
	
			left outer join RHPlazas e2
				inner join CFuncional c
				on c.CFid=e2.CFid
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
			<!--- <cfif Session.cache_empresarial EQ 0>
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			</cfif> --->
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
		default="Positiva"
		returnvariable="vPositiva"/>
	
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Negativa"
		default="Negativa"
		returnvariable="vNegativa"/>
	
			<cfquery name="rsAccion" datasource="#Session.DSN#">
			SELECT 	a.DLlinea, 
					a.DLfechaaplic,
					a.DLfvigencia, 
					coalesce(a.DLffin,'61000101') as DLffin,
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
			<!--- <cfif Session.cache_empresarial EQ 0>
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			</cfif> --->
		</cfquery>


	
	
	
	
	
	<!--- ********************************************************************************************* --->
	<!---                                 Acciones de tipo especial                                     --->
	<!--- ********************************************************************************************* --->
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
<script src="/cfmx/rh/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript">

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
</script>
<cfoutput>
<cfif RHTespecial eq  0>
	<!--- ********************************************************************************************* --->
	<!---                                 Acciones de tipo normal                                       --->
	<!--- ********************************************************************************************* --->
		<table width="<cfif isdefined('url.imprimir')>650<cfelse>100%</cfif>" border="0" cellspacing="0" cellpadding="2" align="center">
		  <tr>
			<td align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif> class="fileLabel"><cf_translate key="TipoDeAccion">Tipo de Acci&oacute;n</cf_translate>:</td>
			<td <cfif not isdefined('url.imprimir')>nowrap</cfif>> 
				#rsAccion.RHTcodigo# - #rsAccion.RHTdesc#
			</td>
			<td align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif> class="fileLabel"><cf_translate key="FechaAplicacion">Fecha Aplicaci&oacute;n</cf_translate>:</td>
			<td <cfif not isdefined('url.imprimir')>nowrap</cfif>>
				#LSDateFormat(rsAccion.DLfechaaplic,'dd/mm/yyyy')#
			</td>
		  </tr>
		  <tr> 
			<td align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif> class="fileLabel"><cf_translate key="FechaVigencia">Fecha Vigencia</cf_translate>:</td>
			<td <cfif not isdefined('url.imprimir')>nowrap</cfif>>
				#LSDateFormat(rsAccion.DLfvigencia,'dd/mm/yyyy')#
			</td>
			<td align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif> class="fileLabel"><cf_translate key="FechaVencimiento">Fecha Vencimiento</cf_translate>:</td>
			<td <cfif not isdefined('url.imprimir')>nowrap</cfif>>
				<cfif len(trim(rsAccion.DLffin)) >#LSDateFormat(rsAccion.DLffin,'dd/mm/yyyy')#<cfelse><cf_translate key="indefinido">INDEFINIDO</cf_translate></cfif>
			</td>
		  </tr>
		  <tr> 
			<td valign="top" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif> class="fileLabel"><cf_translate key="Observaciones">Observaciones</cf_translate>:</td>
			<td colspan="3" >
				#rsAccion.DLobs#
			</td>
		  </tr>
          <cfif rsAccion.DLreplicacion EQ 1>
		  <tr> 
			<td align="right"><input name="DLfvigencia" type="checkbox" disabled="disabled" checked="checked"/></td>
			<td class="fileLabel"><cf_translate key="CHK_TodasPlazas">Aplica para todas las plazas</cf_translate></td>
		  </tr>
          
          </cfif>
		  <tr>
			<td colspan="4">
			<table width="100%" border="0" cellspacing="0" cellpadding="2">
			  <tr>
				<td width="50%" valign="top">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
					  <tr>
						<td class="#Session.Preferences.Skin#_thcenter" colspan="2"><div align="center"><cf_translate key="SituacionAnterior">Situaci&oacute;n Anterior</cf_translate>
						</div></td>
					  </tr>					
					  <tr>
						<td height="25" class="fileLabel" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Empresa">Empresa</cf_translate></td>
						<td height="25" nowrap>#Session.Enombre#</td>
					  </tr>				
				
					  <tr>
						<td height="25" class="fileLabel" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Plaza">Plaza</cf_translate></td>
						<td height="25">#rsAccion2.PlazaAnterior#</td>
					  </tr>
					  <tr>
						<td height="25" class="fileLabel" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Oficina" XmlFile="/rh/generales.xml">Oficina</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion2.OficinaAnterior#</td>
					  </tr>
					  <tr>
						<td height="25" class="fileLabel" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Departamento">Departamento</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion2.DeptoAnterior#</td>
					  </tr>
					   <tr>
						<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Centro_Funcional">Centro Funcional</cf_translate></td>
						<td>#rsAccion2.CFdescripcion#</td>
					  </tr>
					  <cfif usaEstructuraSalarial EQ 1>
							<cfif len(trim(rsAccion.Tcodigoant))>
								<cf_rhcategoriapuesto form="form1" query="#rsAccion#" tablaReadonly="true" categoriaReadonly="true" puestoReadonly="true" incluyeTabla="false" incluyeHiddens="false">							
							<cfelse>
								<cf_rhcategoriapuesto form="form1" tablaReadonly="true" categoriaReadonly="true" puestoReadonly="true" incluyeTabla="false" incluyeHiddens="false">
							</cfif>
						</cfif>
					  <tr>
						<td height="25" class="fileLabel" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Puesto_RH">Puesto RH</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion2.PuestoAnterior#</td>
					  </tr>
					  <tr>
						<td height="25" class="fileLabel" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Jornada">Jornada</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion2.JornadaAnterior#</td>
					  </tr>
					  <tr>
						<td height="25" class="fileLabel" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="PorcentajeDePlaza">Porcentaje de Plaza</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cfif rsAccion.PorcPlazaAnterior NEQ "">#LSCurrencyFormat(rsAccion.PorcPlazaAnterior,'none')# %<cfelse>0.00 %</cfif></td>
						</tr>
					  <tr>
						<td height="25" class="fileLabel" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="PorcentajeDeSalarioFijo">Porcentaje de Salario Fijo</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cfif rsAccion.PorcSalarioAnterior NEQ "">#LSCurrencyFormat(rsAccion.PorcSalarioAnterior,'none')# %<cfelse>0.00 %</cfif></td>
						</tr>
	
	
					  <tr>
						<td height="25" class="fileLabel" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="TipoDeNomina">Tipo de N&oacute;mina</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion2.NominaAnterior#</td>
					  </tr>
					  <tr>
						<td height="25" class="fileLabel" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="RegimenDeVacaciones">R&eacute;gimen de Vacaciones</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion2.RegVacacionesAnterior#</td>
					  </tr>
					</table>
				</td>
				<td width="50%" valign="top">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
					  <tr>
						<td class="#Session.Preferences.Skin#_thcenter" colspan="2"><div align="center"><cf_translate key="SituacionActual">Situaci&oacute;n Actual</cf_translate></div></td>
					  </tr>
	 					<tr>
						<td height="25" class="fileLabel" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Empresa">Empresa</cf_translate></td>
						<td height="25" nowrap>#Session.Enombre#</td>
					  </tr>	
					  <tr>
						<td class="fileLabel" height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Plaza">Plaza</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.RHPdescripcion#</td>
						</tr>
					  <tr>
						<td class="fileLabel" height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Oficina" XmlFile="/rh/generales.xml">Oficina</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.Odescripcion# </td>
					  </tr>
					  <tr>
						<td class="fileLabel" height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Departamento">Departamento</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.Ddescripcion#</td>
					  </tr>
						<cfif usaEstructuraSalarial EQ 1>
							<cf_rhcategoriapuesto form="form1" query="#rsAccion#" tablaReadonly="true" categoriaReadonly="true" puestoReadonly="true" incluyeTabla="false" incluyeHiddens="false">
						</cfif>
					  <tr>
						<td height="25" class="fileLabel" nowrap><cf_translate key="LB_Centro_Funcional">Centro Funcional</cf_translate></td>
						<td>#rsAccion.CFdescripcion#</td>
					  </tr>
					  <tr>
						<td class="fileLabel" height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Puesto_RH">Puesto RH</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.RHPcodigo# - #rsAccion.RHPdescpuesto# </td>
					  </tr>
					  <tr>
						<td class="fileLabel" height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Jornada">Jornada</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.Jornada#</td>
						</tr>
	
					  <tr>
						<td class="fileLabel" height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="PorcentajeDePlaza">Porcentaje de Plaza</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cfif rsAccion.DLporcplaza NEQ "">#LSCurrencyFormat(rsAccion.DLporcplaza,'none')# %<cfelse>0.00 %</cfif></td>
						</tr>
					  <tr>
						<td class="fileLabel" height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="PorcentajeDeSalarioFijo">Porcentaje de Salario Fijo</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cfif rsAccion.DLporcsal NEQ "">#LSCurrencyFormat(rsAccion.DLporcsal,'none')# %<cfelse>0.00 %</cfif></td>
						</tr>
	
					  <tr>
						<td class="fileLabel" height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="TipoDeNomina">Tipo de N&oacute;mina</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.Tdescripcion#</td>
					  </tr>
					  <tr>
						<td class="fileLabel" height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="RegimenDeVacaciones">R&eacute;gimen de Vacaciones</cf_translate></td>
						<td height="25" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsAccion.RegVacaciones# </td>
					  </tr>
						
					</table>
				</td>
			  </tr>
			  <cfif Lvar_Replicacion>
              		<cfset Lvar_FechaActRecI = rsAccion.DLfvigencia>
                    <cfset Lvar_FechaActRecF = rsAccion.DLffin>
				  <tr>
					<td colspan="2" valign="top">
                    	<cfinclude template="frame-detalleRecargos.cfm">
                        
						<!--- <cfinclude template="../../nomina/operacion/AccionesRecargos-form-recargact.cfm"> ---><!---recargos actuales--->
					</td>
				  </tr>
			  </cfif>
			  <tr <cfif RHTNoMuestraCS eq 1 >style="display:none"</cfif>>
				<td valign="top" > 
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
					  <cfif isdefined("rsDetalleAccion") and rsDetalleAccion.recordCount GT 0>
						  <tr >
							<td class="#Session.Preferences.Skin#_thcenter" colspan="4"><div align="center"><cf_translate key="ComponentesAnteriores">Componentes Anteriores</cf_translate></div></td>
						  </tr>
						  <tr>
							<td class="tituloListas" colspan="2" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="SalarioTotalAnterior">Salario Total Anterior</cf_translate>: </td>
							<td class="tituloListas" colspan="2" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSCurrencyFormat(rsSumDetalleAccion.TotalAnterior,'none')#</td>
						  </tr>
						  <cfif rsMostrarSalarioNominal.Pvalor eq 1>
								<cfquery name="rsTiposNomina" datasource="#Session.DSN#">
									select 
										Ttipopago,
										case Ttipopago when 0 then '#LB_Semanal#'
										when 1 then '#LB_Bisemanal#'
										when 2 then '#LB_Quincenal#'
										else ''
										end as   descripcion
									from TiposNomina 
									where 
									Ecodigo 	=  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
									and Tcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAccion2.Tcodigoant#">
								</cfquery>		
							    <cfif rsTiposNomina.Ttipopago neq 3>
									<cfinvoke component="rh.Componentes.RH_Funciones" 
										method="salarioTipoNomina"
										salario = "#rsSumDetalleAccion.TotalAnterior#"
										tcodigo = "#rsAccion2.Tcodigoant#"
										returnvariable="var_salarioTipoNomina">
									  <tr>
										<td class="tituloListas" colspan="2" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="LB_Salario">Salario</cf_translate>&nbsp;#rsTiposNomina.descripcion#:</td>
										<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSNumberFormat(var_salarioTipoNomina,',9.00')#</td>
									  </tr>
									  					  
							  </cfif>
						  </cfif>
						  <tr>
							<td class="tituloListas" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Componente">Componente</cf_translate></td>
							<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Unidad">Unidades</cf_translate></td>
							<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="MontoBase">Monto Base</cf_translate></td>
							<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Monto">Monto</cf_translate></td>
						  </tr>
					  <cfloop query="rsDetalleAccion">
						  <cfif Len(Trim(rsDetalleAccion.CIid))>
							<cfset color = ' style="color: ##FF0000;"'>
						  <cfelse>
							<cfset color = ''>
						  </cfif>
						  <tr>
							<td height="25" class="fileLabel"#color# <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsDetalleAccion.CSdescripcion#</td>
							<td height="25" align="right"#color# <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSNumberFormat(rsDetalleAccion.UnidadAnterior,',9.00')#</td>
							<td height="25" align="right"#color# <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSNumberFormat(rsDetalleAccion.MontoBaseAnterior,',9.00')#</td>
							<td height="25" align="right"#color# <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSCurrencyFormat(rsDetalleAccion.MontoBaseAnterior,'none')#</td>
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
							<td class="tituloListas" colspan="2" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="SalarioTotal">Salario Total</cf_translate>: </td>
							<td class="tituloListas" colspan="2" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSCurrencyFormat(rsSumDetalleAccion.Total,'none')#</td>
						  </tr>
							<cfif rsMostrarSalarioNominal.Pvalor eq 1>
									<cfquery name="rsTiposNomina" datasource="#Session.DSN#">
										select 
											Ttipopago,
											case Ttipopago when 0 then '#LB_Semanal#'
											when 1 then '#LB_Bisemanal#'
											when 2 then '#LB_Quincenal#'
											else ''
											end as   descripcion
										from TiposNomina 
										where 
										Ecodigo 	=  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
										and Tcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAccion.Tcodigo#">
									</cfquery>		
									<cfif rsTiposNomina.Ttipopago neq 3>
										<cfinvoke component="rh.Componentes.RH_Funciones" 
											method="salarioTipoNomina"
											salario = "#rsSumDetalleAccion.Total#"
											tcodigo = "#rsAccion.Tcodigo#"
											returnvariable="var_salarioTipoNomina">
										  <tr>
											<td class="tituloListas" colspan="2" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="LB_Salario">Salario</cf_translate>&nbsp;#rsTiposNomina.descripcion#:</td>
											<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSNumberFormat(var_salarioTipoNomina,',9.00')#</td>
										  </tr>
															  
								  </cfif>
							  </cfif>

						  
						  
						  
						  <tr>
							<td class="tituloListas" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Componente">Componente</cf_translate></td>
							<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Unidad">Unidades</cf_translate></td>
							<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="MontoBase">Monto Base</cf_translate></td>
							<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Monto">Monto</cf_translate></td>
						  </tr>
					  <cfloop query="rsDetalleAccion">
						  <cfif Len(Trim(rsDetalleAccion.CIid))>
							<cfset color = ' style="color: ##FF0000;"'>
						  <cfelse>
							<cfset color = ''>
						  </cfif>
						  <tr>
							<td class="fileLabel" height="25"#color# <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsDetalleAccion.CSdescripcion#</td>						
							<td height="25" align="right"#color# <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSNumberFormat(rsDetalleAccion.DDLunidad,',9.00')#</td>
							<td height="25" align="right"#color# <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSNumberFormat(rsDetalleAccion.DDLmontobase,',9.00')#</td>
							<td height="25" align="right"#color# <cfif not isdefined('url.imprimir')>nowrap</cfif>>
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
		  <tr <cfif RHTNoMuestraCS eq 1 >style="display:none"</cfif>>
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
					<td class="tituloListas" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Concepto">Concepto</cf_translate></td>
					<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Importe">Importe</cf_translate></td>
					<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Cantidad">Cantidad</cf_translate></td>
					<td class="tituloListas" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>><cf_translate key="Resultado">Resultado</cf_translate></td>
				  </tr>
				  <cfloop query="rsConceptosPago">
					  <tr>
						<td <cfif not isdefined('url.imprimir')>nowrap</cfif>>#rsConceptosPago.Concepto#</td>
						<td align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSCurrencyFormat(rsConceptosPago.Importe, 'none')#</td>
						<td align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSCurrencyFormat(rsConceptosPago.Cantidad, 'none')#</td>
						<td align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif>>#LSCurrencyFormat(rsConceptosPago.Resultado, 'none')#</td>
					  </tr>
				  </cfloop>
				</table>
				</td>
			  </tr>
		  </cfif>
		  <cfif isdefined('url.imprimir')>
			   <cfquery name="rsFirmas" datasource="#Session.DSN#">
					select 
					RHFid,
					RHTid,
					RHFtipo,
					RHFautorizador,
					DEid,
					CFid
					from RHFirmasAccion
					where RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.RHTid#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					order by  RHFOrden
				</cfquery>	
				<cfif rsFirmas.recordCount GT 0>
					<tr> 
						<td colspan="4" align="center">
							<table width="100%" border="0" cellspacing="0" cellpadding="2" align="center">
								<tr>
										<td  colspan="2" align="center">&nbsp;</td>		
								</tr>
								<tr>
										<td  colspan="2" align="center">&nbsp;</td>		
								</tr>
								<cfset Firma = "">
								<cfset contadorFirmas = 0>
								<cfloop query="rsFirmas">
									<cfswitch expression="#rsFirmas.RHFtipo#">
											<cfcase value="1">
												<cfif isdefined("rsFirmas.RHFautorizador") and len(trim(rsFirmas.RHFautorizador))>
													<cfset Firma = rsFirmas.RHFautorizador>	
												<cfelse>
													<cfset Firma = "">
												</cfif>	
											</cfcase>
											<cfcase value="2">
												<cfquery name="rsEmpleado" datasource="#Session.DSN#">
													select  <cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,'  ',DEapellido2"> as empleado 
													from DatosEmpleado
													where DEid =  #rsFirmas.DEid#
												</cfquery>
												<cfif isdefined("rsEmpleado.empleado") and len(trim(rsEmpleado.empleado))>
													<cfset Firma = rsEmpleado.empleado>	
												<cfelse>
													<cfset Firma = "">
												</cfif>	
											</cfcase>
											<cfcase value="3">
												<cfquery name="rsEmpleado" datasource="#Session.DSN#">
													select  <cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,'  ',DEapellido2"> as empleado 
													from DatosEmpleado
													where DEid =  #rsAccion.DEid#
												</cfquery>
												<cfif isdefined("rsEmpleado.empleado") and len(trim(rsEmpleado.empleado))>
													<cfset Firma = rsEmpleado.empleado>	
												<cfelse>
													<cfset Firma = "">
												</cfif>	
											</cfcase>
											<cfcase value="4">																					
												<cfquery name="rsEmpleado" datasource="#Session.DSN#">
													select 1 
													from LineaTiempo a, 
														 RHPlazas b, 
														 CFuncional c
													where a.DEid =  #rsAccion.DEid#
													and <cfqueryparam cfsqltype="cf_sql_date" value="#rsAccion.DLfvigencia#"> between LTdesde and LThasta
													and a.RHPid=b.RHPid
													and b.CFid=c.CFid
													and b.RHPid=c.RHPid
												</cfquery>
												
												<cfinvoke component="rh.Componentes.RH_Funciones" 
												method="DeterminaJefe"
												deid = "#rsAccion.DEid#"
												fecha = "#rsAccion.DLfvigencia#"
												returnvariable="ResponsableCF">										
												<cfif ResponsableCF.Jefe EQ rsAccion.DEid>
														<cfquery name="Jefedeljefe" datasource="#Session.DSN#">
															select CFidresp 
															from LineaTiempo a, 
																 RHPlazas b, 
																 CFuncional c
															where a.DEid =  #rsAccion.DEid#
															and <cfqueryparam cfsqltype="cf_sql_date" value="#rsAccion.DLfvigencia#"> between LTdesde and LThasta
															and a.RHPid=b.RHPid
															and b.CFid=c.CFid
														</cfquery>	
														<cfinvoke component="rh.Componentes.RH_Funciones" 
														method="DeterminaDEidResponsableCF"
														cfid = "#Jefedeljefe.CFidresp#"
														fecha = "#rsAccion.DLfvigencia#"
														returnvariable="ResponsableCF">	
												<cfelse>
														<cfinvoke component="rh.Componentes.RH_Funciones" 
														method="DeterminaDEidResponsableCF"
														cfid = "#rsAccion.CFid#"
														fecha = "#rsAccion.DLfvigencia#"
														returnvariable="ResponsableCF">												
												</cfif>												
												
												<cfquery name="rsEmpleado" datasource="#Session.DSN#">
													select  <cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,'  ',DEapellido2"> as empleado 
													from DatosEmpleado
													where DEid =  #ResponsableCF#
												</cfquery>
												<cfif isdefined("rsEmpleado.empleado") and len(trim(rsEmpleado.empleado))>
													<cfset Firma = rsEmpleado.empleado>	
												<cfelse>
													<cfset Firma = "">
												</cfif>	
											</cfcase>
											<cfcase value="5">
												<cfinvoke component="rh.Componentes.RH_Funciones" 
												method="DeterminaDEidResponsableCF"
												cfid = "#rsFirmas.CFid#"
												fecha = "#rsAccion.DLfvigencia#"
												returnvariable="ResponsableCF">
												<cfquery name="rsEmpleado" datasource="#Session.DSN#">
													select  <cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,'  ',DEapellido2"> as empleado 
													from DatosEmpleado
													where DEid =  #ResponsableCF#
												</cfquery>
												<cfif isdefined("rsEmpleado.empleado") and len(trim(rsEmpleado.empleado))>
													<cfset Firma = rsEmpleado.empleado>	
												<cfelse>
													<cfset Firma = "">
												</cfif>										
											</cfcase>
										</cfswitch>
										<cfif rsFirmas.recordCount eq 1>
											<cfif isdefined("Firma") and len(trim(Firma))>
												<tr>
													<td  width="35%" align="center">&nbsp;</td>
													<td  width="30%" align="center">
														<hr/>
													</td>
													<td width="35%" align="center">&nbsp;</td>
												</tr>
												
												<tr>
													<td  colspan="3" align="center">
														#Firma#
													</td>
												</tr>
											</cfif>
										<cfelse>
											<cfif isdefined("Firma") and len(trim(Firma))>
												<cfset contadorFirmas = contadorFirmas + 1>
												<cfif contadorFirmas mod 2 eq 1>
													<tr>
														<td width="50%" align="center">
															<table width="100%" border="0" cellspacing="0" cellpadding="2">
																<tr>
																	<td  width="25%" align="center">&nbsp;</td>
																	<td  width="50%" align="center"><hr/></td>
																	<td  width="25%" align="center">&nbsp;</td>
																</tr>
																<tr>
																	<td  colspan="3" align="center">
																		#Firma#
																	</td>
																</tr>																
															</table>
														</td>
												<cfelse>
														<td width="50%" align="center">
															<table width="100%" border="0" cellspacing="0" cellpadding="2">
																<tr>
																	<td  width="25%" align="center">&nbsp;</td>
																	<td  width="50%" align="center"><hr/></td>
																	<td  width="25%" align="center">&nbsp;</td>
																</tr>
																<tr>
																	<td  colspan="3" align="center">
																		#Firma#
																	</td>
																</tr>																
															</table>
														</td>														
													</tr>
													<tr>
														<td  colspan="2" align="center">&nbsp;</td>		
													</tr>
												</cfif>
											</cfif>
										</cfif>
								</cfloop>
							</table>
						</td>
					</tr>
				</cfif> 
				
		    </cfif> <!------>
		  <cfif not isdefined('url.imprimir')>
			  <tr> 
				<td colspan="4" align="center">
				
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="BTN_Regresar"
					default="Regresar"
					xmlfile="/rh/generales.xml"
					returnvariable="BTN_Regresar"/>
					
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="BTN_Imprimir"
					default="Imprimir"
					xmlfile="/rh/generales.xml"
					returnvariable="BTN_Imprimir"/>
				
	
					<cfif not isdefined("form.RAP")>
		                <input type="button" name="Regresar" value="#BTN_Regresar#" tabindex="1" onclick="javascript:Lista();">
					</cfif>
					<input type="button" name="imprimir" value="#BTN_Imprimir#" tabindex="1" onclick="javascript:imprimeAcciones();">
				</td>
			  </tr>
		  </cfif>
		</table>
<cfelseif RHTespecial eq  1>
		<table width="<cfif isdefined('url.imprimir')>612<cfelse>100%</cfif>" border="0" cellspacing="0" cellpadding="2" align="center">
		  <tr>
			<td align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif> class="fileLabel"><cf_translate key="TipoDeAccion">Tipo de Acci&oacute;n</cf_translate>:</td>
			<td <cfif not isdefined('url.imprimir')>nowrap</cfif>> 
				#rsAccion.RHTcodigo# - #rsAccion.RHTdesc#
			</td>
			<td align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif> class="fileLabel"><cf_translate key="FechaAplicacion">Fecha Aplicaci&oacute;n</cf_translate>:</td>
			<td <cfif not isdefined('url.imprimir')>nowrap</cfif>>
				#LSDateFormat(rsAccion.DLfechaaplic,'dd/mm/yyyy')#
			</td>
		  </tr>
		  <tr> 
			<td align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif> class="fileLabel"><cf_translate key="FechaVigencia">Fecha Vigencia</cf_translate>:</td>
			<td <cfif not isdefined('url.imprimir')>nowrap</cfif>>
				#LSDateFormat(rsAccion.DLfvigencia,'dd/mm/yyyy')#
			</td>
			<td align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif> class="fileLabel"><cf_translate key="FechaVencimiento">Fecha Vencimiento</cf_translate>:</td>
			<td <cfif not isdefined('url.imprimir')>nowrap</cfif>>
				<cfif len(trim(rsAccion.DLffin)) >#LSDateFormat(rsAccion.DLffin,'dd/mm/yyyy')#<cfelse><cf_translate key="indefinido">INDEFINIDO</cf_translate></cfif>
			</td>
		  </tr>
		  <tr> 
			<td width="10%" align="right" <cfif not isdefined('url.imprimir')>nowrap</cfif> class="fileLabel"><cf_translate key="Observaciones">Observaciones</cf_translate>:</td>
			<td colspan="3" <cfif not isdefined('url.imprimir')>nowrap</cfif>>
				#rsAccion.DLobs#
			</td>
		  </tr>
		  <tr> 
			<td colspan="4" <cfif not isdefined('url.imprimir')>nowrap</cfif>>
				<fieldset>
					<table width="100%" border="0">
							<cfif RHTcomportam eq  10>
								<tr>
									<td width="10%" align="left" <cfif not isdefined('url.imprimir')>nowrap</cfif> class="fileLabel"><cf_translate key="Fecha">Fecha</cf_translate>:</td>
									<td>#LSDateFormat(rsAccion.DLfvigencia,'dd/mm/yyyy')#</td>
								</tr>
								<tr>
									<td width="10%" align="left" <cfif not isdefined('url.imprimir')>nowrap</cfif> class="fileLabel"><cf_translate key="Tipo">Tipo</cf_translate>:</td>
									<td>#rsAccion.RHAtipo#</td>
								</tr>
								<tr>
									<td width="10%" align="left" <cfif not isdefined('url.imprimir')>nowrap</cfif> class="fileLabel"><cf_translate key="Texto">Texto</cf_translate>:</td>
									<td>#rsAccion.RHAdescripcion#</td>
								</tr>
							<cfelseif RHTcomportam eq  11>
								<tr>
									<td width="10%" align="left" <cfif not isdefined('url.imprimir')>nowrap</cfif> class="fileLabel"><cf_translate key="FechaDeAntiguedad">Fecha de Antigüedad</cf_translate>:</td>
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
					key="BTN_Regresar"
					default="Regresar"
					xmlfile="/rh/generales.xml"
					returnvariable="BTN_Regresar"/>
					
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="BTN_Imprimir"
					default="Imprimir"
					xmlfile="/rh/generales.xml"
					returnvariable="BTN_Imprimir"/>
					<cfif not isdefined("form.RAP")>
		                <input type="button" name="Regresar" value="#BTN_Regresar#" tabindex="1" onclick="javascript:Lista();">
					</cfif>
                    <input type="button" name="imprimir" value="#BTN_Imprimir#" tabindex="1" onclick="javascript:imprimeAcciones();">
				</td>
			  </tr>
		  </cfif>
		</table>
</cfif>
</cfoutput>
