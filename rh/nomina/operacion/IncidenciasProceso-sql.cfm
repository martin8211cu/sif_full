<!---Averiguar si se ingresa desde Autogestion o desde Nomina --->
<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="validaLugarConsulta" returnvariable="Menu"/>

<!---Averigua si el parametro 'Requiere aprobación incidencias' esta encendido --->
<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="getParam" returnvariable="reqAprobacion">
	<cfinvokeargument name="Pcodigo" value="1010">
</cfinvoke>
		
<!---valida si no requiere aprobacion o si no se trata de una incidencia desde autogestion--->
<cfif Menu NEQ 'AUTO' or not reqAprobacion>
	<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso"><!--- Permite validar el acceso según paramatrizacion 2526--->
</cfif>

<!----Pasar de URL a FORM--->
<cfif isdefined("url.Ifecha")><cfset form.Ifecha = url.Ifecha></cfif>
<cfif isdefined("url.Ivalor")><cfset form.Ivalor = url.Ivalor></cfif>
<cfif isdefined("url.DEid")><cfset form.DEid = url.DEid></cfif>
<cfif isdefined("url.CIid")><cfset form.CIid = url.CIid></cfif>
<cfif isdefined("url.CFid")><cfset form.CFid = url.CFid></cfif>
<cfif isdefined("url.RHJid")><cfset form.RHJid = url.RHJid></cfif>
<cfif isdefined("url.Icpespecial")><cfset form.Icpespecial = url.Icpespecial></cfif>
<cfif isdefined("url.IfechaRebajo")><cfset form.IfechaRebajo = url.IfechaRebajo></cfif>
<cfif isdefined("url.Iid")><cfset form.Iid = url.Iid></cfif>
<cfif isdefined("url.Usuario")><cfset form.Usuario = url.Usuario></cfif>
<cfif isdefined("url.cambio")><cfset form.cambio = url.cambio></cfif>
<cfif isdefined("url.baja")><cfset form.baja = url.baja></cfif>
<cfif isdefined("url.alta")><cfset form.alta = url.alta></cfif>
<cfif isdefined("url.Nuevo")><cfset form.Nuevo = url.Nuevo></cfif>
<cfif isdefined("url.ts_rversion")><cfset form.ts_rversion = url.ts_rversion></cfif>
<cfif isdefined("url.Iobservacion")><cfset form.Iobservacion = url.Iobservacion></cfif>

<cfif isdefined("url.Iestadoaprobacion")><cfset form.Iestadoaprobacion = url.Iestadoaprobacion></cfif>
<cfif isdefined("url.Iingresadopor")><cfset form.Iingresadopor = url.Iingresadopor></cfif>
<cfif isdefined("url.Ijustificacion")><cfset form.Ijustificacion = url.Ijustificacion></cfif>
<cfset form.usuCF = session.usucodigo>

<!---Filtros para no perder la navegacion--->
<cfif isdefined("url.DEid1")><cfset form.DEid1 = url.DEid1></cfif>
<cfif isdefined("url.Ffecha")><cfset form.Ffecha = url.Ffecha></cfif>
<cfif isdefined("url.CIid_f")><cfset form.CIid_f = url.CIid_f></cfif>
<cfif isdefined("url.FIcpespecial_f")><cfset form.FIcpespecial_f = url.FIcpespecial_f></cfif>
<cfif isdefined("url.CFid_f")><cfset form.CFid_f = url.CFid_f></cfif>
<cfif isdefined("url.IfechaRebajo_f")><cfset form.IfechaRebajo_f = url.IfechaRebajo_f></cfif>
<cfif isdefined("url.PageNum_Lista1")><cfset form.PageNum_Lista1 = url.PageNum_Lista1></cfif>
<cfif isdefined("url.PageNum_Lista2")><cfset form.PageNum_Lista2 = url.PageNum_Lista2></cfif>

