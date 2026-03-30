<!---modifica para subir nuevamente y agregar en parche--->
<!--- ============================================= --->
<!--- Traducciones --->
<!--- ============================================= --->
	<!--- Empleado --->
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Simbologia"
	Default="Simbolog&iacute;a"
	returnvariable="LB_Simbologia"/>
	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Empleado"
		default="Empleado"
		xmlfile="/rh/generales.xml"
		returnvariable="vEmpleado"/>
	<!--- Concepto_Incidente --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="Concepto_Incidente"
		default="Concepto Incidente"
		xmlfile="/rh/generales.xml"
		returnvariable="vConcepto"/>		
	<!--- Fecha --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Fecha"
		default="Fecha"
		xmlfile="/rh/generales.xml"
		returnvariable="vFecha"/>		
	<!--- Boton Importar --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Importar"
		default="Importar"
		xmlfile="/rh/generales.xml"
		returnvariable="vImportar"/>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Mes"
		default="Mes"
		xmlfile="/rh/generales.xml"
		returnvariable="LB_Mes"/>
			
	<!----Boton Importar Calculo---->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_ImportarCalculo"
		default="Importar Clculo"
		returnvariable="LB_ImportarCalculo"/>			
	<!--- Boton Filtrar --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Filtrar"
		default="Filtrar"
		xmlfile="/rh/generales.xml"
		returnvariable="vFiltrar"/>		
	<!--- Cantidad/Monto --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Cantidad_Monto"
		default="Cantidad/Monto"
		returnvariable="vCantidadMonto"/>
	<!--- Cantidad horas --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Cantidad_Horas"
		default="Cantidad horas"
		returnvariable="vCantidadHoras"/>
	<!--- Cantidad dias --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Cantidad_Dias"
		default="Cantidad Dias"
		returnvariable="vCantidadDias"/>
	<!--- Monto --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Monto"
		default="Monto"
		xmlfile="/rh/generales.xml"
		returnvariable="vMonto"/>
	<!--- Valor --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Valor"
		default="Valor"
		xmlfile="/rh/generales.xml"		
		returnvariable="vValor"/>		
	<!--- Validacion Cant.digitada fuera de rango --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_La_Cantidad_digitada_se_sale_del_rango_permitido"
		default="La Cantidad digitada se sale del rango permitido"
		returnvariable="vCantidadValidacion"/>
	<!--- No puede ser cero --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="MSG_No_puede_ser_cero"
		default="No puede ser cero"
		returnvariable="vNoCero"/>		
	<!--- Icpespecial --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_CP_Especiales"
		default="CP Especiales"
		returnvariable="vIcpespecial"/>
	<!---Lista conlis--->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_ListaDeIncidencias"
		default="Lista de Incidencias"
		returnvariable="LB_ListaDeIncidencias"/>		
	<!---Etiqueta descripcion--->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Descripcion"
		default="Descripci&oacute;n"
		xmlfile="/rh/generales.xml"
		returnvariable="LB_Descripcion"/>
		
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Se_presentaron_los_siguientes_errores:\n_-_Debe seleccionar_al_menos_un_registro_para_procesar."
		default="Se presentaron los siguientes errores:\n - Debe seleccionar al menos un registro para procesar."
		returnvariable="LB_mensaje"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Estado"
		default="Estado"
		xmlfile="/rh/generales.xml"
		returnvariable="LB_estado"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Todos"
		default="Todos"
		xmlfile="/rh/generales.xml"
		returnvariable="LB_todos"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Sin_Aprobar"
		default="Sin aprobar"
		returnvariable="LB_sinaprobar"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Rechazadas"
		default="Rechazadas"
		returnvariable="LB_rechazadas"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Aprobadas"
		default="Aprobadas"
		returnvariable="LB_aprobadas"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Aprobadas_sin_NAP"
		default="Aprobadas sin NAP"
		returnvariable="LB_aprobadassinnap"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Aprobadas_con_NRP"
		default="Aprobadas con NRP"
		returnvariable="LB_aprobadasconnrp"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Desea_procesar_los_registros_seleccionados?"
		default="Desea procesar los registros seleccionados?"
		returnvariable="LB_confirm"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Tipo"
		default="Tipo"
		returnvariable="vTipo"/>		
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Centro_Funcional"
		default="Centro Funcional"
		xmlFile="/rh/generales.xml"
		returnvariable="vCentro"/>	

	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Pagadas"
		default="Aplicadas Mes (2)"
		xmlFile="/rh/generales.xml"
		returnvariable="LB_Pagadas"/>	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_PagadasNomina"
		default="Aplicadas C.P. (1)"
		xmlFile="/rh/generales.xml"
		returnvariable="LB_PagadasNomina"/>	
	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_pendientes"
		default="Pendientes Mes (3)"
		xmlFile="/rh/generales.xml"
		returnvariable="LB_pendientes"/>		
						
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Incluir_dependencias"
		default="Incluir dependencias"
		xmlFile="/rh/generales.xml"
		returnvariable="vDependencias"/>		
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Estado"
		default="Estado"
		xmlFile="/rh/generales.xml"
		returnvariable="vestado"/>	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Presupuesto"
		default="Presupuesto"
		returnvariable="vpres"/>			
