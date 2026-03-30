<!----<cfinclude template="../../pago/boleta/ParametrizaBoletaPago.cfm">---->

<!-----=============================== PARAMETRIZACION DE BOLETA ===============================------>
<cfset tipo = 10> <!---  Por default tendra valor 10 para que use la boleta estándar (carta)--->
<!--- busca el tipo de boleta de pago definido en parametros generales de RH --->
<cfquery name="RSParametro" datasource="#session.DSN#">
	select ltrim(rtrim(Pvalor)) as tipo  
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo = 720				
</cfquery>
<cfif isdefined("RSParametro") and len(trim(RSParametro.tipo))>
	<cfset tipo = RSParametro.tipo>
</cfif> 
<cfswitch expression="#tipo#"> 
	<cfcase value="10"> 	
		<cfset Ruta.pago        = '/cfmx/rh/expediente/consultas/EnviarEmails.cfm'>
	</cfcase> 
	<cfcase value="20">
		<cfset Ruta.pago        = '/cfmx/rh/expediente/consultas/HEnviarEmailsDosTercios.cfm'>
	</cfcase>
	<cfcase value="30">
		<cfset Ruta.pago        = '/cfmx/rh/expediente/consultas/HEnviarEmailsDosTercios.cfm'>
	</cfcase>	
	<cfcase value="40">					
		<cfset Ruta.pago        = '/cfmx/rh/expediente/consultas/HEnviarEmailsDosTerciosIMP.cfm'>
	</cfcase>
	<cfdefaultcase> 
		<cfset Ruta.pago        = '/cfmx/rh/expediente/consultas/EnviarEmails.cfm'>
	</cfdefaultcase> 
</cfswitch> 
<!-----=============================================================================================----->


<cfset navegacion = '&CPid=' & form.CPid >
<cfset regresar = 'HBoletasPago.cfm?CPid=#form.CPid#'>

<!--- Detalles de la Nómina --->
<cfquery name="rsLista" datasource="#Session.DSN#">
	select a.DEid, 
		   a.RCNid,
		   c.Tcodigo,
		   b.DEidentificacion, 
		   {fn concat({fn concat({fn concat({fn concat(b.DEapellido1 , ' ' )}, b.DEapellido2 )}, ' ' )}, b.DEnombre )} as Nombre, 
		   SEsalariobruto, 
		   SEincidencias, 
		   SErenta, 
		   SEcargasempleado, 
		   SEdeducciones, 
		   SEliquido,
		   '#regresar#' as regresar,
		   'HBoletasPago.cfm' as origen

	from HSalarioEmpleado a 
	
	inner join DatosEmpleado b
 	  on a.DEid = b.DEid
	  <cfif isdefined("form.fDEidentificacion") and len(trim(form.fDEidentificacion))>
	      and upper(b.DEidentificacion) like '%#ucase(trim(form.fDEidentificacion))#%'
			<cfset navegacion = navegacion & "&fDEidentificacion=" & form.fDEidentificacion >
			<cfset regresar = regresar & '&fDEidentificacion=#form.fDEidentificacion#'>				  
	  </cfif>
	  <cfif isdefined("form.fNombre") and len(trim(form.fNombre))>
	      and upper(b.DEnombre) like '%#ucase(trim(form.FNombre))#%'
			<cfset navegacion = navegacion & "&fNombre=" & form.fNombre >
			<cfset regresar = regresar & '&fNombre=#form.fNombre#'>		  
	  </cfif>
	  <cfif isdefined("form.fDApellido1") and len(trim(form.fDApellido1))>
	      and upper(b.DEapellido1) like '%#ucase(trim(form.fDApellido1))#%'
			<cfset navegacion = navegacion & "&fDApellido1=" & form.fDApellido1 >
			<cfset regresar = regresar & '&fDApellido1=#form.fDApellido1#'>		  
	  </cfif>
	  <cfif isdefined("form.fDApellido2") and len(trim(form.fDApellido2))>
	      and upper(b.DEapellido2) like '%#ucase(trim(form.fDApellido2))#%'
			<cfset navegacion = navegacion & "&fDApellido2=" & form.fDApellido2 >
			<cfset regresar = regresar & '&fDApellido2=#form.fDApellido2#'>		  
	  </cfif>
	  
	inner join HRCalculoNomina c
	  on a.RCNid = c.RCNid
	  
	<cfif isdefined("form.CFid") and len(trim(form.CFid))>
		inner join LineaTiempo e
		on a.DEid=e.DEid
		and getDate() between LTdesde and LThasta
	
		inner join RHPlazas f
		on e.RHPid=f.RHPid
		and e.Ecodigo=f.Ecodigo	
		and f.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
		<cfset navegacion = navegacion & "&CFid=" & form.CFid >
		<cfset regresar = regresar & '&CFid=#form.CFid#'>		
	</cfif>
	
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and c.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPid#">
	  
	order by  b.DEidentificacion
