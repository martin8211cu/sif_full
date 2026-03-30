<cfsetting requesttimeout="86400">
<!---<cfif isdefined("Url.Pagina") and not isdefined("Form.Pagina")>
	<cfset Form.Pagina = Url.Pagina >
</cfif>
--->

<cfif isdefined("Url.CPid") and not isdefined("Form.CPid")>
	<cfparam name="Form.CPid" default="#Url.CPid#">
</cfif>
<cfif isdefined("Url.nombreFiltro") and not isdefined("Form.nombreFiltro")>
	<cfparam name="Form.nombreFiltro" default="#Url.nombreFiltro#">
</cfif>
<cfif isdefined("Url.DEidentificacionFiltro") and not isdefined("Form.DEidentificacionFiltro")>
	<cfparam name="Form.DEidentificacionFiltro" default="#Url.DEidentificacionFiltro#">
</cfif>		

<cfset filtro = "">
<cfset navegacion = "" >
<cfif isdefined("Form.CPid")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CPid=" & form.CPid>
</cfif>

<cfif isdefined("Form.nombreFiltro") and Len(Trim(Form.nombreFiltro)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "nombreFiltro=" & Form.nombreFiltro>
</cfif>
<cfif isdefined("Form.DEidentificacionFiltro") and Len(Trim(Form.DEidentificacionFiltro)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEidentificacionFiltro=" & Form.DEidentificacionFiltro>
</cfif>

<cfset modo = 'ALTA'>
<cfif isdefined("form.RHCDid") and len(trim(form.RHCDid))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery name="rsForm" datasource="#session.DSN#">
		select 	a.CPid, 
				a.DEid, 
				{fn concat({fn concat({fn concat({ fn concat(c.DEnombre, ' ') },c.DEapellido1)}, ' ')},c.DEapellido2) } as NombreEmp, 
				a.RHCMmontobase, 
				b.CIid, 
				b.CIcodigo,
				b.RHCMmontocomision,
				b.RHCDid
		from RHComisionMonge a
		
		inner join RHComisionMongeD b
		on a.CPid=b.CPid
		and a.DEid=b.DEid
		and RHCDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCDid#">
		
		inner join DatosEmpleado c
		on a.DEid=c.DEid
		
		inner join CIncidentes d
		on b.CIid=d.CIid
		
		where a.CPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
		  and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	</cfquery>
	
	<!---<cfif len(trim(rsForm.CFid))>
		<cfquery name="rsCFuncional" datasource="#session.DSN#">
			select CFid, CFcodigo, CFdescripcion
			from CFuncional
			where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CFid#">
		</cfquery>
	</cfif>--->

</cfif>

<!----================= TRADUCCION =================---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Empleado"
	Default="Empleado"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Empleado"/>	

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ConceptoDeComision"
	Default="Concepto de Comisión"
	returnvariable="LB_ConceptoDeComision"/>	
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Monto_Base"
	Default="Monto Base"
	returnvariable="LB_Monto_Base"/>	

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Monto_Comision"
	Default="Monto Comisión"
	returnvariable="LB_Monto_Comision"/>	

<!---Boton de filtrar ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Filtrar"
	Default="Filtrar"	
	xmlfile="/rh/generales.xml"
	returnvariable="BTN_Filtrar"/>

<!---Boton Importar ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Importar"
	Default="Importar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Importar"/>

<!---Boton limpiar ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Limpiar"
	Default="Limpiar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Limpiar"/>

<!---Boton regresar ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Regresar"
	Default="Regresar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Regresar"/>
	
<!---Etiquetas de qforms---->	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificación"	
	xmlfile="/rh/generales.xml"
	returnvariable="LB_Identificacion"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Incidencia"
	Default="Incidencia"	
	returnvariable="LB_Incidencia"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripción"
	xmlfile="/rh/generales.xml"	
	returnvariable="LB_Descripcion"/>

<script language="javascript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<table width="95%" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<table border="0" width="100%" cellpadding="0" cellspacing="0">
				<cfoutput>
				<form  name="form1" method="post" action="ResultadoCalculo-comisionesSql.cfm" >
					<tr>
						<!--- Empleado --->
						<td class="fileLabel">#LB_Empleado#</td>
						<!--- Concepto --->	
						<td>&nbsp;</td>
						<td class="fileLabel" nowrap>#LB_ConceptoDeComision#</td>
						<!--- Valor --->
						<td class="fileLabel" nowrap>#LB_Monto_Base#</td>
						<!--- Valor --->
						<td class="fileLabel" nowrap>#LB_Monto_Comision#</td>
					</tr>
				
					 <tr> 
						<td  > 
							<cfif modo NEQ "ALTA">
								<cf_rhempleado query="#rsForm#" tabindex="1" size = "60">
							<cfelse>
								<cf_rhempleado tabindex="1" size = "50">
							</cfif>
						</td>
						
						<td>&nbsp;</td>
						<td>
						  <cfif modo NEQ "ALTA">
							<cf_rhCIncidentes query="#rsForm#" tabindex="1" ExcluirTipo="0,1,3" >
						  <cfelse>
							<cf_rhCIncidentes tabindex="1" ExcluirTipo="0,1,3" >
						  </cfif>			
						</td>
				
						<td nowrap>
						  <input name="RHCMmontobase" type="text" id="Ivalor" size="18" maxlength="15" onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsForm.RHCMmontobase, 'none')#<cfelse>0.00</cfif>" tabindex="1">
						</td>

						<td nowrap>
						  <input name="RHCMmontocomision" type="text" id="Ivalor" size="18" maxlength="15" onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsForm.RHCMmontocomision, 'none')#<cfelse>0.00</cfif>" tabindex="1">
						</td>
					  </tr>
				
						<tr>
							<td class="fileLabel" colspan="4" nowrap><cf_translate key="LB_Centro_Funcional" XmlFile="/rh/generales.xml">Centro Funcional</cf_translate></td>
						</tr>
						
						<!---<tr>
							<td colspan="4">
								<cfif modo neq 'ALTA' and isdefined("rsCFuncional") and rsCFuncional.RecordCount gt 0 >
									<cf_rhcfuncional  query="#rsCFuncional#" tabindex="1" >
								<cfelse>
									<cf_rhcfuncional tabindex="1">
								</cfif>
							</td>
						</tr>--->
				
						<tr><td colspan="5" align="center">
							<cfinclude template="/rh/portlets/pBotones.cfm">
							<input type="submit" name="Importar" value="#BTN_Importar#" onClick="deshabilitarValidacion(); document.form1.action = 'importarComisiones.cfm'">
							<input type="submit" name="Regresar" value="#BTN_Regresar#" onClick="javascript:regresar();">
						</td></tr>

					<cfset ts = "">
					<cfif modo NEQ "ALTA">
						<!---<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsForm.ts_rversion1#" returnvariable="ts1"/>
						<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsForm.ts_rversion2#" returnvariable="ts2"/>
						<input type="hidden" name="ts_rversion1" value="<cfif modo NEQ "ALTA">#ts1#</cfif>">
						<input type="hidden" name="ts_rversion2" value="<cfif modo NEQ "ALTA">#ts2#</cfif>">--->
						<input type="hidden" name="RHCDid" value="#rsForm.RHCDid#">
					</cfif>
					<input type="hidden" name="RCNid" value="#form.CPid#">
					<input type="hidden" name="CPid" value="#form.CPid#">
					
					<!---<input type="hidden" name="Pagina" value="<cfif isdefined("form.Pagina")>#form.Pagina#<cfelse>1</cfif>">--->
					
				</form>
				</cfoutput>
			</table>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td>
			<cfoutput>
			<form name="filtro" method="post" action="ResultadoCalculo-comisiones.cfm">
				<input type="hidden" name="filtrado" value="<cfif isdefined('form.btnFiltrar') or isdefined('form.filtrado')>#BTN_Filtrar#</cfif>">
				<input type="hidden" name="CPid" value="<cfoutput>#Form.CPid#</cfoutput>">

				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro" align="center">
					<tr> 
						<td width="25%" height="17" class="fileLabel">#LB_Identificacion#</td>
						<td width="50%" class="fileLabel"><cf_translate key="LB_NombreDelEmpleado" XmlFile="/rh/generales.xml">Nombre del empleado</cf_translate></td>
						<td width="20%" class="fileLabel">&nbsp;</td>
						<td width="5%" rowspan="2" class="fileLabel" nowrap>
							<input name="btnFiltrar" type="submit" id="btnFiltrar" value="#BTN_Filtrar#">
							<input name="btnLimpiar" type="button" id="btnLimpiar" value="#BTN_Limpiar#" onClick="javascript:limpiar2();">
						</td>
					</tr>
					<tr> 
						<td>
							<input name="DEidentificacionFiltro" type="text" id="DEidentificacionFiltro" size="30" maxlength="60" onfocus="this.select();" value="<cfif isdefined('form.DEidentificacionFiltro')><cfoutput>#form.DEidentificacionFiltro#</cfoutput></cfif>">
						</td>
						<td>
							<input name="nombreFiltro" type="text" id="nombreFiltro2" size="100" maxlength="260" onfocus="this.select();" value="<cfif isdefined('form.nombreFiltro')><cfoutput>#form.nombreFiltro#</cfoutput></cfif>">
						</td>
					</tr>
				</table>
			</form>
			</cfoutput>
		</td>
	</tr>

	<tr>
		<td>
			<cfquery name="rsLista"  datasource="#session.DSN#">
				select 	b.RHCDid,
						a.CPid, 
						a.DEid, 
						c.DEidentificacion,
						{fn concat({fn concat({fn concat({ fn concat(c.DEnombre, ' ') },c.DEapellido1)}, ' ')},c.DEapellido2) } as DEnombre, 
						a.RHCMmontobase, 
						b.CIid, 
						b.CIcodigo,
						d.CIdescripcion, 
						coalesce(b.RHCMmontocomision,0) as RHCMmontocomision
				from RHComisionMonge a
				
				inner join RHComisionMongeD b
				on a.CPid=b.CPid
				and a.DEid=b.DEid
				
				inner join DatosEmpleado c
				on a.DEid=c.DEid
			
				<cfif isdefined("form.DEidentificacionFiltro") and len(trim(form.DEidentificacionFiltro))>
					and c.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEidentificacionFiltro#">
				</cfif>
				
				<cfif isdefined("form.nombreFiltro") and len(trim(form.nombreFiltro))>
					and ( upper(c.DEnombre) like '%#Ucase(form.nombreFiltro)#%'
					or upper(c.DEapellido1) like '%#Ucase(form.nombreFiltro)#%'
					or upper(c.DEapellido2) like '%#Ucase(form.nombreFiltro)#%' )
				</cfif>

				inner join CIncidentes d
				on b.CIid=d.CIid

				and a.CPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
				
				order by a.DEid, b.CIcodigo
			</cfquery>

			<cfoutput>
				<cfinvoke 
						component="rh.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsLista#"/>
					<cfinvokeargument name="desplegar" value="DEidentificacion, DEnombre, CIcodigo, CIdescripcion, RHCMmontocomision"/>
					<cfinvokeargument name="etiquetas" value="#LB_Identificacion#,#LB_Empleado#,#LB_Incidencia#,#LB_Descripcion#,#LB_Monto_Comision#"/>
					<cfinvokeargument name="formatos" value="S, S, S, S, M"/>
					<cfinvokeargument name="align" value="left, left, left, left, right"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="ResultadoCalculo-comisiones.cfm"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="keys" value="CPid, DEid, RHCDid"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="maxRows" value="30"/>
				</cfinvoke>
			</cfoutput>
		</td>
	</tr>		