<!--- ============================================= --->
<!--- ============================================= --->
<!--- por defecto se muestran los registros no aplicados, apicados sin nap y aplicados con NRP --->
<cfparam name="url.filtro_estado" default="0">

<cfif isdefined("url.CFpk") and len(trim(url.CFpk)) >
	<cfquery name="rs_centro" datasource="#session.DSN#" >
		select CFid as CFpk, CFcodigo, CFdescripcion, CFpath
		from CFuncional
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFpk#">
	</cfquery>
	<cfset vpath = rs_centro.CFpath >
</cfif>

<cfset usaPresupuesto = false >
<cfquery name="rs_pres" datasource="#session.DSN#">
	select Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo = 540
</cfquery>
<cfif trim(rs_pres.Pvalor) eq 1 >
	<cfset usaPresupuesto = true >
</cfif>

<cfset aprobarIncidencias = false >
<cfquery name="rs_aprueba" datasource="#session.DSN#">
	select Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo = 1010
</cfquery>
<cfif trim(rs_aprueba.Pvalor) eq 1 >
	<cfset aprobarIncidencias = true >
</cfif>

<cfset aprobarIncidenciasCalc = false >
<cfquery name="rs_apruebacalc" datasource="#session.DSN#">
	select Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo = 1060
</cfquery>
<cfif trim(rs_apruebacalc.Pvalor) eq 1 >
	<cfset aprobarIncidenciasCalc = true >
</cfif>

<cfset anno = DatePart("yyyy", now())>
<cfset mes  = DatePart("m", now())>