<!--- Lunes, 09 de Octubre del 2006, se modifica para que utilice el componente de incidencias --->
<cfif not isdefined("url.btnEliminar") and not isdefined("url.btnRechazar")>
		<cfset modo="ALTA">
		<!--- 22 de Octubre del 2007, se agrega para poder incluir Incidencias de tipo Clculo --->
		<!--- jc --->
		<cfquery name="rsDatosConcepto" datasource="#Session.DSN#"><!---Obtener datos de la incidencia, requeridos por la calculadora--->
			select 	coalesce(b.CItipo,'m') as CItipo,
					b.CIdia,
					b.CImes,
					b.CIcalculo,
					<cfqueryparam cfsqltype="cf_sql_date" value="#Form.Ifecha#"> as Ifecha,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ivalor#"> as Ivalor,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#"> as DEid,
					0 as RHJid,
					0 as Tcodigo,
					coalesce(b.CIcantidad,0) as CIcantidad,
					coalesce(b.CIrango,0) as CIrango
					, coalesce(b.CIspcantidad,0) as CIspcantidad
					, coalesce(b.CIsprango,0) as CIsprango
			from CIncidentes a
				left outer join CIncidentesD b
					on a.CIid = b.CIid
			where a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CIid#">
				and a.CItipo = 3
		</cfquery>
	<!---	<cfdump var="#form#">
		<cfdump var="#rsDatosConcepto#">--->
		
		<cfif rsDatosConcepto.RecordCount NEQ 0>
			<!---LLAMAR CALCULADORA PARA OBTENER EL Imonto----->
			<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")><!----Para utilizar la calculadora--->
			<cfset current_formulas = rsDatosConcepto.CIcalculo>
			<cfset presets_text = RH_Calculadora.get_presets(LSParseDateTime(rsDatosConcepto.Ifecha),<!---fecha1_accion--->
										   LSParseDateTime(rsDatosConcepto.Ifecha),<!---fecha2_accion--->
										   rsDatosConcepto.CIcantidad,<!---CIcantidad--->
										   rsDatosConcepto.CIrango, <!---CIrango--->
										   rsDatosConcepto.CItipo, <!---CItipo--->
										   rsDatosConcepto.DEid,	<!---DEid--->
										   rsDatosConcepto.RHJid, <!---RHJid--->
										   session.Ecodigo, <!---Ecodigo--->
										   0, <!---RHTid--->
										   0, <!---RHAlinea--->																		   
										   rsDatosConcepto.CIdia, <!---CIdia--->
										   rsDatosConcepto.CImes,<!---CImes--->
										   rsDatosConcepto.Tcodigo,<!---Tcodigo--->
										   FindNoCase('SalarioPromedio', current_formulas), <!---calc_promedio--->
										   'false', <!---masivo--->
										   '', <!---tabla_temporal--->
										   0,<!---calc_diasnomina--->
										   rsDatosConcepto.Ivalor
										   , '' 
										   ,rsDatosConcepto.CIsprango
										   ,rsDatosConcepto.CIspcantidad
										   )>
										   
			<cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>
			<cfif Not IsDefined("values") or not isdefined("presets_text")>												
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_NoEsPosibleRealizarElCalculo"
					Default="No es posible realizar el c&aacute;lculo"
					XmlFile="/rh/generales.xml"
					returnvariable="LB_NoEsPosibleRealizarElCalculo"/>
				<cf_throw message="#LB_NoEsPosibleRealizarElCalculo#" errorCode="1000">
			</cfif>
			
			<cfset iMonto = #values.get('resultado').toString()#>
			<!----------------- Fin de calculadora ------------------->		
		</cfif>	
		<!--- fin jc --->
</cfif>
			
