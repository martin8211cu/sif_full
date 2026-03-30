<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfset Form.DEid = Url.DEid>
</cfif>
<cfif isdefined("url.FElinea") and not isdefined("form.FElinea")>
	<cfset form.FElinea = url.FElinea>
</cfif>

<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif isdefined("Form.DEid") and len(trim(form.DEid)) neq 0 and isdefined('form.FElinea') and len(trim(form.FElinea)) neq 0>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>



<cfset Lvar_Modifica = 1>

<cfif modo EQ "CAMBIO" and len(trim(form.DEid)) neq 0 and isdefined('form.FElinea') and len(trim(form.FElinea)) neq 0><!---and isdefined('form.DEid') and isdefined('form.FElinea')--->
	<cfquery datasource="#Session.DSN#" name="rsFamiliar">
		Select  fe.FElinea, DEid, fe.NTIcodigo, FEidentificacion, Pid, FEnombre, 
		        FEapellido1, FEapellido2, FEfnac, FEdir, FEdiscapacitado, FEfinidiscap, 
				FEffindiscap, FEasignacion, FEfiniasignacion,
				FEffinasignacion, FEestudia, FEsexo, FEfiniestudio, 
				FEffinestudio, FEdeducrenta, FEdeducdesde, 
				FEdeduchasta,FEidconcepto,
				FEdatos1, FEdatos2, FEdatos3, FEobs1, FEobs2, FEinfo1, FEinfo2, 
				Usucodigo, Ulocalizacion, fe.ts_rversion, fe.IDInterfaz
		from FEmpleado fe, NTipoIdentificacion nt
		where FElinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FElinea#">
			and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			and fe.NTIcodigo=nt.NTIcodigo		
	</cfquery>	
</cfif>

<cfquery name="rsRolDatosFamInterfaz" datasource="asp">
	select 1
	from UsuarioRol
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
	  and SScodigo = 'RH'
	  and SRcodigo = 'ADMAINT'
	  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
</cfquery>
<!--- VERIFICA SI HAY UNA ACCION REGISTRADA --->
<cfif isdefined('rsFamiliar')>
	<!--- VERIFICA SI LOS DATOS VIENEN DE INTERFAZ Y ADEMÁS SI TIENE EL ROL PARA MODIFICAR
		SI CUMPLE AMBAS CONDICIONES ENTONCES LA VARIABLE SE ASIGNA UN 1 --->
	<cfif rsFamiliar.IDInterfaz GT 0 and rsRolDatosFamInterfaz.RecordCount GT 0>
		<cfset Lvar_Modifica = 1>
	<cfelseif rsFamiliar.IDInterfaz GT 0 and rsRolDatosFamInterfaz.RecordCount EQ 0>
		<cfset Lvar_Modifica = 0>
	</cfif> 
</cfif>

<cfquery name="rsEtiquetasAll" datasource="#Session.DSN#">
	select RHEcol,
		   RHEtiqueta,
		   RHrequerido
	from RHEtiquetasEmpresa
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and RHdisplay = 1
	and RHEcol like 'FE%'
</cfquery>

<cfquery name="rsEtiquetasDatos" dbtype="query">
	select RHEcol,
		   RHEtiqueta,
		   RHrequerido
	from rsEtiquetasAll
	where RHEcol like 'FEdatos%'
</cfquery>

<cfquery name="rsEtiquetasObs" dbtype="query">
	select RHEcol,
		   RHEtiqueta,
		   RHrequerido
	from rsEtiquetasAll
	where RHEcol like 'FEobs%'
</cfquery>

<cfquery name="rsEtiquetasInfo" dbtype="query">
	select RHEcol,
		   RHEtiqueta,
		   RHrequerido
	from rsEtiquetasAll
	where RHEcol like 'FEinfo%'
</cfquery>

<cfquery name="rsTipoIdent" datasource="#Session.DSN#">
	select NTIcodigo,NTIdescripcion
	from NTipoIdentificacion
	order by NTIdescripcion
</cfquery>

<cfquery name="rsParentesco" datasource="#Session.DSN#">
	Select Pid,Pdescripcion
	from RHParentesco
	order by Pdescripcion
</cfquery>

<cfquery name="rsConceptosRenta" datasource="#Session.DSN#">
	select  d.CDid,CDdescripcion  
	from ImpuestoRenta a
	inner join RHParametros  b
		on b.Pcodigo=30
		and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and rtrim(ltrim(b.Pvalor)) = rtrim(ltrim(a.IRcodigo))
	inner join EImpuestoRenta c
		on a.IRcodigo = c.IRcodigo
		and getdate() between c.EIRdesde and c.EIRhasta
	inner join DConceptoDeduc d
		on c.EIRid = d.EIRid
		<!----============== Tipos de deduccion familiar ==============---->
		and d.Dfamiliar = 1
	inner join ConceptoDeduc e
		on 	d.CDid = e.CDid	
</cfquery>


<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfparam name="Form.DEid" default="#Url.DEid#">
</cfif>
<cfif isdefined("Url.sel") and not isdefined("Form.sel")>
	<cfparam name="Form.sel" default="#Url.sel#">
</cfif>

<cfset navegacionFam = "">
<cfset navegacionFam = navegacionFam & Iif(Len(Trim(navegacionFam)) NEQ 0, DE("&"), DE("")) & "o=2">

<cfif isdefined("Form.DEid")>
	<cfset navegacionFam = navegacionFam & Iif(Len(Trim(navegacionFam)) NEQ 0, DE("&"), DE("")) & "DEid=" & Form.DEid>
</cfif>
<cfif isdefined("Form.sel")>
	<cfset navegacionFam = navegacionFam & Iif(Len(Trim(navegacionFam)) NEQ 0, DE("&"), DE("")) & "sel=" & Form.sel>