<cfquery name="rsLista" datasource="#Session.DSN#">
	select 	a.Iid, 
			<cf_dbfunction name="concat" args="b.CIcodigo,' -  ',b.CIdescripcion"> as CIdescripcion, 
			a.Ifecha, 
			case b.CItipo  	when 0 then ' Hora(s)' 
							when 1 then ' Da(s)' 
							when 2 then ' Importe' 
							when 3 then ' C&aacute;lculo' 
							end as CItipo,
			a.Ivalor,
			<cf_dbfunction name="concat" args="c.DEidentificacion, ' - ',c.DEnombre,' ',c.DEapellido1,' ',c.DEapellido2"> as NombreEmp,
			<cf_dbfunction name="concat" args="cf.CFcodigo,' -  ',cf.CFdescripcion"> as centro, cf.CFcodigo, cf.CFdescripcion,
			
			case when Iestado = 2 then '<img src=/cfmx/rh/imagenes/Borrar01_12x12.gif />' 
				 when Iestado = 1 and NAP is not null then '<img src=/cfmx/rh/imagenes/w-check.gif />' 
				 else '<img src=/cfmx/rh/imagenes/sinchequear_verde.gif />'  end as estado,
				 
			case when NRP is not null then '<img src=/cfmx/rh/imagenes/Borrar01_12x12.gif />' 
				 when NAP is not null then '<img src=/cfmx/rh/imagenes/w-check.gif />' 
				 else '<img src=/cfmx/rh/imagenes/sinchequear_verde.gif />'  end as estadoPres,
				 Iestado,
			
			coalesce((	select sum(x.ICvalor)  from HIncidenciasCalculo x  
				where x.DEid = a.DEid 
				and   x.CIid = a.CIid 
				and <cf_dbfunction name="date_part"	args="MM, x.ICfecha"> = <cf_dbfunction name="date_part"	args="MM, a.Ifecha">
				and <cf_dbfunction name="date_part"	args="YY, x.ICfecha"> = <cf_dbfunction name="date_part"	args="YY, a.Ifecha">
			),0) as cantidad
			,
			coalesce((	select sum(y.ICvalor)  from HIncidenciasCalculo y  , HRCalculoNomina w
				where y.DEid = a.DEid 
				and   y.CIid = a.CIid
				and   y.RCNid = w.RCNid
				and   y.RCNid = (select CPid from CalendarioPagos z
								 where z.CPperiodo  =  #anno#
								 and z.CPmes 		=  #mes#
								 and z.Ecodigo      =  #session.Ecodigo#
								 and z.Tcodigo      =  w.Tcodigo
								<!--- ljimenez se agrega el CPTipo para que tome en 
								cuenta la infomacion que solo corresponde el tipo de calendario reporte --->							
								 and z.CPtipo = (select cp1.CPtipo from CalendarioPagos cp1 where cp1.CPid = w.RCNid)
								 and a.Ifecha  between  z.CPdesde and z.CPhasta)
			),0) as cantidadcalendario,
			<cf_dbfunction name="date_part"	args="MM, a.Ifecha">as mes,
			coalesce((
				select sum(z.Ivalor)  from Incidencias  z
				where 	z.DEid = a.DEid 
				and   	z.CIid = a.CIid
				and 	z.NAP   is null
				and 	z.Iestado in(1,2)
				and <cf_dbfunction name="date_part"	args="MM, z.Ifecha"> = <cf_dbfunction name="date_part"	args="MM, a.Ifecha">
				and <cf_dbfunction name="date_part"	args="YY, z.Ifecha"> = <cf_dbfunction name="date_part"	args="YY, a.Ifecha">
			),0) as Pendientes
		
					
	from  Incidencias a, CIncidentes b, DatosEmpleado c, LineaTiempo lt, RHPlazas p, CFuncional cf
	
	where a.CIid = b.CIid
	  and a.DEid = c.DEid
	  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
	  and a.Ivalor != 0
	  
	  and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.Ifecha between lt.LTdesde and lt.LThasta
	  and p.RHPid=lt.RHPid
	  and cf.CFid=p.CFid
	  and lt.DEid=a.DEid
	  <!--- filtrar por centro funcional --->
		<cfif isdefined("url.CFpk") and len(trim(url.CFpk)) >
	  		and ( cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFpk#">
		    	<cfif isdefined("url.dependencias") >
			    	or cf.CFpath like '#vpath#/%' 	
		    	</cfif>
		  	)
		</cfif>		    
	  
	  <!--- filtro fecha --->
	  <cfif isdefined("url.filtro_fecha") and len(trim(url.filtro_fecha))>
		and a.Ifecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.filtro_fecha)#">
	  </cfif>
	  
	  <!--- filtro concepto --->
  	  <cfif isdefined("url.filtro_CIid") and len(trim(url.filtro_CIid))>
	  	and a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.filtro_CIid#">
	  </cfif>
	  
	  <!--- filtro empleado --->
  	  <cfif isdefined("url.DEid") and len(trim(url.DEid))>
	  	and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
	  </cfif>
	  
	  <!--- filtro centro funcional --->
	  <cfif isdefined("url.CFpk") and len(trim(url.CFpk))>
	  	and ( cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFpk#"> 
			  <cfif isdefined("url.dependencias")> or cf.CFpath like '#trim(vpath)#%' </cfif>)
	  </cfif>
	  
	  <!--- filtro de estado --->	
		<!--- si usa presupuesto  --->
		<cfif usaPresupuesto >
			<cfif isdefined("url.filtro_estado")>
				<!--- mostrar las pendientes de aprobar --->
				<cfif url.filtro_estado eq 0 >
					and a.Iestado = 0 
				<!--- mostrar aprobadas manual pero sin aprobacion presupuestaria --->
				<cfelseif url.filtro_estado eq 3 >
					and a.Iestado = 1 and NAP is null and NRP is null
				<!--- mostrar aprobadas manual con rechazo presupuestario --->
				<cfelseif url.filtro_estado eq 4 >
					and a.Iestado = 1 and NRP is not null
				<!--- mostrar rechazadas manualmente --->
				<cfelseif url.filtro_estado eq 2 >
					and a.Iestado = 2 
				<!--- por defecto muestra todo  --->
				<cfelse>
					and NAP is null
				</cfif>
			</cfif>
		<!--- filtro si no usa presupuesto --->
		<cfelse>
			<cfif isdefined("url.filtro_estado")>
				<cfif url.filtro_estado eq 0 >
					and a.Iestado = 0 
				<cfelseif url.filtro_estado eq 1 >
					and a.Iestado = 1 
				<cfelseif url.filtro_estado eq 2 >
					and a.Iestado = 2 
				</cfif>
			</cfif>
	  </cfif>		
	  
	  <!--- si empresa no requiere qu es eaprueben incidencias, esta lista no debe mostrar nada--->

	  
	order by cf.CFcodigo, a.Ifecha	  