</table>
<iframe name="frMontoBase" id="frMontoBase" width="0" height="0" src="" frameborder="0"></iframe>

<script language="JavaScript1.2" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	<cfoutput>
		objForm.DEid.required = true;
		objForm.DEid.description="#LB_Empleado#";
	
		objForm.CIid.required = true;
		objForm.CIid.description="#LB_ConceptoDeComision#";
	
		objForm.RHCMmontobase.required = true;
		objForm.RHCMmontobase.description="#LB_Monto_Base#";
	
		objForm.RHCMmontocomision.required = true;
		objForm.RHCMmontocomision.description="#LB_Monto_Comision#";
	</cfoutput>
	
	/*objForm.CFid.required = true;
	objForm.CFid.description="Centro Funcional";*/

	function deshabilitarValidacion(){
		objForm.DEid.required = false;
		objForm.CIid.required = false;
		objForm.RHCMmontobase.required = false;
		objForm.RHCMmontocomision.required = false;
		//objForm.CFid.required = false;
	}
	
	function traeMontoBase(){
		document.getElementById("frMontoBase").src = 'montobase-query.cfm?CPid=' + document.form1.CPid.value + '&DEid=' + document.form1.DEid.value;
	} 

	function funcDEid(){
		traeMontoBase();
	}
	
	function regresar(){
		deshabilitarValidacion()
		document.form1.action = 'ResultadoCalculo-lista.cfm';
		document.form1.submit();
	}
	
	function limpiar2(){
		document.filtro.DEidentificacionFiltro.value = '';
		document.filtro.nombreFiltro.value = '';
	}
	
	function limpiar(){
		objForm.DEid.obj.value = '';
		objForm.DEidentificacion.obj.value = '';
		objForm.NombreEmp.obj.value = ''; 
		objForm.CIid.obj.value = '';
		objForm.CIcodigo.obj.value = '';
		objForm.CIdescripcion.obj.value = '';
		objForm.RHCMmontobase.obj.value = '0.00';
		objForm.RHCMmontocomision.obj.value = '0.00';
		//objForm.CFid.obj.value = '';
		objForm.CFcodigo.obj.value = '';
		objForm.CFdescripcion.obj.value = '';
	}
</script>