</cfif> 
	
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
	<td colspan="2">
		<cfinclude template="/rh/portlets/pEmpleado.cfm">
	</td>
  </tr>
  <tr> 
	<td valign="top">
		<table width="100%" border="0" cellspacing="3" cellpadding="3">
		  <tr>
			<td>
			<cfset action = "">
			<cfif Session.Params.ModoDespliegue EQ 1>
				<cfset action = "/cfmx/rh/expediente/catalogos/expediente-cons.cfm">
			<cfelseif Session.Params.ModoDespliegue EQ 0>
				<cfset action = "/cfmx/rh/autogestion/autogestion.cfm">
			</cfif>
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Familiar"
			Default="Familiar"
			returnvariable="LB_Familiar"/>
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Parentesco"
			Default="Parentesco"
			returnvariable="LB_Parentesco"/>			 
			 
			 
			  <cfinvoke 
				 component="rh.Componentes.pListas"
				 method="pListaRH"
				 returnvariable="pListaFam">
					<cfinvokeargument name="tabla" value="FEmpleado fam, RHParentesco par"/>
					<cfinvokeargument name="columnas" value="FElinea, {fn concat({fn concat({fn concat({fn concat(FEapellido1 , ' ' )}, FEapellido2 )}, ' ' )}, FEnombre )} as nombreFam,Pdescripcion,2 as o,DEid,1 as sel"/>
					<cfinvokeargument name="desplegar" value="nombreFam,Pdescripcion"/>
					<cfinvokeargument name="etiquetas" value="#LB_Familiar#,#LB_Parentesco#"/>
					<cfinvokeargument name="formatos" value=""/>
					<cfinvokeargument name="formName" value="listaFamiliares"/>	
					<cfinvokeargument name="filtro" value="DEid=#form.DEid# and fam.Pid=par.Pid order by nombreFam"/>
					<cfinvokeargument name="align" value="left,center"/>
					<cfinvokeargument name="ajustar" value="N"/>				
					<cfinvokeargument name="irA" value="SQLfamiliares.cfm?DEid=#form.DEid#&modo=CAMBIO"/>			
					<cfinvokeargument name="navegacion" value="#navegacionFam#"/>
				</cfinvoke>			
			</td>
		  </tr>
		</table>
	</td>  
    <td> 
	  <form method="post" enctype="multipart/form-data" name="formFamiliarEmpleado" action="/cfmx/rh/expediente/catalogos/SQLfamiliares.cfm">
		  <input type="hidden" name="DEid" value="<cfoutput>#form.DEid#</cfoutput>">
		  <input type="hidden" name="FElinea" value="<cfif modo NEQ "ALTA"><cfoutput>#rsFamiliar.FElinea#</cfoutput></cfif>">
        <table width="100%" border="0" cellspacing="3" cellpadding="0">
          <tr> 
            <td colspan="2"> </td>
          </tr>
          <tr> 
            <td colspan="2" class="<cfoutput>#Session.preferences.Skin#_thcenter</cfoutput>" style="padding-left: 5px;"><cf_translate key="LB_Datos_del_Familiar">Datos del familiar</cf_translate></td>
          </tr>
          <tr> 
            <td colspan="2" class="fileLabel"><table width="100%" border="0" cellspacing="3" cellpadding="0">
                <tr> 
                  <td class="fileLabel" ><cf_translate key="LB_Nombre" xmlfile="/rh/generales.xml">Nombre</cf_translate></td>
                  <td class="fileLabel" ><cf_translate key="LB_Primer_Apellido" xmlfile="/rh/generales.xml">Primer Apellido</cf_translate></td>
                  <td class="fileLabel" ><cf_translate key="LB_Segundo_Apellido" xmlfile="/rh/generales.xml">Segundo Apellido</cf_translate></td>
                </tr>
                <tr> 
                  <td><input name="FEnombre" type="text" id="DEnombre2" size="40" maxlength="100" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsFamiliar.FEnombre#</cfoutput></cfif>"></td>
                  <td><input name="FEapellido1" type="text" id="FEapellido12" size="40" maxlength="80" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsFamiliar.FEapellido1#</cfoutput></cfif>"></td>
                  <td><input name="FEapellido2" type="text" id="FEapellido22" size="45" maxlength="80" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsFamiliar.FEapellido2#</cfoutput></cfif>"></td>
                </tr>
                <tr> 
                  <td class="fileLabel" ><cf_translate key="LB_Sexo" xmlfile="/rh/generales.xml">Sexo</cf_translate></td>
                  <td class="fileLabel" ><cf_translate key="LB_Identificacion" xmlfile="/rh/generales.xml">Identificaci&oacute;n</cf_translate></td>
                  <td class="fileLabel" ><cf_translate key="LB_Parentesco">Parentesco</cf_translate></td>
                </tr>
                <tr> 
                  <td><select name="FEsexo" id="select4">
                      <option value="M" <cfif modo NEQ 'ALTA' and rsFamiliar.FEsexo EQ 'M'> selected</cfif>><cf_translate key="LB_Masculino" xmlfile="/rh/generales.xml">Masculino</cf_translate></option>
                      <option value="F" <cfif modo NEQ 'ALTA' and rsFamiliar.FEsexo EQ 'F'> selected</cfif>><cf_translate key="LB_Femenino" xmlfile="/rh/generales.xml">Femenino</cf_translate></option>
                    </select></td>
                  <td><input name="FEidentificacion" type="text" id="FEidentificacion2"  value="<cfif modo NEQ 'ALTA'><cfoutput>#rsFamiliar.FEidentificacion#</cfoutput></cfif>"></td>
                  <td><select name="Pid" id="select">
                      <cfoutput query="rsParentesco"> 
                        <option value="#rsParentesco.Pid#" <cfif modo NEQ 'ALTA' and rsFamiliar.Pid EQ rsParentesco.Pid> selected</cfif>>#rsParentesco.Pdescripcion#</option>
                      </cfoutput> </select></td>
                </tr>
                <tr> 
                  <td class="fileLabel"><cf_translate key="LB_Direccion" xmlfile="/rh/generales.xml">Direcci&oacute;n</cf_translate></td>
                  <td class="fileLabel"><cf_translate key="LB_Fecha_de_Nacimiento">Fecha de Nacimiento</cf_translate></td>
                  <td class="fileLabel"><cf_translate key="LB_Tipo_de_Identificacion" xmlfile="/rh/generales.xml">Tipo de identificaci&oacute;n</cf_translate></td>
                </tr>
                <tr> 
                  <td rowspan="7"><textarea name="FEdir" cols="20" rows="8" id="textarea2"><cfif modo NEQ 'ALTA'><cfoutput>#rsFamiliar.FEdir#</cfoutput></cfif></textarea></td>
                  <td> <cfif modo NEQ 'ALTA'>
                      <cfset fecha = LSDateFormat(rsFamiliar.FEfnac, "DD/MM/YYYY")>
                      <cfelse>
                      <cfset fecha = LSDateFormat(Now(), "DD/MM/YYYY")>
                    </cfif> <cf_sifcalendario Conexion="#session.DSN#" form="formFamiliarEmpleado" value="#fecha#" name="FEfnac">	
                  </td>
                  <td><select name="NTIcodigo" id="select3">
                      <cfoutput query="rsTipoIdent"> 
                        <option value="#rsTipoIdent.NTIcodigo#" <cfif modo NEQ 'ALTA' and rsFamiliar.NTIcodigo EQ rsTipoIdent.NTIcodigo> selected</cfif>>#rsTipoIdent.NTIdescripcion#</option>
                      </cfoutput> </select></td>
                </tr>
                <tr> 
                  <td colspan="2" align="center" class="subTitulo"><cf_translate key="LB_Caracteristicas_del_Familiar">Caracter&iacute;sticas del familiar</cf_translate></td>
                </tr>
                <tr> 
                  <td colspan="2"><input name="ckFEdeducrenta" type="checkbox" id="ckFEdeducrenta" value="ckFEdeducrenta" onClick="javascript: ckRenta(this);" <cfif modo NEQ "ALTA" and rsFamiliar.FEdeducrenta EQ 1> checked</cfif>>
                    <cf_translate key="LB_Aplica_deduccion_renta">Aplica deducci&oacute;n renta</cf_translate> </td>
                </tr>
                <tr style="display: ;" id="verDedRenta"> 
                  <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td><cf_translate key="LB_Concepto">Concepto</cf_translate></td>
                      </tr>
                      <tr>
                        <td>
							<select name="FEidconcepto" id="FEidconcepto">
                            <cfoutput query="rsConceptosRenta"> 
                              <option value="#rsConceptosRenta.CDid#"  <cfif modo neq 'ALTA'><cfif rsFamiliar.FEidconcepto eq rsConceptosRenta.CDid >selected</cfif></cfif> >#rsConceptosRenta.CDdescripcion#</option>
                            </cfoutput> </select>						
						</td>
                      </tr>
                    </table></td>				
                  <td> <cfif modo NEQ 'ALTA'>
                      <cfset fechaDeducdesde = LSDateFormat(rsFamiliar.FEdeducdesde, "DD/MM/YYYY" )>
						  <cfif len(trim(rsFamiliar.FEdeduchasta)) gt 0 >
								<cfset fechaDeduchasta = LSDateFormat(rsFamiliar.FEdeduchasta, "DD/MM/YYYY" ) >
						  <cfelse>
						  		<cfset fechaDeduchasta = "" >
						  </cfif>	
                      <cfelse>
						  <cfset fechaDeducdesde = LSDateFormat(Now(), "DD/MM/YYYY")>
						  <cfset fechaDeduchasta = LSDateFormat(Now(), "DD/MM/YYYY")>
                    </cfif>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td width="50%" class="fileLabel"><cf_translate key="LB_Desde" xmlfile="/rh/generales.xml">Desde</cf_translate></td>
                        <td width="50%" class="fileLabel"><cf_translate key="LB_Hasta" xmlfile="/rh/generales.xml">Hasta</cf_translate></td>
                      </tr>
                      <tr> 
                        <td width="50%"> <cf_sifcalendario Conexion="#session.DSN#" form="formFamiliarEmpleado" value="#fechaDeducdesde#" name="FEdeducdesde">	
                        </td>
                        <td width="50%"> <cf_sifcalendario Conexion="#session.DSN#" form="formFamiliarEmpleado" value="#fechaDeduchasta#" name="FEdeduchasta">	
                        </td>
                      </tr>
                    </table></td>
                </tr>
                <tr> 
                  <td><input name="ckFEestudia" type="checkbox" id="ckFEestudia" value="ckFEestudia" onClick="javascript: ckEstudio(this);" <cfif modo NEQ "ALTA" and rsFamiliar.FEestudia EQ 1> checked</cfif>>
                    <cf_translate key="Estudia">Estudia</cf_translate> </td>
                  <td> <div style="display: ;" id="verEstudio"> 
                      <cfif modo NEQ 'ALTA'>
							<cfset fechaIniestudio = LSDateFormat(rsFamiliar.FEfiniestudio, "DD/MM/YYYY")>
							<cfif len(trim(rsFamiliar.FEfiniestudio)) gt 0 >
								<cfset fechaFinestudio = LSDateFormat(rsFamiliar.FEffinestudio, "DD/MM/YYYY") >
							<cfelse>
								<cfset fechaFinestudio = "" >
							</cfif>	
                       <cfelse>
							<cfset fechaIniestudio = LSDateFormat(Now(), "DD/MM/YYYY")>
							<cfset fechaFinestudio = LSDateFormat(Now(), "DD/MM/YYYY")>
                      </cfif>
                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td width="50%" class="fileLabel"><cf_translate key="Desde">Desde</cf_translate></td>
                          <td width="50%" class="fileLabel"><cf_translate key="Hasta">Hasta</cf_translate></td>
                        </tr>
                        <tr> 
                          <td width="50%"> <cf_sifcalendario Conexion="#session.DSN#" form="formFamiliarEmpleado" value="#fechaIniestudio#" name="FEfiniestudio">	
                          </td>
                          <td width="50%"> <cf_sifcalendario Conexion="#session.DSN#" form="formFamiliarEmpleado" value="#fechaFinestudio#" name="FEffinestudio">	
                          </td>
                        </tr>
                      </table>
                    </div></td>
                </tr>
                <tr> 
                  <td><input name="ckFEasignacion" type="checkbox" id="ckFEasignacion" value="ckFEasignacion" onClick="javascript: ckAsignac(this);" <cfif modo NEQ "ALTA" and rsFamiliar.FEasignacion EQ 1> checked</cfif>>
                    <cf_translate key="LB_Cobra_asignacion_familiar">Cobra asignaci&oacute;n familiar</cf_translate></td>
                  <td> <div style="display: ;" id="verAsigna"> 
                      <cfif modo NEQ 'ALTA'>
							<cfset fechaIniasignacion = LSDateFormat(rsFamiliar.FEfiniasignacion, "DD/MM/YYYY")>
							<cfif len(trim(rsFamiliar.FEffinasignacion)) gt 0 >
								<cfset fechaFinasignacion = LSDateFormat(rsFamiliar.FEffinasignacion, "DD/MM/YYYY") >
					  		<cfelse>
								<cfset fechaFinasignacion = "" >
							</cfif>	
					  <cfelse>
							<cfset fechaIniasignacion = LSDateFormat(Now(), "DD/MM/YYYY")>
							<cfset fechaFinasignacion = LSDateFormat(Now(), "DD/MM/YYYY")>
                      </cfif>
                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td width="50%" class="fileLabel"><cf_translate key="LB_Desde" xmlfile="/rh/generales.xml">Desde</cf_translate></td>
                          <td width="50%" class="fileLabel"><cf_translate key="LB_Hasta" xmlfile="/rh/generales.xml">Hasta</cf_translate></td>
                        </tr>
                        <tr> 
                          <td width="50%"> <cf_sifcalendario Conexion="#session.DSN#" form="formFamiliarEmpleado" value="#fechaIniasignacion#" name="FEfiniasignacion">	
                          </td>
                          <td width="50%"> <cf_sifcalendario Conexion="#session.DSN#" form="formFamiliarEmpleado" value="#fechaFinasignacion#" name="FEffinasignacion">	
                          </td>
                        </tr>
                      </table>
                    </div></td>
                </tr>
                <tr> 
                  <td><input name="ckFEdiscapacitado" type="checkbox" id="ckFEdiscapacitado" value="ckFEdiscapacitado"  onClick="javascript: ckDiscap(this);" <cfif modo NEQ "ALTA" and rsFamiliar.FEdiscapacitado EQ 1> checked</cfif>>
                    <cf_translate key="Discapacitado">Discapacitado</cf_translate> </td>
                  <td> <div style="display: ;" id="verDiscap"> 
						<cfif modo NEQ 'ALTA'>
							<cfset fechaInidiscap = LSDateFormat(rsFamiliar.FEfinidiscap, "DD/MM/YYYY" )>
							<cfif len(trim(rsFamiliar.FEffindiscap)) gt 0 >
								<cfset fechaFindiscap = LSDateFormat(rsFamiliar.FEffindiscap, "DD/MM/YYYY" ) >
					  		<cfelse>
								<cfset fechaFindiscap = "" >
							</cfif>	
						<cfelse>
							<cfset fechaInidiscap = LSDateFormat(Now(), "DD/MM/YYYY")>
							<cfset fechaFindiscap = LSDateFormat(Now(), "DD/MM/YYYY")>
						</cfif>
                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td width="50%" class="fileLabel"><cf_translate key="LB_Desde" xmlfile="/rh/generales.xml">Desde</cf_translate></td>
                          <td width="50%" class="fileLabel"><cf_translate key="LB_Hasta" xmlfile="/rh/generales.xml">Hasta</cf_translate></td>
                        </tr>
                        <tr> 
                          <td width="50%"> <cf_sifcalendario Conexion="#session.DSN#" form="formFamiliarEmpleado" value="#fechaInidiscap#" name="FEfinidiscap">	
                          </td>
                          <td width="50%"> <cf_sifcalendario Conexion="#session.DSN#" form="formFamiliarEmpleado" value="#fechaFindiscap#" name="FEffindiscap">	
                          </td>
                        </tr>
                      </table>
                    </div></td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="3" class="<cfoutput>#Session.preferences.Skin#_thcenter</cfoutput>" style="padding-left: 5px;"><cf_translate key="LB_Datos_variables_del_familiar">Datos variables del familiar</cf_translate></td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="3"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <cfif isdefined('rsEtiquetasAll') and rsEtiquetasAll.recordCount GT 0>
                        <cfif  isdefined('rsEtiquetasDatos')>
                          <cfset contReg = 0>
                          <cfloop query="rsEtiquetasDatos">
                            <!--- Campos Variables de Datos del empleado --->
                            <cfset contReg = contReg + 1>
                            <tr> 
                              <td width="21%" nowrap class="fileLabel"><cfoutput>#rsEtiquetasDatos.RHEtiqueta#</cfoutput>:</td>
                              <td width="79%"> 
                                <cfoutput> 
                                  <input name="FEdatos#contReg#" type="text" id="FEdatos#contReg#" value="<cfif modo NEQ 'ALTA'><cfoutput>#Evaluate("rsFamiliar.#rsEtiquetasDatos.RHEcol#")#</cfoutput></cfif>" size="30" maxlength="30">
                                </cfoutput> </td>
                            </tr>
                          </cfloop>
                        </cfif>
                        <cfif  isdefined('rsEtiquetasInfo')>
                          <cfset contReg = 0>
                          <cfloop query="rsEtiquetasInfo">
                            <!--- Campos variables de informacion del empleado --->
                            <cfset contReg = contReg + 1>
                            <tr> 
                              <td width="21%" nowrap class="fileLabel"><cfoutput>#rsEtiquetasInfo.RHEtiqueta#</cfoutput>:</td>
                              <td width="79%"> 
                                <cfoutput> 
                                  <input name="FEinfo#contReg#" type="text" id="FEinfo#contReg#" value="<cfif modo NEQ 'ALTA'><cfoutput>#Evaluate("rsFamiliar.#rsEtiquetasInfo.RHEcol#")#</cfoutput></cfif>" size="60" maxlength="100">
                                </cfoutput> </td>
                            </tr>
                          </cfloop>
                        </cfif>
                        <cfif  isdefined('rsEtiquetasObs')>
                          <cfset contReg = 0>
                          <cfloop query="rsEtiquetasObs">
                            <!--- Campos variables de observaciones --->
                            <cfset contReg = contReg + 1>
                            <tr> 
                              <td width="21%" nowrap class="fileLabel"><cfoutput>#rsEtiquetasObs.RHEtiqueta#</cfoutput>:</td>
                              <td width="79%"> 
                                <cfoutput> 
                                  <input name="FEobs#contReg#" type="text" id="FEobs#contReg#" value="<cfif modo NEQ 'ALTA'><cfoutput>#Evaluate("rsFamiliar.#rsEtiquetasObs.RHEcol#")#</cfoutput></cfif>" size="60" maxlength="255">
                                </cfoutput> </td>
                            </tr>
                          </cfloop>
                        </cfif>
                      </cfif>
                    </table></td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
              </table>
			  </td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          
		  <tr> 
			<td colspan="2" align="center">
			  <cfset exclude = "">
			  <cfif modo neq  "ALTA" and Lvar_Modifica EQ 0>
				<cfset exclude = "CAMBIO,BAJA">
			  <cfelseif modo neq  "ALTA" and Lvar_Modifica EQ 1>
			  	<cfset exclude = "BAJA">
			  </cfif>
			  <cfif isdefined('form.EstoyEnGestion') and form.EstoyEnGestion EQ 'S'>
			  	<cfif isdefined('rsModificaDE') and rsModificaDE.RecordCount GT 0 and rsModificaDE.Pvalor EQ 1>
				  <cf_botones modo="#modo#" exclude="#exclude#">
				 </cfif>
			  <cfelse>
				  <cf_botones modo="#modo#" exclude="#exclude#">
			  </cfif>
			</td>
		  </tr>
		  
		  <cfif modo neq  "ALTA" and Lvar_Modifica EQ 0>
			<tr><td colspan="2" align="center">*
				<cf_translate key="MSG_RegistroNoSePuedeModificar">
				Este registro no se puede modificar debido a <br>
				que se gener&oacute; en otra aplicaci&oacute;n y el usuario no est&aacute; autorizado
				</cf_translate>.
			</td></tr>
		  </cfif>
		  
        </table>
		</form>	
	</td>
  </tr>