</cfquery>	

 <cdump var="#rsLista#"> 

<cfquery name="rs_combo" datasource="#session.DSN#">
	select 	distinct b.CIid, 
		    b.CIcodigo,
			b.CIdescripcion
	from  Incidencias a, CIncidentes b
	
	where a.CIid = b.CIid
	  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
	  and ( a.Iestado = 0 
	  		or (a.Iestado = 1 and NAP is null)
			or (a.Iestado = 1 and NRP is not null ) )
	  
	order by b.CIcodigo
</cfquery>

<cfinvoke component="sif.Componentes.Translate"
 method="Translate"
 key="LB_NoSeEncontraronRegistros"
 default="No se encontraron Registros "
 returnvariable="LB_NoSeEncontraronRegistros"/> 
	
<cfset navegacion = '' >
<!--- filtro fecha --->
<cfif isdefined("url.filtro_fecha") and len(trim(url.filtro_fecha))>
	<cfset navegacion = navegacion & '&filtro_fecha=#url.filtro_fecha#' >
</cfif>

<!--- filtro concepto --->
<cfif isdefined("url.filtro_CIid") and len(trim(url.filtro_CIid))>
	<cfset navegacion = navegacion & '&filtro_CIid=#url.filtro_CIid#' >
</cfif>

<!--- filtro empleado --->
<cfif isdefined("url.DEid") and len(trim(url.DEid))>
	<cfset navegacion = navegacion & '&DEid=#url.DEid#' >
</cfif>

<!--- filtro centro funcional  --->
<cfif isdefined("url.CFpk") and len(trim(url.CFpk))>
	<cfset navegacion = navegacion & '&CFpk=#url.CFpk#' >
</cfif>
<!--- filtro centro funcional  --->
<cfif isdefined("url.dependencias") and len(trim(url.dependencias))>
	<cfset navegacion = navegacion & '&dependencias=#url.dependencias#' >
</cfif>

<!--- filtro de estado --->	
<cfif isdefined("url.filtro_estado")>
	<cfset navegacion = navegacion & '&filtro_estado=#url.filtro_estado#' >
</cfif>

<cfset valor_fecha = '' >
<cfif isdefined("url.filtro_fecha") and len(trim(url.filtro_fecha))>
	<cfset valor_fecha = url.filtro_fecha >
</cfif>