<cfif isdefined("Form.Alta")>
	<!---Validacion para que no se agregue dos veces la misma incidencia en la misma fecha sin antes ser confirmada. Solo para modo Alta. CarolRS--->
	<cfif not isdefined("url.confirmado") and form.Iingresadopor EQ 2> <!---si es adinistrador--->
		<cfinclude template="IncideciasProceso-confirmacion.cfm">	
	</cfif>
	
	<!---Averigua si el parametro 'Requiere aprobación incidencias' esta encendido --->
	<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="getParam" returnvariable="reqAprobacion">
		<cfinvokeargument name="Pcodigo" value="1010">
	</cfinvoke>
	
		<!---si no se define el centro funcional se agrega el del empleado--->
	<cfif not isdefined("form.CFid") or not len(trim(form.CFid)) or form.CFid LTE 0>
		<cfquery name="rsGetCF" datasource="#session.DSN#">
			select coalesce( b.CFidconta, b.CFid) as CFid
			from LineaTiempo a
			inner join RHPlazas b
				on b.RHPid = a.RHPid
			inner join CFuncional c
				on c.CFid = b.CFid
			where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">	
				and getDate() between a.LTdesde and a.LThasta 
		</cfquery>
		
		<cfif rsGetCF.recordCount EQ 0>
			<cfquery name="rsGetCF" datasource="#session.DSN#">
				select coalesce(b.CFidconta, b.CFid) as CFid
				from DLaboralesEmpleado a
				inner join RHPlazas b
					on b.RHPid = a.RHPid
				inner join CFuncional c
					on c.CFid = b.CFid
				where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">	
					and getDate() between a.DLfvigencia and a.DLffin 
			</cfquery>
		</cfif>
		<cfset url.CFid= rsGetCF.CFid>
		<cfset form.CFid= url.CFid>
	</cfif>

	<cfif rsDatosConcepto.RecordCount NEQ 0>
		<cfinvoke component="rh.Componentes.RH_IncidenciasProceso"  method="Alta" 
			DEid = "#Form.DEid#"
			CIid = "#Form.CIid#"
			iFecha = "#LSParseDateTime(Form.Ifecha)#"
			iValor = "#Form.Ivalor#"		
			Imonto = "#iMonto#"    <!--- jc --->
			returnVariable="Lvar_Iid">
			<cfif isdefined("form.CFid") and len(trim(form.CFid)) gt 0>
				<cfinvokeargument name="CFid" value="#Form.CFid#">
			</cfif>
			<cfif isdefined("form.RHJid") and len(trim(form.RHJid)) gt 0>
				<cfinvokeargument name="RHJid" value="#Form.RHJid#">
			</cfif>
			<cfif isdefined("form.Icpespecial") and len(trim(form.Icpespecial)) EQ 0>
				<cfinvokeargument name="Icpespecial" value="1">		
	
				<cfif isdefined("form.IfechaRebajo") >
					<cfinvokeargument name="IfechaRebajo" value="#form.IfechaRebajo#">
				</cfif>
			</cfif>
			<cfif isdefined("form.Iobservacion") and len(trim(form.Iobservacion)) gt 0>
				<cfinvokeargument name="Iobservacion" value="#Form.Iobservacion#">
			</cfif>
			<cfif isdefined("form.Iingresadopor")>
				<cfinvokeargument name="Iingresadopor" value="#form.Iingresadopor#">
			</cfif>
			<cfif isdefined("form.Iestadoaprobacion")>
				<cfinvokeargument name="Iestadoaprobacion" value="#form.Iestadoaprobacion#">
			</cfif>
			<cfif isdefined("form.usuCF")>
				<cfinvokeargument name="usuCF" value="#form.usuCF#">
			</cfif>	
			<cfif isdefined("form.Ijustificacion")>
				<cfinvokeargument name="Ijustificacion" value="#form.Ijustificacion#">
			</cfif>
		</cfinvoke>
		
	<cfelse>
		
		<cfinvoke component="rh.Componentes.RH_IncidenciasProceso"  method="Alta" 
			DEid = "#Form.DEid#"
			CIid = "#Form.CIid#"
			iFecha = "#LSParseDateTime(Form.Ifecha)#"
			iValor = "#Form.Ivalor#"		
			returnVariable="Lvar_Iid">
			<cfif isdefined("form.CFid") and len(trim(form.CFid)) gt 0>
				<cfinvokeargument name="CFid" value="#Form.CFid#">
			</cfif>
			<cfif isdefined("form.RHJid") and len(trim(form.RHJid)) gt 0>
				<cfinvokeargument name="RHJid" value="#Form.RHJid#">
			</cfif>
			<cfif isdefined("form.Icpespecial") and len(trim(form.Icpespecial)) EQ 0>
				<cfinvokeargument name="Icpespecial" value="1">		
	
				<cfif isdefined("form.IfechaRebajo") >
					<cfinvokeargument name="IfechaRebajo" value="#form.IfechaRebajo#">
				</cfif>
			</cfif>
			<cfif isdefined("form.Iobservacion")>
				<cfinvokeargument name="Iobservacion" value="#form.Iobservacion#">
			</cfif>
			
			<cfif isdefined("form.Iingresadopor")>
				<cfinvokeargument name="Iingresadopor" value="#form.Iingresadopor#">
			</cfif>
			<cfif isdefined("form.Iestadoaprobacion")>
				<cfinvokeargument name="Iestadoaprobacion" value="#form.Iestadoaprobacion#">
			</cfif>
			<cfif isdefined("form.usuCF")>
				<cfinvokeargument name="usuCF" value="#form.usuCF#">
			</cfif>	
			<cfif isdefined("form.Ijustificacion")>
				<cfinvokeargument name="Ijustificacion" value="#form.Ijustificacion#">
			</cfif>
		</cfinvoke>
	</cfif>	<!---Fin de IF rsDatosConcepto.RecordCount NEQ 0---->		
		
	<cfset modo="ALTA">

