<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<!--- <cfif listLen(GvarXML_IE) neq 7>
	<cfthrow message="#GvarXML_IE#">
</cfif> --->



<cfset XMLD = xmlParse(GvarXML_IE) />
<cfset Datos = xmlSearch(XMLD,'/resultset/row')>
<cfset datosXML = xmlparse(Datos[1]) />

<cfset LvarEcodigo			= #datosXML.row.Ecodigo.xmltext#>
<cfset LvarOficodigo		= #datosXML.row.Oficodigo.xmltext#>
<cfset LvarCFcodigo			= #datosXML.row.CFcodigo.xmltext#>
<cfset LvarTipoCuenta		= #datosXML.row.TipoCuenta.xmltext#>
<cfset LvarCmayor			= #datosXML.row.Cmayor.xmltext#>
<cfset LvarListaPCDvalor	= #datosXML.row.ListaPCDvalor.xmltext#>
<cfset LvarListaPosiciones	= #datosXML.row.ListaPosiciones.xmltext#)>


<!--- Tipo de Cuenta
	GA-Cuenta de Gasto
	IT-Cuenta de Inventario
	IS-Cuenta de Inversión
	AC-Cuenta de Activos
	IN-Cuenta de Ingreso
	OI-Cuenta de Otros Ingresos
	OG-Cuenta de Otros Gastos
	OB-Cuenta de Obras
	PA-Cuenta de Ingreso por Patrimonio
--->
<cfif len(trim(LvarEcodigo)) eq 0>
	<cfthrow message="El Ecodigo es requerido y no has sido pasado. Proceso cancelado!!!">
</cfif>
<cfset validar = false>
<cfif (len(trim(LvarCmayor)) or len(trim(LvarListaPCCcodigo)) or len(trim(LvarListaPCDvalor))) and LvarCmayor neq '-1'>
	<cfset validar = true>
</cfif>
<!--- Tipo de Cuenta --->
<cfif len(trim(LvarTipoCuenta)) eq 0 and LvarTipoCuenta neq -1>
	<cfthrow message="Tipo de cuenta requerido, el valor no ha sido pasado.">
</cfif>
<cfif not listfind('GA,IT,IS,AC,IN,OI,OG,OB,PA,-1',trim(LvarTipoCuenta))>
	<cfthrow message="Tipo de cuenta indefinido, valores permetido son: GA:Cuenta de Gasto, IT:Cuenta de Inventario, IS:Cuenta de Inversión, AC:Cuenta de Activos, IN:Cuenta de Ingreso, OI:Cuenta de Otros Ingresos, OG:Cuenta de Otros Gastos, OB:Cuenta de Obras, PA:Cuenta de Ingreso por Patrimonio, -1: NO FILTRAR">
</cfif>
<cfswitch expression="#LvarTipoCuenta#">
	<cfcase value="GA">
		<cfset lvarCuentas = "CFcuentac">
	</cfcase>
	<cfcase value="IT">
		<cfset lvarCuentas = "CFcuentainventario">
	</cfcase>
	<cfcase value="IS">
		<cfset lvarCuentas = "CFcuentainversion">
	</cfcase>
	<cfcase value="AC">
		<cfset lvarCuentas = "CFcuentaaf">
	</cfcase>
	<cfcase value="IN">
		<cfset lvarCuentas = "CFcuentaingreso">
	</cfcase>
	<cfcase value="OI">
		<cfset lvarCuentas = "CFcuentaingresoretaf">
	</cfcase>
	<cfcase value="OG">
		<cfset lvarCuentas = "CFcuentagastoretaf">
	</cfcase>
	<cfcase value="OB">
		<cfset lvarCuentas = "CFcuentaobras">
	</cfcase>
	<cfcase value="PA">
		<cfset lvarCuentas = "CFcuentaPatri">
	</cfcase>
	<cfcase value="-1">
		<cfset lvarCuentas = "CFcuentac, CFcuentainventario, CFcuentainversion, CFcuentaaf, CFcuentaingreso, CFcuentaingresoretaf, CFcuentagastoretaf, CFcuentaobras, CFcuentaPatri">
	</cfcase>