<form name="filtro" method="get" action="aprobarIncidencias.cfm">
	<cfoutput>
	<table width="100%" cellpadding="2" cellspacing="0" class="areaFiltro">
		<tr>
			<td>#vCentro#:</td>
			<td><cfif isdefined("rs_centro")><cf_rhcfuncional id="CFpk" form="filtro" query="#rs_centro#"><cfelse><cf_rhcfuncional id="CFpk" form="filtro"></cfif></td>
			<td colspan="2">
				<table><tr><td width="1%"><input type="checkbox" name="dependencias" id="dependencias" <cfif isdefined("url.dependencias")>checked</cfif> /></td><td><label for="dependencias">#vDependencias#</label></td></tr></table>
			</td>
		</tr>
		<tr>
			<td>#vFecha#:</td>
			<td><cf_sifcalendario form="filtro" name="filtro_fecha" value="#valor_fecha#"></td>
			<td>#vConcepto#:</td>
			<td>
				<select name="filtro_CIid">
					<option value="">-#LB_todos#-</option>
					<cfloop query="rs_combo">
						<option value="#rs_combo.CIid#" <cfif isdefined("url.filtro_CIid") and url.filtro_CIid eq rs_combo.CIid >selected</cfif>>#trim(rs_combo.CIcodigo)# - #rs_combo.CIdescripcion#</option>
					</cfloop>
				</select>
			
			</td>
		</tr>
		<tr>
			<td>#vEmpleado#:</td>
			<td>
			<cfif isdefined("url.DEid") and len(trim(url.DEid))>
				<cf_rhempleado form="filtro" showTipoId="false" idempleado="#url.DEid#">
			<cfelse>
				<cf_rhempleado form="filtro" showTipoId="false">
			</cfif>
			</td>
			<td>#LB_estado#:</td>
			<td>
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="1%">
							<select name="filtro_estado">
								<option value="" <cfif isdefined("url.filtro_estado") and len(trim(url.filtro_estado)) is 0 >selected</cfif>>-#LB_todos#-</option>
								<option value="0" <cfif isdefined("url.filtro_estado") and url.filtro_estado eq 0 >selected</cfif>>#LB_sinaprobar#</option>
								<cfif not usaPresupuesto >
									<option value="1" <cfif isdefined("url.filtro_estado") and url.filtro_estado eq 1 >selected</cfif>>#LB_aprobadas#</option>
								</cfif>
								<option value="2" <cfif isdefined("url.filtro_estado") and url.filtro_estado eq 2 >selected</cfif>>#LB_rechazadas#</option>
								<cfif usaPresupuesto >
									<option value="3" <cfif isdefined("url.filtro_estado") and url.filtro_estado eq 3 >selected</cfif>>#LB_aprobadassinnap#</option>
									<option value="4" <cfif isdefined("url.filtro_estado") and url.filtro_estado eq 4 >selected</cfif>>#LB_aprobadasconnrp#</option>
								</cfif>
							</select>
						</td>
						<td align="center"><input type="submit" class="btnFiltrar" name="btnFiltrar" value="Filtrar" /></td>
					</tr>
				</table>
			</td>
		</tr>		
	</table>
	</cfoutput>
</form>