<cfelseif isdefined("Form.Baja")>
	<cfinvoke 
			component="rh.Componentes.RH_IncidenciasProceso" 
			method="Baja" 
			Iid = "#Form.Iid#"/>
	<cfset modo="ALTA">

<cfelseif isdefined("Form.Cambio")>
	
	<cfset modo="CAMBIO">
	<cf_dbtimestamp datasource="#session.dsn#"
 			table="Incidencias"
 			redirect="IncidenciasProceso.cfm"
 			timestamp="#form.ts_rversion#"
			field1="Iid" 
			type1="numeric" 
			value1="#form.Iid#">
	<cfif rsDatosConcepto.RecordCount NEQ 0>
		<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="Cambio" >
				<cfinvokeargument name="Iid" 	value="#Form.Iid#">
				<cfinvokeargument name="DEid" 	value="#Form.DEid#">
				<cfinvokeargument name="CIid" 	value="#Form.CIid#">
				<cfinvokeargument name="iFecha" value="#LSParseDateTime(Form.Ifecha)#">
				<cfinvokeargument name="iValor" value="#Form.Ivalor#">
				<cfinvokeargument name="Imonto" value="#iMonto#">   <!--- jc --->
					
			<cfif isdefined("form.CFid") and len(trim(form.CFid)) gt 0>
				<cfinvokeargument name="CFid" value="#Form.CFid#">
			</cfif>
			<cfif isdefined("form.RHJid") and len(trim(form.RHJid)) gt 0>
				<cfinvokeargument name="RHJid" value="#Form.RHJid#">
			</cfif>
			<cfif isdefined("form.Icpespecial") and len(trim(form.Icpespecial)) EQ 0>
				<cfinvokeargument name="Icpespecial" value="1">		
	
				<cfif isdefined("form.IfechaRebajo")>
					<cfinvokeargument name="IfechaRebajo" value="#form.IfechaRebajo#">
				</cfif>
			</cfif>		
			<cfif isdefined("form.Iobservacion")>
				<cfinvokeargument name="Iobservacion" value="#form.Iobservacion#">
			</cfif>
			
			<cfif isdefined("form.Iingresadopor")>
				<cfinvokeargument name="Iingresadopor" value="#form.Iingresadopor#">
			</cfif>
			<cfif isdefined("form.Iestadoaprobacion")>
				<cfinvokeargument name="Iestadoaprobacion" value="#form.Iestadoaprobacion#">
			</cfif>
			<cfif isdefined("form.usuCF")>
				<cfinvokeargument name="usuCF" value="#form.usuCF#">
			</cfif>	
			<cfif isdefined("form.Ijustificacion")>
				<cfinvokeargument name="Ijustificacion" value="#form.Ijustificacion#">
			</cfif>
			
		</cfinvoke>
	<cfelse>
		<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="Cambio" >
				<cfinvokeargument name="Iid" 	value="#Form.Iid#">
				<cfinvokeargument name="DEid" 	value="#Form.DEid#">
				<cfinvokeargument name="CIid" 	value="#Form.CIid#">
				<cfinvokeargument name="iFecha" value="#LSParseDateTime(Form.Ifecha)#">
				<cfinvokeargument name="iValor" value="#Form.Ivalor#">				
			<cfif isdefined("form.CFid") and len(trim(form.CFid)) gt 0>
				<cfinvokeargument name="CFid" value="#Form.CFid#">
			</cfif>
			<cfif isdefined("form.RHJid") and len(trim(form.RHJid)) gt 0>
				<cfinvokeargument name="RHJid" value="#Form.RHJid#">
			</cfif>
			<cfif isdefined("form.Icpespecial") and len(trim(form.Icpespecial)) EQ 0>
				<cfinvokeargument name="Icpespecial" value="1">		
	
				<cfif isdefined("form.IfechaRebajo")>
					<cfinvokeargument name="IfechaRebajo" value="#form.IfechaRebajo#">
				</cfif>
			</cfif>	
			<cfif isdefined("form.Iobservacion")>
				<cfinvokeargument name="Iobservacion" value="#form.Iobservacion#">
			</cfif>	
			<cfif isdefined("form.Iingresadopor")>
				<cfinvokeargument name="Iingresadopor" value="#form.Iingresadopor#">
			</cfif>
			<cfif isdefined("form.Iestadoaprobacion")>
				<cfinvokeargument name="Iestadoaprobacion" value="#form.Iestadoaprobacion#">
			</cfif>
			<cfif isdefined("form.usuCF")>
				<cfinvokeargument name="usuCF" value="#form.usuCF#">
			</cfif>	
			<cfif isdefined("form.Ijustificacion")>
				<cfinvokeargument name="Ijustificacion" value="#form.Ijustificacion#">
			</cfif>		
		</cfinvoke>
	</cfif>