</table>
  
<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/calendar.js">//</script>
<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js">//</script>
<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js">//</script>
<script language="JavaScript" type="text/javascript">

	arrNombreObjs = new Array();
	arrNombreEtiquetas = new Array();	
	
	//Objetos de los datos variables del empleado
	var cont = 0;
	<cfloop query="rsEtiquetasDatos">	
		cont++;	
		<cfif rsEtiquetasDatos.RHrequerido EQ 1>
			arrNombreObjs[arrNombreObjs.length] = 'FEdatos' + cont;
			arrNombreEtiquetas[arrNombreEtiquetas.length] = '<cfoutput>#rsEtiquetasDatos.RHEtiqueta#</cfoutput>';
		</cfif>
	</cfloop>
	var cont = 0;
	<cfloop query="rsEtiquetasObs">	
		cont++;
		<cfif rsEtiquetasObs.RHrequerido EQ 1>
			arrNombreObjs[arrNombreObjs.length] = 'FEobs' + cont;						
			arrNombreEtiquetas[arrNombreEtiquetas.length] = '<cfoutput>#rsEtiquetasObs.RHEtiqueta#</cfoutput>';		
		</cfif>
	</cfloop>
	var cont = 0;
	<cfloop query="rsEtiquetasInfo">	
		cont++;
		<cfif rsEtiquetasInfo.RHrequerido EQ 1>
			arrNombreObjs[arrNombreObjs.length] = 'FEinfo' + cont;				
			arrNombreEtiquetas[arrNombreEtiquetas.length] = '<cfoutput>#rsEtiquetasInfo.RHEtiqueta#</cfoutput>';		
		</cfif>
	</cfloop>	

 	function ckRenta(obj){
		var connDedRenta = document.getElementById('verDedRenta');
		
		if(obj.checked){
			connDedRenta.style.display = "";			
		}else{
			connDedRenta.style.display = "none";				
		}
	}

 	function ckAsignac(obj){
		var connVerAsigna = document.getElementById('verAsigna');
		
		if(obj.checked){
			connVerAsigna.style.display = "";			
		}else{
			connVerAsigna.style.display = "none";				
		}
	}

 	function ckDiscap(obj){
		var connVerDiscap = document.getElementById('verDiscap');
		
		if(obj.checked){
			connVerDiscap.style.display = "";			
		}else{
			connVerDiscap.style.display = "none";				
		}
	}

 	function ckEstudio(obj){
		var connVerEstudio = document.getElementById('verEstudio');
		
		if(obj.checked){
			connVerEstudio.style.display = "";			
		}else{
			connVerEstudio.style.display = "none";				
		}
	}	

	function deshabilitarValidacion(){
		objForm.NTIcodigo.required = false;
		objForm.Pid.required = false;
		objForm.FEnombre.required = false;
		objForm.FEfnac.required = false;
		objForm.FEsexo.required = false;
			
		//Validacion de los datos variables por empresa		
		for(var i=0;i<arrNombreObjs.length;i++)
			eval("objForm." + arrNombreObjs[i] + ".required = false;");
	}

	function habilitarValidacion(){
		objForm.NTIcodigo.required = true;
		objForm.Pid.required = true;
		objForm.FEnombre.required = true;
		objForm.FEfnac.required = true;
		objForm.FEsexo.required = true;
		
		//Validacion de los datos variables por empresa
		for(var i=0;i<arrNombreObjs.length;i++)
			eval("objForm." + arrNombreObjs[i] + ".required = true;");		
	}

