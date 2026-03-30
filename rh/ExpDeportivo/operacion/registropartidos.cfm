<!---<cf_dump var="#form#">--->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	//carga el mantenimiento del detalle
	function fnCargaDetalle(EDPrid, Equipo){
		objForm.EDPrid.obj.value = EDPrid;
		objForm.Equipo.obj.value = Equipo;
		document.form1.submit();
	}	
	
		function fnSubmit(EDPid, Equipo){
		objForm.EDPid.obj.value = EDPid;
		objForm.Equipo.obj.value = Equipo;
		document.form1.submit();
	}	
	//-->
</script>


<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Estadisticas"
Default="Estadisticas del Partido"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="LB_Estadisticas"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_RegistrodePartidos"
Default="Registro de Partidos"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="LB_RegistrodePartidos"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Jugadores"
Default="Jugadores"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="LB_Jugadores"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="CMB_Seleccionar"
Default="Seleccionar"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="CMB_Seleccionar"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="BTN_Agregar"
Default="Agregar Estadisticas"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="BTN_Agregar"/>

<!--- Consultas --->
<cfif modo neq 'ALTA'>
	<!--- Form --->
	 <cfquery name="rsForm" datasource="#session.DSN#">
		select EDPrid, EDPfecha, EDPequipo2, EDvid, ts_rversion, EDPtipo, EDPestadio
		from EDPartidos
		where EDPrid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDPrid#">
	</cfquery>