</cfswitch>
<cfset lvarCuentasQuery = "">
<cfif validar>
	<!---  Cuenta Mayor--->
	<cfif len(trim(LvarTipoCuenta)) eq 0 or LvarTipoCuenta eq -1>
		<cfthrow message="Tipo de cuenta requerido, el valor no ha sido pasado.">
	</cfif>
	<cfif len(trim(LvarCmayor)) eq 0 and LvarCmayor neq '-1'>
		<cfthrow message="Cuenta mayor requerido, el valor no ha sido pasado.">
	</cfif>
	<cfset hoy = DatePart("yyyy", now()) * 100 + DatePart("m", now()) >
	<cfquery name="rsCMayor" datasource="#session.dsn#">
		select c.Ecodigo, c.Cmayor, c.CEcodigo, c.PCEMid, m.PCEMformato, v.CPVformatoF
		from CtasMayor c
			left outer join PCEMascaras m
				on m.PCEMid = c.PCEMid
			left outer join CPVigencia v
				on v.Ecodigo= c.Ecodigo and v.Cmayor = c.Cmayor 
				  and  #hoy# >= CPVdesdeAnoMes and #hoy# <= CPVhastaAnoMes
		where c.Ecodigo = #LvarEcodigo#
		  and c.Cmayor = '#LvarCmayor#'
	</cfquery>
	<cfif rsCMayor.recordcount eq 0>
		<cfthrow message="La cuenta mayor no existe, el proceso no puede continuar. Proceso Cancelado!!!">
	</cfif>
	<cfif len(trim(rsCMayor.PCEMformato)) eq 0 and len(trim(rsCMayor.CPVformatoF)) eq 0>
		<cfthrow message="La cuenta no posee un formato definido. Proceso Cancelado!!!">
	</cfif>
	<cfif len(trim(LvarListaPosiciones)) eq 0>
		<cfthrow message="Lista de Posiciones requerido, no ha sido pasado(s).">
	</cfif>
	<cfif len(trim(LvarListaPCDvalor)) eq 0>
		<cfthrow message="Lista de valores al Catálogos en el Plan de Cuentas requerido, el valor o valores no ha sido pasado(s).">
	</cfif>
	<cfif not (listlen(LvarListaPosiciones,'|') eq listlen(LvarListaPCDvalor,'|'))>
		<cfthrow message="La cantidad de valores al catálogo al plan de compras es diferente al las posiciones . Cantidad de valores: #listlen(LvarListaPCDvalor,'|')# - Cantidad de posiciones: #listlen(LvarListaPosiciones,'|')#">
	</cfif>
	<cfset lvarLenPos = listlen(LvarListaPosiciones,'|')>
	<cfset struct = StructNew()>
	<cfif len(trim(rsCMayor.PCEMid))>
		<cfloop from="1" to="#lvarLenPos#" index="indice">
			<cfset pos = listgetat(LvarListaPosiciones,indice,'|')>
			<cfquery name="rsNiveles" datasource="#session.dsn#">
				select (select sum(PCNlongitud) 
						from PCNivelMascara 
						where PCEMid = #rsCMayor.PCEMid# and PCNid < #pos#) + #pos+5# as PosIni
					,PCNlongitud 
				from PCNivelMascara
				where PCEMid = #rsCMayor.PCEMid# and PCNid = #pos#
			</cfquery>
			<cfset StructInsert(struct, indice, '#rsNiveles.PosIni#|#rsNiveles.PCNlongitud#|#listgetat(LvarListaPCDvalor,indice,'|')#')>
		</cfloop>
	<cfelseif len(trim(rsCMayor.CPVformatoF))>
		<cfset posIni = 0>
		<cfset lvarLenFormato = listlen(rsCMayor.CPVformatoF,'-')>
		<cfset structPosFormato = StructNew()>
		<cfloop from="2" to="#lvarLenFormato#" index="indice">
			<cfset posIni = posIni + len(listgetat(rsCMayor.CPVformatoF,indice - 1,'-'))>
			<cfset StructInsert(structPosFormato, indice - 1, "#posIni + indice#|#len(listgetat(rsCMayor.CPVformatoF,indice,'-'))#")>
		</cfloop>
		<cfloop from="1" to="#lvarLenPos#" index="indice">
			<cfset pos = listgetat(LvarListaPosiciones,indice,'|')>
			<cfif not StructKeyExists(structPosFormato, '#pos#')>
				<cfthrow message="La posición #pos# no existe la cuenta #LvarCmayor#. Proceso Cancelado!!!">
			</cfif>
			<cfset listFormato = StructFind(structPosFormato,'#pos#')>
			<cfset StructInsert(struct, indice, "#listgetat(listFormato,1,'|')#|#listgetat(listFormato,2,'|')#|#listgetat(LvarListaPCDvalor,indice,'|')#")>
		</cfloop>
	</cfif>
	<cfloop list="#lvarCuentas#" index="cta">
		<cfloop from="1" to="#lvarLenPos#" index="indice">
			<cfset structVal = StructFind(struct,'#indice#')>
			<cf_dbfunction name="sPart" args="#cta#,#listgetat(structVal,1,'|')#,#listgetat(structVal,2,'|')#" returnvariable="lvarSPcuenta">
			<cf_dbfunction name="sPart" args="#cta#,1,4" returnvariable="lvarCtaM">
			<cfset lvarCuentasQuery = lvarCuentasQuery & " and #lvarCtaM# = '#LvarCmayor#' and #lvarSPcuenta# = '#listgetat(structVal,3,'|')#'">
		</cfloop>
	</cfloop>
</cfif>
<cfquery name="rsCFuncional" datasource="#session.dsn#">
	select CFid, CFcodigo, CFdescripcion, CFuresponsable, cf.Ocodigo, #preservesinglequotes(lvarCuentas)#
	from CFuncional cf
		inner join Oficinas o
			on o.Ocodigo = cf.Ocodigo and o.Ecodigo = cf.Ecodigo
	where cf.Ecodigo = #LvarEcodigo#	
	<cfif len(trim(LvarCFcodigo)) and LvarCFcodigo neq -1>	
		and CFcodigo = '#LvarCFcodigo#'
	</cfif>
	<cfif len(trim(LvarOficodigo)) and LvarOficodigo neq -1>	
		and o.Oficodigo = '#LvarOficodigo#'
	</cfif>
	<cfif len(trim(lvarCuentasQuery))>	
		#preservesinglequotes(lvarCuentasQuery)#
	</cfif>
</cfquery>
<cfif rsCFuncional.recordcount EQ 0>
	<cfthrow message="Código del Centro Funcional o Código de la Oficina erroneo: CFcodigo = #LvarCFcodigo#, Oficodigo = #LvarOficodigo#">
</cfif>
<cfset LvarIrresponsable = -1>
<cfset LvarTabla = "<recordset>">
	<cfloop query="rsCFuncional">
		<!---1.	Invocación para obtener el DEid, del responsable del Centro Funcional--->
		<cfinvoke component="rh.Componentes.RH_Funciones" 
			method="DeterminaDEidResponsableCF"
			cfid = "#rsCFuncional.CFid#"
			fecha = "#now()#"
			returnvariable="ResponsableCF"> 
    	</cfinvoke>
		<cfif not len(trim(ResponsableCF))>
			<cfset ResponsableCF = -1>
		</cfif>
		<cfquery name="rsDatosEmpleado" datasource="#session.dsn#">
			select DEid, DEnombre, DEapellido1, DEapellido2 
			from DatosEmpleado
			where Ecodigo = #LvarEcodigo#
			  and Usucodigo = #ResponsableCF#
		</cfquery>
		<cfset lvarDEid = -1>
		<cfif len(trim(rsDatosEmpleado.DEid))>
			<cfset lvarDEid = rsDatosEmpleado.DEid1>
		</cfif>
		<cfquery name="rsLineaTiempo" datasource="#session.dsn#">
			select LTdesde, LThasta
			from LineaTiempo
			where Ecodigo= #LvarEcodigo#
			  and DEid = #lvarDEid#
			  and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">  between LTdesde and LThasta
		</cfquery>
		<cfset LvarTabla = LvarTabla & " 
		<row>
			<Empresa>#LvarEcodigo#</Empresa>
			<Ocodigo>#rsCFuncional.Ocodigo#</Ocodigo>
			<CFcodigo>#rsCFuncional.CFcodigo#</CFcodigo>
			<CFdescripcion>#rsCFuncional.CFdescripcion#</CFdescripcion>
			<LTdesde>#rsLineaTiempo.LTdesde#</LTdesde>
			<LThasta>#rsLineaTiempo.LThasta#</LThasta>
			<CFuresponsable>#rsCFuncional.CFuresponsable#</CFuresponsable>
			<DEid>#rsDatosEmpleado.DEid#</DEid>
			<DEnombre>#rsDatosEmpleado.DEnombre#</DEnombre>
			<DEapellido1>#rsDatosEmpleado.DEapellido1#</DEapellido1>
			<DEapellido2>#rsDatosEmpleado.DEapellido2#</DEapellido2>">
		<cfloop list="#lvarCuentas#" index="cta">
			<cfset LvarTabla = LvarTabla & "<#trim(cta)#>#evaluate('rsCFuncional.' & trim(cta))#</#trim(cta)#>"> 
		</cfloop>
		<cfset LvarTabla = LvarTabla & " </row>">
	</cfloop>
<cfset LvarTabla &= "<recordset>">
<cfset GvarXML_OE = LvarTabla>