/* Esta funcion toma 2 fechas en formato dia/mes/año y compara la fecha1(primer parametro) con la fecha2(segundo parametro)
		de cinco formas diferentes, en donde el tercer parametro (opc) va a tener 5 valores diferentes 
		si opc = 1
			verifica si la fecha1 es = a la fecha2
		si opc = 2
			verifica si la fecha1 es > a la fecha2
		si opc = 3
			verifica si la fecha1 es < a la fecha2
		si opc = 4
			verifica si la fecha1 es >= a la fecha2
		si opc = 5
			verifica si la fecha1 es <= a la fecha2		*/
		
	function comparaFechas(fecha1,fecha2,opc){
		var res = false;
		var tempFecha1 = fecha1.split('/');
		var tempFecha2 = fecha2.split('/');		

		//Validando que las fechas sean correctas
		if(validaFecha(fecha1) && validaFecha(fecha2)){
			if(opc == 1 || opc == 2 || opc == 3 || opc == 4 || opc == 5){
				tempFecha1[1] = new Number(tempFecha1[1]);
				tempFecha2[1] = new Number(tempFecha2[1]);
				/*
				tempFecha1[1] = (tempFecha1[1] != 0 ) ? tempFecha1[1]-1 : 0 ;
				tempFecha2[1] = (tempFecha2[1] != 0 ) ? tempFecha2[1]-1 : 0 ;
				*/
				var vFecha1 = new Date(tempFecha1[2],tempFecha1[1],tempFecha1[0]);
				var vFecha2 = new Date(tempFecha2[2],tempFecha2[1],tempFecha2[0]);		

				var anio1 = vFecha1.getFullYear();
				var mes1 = vFecha1.getMonth();
				var dia1 = vFecha1.getDate();
				var anio2 = vFecha2.getFullYear();
				var mes2 = vFecha2.getMonth();
				var dia2 = vFecha2.getDate();
				
				
				tempFecha1[0] = new Number(tempFecha1[0]);
				tempFecha1[1] = new Number(tempFecha1[1]);
				tempFecha1[2] = new Number(tempFecha1[2]);
				
				tempFecha2[0] = new Number(tempFecha2[0]);
				tempFecha2[1] = new Number(tempFecha2[1]);
				tempFecha2[2] = new Number(tempFecha2[2]);
				
				
				tempFecha1[0] =  tempFecha1[0] * 1;
				tempFecha1[1] =  tempFecha1[1] * 100;
				tempFecha1[2] =  tempFecha1[2] * 10000;
				
				
				tempFecha2[0] =  tempFecha2[0] * 1;
				tempFecha2[1] =  tempFecha2[1] * 100;
				tempFecha2[2] =  tempFecha2[2] * 10000;

				var vFecha1n =  tempFecha1[2] + tempFecha1[1] + tempFecha1[0] ;
				var vFecha2n =  tempFecha2[2] + tempFecha2[1] + tempFecha2[0] ;

				switch(opc){
					case 1: {	//compara las fechas (fecha1 = fecha2)
						if(eval(anio1 == anio2) &&	eval(mes1 == mes2) &&  (dia1 == dia2)){
							res = true;
						}else{
							res = false;
						}
					}
					break;
					case 2: {	//compara las fechas (fecha1 > fecha2) -- if(vFecha1 > vFecha2){
						if(anio1 > anio2){
							res = true;
						}else{
							if(anio1 == anio2){
								if(mes1 > mes2){
									res = true;
								}else{
									if(mes1 == mes2){
										if(dia1 > dia2){
											res = true
										}else{
											res = false;
										}
									}else{
										res = false;
									}
								}
							}else{
								res = false;
							}
						}					
					}
					break;					
					case 3: {	//compara las fechas (fecha1 < fecha2)
						if(anio1 < anio2){
							res = true;
						}else{
							if(anio1 == anio2){
								if(mes1 < mes2){
									res = true;
								}else{
									if(mes1 == mes2){
										if(dia1 < dia2){
											res = true
										}else{
											res = false;
										}
									}else{
										res = false;
									}
								}
							}else{
								res = false;
							}
						}					
					}
					break;					
					case 4: {	//compara las fechas (fecha1 >= fecha2)
						if(anio1 >= anio2){
							if(mes1 >= mes2){
								if(dia1 >= dia2){
									res = true
								}else{
									res = false;
								}
							}else{
								res = false;							
							}
						}else{
							res = false;
						}					
					}
					break;
					case 5: {	//compara las fechas (fecha1 <= fecha2)
						/*if(anio1 <= anio2){
							if(mes1 <= mes2){
								if(dia1 <= dia2){
									res = true
								}else{
									res = false;
								}
							}else{
								res = false;							
							}
						}else{
							res = false;
						}*/					
						if(vFecha2n < vFecha1n){
						 alert(vFecha2n < vFecha1n)
						 res = false;
						}
						else{
						res = true;
						}
						
					}
					break;										
				}
			}else{
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_ElTercerParametroDeComparaFechasEsInvalidoRangoValidoDe15"
				Default="el tercer parametro de comparaFechas es inválido (rango válido de 1 - 5)"
				returnvariable="LB_ElTercerParametroDeComparaFechasEsInvalidoRangoValidoDe15"/>
			
				alert('<cfoutput>#LB_ElTercerParametroDeComparaFechasEsInvalidoRangoValidoDe15#</cfoutput>');
			}
		}
		return res;
	}	
	
	function validaFecha(f){
		if (f != "") {
			var partes = f.split ("/");
			var ano = 0, mes = 0; dia = 0;
			if (partes.length == 3) {
				ano = parseInt(partes[2], 10);
				mes = parseInt(partes[1], 10);
				dia = parseInt(partes[0], 10);
			} else if (partes.length == 2) {
				var hoy = new Date;
				ano = hoy.getFullYear();
				mes = parseInt(partes[1], 10);
				dia = parseInt(partes[0], 10); 
			} else {
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_LaFechaIndicadaEsInvalidaUtiliceElFormatoddmmyyyy"
				Default="La fecha indicada es inválida. Utilice el formato (dd/mm/yyyy)"
				returnvariable="LB_LaFechaIndicadaEsInvalidaUtiliceElFormatoddmmyyyy"/>			
			
				alert("<cfoutput>#LB_LaFechaIndicadaEsInvalidaUtiliceElFormatoddmmyyyy#</cfoutput>");
				return false;
			}
			if (ano < 100) {
				ano += (ano < 50 ? 2000 : 1900);
			} else if (ano >= 100 && ano < 1900) {
				alert("El año debe ser mayor o igual a 1900");
				return false;
			}
			var d = new Date(ano, mes - 1, dia);
			if (!(d.getFullYear() == ano) && (d.getMonth()    == mes-1) && (d.getDate()     == dia)){
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_LaFechaIndicadaEsInvalidaUtiliceElFormatoddmmyyyy"
				Default="La fecha indicada es inválida. Utilice el formato (dd/mm/yyyy)"
				returnvariable="LB_LaFechaIndicadaEsInvalidaUtiliceElFormatoddmmyyyy"/>			
			
				alert("<cfoutput>#LB_LaFechaIndicadaEsInvalidaUtiliceElFormatoddmmyyyy#</cfoutput>");

				return false;
			}
		}
		return true;	
	}	

	function __isRangoFechas(opc) {
		if (btnSelected("Alta",this.obj.form)||btnSelected("Cambio",this.obj.form)) {

			switch(opc){
				case 1:{	//	Para deduccion Renta
					if (trim(this.obj.form.FEdeducdesde.value) != ''){
						if (trim(this.obj.form.FEdeduchasta.value) != ''){
							if(!comparaFechas(this.obj.form.FEdeducdesde.value,this.obj.form.FEdeduchasta.value,5)){
								
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="MSG_ErrorLaFechaDesdeDebeSerMenorOIgualQueLaFechaHastaParaAPLICADEDUCCIONRENTA"
								Default="Error, la fecha desde debe ser menor o igual que la fecha hasta para APLICA DEDUCCION RENTA"
								returnvariable="MSG_ErrorLaFechaDesdeDebeSerMenorOIgualQueLaFechaHastaParaAPLICADEDUCCIONRENTA"/>	
								
								this.error = "<cfoutput>#MSG_ErrorLaFechaDesdeDebeSerMenorOIgualQueLaFechaHastaParaAPLICADEDUCCIONRENTA#</cfoutput>";
								this.obj.form.FEdeducdesde.focus();					
							}
						}
					}
					else{
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_LaFechaDesdeParaDeduccionRentaEsRequerida"
						Default="La fecha desde para Deducción Renta es requerida"
						returnvariable="MSG_LaFechaDesdeParaDeduccionRentaEsRequerida"/>					
					
						this.error = "<cfoutput>#MSG_LaFechaDesdeParaDeduccionRentaEsRequerida#</cfoutput>";
						this.obj.form.FEdeducdesde.focus();					
					}	
				}
				break;
				case 2:{	//	Para Estudia
					if (trim(this.obj.form.FEfiniestudio.value) != ''){
						if (trim(this.obj.form.FEffinestudio.value) != ''){
							if(!comparaFechas(this.obj.form.FEfiniestudio.value,this.obj.form.FEffinestudio.value,5)){
								
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="MSG_ErrorLaFechaDesdeDebeSerMenorOIgualQueLaFechaHastaParaESTUDIA"
								Default="Error, la fecha desde debe ser menor o igual que la fecha hasta para ESTUDIA"
								returnvariable="MSG_ErrorLaFechaDesdeDebeSerMenorOIgualQueLaFechaHastaParaESTUDIA"/>
								
								this.error = "<cfoutput>#MSG_ErrorLaFechaDesdeDebeSerMenorOIgualQueLaFechaHastaParaESTUDIA#</cfoutput>";
								this.obj.form.FEfiniestudio.focus();					
							}
						}
					}
					else{
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_LaFechaDesdeParaEstudiaEsRequerida"
						Default="La fecha desde para Estudia es requerida"
						returnvariable="MSG_LaFechaDesdeParaEstudiaEsRequerida"/>

						this.error = "<cfoutput>#MSG_LaFechaDesdeParaEstudiaEsRequerida#</cfoutput>";
						this.obj.form.FEfiniestudio.focus();					
					}	
				}
				break;
				case 3:{	// Para asignacion familiar
					if (trim(this.obj.form.FEfiniasignacion.value) != ''){
						if (trim(this.obj.form.FEffinasignacion.value) != ''){
							if(!comparaFechas(this.obj.form.FEfiniasignacion.value,this.obj.form.FEffinasignacion.value,5)){
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="MSG_ErrorLaFechaDesdeDebeSerMenorOIgualQueLaFechaHastaParaASIGNACIONFAMILIAR"
								Default="Error, la fecha desde debe ser menor o igual que la fecha hasta para ASIGNACION FAMILIAR"
								returnvariable="MSG_ErrorLaFechaDesdeDebeSerMenorOIgualQueLaFechaHastaParaASIGNACIONFAMILIAR"/>
										
								
								this.error = "<cfoutput>#MSG_ErrorLaFechaDesdeDebeSerMenorOIgualQueLaFechaHastaParaASIGNACIONFAMILIAR#</cfoutput>";
								this.obj.form.FEfiniasignacion.focus();					
							}			
						}
					}
					else{
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_LaFechaDesdeParaAsignacionFamiliarEsRequerida"
						Default="Error, la fecha desde debe ser menor o igual que la fecha hasta para ASIGNACION FAMILIAR"
						returnvariable="MSG_LaFechaDesdeParaAsignacionFamiliarEsRequerida"/>
						
						this.error = "<cfoutput>#MSG_LaFechaDesdeParaAsignacionFamiliarEsRequerida#</cfoutput>";
						this.obj.form.FEfiniasignacion.focus();					
					}	
				}
				break;
				case 4:{	//	Para Discapacitado
					if (trim(this.obj.form.FEfinidiscap.value) != ''){
						if (trim(this.obj.form.FEffindiscap.value) != ''){
							if(!comparaFechas(this.obj.form.FEfinidiscap.value,this.obj.form.FEffindiscap.value,5)){
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="MSG_ErrorLaFechaDesdeDebeSerMenorOIgualQueLaFechaHastaParaDISCAPACITADO"
								Default="Error, la fecha desde debe ser menor o igual que la fecha hasta para DISCAPACITADO"
								returnvariable="MSG_ErrorLaFechaDesdeDebeSerMenorOIgualQueLaFechaHastaParaDISCAPACITADO"/>
								
								
								this.error = "<cfoutput>#MSG_ErrorLaFechaDesdeDebeSerMenorOIgualQueLaFechaHastaParaDISCAPACITADO#</cfoutput>";
								this.obj.form.FEfinidiscap.focus();					
							}
						}
					}
					else{
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_LaFechaDesdeParaDiscapacitadoEsRequerida"
						Default="La fecha desde para Discapacitado es requerida"
						returnvariable="MSG_LaFechaDesdeParaDiscapacitadoEsRequerida"/>
						
						this.error = "<cfoutput>#MSG_LaFechaDesdeParaDiscapacitadoEsRequerida#</cfoutput>";
					
						this.obj.form.FEfinidiscap.focus();					
					}	
				}
				break;
			}
		}
	}	

	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");			

	qFormAPI.errorColor = "#FFFFCC";
	_addValidator("isRangoFechas", __isRangoFechas);
	objForm = new qForm("formFamiliarEmpleado");
	

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Tipo_de_Identificacion"
	Default="Tipo de Identificación"
	xmlfile="/rh/generales.xml" 
	returnvariable="MSG_TipoDeIdentificacion"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Parentesco"
	Default="Parentesco"
	returnvariable="MSG_parentezco"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nombre"
	Default="Nombre"
	xmlfile="/rh/generales.xml" 
	returnvariable="MSG_Nombre"/>	
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Fecha_de_Nacimiento"
	Default="Fecha de Nacimiento"
	returnvariable="MSG_FechaDeNacimieto"/>	

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Sexo"
	Default="Sexo"
	xmlfile="/rh/generales.xml" 
	returnvariable="MSG_Sexo"/>	


	objForm.NTIcodigo.required = true;
	objForm.NTIcodigo.description = "<cfoutput>#MSG_TipoDeIdentificacion#</cfoutput>";	
	objForm.Pid.required = true;
	objForm.Pid.description = "<cfoutput>#MSG_parentezco#</cfoutput>";
	objForm.FEnombre.required = true;
	objForm.FEnombre.description = "<cfoutput>#MSG_Nombre#</cfoutput>";	
	objForm.FEfnac.required = true;
	objForm.FEfnac.description = "<cfoutput>#MSG_FechaDeNacimieto#</cfoutput>";				
	objForm.FEsexo.required = true;
	objForm.FEsexo.description = "<cfoutput>#MSG_Sexo#</cfoutput>";
	
	//Validacion de los datos variables por empresa
	for(var i=0;i<arrNombreObjs.length;i++){
		eval("objForm." + arrNombreObjs[i] + ".required = true;");
		eval("objForm." + arrNombreObjs[i] + ".description = '" + arrNombreEtiquetas[i] + "';");		
	}	
	
	ckRenta(document.formFamiliarEmpleado.ckFEdeducrenta);	
	ckAsignac(document.formFamiliarEmpleado.ckFEasignacion);
	ckDiscap(document.formFamiliarEmpleado.ckFEdiscapacitado);				
	ckEstudio(document.formFamiliarEmpleado.ckFEestudia);
	
	objForm.ckFEdeducrenta.validateRangoFechas(1);
	objForm.ckFEestudia.validateRangoFechas(2);	
	objForm.ckFEasignacion.validateRangoFechas(3);	
	objForm.ckFEdiscapacitado.validateRangoFechas(4);	
</script>