</cfif>

	
	<cfoutput>
	<cf_templateheader title="#LB_RegistrodePartidos#">
		<cf_web_portlet_start border="true" titulo="#LB_RegistrodePartidos#"> 
		<table width="100%" cellpadding="1" cellspacing="0">
			<tr>
				<td valign="top"> 	
					
					<form name="form1" id="form1" method="post" action="registropartidos-sql.cfm" onSubmit="return validar(this);">
						<table width="75%" align="center" cellpadding="2">
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td align="right"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_FechadePartido">Fecha de 	 						 								Partido</cf_translate>:</strong></td>
								
								<td><cfif modo eq "CAMBIO">
										<cf_sifcalendario form="form1" name="EDPfecha" value=		 					 						 										"#LSDateFormat(rsForm.EDPfecha,'DD/MM/YYYY')#">
									<cfelse>
										<cf_sifcalendario name="EDPfecha">
									</cfif></td>
							</tr>
							<tr>
								<td align="right" width="35%"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_EquipoDivision1">								 								Equipo Divisi&oacute;n 1</cf_translate>:</strong></td>
								<td> <cf_equipodivision> </td>
							<tr>
								<td align="right" width="35%"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_EquipoDivision2">		 								Equipo Divisi&oacute;n 2</cf_translate>:</strong></td>
								<td nowrap>
								<cf_equipodivision2></td> 
							</tr>	
							<tr>  
								<td align="right" width="35%"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_TipodePartido">		 								Tipo de Partido</cf_translate>:</strong></td>
								<td nowrap> 
								<select name="EDPtipo" id="EDPtipo">
								<option value ="">#CMB_Seleccionar#</option>
								<option value="0" <cfif modo NEQ 'ALTA' and rsForm.EDPtipo EQ 0> selected</cfif>><cf_translate key="LB_Amistoso">Amistoso</cf_translate></option>
					  			<option value="1" <cfif modo NEQ 'ALTA' and rsForm.EDPtipo EQ 1> selected</cfif>><cf_translate key="LB_Fogeo">Fogeo</cf_translate></option>
								<option value="2" <cfif modo NEQ 'ALTA' and rsForm.EDPtipo EQ 2> selected</cfif>><cf_translate key="LB_Colectivo">Colectivo</cf_translate></option>
								<option value="3" <cfif modo NEQ 'ALTA' and rsForm.EDPtipo EQ 3> selected</cfif>><cf_translate key="LB_Oficial">Oficial</cf_translate></option>
								</select>
					</td>
			<tr>  
					<td align="right" width="35%"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Estadio">		 								Estadio</cf_translate>:</strong></td>
					<td><input name="EDPestadio" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsForm.EDPestadio#</cfif>" size="30" maxlength="60"></td>
			</tr>
			<tr>
			<td align="right" width="35%"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_ArbitroCentral">		 								&Aacute;rbitro Central</cf_translate>:</strong></td>
			<td><cf_EDParbitroc> </td>
			</tr>
			<tr>
			<td align="right" width="35%"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_ArbitroLinea1">		 								&Aacute;rbitro L&iacute;nea 1</cf_translate>:</strong></td>
			<td><cf_EDPalinea1></td>
			
			</tr>
			<tr>
			<td align="right" width="35%"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_ArbitroLinea2">		 								&Aacute;rbitro L&iacute;nea 2</cf_translate>:</strong></td>
			<td><cf_EDPalinea2></td>
			</tr>
			<tr>
			<td align="right" width="35%"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_CuartoArbitro">		 								Cuarto &Aacute;rbitro</cf_translate>:</strong></td>
			<td><cf_EDPcarbitro></td>
			<td>&nbsp;</td>
			
			</tr>
				
					<cfset ts = "">	
		<cfif modo neq "ALTA">
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
		</cfif>
		<tr><td><input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>"></td></tr>
				<input type="hidden" name="Equipo" value="" />
		<input type="hidden" name="EDPrid" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.EDPrid#</cfoutput></cfif>">

						<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center">
				<cfset tabindex="1">
				<cfinclude template="/rh/portlets/pBotones.cfm">
			</td>
		</tr>
		</table></td></tr>
	
									
							
						<cfif modo neq 'ALTA'> 
				<cfquery name="rsLista" datasource="#session.DSN#">
				select {fn concat({fn concat(e1.Edescripcion, '-')}, de1.TEdescripcion)}  as Equipo1, {fn concat({fn 					                concat(e2.Edescripcion, '-')}, de2.TEdescripcion)} as Equipo2, edp.EDPfecha, edp.EDPrid
				from EDPartidos edp

				inner join EquipoDivision ed1
					inner join DivisionEquipo de1
					on de1.TEid=ed1.TEid
					inner join Equipo e1
					on e1.EDid=ed1.EDid
				on ed1.EDvid=edp.EDvid

				inner join EquipoDivision ed2	
					inner join DivisionEquipo de2
					on de2.TEid=ed2.TEid
					inner join Equipo e2
					on e2.EDid=ed2.EDid
				on ed2.EDvid=edp.EDPequipo2 
				
			where EDPrid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDPrid#">					
			</cfquery>
		<tr><td colspan="5">&nbsp;</td></tr>
		<tr align="center"> 
			<td colspan="5">
							<fieldset><legend><cf_translate key="LB_Alineacion">Alineaci&oacute;n</cf_translate></legend>
								<table width="100%" border="0" cellspacing="0" cellpadding="0"align="center">
									<tr bgcolor="FAFAFA"> 
									  <td colspan="2" align="left"><a href="javascript: fnCargaDetalle('#EDPrid#', '#EDvid#');">
				  <cfif isdefined('form.Equipo') and len(trim(form.Equipo)) and form.Equipo eq rsForm.EDvid><strong>#rsLista.Equipo1#</strong><cfelse>#rsLista.Equipo1#</cfif></a></td>
										<td width="7%" align="center">VS.</td>
				<td width="43%" colspan="2" align="right"><a href="javascript: fnCargaDetalle('#EDPrid#', '#EDPequipo2#');">
				  <cfif isdefined('form.Equipo') and len(trim(form.Equipo)) and form.Equipo eq rsForm.EDPequipo2><strong>#rsLista.Equipo2#</strong><cfelse>#rsLista.Equipo2#</cfif></a></td>  
				
									</tr>
									<cfif isdefined('form.Equipo') and len(trim(form.Equipo))>
				<tr><td>&nbsp;</td></tr>
				<tr bgcolor="FAFAFA" align="center"><td><strong>#LB_Jugadores#</strong></td></tr>
				<cfquery name="rsEquipoPer" datasource="#session.DSN#">
				select {fn concat({fn concat({fn concat({fn concat(a.DEapellido1, ' ')}, a.DEapellido2)}, ', ')}, a.DEnombre) } as Persona, b.DEid, b.EDPid, {fn concat({fn concat(c.Edescripcion, '-')}, e.TEdescripcion)}  as Equipo
				from EDPersonas a
				inner join EquipoDivPersona b on
				a.DEid = b.DEid
				inner join EquipoDivision d on
				b.EDvid = d.EDvid
				inner join Equipo c on
				d.EDid = c.EDid
				inner join DivisionEquipo e on
				d.TEid = e.TEid
				where 1=1 and
				 b.EDvid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Equipo#"> 
							
			</cfquery>
			<cfloop query="rsEquipoPer">
									<tr>
										<td width="25%" valign="top" <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>										<input type="hidden" name="EDPid" value="">
										<a href="javascript: fnSubmit('#EDPid#', '#form.Equipo#');">#rsEquipoPer.Persona#</a>	
									  </td></cfloop><td colspan="4"><cfinclude template="registropartidos-form.cfm"></td>
									  </tr>

								  </cfif>
										
						  </fieldset> </table></td></tr>
	</cfif> </cfoutput>
	</table></td></tr>
	</form>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Equipo1"
	Default="Equipo 1"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Equipo1"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Equipo2"
	Default="Equipo 2"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Equipo2"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Fecha"
	Default="Fecha"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Fecha"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_TipodePartido"
	Default="Tipo de Partido"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_TipodePartido"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Estadio"
	Default="Estadio"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Estadio"/>
	
	<script language="JavaScript1.2" type="text/javascript">
	
	<cfif isdefined('rsPersona.EDPrid')>
		document.form1.EDvid.focus();
	<cfelse>
		document.form1.EDvid2.focus();
	</cfif>

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	<cfoutput>
		objForm.EDvid.required = true;
		objForm.EDvid.description="#MSG_Equipo1#";
		objForm.EDvid2.required = true;
		objForm.EDvid2.description="#MSG_Equipo2#";
		objForm.EDPfecha.required = true;
		objForm.EDPfecha.description="#MSG_Fecha#";
		objForm.EDPtipo.required = true;
		objForm.EDPtipo.description="#MSG_TipodePartido#";
		objForm.EDPestadio.required = true;
		objForm.EDPestadio.description="#MSG_Estadio#";
	</cfoutput>

</script>
	<cf_web_portlet_end> 	
		
			
	<cf_templatefooter>


					
	
	
	
	
							