<form name="form1" method="get" action="aprobarIncidencias-sql.cfm" onsubmit="javascript: return validar();">
	<table width="100%" cellpadding="1" cellspacing="0">
		<tr><td>
			<table border="0">
				<tr>
					<td width="1%" >
						<input name="chk_todos" id="chk_todos" type="checkbox" onclick="javascript:todos(this);" />
					</td>
					<td width="40%"><label for="chk_todos"><cf_translate key="LB_Seleccionar_todos_los_reguistros" xmlfile="/rh/generales.xml">Seleccionar todos los registros</cf_translate></label></td>
					<td>
						<cfoutput>
						<table cellpadding="2" bgcolor="##f5f5f5">
							<tr>
								<td valign="middle" width="1%"><img src=/cfmx/rh/imagenes/w-check.gif /></td>
								<td width="32%" valign="middle">#LB_aprobadas#</td>
								<td width="1%"><img src=/cfmx/rh/imagenes/Borrar01_12x12.gif /></td>
								<td width="32%" valign="middle">#LB_rechazadas#</td>
								<td width="1%"><img src=/cfmx/rh/imagenes/sinchequear_verde.gif /></td>
								<td width="32%" valign="middle" nowrap="nowrap">#LB_sinaprobar#</td>								
							</tr>
						</table>
						</cfoutput>
					</td>
					
				</tr>
				<tr>
					<td colspan="3">
						<cfoutput>
						<fieldset>
							<table width="100%" border="0" cellspacing="1" cellpadding="1">
								<tr >
									<td width="1%">
										(1)
									</td>
									<td>
										<cf_translate  key="LB_simbolo1">Incidencias Pagadas Agrupadas por Calendarios de Pago</cf_translate>
									</td>
									<td>
										(2)
									</td>
									<td>
										<cf_translate  key="LB_simbolo3">Incidencias Pagadas Agrupadas por mes</cf_translate>
									</td>
									<td>
										(3)
									</td>
									<td>
										<cf_translate  key="LB_simbolo4">Incidencias Pendientes de Aprobar</cf_translate>
									</td>
								</tr>
							</table>
						</fieldset>	
						</cfoutput>
					</td>					
				</tr>
				
			</table>
		</td></tr>
		<tr>
			<td>
				<cfset maxrows = 25 >
				<cfinvoke component="rh.Componentes.pListas"
				 method="pListaQuery"
				 returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsLista#"/>
					<cfif usaPresupuesto >
						<cfinvokeargument name="desplegar" value="NombreEmp,CIdescripcion,Ifecha, CItipo,Ivalor, estado,estadoPres,mes,cantidadcalendario,cantidad,Pendientes"/>
						<cfinvokeargument name="etiquetas" value="#vEmpleado#, #vConcepto#,#vFecha#, #vTipo#, #vValor#,#vestado#,#vPres#,#LB_Mes#,#LB_PagadasNomina#,#LB_Pagadas#,#LB_pendientes#"/>
						<cfinvokeargument name="formatos" value="V,V,D,V,M,V,V,S,M,M,M"/>
						<cfinvokeargument name="align" value="left,left,center,left, right,center,center,center,right,right,right"/>
					<cfelse>
						<cfinvokeargument name="desplegar" value="NombreEmp,CIdescripcion,Ifecha, CItipo,Ivalor, estado,mes,cantidadcalendario,cantidad,Pendientes"/>
						<cfinvokeargument name="etiquetas" value="#vEmpleado#, #vConcepto#,#vFecha#, #vTipo#, #vValor#,#vestado#,#LB_Mes#,#LB_PagadasNomina#,#LB_Pagadas#,#LB_pendientes#"/>
						<cfinvokeargument name="formatos" value="V,V,D,V,M,V,S,M,M,M"/>
						<cfinvokeargument name="align" value="left,left,center,left, right,center,center,right,right,right"/>
					</cfif>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="showlink" value="false"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="EmptyListMsg" value="#LB_NoSeEncontraronRegistros#"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="maxRows" value="#maxrows#"/>
					<cfinvokeargument name="checkboxes" value="S"/>
					<cfinvokeargument name="form_method" value="get"/>
					<cfinvokeargument name="formname" value="form1"/>
					<cfinvokeargument name="incluyeform" value="false"/>
					<cfinvokeargument name="keys" value="Iid"/>
					<cfinvokeargument name="cortes" value="centro"/>
				</cfinvoke>
			</td>
		</tr>	
		<!--- <tr>
			<td >
				<cfoutput>
				<fieldset>
					<table width="100%" border="0" cellspacing="1" cellpadding="1">
						<tr >
							<td width="1%">
								(1)
							</td>
							<td>
								<cf_translate  key="LB_simbolo1">Incidencias Pagadas Agrupadas por Calendarios de Pago</cf_translate>
							</td>
							<td>
								(2)
							</td>
							<td>
								<cf_translate  key="LB_simbolo3">Incidencias Pagadas Agrupadas por mes</cf_translate>
							</td>
							<td>
								(3)
							</td>
							<td>
								<cf_translate  key="LB_simbolo4">Incidencias Pendientes de Aprobar</cf_translate>
							</td>
						</tr>
					</table>
				</fieldset>	
				</cfoutput>
			</td>					
		</tr> --->
		<tr>
			<td align="center">
				<input type="submit" class="btnAplicar" name="btnAprobar" value="Aprobar" />
				<input type="submit" class="btnEliminar" name="btnRechazar" value="Rechazar" />
			</td>
		</tr>
	</table>


