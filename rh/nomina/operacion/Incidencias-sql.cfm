<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso"><!--- Permite validar el acceso según paramatrizacion 2526--->
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
<cfif isdefined("url.Pagina")><cfset form.Pagina = url.Pagina></cfif>
<cfif isdefined("url.cambio")><cfset form.cambio = url.cambio></cfif>
<cfif isdefined("url.baja")><cfset form.baja = url.baja></cfif>
<cfif isdefined("url.alta")><cfset form.alta = url.alta></cfif>
<cfif isdefined("url.Nuevo")><cfset form.Nuevo = url.Nuevo></cfif>
<cfif isdefined("url.ts_rversion")><cfset form.ts_rversion = url.ts_rversion></cfif>

<!--- Lunes, 09 de Octubre del 2006, se modifica para que utilice el componente de incidencias --->

<cfif not isdefined("url.btnEliminar")>
		<!--- 22 de Octubre del 2007, se agrega para poder incluir Incidencias de tipo Clculo --->
		<!--- jc --->
		<cfquery name="rsDatosConcepto" datasource="#Session.DSN#"><!---Obtener datos de la incidencia, requeridos por la calculadora--->
			select 	coalesce(b.CItipo,'m') as CItipo,
					b.CIdia,
					b.CImes,
					b.CIcalculo,
					<cfqueryparam cfsqltype="cf_sql_date" value="#Form.Ifecha#"> as Ifecha,
					#Form.Ivalor# as Ivalor,
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
	<cfif not isdefined("url.confirmado")>
		<cfinclude template="Incidecias-confirmacion.cfm">	
	</cfif>
		
	<cfif rsDatosConcepto.RecordCount NEQ 0>
		<cfinvoke component="rh.Componentes.RH_Incidencias"  method="Alta" 
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
		</cfinvoke>
		
	<cfelse>
		
		<cfinvoke component="rh.Componentes.RH_Incidencias"  method="Alta" 
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
		</cfinvoke>
	</cfif>	<!---Fin de IF rsDatosConcepto.RecordCount NEQ 0---->		
		
	<cfset modo="ALTA">

<cfelseif isdefined("Form.Baja")>
	<cfinvoke 
			component="rh.Componentes.RH_Incidencias" 
			method="Baja" 
			Iid = "#Form.Iid#"/>
	<cfset modo="ALTA">

<cfelseif isdefined("Form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
 			table="Incidencias"
 			redirect="Incidencias.cfm"
 			timestamp="#form.ts_rversion#"
			field1="Iid" 
			type1="numeric" 
			value1="#form.Iid#">
	<cfif rsDatosConcepto.RecordCount NEQ 0>
		<cfinvoke component="rh.Componentes.RH_Incidencias" method="Cambio" >
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
		</cfinvoke>
	<cfelse>
		<cfinvoke component="rh.Componentes.RH_Incidencias" method="Cambio" >
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
		</cfinvoke>
	</cfif>

<cfelseif isdefined("url.btnEliminar")>
	<cfif isdefined("url.chk") and len(trim(url.chk)) >
		<cfloop list="#url.chk#" index="i">
				<cfinvoke component="rh.Componentes.RH_Incidencias" method="Baja" Iid = "#i#"/>
		</cfloop>
	</cfif>
	<cfset modo="ALTA">
</cfif>	

<form action="Incidencias.cfm" method="get" name="sql">
	<cfif isdefined("Form.Usuario")>
		<input name="Usuario" type="hidden" value="<cfoutput>#Form.Usuario#</cfoutput>"> 
	</cfif>
	<cfif isdefined("Form.DEid")>
		<input name="DEid" type="hidden" value="<cfoutput>#Form.DEid#</cfoutput>"> 
	</cfif>	
	<cfif isdefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="Nuevo"> 
	</cfif>	
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif isdefined("Lvar_Iid")>
		<input name="Iid" type="hidden" value="<cfoutput>#Lvar_Iid#</cfoutput>">
	<cfelseif isdefined("Form.Iid")>
	   	<input name="Iid" type="hidden" value="<cfoutput>#Form.Iid#</cfoutput>">
	</cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">	
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