<cfelseif isdefined("url.btnEliminar")>
	<cfif isdefined("url.chk") and len(trim(url.chk)) >
		<cfloop list="#url.chk#" index="i">
				<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="Baja" Iid = "#i#"/>
		</cfloop>
	</cfif>
	<cfset modo="ALTA">
	
<cfelseif isdefined("url.btnRechazar")>
	<cfif isdefined("url.chk") and len(trim(url.chk)) >
		<cfloop list="#url.chk#" index="i">
				<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="RechazaIncidenciaFinal" Iid = "#i#"/>
		</cfloop>
	</cfif>
	<cfset modo="ALTA">
</cfif>	

<form action="IncidenciasProceso.cfm" method="get" name="sql">
	<cfoutput>
		<cfif isdefined("Form.Usuario")>
			<input name="Usuario" type="hidden" value="#Form.Usuario#"> 
		</cfif>
		<cfif isdefined("Form.DEid")>
			<input name="DEid" type="hidden" value="#Form.DEid#"> 
		</cfif>	
		<cfif isdefined("Form.Nuevo")>
			<input name="Nuevo" type="hidden" value="Nuevo"> 
		</cfif>	
		<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<cfif isdefined("Lvar_Iid")>
			<input name="Iid" type="hidden" value="#Lvar_Iid#">
		<cfelseif isdefined("Form.Iid")>
			<input name="Iid" type="hidden" value="#Form.Iid#">
		</cfif>
		<!---Filtros para no perder la navegacion--->
		<cfif isdefined("url.proceso_aprobacion")>
		<input type="hidden" name="proceso_aprobacion" value="#url.proceso_aprobacion#"/>
		</cfif>
		<cfif isdefined("form.DEid1")>
			<input type="hidden" name="DEid1" value="#form.DEid1#"  />
		</cfif>
		<cfif isdefined("form.Ffecha")>
			<input type="hidden" name="Ffecha" value="#form.Ffecha#"  />
		</cfif>
		<cfif isdefined("form.CIid_f")>
			<input type="hidden" name="CIid_f" value="#form.CIid_f#"  />
		</cfif>
		<cfif isdefined("form.FIcpespecial_f")>
			<input type="hidden" name="FIcpespecial_f" value="#form.FIcpespecial_f#"  />
		</cfif>
		<cfif isdefined("form.CFid_f")>
			<input type="hidden" name="CFid_f" value="#form.CFid_f#"  />
		</cfif>
		<cfif isdefined("form.IfechaRebajo_f")>
			<input type="hidden" name="IfechaRebajo_f" value="#form.IfechaRebajo_f#"  />
		</cfif>
		<input name="PageNum_Lista1" type="hidden" value="<cfif isdefined("Form.PageNum_Lista1")>#Form.PageNum_Lista1#</cfif>">
		<input name="PageNum_Lista2" type="hidden" value="<cfif isdefined("Form.PageNum_Lista2")>#Form.PageNum_Lista2#</cfif>">	
		<cfparam name="url.tab" default="1">
		<input type="hidden" name="tab" value="#url.tab#" />
	</cfoutput>
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