<!--- filtro fecha --->
<cfoutput>
<cfif isdefined("url.filtro_fecha") and len(trim(url.filtro_fecha))>
	<input type="hidden" name="filtro_fecha" value="#url.filtro_fecha#" />
</cfif>

<!--- filtro concepto --->
<cfif isdefined("url.filtro_CIid") and len(trim(url.filtro_CIid))>
	<input type="hidden" name="filtro_CIid" value="#url.filtro_CIid#" />
</cfif>

<!--- filtro empleado --->
<cfif isdefined("url.DEid") and len(trim(url.DEid))>
	<input type="hidden" name="DEid" value="#url.DEid#" />
</cfif>
<!--- filtro empleado --->
<cfif isdefined("url.CFpk") and len(trim(url.CFpk))>
	<input type="hidden" name="CFpk" value="#url.CFpk#" />
</cfif>
<!--- filtro empleado --->
<cfif isdefined("url.dependencias") and len(trim(url.dependencias))>
	<input type="hidden" name="dependencias" value="#url.dependencias#" />
</cfif>

<!--- filtro de estado --->	
<cfif isdefined("url.filtro_estado")>
	<input type="hidden" name="filtro_estado" value="#url.filtro_estado#" />
</cfif>

<input type="hidden" name="pageNum_lista" value="<cfif isdefined('url.pageNum_lista')>#url.pageNum_lista#<cfelse>1</cfif>" />


<cfset valor_fecha = '' >
<cfif isdefined("url.filtro_fecha") and len(trim(url.filtro_fecha))>
	<cfset valor_fecha = url.filtro_fecha >
</cfif>
</cfoutput>

</form>

<script language="javascript1.2" type="text/javascript">
	var cont = <cfoutput>#rsLista.recordcount#</cfoutput>;
	<cfoutput>
	if (cont > #maxrows#){
		cont = #maxrows#;
	}
	</cfoutput>
	
	function validar(){
		if ( cont > 0 ){
			if ( cont == 1 ){
				if ( document.form1.chk.checked ){
					return true;
				}
				alert('<cfoutput>#LB_mensaje#</cfoutput>');
				return confirm('<cfoutput>#LB_confirm#</cfoutput>');
			}
			else{
				for (i=0; i<cont; i++){
					if ( document.form1.chk[i] ){
						if (document.form1.chk[i].checked){
							return confirm('<cfoutput>#LB_confirm#</cfoutput>');
						}
					}
				}
				alert('<cfoutput>#LB_mensaje#</cfoutput>');
				return false;
			}
		}	

		return false;
	}

	function todos(obj){
		if (obj.checked){
			if ( cont > 0 ){
				if ( cont == 1 ){
					document.form1.chk.checked = true;
				}
				else{
					for (i=0; i<cont; i++){
						if ( document.form1.chk[i] ){
							document.form1.chk[i].checked = true;
						}	
					}
				}
			}
		}
	}
	
	function no_todos(){
		if ( cont > 0 ){
			if ( cont == 1 ){
				document.form1.chk.onclick = function(){ if(!document.form1.chk.checked){ document.form1.chk_todos.checked = false; }  };
			}
			else{
				for (i=0; i<cont; i++){
					if ( document.form1.chk[i] ){
						document.form1.chk[i].onclick = function(){ if(!this.checked){ document.form1.chk_todos.checked = false; } };
					}
				}
			}
		}
	}
	no_todos();
	
</script>