</cfquery>

<cfquery name="dataCalendario" datasource="#session.DSN#">
	select CPcodigo, CPdescripcion
	from CalendarioPagos
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
</cfquery>

<cf_templatecss>
<cfoutput>
<table width="98%" cellpadding="0" cellspacing="0" align="center">
	<tr><td>&nbsp;</td></tr>

	<tr>
		<td>
			<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td colspan="2"><strong><font size="2"><cf_translate  key="LB_HistoricoDeBoletasDePago">Hist&oacute;rico de Boletas de Pago</cf_translate></font></strong></td>
				</tr>
				<tr>
					<td width="1%" nowrap><strong><cf_translate  key="LB_CalendarioDePagos">Calendario de Pagos</cf_translate>:&nbsp;</strong></td>
					<td>#dataCalendario.CPcodigo# - #dataCalendario.CPdescripcion#</td>
				</tr>
				<cfif isdefined("form.CFid") and len(trim(form.CFid))>
					<cfquery name="dataCFuncional" datasource="#session.DSN#">
						select CFcodigo, CFdescripcion
						from CFuncional
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
					</cfquery>
					<tr>
						<td width="1%" nowrap><strong><cf_translate  key="LB_CentroFuncional">Centro Funcional</cf_translate>:&nbsp;</strong></td>
						<td>#dataCFuncional.CFcodigo# - #dataCFuncional.CFdescripcion#</td>
					</tr>
				</cfif>
				<tr><td colspan="2">
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr>
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_EnviarBoletasDePago"
							Default="Enviar Boletas de Pago"
							returnvariable="BTN_EnviarBoletasDePago"/>
							<td width="1%">&nbsp;</td><td width="1%" nowrap><strong><cf_translate  key="LB_EnviarBoletasDePagoPorCorreo">Enviar Boletas de Pago por Correo</cf_translate>&nbsp;</strong></td><td width="98%"><input type="button" onClick="javascript:funcEnviarEmails();" value="<cfoutput>#BTN_EnviarBoletasDePago#</cfoutput>"></td>
						</tr>
					</table>
				</td></tr>
				<tr><td>&nbsp;</td></tr>
			</table>
		</td>
	</tr>

	<tr><td>&nbsp;</td></tr>		

	<tr><td>
		<form style="margin:0; " name="filtro" method="post" action="HBoletasPago.cfm">
			<input type="hidden" name="CPid" value="#form.CPid#">
			<cfif isdefined("form.CFid") and len(trim(form.CFid))>
				<input type="hidden" name="CFid" value="#form.CFid#">
			</cfif>
			
			<table cellpadding="0" cellspacing="0" class="areaFiltro" width="100%">
				<tr>
					<td align="right"><strong><cf_translate  key="LB_Identificacion">Identificaci&oacute;n</cf_translate>:&nbsp;</strong></td>
					<td><input type="text" size="20" maxlength="60" name="fDEidentificacion" value="<cfif isdefined("form.fDEidentificacion") and len(trim(form.fDEidentificacion))>#form.fDEidentificacion#</cfif>"></td>
					<td align="right"><strong><cf_translate  key="LB_Apellidos">Apellidos</cf_translate>:&nbsp;</strong></td>
				  <td  nowrap="nowrap"><input type="text" size="20" maxlength="60" name="fDApellido1" value="<cfif isdefined("form.fDApellido1") and len(trim(form.fDApellido1))>#form.fDApellido1#</cfif>">
				    <input type="text" size="20" maxlength="60" name="fDApellido2" value="<cfif isdefined("form.fDApellido2") and len(trim(form.fDApellido2))>#form.fDApellido2#</cfif>"></td>
					<td align="right"><strong><cf_translate  key="LB_Nombre">Nombre</cf_translate>:&nbsp;</strong></td>
					<td><input type="text" size="20" maxlength="60" name="fNombre" value="<cfif isdefined("form.fNombre") and len(trim(form.fNombre))>#form.fNombre#</cfif>"></td>
					<td nowrap="nowrap">
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Limpiar"
						Default="Limpiar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Limpiar"/>
						
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Filtrar"
						Default="Filtrar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Filtrar"/>
						<cfoutput>
							<input type="submit" name="Filtrar" value="#BTN_Filtrar#">
							<input type="submit" name="Limpiar" value="#BTN_Limpiar#" onClick="javascript:limpiar();">
						</cfoutput>
					</td>
				</tr>
			</table>
		</form>
	</td></tr>
	
	<tr>
		<td>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Cedula"
			Default="C&eacute;dula"
			returnvariable="LB_Cedula"/> 
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Nombre"
			Default="Nombre"
			returnvariable="LB_Nombre"/>
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Bruto"
			Default="Bruto"
			returnvariable="LB_Bruto"/>
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Incidencias"
			Default="Incidencias"
			returnvariable="LB_Incidencias"/>
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Renta"
			Default="Renta"
			returnvariable="LB_Renta"/>
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_CargasEmpleado"
			Default="Cargas Empleado"
			returnvariable="LB_CargasEmpleado"/>
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Deducciones"
			Default="Deducciones"
			returnvariable="LB_Deducciones"/>
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Liquido"
			Default="L&iacute;quido"
			returnvariable="LB_Liquido"/>

			<cfinvoke 
			 component="rh.Componentes.pListas"
			 method="pListaQuery"
			 returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="desplegar" value="DEidentificacion,Nombre,SEsalariobruto, SEincidencias, SErenta,SEcargasempleado,SEdeducciones,SEliquido"/>
				<cfinvokeargument name="etiquetas" value="#LB_Cedula#,#LB_Nombre#,#LB_Bruto#,#LB_Incidencias#,#LB_Renta#,#LB_CargasEmpleado#,#LB_Deducciones#,#LB_Liquido#"/>
				<cfinvokeargument name="formatos" value="V,V,M,M,M,M,M,M"/>
				<cfinvokeargument name="align" value="left, left,right,right,right,right,right,right"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="irA" value="HResultadoCalculo.cfm"/>
				<cfinvokeargument name="keys" value="RCNid,DEid"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="maxrows" value="25"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
			</cfinvoke>
			<br>
		</td>
	</tr>	
</table>
</cfoutput>

<script type="text/javascript" language="javascript1.2">
	function funcEnviarEmails() {
		var width = 450;
		var height = 200;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		<cfoutput>
		var parametros = '';
		<cfif isdefined('form.CFid') and len(trim(form.CFid)) >
			var parametros = '&CFid=#form.CFid#';
		</cfif>
		var nuevo = window.open('<cfoutput>#Ruta.pago#</cfoutput>?RCNid=#Form.CPid#'+parametros,'ListaEmpleados','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
		</cfoutput>
		nuevo.focus();
	}

	function limpiar(){
		document.filtro.fDEidentificacion.value = '';
		document.filtro.fNombre.value = '';
		document.filtro.fDApellido1.value = '';
		document.filtro.fDApellido2.value = '';
	}
</script>